<?php
class PermissionsConstants {
    const ANONIMO = 0;
    const VISITATORE = 10;
    const REDATTORE = 20;
    const CAPOREDATTORE = 30;
    const COOKIE_NAME = "SweetNewsAuth";
}

class ApprovalFlowConstants {
    const BOZZA = 0;
    const INVIATA = 5;
    const IN_VALIDAZIONE = 10;
    const NON_IDONEA = 15;
    const IDONEA = 20;
    const IN_APPROVAZIONE = 25;
    const NON_APPROVATA = 30;
    const APPROVATA = 35;
}

class LoginContext {
    public $username;
    public $id_utente;
    public $id_tipo_delega;
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
        $this->id_tipo_delega = $row["id_tipo_delega"];
        $this->delega_codice = $row["delega_codice"];
        $this->delega_nome = $row["delega_nome"];
        $this->matricola = $row["id_utente"];
        $this->indirizzo = $row["indirizzo"];
        $this->telefono_abitazione = $row["telefono_abitazione"];
        $this->telefono_cellulare = $row["telefono_cellulare"];
        $this->email = $row["email"];
        $this->data_nascita = $row["data_nascita"];
    }

    public static function MapFromJSON($json) {
        $ctx = json_decode($json);        
    }
}
?>