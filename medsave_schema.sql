-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: medsave
-- ------------------------------------------------------
-- Server version	9.7.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'a09d1354-89b8-11f1-a31a-d4939040d727:1-47';

--
-- Table structure for table `dim_brand_map`
--

DROP TABLE IF EXISTS `dim_brand_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_brand_map` (
  `brand_map_id` int unsigned NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_id` int unsigned NOT NULL,
  PRIMARY KEY (`brand_map_id`),
  UNIQUE KEY `uq_brand_name` (`brand_name`),
  KEY `fk_map_product` (`product_id`),
  CONSTRAINT `fk_map_product` FOREIGN KEY (`product_id`) REFERENCES `dim_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dim_brand_map`
--

LOCK TABLES `dim_brand_map` WRITE;
/*!40000 ALTER TABLE `dim_brand_map` DISABLE KEYS */;
INSERT INTO `dim_brand_map` VALUES (1,'Atorva 10',1),(2,'Storvas 10',1);
/*!40000 ALTER TABLE `dim_brand_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dim_person`
--

DROP TABLE IF EXISTS `dim_person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_person` (
  `person_id` int unsigned NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `relation` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dim_person`
--

LOCK TABLES `dim_person` WRITE;
/*!40000 ALTER TABLE `dim_person` DISABLE KEYS */;
INSERT INTO `dim_person` VALUES (1,'Parent','mother');
/*!40000 ALTER TABLE `dim_person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dim_product`
--

DROP TABLE IF EXISTS `dim_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_product` (
  `product_id` int unsigned NOT NULL AUTO_INCREMENT,
  `drug_code` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `generic_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `strength` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pack_size` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mrp_inr` decimal(10,2) NOT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `uq_product` (`generic_name`,`strength`,`pack_size`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dim_product`
--

LOCK TABLES `dim_product` WRITE;
/*!40000 ALTER TABLE `dim_product` DISABLE KEYS */;
INSERT INTO `dim_product` VALUES (1,'TEST1','Atorvastatin','10 mg','10s',15.00,1);
/*!40000 ALTER TABLE `dim_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_household_fill`
--

DROP TABLE IF EXISTS `fact_household_fill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_household_fill` (
  `fill_id` int unsigned NOT NULL AUTO_INCREMENT,
  `person_ID` int unsigned NOT NULL,
  `product_id` int unsigned DEFAULT NULL,
  `brand_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pack_qty` int unsigned NOT NULL DEFAULT '1',
  `branded_price` decimal(10,2) NOT NULL,
  `fill_date` date NOT NULL,
  PRIMARY KEY (`fill_id`),
  KEY `fk_fill_person` (`person_ID`),
  KEY `fk_fill_product` (`product_id`),
  CONSTRAINT `fk_fill_person` FOREIGN KEY (`person_ID`) REFERENCES `dim_person` (`person_id`),
  CONSTRAINT `fk_fill_product` FOREIGN KEY (`product_id`) REFERENCES `dim_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_household_fill`
--

LOCK TABLES `fact_household_fill` WRITE;
/*!40000 ALTER TABLE `fact_household_fill` DISABLE KEYS */;
INSERT INTO `fact_household_fill` VALUES (1,1,1,'Atorva 10',1,95.00,'2026-08-01'),(2,1,1,'Atorva 10',1,95.00,'2026-09-01'),(3,1,NULL,'Atorva 10',1,95.00,'2026-10-01'),(5,1,1,'Atorva 10',1,95.00,'2026-11-01'),(7,1,1,'Atorva 10',1,95.00,'2026-12-01');
/*!40000 ALTER TABLE `fact_household_fill` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-16 18:13:39
