class RestClient {
    constructor() {
        this.ajaxOptions = {};
     }

    execute() {
        this.setAjaxOptions();
        return $.ajax(this.ajaxOptions);
    }

    static redirectAccordingToError(jqXHR, textStatus, errorThrown) {
        switch(jqXHR.status) {
            case 401:
                CorrelationID = jqXHR.responseText;
                mainContentController.setView(views.unauthorized);
                modal.openErrorModal();      
                break;
            case 480:
                break;
        }
    }

    setAjaxOptions() {
        this.ajaxOptions.url = this.endpoint,
        this.ajaxOptions.data = this.data,
        this.ajaxOptions.type = "POST";
    }
}

class AuthenticationApi extends RestClient {
    constructor() {
        super();
        this.endpoint = "php/AuthenticationAPI.php";
    }

    registerUser(registrationForm) {
        registrationForm = JSON.stringify(registrationForm);
        this.data = {
            action: "registerUser",
            registrationForm: registrationForm
        }
        return super.execute();
    }

    asyncCheckUsernameValidity(username) {
        this.data = {
            action: "asyncCheckUsernameValidity",
            username: username
        }
        return super.execute();
    }

    login(credentials) {
        credentials = JSON.stringify(credentials);
        this.data = {
            action: "login",
            credentials: credentials
        }
        return super.execute();
    }

    // login(username, password) {
    //     var credentials = JSON.stringify({
    //         username: username,
    //         password: password
    //     });
    //     this.data = {
    //         credentials: credentials,
    //         action: "login"
    //     }
    //     return super.execute();
    // }

    logout() {
        this.data = {
            action: "logout"
        };
        return super.execute();
    }

    authenticateUser() {
        this.data = {
            action: "authenticateUser"
        }
        return super.execute();
    }
}