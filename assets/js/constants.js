class Views {
    constructor() {
        this.allViews = {
            home: { title: "Home", name: "home" },
            login: { title: "Profilo personale", name: "login" },
            registration: { title: "Registrazione", name: "registration", showInMenu: false },
            allRecipes: { title: "Catalogo ricette", name: "allRecipes" },
            restitutions: { title: "Restituzioni", name: "restitutions" },
            bookings: { title: "Prenotazioni", name: "bookings" },
            customers: { title: "Gestione clienti", name: "customers" },
            storage: { title: "Magazzino", name: "storage" },
            sales: { title: "Vendite", name: "sales", needPermissions: permissions.levels.responsabile },
            accounts: { title: "Gestione dipendenti", name: "accounts", needPermissions: permissions.levels.proprietario },    
            unauthorized: { title: "Unauthorized", name: "unauthorized", showInMenu: false }
        };
        
        this.components = {
            sidebar: { title: "Sidebar", name: "sidebar" }
        };
    }
}

class Permissions {
    constructor() {
        this.levels = {
            utente: 10,
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

permissions = new Permissions();
placeholders = new Placeholders();
httpUtilities = new HttpUtilities();
views = new Views();