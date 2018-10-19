class Permissions {
    constructor() {
        this.levels = {
            anonimo: 0,
            visitatore: 10,
            redattore: 20,
            caporedattore: 30
        }
    }
}

class Approval {    
    static getStates() {
        return {
            bozza: 0,
            in_validazione: 10,
            non_idonea: 15,
            in_approvazione: 20,
            non_approvata: 25,
            approvata: 30
        }
    }
}

class Placeholders {
    constructor() {
        this.mainContentZone = "#mainContentContainer";
        this.secondaryContentZone = "#secondaryContentContainer";
        this.sideMenu = "#navbar";
        this.breadcrumbContainer = "#breadcrumb";
        this.sharedModal = "#SharedModal";
        this.logoutContainer = "#logoutContainer";
        this.accountContainer = "#accountContainer";
        this.warningBanner = "#warningBanner";
        this.warningBannerText = "#warningBannerText";
    }
}

class HttpUtilities {
    constructor() {
        this.httpStatusCodes = {
            unauthorized: 401,
            conflict: 409,
            internalServerError: 500
        }
    }
}

class DataTableLanguage {
    constructor() {
        this.italian = {
            emptyTable: "Nessun risultato trovato",
            search: "Cerca",
            paginate: {
                
            },
            info: "Risultati da _START_ a _END_ da _TOTAL_ totali",
            infoEmpty: "Risultati da 0 a 0 di 0 totali",
            lengthMenu: "Mostra _MENU_ risultati",
            loadingRecords: "Caricamento...",
            processing: "Processando...",
            paginate: {
                first: "Primo",
                last: "Ultimo",
                next: "Prossimo",
                previous: "Precedente"
            }
        }
    }
}

var permissions = new Permissions();
var placeholders = new Placeholders();
var httpUtilities = new HttpUtilities();
var dataTableLanguage = new DataTableLanguage();