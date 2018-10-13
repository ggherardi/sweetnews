var registrationController = new Controller("#registration");

function switchToLogin() {
    pageContentController.switch();
}

/* EVENTS */
/* Async actions */
function checkUsernameValidity(sender) {
    var username = sender.value;
    if(username == "") {
        sender.setCustomValidity("Compila questo campo");
    } else {
        var loader = new Loader("#registrationForm__username_container", 30, 30);
        loader.showLoader();
        var authenticationApi = new AuthenticationApi();
        authenticationApi.asyncCheckUsernameValidity(username)
            .done((data) => {
                loader.hideLoader();
                if(data) {
                    usernameAlreadyExistsReport();
                }
            })
            .fail((jqXHR) => {
                loader.hideLoader();
                console.log(jqXHR.status);
            });
    }
}

/* Registration action */
function register(sender, e) {
    e.preventDefault();
    var registrationForm = getRegistrationInputValues();
    var authenticationApi = new AuthenticationApi();
    var loader = new Loader("#registrationForm");
    loader.showLoader();
    authenticationApi.registerUser(registrationForm)
        .done(registrationSuccess.bind(loader))
        .fail(registrationError.bind(loader));
}

function registrationSuccess(data) {
    if(data) {
        var authenticationApi = new AuthenticationApi();
        var credentials = {
            username: $("#registrationForm__username").val(),
            password: $("#registrationForm__password").val()
        }
        authenticationApi.login(credentials)
            .done((data) => { 
                pageContentController.switch(); 
                shared.loginManager.login(data);
                var modalOptions = new ModalOptions();
                modalOptions.title = `Registrazione effettuata`;
                modalOptions.body = `<span>Registrazione effettuata con successo!</span>`;
                modal = new Modal();                 
            })
            .fail(RestClient.redirectAccordingToError);
    }
}

function registrationError(jqXHR) {
    this.hideLoader();
    switch(jqXHR.status) {
        case httpUtilities.httpStatusCodes.conflict:
            usernameAlreadyExistsReport();
            break;
        default:
            console.log("test");
            break;
    }    
}

function getRegistrationInputValues() {
    var registrationForm = {
        nome: $("#registrationForm__nome").val(),
        cognome: $("#registrationForm__cognome").val(),
        email: $("#registrationForm__email").val(),
        telefono_cellulare: $("#registrationForm__telefono_cellulare").val(),
        telefono_abitazione: $("#registrationForm__telefono_abitazione").val(),
        indirizzo: $("#registrationForm__indirizzo").val(),
        data_nascita: $("#registrationForm__data_nascita").val(),
        username: $("#registrationForm__username").val(),
        password: $("#registrationForm__password").val()
    }
    return registrationForm;
}

function usernameAlreadyExistsReport() {
    $("#registrationForm__username")[0].setCustomValidity("Username già presente");
    $("#registrationForm")[0].reportValidity();
}