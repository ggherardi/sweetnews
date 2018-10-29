CREATE DATABASE  IF NOT EXISTS `sweetnews` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `sweetnews`;
-- MySQL dump 10.13  Distrib 5.5.61, for Win64 (AMD64)
--
-- Host: localhost    Database: sweetnews
-- ------------------------------------------------------
-- Server version	5.5.61

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary table structure for view `abstract_ricette`
--

DROP TABLE IF EXISTS `abstract_ricette`;
/*!50001 DROP VIEW IF EXISTS `abstract_ricette`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `abstract_ricette` (
  `id_ricetta` tinyint NOT NULL,
  `titolo_ricetta` tinyint NOT NULL,
  `difficolta` tinyint NOT NULL,
  `tempo_cottura` tinyint NOT NULL,
  `calorie_totali` tinyint NOT NULL,
  `preparazione` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome_tipologia` tinyint NOT NULL,
  `codice_stato_approvativo` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `anteprime_ricetta`
--

DROP TABLE IF EXISTS `anteprime_ricetta`;
/*!50001 DROP VIEW IF EXISTS `anteprime_ricetta`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anteprime_ricetta` (
  `id_ricetta` tinyint NOT NULL,
  `titolo_ricetta` tinyint NOT NULL,
  `difficolta` tinyint NOT NULL,
  `tempo_cottura` tinyint NOT NULL,
  `calorie_totali` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome_tipologia` tinyint NOT NULL,
  `data_flusso` tinyint NOT NULL,
  `nome_stato_approvativo` tinyint NOT NULL,
  `codice_stato_approvativo` tinyint NOT NULL,
  `id_stato_approvativo` tinyint NOT NULL,
  `id_stato_approvativo_valutazione` tinyint NOT NULL,
  `id_stato_approvativo_approvazione` tinyint NOT NULL,
  `id_stato_approvativo_rifiuto` tinyint NOT NULL,
  `id_utente_creatore` tinyint NOT NULL,
  `username_utente_creatore` tinyint NOT NULL,
  `id_utente_approvatore` tinyint NOT NULL,
  `username_utente_approvatore` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `delega`
--

DROP TABLE IF EXISTS `delega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delega` (
  `id_tipo_delega` int(11) NOT NULL,
  `id_utente` int(11) NOT NULL,
  PRIMARY KEY (`id_tipo_delega`,`id_utente`),
  KEY `fk_delega_utente_idx` (`id_utente`),
  CONSTRAINT `fk_delega_tipo_delega` FOREIGN KEY (`id_tipo_delega`) REFERENCES `tipo_delega` (`id_tipo_delega`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_delega_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delega`
--

LOCK TABLES `delega` WRITE;
/*!40000 ALTER TABLE `delega` DISABLE KEYS */;
INSERT INTO `delega` VALUES (1,1),(2,1),(3,1),(1,8),(1,66),(1,69),(2,85),(1,86),(2,87),(3,88);
/*!40000 ALTER TABLE `delega` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `deleghe_utente`
--

DROP TABLE IF EXISTS `deleghe_utente`;
/*!50001 DROP VIEW IF EXISTS `deleghe_utente`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `deleghe_utente` (
  `id_utente` tinyint NOT NULL,
  `delega_codice` tinyint NOT NULL,
  `delega_nome` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `dettagli_utente`
--

DROP TABLE IF EXISTS `dettagli_utente`;
/*!50001 DROP VIEW IF EXISTS `dettagli_utente`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `dettagli_utente` (
  `id_utente` tinyint NOT NULL,
  `username` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `cognome` tinyint NOT NULL,
  `id_dettaglio_utente_interno` tinyint NOT NULL,
  `id_dettaglio_utente_esterno` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `telefono_abitazione` tinyint NOT NULL,
  `telefono_cellulare` tinyint NOT NULL,
  `email` tinyint NOT NULL,
  `data_nascita` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `dettaglio_utente_esterno`
--

DROP TABLE IF EXISTS `dettaglio_utente_esterno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dettaglio_utente_esterno` (
  `id_dettaglio_utente_esterno` int(11) NOT NULL AUTO_INCREMENT,
  `id_utente` int(11) NOT NULL,
  `indirizzo` varchar(45) DEFAULT NULL,
  `telefono_abitazione` varchar(45) DEFAULT NULL,
  `telefono_cellulare` varchar(45) DEFAULT NULL,
  `email` varchar(45) NOT NULL,
  `data_nascita` date DEFAULT NULL,
  `liberatoria` blob,
  PRIMARY KEY (`id_dettaglio_utente_esterno`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `fk_dettaglio_utente_esterno_utente_idx` (`id_utente`),
  CONSTRAINT `fk_dettaglio_utente_esterno_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dettaglio_utente_esterno`
--

LOCK TABLES `dettaglio_utente_esterno` WRITE;
/*!40000 ALTER TABLE `dettaglio_utente_esterno` DISABLE KEYS */;
INSERT INTO `dettaglio_utente_esterno` VALUES (2,8,'Montione, Via Sergente Maggiore 25','0360 3499391','3495121835',' mariorossi@armyspy.com','1977-12-10',NULL),(3,1,'Roma, Largo Giuseppe Veratti 37','06216581563 ','345641236','admin@admin.com','1986-10-04',NULL),(5,66,'Roma, Via dei Gracchi 37','068463123','3158633125','luigiverdi@spyarmi.com','1988-01-29',NULL),(8,69,'','','3205467','ClaraBruno@rhyta.com','1958-07-25',NULL),(9,86,'Lotta, Piazza Bovio 9','','340123512','OttoneGenovese@rhyta.com','1961-01-04','DEFAULT');
/*!40000 ALTER TABLE `dettaglio_utente_esterno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dettaglio_utente_interno`
--

DROP TABLE IF EXISTS `dettaglio_utente_interno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dettaglio_utente_interno` (
  `id_dettaglio_utente_interno` int(11) NOT NULL AUTO_INCREMENT,
  `id_utente` int(11) NOT NULL,
  PRIMARY KEY (`id_dettaglio_utente_interno`),
  KEY `fk_dettaglio_utente_interno_utente_idx` (`id_utente`),
  CONSTRAINT `fk_dettaglio_utente_interno_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dettaglio_utente_interno`
--

LOCK TABLES `dettaglio_utente_interno` WRITE;
/*!40000 ALTER TABLE `dettaglio_utente_interno` DISABLE KEYS */;
INSERT INTO `dettaglio_utente_interno` VALUES (1,1),(12,85),(13,87),(14,88);
/*!40000 ALTER TABLE `dettaglio_utente_interno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flusso_approvativo`
--

DROP TABLE IF EXISTS `flusso_approvativo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flusso_approvativo` (
  `id_flusso_approvativo` int(11) NOT NULL AUTO_INCREMENT,
  `id_utente_creatore` int(11) NOT NULL,
  `id_utente_approvatore` int(11) DEFAULT NULL,
  `id_stato_approvativo` int(11) NOT NULL,
  `id_ricetta` int(11) NOT NULL,
  `data_flusso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_flusso_approvativo`),
  KEY `fk_flusso_approvativo_utente_idx` (`id_utente_creatore`),
  KEY `fk_flusso_approvativo_stato_approvativo_idx` (`id_stato_approvativo`),
  KEY `fk_flusso_approvativo_ricetta_idx` (`id_ricetta`),
  KEY `fk_flusso_approvativo_utente_approvatore_idx` (`id_utente_approvatore`),
  CONSTRAINT `fk_flusso_approvativo_utente_creatore` FOREIGN KEY (`id_utente_creatore`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flusso_approvativo_utente_approvatore` FOREIGN KEY (`id_utente_approvatore`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flusso_approvativo_ricetta` FOREIGN KEY (`id_ricetta`) REFERENCES `ricetta` (`id_ricetta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flusso_approvativo_stato_approvativo` FOREIGN KEY (`id_stato_approvativo`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flusso_approvativo`
--

LOCK TABLES `flusso_approvativo` WRITE;
/*!40000 ALTER TABLE `flusso_approvativo` DISABLE KEYS */;
INSERT INTO `flusso_approvativo` VALUES (18,1,NULL,7,20,'2018-10-28 12:45:27'),(22,1,NULL,1,24,'2018-10-18 10:02:44'),(23,8,1,3,25,'2018-10-21 16:24:12'),(24,8,NULL,1,26,'2018-10-21 17:41:37'),(25,8,NULL,8,27,'2018-10-28 12:45:42'),(26,66,NULL,8,28,'2018-10-28 12:45:45'),(27,66,NULL,8,29,'2018-10-28 12:45:38'),(28,69,NULL,8,30,'2018-10-25 16:39:21'),(29,69,NULL,8,31,'2018-10-28 12:45:43'),(30,69,NULL,1,32,'2018-10-21 19:33:51'),(31,69,NULL,4,33,'2018-10-28 11:47:36'),(32,69,1,3,34,'2018-10-28 11:47:39'),(33,69,NULL,8,35,'2018-10-28 12:45:47'),(34,66,NULL,1,36,'2018-10-28 11:04:13'),(35,66,85,3,37,'2018-10-28 11:47:56'),(36,66,NULL,4,38,'2018-10-28 11:48:02'),(37,66,NULL,7,39,'2018-10-28 12:45:48'),(38,66,85,3,40,'2018-10-28 11:48:08'),(39,8,NULL,8,41,'2018-10-28 12:45:40'),(40,8,NULL,8,42,'2018-10-28 12:45:51'),(41,8,NULL,4,43,'2018-10-28 12:07:53'),(42,1,NULL,8,44,'2018-10-28 12:45:22'),(43,1,NULL,7,45,'2018-10-28 12:45:20'),(44,1,NULL,8,46,'2018-10-28 12:45:25'),(45,1,87,3,47,'2018-10-28 12:07:33'),(46,86,NULL,4,48,'2018-10-28 12:09:37'),(47,86,NULL,2,49,'2018-10-28 11:37:20'),(48,86,NULL,2,50,'2018-10-28 11:38:34'),(49,86,NULL,2,51,'2018-10-28 11:40:46'),(50,86,NULL,8,52,'2018-10-28 12:45:50'),(51,86,NULL,2,53,'2018-10-28 11:45:56'),(52,86,NULL,2,54,'2018-10-28 11:46:49');
/*!40000 ALTER TABLE `flusso_approvativo` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sweetnews`.`flusso_approvativo_AFTER_INSERT` AFTER INSERT ON `flusso_approvativo` FOR EACH ROW
BEGIN
	INSERT INTO `sweetnews`.`flusso_approvativo_audit`
    (id_flusso_approvativo, id_stato_approvativo, id_ricetta, id_utente_creatore, id_utente_approvatore, data_flusso)
    VALUES
    (NEW.id_flusso_approvativo, NEW.id_stato_approvativo, NEW.id_ricetta, NEW.id_utente_creatore, NEW.id_utente_approvatore, NEW.data_flusso);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sweetnews`.`flusso_approvativo_AFTER_UPDATE` AFTER UPDATE ON `flusso_approvativo` FOR EACH ROW
BEGIN
	INSERT INTO `sweetnews`.`flusso_approvativo_audit`
    (id_flusso_approvativo, id_stato_approvativo, id_ricetta, id_utente_creatore, id_utente_approvatore, data_flusso)
    VALUES
    (NEW.id_flusso_approvativo, NEW.id_stato_approvativo, NEW.id_ricetta, NEW.id_utente_creatore, NEW.id_utente_approvatore, NEW.data_flusso);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `flusso_approvativo_audit`
--

DROP TABLE IF EXISTS `flusso_approvativo_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flusso_approvativo_audit` (
  `id_flusso_approvativo_audit` int(11) NOT NULL AUTO_INCREMENT,
  `id_flusso_approvativo` int(11) NOT NULL,
  `id_stato_approvativo` int(11) NOT NULL,
  `id_ricetta` int(11) NOT NULL,
  `id_utente_creatore` int(11) NOT NULL,
  `id_utente_approvatore` int(11) DEFAULT NULL,
  `data_flusso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_flusso_approvativo_audit`),
  KEY `fk_flusso_approvativo_audit_flusso_approvativo_idx` (`id_flusso_approvativo`),
  CONSTRAINT `fk_flusso_approvativo_audit_flusso_approvativo` FOREIGN KEY (`id_flusso_approvativo`) REFERENCES `flusso_approvativo` (`id_flusso_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flusso_approvativo_audit`
--

LOCK TABLES `flusso_approvativo_audit` WRITE;
/*!40000 ALTER TABLE `flusso_approvativo_audit` DISABLE KEYS */;
INSERT INTO `flusso_approvativo_audit` VALUES (3,18,1,20,1,0,'2018-10-17 21:18:26'),(7,22,1,24,1,0,'2018-10-18 10:02:44'),(15,18,2,20,1,NULL,'2018-10-17 21:18:26'),(16,23,1,25,8,NULL,'2018-10-21 16:24:12'),(17,24,1,26,8,NULL,'2018-10-21 17:41:37'),(18,23,2,25,8,NULL,'2018-10-21 16:24:12'),(19,25,1,27,8,NULL,'2018-10-21 19:17:43'),(23,27,2,29,66,NULL,'2018-10-21 19:23:47'),(28,30,1,32,69,NULL,'2018-10-21 19:33:51'),(40,23,3,25,8,NULL,'2018-10-21 16:24:12'),(41,23,3,25,8,1,'2018-10-21 16:24:12'),(56,26,3,28,66,85,'2018-10-24 22:25:09'),(66,28,3,30,69,85,'2018-10-24 23:14:00'),(67,28,5,30,69,NULL,'2018-10-24 23:14:05'),(68,28,6,30,69,1,'2018-10-25 16:39:14'),(69,28,8,30,69,NULL,'2018-10-25 16:39:21'),(70,26,5,28,66,NULL,'2018-10-27 15:24:34'),(71,26,5,28,66,NULL,'2018-09-27 15:24:34'),(72,31,1,33,69,NULL,'2018-10-28 10:53:41'),(73,32,1,34,69,NULL,'2018-10-28 10:59:49'),(74,33,1,35,69,NULL,'2018-10-28 11:01:28'),(75,33,2,35,69,NULL,'2018-10-28 11:01:28'),(76,32,2,34,69,NULL,'2018-10-28 10:59:49'),(77,31,2,33,69,NULL,'2018-10-28 10:53:41'),(78,34,1,36,66,NULL,'2018-10-28 11:04:13'),(79,35,1,37,66,NULL,'2018-10-28 11:08:50'),(80,35,2,37,66,NULL,'2018-10-28 11:08:50'),(81,36,1,38,66,NULL,'2018-10-28 11:10:51'),(82,36,2,38,66,NULL,'2018-10-28 11:10:51'),(83,37,1,39,66,NULL,'2018-10-28 11:14:51'),(84,37,2,39,66,NULL,'2018-10-28 11:14:51'),(85,38,1,40,66,NULL,'2018-10-28 11:18:33'),(86,38,2,40,66,NULL,'2018-10-28 11:18:33'),(87,25,2,27,8,NULL,'2018-10-21 19:17:43'),(88,39,1,41,8,NULL,'2018-10-28 11:21:24'),(89,39,2,41,8,NULL,'2018-10-28 11:21:24'),(90,40,1,42,8,NULL,'2018-10-28 11:24:32'),(91,40,2,42,8,NULL,'2018-10-28 11:24:32'),(92,41,1,43,8,NULL,'2018-10-28 11:25:36'),(93,41,2,43,8,NULL,'2018-10-28 11:25:36'),(94,42,1,44,1,NULL,'2018-10-28 11:26:51'),(95,42,2,44,1,NULL,'2018-10-28 11:26:51'),(96,43,1,45,1,NULL,'2018-10-28 11:28:12'),(97,43,2,45,1,NULL,'2018-10-28 11:28:12'),(98,44,1,46,1,NULL,'2018-10-28 11:30:07'),(99,44,2,46,1,NULL,'2018-10-28 11:30:07'),(100,45,1,47,1,NULL,'2018-10-28 11:33:10'),(101,45,2,47,1,NULL,'2018-10-28 11:33:10'),(102,46,1,48,86,NULL,'2018-10-28 11:36:04'),(103,46,2,48,86,NULL,'2018-10-28 11:36:04'),(104,47,1,49,86,NULL,'2018-10-28 11:37:20'),(105,47,2,49,86,NULL,'2018-10-28 11:37:20'),(106,48,1,50,86,NULL,'2018-10-28 11:38:34'),(107,48,2,50,86,NULL,'2018-10-28 11:38:34'),(108,49,1,51,86,NULL,'2018-10-28 11:40:46'),(109,49,2,51,86,NULL,'2018-10-28 11:40:46'),(110,50,1,52,86,NULL,'2018-10-28 11:43:25'),(111,50,2,52,86,NULL,'2018-10-28 11:43:25'),(112,51,1,53,86,NULL,'2018-10-28 11:45:56'),(113,51,2,53,86,NULL,'2018-10-28 11:45:56'),(114,52,1,54,86,NULL,'2018-10-28 11:46:49'),(115,52,2,54,86,NULL,'2018-10-28 11:46:49'),(116,25,3,27,8,1,'2018-10-28 11:47:23'),(117,25,5,27,8,NULL,'2018-10-28 11:47:27'),(118,27,3,29,66,1,'2018-10-28 11:47:30'),(119,27,5,29,66,NULL,'2018-10-28 11:47:31'),(120,29,3,31,69,1,'2018-10-28 11:47:33'),(121,29,5,31,69,NULL,'2018-10-28 11:47:33'),(122,31,3,33,69,1,'2018-10-28 11:47:36'),(123,31,4,33,69,NULL,'2018-10-28 11:47:36'),(124,32,3,34,69,1,'2018-10-28 11:47:39'),(125,18,3,20,1,85,'2018-10-28 11:47:50'),(126,18,5,20,1,NULL,'2018-10-28 11:47:51'),(127,33,3,35,69,85,'2018-10-28 11:47:53'),(128,33,5,35,69,NULL,'2018-10-28 11:47:54'),(129,35,3,37,66,85,'2018-10-28 11:47:56'),(130,36,3,38,66,85,'2018-10-28 11:48:00'),(131,36,4,38,66,NULL,'2018-10-28 11:48:02'),(132,37,3,39,66,85,'2018-10-28 11:48:05'),(133,37,5,39,66,NULL,'2018-10-28 11:48:05'),(134,38,3,40,66,85,'2018-10-28 11:48:08'),(135,42,3,44,1,87,'2018-10-28 11:51:35'),(136,42,5,44,1,NULL,'2018-10-28 11:51:37'),(137,39,3,41,8,87,'2018-10-28 11:52:56'),(138,40,3,42,8,87,'2018-10-28 11:53:15'),(139,41,3,43,8,87,'2018-10-28 11:53:27'),(140,43,3,45,1,87,'2018-10-28 11:53:39'),(141,39,5,41,8,NULL,'2018-10-28 11:53:53'),(142,40,5,42,8,NULL,'2018-10-28 11:56:27'),(143,44,3,46,1,87,'2018-10-28 12:07:14'),(144,44,5,46,1,NULL,'2018-10-28 12:07:18'),(145,45,3,47,1,87,'2018-10-28 12:07:33'),(146,41,4,43,8,NULL,'2018-10-28 12:07:53'),(147,46,3,48,86,87,'2018-10-28 12:09:08'),(148,43,5,45,1,NULL,'2018-10-28 12:09:11'),(149,50,3,52,86,87,'2018-10-28 12:09:30'),(150,50,5,52,86,NULL,'2018-10-28 12:09:33'),(151,46,4,48,86,NULL,'2018-10-28 12:09:37'),(152,18,5,20,1,NULL,'2018-09-25 10:47:51'),(153,25,5,27,8,NULL,'2018-08-23 10:47:27'),(154,26,5,28,66,NULL,'2018-08-27 15:24:34'),(155,27,5,29,66,NULL,'2018-09-15 10:47:31'),(156,29,5,31,69,NULL,'2018-06-08 10:47:33'),(157,33,5,35,69,NULL,'2018-09-25 10:47:54'),(158,37,5,39,66,NULL,'2018-09-07 10:48:05'),(159,39,5,41,8,NULL,'2018-09-08 10:53:53'),(160,40,5,42,8,NULL,'2018-09-05 10:56:27'),(161,42,5,44,1,NULL,'2018-09-10 10:51:37'),(162,43,5,45,1,NULL,'2018-09-04 11:09:11'),(163,44,5,46,1,NULL,'2018-09-26 11:07:18'),(164,50,5,52,86,NULL,'2018-09-27 11:09:33'),(165,25,6,27,8,1,'2018-10-28 12:14:03'),(166,26,6,28,66,1,'2018-10-28 12:16:59'),(167,27,6,29,66,1,'2018-10-28 12:17:31'),(168,37,6,39,66,1,'2018-10-28 12:40:56'),(169,29,6,31,69,1,'2018-10-28 12:41:01'),(170,39,6,41,8,1,'2018-10-28 12:41:04'),(171,50,6,52,86,1,'2018-10-28 12:43:00'),(172,33,6,35,69,1,'2018-10-28 12:43:03'),(173,40,6,42,8,1,'2018-10-28 12:43:06'),(174,42,6,44,1,88,'2018-10-28 12:43:28'),(175,43,6,45,1,88,'2018-10-28 12:43:29'),(176,18,6,20,1,88,'2018-10-28 12:43:30'),(177,44,6,46,1,88,'2018-10-28 12:43:32'),(178,18,6,20,1,88,'2018-09-25 11:43:30'),(179,25,6,27,8,1,'2018-09-25 11:43:30'),(180,26,6,28,66,1,'2018-09-25 11:43:30'),(181,27,6,29,66,1,'2018-09-25 11:43:30'),(182,29,6,31,69,1,'2018-09-25 11:43:30'),(183,33,6,35,69,1,'2018-09-25 11:43:30'),(184,37,6,39,66,1,'2018-09-25 11:43:30'),(185,39,6,41,8,1,'2018-09-25 11:43:30'),(186,40,6,42,8,1,'2018-09-25 11:43:30'),(187,42,6,44,1,88,'2018-09-25 11:43:30'),(188,43,6,45,1,88,'2018-09-25 11:43:30'),(189,44,6,46,1,88,'2018-09-25 11:43:30'),(190,50,6,52,86,1,'2018-09-25 11:43:30'),(191,43,7,45,1,NULL,'2018-10-28 12:45:20'),(192,42,8,44,1,NULL,'2018-10-28 12:45:22'),(193,44,8,46,1,NULL,'2018-10-28 12:45:25'),(194,18,7,20,1,NULL,'2018-10-28 12:45:27'),(195,27,8,29,66,NULL,'2018-10-28 12:45:38'),(196,39,8,41,8,NULL,'2018-10-28 12:45:40'),(197,25,8,27,8,NULL,'2018-10-28 12:45:42'),(198,29,8,31,69,NULL,'2018-10-28 12:45:43'),(199,26,8,28,66,NULL,'2018-10-28 12:45:45'),(200,33,8,35,69,NULL,'2018-10-28 12:45:47'),(201,37,7,39,66,NULL,'2018-10-28 12:45:48'),(202,50,8,52,86,NULL,'2018-10-28 12:45:50'),(203,40,8,42,8,NULL,'2018-10-28 12:45:51');
/*!40000 ALTER TABLE `flusso_approvativo_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingrediente`
--

DROP TABLE IF EXISTS `ingrediente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ingrediente` (
  `id_ingrediente` int(11) NOT NULL AUTO_INCREMENT,
  `nome_ingrediente` varchar(45) NOT NULL,
  `calorie` float NOT NULL,
  PRIMARY KEY (`id_ingrediente`)
) ENGINE=InnoDB AUTO_INCREMENT=402 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingrediente`
--

LOCK TABLES `ingrediente` WRITE;
/*!40000 ALTER TABLE `ingrediente` DISABLE KEYS */;
INSERT INTO `ingrediente` VALUES (223,'Banana',0.89),(224,'Melograno',0.83),(225,'Zenzero',0.8),(226,'Fichi',0.74),(227,'Uva',0.69),(228,'Ciliegie',0.63),(229,'Kiwi',0.61),(230,'Mango',0.6),(231,'Pera',0.58),(232,'Mirtilli',0.57),(233,'Mandarini',0.53),(234,'Mela',0.52),(235,'Lamponi',0.52),(236,'Ananas',0.5),(237,'Albicocche',0.48),(238,'Arance',0.47),(239,'Prugne',0.46),(240,'More',0.43),(241,'Pompelmo',0.42),(242,'Pesca',0.39),(243,'Melone',0.34),(244,'Fragole',0.32),(245,'Anguria',0.3),(246,'Limone',0.29),(247,'Melone giallo',0.28),(248,'Macadamia',7.18),(249,'Pinoli',6.73),(250,'Nocciole',6.28),(251,'Pistacchi',6.01),(252,'Anacardi',5.98),(253,'Noci',5.82),(254,'Arachidi',5.71),(255,'Sesamo',5.73),(256,'Mandorle dolci',5.42),(257,'Castagne',1.89),(258,'Cocco',6.04),(259,'Uva',2.83),(260,'Banana',2.7),(261,'Datteri',2.53),(262,'Fichi',2.42),(263,'Prugne',2.4),(264,'Albicocche',1.88),(265,'Lupini secchi',3.71),(266,'Ceci secchi',3.64),(267,'Lenticchie secche',3.53),(268,'Fagioli secchi',2.91),(269,'Avocado',1.6),(270,'Aglio',1.49),(271,'Soia',1.22),(272,'Fave',0.88),(273,'Mais crudo',0.86),(274,'Patata dolce',0.86),(275,'Fagioli borlotti in scatola',0.83),(276,'Piselli',0.81),(277,'Patate',0.77),(278,'Porro',0.61),(279,'Carciofo',0.47),(280,'Barbabietola',0.43),(281,'Carote',0.41),(282,'Cipolla',0.4),(283,'Broccoli',0.34),(284,'Finocchio',0.31),(285,'Fagiolini',0.31),(286,'Rape',0.28),(287,'Zucca',0.26),(288,'Cavolfiore',0.25),(289,'Rucola',0.25),(290,'Melanzana',0.24),(291,'Peperoni',0.24),(292,'Spinaci',0.23),(293,'Funghi',0.22),(294,'Zucchina',0.21),(295,'Pomodori',0.2),(296,'Asparago',0.2),(297,'Lattuga',0.17),(298,'Ravanelli',0.16),(299,'Cetriolo',0.16),(300,'Lardo',9.02),(301,'Salame',3.92),(302,'Salsiccia',3.39),(303,'Costina di maiale',2.77),(304,'Wurstel',2.3),(305,'Prosciutto cotto',2.15),(306,'Manzo macinato',2.12),(307,'Prosciutto crudo',1.95),(308,'Tacchino',1.6),(309,'Prosciutto crudo magro',1.47),(310,'Vitello',1.44),(311,'Manzo magro',1.4),(312,'Coniglio',1.36),(313,'Anatra',1.36),(314,'Coscia di pollo',1.3),(315,'Cervo',1.2),(316,'Maiale filetto',1.1),(317,'Agnello',1.09),(318,'Petto di tacchino',1.11),(319,'Petto di pollo',1),(320,'Salmone',1.79),(321,'Sgombro',1.63),(322,'Trota',1.48),(323,'Trota salmonata',1.41),(324,'Salmone affumicato',1.17),(325,'Orata',1.05),(326,'Gamberi',1.05),(327,'Tonno',1.03),(328,'Branzino',0.97),(329,'Cozze',0.86),(330,'Vongole',0.86),(331,'Polpo',0.82),(332,'Seppie',0.79),(333,'Gamberetti',0.71),(334,'Olio Extravergine',8.84),(335,'Burro',7.17),(336,'Olio di semi',8.84),(337,'Grana',3.92),(338,'Seitain',3.7),(339,'Emmental',3.57),(340,'Mozzarella',2.54),(341,'Tempeh',1.93),(342,'Hamburger di soia',1.54),(343,'Tofu',1.45),(344,'Uova',1.43),(345,'Ricotta',1.38),(346,'Yogurt alla frutta',1.09),(347,'Yogurt greco',0.96),(348,'Fiocchi di latte',0.87),(349,'Latte intero',0.61),(350,'Yogurt greco 0%',0.57),(351,'Latte di soia',0.54),(352,'Yogurt di soia',0.5),(353,'Latte di avena',0.44),(354,'Yogurt magro',0.41),(355,'Latte parzialmente Scremato',0.4),(356,'Latte scremato',0.34),(357,'Avena',3.89),(358,'Miglio',3.78),(359,'Pasta di semola',3.71),(360,'Amaranto',3.71),(361,'Farina di mais',3.65),(362,'Quinoa',3.64),(363,'Frumento tipo 0',3.61),(364,'Riso',3.58),(365,'Orzo',3.54),(366,'Grano saraceno',3.43),(367,'Segale',3.38),(368,'Farro',3.35),(369,'Gocciole',4.77),(370,'Oro Saiwa',4.25),(371,'Brioches',3.9),(372,'Pizza',3.01),(373,'Patatine fritte',2.99),(374,'Pane tipo 0',2.71),(375,'Big Mac',2.32),(376,'Coca Cola',0.42),(377,'Limoncello',3.43),(378,'Whisky',2.5),(379,'Vodka',2.31),(380,'Vino rosso',0.84),(381,'Vino bianco',0.82),(382,'Birra rossa',0.63),(383,'Spritz',0.5),(384,'Birra',0.43),(387,'Pasta all uovo',4.1),(388,'Sale',0),(389,'Pepe',0),(390,'Farina 00',3),(391,'Cioccolato fondente',5.46),(392,'Zucchero',3.92),(393,'Panna',3.36),(394,'Guanciale',6.55),(395,'Pancetta',4.58),(396,'Pecorino',3.32),(397,'Peperoncino',0.4),(398,'Nutella',5.3),(399,'Sedano',0.16),(400,'Cioccolato bianco',5.39),(401,'Crema spalmabile alle nocciole',5.37);
/*!40000 ALTER TABLE `ingrediente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lista_ingredienti`
--

DROP TABLE IF EXISTS `lista_ingredienti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lista_ingredienti` (
  `id_ingrediente` int(11) NOT NULL,
  `id_ricetta` int(11) NOT NULL,
  `quantita` float NOT NULL,
  PRIMARY KEY (`id_ingrediente`,`id_ricetta`),
  KEY `fk_lista_ingredienti_ingrediente_idx` (`id_ingrediente`),
  KEY `fk_lista_ingredienti_ricetta_idx` (`id_ricetta`),
  CONSTRAINT `fk_lista_ingredienti_ingrediente` FOREIGN KEY (`id_ingrediente`) REFERENCES `ingrediente` (`id_ingrediente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_lista_ingredienti_ricetta` FOREIGN KEY (`id_ricetta`) REFERENCES `ricetta` (`id_ricetta`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_ingredienti`
--

LOCK TABLES `lista_ingredienti` WRITE;
/*!40000 ALTER TABLE `lista_ingredienti` DISABLE KEYS */;
INSERT INTO `lista_ingredienti` VALUES (234,33,700),(234,46,750),(234,49,1000),(237,53,400),(246,49,400),(249,46,25),(250,52,300),(253,36,1),(270,20,0.5),(270,32,0.1),(270,42,0.2),(270,43,0.4),(274,47,75),(275,42,200),(277,24,400),(277,27,500),(277,32,400),(277,36,200),(277,41,1000),(277,43,1000),(277,50,1000),(277,51,750),(281,42,30),(281,51,150),(282,20,50),(282,24,100),(282,26,100),(282,36,80),(282,42,30),(282,51,100),(287,26,600),(287,28,600),(287,36,1000),(287,45,500),(293,25,230),(293,31,500),(294,24,200),(295,20,100),(295,40,400),(295,42,250),(295,51,20),(300,42,80),(300,51,130),(301,27,50),(305,27,50),(305,29,100),(307,42,80),(310,31,400),(325,32,900),(334,26,20),(334,29,5),(334,36,60),(334,40,10),(334,42,10),(334,43,30),(334,45,10),(334,51,20),(335,26,50),(335,31,50),(335,33,100),(335,34,25),(335,35,100),(335,37,20),(335,44,100),(335,46,50),(335,50,30),(335,53,250),(336,46,10),(337,20,0.2),(337,26,80),(337,27,10),(337,45,100),(337,50,30),(337,51,50),(344,24,200),(344,27,100),(344,28,150),(344,33,100),(344,34,100),(344,35,220),(344,37,300),(344,38,400),(344,39,400),(344,41,100),(344,44,400),(344,45,100),(344,46,100),(344,47,500),(344,48,400),(344,53,110),(347,30,250),(349,33,100),(349,37,500),(349,39,400),(349,50,200),(359,20,250),(359,29,320),(359,38,500),(359,51,320),(359,54,320),(364,26,320),(374,45,100),(381,40,50),(388,20,0.1),(388,24,0.1),(388,25,20),(388,29,0.2),(388,31,0.2),(388,32,0.1),(388,36,0.1),(388,38,0.1),(388,40,0.1),(388,41,0.1),(388,43,0.1),(388,45,0.2),(388,50,0.2),(388,54,0.2),(389,20,0.1),(389,24,0.1),(389,25,20),(389,31,0.2),(389,32,0.1),(389,36,0.1),(389,38,0.1),(389,40,0.1),(389,45,0.2),(390,25,150),(390,28,50),(390,31,40),(390,33,200),(390,34,125),(390,37,250),(390,41,300),(390,44,50),(390,46,130),(390,47,75),(390,48,80),(390,53,500),(391,35,200),(391,44,200),(391,52,300),(392,30,100),(392,33,200),(392,34,15),(392,39,140),(392,44,150),(392,46,60),(392,47,150),(392,48,115),(392,49,600),(392,53,200),(393,29,300),(393,30,250),(393,39,100),(394,38,150),(394,40,150),(394,54,250),(396,38,50),(396,40,75),(396,54,60),(397,40,10),(398,48,350),(399,51,150),(400,52,500),(401,52,400);
/*!40000 ALTER TABLE `lista_ingredienti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lista_ricerche`
--

DROP TABLE IF EXISTS `lista_ricerche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lista_ricerche` (
  `id_utente` int(11) NOT NULL,
  `id_ricetta` int(11) NOT NULL,
  PRIMARY KEY (`id_utente`,`id_ricetta`),
  KEY `fk_lista_ricerche_ricetta_idx` (`id_ricetta`),
  CONSTRAINT `fk_lista_ricerche_ricetta` FOREIGN KEY (`id_ricetta`) REFERENCES `ricetta` (`id_ricetta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_lista_ricerche_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_ricerche`
--

LOCK TABLES `lista_ricerche` WRITE;
/*!40000 ALTER TABLE `lista_ricerche` DISABLE KEYS */;
/*!40000 ALTER TABLE `lista_ricerche` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ricetta`
--

DROP TABLE IF EXISTS `ricetta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ricetta` (
  `id_ricetta` int(11) NOT NULL AUTO_INCREMENT,
  `id_utente` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `titolo_ricetta` varchar(45) NOT NULL,
  `difficolta` int(11) NOT NULL,
  `tempo_cottura` int(11) NOT NULL,
  `preparazione` varchar(2000) NOT NULL,
  `porzioni` int(11) NOT NULL,
  `calorie_totali` float NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `messaggio` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id_ricetta`),
  KEY `fk_ricetta_utente_idx` (`id_utente`),
  KEY `fk_ricetta_tipologia_idx` (`id_tipologia`),
  CONSTRAINT `fk_ricetta_tipologia` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologia` (`id_tipologia`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ricetta_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ricetta`
--

LOCK TABLES `ricetta` WRITE;
/*!40000 ALTER TABLE `ricetta` DISABLE KEYS */;
INSERT INTO `ricetta` VALUES (20,1,2,'Pasta al sugo',1,35,'Tagliare tutto, mettere a soffriggere, buttare acqua, far saltare in padella e condire bene bene!',2,969,'Nessuna nota','Aggiungere pasta all\'uovo'),(24,1,3,'Frittata',2,50,'Mettere a soffriggere cipolla, zucchine e patate. Sbattere in una ciotola le uova. Dopo aver lasciato appassire le verdure, versare le uova nella padella. Lasciare cuocere per 30 minuti a fuoco basso rigirando a metà cottura.',4,676,'',''),(25,8,3,'Funghi fritti',1,20,'Se a sentir parlare di funghi fritti vi viene subito alla mente la celeberrima scena dei “funghi fritti fritti fritti” descritti da Roberto Benigni in veste di cameriere nel film “La vita è bella”, questa ricetta vi farà senz’altro ricredere! I funghi fritti sono un piatto tanto semplice quanto appetitoso, perfetto da servire accompagnato da salsine come sfizioso antipasto oppure come sostanzioso contorno a un buon piatto di carne, in alternativa ai tradizionali funghi trifolati. Noi abbiamo scelto di utilizzare tre qualità diverse di funghi, ovvero porcini, pleurotus e champignon, e il risultato è stato pienamente all’altezza delle nostre aspettative: dorati, saporiti e gustosamente croccanti! Con poco tempo e poco sforzo, potrete preparare anche voi un classico autunnale dal tocco rustico con cui deliziare i vostri amici… basterà prestare attenzione alla temperatura dell’olio e assorbire quello in eccesso per ottenere dei funghi fritti asciutti e fragranti: siamo certi che in questo caso saranno i più richiesti del menù!',4,500.6,'Sono molto buoni!',''),(26,8,1,'Risotto alla zucca',2,60,'Il risotto alla zucca è una vera e propria istituzione della cucina italiana: una primo piatto che racchiude tutto il calore delle cotture lente, dei sapori genuini, del buon profumo che sa di casa. Una pietanza di origini contadine, come molti tra i migliori piatti della nostra tradizione: solo intuizione, pratica e fantasia hanno saputo trasformare la zucca e il riso in un piatto oggi celebrato dai gastronomi e amato dagli intenditori. Cosa c’è di così speciale in un risotto alla zucca, cosa lo rende irresistibile? La sua semplicità, ci verrebbe da rispondere; una semplicità che racchiude saggezza, cura, gesti immutabili, necessari, privi di frivolezze pompose: la tostatura del riso, che ne impermeabilizza i chicchi e regala loro una straordinaria tenuta di cottura. La cottura seguita passo passo, un mestolo di brodo per volta, perché un riso lesso è diverso da un risotto. La mantecatura, quel momento in cui l’amido trasforma i rimasugli di brodo in una cremina che poi il burro rende lucida e fondente. Tanti piccoli gesti d’altri tempi, che rendono questo piatto una delizia capace di conquistare tanto i palati più raffinati quanto gli amanti dei sapori semplici e genuini. Un piatto perfetto per tutte le occasioni, dalla cena per due a serate tra amici, anche nella festa principe della zucca: Halloween! Seguite il nostro passo-passo: anche per voi il risotto alla zucca non avrà più segreti!',4,2190.5,'',''),(27,8,3,'Gateau di patate',2,100,'Il gateau di patate è una deliziosa preparazione a base di patate e salumi vari. Un pasticcio da sfornare con un’irresistibile crosticina dorata che vi assicurerà un pasto succulento. Questa famosa e antica preparazione è un caposaldo della cucina partenopea e rivisitato poi in altre regioni del sud Italia. Tuttavia il gateau di patate, italianizzato in gattò o gatò, fece la sua comparsa sulle lussuose tavole del Regno delle due Sicilie soltanto alla fine del 1700. Infatti il palato sopraffino della regina Maria Carolina d’Asburgo, moglie di Ferdinando I di Borbone, non volle separarsi dai manicaretti dei monsieurs - i cuochi francesi - richiamati alla corte del Regno di Napoli. Fu così che il popolo napoletano apprese la tecnica e la rese propria. Sostituì la groviera con il fior di latte, e poi impreziosì il pasticcio con prosciutto cotto e salame. E non solo. Anche il nome presto passò da gateau di patate in gattò… e persino i monsieurs non scamparono alla fantasia partenopea, diventando perciò i “monzù”! Ogni famiglia tramanda la propria versione di questo irresistibile pasticcio, e così anche noi abbiamo deciso di condividere con voi la ricetta del gateau di patate realizzata dallo Chef Roberto Di Pinto!',6,870.7,'',''),(28,66,4,'Torta zucca e cioccolato',3,90,'L’arrivo dell’autunno con la sua deliziosa aria frizzantina accende il desiderio di coccolarsi con una calda e aromatica tazza di tè accompagnata da qualche golosità come la nostra torta zucca e cioccolato. Questo dolce dai colori aranciati con una setosa decorazione di ganache al cioccolato è la compagna perfetta per i pomeriggi ottobrini, ma potrebbe diventare anche una golosa torta a tema per coronare il vostro menù di Halloween! Ricca e sostanziosa, la torta zucca e cioccolato porta con sé profumi e aromi avvolgenti che spazzeranno via con un morso la nostalgia dell’estate con i suoi gelati. Chiamate a raccolta i vostri amici più cari e concedetevi un irresistibile peccato di gola!',8,520.5,'','Aggiungere l\'ingrediente farina di nocciole e lo zucchero!'),(29,66,2,'Penne al baffo',1,20,'Siete alla ricerca di un primo piatto veramente appetitoso e goloso pronto in soli 20 minuti? Eccolo servito! Le penne al baffo sono la ricetta perfetta da preparare per un pranzo in famiglia, quando si ha poco tempo per cucinare ma tanta voglia di qualcosa di sfizioso... e, perché no, anche quando stanno per arrivare i vostri amici affamati! Pochi e semplici passaggi garantiranno un risultato strepitoso... le penne assorbiranno questa crema vellutata, a base di panna e pomodoro, per rilasciarla ad ogni assaggio! Noi abbiamo scelto di arricchire la crema con del prosciutto cotto, ma le varianti sono tantissime: è possibile utilizzare lo speck o optare per una versione completamente diversa utilizzando cubetti di pesce o calamari! Noi vi consigliamo di provarle tutte e scegliere quella che fa per voi! ',4,2454.4,'',''),(30,69,4,'Delizie foresta nera',4,60,'Tra le tante prelibatezze della costiera amalfitana ecco una ricetta golosa creata dal pasticcere campano Carmine Marzuillo nel 1978: le delizie ovvero soffici cupole morbide come il pan di spagna che racchiudono un cremoso ripieno e hanno una ricopertura golosa. \nLa ricetta originale è quella delle delizie al limone ma noi vogliamo proporvi una variante altrettanto gustosa e raffinata che si ispira alla tradizionale torta omonima: le delizie foresta nera, farcite con una crema di yogurt arricchita con succulenti amarene sciroppate. \nLe delizie foresta nera sono un dessert al quale è difficile resistere e per realizzarle vi basterà seguire la nostra ricetta!',5,1472,'Difficilissima!!!',''),(31,69,3,'Scaloppine ai funghi',2,30,'Le scaloppine sono un secondo piatto semplice da realizzare ed estremamente gustoso! In questa ricetta vi proponiamo una variante delle classiche scaloppine al limone: le scaloppine ai funghi! Un appetitoso e saporito secondo piatto a base di carne, completo di contorno con i profumi del sottobosco... un classico che vi permette di dare un tocco raffinato ai vostri menu in modo semplice ma soprattutto in poco tempo. Per questa ricetta abbiamo scelto funghi polposi e molto versatili: i funghi Champignon crema, un perfetto accompagnamento per le fettine di vitello che, come vuole la ricetta tradizionale, vengono sapientemente dorate in padella per creare quella appetitosa crosticina dorata che rende questo piatto irresistibile. Le scaloppine con i funghi saranno la carta vincente dei vostri menu più sfiziosi, e non dimenticate di stappare un buon vino!',4,1164.5,'','Mancano alcuni ingredienti!'),(32,69,3,'Orata al forno',3,55,'Ogni volta che vi trovate davanti al banco del pesce ve ne andate sconsolati perché non sapete mai come cucinarlo? Dovete organizzare una cenetta intima e scartate a priori i piatti di pesce per paura delle temutissime lische? Niente paura: pulire e cuocere il pesce è più facile di quanto pensiate! Se poi il pesce è una saporitissima orata farete un figurone con i vostri ospiti. Magari potete cominciare con un piatto di pasta. Scegliendo per esempio l\'armonia tra mare e monti grazie al condimento di pesto di pistacchi, gamberi e pomodori che abbiamo fatto per la pasta senza glutine! L’orata al forno è un secondo piatto di pesce semplice da preparare, per gustare tutto il buono del pesce esaltato dal profumo di limone e delle erbe aromatiche che lo impreziosiscono in cottura. Accompagnata con gustose patate, l’orata al forno è ideale per una cena o un pranzo importanti, dove il gusto si sposa con la leggerezza. Cosa state aspettando? Mettete da parte i dubbi: una volta portata in tavola non potrete che ricevere i complimenti dei vostri commensali!',2,1253.15,'Nessuna',''),(33,69,4,'Torta di mele',2,80,'Le mele da sempre sono protagoniste indiscusse dei dolci casalinghi, come la nostra torta di mele, golosa, soffice e aromatica, è il miglior comfort food che si possa desiderare! Del resto, chi l’ha provata sa bene quanto sia rassicurante una torta di mele fatta in casa, con la sua semplice dolcezza, la sua morbida consistenza e il suo inconfondibile profumo. Intramontabili sapori che rievocano ricordi di famiglia, ciascuna con la propria ricetta da custodire gelosamente come il più prezioso dei tesori. Nel tempo abbiamo poi accolto delle varianti che permettessero a tutti di gustare un dolce casalingo come questo e così buono, attraverso la torta di mele senza glutine: un\'irrinunciabile versione perfetta per tutti! Qui vi riveliamo la nostra versione della torta di mele, perfetta per concedersi una coccola golosa insieme ai propri cari!',8,2669,'Se non gradite la cannella potete aromatizzare il dolce con i semi di un baccello di vaniglia. Per rendere più ricca la torta di mele potete aggiungere all\'impasto dei pinoli o dell\'uvetta.',''),(34,69,4,'Pancakes allo sciroppo d\'acero',1,35,'\nSe state progettando un viaggio negli Stati Uniti, preparatevi a degustare la tradizionale american breakfast con i deliziosi pancakes, piccoli dischi spugnosi e saporiti che non aspettano altro che essere farciti con le leccornie più invitanti: la tradizione li vuole conditi con il tipico sciroppo d’acero, un dolcificante naturale con un gusto che ricorda quello del miele. Ma accanto a questo tipico abbinamento sono ammesse tutte le varianti possibili, a patto che siano super golose: dalla frutta fresca o sciroppata, alle creme fino alle salse al cioccolato. Gli americani non si fanno mancare proprio nulla e spesso accompagnano il piatto di pancakes con ciuffi di panna montata, come si fa a resistere? Senza contare che in uno dei classici bar farete davvero difficoltà a scegliere tra le varie torte e gli innumerevoli tipi di muffin, compresi quelli senza glutine. Di sicuro avrete già l’acquolina in bocca, se non volete aspettare la colazione potete preparare i pancakes anche per merenda, ecco la nostra ricetta!',4,756.05,'',''),(35,69,4,'Tiramisù',2,40,'Anticamente le nonne usavano preparare una colazione che oggi potremmo definire povera, ma che all’epoca era davvero ricchissima! Ancora oggi la ricetta è immutata, basta rompere in un bicchiere un uovo freschissimo e sbatterlo con dello zucchero e a piacere aggiungere caffè o latte caldo, per i più piccoli, e marsala o anice per i più grandicelli. Ed è proprio da questa portentosa crema che nasce la crema al mascarpone base del tiramisù. Il dolce italiano per eccellenza, quello più famoso e amato, ma soprattutto che ha dato vita a tantissime altre versioni! Le più apprezzate? Sicuramente il tiramisù alle fragole o quello alla Nutella, giusto per citarne qualcuno! \nSebbene le origini di questo famoso dessert non siano chiare, perché contese tra le regioni del Veneto, Friuli Venezia Giulia, Piemonte e Toscana, resta comunque un caposaldo della cucina italiana preparato indistintamente da Nord a Sud. \nPurtroppo non abbiamo scoperto chi l’ha inventato ma sicuramente sappiamo come farvi preparare uno dei più buoni tiramisù che abbiate mai preparato. Perciò ecco la ricetta: preparatelo anche voi e fateci sapere!',8,2123.6,'',''),(36,66,2,'Crema di zucca',2,35,'La zucca è la regina indiscussa dell’autunno… il colore della sua polpa carnosa ricorda quello delle foglie che, proprio in questo periodo, si staccano dolcemente dagli alberi e si posano lievi sul terreno. Inconfondibile e conosciuta da tutti per la sua dolcezza è utilizzata in moltissime ricette che fanno parte della tradizione culinaria italiana, come la zucca al forno o il risotto alla zucca. Abbiamo scelto di esaltarne tutti i sapori, aggiungendo solo alcune spezie e trasformandola in un delizioso comfort food: la crema di zucca. Calda e speziata, è una preparazione molto versatile, ideale da servire da sola come zuppa e perfetta come condimento per arricchire moltissimi altri piatti: il successo è sempre garantito! Potete anche creare delle originali varianti per il vostro menu di Halloween! Tra i piatti speciali più rincuoranti, la crema di zucca è proprio il lato bello dell\'autunno!',4,982.22,'Trasformate questa crema di zucca in un primo piatto delicato aggiungendo del riso o dell\'orzo, precedentemente sbollentati! ',''),(37,66,4,'Crepes dolci e salate',1,25,'Che si tratti di un’amorevole mamma che prepara la merenda per i suoi bambini, di un gruppetto di studenti che fa una pausa tra storia e algebra, o di fanatici della cucina espressa ma pur sempre originale, le crepes sono sempre la scelta giusta! Si tratta di un impasto di base che si presta bene per farciture sia dolci che salate. \nQualche esempio? Sicuramente la più amata di tutte, la crepe alla Nutella! Per quelle salate non abbiamo dubbi a consigliarvi delle golose crespelle gorgonzola e radicchio! Oppure, se preferite un\'alternativa più rustica, potete provare le nostre crepes integrali. Ci sono soltanto poche cose da sapere per riuscire a preparare le crepes dolci e salate, ve le raccontiamo subito. Siamo certi che ne farete una bella scorta, scoprendo quanto è facile conservarle! Poi però fateci sapere qual è la vostra preferita!',8,1627.4,'',''),(38,66,2,'Spaghetti alla carbonara',1,25,'Il Vicolo della Scrofa, per chi conosce Roma, è una delle stradine più caratteristiche e ricche di simboli. Proprio in una trattoria di questa strada, da cui il nome del vicolo, pare sia stata realizzata la prima Carbonara, nel 1944. La storia più attendibile infatti racconta l\'incontro tra gli ingredienti a disposizione dei soldati americani e la fantasia di un cuoco romano. Il risultato fu il prototipo degli spaghetti alla carbonara: uova, bacon (poi guanciale) e formaggio. Man a mano la ricetta è evoluta fino a quella che tutti conosciamo oggi e possiamo apprezzare a casa di amici romani veraci (e voraci!), nelle trattorie come nei ristoranti stellati della Capitale, in tutta Italia e all\'estero, nelle innumerevoli versioni: con o senza pepe, con un tuorlo per persona o l\'aggiunta di almeno un uovo intero, con guanciale o pancetta tesa.\nIl condimento per la carbonara si prepara in una manciata di minuti. Pensate che occorrono soltanto guanciale speziato tagliato a striscioline, una crema dorata a base di tuorli (nella nostra versione) e tanto Pecorino grattugiato al momento. \nNella sua semplicità e nella ricchezza delle materie prime, la ricetta degli spaghetti alla carbonara è parente stretta di altri due capisaldi della cucina genuina italiana: l\'amatriciana e la gricia! Fate un tuffo nella Roma popolare insieme a noi e scoprite come realizzare dei cremosissimi spaghetti alla carbonara, fateci sapere se la nostra versione vi piace e... aspettiamo la vostra!',4,3575.5,'Come potete arricchire questa ricetta? Innanzitutto rispettando i vostri gusti, in cucina è sempre importantissimo! Altrimenti eccovi delle validissime alternative. Per esempio in alternativa agli spaghetti si possono usare anche rigatoni o mezze maniche e invece del guanciale provate con della pancetta tesa utilizzando un grasso in padella, dell\'olio o del burro. Poi sostituite il Pecorino o fate a metà con del Parmigiano grattugiato. E per finire, per rendere ancora più corposa la vostra carbonara, non ci sarà bisogno di aggiungere la panna! Potete semplicemente aggiungere poca acqua di cottura della pasta oppure usare una combinazione di uova intere e tuorli: sperimentate per trovare la consistenza che più preferite!','Aggiungere il guanciale e pecorino'),(39,66,4,'Crema pasticcera',2,25,'Uova, latte, zucchero, vaniglia, bastano pochi ingredienti per dare vita ad una delle creme più amate: la crema pasticcera. Questa crema è tra le più usate in pasticceria, come la chantilly o lo zabaione per farcire crostate, bignè, dolci di pasta sfoglia (come cannoncini, vol-au-vent, dolci millefoglie), ma anche il più classico Pan di Spagna. La crema pasticcera viene usata anche per preparare semifreddi, budini e moltissimi dolci al cucchiaio, come la nostra deliziosa torta mattonella. E\' una preparazione molto versatile: basterà modificare appena le dosi di alcuni ingredienti per ottenere consistenze diverse e appropriate all\'uso che ne farete! Se volete omettere la panna fresca ad esempio, che rende la crema più ricca e setosa, basterà sostituirla con la stessa dose di latte. Invece della bacca di vaniglia, potete aromatizzare la crema con scorza d\'arancia o limone non trattati. Per addensarla maggiormente, poi, sarà sufficiente utilizzare più amido di mais o diminuire la dose nel caso vorreste gustarla al cucchiaio. Seguite il procedimento passo passo e scoprite tutti gli accorgimenti per preparare una golosissima crema pasticcera!',4,1700.8,'',''),(40,66,2,'Spaghetti all\'amatriciana',1,35,'I piatti regionali sono spesso motivo di disputa tra gli italiani, che si tratti di Chef professionisti o cuochi amatoriali, e gli spaghetti all’Amatriciana non fanno eccezione! Bucatini o spaghetti, pancetta o guanciale, aglio o cipolla… questi i principali interrogativi che chiunque si appresti a cucinare per la prima volta questa ricetta si trova a dover affrontare. Si dice che questo famoso piatto nato ad Amatrice fosse il pasto principale dei pastori, ma originariamente era senza pomodoro e prendeva il nome di “gricia”; questo ingrediente fu aggiunto in seguito quando i pomodori vennero importati dalle Americhe e il condimento prese il nome di Amatriciana. E’ quindi normale che una ricetta così antica e popolare si sia trasformata nel tempo assumendo le numerose varianti di cui ancora si discute al giorno d’oggi. Quella che vi proponiamo qui è la nostra versione, preparata con ingredienti locali e di qualità. Perché pensiamo che in realtà la ricetta degli spaghetti all’Amatriciana non divida l’Italia, bensì la unisca nel nome della bontà di una pietanza dall’animo semplice e dal carattere deciso… proprio come chi l’ha creata!',4,1444.9,'','Aggiungere peperoncino'),(41,8,2,'Gnocchi di patate',2,60,'Chi non ha mai affondato le mani in pasta per preparare queste morbide gemme di patate? Gli gnocchi, sovrani indiscussi dei pranzi del giovedì, almeno nella Capitale e in alcune regioni del centro Italia. Così semplici eppure insidiosi per ottenere la giusta consistenza. Ci sono infatti diversi accorgimenti da tenere presente per una perfetta riuscita, quelli che conoscono soltanto le nonne. Ci siamo fatti sussurrare all’orecchio i segreti per gli gnocchi perfetti e… dato che non siamo custodi gelosi delle ricette, abbiamo pensato di condividerli con voi! Scoprite come preparare gli gnocchi di patate, questi morbidi cuscinetti dal sapore delicato perfetti per qualsiasi condimento, dal classico sugo alla sorrentina a quelli delicati e cremosi come con stracchino e spinaci fino più rustici come gli gnocchi ai 4 formaggi o con speck e noci. Questa volta, se qualcuno vi dirà “ridi, ridi che la mamma ha fatto i gnocchi” potrete sorridere beatamente e rispondere “No, li ho preparati io, gli gnocchi di patate… ed erano i più buoni mai mangiati!”',4,1813,'',''),(42,8,1,'Pasta e fagioli',1,125,'La ricetta della pasta e fagioli è un classico della cucina italiana, un primo piatto dal sapore inconfondibile che affonda le radici nella tradizione rurale. Nella sua versione più rustica viene insaporita con le cotiche di maiale, come nella pasta e fagioli alla napoletana, mentre in altre varianti i legumi vengono abbinati a molluschi che conferiscono alla pietanza un intenso sapore di mare, come nei cicatielli con cozze e fagioli. Un piatto povero ed economico, quindi, ma sempre estremamente gustoso e genuino. Proprio come la nostra versione della pasta e fagioli! Abbastanza densa da \"reggere il cucchiaio in piedi\" (i più tradizionalisti dicono sia questo il modo per riconoscere la giusta consistenza, cremosa e corposa al tempo stesso) e ricca di aromi, con l\'immancabile nota sapida data dall’aggiunta del lardo e del prosciutto crudo. Un intramontabile comfort food all’italiana che scalda il cuore e mette d’accordo tutti grazie al suo sapore senza tempo, da provare anche nella versione estiva con i legumi freschi. Assaggiate la nostra pasta e fagioli e vedrete che non la lascerete più!',4,1206.6,'',''),(43,8,3,'Patate al forno',2,80,'Una tira l’altra ma non sono le ciliegie... sono le patate! Oggi vi deliziamo con un classico intramontabile della cucina casalinga: le patate al forno. Impossibile non amare questo contorno tipico che sta bene su tutto: carne o pesce a voi la scelta, unica regola è che le patate al forno siano dorate e croccanti, in una parola irresistibili! Come tutte le ricette che al primo sguardo appaiono semplici, anche questa può nascondere delle insidie nella preparazione. Ognuno custodisce il segreto per patate al forno perfette: c\'è chi le passa sotto acqua corrente fredda o in ammollo per eliminare l\'amido, chi le cuoce in forno statico prima coperte con carta alluminio e poi scoprendo la teglia, chi ancora misura millimetricamente gli spicchi o i cubetti per farli tutti uguali e garantire la cottura uniforme. Siete curiosi di conoscere quali sono i nostri trucchi per un risultato da applausi a tavola? Siamo felici di condividerli con voi per farvi assaporare un contorno gustoso che piace sempre a tutti! Per insaporire le patate al forno abbiamo scelto rosmarino e timo, degli evergreen irrinunciabili. Provate anche la versione alla birra, dall\'aroma deciso e particolare! Se siete amanti della cottura al forno, nella stagione autunnale non potrete perdere un altro contorno ugualmente facile e sfizioso da preparare: la zucca al forno!',4,1035.8,'',''),(44,1,4,'Torta tenerina',2,55,'La torta tenerina è un dolce tipico della città di Ferrara, che grazie alla sua golosità ha conquistato tutto il paese... nessuno infatti riesce a resistere ad una fetta di questo fantastico dolce! Sarà merito della fragrante crosticina esterna o della sua consistenza fondente che si scioglie in bocca ad ogni assaggio? Noi ci siamo innamorati di entrambi, ma una cosa è certa: il suo intenso sapore di cioccolato mette d\'accordo tutti! La torta tenerina è una torta con pochi ingredienti, senza lievito che ha la particolarità di rimanere bassa e umida all\'interno, proprio come il nome suggerisce: nel dialetto ferrarese veniva chiamata anche \" Torta Taclenta\", che in italiano significa appiccicosa. Un dessert semplice da realizzare, dal successo garantito perfetto anche per festeggiare i papà e per esaltare tutto il suo sapore provate a servirlo insieme ad una delicata crema al mascarpone, sentirete che bontà.. perfetta per ogni occasione e per la festa del papà! ',8,3119,'Per ottenere un gusto ancora più intenso spolverizzate la torta tenerina con del cacao amaro!',''),(45,1,3,'Polpette di zucca',3,60,'Amanti delle polpette, correte a noi! Se non sapete resistere a questi dorati finger food, e ancor meno a quelli che custodiscono un voluttuoso cuore filante, abbiamo preparato per voi un’altra gustosissima variante da mangiare in un sol boccone… polpette di zucca! L’ortaggio simbolo di Halloween e dell’autunno si trasforma in una morbida purea da plasmare con le vostre mani per dare forma a sfiziose pepite da friggere o cuocere al forno. Servite insieme alle polpette di ceci o a quelle di cavolfiore e curcuma, le polpette di zucca saranno le ambite co-protagoniste di un invitante buffet vegetariano con cui potrete stupire tutti i vostri amici!',16,1024.4,'',''),(46,1,4,'Strudel di mele',3,70,'Lo strudel è un dolce tipico del Trentino Alto Adige, ma le sue origini sono Turche. I Turchi, che dominarono intorno al XVII secolo l’Ungheria, preparavano un dolce di mele simile che si chiamava baklava. Questa ricetta fu variata e trasformata dagli ungheresi nell’attuale strudel che presto prese piede in Austria che, a sua volta, dominando per un certo periodo alcuni territori dell’Italia del Nord, fece conoscere loro questo delizioso dolce. Il Trentino Alto Adige è ormai il depositario dei segreti della preparazione dello strudel, che qui ha avuto notevole successo anche grazie alle numerose coltivazioni di mele presenti sul suo territorio, che sono l’ingrediente fondamentale del ripieno di questo rotolo di pasta, assieme a uvetta, pinoli e cannella. In questa ricetta vi proponiamo la varietà di mele Golden, ma la ricetta originale prevede l\'uso delle renette. Preparate lo strudel di mele, gustatelo con una tazza fumante di vin brulé, e inebriatevi del suo profumo intenso!',6,1773.35,'Lo strudel, a seconda del luogo, viene preparato anche con pasta sfoglia o pasta frolla; può essere fatto anche con altri tipi di frutta come pere, ciliegie, albicocche, oppure addirittura con verdure o crauti in versione salata.',''),(47,1,4,'Pan di spagna',4,65,'Il Pan di Spagna è una delle preparazioni di base della pasticceria italiana che tutti coloro che amano cucinare hanno preparato almeno una volta per dar vita ad una meravigliosa torta di compleanno o un dolce a base di questa morbida preparazione, come lo zuccotto! Una ricetta semplice, ma spesso le cose più semplici in cucina richiedono molte accortezze per un risultato perfetto! La sofficità del Pan di Spagna, il risultato alto e alveolato è dovuto all\'uso di una farina debole come la 00, così che l\'impasto non risulti elastico, e di una parte di fecola che assorbendo l\'umidità permetterà di ottenere un dolce ancora più soffice. Inoltre il Pan di Spagna è una ricetta che non richiede l\'utilizzo del lievito, infatti le uova dovranno essere montate correttamente per incorporare e sviluppare delle bollicine d\'aria che permetteranno di non farlo sgonfiare durante la cottura. \nInoltre, forse non sapete, ma ci sono moltissime varietà di questa ricetta: basti pensare quella al cacao, quello senza glutine e persino quello salato per feste e aperitivi! Ma oltre alle varietà esistono almeno 5 metodi per preparare il Pan di Spagna: 2 a caldo, 2 a freddo e uno con emulsionanti.\nSono diversi i procedimenti ma il risultato non cambia! E come ben sapete cerchiamo sempre di ricorrere al metodo più semplice per permettervi di ottenere un buon risultato anche a casa... con questa ricetta sporcherete solo la ciotola della planetaria! Preparate il Pan di Spagna per farcire le vostre torte delle occasioni speciali con crema pasticcera o ganache al cioccolato o per assemblare una deliziosa zuppa inglese! Se invece state cercando un\'idea originale per la vostra festa di Halloween, scoprite come utilizzare il pan di Spagna per realizzare delle dolci bare farcite con la marmellata!',8,1592.5,'',''),(48,86,4,'Rotolo alla nutella',3,39,'Il rotolo alla Nutella è uno dei dolci più classici: un golosissimo vortice di soffice pasta biscotto avvolge una delle creme spalmabili più amate a base di nocciole! Questo soffice impasto ricorda la consistenza e il gusto del pan di Spagna ma in questo formato diventerà un invitante rotolo di travolgente golosità, che conquisterà grandi e piccini! Servitelo a fette per una merenda sfiziosa per festeggiare il compleanno dei vostri bambini, magari in abbinamento a simpatici cubetti di torta Mars, oppure in occasione di feste in casa, come durante il periodo di Halloween. Sbizzarritevi nella decorazione utilizzando stencil diversi per le varie occasioni... diventerà una vera e propria tela su cui sfogare la vostra creatività! Ma non sperate di poterla ammirare a lungo, il rotolo alla Nutella sparirà in un lampo!',8,3117.8,'',''),(49,86,5,'Confettura di mele',2,60,'Le mele cotogne: un frutto particolare e delizioso che offre l’inverno! Questo frutto originario del Medio Oriente ha un sapore gradevolmente acidulo e astringente che diventa una vera prelibatezza della stagione fredda se trasformato in una profumata confettura! La confettura di mele cotogne può essere utilizzata per farcire i dolci, come i tradizionali gobeletti liguri, ma noi vogliamo suggerirvi un’idea alternativa: come accompagnamento di secondi piatti di carne! Pare infatti che già nel Medioevo questa confettura venisse usata per profumare e insaporire le carni, specialmente quelle grasse, di pollame e selvaggina. Allora cosa aspettate? Cominciate anche voi a racchiudere il profumo di questo frutto invernale in piccoli barattolini per averlo sempre con voi e portare un tocco di originalità a tavola!',20,2988,'Il segreto per una confettura con questo frutto irresistibile? Le mele dovranno essere molto mature. Per gli amanti dei sapori intensi perché non provare ad aromatizzarla con delle spezie come ad esempio la cannella? Sarà un capolavoro!',''),(50,86,5,'Purè di patate',2,80,'Per qualcuno il purè di patate rappresenta un vero e proprio comfort food, praticamente quei cibi capaci di suscitare sensazioni di benessere psicofisico. E non c’è bisogno nemmeno di chiedersi come sia possibile, specialmente se si tratta di questa ricetta! Immaginate una irresistibile cremosità, il profumo del burro e quella leggera nota di sapido data dal formaggio grattugiato. Il purè di patate è praticamente un contorno perfetto per accompagnare secondi a base di carne, di pesce o vegetariani, come per esempio le lenticchie! \nPoi c’è la versione cremosa, che è destinata ai veri golosi, si prepara con la panna e la sua consistenza conquista anche i palati più scettici e grandi affezionati della ricetta tradizionale. Ma alla fine l’unico capace di mettere tutti d’accordo, quello che piace a chiunque insomma è sempre e solo il purè di patate nella sua versione classica. \nSignore e signori oggi nella vostra cucina c\'è il più famoso dei comfort food!',4,1224.7,'',''),(51,86,2,'Pasta e patate alla napoletana',2,75,'Se non conoscete la pasta e patate alla napoletana oggi vi si aprirà un mondo! Non è un’esagerazione perché si tratta di un piatto che ha sorpreso noi per primi, una ghiotta variante della classica pasta e patate: la sua preparazione, la sua modalità di cottura e, non per ultimo, il suo meraviglioso sapore. Ma procediamo con ordine. Si tratta di un primo piatto le cui radici sono davvero molto umili. Unire le patate alla pasta è infatti un modo ingegnoso per preparare un piatto contadino molto povero. Per rendere più ricca la preparazione viene aggiunto del grasso di maiale in cui lasciar sfrigolare le verdure del soffritto. Per dare un po’ di colore si aggiunge del concentrato che, durante la bella stagione, può essere sostituito con dei pomodorini freschi per esempio. E poi c’è l’ingrediente fondamentale della pasta e patate alla napoletana: la crosta del formaggio! In tanti la scartano, non sanno che si perdono a non aggiungerla in pentola come per esempio nella ricetta della pasta e fagioli. La crosta infatti diventa morbida rilasciando parte del formaggio ancora attaccato trasformando il piatto in una prelibatezza di cremosità, mentre la parte più esterna, accuratamente pulita e grattata, è da masticare: il nostro consiglio, per evitare scontri diplomatici a tavola, è di dividerla in pezzi tanti quanti i commensali così ognuno avrà la sua porzione. Siete curiosi di sapere come si prepara la pasta e patate alla napoletana? Ecco la nostra versione!',0,3439.6,'','Non trovo il sedano tra gli ingredienti'),(52,86,4,'Torrone dei morti',5,35,'Girovagando di regione in regione, incuriositi dalle diverse culture culinarie proposte per le festività, ci siamo imbattuti in questa specialità legata alla Commemorazione dei Defunti: il torrone dei morti, un dolce a base di cioccolato e nocciole che si prepara in Campania nei primi giorni di novembre. Ci siamo incuriositi di tanta bontà e abbiamo pensato di presentarvi una variante di questo tradizionale dolce campano: un goloso involucro di cioccolato fondente racchiude un cuore di cioccolato bianco e crema spalmabile alle nocciole arricchito con nocciole intere... una vera delizia da spiluccare per merenda o come dolce fine pasto, magari travestito da macabro dessert per la vostra cena di Halloween. Il torrone dei morti si scioglie letteralmente in bocca... dite la verità: ne volete già un pezzetto!',10,8365,'','Manca il cioccolato bianco e crema spalmabile alle nocciole!'),(53,86,4,'Crostata alla confettura di albicocca',2,90,'Qual è il dolce classico fatto in casa per antonomasia? Senza dubbio la crostata alla confettura di albicocche! La crostata è una ricetta gustosa e soprattutto semplice da realizzare e potrete farcirla con tante confetture fatte in casa. \nNon servono particolari strumenti: noi abbiamo usato il mixer per facilitare il procedimento, ottenendo una frolla sabbiata, ma voi potete tranquillamente impastare a mano come da sempre fanno le nostre nonne!\nE se avete poco tempo non rinunciate ad un dolce sano e casalingo: preparate in anticipo la pasta frolla classica o quella senza glutine adatta a tutti, e congelatela, così all’occorrenza sarà sufficiente scongelarla in frigorifero prima di utilizzarla e preparare il dolce. \nLa versione tradizionale della ricetta prevede la creazione di strisce ricavate dai ritagli di pasta per realizzare il tipico decoro a losanghe che caratterizza questo dolce ma potete scatenare la vostra fantasia e inventarne di nuovi, ad esempio utilizzando gli stampi per biscotti creando così delle forme nuove e originali da distribuire sulla superficie della crostata. \nLa crostata con confettura di albicocche è perfetta sia per un’ottima colazione sia come merenda per i bambini, provatela realizzando delle crostatine monoporzione, i vostri bimbi ne saranno entusiasti.',4,4425.8,'Se volete rendere più profumata la crostata alle albicocche potete aromatizzare la frolla con dell’arancia! \nSe invece volete renderla più particolare sistemate della granella di mandorle tra i vari spazi delle losanghe: conquisterete tutti! Nel caso avanzasse dell\'impasto, potete congelarlo oppure realizzare delle piccole crostatine monoporzione.',''),(54,86,2,'Pasta alla gricia',2,25,'La pasta alla gricia è uno dei piatti più famosi della cucina laziale, considerata l’antenata della pasta all\'amatriciana.\nIn comune con la ricetta dell’amatriciana infatti c’è l’utilizzo del guanciale e del Pecorino romano. La differenza principale invece sta nel sugo di pomodoro, assente nella pasta alla gricia poiché la sua origine sarebbe addirittura antecedente all’importazione del pomodoro in Europa. Si dice la pasta alla gricia sia stata inventata dai pastori laziali, che con i pochi ingredienti che avevano a disposizione al ritorno dai pascoli preparavano un piatto così semplice ma altrettanto gustoso e sostanzioso. Potete scegliere se unire al saporito condimento un formato di pasta lungo come bucatini e tonnarelli, oppure corto come i rigatoni!',4,3023.9,'','');
/*!40000 ALTER TABLE `ricetta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sweetnews`.`ricetta_AFTER_INSERT` AFTER INSERT ON `ricetta` FOR EACH ROW
BEGIN
	INSERT INTO `sweetnews`.`flusso_approvativo`
    (id_utente_creatore, id_stato_approvativo, id_ricetta)
    VALUES
    (NEW.id_utente, (SELECT id_stato_approvativo FROM stato_approvativo WHERE codice_stato_approvativo = 0), NEW.id_ricetta);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `ruoli_utente`
--

DROP TABLE IF EXISTS `ruoli_utente`;
/*!50001 DROP VIEW IF EXISTS `ruoli_utente`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_utente` (
  `id_utente` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `cognome` tinyint NOT NULL,
  `username` tinyint NOT NULL,
  `password` tinyint NOT NULL,
  `delega_codice` tinyint NOT NULL,
  `delega_nome` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `stato_approvativo`
--

DROP TABLE IF EXISTS `stato_approvativo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stato_approvativo` (
  `id_stato_approvativo` int(11) NOT NULL AUTO_INCREMENT,
  `id_stato_approvativo_precedente` int(11) DEFAULT NULL,
  `id_stato_approvativo_valutazione` int(11) DEFAULT NULL,
  `id_stato_approvativo_approvazione` int(11) DEFAULT NULL,
  `id_stato_approvativo_rifiuto` int(11) DEFAULT NULL,
  `codice_stato_approvativo` int(11) NOT NULL,
  `nome_stato_approvativo` varchar(45) NOT NULL,
  `stato_approvativo_isLeaf` tinyint(4) DEFAULT NULL,
  `id_delega_necessaria` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_stato_approvativo`),
  KEY `fk_stato_stato_precedente_idx` (`id_stato_approvativo_precedente`),
  KEY `fk_stato_stato_valutazione_idx` (`id_stato_approvativo_valutazione`),
  KEY `fk_stato_stato_approvazione_idx` (`id_stato_approvativo_approvazione`),
  KEY `fk_stato_stato_rifiuto_idx` (`id_stato_approvativo_rifiuto`),
  KEY `fk_stato_approvativo_tipo_delega_idx` (`id_delega_necessaria`),
  CONSTRAINT `fk_stato_approvativo_tipo_delega` FOREIGN KEY (`id_delega_necessaria`) REFERENCES `tipo_delega` (`id_tipo_delega`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_stato_stato_approvazione` FOREIGN KEY (`id_stato_approvativo_approvazione`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_stato_stato_precedente` FOREIGN KEY (`id_stato_approvativo_precedente`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_stato_stato_rifiuto` FOREIGN KEY (`id_stato_approvativo_rifiuto`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_stato_stato_valutazione` FOREIGN KEY (`id_stato_approvativo_valutazione`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stato_approvativo`
--

LOCK TABLES `stato_approvativo` WRITE;
/*!40000 ALTER TABLE `stato_approvativo` DISABLE KEYS */;
INSERT INTO `stato_approvativo` VALUES (1,NULL,NULL,NULL,NULL,0,'bozza',0,1),(2,1,3,NULL,NULL,5,'inviata',0,2),(3,2,NULL,5,4,10,'in validazione',0,2),(4,2,NULL,NULL,NULL,15,'non idonea',1,NULL),(5,2,6,NULL,NULL,20,'idonea',0,3),(6,5,NULL,8,7,25,'in approvazione',0,3),(7,5,NULL,NULL,NULL,30,'non approvata',1,NULL),(8,5,NULL,NULL,NULL,35,'approvata',0,NULL);
/*!40000 ALTER TABLE `stato_approvativo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `stato_flusso_approvativo`
--

DROP TABLE IF EXISTS `stato_flusso_approvativo`;
/*!50001 DROP VIEW IF EXISTS `stato_flusso_approvativo`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `stato_flusso_approvativo` (
  `id_flusso_approvativo` tinyint NOT NULL,
  `id_utente_creatore` tinyint NOT NULL,
  `id_utente_approvatore` tinyint NOT NULL,
  `id_ricetta` tinyint NOT NULL,
  `data_flusso` tinyint NOT NULL,
  `codice_stato_approvativo` tinyint NOT NULL,
  `nome_stato_approvativo` tinyint NOT NULL,
  `id_stato_approvativo` tinyint NOT NULL,
  `id_stato_approvativo_precedente` tinyint NOT NULL,
  `stato_approvativo_isLeaf` tinyint NOT NULL,
  `id_stato_approvativo_valutazione` tinyint NOT NULL,
  `id_stato_approvativo_approvazione` tinyint NOT NULL,
  `id_stato_approvativo_rifiuto` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipo_delega`
--

DROP TABLE IF EXISTS `tipo_delega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipo_delega` (
  `id_tipo_delega` int(11) NOT NULL AUTO_INCREMENT,
  `delega_codice` int(11) NOT NULL,
  `delega_nome` varchar(45) NOT NULL,
  PRIMARY KEY (`id_tipo_delega`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_delega`
--

LOCK TABLES `tipo_delega` WRITE;
/*!40000 ALTER TABLE `tipo_delega` DISABLE KEYS */;
INSERT INTO `tipo_delega` VALUES (1,10,'visitatore'),(2,20,'redattore'),(3,30,'caporedattore');
/*!40000 ALTER TABLE `tipo_delega` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipologia`
--

DROP TABLE IF EXISTS `tipologia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologia` (
  `id_tipologia` int(11) NOT NULL AUTO_INCREMENT,
  `nome_tipologia` varchar(45) NOT NULL,
  PRIMARY KEY (`id_tipologia`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipologia`
--

LOCK TABLES `tipologia` WRITE;
/*!40000 ALTER TABLE `tipologia` DISABLE KEYS */;
INSERT INTO `tipologia` VALUES (1,'antipasto'),(2,'primo'),(3,'secondo'),(4,'dolce'),(5,'altro');
/*!40000 ALTER TABLE `tipologia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `utente` (
  `id_utente` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `cognome` varchar(45) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(60) NOT NULL,
  PRIMARY KEY (`id_utente`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES (1,'Gianmattia','Gherardi','admin','$2y$10$HhNbqwNnO/7X.3/pFg0R3OS4p6a5JiW4hx0dMinaKIc3jhA.GTRNq'),(8,'Mario','Rossi','visitatore1','$2y$10$OtI5mZz9tSfRfOk9zyYDLu6MED/ATkNERbvYat3WDO5sGsVMWF1vC'),(66,'Luigi','Verdi','visitatore2','$2y$10$XonoHcS8Yo6olVJNEzOyp.ETUiGURtO.9hNCeBoVaFTuCRE6u39ka'),(69,'Clara','Bruno','visitatore3','$2y$10$xGhsTZlx6ucrLOYNX5X7XewDOJ9YItKBGR4SSC2FlnZuF3LzJ5oPm'),(85,'Miranda','Manna','Redattore1','$2y$10$EtXwmxGu//dLXsy4CO73bOVdYf.7cIuzntIbJ8Oam4rvcY1mqsVqu'),(86,'Ottone','Genovese','visitatore4','$2y$10$0gZAw0FTubCIcKWag9YqMemyBu5Oi3sBj7r5Jre33iCZnAbdJzbKK'),(87,'Davide','Celio','redattore2','$2y$10$ahdP2/jjj66CpAbpoqwXpuzRKMYv9ojyV9FbI.B8.laDRRDXqkTEO'),(88,'Renata','Boni','caporedattore2','$2y$10$WinZx/v16w4fMn9.mrQoherY.udJ6ADs/sy4e4pzhKltywFi5Fhv2');
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'sweetnews'
--

--
-- Dumping routines for database 'sweetnews'
--
/*!50003 DROP PROCEDURE IF EXISTS `deleteRecipe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRecipe`(IN idRicetta VARCHAR(255))
BEGIN
	DELETE FROM flusso_approvativo_audit WHERE id_ricetta = idRicetta;
    DELETE FROM flusso_approvativo WHERE id_ricetta = idRicetta;
    DELETE FROM lista_ingredienti WHERE id_ricetta = idRicetta;
	DELETE FROM ricetta WHERE id_ricetta = idRicetta;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUser`(IN idUtente VARCHAR(255))
BEGIN
	DELETE FROM delega WHERE id_utente = idUtente;
    DELETE FROM dettaglio_utente_esterno WHERE id_utente = idUtente;
    DELETE FROM dettaglio_utente_interno WHERE id_utente = idUtente;
	DELETE FROM utente WHERE id_utente = idUtente;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `abstract_ricette`
--

/*!50001 DROP TABLE IF EXISTS `abstract_ricette`*/;
/*!50001 DROP VIEW IF EXISTS `abstract_ricette`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `abstract_ricette` AS select `r`.`id_ricetta` AS `id_ricetta`,`r`.`titolo_ricetta` AS `titolo_ricetta`,`r`.`difficolta` AS `difficolta`,`r`.`tempo_cottura` AS `tempo_cottura`,`r`.`calorie_totali` AS `calorie_totali`,`r`.`preparazione` AS `preparazione`,`t`.`id_tipologia` AS `id_tipologia`,`t`.`nome_tipologia` AS `nome_tipologia`,`sa`.`codice_stato_approvativo` AS `codice_stato_approvativo` from (((`ricetta` `r` join `flusso_approvativo` `fa` on((`fa`.`id_ricetta` = `r`.`id_ricetta`))) join `stato_approvativo` `sa` on((`fa`.`id_stato_approvativo` = `sa`.`id_stato_approvativo`))) join `tipologia` `t` on((`t`.`id_tipologia` = `r`.`id_tipologia`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `anteprime_ricetta`
--

/*!50001 DROP TABLE IF EXISTS `anteprime_ricetta`*/;
/*!50001 DROP VIEW IF EXISTS `anteprime_ricetta`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `anteprime_ricetta` AS select `r`.`id_ricetta` AS `id_ricetta`,`r`.`titolo_ricetta` AS `titolo_ricetta`,`r`.`difficolta` AS `difficolta`,`r`.`tempo_cottura` AS `tempo_cottura`,`r`.`calorie_totali` AS `calorie_totali`,`t`.`id_tipologia` AS `id_tipologia`,`t`.`nome_tipologia` AS `nome_tipologia`,`fa`.`data_flusso` AS `data_flusso`,`sa`.`nome_stato_approvativo` AS `nome_stato_approvativo`,`sa`.`codice_stato_approvativo` AS `codice_stato_approvativo`,`sa`.`id_stato_approvativo` AS `id_stato_approvativo`,`sa`.`id_stato_approvativo_valutazione` AS `id_stato_approvativo_valutazione`,`sa`.`id_stato_approvativo_approvazione` AS `id_stato_approvativo_approvazione`,`sa`.`id_stato_approvativo_rifiuto` AS `id_stato_approvativo_rifiuto`,`uc`.`id_utente` AS `id_utente_creatore`,`uc`.`username` AS `username_utente_creatore`,`ua`.`id_utente` AS `id_utente_approvatore`,`ua`.`username` AS `username_utente_approvatore` from (((((`ricetta` `r` join `flusso_approvativo` `fa` on((`r`.`id_ricetta` = `fa`.`id_ricetta`))) join `utente` `uc` on((`uc`.`id_utente` = `fa`.`id_utente_creatore`))) join `tipologia` `t` on((`t`.`id_tipologia` = `r`.`id_tipologia`))) left join `utente` `ua` on((`ua`.`id_utente` = `fa`.`id_utente_approvatore`))) join `stato_approvativo` `sa` on((`sa`.`id_stato_approvativo` = `fa`.`id_stato_approvativo`))) order by `sa`.`codice_stato_approvativo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `deleghe_utente`
--

/*!50001 DROP TABLE IF EXISTS `deleghe_utente`*/;
/*!50001 DROP VIEW IF EXISTS `deleghe_utente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `deleghe_utente` AS select `d`.`id_utente` AS `id_utente`,`tp`.`delega_codice` AS `delega_codice`,`tp`.`delega_nome` AS `delega_nome` from (`tipo_delega` `tp` join `delega` `d` on((`tp`.`id_tipo_delega` = `d`.`id_tipo_delega`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `dettagli_utente`
--

/*!50001 DROP TABLE IF EXISTS `dettagli_utente`*/;
/*!50001 DROP VIEW IF EXISTS `dettagli_utente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `dettagli_utente` AS select `u`.`id_utente` AS `id_utente`,`u`.`username` AS `username`,`u`.`nome` AS `nome`,`u`.`cognome` AS `cognome`,`dui`.`id_dettaglio_utente_interno` AS `id_dettaglio_utente_interno`,`due`.`id_dettaglio_utente_esterno` AS `id_dettaglio_utente_esterno`,`due`.`indirizzo` AS `indirizzo`,`due`.`telefono_abitazione` AS `telefono_abitazione`,`due`.`telefono_cellulare` AS `telefono_cellulare`,`due`.`email` AS `email`,`due`.`data_nascita` AS `data_nascita` from ((`utente` `u` left join `dettaglio_utente_interno` `dui` on((`u`.`id_utente` = `dui`.`id_utente`))) left join `dettaglio_utente_esterno` `due` on((`u`.`id_utente` = `due`.`id_utente`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ruoli_utente`
--

/*!50001 DROP TABLE IF EXISTS `ruoli_utente`*/;
/*!50001 DROP VIEW IF EXISTS `ruoli_utente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ruoli_utente` AS select `utente`.`id_utente` AS `id_utente`,`utente`.`nome` AS `nome`,`utente`.`cognome` AS `cognome`,`utente`.`username` AS `username`,`utente`.`password` AS `password`,`deleghe_utente`.`delega_codice` AS `delega_codice`,`deleghe_utente`.`delega_nome` AS `delega_nome` from (`utente` left join `deleghe_utente` on((`utente`.`id_utente` = `deleghe_utente`.`id_utente`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `stato_flusso_approvativo`
--

/*!50001 DROP TABLE IF EXISTS `stato_flusso_approvativo`*/;
/*!50001 DROP VIEW IF EXISTS `stato_flusso_approvativo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `stato_flusso_approvativo` AS select `fa`.`id_flusso_approvativo` AS `id_flusso_approvativo`,`fa`.`id_utente_creatore` AS `id_utente_creatore`,`fa`.`id_utente_approvatore` AS `id_utente_approvatore`,`fa`.`id_ricetta` AS `id_ricetta`,`fa`.`data_flusso` AS `data_flusso`,`sa`.`codice_stato_approvativo` AS `codice_stato_approvativo`,`sa`.`nome_stato_approvativo` AS `nome_stato_approvativo`,`sa`.`id_stato_approvativo` AS `id_stato_approvativo`,`sa`.`id_stato_approvativo_precedente` AS `id_stato_approvativo_precedente`,`sa`.`stato_approvativo_isLeaf` AS `stato_approvativo_isLeaf`,`sa`.`id_stato_approvativo_valutazione` AS `id_stato_approvativo_valutazione`,`sa`.`id_stato_approvativo_approvazione` AS `id_stato_approvativo_approvazione`,`sa`.`id_stato_approvativo_rifiuto` AS `id_stato_approvativo_rifiuto` from (`flusso_approvativo` `fa` join `stato_approvativo` `sa` on((`fa`.`id_stato_approvativo` = `sa`.`id_stato_approvativo`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-30  0:54:04
