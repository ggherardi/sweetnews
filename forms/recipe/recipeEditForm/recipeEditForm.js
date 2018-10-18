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
function save() {
    var form = $("#recipeEditForm");
    if(form[0].reportValidity() && $("#recipeEditForm__ingredients .form-row").length > 0) {
        $("#submitForm").click();
    } 
}

function back() {
    if(WarningIds[WarningMessages.saveWarning]) { 
        if(!window.confirm(`Attenzione, tornando indietro verranno perse le modifiche non salvate.`)) {
            return;
        }
    }    
    pageContentController.switch();
}

function send() {
    if(WarningIds[WarningMessages.saveWarning]) { 
        if(!window.confirm(`Vuoi salvare le modifiche prima di inviare la ricetta in approvazione?`)) {
            return;
        }
    }    
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
    if(data) {
        Recipe = JSON.parse(data);
        populateTextControls();
        populateRadioControl();
        populateTipologiaSelect();
        populateIngredientsControl();
        retrieveIngredientsFromDBAndInitAutocomplete();
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
    var ingredientsCount = $("#recipeEditForm__ingredients .form-row").length;    
    if(ingredientsCount == 0) {
        removeWarning(WarningMessages.noIngredientsWarning);
    }
    if(!isFormStateDirty()) {
        removeWarning(WarningMessages.saveWarning);
    }
    var currentControlNumber = ingredientsCount + 1;
    var html = `<div id="ingredientRow_${currentControlNumber}" class="ingredientRow form-row mt-2" data-rowid="${currentControlNumber}">
                    <input id="recipeEditForm__ingredient_id_${currentControlNumber}" class="ingredient_id_${currentControlNumber}" type="hidden">
                    <div class="col-sm-5 autocomplete">
                        <input id="recipeEditForm__ingredient_nome_${currentControlNumber}" 
                            class="form-control ingredient_nome_${currentControlNumber}" 
                            type="text" 
                            placeholder="ingrediente" 
                            required>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipeEditForm__ingredient_quantita_${currentControlNumber}" 
                            class="form-control ingredient_quantita_${currentControlNumber}" 
                            type="number" 
                            min="0" 
                            placeholder="qt." 
                            title="quantità" 
                            step="0.01" 
                            required>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipeEditForm__ingredient_calorie_${currentControlNumber}" 
                            class="form-control ingredient_calorie_${currentControlNumber}" 
                            type="number" 
                            min="0" 
                            placeholder="cal." 
                            title="calorie" 
                            step="0.01" 
                            required 
                            disabled>
                    </div>
                    <div class="col-sm-1"><span class="icon fa-remove delete-cross c-pointer" onclick="deleteIngredientControl(this)"></span></div>
                </div>`;
    ingredientsControlsContainer.append(html);
    var ingredient = $(`#recipeEditForm__ingredient_nome_${currentControlNumber}`)[0];
    ingredient.addEventListener("change", checkCurrentstate);
    initAutoComplete(ingredient.id);
    switchAddIngredientButtonState(currentControlNumber);
}

function deleteIngredientControl(sender) {
    var controlNumber = $(sender).parents(".ingredientRow")[0].dataset["rowid"];
    var rowInputs = getIngredientRow(controlNumber);
    restoreIngredientRowStateToPristine(rowInputs);
    $(sender).parents(".form-row").remove();        
    if($(".ingredientRow").length < 1) {
        var id = Ribbon.setMessage("Attenzione, la ricetta deve contenere almeno un ingrediente");
        WarningIds[WarningMessages.noIngredientsWarning] = id;
    }
    switchAddIngredientButtonState(controlNumber - 1);
}

function getIngredientRow(ingredientControlNumber) {
    var ingredientRow = $(`#ingredientRow_${ingredientControlNumber}`);
    var inputs = ingredientRow.find(`input`);
    return inputs;
}

function restoreIngredientRowStateToPristine(inputs) {
    for(var i = 0; i < inputs.length; i++) {
        var row = inputs[i];
        if(FormInitialState[row.id]) {
            FormInitialState[row.id].isDirty = false;
        }
    }
}

function switchAddIngredientButtonState(ingredientControlNumber) {
    var button = document.getElementById("createIngredientControl");    
    button.disabled = parseInt(ingredientControlNumber) >= 10;
}

function retrieveIngredientsFromDBAndInitAutocomplete() {
    var recipesApi = new RecipesApi();
    recipesApi.getIngredients()
        .done((data) => { 
            if(data) {
                data = JSON.parse(data);
                AllIngredients = data;
                var ingredientsControls = $("[id^=recipeEditForm__ingredient_nome_]");
                for(var i = 0; i < ingredientsControls.length; i++) {                    
                    initAutoComplete(ingredientsControls[i].id);
                }
                getInitialState();                
            }
        })
        .fail(RestClient.reportError);
}

function initAutoComplete(inputId) {
    var inputControl = document.getElementById(inputId);
    autocomplete(inputControl, AllIngredients);
}

/* State check */
function getInitialState() {
    InitialIngredientsCount = $(".ingredientRow").length;
    var controls = $("#recipeEditForm").find(".form-control");
    for(var i = 0; i < controls.length; i++) {
	    var control = controls[i];
        FormInitialState[control.id] = { value: control.value, isDirty: false };
        control.addEventListener("change", checkCurrentstate);
    }
}

function checkCurrentstate(e) {
    var controlId = e.srcElement.id;
    if(!FormInitialState[controlId]) {
        return;
    }
    FormInitialState[controlId].isDirty = e.srcElement.value != FormInitialState[controlId].value;
    currentIngredientsCount = $(".ingredientRow").length;
    if(isFormStateDirty() || currentIngredientsCount != InitialIngredientsCount){
        if(!WarningIds[WarningMessages.saveWarning]) {
            var messageId = Ribbon.setMessage(`Premere su "Salva" per salvare le modifiche.`);
            WarningIds[WarningMessages.saveWarning] = messageId;
        }
    } else {
        removeWarning(WarningMessages.saveWarning);
    }
}

function isFormStateDirty() {
    for(var key in FormInitialState) {
        if(FormInitialState[key].isDirty) {
            return true;
        }
    }
    return false;
}

/* EVENTS */
function editRecipe(sender, e) {
    e.preventDefault();
    var loader = new Loader("#recipeEditForm");
    loader.showLoader();
    var recipeForm = getRecipeFromForm();
    recipeForm.id_ricetta = window.RecipeId;
    var recipesApi = new RecipesApi();
    recipesApi.editRecipe(recipeForm)
        .done(saveSuccess)
        .fail(saveFail)
        .always(() => loader.hideLoader());
    // Restart form initial state
}

function saveSuccess(data) {
    console.log(data);
    pageContentController.setSwitchableSecondaryPage(views.allForms.recipes.editForm);
    initPersonalRecipes();
}

function saveFail(jqXHR) {
    console.log(jqXHR);
}

function getRecipeFromForm() {
    var recipe = {
        id_tipologia : $("#recipeEditForm__tipologia").val(),
        titolo_ricetta : $("#recipeEditForm__titolo").val(),
        difficolta : $("#recipeEditForm__difficolta input:checked").val(),
        tempo_cottura : $("#recipeEditForm__tempo_cottura").val(),
        preparazione : $("#recipeEditForm__preparazione").val(),
        porzioni : $("#recipeEditForm__porzioni").val(),
        note : $("#recipeEditForm__note").val(),
        messaggio : $("#recipeEditForm__messaggio").val(),
        lista_ingredienti : getIngredientsFromForm()
    };
    return recipe;
}

function getIngredientsFromForm() {
    var ingredients = [];
    var ingredientsRows = $("#recipeEditForm__ingredients .ingredientRow");
    for(var i = 0; i < ingredientsRows.length; i++) {
        var ingredientRow = ingredientsRows[i];
        var rowid = ingredientRow.dataset["rowid"];
        var ingredient = {};
        ingredient.id_ingrediente = $(`#recipeEditForm__ingredient_id_${rowid}`).val(),
        ingredient.quantita = $(`#recipeEditForm__ingredient_quantita_${rowid}`).val()
        ingredients.push(ingredient);
    }
    return ingredients;
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