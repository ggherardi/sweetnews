class Shared {
    constructor() {
        class LoginManager {
            constructor() { }
        
            login() {
                
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
        this.loginContext = null;
        this.userIdentities = null;
    }
}

var shared = new Shared();