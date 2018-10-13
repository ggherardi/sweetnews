class Shared {
    constructor() {
        class LoginManager {
            constructor() { }
        
            login() {

            }

            logout() {
                shared.loginContext = { delega_codice: 0 };
                $(placeholders.logoutContainer).html("");
                if(mainContentController.getActiveView().title == views.allViews.personal.title) {
                    mainContentController.loadView(views.allViews.home);
                }
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