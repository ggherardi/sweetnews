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

class Placeholders {
    constructor() {
        this.mainContentZone = "#mainContentContainer";
        this.secondaryContentZone = "#secondaryContentContainer";
        this.sidebarZone = "#navbar";
        this.breadcrumbContainer = "#breadcrumb";
        this.sharedModal = "#SharedModal";
        this.logoutContainer = "#logoutContainer";
        this.accountContainer = "#accountContainer";
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