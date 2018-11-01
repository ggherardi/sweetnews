<?php
include_once 'DBConnection.php';
include_once 'TokenGenerator.php';
include_once 'Constants.php';

$GLOBALS["CorrelationID"] = uniqid("corrId_", true);
$correlationId = $GLOBALS["CorrelationID"];

class RecipesApi {
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

    public function GetRecipesInCart() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE), "delega_codice");            
            $id_utente = $this->loginContext->id_utente;
            $query = 
                "SELECT *
                FROM carrello_ricette cr    
                WHERE cr.id_utente = ?";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("d", array($id_utente));
            $res = $this->dbContext->ExecuteStatement();
            $array = array();
            while($row = $res->fetch_assoc()) {
                $array[] = $row;
            }                            
            exit(json_encode($array));
        } 
        catch (Throwable $ex) {          
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);                     
            http_response_code(500); 
        }
    }

    public function AddRecipeToCart() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE), "delega_codice");  
            $id_ricetta = $_POST["id_ricetta"];          
            $id_utente = $this->loginContext->id_utente;
            $query = 
                "INSERT INTO ricetta_salvata rs (id_utente, id_ricetta)
                VALUES(?, ?)";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dd", array($id_utente, $id_ricetta));
            $res = $this->dbContext->ExecuteStatement();
            exit(json_encode($res));
        } 
        catch (Throwable $ex) {          
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);                     
            http_response_code(500); 
        }
    }

    public function RemoveRecipeFromCart() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE), "delega_codice");  
            $id_ricetta = $_POST["id_ricetta"];          
            $id_utente = $this->loginContext->id_utente;
            $query = 
                "DELETE FROM ricetta_salvata rs
                WHERE id_utente = ?
                AND id_ricetta = ?";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dd", array($id_utente, $id_ricetta));
            $res = $this->dbContext->ExecuteStatement();
            exit(json_encode($res));
        } 
        catch (Throwable $ex) {          
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);                     
            http_response_code(500); 
        }
    }

    // Switcha l'operazione richiesta lato client
    function Init(){
        $this->dbContext = new DBConnection();
        $this->loginContext = json_decode(TokenGenerator::ValidateToken());
        switch($_POST["action"]) {
            case "getRecipesInCart":
                self::GetRecipesInCart();
                break;
            case "addRecipeToCart":
                self::AddRecipeToCart();
                break;
            case "removeRecipeFromCart":
                self::RemoveRecipeFromCart();
                break;
            default: 
                exit(json_encode($_POST));
                break;
        }
    }
}

// Inizializza la classe per restituire i risultati e richiama il metodo d'ingresso
try {
    Logger::Write("Reached RecipesApi", $GLOBALS["CorrelationID"]);    
    $Auth = new RecipesApi();
    $Auth->Init();
}
catch(Throwable $ex) {
    Logger::Write("Error occured: $ex", $GLOBALS["CorrelationID"]);
    http_response_code(500);
    exit(json_encode($ex->getMessage()));
}


class Ingredient {
    public $id_ingrediente;
    public $nome_ingrediente;
    public $calorie;
    public $quantita;

    function __construct($row) {
        $this->id_ingrediente = $row["id_ingrediente"];
        $this->nome_ingrediente = $row["nome_ingrediente"];
        $this->calorie = $row["calorie"];
        $this->quantita = $row["quantita"];
    }
}

class Filter {
    public $sqlType;
    public $condition;

    function __construct($sqlType, $condition) {
        $this->sqlType = $sqlType;
        $this->condition = $condition;
    }
}
?>