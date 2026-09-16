# Medsave

Medsave is a healthcare data management and analytics project built using a MySQL database, FastAPI backend, and Power BI dashboard.

## Overview

The project brings together:

- **MySQL** for storing and managing the project data
- **FastAPI** for providing a Python-based REST API
- **Power BI** for data analysis and dashboard visualization

## Project Structure

```text
Medsave/
├── api/
│   ├── main.py
│   └── requirements.txt
├── database/
│   └── medsave_schema.sql
├── powerbi/
│   └── Medsave.pbix
└── README.md
```

## Technologies

- Python
- FastAPI
- MySQL
- Power BI
- REST API
- Git & GitHub

## FastAPI Backend

The API source code is located in the `api` directory.

### Setup

Clone the repository and open the API directory:

```bash
cd api
```

Create a virtual environment:

```bash
python -m venv venv
```

Activate it on Windows:

```bash
venv\Scripts\activate
```

Install the required packages:

```bash
pip install -r requirements.txt
```

Start the FastAPI application:

```bash
uvicorn main:app --reload
```

The API will normally be available at:

```text
http://127.0.0.1:8000
```

Interactive API documentation is available at:

```text
http://127.0.0.1:8000/docs
```

## Database

The MySQL database schema and sample data are provided in:

```text
database/medsave_schema.sql
```

Import the SQL file into MySQL to recreate the database used by the project.

## Power BI Dashboard

The Power BI dashboard is provided in:

```text
powerbi/Medsave.pbix
```

Open the file with **Microsoft Power BI Desktop**.

Configure the MySQL connection as required and refresh the data before using the dashboard.

## Security

Do not commit passwords, API keys, database credentials, or other secrets to GitHub.

Use a local `.env` file for sensitive configuration and keep `.env` excluded through `.gitignore`.

## Author

**Sadaat Badar**

Computer Science Engineering Graduate
