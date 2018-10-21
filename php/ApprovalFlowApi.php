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