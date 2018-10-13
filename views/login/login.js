var loginController = new Controller("#login");

function switchToRegistration() {
    pageContentController.setSwitchableSecondaryPage(views.allViews.registration);
    pageContentController.switch();
}

function login(sender, e) {
    e.preventDefault();
    var loader = new Loader("#loginForm");
    loader.showLoader();
    var authenticationApi = new AuthenticationApi();
    var credentials = getLoginCredentials();
    var errorSpan = $("#loginForm__errorText");
    errorSpan.hide();
    authenticationApi.login(credentials)
        .done(loginSuccess)
        .fail(loginFail)
        .always(() => loader.hideLoader());
}

function getLoginCredentials() {
    return {
        username: $("#loginForm__username").val(),
        password: $("#loginForm__password").val()
    }
}

function loginSuccess(data) {
    var identities = JSON.parse(data);
    if(identities.length > 1) {
        console.log(identities);
        shared.userIdentities = identities;
        pageContentController.setSwitchableSecondaryPage(views.allViews.identities);
        pageContentController.switch();
    } else {
        shared.loginManager.login(data);
    }
}

function loginFail(jqXHR) {
    var errorSpan = $("#loginForm__errorText");
    switch(jqXHR.status) {
        case 401:
            errorSpan.text("Le credenziali fornite non sono corrette");
            break;
        case 480:
            errorSpan.text("Username non presente in database");
            break;
    }
    errorSpan.show();
}