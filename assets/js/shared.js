class Shared {
    constructor() {
        class LoginManager {
            constructor() { }
        
            login(stringLoginContext) {
                initTopologies();
                shared.loginContext = JSON.parse(stringLoginContext);
                mainContentController.loadView(views.allViews.personal);
                logoutController.loadComponent(views.AllComponents.logout);
                accountController.loadComponent(views.AllComponents.account);
                breadcrumb.rebuildBreadcrumb(views.allViews.personal);
                menu.buildMenu();
                menu.setMenuItemActive(shared.loginContext.delega_codice > 10 ?  views.allViews.approveRecipes : views.allViews.personal);
            }

            logout() {
                shared.loginContext = { delega_codice: 0 };
                $(placeholders.logoutContainer).html("");
                $(placeholders.accountContainer).html("");
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