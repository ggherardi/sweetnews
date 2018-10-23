function initAccount() {
    if(shared.loginContext.delega_codice > 0) {
        $("#account__username").text(shared.loginContext.username);
        $("#account__delega").text(`(${shared.loginContext.delega_nome})`);
        $("#loginAccountIcon").addClass(ImagesUtilities.getAccountImage(shared.loginContext.delega_codice));
    } else {
        var container = $("#account__username");
        container.parents("div").first().on("click", () => mainContentController.loadView(views.allViews.personal));
        container.addClass("c-pointer");
        container.text("Accedi");
        $("#loginAccountIcon").addClass("fas fa-sign-in-alt");
    }
}

initAccount();