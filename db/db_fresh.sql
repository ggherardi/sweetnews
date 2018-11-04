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
-- Temporary table structure for view `carrello_ricette`
--

DROP TABLE IF EXISTS `carrello_ricette`;
/*!50001 DROP VIEW IF EXISTS `carrello_ricette`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `carrello_ricette` (
  `id_utente` tinyint NOT NULL,
  `id_ricetta` tinyint NOT NULL,
  `calorie_totali` tinyint NOT NULL,
  `titolo_ricetta` tinyint NOT NULL
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
  `liberatoria` tinyint(4) NOT NULL,
  PRIMARY KEY (`id_dettaglio_utente_esterno`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `fk_dettaglio_utente_esterno_utente_idx` (`id_utente`),
  CONSTRAINT `fk_dettaglio_utente_esterno_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `fk_flusso_approvativo_ricetta` FOREIGN KEY (`id_ricetta`) REFERENCES `ricetta` (`id_ricetta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flusso_approvativo_stato_approvativo` FOREIGN KEY (`id_stato_approvativo`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flusso_approvativo_utente_approvatore` FOREIGN KEY (`id_utente_approvatore`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flusso_approvativo_utente_creatore` FOREIGN KEY (`id_utente_creatore`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
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
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
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
-- Table structure for table `ricetta_salvata`
--

DROP TABLE IF EXISTS `ricetta_salvata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ricetta_salvata` (
  `id_utente` int(11) NOT NULL,
  `id_ricetta` int(11) NOT NULL,
  PRIMARY KEY (`id_utente`,`id_ricetta`),
  KEY `fk_lista_ricerche_ricetta_idx` (`id_ricetta`),
  CONSTRAINT `fk_ricetta_salvata_ricetta` FOREIGN KEY (`id_ricetta`) REFERENCES `ricetta` (`id_ricetta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ricetta_salvata_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`id_stato_approvativo`),
  KEY `fk_stato_stato_precedente_idx` (`id_stato_approvativo_precedente`),
  KEY `fk_stato_stato_valutazione_idx` (`id_stato_approvativo_valutazione`),
  KEY `fk_stato_stato_approvazione_idx` (`id_stato_approvativo_approvazione`),
  KEY `fk_stato_stato_rifiuto_idx` (`id_stato_approvativo_rifiuto`),
  CONSTRAINT `fk_stato_stato_approvazione` FOREIGN KEY (`id_stato_approvativo_approvazione`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_stato_stato_precedente` FOREIGN KEY (`id_stato_approvativo_precedente`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_stato_stato_rifiuto` FOREIGN KEY (`id_stato_approvativo_rifiuto`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_stato_stato_valutazione` FOREIGN KEY (`id_stato_approvativo_valutazione`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRecipe`(IN idRicetta INT, IN idUtente INT)
BEGIN
	DELETE FROM flusso_approvativo_audit WHERE id_ricetta = idRicetta AND id_utente_creatore = idUtente;
    DELETE FROM flusso_approvativo WHERE id_ricetta = idRicetta AND id_utente_creatore = idUtente;
    DELETE FROM lista_ingredienti WHERE id_ricetta = idRicetta;
	DELETE FROM ricetta WHERE id_ricetta = idRicetta AND id_utente = idUtente;
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
-- Final view structure for view `carrello_ricette`
--

/*!50001 DROP TABLE IF EXISTS `carrello_ricette`*/;
/*!50001 DROP VIEW IF EXISTS `carrello_ricette`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `carrello_ricette` AS select `rs`.`id_utente` AS `id_utente`,`ri`.`id_ricetta` AS `id_ricetta`,`ri`.`calorie_totali` AS `calorie_totali`,`ri`.`titolo_ricetta` AS `titolo_ricetta` from (`ricetta_salvata` `rs` join `ricetta` `ri` on((`rs`.`id_ricetta` = `ri`.`id_ricetta`))) */;
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

-- Dump completed on 2018-11-04 14:53:41
