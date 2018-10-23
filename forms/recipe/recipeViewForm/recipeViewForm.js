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

function takeCharge() {
    
}

/* FORM POPULATION */
function init() {
    var loader = new Loader("#recipreViewForm");
    loader.showLoader();
    var recipesApi = new RecipesApi();
    recipesApi.getRecipe(window.RecipeId)
        .done(initControlsPopulation)
        .fail(RestClient.reportError)
        .always(() => loader.hideLoader());

    if(window.RecipeApprovaFlowState && window.RecipeApprovaFlowState >= Approval.getStates().inviata) {
        var recipeAuthorController = new Controller("#authorView");
        recipeAuthorController.loadComponent(views.AllComponents.author);
    }
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
    $("#recipreViewForm__titolo").val(Recipe.titolo_ricetta);
    $("#recipreViewForm__tempo_cottura").val(Recipe.tempo_cottura);
    $("#recipreViewForm__preparazione").val(Recipe.preparazione);
    $("#recipreViewForm__porzioni").val(Recipe.porzioni);
    $("#recipreViewForm__note").val(Recipe.note);
    $("#recipreViewForm__messaggio").val(Recipe.messaggio);
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
    var topologiesSelect = document.getElementById("recipreViewForm__tipologia");
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
        $(`#recipreViewForm__ingredient_id_${controlNumber}`).val(ingredient.id_ingrediente);
        $(`#recipreViewForm__ingredient_nome_${controlNumber}`).val(ingredient.nome_ingrediente);
        $(`#recipreViewForm__ingredient_quantita_${controlNumber}`).val(ingredient.quantita);
        $(`#recipreViewForm__ingredient_calorie_${controlNumber}`).val(ingredient.calorie);
    }
}

function createNewIngredientControl() {
    var ingredientsControlsContainer = $("#recipreViewForm__ingredients");
    var ingredientsCount = $("#recipreViewForm__ingredients .ingredientRow").length;    
    var currentControlNumber = ingredientsCount + 1;
    var html = `<div id="ingredientRow_${currentControlNumber}" class="ingredientRow form-row mt-2" data-rowid="${currentControlNumber}">
                    <input id="recipreViewForm__ingredient_id_${currentControlNumber}" class="ingredient_id_${currentControlNumber}" type="hidden">
                    <div class="col-sm-6 autocomplete">
                        <input id="recipreViewForm__ingredient_nome_${currentControlNumber}" 
                            class="form-control ingredient_nome_${currentControlNumber}" 
                            type="text" 
                            placeholder="ingrediente" 
                            disabled>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipreViewForm__ingredient_quantita_${currentControlNumber}" 
                            class="form-control ingredient_quantita_${currentControlNumber}" 
                            type="number" 
                            min="0.01" 
                            placeholder="qt." 
                            title="quantità" 
                            step="0.01" 
                            disabled>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipreViewForm__ingredient_calorie_${currentControlNumber}" 
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