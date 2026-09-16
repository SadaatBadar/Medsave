import os
from urllib.parse import quote_plus
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from fastapi import FastAPI
from pydantic import BaseModel
from datetime import date

class FillInput(BaseModel):
    person_id: int
    brand_name: str
    pack_qty: int = 1
    branded_price: float
    fill_date: date

class BrandMapInput(BaseModel):
    brand_name: str
    product_id: int

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

DATABASE_URL = f"mysql+pymysql://{DB_USER}:{quote_plus(DB_PASSWORD)}@{DB_HOST}/{DB_NAME}"

engine = create_engine(DATABASE_URL)

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "MedSave API is alive"}

@app.get("/savings")
def get_savings(person_id: int | None = None):
    base_query = """
        SELECT
            f.person_id,
            f.brand_name,
            d.generic_name,
            d.mrp_inr,
            f.branded_price,
            (f.branded_price - d.mrp_inr) AS estimated_savings_inr
        FROM fact_household_fill AS f
        JOIN dim_brand_map AS m
            ON f.brand_name = m.brand_name
        JOIN dim_product AS d
            ON m.product_id = d.product_id
    """

    params = {}
    if person_id is not None:
        base_query += " WHERE f.person_id = :person_id"
        params["person_id"] = person_id

    query = text(base_query)

    with engine.connect() as connection:
        result = connection.execute(query, params)
        rows = [dict(row._mapping) for row in result]
        return rows

@app.get("/test-db")
def test_db():
    with engine.connect() as connection:
        result = connection.execute(text("SELECT 1"))
        return {"result": result.fetchone()[0]}

@app.post("/fills")
def create_fill(fill: FillInput):
    with engine.connect() as connection:
        # Step 1: check if this exact fill already exists
        duplicate_check = text("""
            SELECT fill_id
            FROM fact_household_fill
            WHERE person_id = :person_id
              AND brand_name = :brand_name
              AND fill_date = :fill_date
        """)
        existing = connection.execute(
            duplicate_check,
            {
                "person_id": fill.person_id,
                "brand_name": fill.brand_name,
                "fill_date": fill.fill_date,
            }
        ).fetchone()

        if existing is not None:
            return {
                "status": "skipped",
                "reason": "A fill for this person, brand, and date already exists.",
                "existing_fill_id": existing.fill_id,
            }

        # Step 2: look up product_id from the brand map, if it exists
        lookup_query = text("""
            SELECT product_id
            FROM dim_brand_map
            WHERE brand_name = :brand_name
        """)
        lookup_result = connection.execute(
            lookup_query, {"brand_name": fill.brand_name}
        ).fetchone()

        product_id = lookup_result.product_id if lookup_result else None

        # Step 3: insert the fill
        insert_query = text("""
            INSERT INTO fact_household_fill
                (person_id, product_id, brand_name, pack_qty, branded_price, fill_date)
            VALUES
                (:person_id, :product_id, :brand_name, :pack_qty, :branded_price, :fill_date)
        """)

        params = {
            "person_id": fill.person_id,
            "product_id": product_id,
            "brand_name": fill.brand_name,
            "pack_qty": fill.pack_qty,
            "branded_price": fill.branded_price,
            "fill_date": fill.fill_date,
        }

        connection.execute(insert_query, params)
        connection.commit()

    return {"status": "created", "fill": params, "matched_product": product_id is not None}
@app.get("/savings/summary")
def get_savings_summary():
    query = text("""
        SELECT
            DATE_FORMAT(f.fill_date, '%Y-%m') AS month,
            SUM(f.branded_price) AS total_branded,
            SUM(d.mrp_inr) AS total_mrp,
            SUM(f.branded_price - d.mrp_inr) AS total_savings
        FROM fact_household_fill AS f
        JOIN dim_brand_map AS m
            ON f.brand_name = m.brand_name
        JOIN dim_product AS d
            ON m.product_id = d.product_id
        GROUP BY DATE_FORMAT(f.fill_date, '%Y-%m')
        ORDER BY month
    """)

    with engine.connect() as connection:
        result = connection.execute(query)
        rows = [dict(row._mapping) for row in result]
        return rows
from sqlalchemy.exc import IntegrityError

@app.post("/brand-map")
def create_brand_map(mapping: BrandMapInput):
    insert_query = text("""
        INSERT INTO dim_brand_map (brand_name, product_id)
        VALUES (:brand_name, :product_id)
    """)

    with engine.connect() as connection:
        try:
            connection.execute(
                insert_query,
                {"brand_name": mapping.brand_name, "product_id": mapping.product_id}
            )
            connection.commit()
        except IntegrityError as e:
            connection.rollback()
            return {
                "status": "failed",
                "reason": "This brand name is already mapped, or the product_id doesn't exist.",
            }

    return {"status": "created", "mapping": mapping}