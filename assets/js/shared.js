class Shared {
    constructor() {
        class LoginManager {
            constructor() { }
        
            login() {
                
            }
        }
        this.loginManager = new LoginManager();
        this.loginContext = null;
        this.userIdentities = null;
    }
}

var shared = new Shared();