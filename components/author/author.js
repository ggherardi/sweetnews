function initAuthorView() {
    var loader = new Loader("#recipeAuthor");
    loader.showLoader();
    var accountsApi = new AccountsApi();
    accountsApi.getRecipeAuthorDetails(window.RecipeAuthor)
        .done(getRecipeAuthorDetailsSuccess)
        .fail(RestClient.reportError)
        .always(() => loader.hideLoader());
}

function getRecipeAuthorDetailsSuccess(data) {
    if(data && JSON.parse(data)) {
        data = JSON.parse(data);
        $("#recipeAuthor__username").text(data.username);
        $("#recipeAuthor__name").text(data.nome);
        $("#recipeAuthor__surname").text(data.cognome);
        $("#recipeAuthor__email").text(data.email);
    } else {
        $("#recipeAuthor").html("<span>Si è verificato un errore durante il caricamento del profilo.</span>")
    }
}

initAuthorView();