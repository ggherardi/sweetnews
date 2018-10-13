class Shared {
    constructor() {
        class LoginManager {
            constructor() { }
        
            login(stringLoginContext) {
                shared.loginContext = JSON.parse(stringLoginContext);
                mainContentController.loadView(views.allViews.personal);
                logoutController.loadComponent(views.AllComponents.logout);
                accountController.loadComponent(views.AllComponents.account);
                breadcrumb.rebuildBreadcrumb(views.allViews.personal);
                menu.buildMenu();
            }

            logout() {
                shared.loginContext = { delega_codice: 0 };
                $(placeholders.logoutContainer).html("");
                $(placeholders.accountContainer).html("");
                if(mainContentController.getActiveView().title == views.allViews.personal.title) {
                    $("#navbar__home").children().first().click();
                }
                menu.buildMenu();
            }
        }
        this.buildRepeaterHtml = function(htmlTemplate, array, containerSelector) {
            var html = ``;
            for(var i = 0; i < array.length; i++) {
                html += htmlTemplate;
            }
            if(containerSelector) {
                $(containerSelector).html(html);
            }            
            return html;
        }
        this.loginManager = new LoginManager();
        this.loginContext = {
            username: null,
            nome: null,
            id_utente: null,
            delega_codice: null,
            delega_nome: null
        };
        this.userIdentities = [{
            delega_codice: null,
            delega_nome: null,
            id_utente: null,
            nome: null,
            username: null
        }];
    }
}

var shared = new Shared();