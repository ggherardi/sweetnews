class Views {
    constructor() {
        class AllViews {
            constructor() {
                this.home = { title: "Home", name: "home" },
                this.personal = { title: "Pagina personale", name: "personal", showInMenu: true }
                this.login = { title: "Login", name: "login", parent: this.personal},
                this.identities = { title: "Deleghe utente", name: "identities", showInMenu: false, needPermissions: permissions.levels.visitatore, parent: this.login },
                this.registration = { title: "Registrazione", name: "registration", showInMenu: false, parent: this.personal },
                this.allRecipes = { title: "Catalogo ricette", name: "allRecipes" },
                this.restitutions = { title: "Restituzioni", name: "restitutions" },
                this.bookings = { title: "Prenotazioni", name: "bookings" },
                this.customers = { title: "Gestione clienti", name: "customers" },
                this.storage = { title: "Magazzino", name: "storage" },
                this.sales = { title: "Vendite", name: "sales", needPermissions: permissions.levels.responsabile },
                this.accounts = { title: "Gestione dipendenti", name: "accounts", needPermissions: permissions.levels.proprietario },    
                this.unauthorized = { title: "Unauthorized", name: "unauthorized", showInMenu: false }
            }
        };
        this.allViews = new AllViews();
        this.components = {
            sidebar: { title: "Sidebar", name: "sidebar" }
        };
    }
}

class Permissions {
    constructor() {
        this.levels = {
            visitatore: 10,
            redattore: 20,
            caporedattore: 30
        }
    }
}

class Placeholders {
    constructor() {
        this.mainContentZone = "#mainContentContainer";
        this.secondaryContentZone = "#secondaryContentContainer";
        this.sidebarZone = "#navbar";
        this.breadcrumbContainer = "#breadcrumb";
        this.sharedModal = "#SharedModal";
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

var permissions = new Permissions();
var placeholders = new Placeholders();
var httpUtilities = new HttpUtilities();
var views = new Views();