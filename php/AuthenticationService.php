<?php
include 'DBConnection.php';
include 'TokenGenerator.php';
include 'Constants.php';
use TokenGenerator;
use Logger;

$GLOBALS["CorrelationID"] = uniqid("corrId_", true);
$correlationId = $GLOBALS["CorrelationID"];

class AuthenticationService {
    private static $authCookieName = "RentNetAuth";
    private $dbContext;

    function __construct() { }

    /** Metodo per eseguire le Query. Utilizza la classe ausiliare DBConnection */
    private function ExecuteQuery($query = "") {        
        if($this->dbContext == null) {
            $this->dbContext = new DBConnection();
        }
        return $this->dbContext->ExecuteQuery($query);
    }

    public function RegisterUser() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            $registrationForm = json_decode($_POST["registrationForm"]);
            $this->dbContext->StartTransaction();
            $query = 
                "INSERT INTO utente
                (nome, cognome, username, password)
                VALUES
                (%s, %s, %s, %s)";
            $hashedPassword = password_hash($registrationForm->password, PASSWORD_DEFAULT);     
            $query = sprintf($query, self::GetSlashedValueOrDefault($registrationForm->nome), self::GetSlashedValueOrDefault($registrationForm->cognome), 
            self::GetSlashedValueOrDefault($registrationForm->username), self::GetSlashedValueOrDefault($hashedPassword));
            $res = self::ExecuteQuery($query);
            $insertId = $this->dbContext->GetLastID();
            $query = 
            "INSERT INTO delega
            (id_tipo_delega, id_utente)
            VALUES
            ((SELECT id_tipo_delega FROM tipo_delega WHERE delega_codice = %d), %d)";
            $query = sprintf($query, PermissionsConstants::VISITATORE, $insertId);
            $res = self::ExecuteQuery($query);
            if(count($_FILES) > 0) {
                $fileData = self::GetFileData();
            }
            $query = 
            "INSERT INTO dettaglio_utente_esterno
            (id_utente, indirizzo, telefono_abitazione, telefono_cellulare, email, data_nascita, liberatoria)
            VALUES
            (%d, %s, %s, %s, %s, %s, %s)";
            $query = sprintf($query, $insertId, self::GetSlashedValueOrDefault($registrationForm->indirizzo), self::GetSlashedValueOrDefault($registrationForm->telefono_abitazione), 
                self::GetSlashedValueOrDefault($registrationForm->telefono_cellulare), self::GetSlashedValueOrDefault($registrationForm->email),
                self::GetSlashedValueOrDefault($registrationForm->data_nascita), ($fileData != null ? "'$fileData'" : "DEFAULT"));
            $res = self::ExecuteQuery($query);
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
            }            
        }
    }
    
    /**  */
    public function AsyncCheckUsernameValidity() {
        Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
        $username = $_POST["username"];
        $this->dbContext->StartTransaction();
        $query = 
            "SELECT username FROM utente WHERE username = %s";
        $query = sprintf($query, self::GetSlashedValueOrDefault($username));
        $res = self::ExecuteQuery($query);
        $row = $res->fetch_assoc();
        exit($row);
    }

    /** Effettua il login al sito con l'username inserito */
    public function Login() {             
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
                WHERE username = %s";
            $query = sprintf($query, self::GetSlashedValueOrDefault($credentials->username));
            $res = self::ExecuteQuery($query);
            $identities = array(); 
            while($row = $res->fetch_assoc()) {
                $fetchedPassword = $row["password"];
                $identity =  new Identity($row);
                $identities[] = $identity;
            }
            $identitiesCount = count($identities);
            if($identitiesCount == 0) {
                http_response_code(480); // username not found (i made it up)
                exit();
            }
            if(password_verify($credentials->password, $fetchedPassword)) {   
                if($identitiesCount > 1) {
                    Logger::Write(sprintf("%d identities found for user %s", $identitiesCount, self::GetSlashedValueOrDefault($credentials->username)), $GLOBALS["CorrelationID"]);       
                    exit(json_encode($identities));
                } else {
                    self::FinalizeLogin($row);
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
        $identities = $_POST["identities"];
        $id_utente = isset($row) ? $row["id_utente"] : $_POST("id_utente");
        $delega_codice = isset($row) ? $row["delega_codice"] : $_POST("delega_codice");
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
        $whereCondition = sprintf("WHERE id_utente = %d", $id_utente);
        $query = sprintf($query, $tableJoin, $whereCondition);
        $res = self::ExecuteQuery($query);
        $row = $res->fetch_assoc();
        self::FinalizeLogin($row);        
    }

    private function FinalizeLogin($row) {
        $loginContext = new LoginContext($row);
        Logger::Write(sprintf("User %s validated, starting token generation.", $loginContext->username), $GLOBALS["CorrelationID"]);       
        self::SetAuthenticationCookie($loginContext);
        Logger::Write("User $this->username succesfully logged in.", $GLOBALS["CorrelationID"]);
        exit(json_encode($loginContext));
    }
    // private function GetFileData() {
    //     $filename = $_FILES['file']['tmp_name'];
    //     $file = readfile($_FILES['file']['tmp_name']);
    //     $filePointer = fopen($_FILES['file']['tmp_name'], 'rb');
    //     $fileData = fread($filePointer, filesize($_FILES['file']['tmp_name']));
    //     $fileData = addslashes($fileData);
    //     return $fileData;
    // }

    private function SetAuthenticationCookie($cookieValue) {
        $cookie = TokenGenerator::GenerateTokenForUser($cookieValue);
        $cookieDuration = time() + (3600 * 12); // Scade in 12 ore
        setcookie(self::$authCookieName, $cookie, $cookieDuration, "/", "", false, true);
        Logger::Write("Authentication cookie has been set: ".$_COOKIE[self::$authCookieName], $GLOBALS["CorrelationID"]);
    }

    public function Logout() {
        $user = json_decode(TokenGenerator::ValidateToken());
        Logger::Write(sprintf("User %s logging out.", $user->username), $GLOBALS["CorrelationID"]);
        setcookie(self::$authCookieName, "", time() - 1, "/", "", false, true);
    }

    public function AuthenticateUser() {             
        try {            
            exit(TokenGenerator::ValidateToken());
        } 
        catch (Throwable $ex) {
            Logger::Write("Error occured in " . __FUNCTION__. " -> $ex", $GLOBALS["CorrelationID"]);
        }
    }

    private function GetSlashedValueOrDefault($value) {
        $value = addslashes($value);
        return strlen($value) > 0 ? "'$value'" : "DEFAULT";
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
    Logger::Write("Reached AuthenticationService API", $GLOBALS["CorrelationID"]);    
    $Auth = new AuthenticationService();
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

class LoginContext {
    public $username;
    public $id_utente;
    public $delega_codice;
    public $delega_nome;
    public $matricola;
    public $indirizzo;
    public $telefono_abitazione;
    public $telefono_cellulare;
    public $email;
    public $data_nascita;

    public function __construct($row) {
        $this->username = $row["username"];
        $this->id_utente = $row["id_utente"];
        $this->delega_codice = $row["delega_codice"];
        $this->delega_nome = $row["delega_nome"];
        $this->matricola = $row["matricola"];
        $this->indirizzo = $row["indirizzo"];
        $this->telefono_abitazione = $row["telefono_abitazione"];
        $this->telefono_cellulare = $row["telefono_cellulare"];
        $this->email = $row["email"];
        $this->data_nascita = $row["data_nascita"];
    }
}
?>