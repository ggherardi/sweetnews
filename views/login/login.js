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

function openGuide() {
    body = "<h3>Credenziali per l'accesso al sito</h3>";
    body += `<table class="table mt-2">
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Password</th>
                        <th>Ruolo</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>guest</td>
                        <td>password</td>
                        <td>Visitatore, Redattore, Caporedattore</td>
                    </tr>
                    <tr>
                        <td>redattore1</td>
                        <td>password</td>
                        <td>Redattore</td>
                    </tr>
                    <tr>
                        <td>visitatore1</td>
                        <td>password</td>
                        <td>Visitatore</td>
                    </tr>
                </tbody>
            </table>
            <div>
                <span>Una volta effettuato l'accesso al sito come Caporedattore, è possibile reperire le altre utenze dalla pagina "Gestione account". 
                La password è uguale per tutti ed è "password".</span><br>
                <span>Utilizzare i link di seguito, invece, per scaricare la documentazione e gli zip contenti gli script PHP e gli schema SQL.</span>
            </div>
            <div class="mt-3">
                <a href="/documentazione/RelazioneTecnicaWebApplication SweetNews.pdf" download>Scarica la documentazione</a><br>
                <a href="/documentazione/source/scriptPHP.7z" download>Scarica i servizi PHP</a><br>
                <a href="/documentazione/source/scriptSQL.7z" download>Scarica gli script SQL</a>
            </div>`;
    modalOptions = {
        title: "Guida all'accesso al sito",
        body: body,
        cancelButton: {
            text: "Chiudi"
        }
    }

    modal = new Modal(modalOptions);
    modal.open(); 
}