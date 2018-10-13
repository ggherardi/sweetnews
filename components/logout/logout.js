function logout() {
    var authenticationApi = new AuthenticationApi();
    authenticationApi.logout()
        .done(shared.loginManager.logout)
        .fail(RestClient.redirectAccordingToError);
}