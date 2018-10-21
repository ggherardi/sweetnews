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
            TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE), "delega_codice");            
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
                WHERE ri.id_utente = ?";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("d", array($id_utente));
            $res = $this->dbContext->ExecuteStatement();
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
                    $idsString .= sprintf("%d, ", $array[$i]["id_ricetta"]);
                }
                $idsString = rtrim($idsString);
                $idsString = rtrim($idsString, ",");
                $query = sprintf($query, $idsString);
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
    
    public function GetRecipe() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE), "delega_codice");
            $id_ricetta = $_POST["id_ricetta"];
            $id_utente = $this->loginContext->id_utente;
            $query = 
                "SELECT ri.titolo_ricetta, ri.id_ricetta, ri.difficolta, ri.tempo_cottura, ri.preparazione, ri.porzioni, ri.note, ri.messaggio,
                    ti.id_tipologia, ti.nome_tipologia, sfa.data_flusso, sfa.id_stato_approvativo, sfa.id_stato_approvativo_precedente,
                    sfa.nome_stato_approvativo, sfa.stato_approvativo_isLeaf, sfa.codice_stato_approvativo
                FROM ricetta ri
                INNER JOIN tipologia ti
                ON ri.id_tipologia = ti.id_tipologia
                INNER JOIN stato_flusso_approvativo sfa
                ON ri.id_ricetta = sfa.id_ricetta      
                WHERE ri.id_ricetta = ?
                AND ri.id_utente = ?";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dd", array($id_ricetta, $id_utente));
            $res = $this->dbContext->ExecuteStatement();
            $recipeRow = $res->fetch_assoc();
            Logger::Write("ROW ".json_encode($row), $GLOBALS["CorrelationID"]);
            if($recipeRow) {
                $query = 
                    "SELECT li.id_ricetta, li.quantita, ing.id_ingrediente, ing.nome_ingrediente, ing.calorie                    
                    FROM lista_ingredienti li
                    INNER JOIN ingrediente ing
                    ON li.id_ingrediente = ing.id_ingrediente
                    WHERE li.id_ricetta = %s";
                $idsString = "";
                $query = sprintf($query, $id_ricetta);
                $res = self::ExecuteQuery($query);
                while($row = $res->fetch_assoc()) {         
                    $ingredient = new Ingredient($row);                                
                    $recipeRow["ingredienti"][] = $ingredient;
                }
            }            
            Logger::Write("FINAL ROW ".json_encode($recipeRow), $GLOBALS["CorrelationID"]);
            exit(json_encode($recipeRow));
        } 
        catch (Throwable $ex) {          
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);                     
            http_response_code(500); 
        }
    }

    function SortByRicettaId($a, $b) {
        return $a->id_ricetta > $b->id_ricetta;
    }

    function GetRecipeTopologies() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE), "delega_codice");            
            $query = 
                "SELECT *
                FROM tipologia";
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

    function GetIngredients() {
        Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
        TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE), "delega_codice");            
        $query = 
            "SELECT * FROM ingrediente";
        $res = self::ExecuteQuery($query);
        $array = array();
        while($row = $res->fetch_assoc()) {
            $array[] = $row;
        }
        exit(json_encode($array));
    }

    function InsertRecipe() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE, PermissionsConstants::VISITATORE), "delega_codice");
            $recipeForm = json_decode($_POST["recipeForm"]);
            $id_utente = $this->loginContext->id_utente;
            $ingredients = $recipeForm->lista_ingredienti;
            Logger::Write("RECIPE ".json_encode($ingredients), $GLOBALS["CorrelationID"]);
            $this->dbContext->StartTransaction();
            $query = 
                "INSERT INTO ricetta
                (id_utente, id_tipologia, titolo_ricetta, difficolta, tempo_cottura, preparazione, porzioni, note, messaggio)
                VALUES
                (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("ddsddsdss", array($id_utente, $recipeForm->id_tipologia, $recipeForm->titolo_ricetta, 
                $recipeForm->difficolta, $recipeForm->tempo_cottura, $recipeForm->preparazione, $recipeForm->porzioni, $recipeForm->note, $recipeForm->messaggio));
            $res = $this->dbContext->ExecuteStatement();
            $recipeId = $this->dbContext->GetLastId();

            $query = 
                "INSERT INTO lista_ingredienti
                (id_ingrediente, id_ricetta, quantita)
                VALUES
                (?, ?, ?)";
            $this->dbContext->PrepareStatement($query);
            for($i = 0; $i < count($ingredients); $i++) {
                $ingredient = $ingredients[$i];
                $this->dbContext->BindStatementParameters("ddd", array($ingredient->id_ingrediente, $recipeId, $ingredient->quantita));
                $res = $this->dbContext->ExecuteStatement();
            } 
            $this->dbContext->CommitTransaction();
            exit(json_encode($recipeId));
        }
        catch(Throwable $ex) {
            $this->dbContext->RollBack();            
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getTraceAsString()), $GLOBALS["CorrelationID"]);
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

    
    function EditRecipe() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE, PermissionsConstants::VISITATORE), "delega_codice");
            $recipeForm = json_decode($_POST["recipeForm"]);
            $id_utente = $this->loginContext->id_utente;
            $ingredients = $recipeForm->lista_ingredienti;
            $this->dbContext->StartTransaction();
            $query = 
                "UPDATE ricetta ri
                INNER JOIN stato_flusso_approvativo sfa
                ON ri.id_ricetta = sfa.id_ricetta
                SET ri.id_tipologia = ?, ri.titolo_ricetta = ?, ri.difficolta = ?, ri.tempo_cottura = ?, ri.preparazione = ?, ri.porzioni = ?, ri.note = ?, ri.messaggio = ?
                WHERE ri.id_ricetta = ?
                AND ri.id_utente = ?
                AND sfa.codice_stato_approvativo = ?";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dsddsdssddd", array($recipeForm->id_tipologia, $recipeForm->titolo_ricetta, $recipeForm->difficolta, 
                $recipeForm->tempo_cottura, $recipeForm->preparazione, $recipeForm->porzioni, $recipeForm->note, $recipeForm->messaggio, $recipeForm->id_ricetta, 
                $id_utente, ApprovalFlowConstants::BOZZA));
            $res = $this->dbContext->ExecuteStatement();

            // Per ora cancello e ricreo, con più tempo creerò un metodo per controllare quali ingredienti sono stati cancellati e quali aggiunti
            $query = 
                "DELETE FROM lista_ingredienti WHERE id_ricetta = ?";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("d", array($recipeForm->id_ricetta)); 
            $this->dbContext->ExecuteStatement();

            $query = 
                "INSERT INTO lista_ingredienti
                (id_ingrediente, id_ricetta, quantita)
                VALUES
                (?, ?, ?)";
            $this->dbContext->PrepareStatement($query);
            for($i = 0; $i < count($ingredients); $i++) {
                $ingredient = $ingredients[$i];
                $this->dbContext->BindStatementParameters("ddd", array($ingredient->id_ingrediente, $recipeForm->id_ricetta, $ingredient->quantita));
                $res = $this->dbContext->ExecuteStatement();
            } 
            $this->dbContext->CommitTransaction();
            exit(json_encode($recipeId));
        }
        catch(Throwable $ex) {
            $this->dbContext->RollBack();            
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getTraceAsString()), $GLOBALS["CorrelationID"]);
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

    // Switcha l'operazione richiesta lato client
    function Init(){
        $this->dbContext = new DBConnection();
        $this->loginContext = json_decode(TokenGenerator::ValidateToken());
        if(!$this->loginContext) {
            Logger::Write("LoginContext is not valid, exiting scope.", $GLOBALS["CorrelationID"]);
            exit(json_encode(false));
        }
        switch($_POST["action"]) {
            case "getRecipesForUser":
                self::GetRecipesForUser();
                break;
            case "getRecipeTopologies":
                self::GetRecipeTopologies();
                break;
            case "getIngredients":
                self::GetIngredients();
                break;
            case "getRecipe":
                self::GetRecipe();
                break;
            case "insertRecipe":
                self::InsertRecipe();
                break;
            case "editRecipe":
                self::EditRecipe();
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