Recipe = {};

/* FORM POPULATION */
function init() {
    initObserver();
    initDisplayFormCart();
    var loader = new Loader("#recipeDisplayForm");
    loader.showLoader();
    var recipesApi = new RecipesApi();
    recipesApi.getPublicRecipe(window.RecipeId)
        .done(initControlsPopulation)
        .fail(RestClient.reportError)
        .always(() => { 
            loader.hideLoader();
            hideEmptyFields();
        });
}

function initObserver() {
    var observer = new MutationObserver(observerCallback)
    observer.observe(document.getElementById("recipesCartContainer"), { childList: true, subtree: true });
}

function observerCallback(mutationList) {
    if(mutationList && mutationList[0].addedNodes.length || mutationList[0].removedNodes) {
        initDisplayFormCart();
        initButtons();
    }
}

function initDisplayFormCart() {
    $("#displayFormCartsContainer").html($("#recipesCartContainer").html());
}

function initButtons() {
    if(window.SavedRecipes && window.SavedRecipes.filter(r => r.id_ricetta == Recipe.id_ricetta).length) {
        $("#btnSaveRecipe").prop("disabled", true);
    } else {
        $("#btnSaveRecipe").prop("disabled", false);
    }
}

function initControlsPopulation(data) {
    if(data && JSON.parse(data)) {
        Recipe = JSON.parse(data);
        populateTextControls();
        formatIngredientsField();        
    }
    else {
        var messageId = Ribbon.setMessage(`Si è verificato un errore durante il caricamento.`);
        WarningIds[WarningMessages.loadingError] = messageId;
    }
}

function populateTextControls() {
    initButtons();
    var caloriesForPortion = new Number(parseFloat(Recipe.calorie_totali) / parseInt(Recipe.porzioni)).toFixed(2);
    $("#recipeDisplayForm__titolo").text(Recipe.titolo_ricetta);
    $("#recipeDisplayForm__tipologia").text(Recipe.nome_tipologia);
    $("#recipeDisplayForm__difficolta").text(formatStarsDifficulty());
    $("#recipeDisplayForm__tempo_cottura").text(Recipe.tempo_cottura);
    $("#recipeDisplayForm__porzioni").text(Recipe.porzioni);
    $("#recipeDisplayForm__calorie").text(caloriesForPortion);
    $("#recipeDisplayForm__preparazione").text(Recipe.preparazione);
    $("#recipeDisplayForm__note").text(Recipe.note);
}

function hideEmptyFields() {
    if(!Recipe.note) {
        $("#noteSection").hide();
    }
}

function formatStarsDifficulty() {
    var stars = "";
    for(var i = 0; i < Recipe.difficolta; i++) {
        stars += "★";
    }
    return stars;
}

function formatIngredientsField() {
    var html = ``;
    for(var i = 0; i < Recipe.ingredienti.length; i++) {
        var ingredient = Recipe.ingredienti[i];
        if(!i % 5) {
            if(i > 0) {
                html += `   </div>`;
            }
            html += `       <div class="row">`;
        }
        html += `               <div class="col-12 col-sm-2">
                                    <span>${ingredient.nome_ingrediente}</span>: <span>${ingredient.quantita} g.</span>
                                </div>`;
    }
    $("#recipeDisplayForm__ingredienti").html(html);
}

/* AUX */
function removeWarning(warning) {
    if(WarningIds[warning]) {
        var id = WarningIds[warning];
        Ribbon.removeMessage(id);
        WarningIds[warning] = undefined;
    }
}

function resetVariables() {
    delete window.RecipeId;
    delete Recipe;
}

/* EVENTS */
function goBackToRecipes() {
    resetVariables();
    pageContentController.switch();
}

function addRecipeToCart() {
    var recipesCartApi = new RecipesCartApi();
    recipesCartApi.addRecipeToCart(Recipe.id_ricetta)
        .done(addRecipeToCartSuccess)
        .fail(RestClient.redirectAccordingToError);
}

function addRecipeToCartSuccess() {
    initRecipesCart();
    initDisplayFormCart();
    // setTimeout(() => initButtons(), 200);
}

/* Init */
init();