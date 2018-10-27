<?php
include_once 'DBConnection.php';
include_once 'TokenGenerator.php';
include_once 'Constants.php';

$GLOBALS["CorrelationID"] = uniqid("corrId_", true);
$correlationId = $GLOBALS["CorrelationID"];

class ApprovalFlowApi {
    private $dbContext;
    private $loginContext;

    function __construct() { }

    public function StartApprovalFlow() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE, PermissionsConstants::VISITATORE), "delega_codice"); 
            $id_ricetta = $_POST["id_ricetta"];           
            $id_utente = $this->loginContext->id_utente;
            $query = 
                "UPDATE flusso_approvativo
                SET id_stato_approvativo = (SELECT id_stato_approvativo 
                                            FROM stato_approvativo
                                            WHERE codice_stato_approvativo = ?)
                WHERE id_ricetta = ?                                                                
                AND id_utente_creatore = ?
                AND id_stato_approvativo = (SELECT id_stato_approvativo 
                                            FROM stato_approvativo
                                            WHERE codice_stato_approvativo = ?)";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dddd", array(ApprovalFlowConstants::INVIATA, $id_ricetta, $id_utente, ApprovalFlowConstants::BOZZA));
            $res = $this->dbContext->ExecuteStatement();
            exit(json_encode($res));
        } 
        catch (Throwable $ex) {          
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);                     
            http_response_code(500); 
        }
    }

    public function StartApprovalValidation() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::REDATTORE), "delega_codice"); 
            $parameters = json_decode($_POST["parameters"]);           
            $id_utente = $this->loginContext->id_utente;
            $query = 
                "UPDATE flusso_approvativo
                SET 
                id_stato_approvativo = ?,
                id_utente_approvatore = ?,
                data_flusso = DEFAULT  
                WHERE id_ricetta = ?                                                                
                AND id_utente_creatore <> ?
                AND id_stato_approvativo IN (SELECT id_stato_approvativo 
                                            FROM stato_approvativo
                                            WHERE codice_stato_approvativo = ?
                                            OR codice_stato_approvativo = ?)";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dddddd", array($parameters->id_stato_approvativo_valutazione, $id_utente, $parameters->id_ricetta, 
                $id_utente, ApprovalFlowConstants::INVIATA, ApprovalFlowConstants::IDONEA));
            $res = $this->dbContext->ExecuteStatement();

            $query = 
                "SELECT codice_stato_approvativo, id_utente_approvatore
                FROM stato_flusso_approvativo
                WHERE id_ricetta = ?";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("d", array($parameters->id_ricetta));
            $res = $this->dbContext->ExecuteStatement();
            $row = $res->fetch_assoc();
            exit(json_encode($row));
        } 
        catch (Throwable $ex) {          
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);                     
            http_response_code(500); 
        }
    }

    public function ApproveRejectRecipe() {
        try {
            Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
            TokenGenerator::CheckPermissions(array(PermissionsConstants::REDATTORE), "delega_codice"); 
            $parameters = json_decode($_POST["parameters"]);           
            $id_utente = $this->loginContext->id_utente;
            $query = 
                "UPDATE flusso_approvativo
                SET 
                id_stato_approvativo = ?,
                id_utente_approvatore = NULL,
                data_flusso = DEFAULT  
                WHERE id_ricetta = ?                                                                
                AND id_utente_creatore <> ?
                ANd id_utente_approvatore = ?
                AND id_stato_approvativo IN (SELECT id_stato_approvativo
                                            FROM stato_approvativo
                                            WHERE codice_stato_approvativo = ?
                                            OR codice_stato_approvativo = ?)";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("dddddd", array($parameters->idNextStep, $parameters->id_ricetta, 
                $id_utente, $id_utente, ApprovalFlowConstants::IN_VALIDAZIONE, ApprovalFlowConstants::IN_APPROVAZIONE));
            $res = $this->dbContext->ExecuteStatement();

            $query = 
                "SELECT codice_stato_approvativo, id_utente_approvatore
                FROM stato_flusso_approvativo
                WHERE id_ricetta = ?";
            $this->dbContext->PrepareStatement($query);
            $this->dbContext->BindStatementParameters("d", array($parameters->id_ricetta));
            $res = $this->dbContext->ExecuteStatement();
            $row = $res->fetch_assoc();
            exit(json_encode($row));
        } 
        catch (Throwable $ex) {          
            Logger::Write(sprintf("Error occured in " . __FUNCTION__. " code -> ".$ex->getMessage()), $GLOBALS["CorrelationID"]);                     
            http_response_code(500); 
        }
    }

    public function GetAllRecipesWithStateInRange() {
        Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
        TokenGenerator::CheckPermissions(array(PermissionsConstants::REDATTORE), "delega_codice");         
        $args = json_decode($_POST["args"]);
        $id_utente = $this->loginContext->id_utente;
        $query = 
            "SELECT *
            FROM anteprime_ricetta
            WHERE id_stato_approvativo NOT IN (SELECT id_stato_approvativo
                                                    FROM stato_approvativo
                                                    WHERE codice_stato_approvativo = ?
                                                    OR codice_stato_approvativo = ?) 
            AND codice_stato_approvativo >= ?
            %s";
        $parametersTypes = "ddd";
        $parameters = array();
        $parameters[] = ApprovalFlowConstants::NON_IDONEA;
        $parameters[] = ApprovalFlowConstants::NON_APPROVATA;
        $parameters[] = $args->minState;
        if($args->maxState) {
            $query = sprintf($query, "AND codice_stato_approvativo <= ? %s");
            $parametersTypes .= "d";
            $parameters[] = $args->maxState;
        } else {
            $query = sprintf($query, "%s");
        }
        if($args->needsUserValidation) {
            if($args->currentUser) {
                $query = sprintf($query, "AND (id_utente_approvatore = ? AND id_utente_approvatore is not NULL) %s");
            } else {
                $query = sprintf($query, "AND (id_utente_approvatore <> ? OR id_utente_approvatore is NULL) %s");
            }
            $parametersTypes .= "d";
            $parameters[] = $id_utente;
        } else {
            $query = sprintf($query, "%s");
        }
        if($this->loginContext->delega_codice == PermissionsConstants::CAPOREDATTORE) {
            $query = sprintf($query, "AND data_flusso <= ?");
            $parametersTypes .= "s"; 
            $parameters[] = self::GetDateForRecipeApproval();
        } else {
            $query = sprintf($query, "");
        }

        $this->dbContext->PrepareStatement($query);
        $this->dbContext->BindStatementParameters($parametersTypes, $parameters);
        $res = $this->dbContext->ExecuteStatement();
        $array = array();
        while($row = $res->fetch_assoc()) {
            $array[] = $row;
        }
        exit(json_encode($array));
    }

    private function GetDateForRecipeApproval() {
        $today = time();
        $daysForRecipeApproval = ($today / (60 * 60 * 24)) - 30;
        $daysForRecipeApproval = $daysForRecipeApproval * (60 * 60 * 24);
        return date("Y-m-d H:i:s", $daysForRecipeApproval);
    }

    public function GetRejectedRecipes() {
        Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
        TokenGenerator::CheckPermissions(array(PermissionsConstants::REDATTORE), "delega_codice");         
        $id_utente = $this->loginContext->id_utente;
        $query = 
            "SELECT *
            FROM anteprime_ricetta
            WHERE id_stato_approvativo IN (SELECT id_stato_approvativo
                                            FROM stato_approvativo
                                            WHERE codice_stato_approvativo = ?
                                            OR codice_stato_approvativo = ?)";
        $this->dbContext->PrepareStatement($query);
        $this->dbContext->BindStatementParameters("dd", array(ApprovalFlowConstants::NON_IDONEA, ApprovalFlowConstants::NON_APPROVATA));
        $res = $this->dbContext->ExecuteStatement();
        $array = array();
        while($row = $res->fetch_assoc()) {
            $array[] = $row;
        }
        exit(json_encode($array));
    }

    public function GetAllApprovaFlowSteps() {
        Logger::Write("Processing ". __FUNCTION__ ." request.", $GLOBALS["CorrelationID"]);
        TokenGenerator::CheckPermissions(array(PermissionsConstants::VISITATORE), "delega_codice");            
        $query = 
            "SELECT *
            FROM stato_approvativo
            ORDER BY codice_stato_approvativo ASC";
        $this->dbContext->PrepareStatement($query);
        $res = $this->dbContext->ExecuteStatement();
        $array = array();
        while($row = $res->fetch_assoc()) {
            $array[] = $row;
        }
        exit(json_encode($array));
    }

    function Init(){
        $this->dbContext = new DBConnection();
        $this->loginContext = json_decode(TokenGenerator::ValidateToken());
        if(!$this->loginContext) {
            Logger::Write("LoginContext is not valid, exiting scope.", $GLOBALS["CorrelationID"]);
            http_response_code(401);
        }
        switch($_POST["action"]) {
            case "startApprovalFlow":
                self::StartApprovalFlow();
                break;
            case "startApprovalValidation":
                self::StartApprovalValidation();
                break;
            case "approveRejectRecipe":
                self::ApproveRejectRecipe();
                break;
            case "getAllRecipesWithStateInRange":
                self::GetAllRecipesWithStateInRange();
                break;
            case "getRejectedRecipes":
                self::GetRejectedRecipes();
                break;
            case "getAllApprovaFlowSteps":
                self::GetAllApprovaFlowSteps();
                break;
            default: 
                exit(json_encode($_POST));
                break;
        }
    }
}

// Inizializza la classe per restituire i risultati e richiama il metodo d'ingresso
try {
    Logger::Write("Reached ApprovalFlowApi", $GLOBALS["CorrelationID"]);    
    $Auth = new ApprovalFlowApi();
    $Auth->Init();
}
catch(Throwable $ex) {
    Logger::Write("Error occured: $ex", $GLOBALS["CorrelationID"]);
    http_response_code(500);
    exit(json_encode($ex->getMessage()));
}
?>