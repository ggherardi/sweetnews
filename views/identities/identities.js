loginController = new Controller("#login");

function back() {
    pageContentController.switch();
}

function buildIdentitiesList() {
    var html = "";
    for(var i = 0; i < shared.userIdentities.length; i++) {
        var identity = shared.userIdentities[i];
        var codice = parseInt(identity.delega_codice);
        var icon = ImagesUtilities.getAccountImage(codice);
        html += `   <div class="identityRow c-pointer" onclick="loginWithIdentity(${identity.id_utente}, ${identity.delega_codice})">
                        <div class="row">
                            <div class="col-sm-4">
                                <i class="${icon} identityIcon purple"></i>
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