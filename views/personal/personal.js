function authenticateUser() {
    var authenticationApi = new AuthenticationApi();
    authenticationApi.authenticateUser()
        .done(authenticateUserCallback)
        .fail(RestClient.redirectAccordingToError);
}

function authenticateUserCallback(data) {
    data = JSON.parse(data);
    console.log(data);
    if(!data) {
        mainContentController.loadView(views.allViews.login);
    }
}

authenticateUser();