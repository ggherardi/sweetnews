<?php
include_once 'DBConnection.php';
include_once 'TokenGenerator.php';
include_once 'Constants.php';

$GLOBALS["CorrelationID"] = uniqid("corrId_", true);
$correlationId = $GLOBALS["CorrelationID"];

class AccountsApi {
    private $dbContext;
    private $loginContext;

    function __construct() { }

    /** Metodo per eseguire le Query. Utilizza la classe ausiliare DBConnection */
    private function ExecuteQuery($query = "") {        
        if($this->dbContext == null) {
            $this->dbContext = new DBConnection();
        }
        return $this->dbContext->ExecuteQuery($query);
    }

    public function GetUsersAccounts() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::CAPOREDATTORE), "delega_codice"); 
            $query = 
                "SELECT * 
                FROM deleghe_utente";
            $this->dbContext->PrepareStatement($query);
            $res = $this->dbContext->ExecuteStatement();
            $array = array();
            while($row = $res->fetch_assoc()) {
                Logger::Write("ROW: ".json_encode($row), $GLOBALS["CorrelationID"]);
                $identity = new AccountIdentity($row);
                if(!$array[$row["id_utente"]]) {
                    $user = new User($row);                   
                    $array[$row["id_utente"]]["account"][] = $user;
                    Logger::Write("USER: ".json_encode($array), $GLOBALS["CorrelationID"]);
                }
                $array[$row["id_utente"]]["deleghe"][] = $identity;       
            }
            exit(json_encode(array_values($array)));
        } 
        catch (Throwable $ex) {          
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);                     
            http_response_code(500); 
        }
    }

    function Init(){
        $this->dbContext = new DBConnection();
        $this->loginContext = json_decode(TokenGenerator::ValidateToken());
        if(!$this->loginContext) {
            Logger::Write("LoginContext is not valid, exiting scope.", $GLOBALS["CorrelationID"]);
            exit(false);
        }
        switch($_POST["action"]) {
            case "getUsersAccounts":
                self::GetUsersAccounts();
                break;
            default: 
                exit(json_encode($_POST));
                break;
        }
    }
}

// Inizializza la classe per restituire i risultati e richiama il metodo d'ingresso
try {
    Logger::Write("Reached AccountsApi", $GLOBALS["CorrelationID"]);    
    $Auth = new AccountsApi();
    $Auth->Init();
}
catch(Throwable $ex) {
    Logger::Write("Error occured: $ex", $GLOBALS["CorrelationID"]);
    http_response_code(500);
    exit(json_encode($ex->getMessage()));
}


class User {
    public $id_utente;
    public $cognome;
    public $username;
    public $nome;

    public function __construct($row) {
        $this->id_utente = $row["id_utente"];
        $this->username = $row["username"];
        $this->nome = $row["nome"];
        $this->cognome = $row["cognome"];
    }
}

class AccountIdentity {
    public $delega_codice;
    public $delega_nome;

    public function __construct($row) {
        $this->delega_codice = $row["delega_codice"];
        $this->delega_nome = $row["delega_nome"];
    }
}


?>