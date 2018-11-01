Recipe = {};
FormInitialState = [];
WarningIds = [];
AllIngredients = [];
InitialIngredientsCount = 0;
WarningMessages = {
    approvalFlowWarning: "approvalFlowWarning",
    saveWarning: "saveWarning",
    noIngredientsWarning: "noIngredientsWarning",
    loadingError: "loadingError"
}

/* RIBBON ACTIONS */
function back() {
    pageContentController.switch();
}

function takeCharge() {
    Ribbon.removeMessage(WarningIds[WarningMessages.approvalFlowWarning]);
    var approvalFlowApi = new ApprovalFlowApi();
    var parameters = {
        id_stato_approvativo_valutazione: Recipe.id_stato_approvativo_valutazione,
        id_ricetta: Recipe.id_ricetta
    };
    approvalFlowApi.startApprovalValidation(parameters)
        .done(startApprovalValidationSuccess)
        .fail(RestClient.reportError);
}

function startApprovalValidationSuccess(data) {
    if(data && JSON.parse(data)) {
        data = JSON.parse(data);
        window.RecipeApprover = data.id_utente_approvatore;
        window.RecipeApprovaFlowState = data.codice_stato_approvativo;
        pageContentController.setSwitchableSecondaryPage(views.allForms.recipes.viewForm);
        pageContentController.switch();
        initApprovals(window.TableSource);
    } else {
        flowError();
    }
}

function approve() {
    approveReject(Recipe.id_stato_approvativo_approvazione);
}

function reject() {
    approveReject(Recipe.id_stato_approvativo_rifiuto);
} 

function approveReject(idNextstep) {
    Ribbon.removeMessage(WarningIds[WarningMessages.approvalFlowWarning]);
    var approvalFlowApi = new ApprovalFlowApi();
    var parameters = {
        idNextStep: idNextstep,
        id_ricetta: Recipe.id_ricetta
    };
    approvalFlowApi.approveRejectRecipe(parameters)
        .done(approveRejectSuccess)
        .fail(RestClient.reportError);
}

function approveRejectSuccess(data) {
    if(data && JSON.parse(data)) {
        data = JSON.parse(data);
        window.RecipeApprover = data.id_utente_approvatore;
        window.RecipeApprovaFlowState = data.codice_stato_approvativo;
        pageContentController.setSwitchableSecondaryPage(views.allForms.recipes.viewForm);
        pageContentController.switch();
        initApprovals(window.TableSource);
    } else {
        flowError();
    }
}

/* FORM POPULATION */
function init() {
    initErrorMessages();
    var loader = new Loader("#recipreViewForm");
    loader.showLoader();
    var recipesApi = new RecipesApi();
    recipesApi.getRecipe(window.RecipeId)
        .done(initControlsPopulation)
        .fail(RestClient.reportError)
        .always(() => loader.hideLoader());

    if(window.RecipeApprovaFlowState && window.RecipeApprovaFlowState >= Approval.getStates().inviata && shared.loginContext.isDipendente) {
        var recipeAuthorController = new Controller("#authorView");
        recipeAuthorController.loadComponent(views.AllComponents.author);
    }
}

function initErrorMessages() {
    if(window.ButtonEnablingWarningMessages) {
        for(var i = 0; i < window.ButtonEnablingWarningMessages.length; i ++) {
            Ribbon.setMessage(window.ButtonEnablingWarningMessages[i]);        
        }
        delete window.ButtonEnablingWarningMessages;
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
        var ingredientCalories = parseFloat(ingredient.quantita) * parseFloat(ingredient.calorie);
        createNewIngredientControl();
        $(`#recipreViewForm__ingredient_id_${controlNumber}`).val(ingredient.id_ingrediente);
        $(`#recipreViewForm__ingredient_nome_${controlNumber}`).val(ingredient.nome_ingrediente);
        $(`#recipreViewForm__ingredient_quantita_${controlNumber}`).val(ingredient.quantita);
        $(`#recipreViewForm__ingredient_calorie_${controlNumber}`).val(ingredientCalories);
    }
    $("#recipeViewForm__ingredient_calorie_totali").val(parseFloat(Recipe.calorie_totali));
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
                            class="form-control ingredient_calorie_${currentControlNumber} caloriesToSum" 
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

function recalculateTotalCalories() {
    var calories = $(".caloriesToSum");
    var total = 0;
    for(var i = 0; i < calories.length; i++) {
        total += parseFloat(calories[i].value);
    }
    $("#recipeViewForm__ingredient_calorie_totali").val(new Number(total).toFixed(1));
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

function flowError() {
    var messageId = Ribbon.setMessage("Si è verificato un errore durante l'avanzamento del flusso.");
    WarningIds[WarningMessages.approvalFlowWarning] = messageId;
}

/* Init */
init();