<?php
include_once 'DBConnection.php';
include_once 'TokenGenerator.php';
include_once "Constants.php";

$GLOBALS["CorrelationID"] = uniqid("corrId_", true);
$correlationId = $GLOBALS["CorrelationID"];

class AuthenticationApi {
    private $dbContext;

    function __construct() { }
    
    public function RegisterUser() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            $registrationForm = json_decode($_POST["registrationForm"]);
            $this->dbContext->StartTransaction();
            $query = 
                "INSERT INTO utente
                (nome, cognome, username, password)
                VALUES
                (?, ?, ?, ?)";
            $this->dbContext->PrepareStatement($query);
            $hashedPassword = password_hash($registrationForm->password, PASSWORD_DEFAULT);     
            $this->dbContext->BindStatementParameters("ssss", array($registrationForm->nome, $registrationForm->cognome, $registrationForm->username, $hashedPassword));
            $this->dbContext->ExecuteStatement();

            $insertId = $this->dbContext->GetLastID();
            $query = 
                "INSERT INTO delega
                (id_tipo_delega, id_utente)
                VALUES
                ((SELECT id_tipo_delega FROM tipo_delega WHERE delega_codice = ?), ?)";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dd", array(PermissionsConstants::VISITATORE, $insertId));
            $this->dbContext->ExecuteStatement();

            $query = 
                "INSERT INTO dettaglio_utente_esterno
                (id_utente, indirizzo, telefono_abitazione, telefono_cellulare, email, data_nascita, liberatoria)
                VALUES
                (?, ?, ?, ?, ?, ?, ?)";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dssssss", array($insertId, $registrationForm->indirizzo, $registrationForm->telefono_abitazione,
                $registrationForm->telefono_cellulare, $registrationForm->email, $registrationForm->data_nascita, ($fileData != null ? "'$fileData'" : "DEFAULT")));
            $this->dbContext->ExecuteStatement();   

            $this->dbContext->CommitTransaction();
            exit(true);
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
    
    /** Controlla se il nome esiste durante il form di registrazione  */
    public function AsyncCheckUsernameValidity() {
        Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
        $username = $_POST["username"];
        $query = "SELECT username FROM utente WHERE username = ?";
        $this->dbContext->PrepareStatement($query);
        $this->dbContext->BindStatementParameters("s", array($username));
        $res = $this->dbContext->ExecuteStatement();
        if($res) {
            $row = $res->fetch_assoc();
        }
        Logger::Write("RESULT " .json_encode($row), $GLOBALS["CorrelationID"]);
        exit($row);
    }

    /** Effettua il login al sito con l'username inserito */
    public function Login($credentials) {             
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            $credentials = json_decode($_POST["credentials"]);
            $query = 
                "SELECT ut.id_utente, ut.nome, ut.username, ut.password, td.delega_nome, td.delega_codice
                FROM utente as ut
                INNER JOIN delega as de
                ON de.id_utente = ut.id_utente
                INNER JOIN tipo_delega as td
                ON de.id_tipo_delega = td.id_tipo_delega
                WHERE username = ?";

            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("s", array($credentials->username));
            $res = $this->dbContext->ExecuteStatement();
            $identities = array(); 
            while($row = $res->fetch_assoc()) {
                $uniqueRow = $row;
                $fetchedPassword = $row["password"];
                $identity =  new Identity($row);
                $identities[] = $identity;
            }
            $identitiesCount = count($identities);
            if($identitiesCount == 0) {
                http_response_code(480); // username not found (code 480: i made it up)
                exit();
            }
            if(password_verify($credentials->password, $fetchedPassword)) {   
                if($identitiesCount > 1) {
                    Logger::Write(sprintf("%d identities found for user %s", $identitiesCount, $credentials->username), $GLOBALS["CorrelationID"]);       
                    exit(json_encode($identities));
                } else {
                    self::FinalizeLogin($uniqueRow);
                }
            }
            else{
                http_response_code(401);                
            }
        } 
        catch (Throwable $ex) {
            Logger::Write("Error occured in " . __FUNCTION__. " -> $ex", $GLOBALS["CorrelationID"]);
            http_response_code(500); 
        }
    }

    public function GetDetailsForUser($row) {
        Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
        $id_utente = isset($row) ? $row["id_utente"] : $_POST["id_utente"];
        $delega_codice = isset($row) ? $row["delega_codice"] : $_POST["delega_codice"];
        $query = 
            "SELECT *
            FROM utente as ut
            INNER JOIN delega as de
            ON de.id_utente = ut.id_utente
            INNER JOIN tipo_delega as td
            ON de.id_tipo_delega = td.id_tipo_delega
            %s %s";
        $tableJoin = sprintf("INNER JOIN %s du ON ut.id_utente = du.id_utente", 
            $delega_codice == PermissionsConstants::VISITATORE 
                ? "dettaglio_utente_esterno" 
                : "dettaglio_utente_interno");      
        $whereCondition = "WHERE ut.id_utente = ? AND td.delega_codice = ?";
        $query = sprintf($query, $tableJoin, $whereCondition);
        $this->dbContext->PrepareStatement($query);
        $this->dbContext->BindStatementParameters("dd", array($id_utente, $delega_codice));
        $res = $this->dbContext->ExecuteStatement();
        $row = $res->fetch_assoc();
        self::FinalizeLogin($row);        
    }

    private function FinalizeLogin($row) {
        $loginContext = new LoginContext($row);
        Logger::Write(sprintf("User %s validated, starting token generation.", $loginContext->username), $GLOBALS["CorrelationID"]);       
        self::SetAuthenticationCookie($loginContext);
        Logger::Write(sprintf("User %s succesfully logged in.", $loginContext->username), $GLOBALS["CorrelationID"]);
        exit(json_encode($loginContext));
    }

    private function SetAuthenticationCookie($cookieValue) {
        $cookie = TokenGenerator::GenerateTokenForUser($cookieValue);
        $cookieDuration = time() + (3600 * 12); // Scade in 12 ore
        setcookie(PermissionsConstants::COOKIE_NAME, $cookie, $cookieDuration, "/", "", false, true);
        Logger::Write("Authentication cookie has been set.", $GLOBALS["CorrelationID"]);
    }

    public function Logout() {
        $user = json_decode(TokenGenerator::ValidateToken());        
        Logger::Write(sprintf("User %s logging out.", $user->username), $GLOBALS["CorrelationID"]);
        setcookie(PermissionsConstants::COOKIE_NAME, "", time() - 1, "/", "", false, true);
    }

    public function AuthenticateUser() {             
        try {            
            exit(TokenGenerator::ValidateToken());
        } 
        catch (Throwable $ex) {
            Logger::Write("Error occured in " . __FUNCTION__. " -> $ex", $GLOBALS["CorrelationID"]);
        }
    }

    // Switcha l'operazione richiesta lato client
    function Init(){
        $this->dbContext = new DBConnection();
        switch($_POST["action"]) {
            case "registerUser":
                self::RegisterUser();
                break;
            case "asyncCheckUsernameValidity":
                self::AsyncCheckUsernameValidity();
                break;
            case "login":
                self::Login();
                break;
            case "getDetailsForUser":
                self::GetDetailsForUser(null);
                break;
            case "logout":
                self::Logout();
                break;
            case "authenticateUser":
                self::AuthenticateUser();
                break;
            default: 
                exit(json_encode($_POST));
                break;
        }
    }
}

// Inizializza la classe per restituire i risultati e richiama il metodo d'ingresso
try {
    Logger::Write("Reached AuthenticationApi", $GLOBALS["CorrelationID"]);    
    $Auth = new AuthenticationApi();
    $Auth->Init();
}
catch(Throwable $ex) {
    Logger::Write("Error occured: $ex", $GLOBALS["CorrelationID"]);
    http_response_code(500);
    exit(json_encode($ex->getMessage()));
}

class AuthenticationCookie {
    public $username;
    public $id_utente;
    public $delega_codice;

    public function __construct($row) {
        $this->username = $row["username"];
        $this->id_utente = $row["id_utente"];
        $this->delega_codice = $row["delega_codice"];
    }
}

class Identity {
    public $username;
    public $nome;
    public $id_utente;
    public $delega_codice;
    public $delega_nome;

    public function __construct($row) {
        $this->username = $row["username"];
        $this->nome = $row["nome"];
        $this->id_utente = $row["id_utente"];
        $this->delega_codice = $row["delega_codice"];
        $this->delega_nome = $row["delega_nome"];
    }
}

class Credentials {
    public $username;
    public $password;

    public function __construct($row) {
        $this->username = $row["username"];
        $this->password = $row["password"];
    }
}
?>