function initAccount() {
    $("#account__username").text(shared.loginContext.username);
    $("#account__delega").text(shared.loginContext.delega_nome);
    $("#loginAccountIcon").addClass(ImagesUtilities.getAccountImage(shared.loginContext.delega_codice));
}

initAccount();