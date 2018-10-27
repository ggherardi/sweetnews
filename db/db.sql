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
  `calorie_totali` tinyint NOT NULL,
  `preparazione` tinyint NOT NULL,
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
INSERT INTO `delega` VALUES (1,1),(2,1),(3,1),(1,8),(1,66),(1,69),(2,85);
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dettaglio_utente_esterno`
--

LOCK TABLES `dettaglio_utente_esterno` WRITE;
/*!40000 ALTER TABLE `dettaglio_utente_esterno` DISABLE KEYS */;
INSERT INTO `dettaglio_utente_esterno` VALUES (2,8,'Montione, Via Sergente Maggiore 25','0360 3499391','3495121835',' mariorossi@armyspy.com','1977-12-10',NULL),(3,1,'Roma, Largo Giuseppe Veratti 37','06216581563 ','345641236','admin@admin.com','1986-10-04',NULL),(5,66,'Roma, Via dei Gracchi 37','068463123','3158633125','luigiverdi@spyarmi.com','1988-01-29',NULL),(8,69,'','','3205467','ClaraBruno@rhyta.com','1958-07-25',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dettaglio_utente_interno`
--

LOCK TABLES `dettaglio_utente_interno` WRITE;
/*!40000 ALTER TABLE `dettaglio_utente_interno` DISABLE KEYS */;
INSERT INTO `dettaglio_utente_interno` VALUES (1,1),(12,85);
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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flusso_approvativo`
--

LOCK TABLES `flusso_approvativo` WRITE;
/*!40000 ALTER TABLE `flusso_approvativo` DISABLE KEYS */;
INSERT INTO `flusso_approvativo` VALUES (18,1,NULL,2,20,'2018-10-17 21:18:26'),(22,1,NULL,1,24,'2018-10-18 10:02:44'),(23,8,1,3,25,'2018-10-21 16:24:12'),(24,8,NULL,1,26,'2018-10-21 17:41:37'),(25,8,NULL,1,27,'2018-10-21 19:17:43'),(26,66,NULL,5,28,'2018-09-27 15:24:34'),(27,66,NULL,2,29,'2018-10-21 19:23:47'),(28,69,NULL,8,30,'2018-10-25 16:39:21'),(29,69,NULL,2,31,'2018-10-21 19:31:43'),(30,69,NULL,1,32,'2018-10-21 19:33:51');
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
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flusso_approvativo_audit`
--

LOCK TABLES `flusso_approvativo_audit` WRITE;
/*!40000 ALTER TABLE `flusso_approvativo_audit` DISABLE KEYS */;
INSERT INTO `flusso_approvativo_audit` VALUES (3,18,1,20,1,0,'2018-10-17 21:18:26'),(7,22,1,24,1,0,'2018-10-18 10:02:44'),(15,18,2,20,1,NULL,'2018-10-17 21:18:26'),(16,23,1,25,8,NULL,'2018-10-21 16:24:12'),(17,24,1,26,8,NULL,'2018-10-21 17:41:37'),(18,23,2,25,8,NULL,'2018-10-21 16:24:12'),(19,25,1,27,8,NULL,'2018-10-21 19:17:43'),(23,27,2,29,66,NULL,'2018-10-21 19:23:47'),(28,30,1,32,69,NULL,'2018-10-21 19:33:51'),(40,23,3,25,8,NULL,'2018-10-21 16:24:12'),(41,23,3,25,8,1,'2018-10-21 16:24:12'),(56,26,3,28,66,85,'2018-10-24 22:25:09'),(66,28,3,30,69,85,'2018-10-24 23:14:00'),(67,28,5,30,69,NULL,'2018-10-24 23:14:05'),(68,28,6,30,69,1,'2018-10-25 16:39:14'),(69,28,8,30,69,NULL,'2018-10-25 16:39:21'),(70,26,5,28,66,NULL,'2018-10-27 15:24:34'),(71,26,5,28,66,NULL,'2018-09-27 15:24:34');
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
) ENGINE=InnoDB AUTO_INCREMENT=394 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingrediente`
--

LOCK TABLES `ingrediente` WRITE;
/*!40000 ALTER TABLE `ingrediente` DISABLE KEYS */;
INSERT INTO `ingrediente` VALUES (223,'Banana',0.89),(224,'Melograno',0.83),(225,'Zenzero',0.8),(226,'Fichi',0.74),(227,'Uva',0.69),(228,'Ciliegie',0.63),(229,'Kiwi',0.61),(230,'Mango',0.6),(231,'Pera',0.58),(232,'Mirtilli',0.57),(233,'Mandarini',0.53),(234,'Mela',0.52),(235,'Lamponi',0.52),(236,'Ananas',0.5),(237,'Albicocche',0.48),(238,'Arance',0.47),(239,'Prugne',0.46),(240,'More',0.43),(241,'Pompelmo',0.42),(242,'Pesca',0.39),(243,'Melone',0.34),(244,'Fragole',0.32),(245,'Anguria',0.3),(246,'Limone',0.29),(247,'Melone giallo',0.28),(248,'Macadamia',7.18),(249,'Pinoli',6.73),(250,'Nocciole',6.28),(251,'Pistacchi',6.01),(252,'Anacardi',5.98),(253,'Noci',5.82),(254,'Arachidi',5.71),(255,'Sesamo',5.73),(256,'Mandorle dolci',5.42),(257,'Castagne',1.89),(258,'Cocco',6.04),(259,'Uva',2.83),(260,'Banana',2.7),(261,'Datteri',2.53),(262,'Fichi',2.42),(263,'Prugne',2.4),(264,'Albicocche',1.88),(265,'Lupini secchi',3.71),(266,'Ceci secchi',3.64),(267,'Lenticchie secche',3.53),(268,'Fagioli secchi',2.91),(269,'Avocado',1.6),(270,'Aglio',1.49),(271,'Soia',1.22),(272,'Fave',0.88),(273,'Mais crudo',0.86),(274,'Patata dolce',0.86),(275,'Fagioli borlotti in scatola',0.83),(276,'Piselli',0.81),(277,'Patate',0.77),(278,'Porro',0.61),(279,'Carciofo',0.47),(280,'Barbabietola',0.43),(281,'Carote',0.41),(282,'Cipolla',0.4),(283,'Broccoli',0.34),(284,'Finocchio',0.31),(285,'Fagiolini',0.31),(286,'Rape',0.28),(287,'Zucca',0.26),(288,'Cavolfiore',0.25),(289,'Rucola',0.25),(290,'Melanzana',0.24),(291,'Peperoni',0.24),(292,'Spinaci',0.23),(293,'Funghi',0.22),(294,'Zucchina',0.21),(295,'Pomodori',0.2),(296,'Asparago',0.2),(297,'Lattuga',0.17),(298,'Ravanelli',0.16),(299,'Cetriolo',0.16),(300,'Lardo',9.02),(301,'Salame',3.92),(302,'Salsiccia',3.39),(303,'Costina di maiale',2.77),(304,'Wurstel',2.3),(305,'Prosciutto cotto',2.15),(306,'Manzo macinato',2.12),(307,'Prosciutto crudo',1.95),(308,'Tacchino',1.6),(309,'Prosciutto crudo magro',1.47),(310,'Vitello',1.44),(311,'Manzo magro',1.4),(312,'Coniglio',1.36),(313,'Anatra',1.36),(314,'Coscia di pollo',1.3),(315,'Cervo',1.2),(316,'Maiale filetto',1.1),(317,'Agnello',1.09),(318,'Petto di tacchino',1.11),(319,'Petto di pollo',1),(320,'Salmone',1.79),(321,'Sgombro',1.63),(322,'Trota',1.48),(323,'Trota salmonata',1.41),(324,'Salmone affumicato',1.17),(325,'Orata',1.05),(326,'Gamberi',1.05),(327,'Tonno',1.03),(328,'Branzino',0.97),(329,'Cozze',0.86),(330,'Vongole',0.86),(331,'Polpo',0.82),(332,'Seppie',0.79),(333,'Gamberetti',0.71),(334,'Olio Extravergine',8.84),(335,'Burro',7.17),(336,'Olio di semi',8.84),(337,'Grana',3.92),(338,'Seitain',3.7),(339,'Emmental',3.57),(340,'Mozzarella',2.54),(341,'Tempeh',1.93),(342,'Hamburger di soia',1.54),(343,'Tofu',1.45),(344,'Uova',1.43),(345,'Ricotta',1.38),(346,'Yogurt alla frutta',1.09),(347,'Yogurt greco',0.96),(348,'Fiocchi di latte',0.87),(349,'Latte intero',0.61),(350,'Yogurt greco 0%',0.57),(351,'Latte di soia',0.54),(352,'Yogurt di soia',0.5),(353,'Latte di avena',0.44),(354,'Yogurt magro',0.41),(355,'Latte parzialmente Scremato',0.4),(356,'Latte scremato',0.34),(357,'Avena',3.89),(358,'Miglio',3.78),(359,'Pasta di semola',3.71),(360,'Amaranto',3.71),(361,'Farina di mais',3.65),(362,'Quinoa',3.64),(363,'Frumento tipo 0',3.61),(364,'Riso',3.58),(365,'Orzo',3.54),(366,'Grano saraceno',3.43),(367,'Segale',3.38),(368,'Farro',3.35),(369,'Gocciole',4.77),(370,'Oro Saiwa',4.25),(371,'Brioches',3.9),(372,'Pizza',3.01),(373,'Patatine fritte',2.99),(374,'Pane tipo 0',2.71),(375,'Big Mac',2.32),(376,'Coca Cola',0.42),(377,'Limoncello',3.43),(378,'Whisky',2.5),(379,'Vodka',2.31),(380,'Vino rosso',0.84),(381,'Vino bianco',0.82),(382,'Birra rossa',0.63),(383,'Spritz',0.5),(384,'Birra',0.43),(387,'Pasta all uovo',4.1),(388,'Sale',0),(389,'Pepe',0),(390,'Farina 00',3),(391,'Cioccolato fondente',5.46),(392,'Zucchero',3.92),(393,'Panna',3.36);
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
INSERT INTO `lista_ingredienti` VALUES (270,20,0.5),(270,32,0.1),(277,24,400),(277,27,500),(277,32,400),(282,20,50),(282,24,100),(282,26,100),(287,26,600),(287,28,600),(293,25,230),(293,31,500),(294,24,200),(295,20,100),(301,27,50),(305,27,50),(305,29,100),(310,31,400),(325,32,900),(334,26,20),(334,29,5),(335,26,50),(335,31,50),(337,20,0.2),(337,26,80),(337,27,10),(344,24,200),(344,27,100),(344,28,150),(347,30,250),(359,20,250),(359,29,320),(364,26,320),(388,20,0.1),(388,24,0.1),(388,25,20),(388,29,0.2),(388,31,0.2),(388,32,0.1),(389,20,0.1),(389,24,0.1),(389,25,20),(389,31,0.2),(389,32,0.1),(390,25,150),(390,28,50),(390,31,40),(392,30,100),(393,29,300),(393,30,250);
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
  `note` varchar(500) DEFAULT NULL,
  `messaggio` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_ricetta`),
  KEY `fk_ricetta_utente_idx` (`id_utente`),
  KEY `fk_ricetta_tipologia_idx` (`id_tipologia`),
  CONSTRAINT `fk_ricetta_tipologia` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologia` (`id_tipologia`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ricetta_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ricetta`
--

LOCK TABLES `ricetta` WRITE;
/*!40000 ALTER TABLE `ricetta` DISABLE KEYS */;
INSERT INTO `ricetta` VALUES (20,1,2,'Pasta al sugo',1,35,'Tagliare tutto, mettere a soffriggere, buttare acqua, far saltare in padella e condire bene bene!',2,969,'Nessuna nota','Aggiungere pasta all\'uovo'),(24,1,3,'Frittata',2,50,'Mettere a soffriggere cipolla, zucchine e patate. Sbattere in una ciotola le uova. Dopo aver lasciato appassire le verdure, versare le uova nella padella. Lasciare cuocere per 30 minuti a fuoco basso rigirando a metà cottura.',4,676,'',''),(25,8,3,'Funghi fritti',1,20,'Se a sentir parlare di funghi fritti vi viene subito alla mente la celeberrima scena dei “funghi fritti fritti fritti” descritti da Roberto Benigni in veste di cameriere nel film “La vita è bella”, questa ricetta vi farà senz’altro ricredere! I funghi fritti sono un piatto tanto semplice quanto appetitoso, perfetto da servire accompagnato da salsine come sfizioso antipasto oppure come sostanzioso contorno a un buon piatto di carne, in alternativa ai tradizionali funghi trifolati. Noi abbiamo scelto di utilizzare tre qualità diverse di funghi, ovvero porcini, pleurotus e champignon, e il risultato è stato pienamente all’altezza delle nostre aspettative: dorati, saporiti e gustosamente croccanti! Con poco tempo e poco sforzo, potrete preparare anche voi un classico autunnale dal tocco rustico con cui deliziare i vostri amici… basterà prestare attenzione alla temperatura dell’olio e assorbire quello in eccesso per ottenere dei funghi fritti asciutti e fragranti: siamo certi che in questo caso saranno i più richiesti del menù!',4,500.6,'Sono molto buoni!',''),(26,8,1,'Risotto alla zucca',2,60,'Il risotto alla zucca è una vera e propria istituzione della cucina italiana: una primo piatto che racchiude tutto il calore delle cotture lente, dei sapori genuini, del buon profumo che sa di casa. Una pietanza di origini contadine, come molti tra i migliori piatti della nostra tradizione: solo intuizione, pratica e fantasia hanno saputo trasformare la zucca e il riso in un piatto oggi celebrato dai gastronomi e amato dagli intenditori. Cosa c’è di così speciale in un risotto alla zucca, cosa lo rende irresistibile? La sua semplicità, ci verrebbe da rispondere; una semplicità che racchiude saggezza, cura, gesti immutabili, necessari, privi di frivolezze pompose: la tostatura del riso, che ne impermeabilizza i chicchi e regala loro una straordinaria tenuta di cottura. La cottura seguita passo passo, un mestolo di brodo per volta, perché un riso lesso è diverso da un risotto. La mantecatura, quel momento in cui l’amido trasforma i rimasugli di brodo in una cremina che poi il burro rende lucida e fondente. Tanti piccoli gesti d’altri tempi, che rendono questo piatto una delizia capace di conquistare tanto i palati più raffinati quanto gli amanti dei sapori semplici e genuini. Un piatto perfetto per tutte le occasioni, dalla cena per due a serate tra amici, anche nella festa principe della zucca: Halloween! Seguite il nostro passo-passo: anche per voi il risotto alla zucca non avrà più segreti!',4,2190.5,'',''),(27,8,3,'Gateau di patate',2,100,'Il gateau di patate è una deliziosa preparazione a base di patate e salumi vari. Un pasticcio da sfornare con un’irresistibile crosticina dorata che vi assicurerà un pasto succulento. Questa famosa e antica preparazione è un caposaldo della cucina partenopea e rivisitato poi in altre regioni del sud Italia. Tuttavia il gateau di patate, italianizzato in gattò o gatò, fece la sua comparsa sulle lussuose tavole del Regno delle due Sicilie soltanto alla fine del 1700. Infatti il palato sopraffino della regina Maria Carolina d’Asburgo, moglie di Ferdinando I di Borbone, non volle separarsi dai manicaretti dei monsieurs - i cuochi francesi - richiamati alla corte del Regno di Napoli. Fu così che il popolo napoletano apprese la tecnica e la rese propria. Sostituì la groviera con il fior di latte, e poi impreziosì il pasticcio con prosciutto cotto e salame. E non solo. Anche il nome presto passò da gateau di patate in gattò… e persino i monsieurs non scamparono alla fantasia partenopea, diventando perciò i “monzù”! Ogni famiglia tramanda la propria versione di questo irresistibile pasticcio, e così anche noi abbiamo deciso di condividere con voi la ricetta del gateau di patate realizzata dallo Chef Roberto Di Pinto!',6,870.7,'',''),(28,66,4,'Torta zucca e cioccolato',3,90,'L’arrivo dell’autunno con la sua deliziosa aria frizzantina accende il desiderio di coccolarsi con una calda e aromatica tazza di tè accompagnata da qualche golosità come la nostra torta zucca e cioccolato. Questo dolce dai colori aranciati con una setosa decorazione di ganache al cioccolato è la compagna perfetta per i pomeriggi ottobrini, ma potrebbe diventare anche una golosa torta a tema per coronare il vostro menù di Halloween! Ricca e sostanziosa, la torta zucca e cioccolato porta con sé profumi e aromi avvolgenti che spazzeranno via con un morso la nostalgia dell’estate con i suoi gelati. Chiamate a raccolta i vostri amici più cari e concedetevi un irresistibile peccato di gola!',8,520.5,'','Aggiungere l\'ingrediente farina di nocciole e lo zucchero!'),(29,66,2,'Penne al baffo',1,20,'Siete alla ricerca di un primo piatto veramente appetitoso e goloso pronto in soli 20 minuti? Eccolo servito! Le penne al baffo sono la ricetta perfetta da preparare per un pranzo in famiglia, quando si ha poco tempo per cucinare ma tanta voglia di qualcosa di sfizioso... e, perché no, anche quando stanno per arrivare i vostri amici affamati! Pochi e semplici passaggi garantiranno un risultato strepitoso... le penne assorbiranno questa crema vellutata, a base di panna e pomodoro, per rilasciarla ad ogni assaggio! Noi abbiamo scelto di arricchire la crema con del prosciutto cotto, ma le varianti sono tantissime: è possibile utilizzare lo speck o optare per una versione completamente diversa utilizzando cubetti di pesce o calamari! Noi vi consigliamo di provarle tutte e scegliere quella che fa per voi! ',4,2454.4,'',''),(30,69,4,'Delizie foresta nera',4,60,'Tra le tante prelibatezze della costiera amalfitana ecco una ricetta golosa creata dal pasticcere campano Carmine Marzuillo nel 1978: le delizie ovvero soffici cupole morbide come il pan di spagna che racchiudono un cremoso ripieno e hanno una ricopertura golosa. \nLa ricetta originale è quella delle delizie al limone ma noi vogliamo proporvi una variante altrettanto gustosa e raffinata che si ispira alla tradizionale torta omonima: le delizie foresta nera, farcite con una crema di yogurt arricchita con succulenti amarene sciroppate. \nLe delizie foresta nera sono un dessert al quale è difficile resistere e per realizzarle vi basterà seguire la nostra ricetta!',5,1472,'Difficilissima!!!',''),(31,69,3,'Scaloppine ai funghi',2,30,'Le scaloppine sono un secondo piatto semplice da realizzare ed estremamente gustoso! In questa ricetta vi proponiamo una variante delle classiche scaloppine al limone: le scaloppine ai funghi! Un appetitoso e saporito secondo piatto a base di carne, completo di contorno con i profumi del sottobosco... un classico che vi permette di dare un tocco raffinato ai vostri menu in modo semplice ma soprattutto in poco tempo. Per questa ricetta abbiamo scelto funghi polposi e molto versatili: i funghi Champignon crema, un perfetto accompagnamento per le fettine di vitello che, come vuole la ricetta tradizionale, vengono sapientemente dorate in padella per creare quella appetitosa crosticina dorata che rende questo piatto irresistibile. Le scaloppine con i funghi saranno la carta vincente dei vostri menu più sfiziosi, e non dimenticate di stappare un buon vino!',4,1164.5,'','Mancano alcuni ingredienti!'),(32,69,3,'Orata al forno',3,55,'Ogni volta che vi trovate davanti al banco del pesce ve ne andate sconsolati perché non sapete mai come cucinarlo? Dovete organizzare una cenetta intima e scartate a priori i piatti di pesce per paura delle temutissime lische? Niente paura: pulire e cuocere il pesce è più facile di quanto pensiate! Se poi il pesce è una saporitissima orata farete un figurone con i vostri ospiti. Magari potete cominciare con un piatto di pasta. Scegliendo per esempio l\'armonia tra mare e monti grazie al condimento di pesto di pistacchi, gamberi e pomodori che abbiamo fatto per la pasta senza glutine! L’orata al forno è un secondo piatto di pesce semplice da preparare, per gustare tutto il buono del pesce esaltato dal profumo di limone e delle erbe aromatiche che lo impreziosiscono in cottura. Accompagnata con gustose patate, l’orata al forno è ideale per una cena o un pranzo importanti, dove il gusto si sposa con la leggerezza. Cosa state aspettando? Mettete da parte i dubbi: una volta portata in tavola non potrete che ricevere i complimenti dei vostri commensali!',2,1253.15,'Nessuna','');
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
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES (1,'Gianmattia','Gherardi','admin','$2y$10$HhNbqwNnO/7X.3/pFg0R3OS4p6a5JiW4hx0dMinaKIc3jhA.GTRNq'),(8,'Mario','Rossi','visitatore1','$2y$10$OtI5mZz9tSfRfOk9zyYDLu6MED/ATkNERbvYat3WDO5sGsVMWF1vC'),(66,'Luigi','Verdi','visitatore2','$2y$10$XonoHcS8Yo6olVJNEzOyp.ETUiGURtO.9hNCeBoVaFTuCRE6u39ka'),(69,'Clara','Bruno','visitatore3','$2y$10$xGhsTZlx6ucrLOYNX5X7XewDOJ9YItKBGR4SSC2FlnZuF3LzJ5oPm'),(85,'Miranda','Manna','Redattore1','$2y$10$EtXwmxGu//dLXsy4CO73bOVdYf.7cIuzntIbJ8Oam4rvcY1mqsVqu');
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
/*!50001 VIEW `abstract_ricette` AS select `r`.`id_ricetta` AS `id_ricetta`,`r`.`titolo_ricetta` AS `titolo_ricetta`,`r`.`difficolta` AS `difficolta`,`r`.`calorie_totali` AS `calorie_totali`,`r`.`preparazione` AS `preparazione`,`sa`.`codice_stato_approvativo` AS `codice_stato_approvativo` from ((`ricetta` `r` join `flusso_approvativo` `fa` on((`fa`.`id_ricetta` = `r`.`id_ricetta`))) join `stato_approvativo` `sa` on((`fa`.`id_stato_approvativo` = `sa`.`id_stato_approvativo`))) */;
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

-- Dump completed on 2018-10-27 21:46:31
