class Shared {
    constructor() {
        class LoginManager {
            constructor() { }
        
            login(stringLoginContext) {
                initTopologies();
                // shared.loginContext = JSON.parse(stringLoginContext);
                shared.loginContext = new LoginContext(stringLoginContext);
                mainContentController.loadView(shared.loginContext.isDipendente ? views.allViews.approveRecipes : views.allViews.personal);
                logoutController.loadComponent(views.AllComponents.logout);                
                accountController.loadComponent(views.AllComponents.account);
                breadcrumb.rebuildBreadcrumb(views.allViews.personal);
                menu.buildMenu();
            }

            logout() {
                shared.loginContext = new LoginContext(JSON.stringify({ delega_codice: 0 }));
                $(placeholders.logoutContainer).html("");
                accountController.loadComponent(views.AllComponents.account);
                $("#navbar__home").children().first().click();
                menu.buildMenu();
                menu.setMenuItemActive(views.allViews.home);
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

        class DateUtilities {
            constructor() { }

            formatDateFromString(dateString) {
                var date = new Date(dateString);
                var day = date.getDate();
                var month = date.getMonth() + 1;
                var year = date.getFullYear();
                return `${day < 10 ? `0${day}` : day}-${month < 10 ? `0${month}` : month}-${year}`;
            }
            
            formatDateToday() {
                var today = new Date();
                var day = today.getDate();
                var month = today.getMonth() + 1;
                var year = today.getFullYear();
                return `${year}-${month < 10 ? `0${month}` : month}-${day < 10 ? `0${day}` : day}`;
            }
            
            switchDateDigitsPosition(dateString) {
                dateString = dateString.replace(/\//g, "-");
                var arr = dateString.split("-");
                var newDateString = `${arr[2]}-${arr[1]}-${arr[0]}`;
                return newDateString;
            }
        }
        this.dateUtilities = new DateUtilities();

        class LoginContext {
            constructor(ctxJSON) {
                var ctx = JSON.parse(ctxJSON ? ctxJSON : JSON.stringify({ delega_codice: 0 }));
                this.username = ctx.username,
                this.nome = ctx.nome,
                this.id_utente = ctx.id_utente,
                this.delega_codice = ctx.delega_codice,
                this.delega_nome = ctx.delega_nome,
                this.isRedattore = this.delega_codice == 20,
                this.isCapoRedattore = this.delega_codice == 30,
                this.isDipendente = this.delega_codice > 10
            }
        }
        this.loginContext = new LoginContext();

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