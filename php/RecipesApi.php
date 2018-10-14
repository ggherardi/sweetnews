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

    public function GetRecipesForUser() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(PermissionsConstants::VISITATORE, "delega_codice");            
            $id_utente = $this->loginContext->id_utente;
            $query = 
                "SELECT ri.titolo_ricetta, ri.id_ricetta, ri.difficolta, ri.tempo_cottura, ri.preparazione, ri.porzioni, ri.note, 
                    ti.nome_tipologia, sfa.data_flusso, sfa.codice_stato_approvativo, sfa.nome_stato_approvativo
                FROM ricetta ri
                INNER JOIN tipologia ti
                ON ri.id_tipologia = ti.id_tipologia      
                INNER JOIN flusso_approvativo fa
                ON ri.id_ricetta = fa.id_ricetta
                INNER JOIN stato_flusso_approvativo sfa
                ON ri.id_ricetta = sfa.id_ricetta        
                WHERE ri.id_utente = %d";
            $query = sprintf($query, $id_utente);
            Logger::Write("Query: ".$query, $GLOBALS["CorrelationID"]);
            $res = self::ExecuteQuery($query);
            $array = array();
            while($row = $res->fetch_assoc()) {
                $array[] = $row;
            }
            if(count($array)) {
                $query = 
                    "SELECT li.id_ricetta, li.quantita, ing.id_ingrediente, ing.nome_ingrediente, ing.calorie                    
                    FROM lista_ingredienti li
                    INNER JOIN ingrediente ing
                    ON li.id_ingrediente = ing.id_ingrediente
                    WHERE li.id_ricetta         
                    IN (%s)";
                $idsString = "";
                for($i = 0; $i < count($array); $i++) {            
                    $idsString .= sprintf("%d, ", $array[$i]["id_film"]);
                }
                $idsString = rtrim($idsString);
                $idsString = rtrim($idsString, ",");
                $query = sprintf($query, $idsString);
                Logger::Write("Query: ".$query, $GLOBALS["CorrelationID"]);
                usort($array, array($this, "SortByRicettaId"));        
                $res = self::ExecuteQuery($query);
                while($row = $res->fetch_assoc()) {
                    for($i = 0; $i < count($array); $i++) {              
                        if($array[$i]["id_ricetta"] == $row["id_ricetta"]) {    
                            $ingredient = new Ingredient($row);                                
                            $array[$i]["ingredienti"][] = $ingredient;
                            break;
                        }            
                    }
                }
            }            
            exit(json_encode($array));
        } 
        catch (Throwable $ex) {          
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);                     
            http_response_code(500); 
        }
    }

    function SortByRicettaId($a, $b) {
        return $a->id_ricetta > $b->id_ricetta;
    }

    public function GetRecipeTopologies() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(PermissionsConstants::VISITATORE, "delega_codice");            
            $query = 
                "SELECT *
                FROM tipologia";
            Logger::Write("Query: ".$query, $GLOBALS["CorrelationID"]);
            $res = self::ExecuteQuery($query);
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

    private function GetSlashedValueOrDefault($value) {
        $value = addslashes($value);
        return strlen($value) > 0 ? "'$value'" : "DEFAULT";
    }

    // Switcha l'operazione richiesta lato client
    function Init(){
        $this->dbContext = new DBConnection();
        $this->loginContext = json_decode(TokenGenerator::ValidateToken());
        if(!$this->loginContext) {
            Logger::Write("LoginContext is not valid, exiting scope.", $GLOBALS["CorrelationID"]);
            exit(false);
        }
        switch($_POST["action"]) {
            case "getRecipesForUser":
                self::GetRecipesForUser();
                break;
            case "getRecipeTopologies":
                self::GetRecipeTopologies();
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
?>