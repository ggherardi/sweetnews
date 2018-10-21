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

    function GetUsersAccounts() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::CAPOREDATTORE), "delega_codice"); 
            $query = 
                "SELECT * 
                FROM ruoli_utente";
            $this->dbContext->PrepareStatement($query);
            $res = $this->dbContext->ExecuteStatement();
            $array = array();
            while($row = $res->fetch_assoc()) {
                $identity = new AccountIdentity($row);
                if(!$array[$row["id_utente"]]) {
                    $user = new User($row);                   
                    $array[$row["id_utente"]]["account"][] = $user;
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

    function GetUserAccount() {
        Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
        TokenGenerator::CheckPermissions(array(PermissionsConstants::CAPOREDATTORE), "delega_codice"); 
        $id_utente = $_POST["id_utente"];
        $query = 
            "SELECT *
            FROM dettagli_utente
            WHERE id_utente = ?";
        $this->dbContext->PrepareStatement($query);
        $this->dbContext->BindStatementParameters("d", array($id_utente)); 
        $res = $this->dbContext->ExecuteStatement();
        $account = $res->fetch_assoc();        

        $query = 
            "SELECT *
            FROM ruoli_utente
            WHERE id_utente = ?";
        $this->dbContext->PrepareStatement($query);
        $this->dbContext->BindStatementParameters("d", array($id_utente)); 
        $res = $this->dbContext->ExecuteStatement();
        while($row = $res->fetch_assoc()) {
            $account["deleghe"][] = $row;
        }

        exit(json_encode($account));
    }

    function GetBusinessRoles() {
        Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
        TokenGenerator::CheckPermissions(array(PermissionsConstants::CAPOREDATTORE), "delega_codice");
        $minimumRole = $_POST["delega_minima"];
        $query = 
            "SELECT *
            FROM tipo_delega
            %s";
        $query = sprintf($query, $minimumRole ? "WHERE delega_codice >= ?" : "");
        $this->dbContext->PrepareStatement($query);
        if($minimumRole) {            
            $this->dbContext->BindStatementParameters("d", array($minimumRole)); 
        }
        $res = $this->dbContext->ExecuteStatement();
        $array = array();
        while($row = $res->fetch_assoc()) {
            $array[] = $row;
        }
        exit(json_encode($array));
    }

    function CreateBusinessAccount() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            $accountEditForm = json_decode($_POST["accountNewForm"]);
            $this->dbContext->StartTransaction();
            Logger::Write("DELEGHE: ".json_encode($accountEditForm), $GLOBALS["CorrelationID"]);

            $query = 
                "INSERT INTO utente
                (nome, cognome, username, password)
                VALUES
                (?, ?, ?, ?)";
            $this->dbContext->PrepareStatement($query);
            $hashedPassword = password_hash($accountEditForm->password, PASSWORD_DEFAULT);     
            $this->dbContext->BindStatementParameters("ssss", array($accountEditForm->nome, $accountEditForm->cognome, $accountEditForm->username, $hashedPassword));
            $this->dbContext->ExecuteStatement();

            $insertId = $this->dbContext->GetLastID();
            $query = 
                "INSERT INTO delega
                (id_tipo_delega, id_utente)
                VALUES
                (?, ?)";
            $this->dbContext->PrepareStatement($query);
            for($i = 0; $i < count($accountEditForm->deleghe); $i++) {
                $this->dbContext->BindStatementParameters("dd", array($accountEditForm->deleghe[$i], $insertId));
                $this->dbContext->ExecuteStatement();
            }            

            $query = 
                "INSERT INTO dettaglio_utente_interno
                (id_utente)
                VALUES
                (?)";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("d", array($insertId));
            $this->dbContext->ExecuteStatement();   

            $this->dbContext->CommitTransaction();
            exit(json_encode($insertId));
        } 
        catch (Throwable $ex) {
            $this->dbContext->RollBack();            
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);
            switch($ex->getMessage()) {
                case 1062:
                    http_response_code(409);
                    break;
                default:
                    http_response_code(500); 
                    break;
            }            
        }
    }

    function EditBusinessAccount() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            $accountEditForm = json_decode($_POST["accountEditForm"]);
            $this->dbContext->StartTransaction();
            Logger::Write("DELEGHE: ".json_encode($accountEditForm), $GLOBALS["CorrelationID"]);

            $query = 
                "UPDATE utente
                SET 
                nome = ?,
                cognome = ?, 
                username = ?
                WHERE
                id_utente = ?";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("ssss", array($accountEditForm->nome, $accountEditForm->cognome, $accountEditForm->username, $accountEditForm->id_utente));
            $this->dbContext->ExecuteStatement();

            $insertId = $this->dbContext->GetLastID();
            $query = 
                "DELETE FROM delega
                WHERE 
                id_utente = ?
                AND id_tipo_delega IN (SELECT id_tipo_delega 
                                        FROM tipo_delega 
                                        WHERE delega_codice > ?)";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dd", array($accountEditForm->id_utente, PermissionsConstants::VISITATORE));
            $this->dbContext->ExecuteStatement();    

            if(count($accountEditForm->deleghe) > 0) {
                $insertId = $this->dbContext->GetLastID();
                $query = 
                    "INSERT INTO delega
                    (id_tipo_delega, id_utente)
                    VALUES
                    (?, ?)";
                $this->dbContext->PrepareStatement($query);
                for($i = 0; $i < count($accountEditForm->deleghe); $i++) {
                    $this->dbContext->BindStatementParameters("dd", array($accountEditForm->deleghe[$i], $accountEditForm->id_utente));
                    $this->dbContext->ExecuteStatement();
                }     
            }
         
            $this->dbContext->CommitTransaction();
            exit(json_encode(true));
        } 
        catch (Throwable $ex) {
            $this->dbContext->RollBack();            
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);
            switch($ex->getMessage()) {
                case 1062:
                    http_response_code(409);
                    break;
                default:
                    http_response_code(500); 
                    break;
            }            
        }
    }

    function Init(){
        $this->dbContext = new DBConnection();
        $this->loginContext = json_decode(TokenGenerator::ValidateToken());
        if(!$this->loginContext) {
            Logger::Write("LoginContext is not valid, exiting scope.", $GLOBALS["CorrelationID"]);
            http_response_code(401);
        }
        switch($_POST["action"]) {
            case "getUsersAccounts":
                self::GetUsersAccounts();
                break;
            case "getUserAccount":
                self::GetUserAccount();
                break;
            case "getBusinessRoles":
                self::GetBusinessRoles();
                break;
            case "createBusinessAccount":
                self::CreateBusinessAccount();
                break;
            case "editBusinessAccount":
                self::EditBusinessAccount();
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