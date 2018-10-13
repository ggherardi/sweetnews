function initAccount() {
    $("#account__username").text(shared.loginContext.username);
    $("#account__delega").text(shared.loginContext.delega_nome);
}

initAccount();