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
INSERT INTO `delega` VALUES (1,1),(3,1),(1,8),(1,66),(1,69);
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dettaglio_utente_esterno`
--

LOCK TABLES `dettaglio_utente_esterno` WRITE;
/*!40000 ALTER TABLE `dettaglio_utente_esterno` DISABLE KEYS */;
INSERT INTO `dettaglio_utente_esterno` VALUES (2,8,'Montione, Via Sergente Maggiore 25','0360 3499391','3495121835',' mariorossi@armyspy.com','1977-12-10',NULL),(3,1,'Roma, Largo Giuseppe Veratti 37','06216581563 ','345641236','admin@admin.com','1986-10-04',NULL),(5,66,'Roma, Via dei Gracchi 37','068463123','3158633125','luigiverdi@spyarmi.com','1988-01-29',NULL),(8,69,'','','3205467','ClaraBruno@rhyta.com','1958-07-25','DEFAULT');
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flusso_approvativo`
--

LOCK TABLES `flusso_approvativo` WRITE;
/*!40000 ALTER TABLE `flusso_approvativo` DISABLE KEYS */;
INSERT INTO `flusso_approvativo` VALUES (18,1,NULL,2,20,'2018-10-17 21:18:26'),(22,1,NULL,1,24,'2018-10-18 10:02:44');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flusso_approvativo_audit`
--

LOCK TABLES `flusso_approvativo_audit` WRITE;
/*!40000 ALTER TABLE `flusso_approvativo_audit` DISABLE KEYS */;
INSERT INTO `flusso_approvativo_audit` VALUES (3,18,1,20,1,0,'2018-10-17 21:18:26'),(7,22,1,24,1,0,'2018-10-18 10:02:44'),(15,18,2,20,1,NULL,'2018-10-17 21:18:26');
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
) ENGINE=InnoDB AUTO_INCREMENT=390 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingrediente`
--

LOCK TABLES `ingrediente` WRITE;
/*!40000 ALTER TABLE `ingrediente` DISABLE KEYS */;
INSERT INTO `ingrediente` VALUES (223,'Banana',89),(224,'Melograno',83),(225,'Zenzero',80),(226,'Fichi',74),(227,'Uva',69),(228,'Ciliegie',63),(229,'Kiwi',61),(230,'Mango',60),(231,'Pera',58),(232,'Mirtilli',57),(233,'Mandarini',53),(234,'Mela',52),(235,'Lamponi',52),(236,'Ananas',50),(237,'Albicocche',48),(238,'Arance',47),(239,'Prugne',46),(240,'More',43),(241,'Pompelmo',42),(242,'Pesca',39),(243,'Melone',34),(244,'Fragole',32),(245,'Anguria',30),(246,'Limone',29),(247,'Melone giallo',28),(248,'Macadamia',718),(249,'Pinoli',673),(250,'Nocciole',628),(251,'Pistacchi',601),(252,'Anacardi',598),(253,'Noci',582),(254,'Arachidi',571),(255,'Sesamo',573),(256,'Mandorle dolci',542),(257,'Castagne',189),(258,'Cocco',604),(259,'Uva',283),(260,'Banana',270),(261,'Datteri',253),(262,'Fichi',242),(263,'Prugne',240),(264,'Albicocche',188),(265,'Lupini secchi',371),(266,'Ceci secchi',364),(267,'Lenticchie secche',353),(268,'Fagioli secchi',291),(269,'Avocado',160),(270,'Aglio',149),(271,'Soia',122),(272,'Fave',88),(273,'Mais crudo',86),(274,'Patata dolce',86),(275,'Fagioli borlotti in scatola',83),(276,'Piselli',81),(277,'Patate',77),(278,'Porro',61),(279,'Carciofo',47),(280,'Barbabietola',43),(281,'Carote',41),(282,'Cipolla',40),(283,'Broccoli',34),(284,'Finocchio',31),(285,'Fagiolini',31),(286,'Rape',28),(287,'Zucca',26),(288,'Cavolfiore',25),(289,'Rucola',25),(290,'Melanzana',24),(291,'Peperoni',24),(292,'Spinaci',23),(293,'Funghi',22),(294,'Zucchina',21),(295,'Pomodori',20),(296,'Asparago',20),(297,'Lattuga',17),(298,'Ravanelli',16),(299,'Cetriolo',16),(300,'Lardo',902),(301,'Salame',392),(302,'Salsiccia',339),(303,'Costina di maiale',277),(304,'Wurstel',230),(305,'Prosciutto cotto',215),(306,'Manzo macinato',212),(307,'Prosciutto crudo',195),(308,'Tacchino',160),(309,'Prosciutto crudo magro',147),(310,'Vitello',144),(311,'Manzo magro',140),(312,'Coniglio',136),(313,'Anatra',136),(314,'Coscia di pollo',130),(315,'Cervo',120),(316,'Maiale filetto',110),(317,'Agnello',109),(318,'Petto di tacchino',111),(319,'Petto di pollo',100),(320,'Salmone',179),(321,'Sgombro',163),(322,'Trota',148),(323,'Trota salmonata',141),(324,'Salmone affumicato',117),(325,'Orata',105),(326,'Gamberi',105),(327,'Tonno',103),(328,'Branzino',97),(329,'Cozze',86),(330,'Vongole',86),(331,'Polpo',82),(332,'Seppie',79),(333,'Gamberetti',71),(334,'Olio Extravergine',884),(335,'Burro',717),(336,'Olio di semi',884),(337,'Grana',392),(338,'Seitain',370),(339,'Emmental',357),(340,'Mozzarella',254),(341,'Tempeh',193),(342,'Hamburger di soia',154),(343,'Tofu',145),(344,'Uova',143),(345,'Ricotta',138),(346,'Yogurt alla frutta',109),(347,'Yogurt greco',96),(348,'Fiocchi di latte',87),(349,'Latte intero',61),(350,'Yogurt greco 0%',57),(351,'Latte di soia',54),(352,'Yogurt di soia',50),(353,'Latte di avena',44),(354,'Yogurt magro',41),(355,'Latte parzialmente Scremato',40),(356,'Latte scremato',34),(357,'Avena',389),(358,'Miglio',378),(359,'Pasta di semola',371),(360,'Amaranto',371),(361,'Farina di mais',365),(362,'Quinoa',364),(363,'Frumento tipo 0',361),(364,'Riso',358),(365,'Orzo',354),(366,'Grano saraceno',343),(367,'Segale',338),(368,'Farro',335),(369,'Gocciole',477),(370,'Oro Saiwa',425),(371,'Brioches',390),(372,'Pizza',301),(373,'Patatine fritte',299),(374,'Pane tipo 0',271),(375,'Big Mac',232),(376,'Coca Cola',42),(377,'Limoncello',343),(378,'Whisky',250),(379,'Vodka',231),(380,'Vino rosso',84),(381,'Vino bianco',82),(382,'Birra rossa',63),(383,'Spritz',50),(384,'Birra',43),(387,'Pasta all\'uovo',410),(388,'Sale',0),(389,'Pepe',0);
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
INSERT INTO `lista_ingredienti` VALUES (270,20,0.5),(277,24,2),(282,20,1),(282,24,1),(294,24,2),(295,20,2),(337,20,0.2),(344,24,4),(359,20,2),(388,20,0.1),(388,24,0.1),(389,20,0.1),(389,24,0.1);
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
  `messaggio` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_ricetta`),
  KEY `fk_ricetta_utente_idx` (`id_utente`),
  KEY `fk_ricetta_tipologia_idx` (`id_tipologia`),
  CONSTRAINT `fk_ricetta_tipologia` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologia` (`id_tipologia`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ricetta_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ricetta`
--

LOCK TABLES `ricetta` WRITE;
/*!40000 ALTER TABLE `ricetta` DISABLE KEYS */;
INSERT INTO `ricetta` VALUES (20,1,2,'Pasta al sugo',1,35,'Tagliare tutto, mettere a soffriggere, buttare acqua, far saltare in padella e condire bene bene!',2,'Nessuna nota','Aggiungere pasta all\'uovo'),(24,1,3,'Frittata',2,50,'Mettere a soffriggere cipolla, zucchine e patate. Sbattere in una ciotola le uova. Dopo aver lasciato appassire le verdure, versare le uova nella padella. Lasciare cuocere per 30 minuti a fuoco basso rigirando a metà cottura.',4,'','');
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
-- Table structure for table `stato_approvativo`
--

DROP TABLE IF EXISTS `stato_approvativo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stato_approvativo` (
  `id_stato_approvativo` int(11) NOT NULL AUTO_INCREMENT,
  `id_stato_approvativo_precedente` int(11) DEFAULT NULL,
  `codice_stato_approvativo` int(11) NOT NULL,
  `nome_stato_approvativo` varchar(45) NOT NULL,
  `stato_approvativo_isLeaf` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_stato_approvativo`),
  KEY `fk_stato_stato_precedente_idx` (`id_stato_approvativo_precedente`),
  CONSTRAINT `fk_stato_stato_precedente` FOREIGN KEY (`id_stato_approvativo_precedente`) REFERENCES `stato_approvativo` (`id_stato_approvativo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stato_approvativo`
--

LOCK TABLES `stato_approvativo` WRITE;
/*!40000 ALTER TABLE `stato_approvativo` DISABLE KEYS */;
INSERT INTO `stato_approvativo` VALUES (1,NULL,0,'bozza',0),(2,1,5,'inviata',0),(3,2,10,'in validazione',0),(4,2,15,'non idonea',1),(5,2,20,'idonea',0),(6,5,25,'in approvazione',0),(7,5,30,'non approvata',1),(8,5,35,'approvata',0);
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
  `stato_approvativo_isLeaf` tinyint NOT NULL
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
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES (1,'Gianmattia','Gherardi','admin','$2y$10$HhNbqwNnO/7X.3/pFg0R3OS4p6a5JiW4hx0dMinaKIc3jhA.GTRNq'),(8,'Mario','Rossi','visitatore1','$2y$10$OtI5mZz9tSfRfOk9zyYDLu6MED/ATkNERbvYat3WDO5sGsVMWF1vC'),(66,'Luigi','Verdi','visitatore2','$2y$10$XonoHcS8Yo6olVJNEzOyp.ETUiGURtO.9hNCeBoVaFTuCRE6u39ka'),(69,'Clara','Bruno','visitatore3','$2y$10$xGhsTZlx6ucrLOYNX5X7XewDOJ9YItKBGR4SSC2FlnZuF3LzJ5oPm');
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
/*!50001 VIEW `stato_flusso_approvativo` AS select `fa`.`id_flusso_approvativo` AS `id_flusso_approvativo`,`fa`.`id_utente_creatore` AS `id_utente_creatore`,`fa`.`id_utente_approvatore` AS `id_utente_approvatore`,`fa`.`id_ricetta` AS `id_ricetta`,`fa`.`data_flusso` AS `data_flusso`,`sa`.`codice_stato_approvativo` AS `codice_stato_approvativo`,`sa`.`nome_stato_approvativo` AS `nome_stato_approvativo`,`sa`.`id_stato_approvativo` AS `id_stato_approvativo`,`sa`.`id_stato_approvativo_precedente` AS `id_stato_approvativo_precedente`,`sa`.`stato_approvativo_isLeaf` AS `stato_approvativo_isLeaf` from (`flusso_approvativo` `fa` join `stato_approvativo` `sa` on((`fa`.`id_stato_approvativo` = `sa`.`id_stato_approvativo`))) */;
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

-- Dump completed on 2018-10-20  1:34:18
