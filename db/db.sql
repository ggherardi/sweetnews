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
INSERT INTO `delega` VALUES (1,1),(3,1),(1,8),(1,66);
/*!40000 ALTER TABLE `delega` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dettaglio_utente_esterno`
--

LOCK TABLES `dettaglio_utente_esterno` WRITE;
/*!40000 ALTER TABLE `dettaglio_utente_esterno` DISABLE KEYS */;
INSERT INTO `dettaglio_utente_esterno` VALUES (2,8,'Montione, Via Sergente Maggiore 25','0360 3499391','3495121835',' mariorossi@armyspy.com','1977-12-10',NULL),(3,1,'Roma, Largo Giuseppe Veratti 37','06216581563 ','345641236','admin@admin.com','1986-10-04',NULL),(5,66,'Roma, Via dei Gracchi 37','068463123','3158633125','luigiverdi@spyarmi.com','1988-01-29',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dettaglio_utente_interno`
--

LOCK TABLES `dettaglio_utente_interno` WRITE;
/*!40000 ALTER TABLE `dettaglio_utente_interno` DISABLE KEYS */;
INSERT INTO `dettaglio_utente_interno` VALUES (1,1);
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
  `id_utente` int(11) NOT NULL,
  `id_stato_approvativo` int(11) NOT NULL,
  `id_ricetta` int(11) NOT NULL,
  `data_flusso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_flusso_approvativo`),
  KEY `fk_flusso_approvativo_utente_idx` (`id_utente`),
  KEY `fk_flusso_approvativo_stato_approvativo_idx` (`id_stato_approvativo`),
  KEY `fk_flusso_approvativo_ricetta_idx` (`id_ricetta`),
  CONSTRAINT `fk_flusso_approvativo_ricetta` FOREIGN KEY (`id_ricetta`) REFERENCES `ricetta` (`id_ricetta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flusso_approvativo_stato_approvativo` FOREIGN KEY (`id_stato_approvativo`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flusso_approvativo_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flusso_approvativo`
--

LOCK TABLES `flusso_approvativo` WRITE;
/*!40000 ALTER TABLE `flusso_approvativo` DISABLE KEYS */;
/*!40000 ALTER TABLE `flusso_approvativo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flusso_approvativo_audit`
--

DROP TABLE IF EXISTS `flusso_approvativo_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flusso_approvativo_audit` (
  `id_flusso_approvativo_audit` int(11) NOT NULL AUTO_INCREMENT,
  `id_flusso_approvativo` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `id_ricetta` varchar(45) NOT NULL,
  `id_utente` varchar(45) NOT NULL,
  `data` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_flusso_approvativo_audit`),
  KEY `fk_flusso_approvativo_audit_flusso_approvativo_idx` (`id_flusso_approvativo`),
  CONSTRAINT `fk_flusso_approvativo_audit_flusso_approvativo` FOREIGN KEY (`id_flusso_approvativo`) REFERENCES `flusso_approvativo` (`id_flusso_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flusso_approvativo_audit`
--

LOCK TABLES `flusso_approvativo_audit` WRITE;
/*!40000 ALTER TABLE `flusso_approvativo_audit` DISABLE KEYS */;
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
  `calorie` int(11) NOT NULL,
  PRIMARY KEY (`id_ingrediente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingrediente`
--

LOCK TABLES `ingrediente` WRITE;
/*!40000 ALTER TABLE `ingrediente` DISABLE KEYS */;
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
  `quantita` int(11) NOT NULL,
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
  `preparazione` varchar(500) NOT NULL,
  `porzioni` int(11) NOT NULL,
  `note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_ricetta`),
  KEY `fk_ricetta_utente_idx` (`id_utente`),
  KEY `fk_ricetta_tipologia_idx` (`id_tipologia`),
  CONSTRAINT `fk_ricetta_tipologia` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologia` (`id_tipologia`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ricetta_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ricetta`
--

LOCK TABLES `ricetta` WRITE;
/*!40000 ALTER TABLE `ricetta` DISABLE KEYS */;
/*!40000 ALTER TABLE `ricetta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stato_approvativo`
--

DROP TABLE IF EXISTS `stato_approvativo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stato_approvativo` (
  `id_stato_approvativo` int(11) NOT NULL AUTO_INCREMENT,
  `codice_stato_approvativo` int(11) NOT NULL,
  `nome_stato_approvativo` varchar(45) NOT NULL,
  PRIMARY KEY (`id_stato_approvativo`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stato_approvativo`
--

LOCK TABLES `stato_approvativo` WRITE;
/*!40000 ALTER TABLE `stato_approvativo` DISABLE KEYS */;
INSERT INTO `stato_approvativo` VALUES (1,0,'bozza'),(2,10,'in approvazione'),(3,15,'non idonea'),(4,20,'idonea'),(5,25,'non approvata'),(6,30,'approvata');
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
  `id_utente` tinyint NOT NULL,
  `id_ricetta` tinyint NOT NULL,
  `data_flusso` tinyint NOT NULL,
  `codice_stato_approvativo` tinyint NOT NULL,
  `nome_stato_approvativo` tinyint NOT NULL
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipologia`
--

LOCK TABLES `tipologia` WRITE;
/*!40000 ALTER TABLE `tipologia` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES (1,'Gianmattia','Gherardi','admin','$2y$10$HhNbqwNnO/7X.3/pFg0R3OS4p6a5JiW4hx0dMinaKIc3jhA.GTRNq'),(8,'Mario','Rossi','visitatore1','$2y$10$OtI5mZz9tSfRfOk9zyYDLu6MED/ATkNERbvYat3WDO5sGsVMWF1vC'),(66,'Luigi','Verdi','visitatore2','$2y$10$XonoHcS8Yo6olVJNEzOyp.ETUiGURtO.9hNCeBoVaFTuCRE6u39ka');
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'sweetnews'
--

--
-- Dumping routines for database 'sweetnews'
--
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
/*!50001 VIEW `stato_flusso_approvativo` AS select `fa`.`id_flusso_approvativo` AS `id_flusso_approvativo`,`fa`.`id_utente` AS `id_utente`,`fa`.`id_ricetta` AS `id_ricetta`,`fa`.`data_flusso` AS `data_flusso`,`sa`.`codice_stato_approvativo` AS `codice_stato_approvativo`,`sa`.`nome_stato_approvativo` AS `nome_stato_approvativo` from (`flusso_approvativo` `fa` join `stato_approvativo` `sa` on((`fa`.`id_stato_approvativo` = `sa`.`id_stato_approvativo`))) */;
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

-- Dump completed on 2018-10-14 13:36:29
