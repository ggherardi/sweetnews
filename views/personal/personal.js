function authenticateUser() {
    var authenticationApi = new AuthenticationApi();
    var loader = new Loader(placeholders.mainContentZone);
    loader.showLoader();
    authenticationApi.authenticateUser()
        .done(authenticateUserCallback.bind(loader))
        .fail(RestClient.redirectAccordingToError);
}

function authenticateUserCallback(data) {
    data = JSON.parse(data);
    console.log(data);
    if(!data) {
        mainContentController.loadView(views.allViews.login).done(() => this.hideLoader());
        breadcrumb.rebuildBreadcrumb(views.allViews.login);
    } else {
        this.hideLoader();
    }
}

authenticateUser();