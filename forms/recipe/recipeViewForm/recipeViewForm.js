Recipe = {};
FormInitialState = [];
WarningIds = [];
AllIngredients = [];
InitialIngredientsCount = 0;
WarningMessages = {
    saveWarning: "saveWarning",
    noIngredientsWarning: "noIngredientsWarning",
    loadingError: "loadingError"
}

/* RIBBON ACTIONS */
function back() {
    pageContentController.switch();
}

/* FORM POPULATION */
function init() {
    var loader = new Loader("#recipeEditForm");
    loader.showLoader();
    var recipesApi = new RecipesApi();
    recipesApi.getRecipe(window.RecipeId)
        .done(initControlsPopulation)
        .fail(RestClient.reportError)
        .always(() => loader.hideLoader());
}

function initControlsPopulation(data) {
    if(data && JSON.parse(data)) {
        Recipe = JSON.parse(data);
        populateTextControls();
        populateRadioControl();
        populateTipologiaSelect();
        populateIngredientsControl();
        initFlowSteps();
    }
    else {
        var messageId = Ribbon.setMessage(`Si è verificato un errore durante il caricamento.`);
        WarningIds[WarningMessages.loadingError] = messageId;
    }
}

function populateTextControls() {
    $("#recipeEditForm__titolo").val(Recipe.titolo_ricetta);
    $("#recipeEditForm__tempo_cottura").val(Recipe.tempo_cottura);
    $("#recipeEditForm__preparazione").val(Recipe.preparazione);
    $("#recipeEditForm__porzioni").val(Recipe.porzioni);
    $("#recipeEditForm__note").val(Recipe.note);
    $("#recipeEditForm__messaggio").val(Recipe.messaggio);
}

function populateRadioControl() {
    $(`#star${Recipe.difficolta}`).prop("checked", true);
}

function populateTipologiaSelect() {
    var recipesApi = new RecipesApi();
    recipesApi.getRecipeTopologies()
        .done(getRecipeTopologiesSuccess)
        .fail(RestClient.redirectAccordingToError);
}

function getRecipeTopologiesSuccess(data) {
    topologies = JSON.parse(data);
    var topologiesSelect = document.getElementById("recipeEditForm__tipologia");
    for(var i = 0; i < topologies.length; i++) {
        let topology = topologies[i];
        let option = document.createElement("option");
        option.value = topology.id_tipologia;
        option.text = topology.nome_tipologia;
        option.defaultSelected = topology.id_tipologia == Recipe.id_tipologia;
        topologiesSelect.add(option);
    }
}

/* Ingredients controls */
function populateIngredientsControl() {
    for(var i = 0; i < Recipe.ingredienti.length; i++) {
        var ingredient = Recipe.ingredienti[i];
        var controlNumber = i + 1;
        createNewIngredientControl();
        $(`#recipeEditForm__ingredient_id_${controlNumber}`).val(ingredient.id_ingrediente);
        $(`#recipeEditForm__ingredient_nome_${controlNumber}`).val(ingredient.nome_ingrediente);
        $(`#recipeEditForm__ingredient_quantita_${controlNumber}`).val(ingredient.quantita);
        $(`#recipeEditForm__ingredient_calorie_${controlNumber}`).val(ingredient.calorie);
    }
}

function createNewIngredientControl() {
    var ingredientsControlsContainer = $("#recipeEditForm__ingredients");
    var ingredientsCount = $("#recipeEditForm__ingredients .ingredientRow").length;    
    var currentControlNumber = ingredientsCount + 1;
    var html = `<div id="ingredientRow_${currentControlNumber}" class="ingredientRow form-row mt-2" data-rowid="${currentControlNumber}">
                    <input id="recipeEditForm__ingredient_id_${currentControlNumber}" class="ingredient_id_${currentControlNumber}" type="hidden">
                    <div class="col-sm-6 autocomplete">
                        <input id="recipeEditForm__ingredient_nome_${currentControlNumber}" 
                            class="form-control ingredient_nome_${currentControlNumber}" 
                            type="text" 
                            placeholder="ingrediente" 
                            disabled>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipeEditForm__ingredient_quantita_${currentControlNumber}" 
                            class="form-control ingredient_quantita_${currentControlNumber}" 
                            type="number" 
                            min="0.01" 
                            placeholder="qt." 
                            title="quantità" 
                            step="0.01" 
                            disabled>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipeEditForm__ingredient_calorie_${currentControlNumber}" 
                            class="form-control ingredient_calorie_${currentControlNumber}" 
                            type="number" 
                            min="0" 
                            placeholder="cal." 
                            title="calorie" 
                            step="0.01"                              
                            disabled>
                    </div>
                </div>`;
    ingredientsControlsContainer.append(html);
}

function initFlowSteps() {
    var steps = new ApprovalFlowSteps(Recipe, Global_AllApprovalSteps);
    $("#flowStepsCrumb").html(steps.getHtml());
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
    delete FormInitialState;
    delete WarningIds;
    delete AllIngredients;
    delete InitialIngredientsCount;
    delete WarningMessages;
}

/* Init */
init();