loginController = new Controller("#login");

function switchToLogin() {
    pageContentController.switch();
}

function buildIdentitiesList() {
    var html = "";
    for(var i = 0; i < shared.userIdentities.length; i++) {
        var identity = shared.userIdentities[i];
        var codice = parseInt(identity.delega_codice);
        var icon;
        switch(codice) {
            case 10:
                icon = "person";
                break;
            case 20:
                icon = "pie-chart";
                break;
            case 30:
                icon = "briefcase";
                break;
        }
        html += `   <div class="identityRow c-pointer" onclick="loginWithIdentity(${identity.id_utente}, ${identity.delega_codice})">
                        <div class="row">
                            <div class="col-sm-4">
                                <svg class="identityIcon purple">
                                    <use xlink:href="/assets/svg/sprite.svg#${icon}"></use>
                                </svg>
                            </div>
                        <div class="col-sm-8">${identity.delega_nome}</div>
                        </div>
                    </div>`;
    }
    $("#identitiesForm").html(html);
}

function loginWithIdentity(id_utente, delega_codice) {
    var authenticationApi = new AuthenticationApi();
    var loader = new Loader(placeholders.mainContentZone);
    loader.showLoader();
    authenticationApi.getDetailsForUser(id_utente, delega_codice)
        .done((data) => { shared.loginManager.login(data); pageContentController.switch(); })
        .fail(RestClient.redirectAccordingToError);
}

buildIdentitiesList();