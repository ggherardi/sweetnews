class RestClient {
    constructor() {
        this.ajaxOptions = {};
     }

    execute() {
        this.setAjaxOptions();
        return $.ajax(this.ajaxOptions);
    }

    static redirectAccordingToError(jqXHR, textStatus, errorThrown) {
        if(jqXHR.status == 401) {
            CorrelationID = jqXHR.responseText;
            mainContentController.setView(views.unauthorized);
            modal.openErrorModal();            
        }
    }

    setAjaxOptions() {
        this.ajaxOptions.url = this.endpoint,
        this.ajaxOptions.data = this.data,
        this.ajaxOptions.type = "POST";
    }
}

class AuthenticationService extends RestClient {
    constructor() {
        super();
        this.endpoint = "php/AuthenticationService.php";
    }

    registerUser(registrationForm) {
        registrationForm = JSON.stringify(registrationForm);
        this.data = {
            action: "registerUser",
            registrationForm: registrationForm
        }
        return super.execute();
    }

    checkUsernameValidity(username) {
        this.data = {
            action: "checkUsernameValidity",
            username: username
        }
        return super.execute();
    }

    login(username, password) {
        var credentials = JSON.stringify({
            username: username,
            password: password
        });
        this.data = {
            credentials: credentials,
            action: "login"
        }
        return super.execute();
    }

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