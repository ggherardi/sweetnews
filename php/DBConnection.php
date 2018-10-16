<?php
include_once 'Logger.php';

class DBConnection {
    private $Connection;
    private $Statement;
    private $ServerName;
    private $UserName;
    private $Password;
    private $DB;

    //PROD
    //function __construct($servername = "127.0.0.1", $username = "newuser", $password = "password", $db = "videonoleggio") {
    //DEV
    function __construct($servername = "127.0.0.1", $username = "root", $password = "root", $db = "sweetnews") {
        $this->ServerName = $servername;
        $this->UserName = $username;
        $this->Password = $password;
        $this->DB = $db;
        $this->EstablishConnection();
    }

    private function getConnection(): mysqli {
        return $this->Connection;
    }

    private function getStatement(): mysqli_stmt {
        return $this->Statement;
 
    }

    private function EstablishConnection() {
        try {
            Logger::Write("Establishing connection to DB", $GLOBALS["CorrelationID"]);
            // $this->Connection = mysqli_connect($this->ServerName, $this->UserName, $this->Password, $this->DB);
            $this->Connection = new mysqli($this->ServerName, $this->UserName, $this->Password, $this->DB);
            if($this->Connection->connect_errno){
                Logger::Write(("Error while establishing a connection with the DB -> " . ($this->Connection->connect_error)), $GLOBALS["CorrelationID"]);
                throw new Exception("ERROR! ".$this->Connection->mysqli_error);
            }
        }
        catch (Throwable $ex) {
            $exMessage = $ex->getMessage();
            Logger::Write("Error while establishing a connection with the DB -> $exMessage", $GLOBALS["CorrelationID"]);
            http_response_code(500);
            exit(json_encode($exMessage));
        }
    }

    function PrepareStatement($query) {
        Logger::Write(sprintf("Preparing statement: %s", $query), $GLOBALS["CorrelationID"]);
        $this->Statement = $this->getConnection()->prepare($query);      
        if(!$this->Statement) {
            throw new Exception("An error occured while preparing the query.");            
        }
    }

    function BindStatementParameters($paramType, $parameters) {
        Logger::WriteWithParameters(sprintf("Binding parameters to statement: types: %s, values:", $paramType), $parameters, $GLOBALS["CorrelationID"]);
        $this->getStatement()->bind_param($paramType, ...$parameters);
    }

    function ExecuteStatement() {
        try {
            Logger::Write("Executing statement", $GLOBALS["CorrelationID"]);
            $this->getStatement()->execute();  
            if(!$res) {     
                if($this->getStatement()->error){
                    Logger::Write("Error occured while executing statement -> ".$this->getStatement()->error, $GLOBALS["CorrelationID"]);
                    throw new Exception($this->getStatement()->errno);   
                }
                Logger::Write("No results found", $GLOBALS["CorrelationID"]);                
            }
            Logger::Write("Statement executed successfully", $GLOBALS["CorrelationID"]);
            return $this->getStatement()->get_result();
        }
        catch (Throwable $ex) {
            $exMessage = $ex->getMessage();
            Logger::Write("Error code -> [$ex]", $GLOBALS["CorrelationID"]);
            throw new Exception($exMessage);
        }
    }

    function StartTransaction() {
        Logger::Write("Starting transaction", $GLOBALS["CorrelationID"]);
        $this->getConnection()->begin_transaction();
    }

    function RollBack() {
        Logger::Write("Rolling back current transaction", $GLOBALS["CorrelationID"]);
        $this->getConnection()->rollback();
    }

    function CommitTransaction() {
        Logger::Write("Committing transaction", $GLOBALS["CorrelationID"]);
        $this->getConnection()->commit();
    }

    /** Ritorna il risultato della query. Se non sono stati trovati, la chiamata riesce e ritorna un array vuoto */
    function ExecuteQuery($query = "") {
        try {
            Logger::Write("Query: ".$query, $GLOBALS["CorrelationID"]);
            Logger::Write("Executing query", $GLOBALS["CorrelationID"]);
            // Logger::Write($query, $GLOBALS["CorrelationID"]);
            $msRes = $this->getConnection()->query($query);
            if(!$msRes) {     
                if($this->Connection->error){
                    Logger::Write("Error occured while executing query -> ".$this->Connection->error, $GLOBALS["CorrelationID"]);
                    throw new Exception($this->Connection->errno);   
                }
                Logger::Write("No results found", $GLOBALS["CorrelationID"]);                
            }
            Logger::Write("Query executed successfully", $GLOBALS["CorrelationID"]);
            return $msRes;
        } 
        catch (Throwable $ex) {
            $exMessage = $ex->getMessage();
            Logger::Write("Error code -> [$ex]", $GLOBALS["CorrelationID"]);
            throw new Exception($exMessage);
        }
    }

    function ExecuteMultiQuery($query = "") {
        try {
            Logger::Write("Executing multi query", $GLOBALS["CorrelationID"]);
            // Logger::Write($query, $GLOBALS["CorrelationID"]);
            $msRes = $this->getConnection()->multi_query($query);
            if(!$msRes) {     
                if($this->Connection->error){
                    throw new Exception($this->Connection->error);   
                }
                Logger::Write("No results found", $GLOBALS["CorrelationID"]);                
            }
            Logger::Write("Multi query executed successfully", $GLOBALS["CorrelationID"]);
            return $msRes;
        } 
        catch (Throwable $ex) {
            $exMessage = $ex->getMessage();
            Logger::Write("Error while executing multi query -> $exMessage", $GLOBALS["CorrelationID"]);
            throw $ex;
        }
    }

    function GetPublicConnection() {
        return $this->Connection;
    }

    function GetLastID() {
        return $this->Connection->insert_id;
    }
}
?>