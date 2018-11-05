RecipeId = 0;
FormInitialState = [];
WarningIds = [];
AllIngredients = [];
InitialIngredientsCount = 1;
WarningMessages = {
    saveWarning: "saveWarning",
    noIngredientsWarning: "noIngredientsWarning"
}

/* RIBBON ACTIONS */
function save() {
    var form = $("#recipeNewForm");
    if(form[0].reportValidity() && $("#recipeNewForm__ingredients .form-row").length > 0) {
        $("#submitForm").click();
    } 
}

function back() {
    if(WarningIds[WarningMessages.saveWarning]) { 
        if(!window.confirm(`Attenzione, tornando indietro verranno perse le modifiche non salvate.`)) {
            resetVariables();
            return;
        }
    }
    pageContentController.switch();
}

/* FORM POPULATION */
function init() {
    populateTipologiaSelect();
    populateIngredientsControl();
    retrieveIngredientsFromDBAndInitAutocomplete();
}

function populateTipologiaSelect() {
    var recipesApi = new RecipesApi();
    recipesApi.getRecipeTopologies()
        .done(getRecipeTopologiesSuccess)
        .fail(RestClient.redirectAccordingToError);
}

function getRecipeTopologiesSuccess(data) {
    topologies = JSON.parse(data);
    var topologiesSelect = document.getElementById("recipeNewForm__tipologia");
    for(var i = 0; i < topologies.length; i++) {
        let topology = topologies[i];
        let option = document.createElement("option");
        option.value = topology.id_tipologia;
        option.text = topology.nome_tipologia;        
        topologiesSelect.add(option);
    }
}

/* Ingredients controls */
function populateIngredientsControl() {
    createNewIngredientControl();
}

function createNewIngredientControl() {
    var ingredientsControlsContainer = $("#recipeNewForm__ingredients");
    var ingredientsCount = $("#recipeNewForm__ingredients .ingredientRow").length;    
    if(ingredientsCount == 0) {
        removeWarning(WarningMessages.noIngredientsWarning);
    }
    if(!isFormStateDirty()) {
        removeWarning(WarningMessages.saveWarning);
    }
    var currentControlNumber = ingredientsCount + 1;
    var html = `<div id="ingredientRow_${currentControlNumber}" class="ingredientRow form-row mt-2" data-rowid="${currentControlNumber}">
                    <input id="recipeNewForm__ingredient_id_${currentControlNumber}" class="ingredient_id_${currentControlNumber}" type="hidden">
                    <div class="col-sm-5 autocomplete">
                        <input id="recipeNewForm__ingredient_nome_${currentControlNumber}" 
                            class="form-control ingredient_nome_${currentControlNumber}" 
                            type="text" 
                            placeholder="ingrediente" 
                            required>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipeNewForm__ingredient_quantita_${currentControlNumber}" 
                            class="form-control ingredient_quantita_${currentControlNumber}" 
                            type="number" 
                            min="0.01" 
                            placeholder="gr"
                            title="quantità" 
                            step="0.01" 
                            required>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipeNewForm__ingredient_calorie_hidden_${currentControlNumber}" class="ingredient_calorie_hidden_${currentControlNumber}" type="hidden">
                        <input id="recipeNewForm__ingredient_calorie_${currentControlNumber}" 
                            class="form-control ingredient_calorie_${currentControlNumber} caloriesToSum" 
                            type="number" 
                            min="0.01" 
                            placeholder="kcal/g" 
                            title="calorie" 
                            step="0.01" 
                            required 
                            disabled>
                    </div>
                    <div class="col-sm-1"><span class="icon fa-remove delete-cross c-pointer" onclick="deleteIngredientControl(this)"></span></div>
                </div>`;
    ingredientsControlsContainer.append(html);
    var ingredient = $(`#recipeNewForm__ingredient_nome_${currentControlNumber}`)[0];
    var quantity = $(`#recipeNewForm__ingredient_quantita_${currentControlNumber}`)[0];
    ingredient.addEventListener("change", checkCurrentstate);
    quantity.addEventListener("keyup", recalculateCalories);
    quantity.addEventListener("keyup", recalculateTotalCalories);
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

function recalculateCalories(e) {
    var jqElement = $(e.srcElement);    
    var newQuantity = jqElement.val() ? parseFloat(jqElement.val()) : 1;
    var rowid = jqElement.parent().parent().get(0).dataset["rowid"];
    var calories = parseFloat(jqElement.parent().siblings().find(`.ingredient_calorie_hidden_${rowid}`).val());
    var newCaloriesAmount = newQuantity * calories;
    jqElement.parent().siblings().find(`.ingredient_calorie_${rowid}`).val(newCaloriesAmount);
}

function recalculateTotalCalories() {
    var calories = $(".caloriesToSum");
    var total = 0;
    for(var i = 0; i < calories.length; i++) {
        total += parseFloat(calories[i].value);
    }
    $("#recipeViewForm__ingredient_calorie_totali").val(new Number(total).toFixed(1));
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
                var ingredientsControls = $("[id^=recipeNewForm__ingredient_nome_]");
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
    InitialIngredientsCount = 1;
    var controls = $("#recipeNewForm").find(".form-control");
    for(var i = 0; i < controls.length; i++) {
	    var control = controls[i];
        FormInitialState[control.id] = { value: control.value, isDirty: false };
        control.addEventListener("keydown", checkCurrentstate);
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
function insertRecipe(sender, e) {
    e.preventDefault();
    var loader = new Loader("#recipeNewForm");
    loader.showLoader();
    var recipeForm = getRecipeFromForm();
    var recipesApi = new RecipesApi();
    recipesApi.insertRecipe(recipeForm)
        .done(saveSuccess)
        .fail(RestClient.reportError)
        .always(() => loader.hideLoader());
    // Restart form initial state
}

function saveSuccess(data) {    
    RecipeId = data;
    pageContentController.setSwitchableSecondaryPage(views.allForms.recipes.editForm);
    initPersonalRecipes();
}

function getRecipeFromForm() {
    var ingredients = getIngredientsFromForm();
    var recipe = {
        id_tipologia : $("#recipeNewForm__tipologia").val(),
        titolo_ricetta : $("#recipeNewForm__titolo").val(),
        difficolta : $("#recipeNewForm__difficolta input:checked").val() ? $("#recipeNewForm__difficolta input:checked").val() : 1,
        tempo_cottura : $("#recipeNewForm__tempo_cottura").val(),
        preparazione : $("#recipeNewForm__preparazione").val(),
        porzioni : $("#recipeNewForm__porzioni").val(),
        note : $("#recipeNewForm__note").val(),
        messaggio : $("#recipeNewForm__messaggio").val(),
        lista_ingredienti : ingredients.list,
        calorie_totali: ingredients.totalCalories
    };
    return recipe;
}

function getIngredientsFromForm() {
    var ingredients = {
        list: [],
        totalCalories: 0
    }
    var ingredientsRows = $("#recipeNewForm__ingredients .ingredientRow");
    for(var i = 0; i < ingredientsRows.length; i++) {
        var ingredientRow = ingredientsRows[i];
        var rowid = ingredientRow.dataset["rowid"];
        var calories = $(`#recipeNewForm__ingredient_calorie_${rowid}`).val();
        ingredients.totalCalories += parseFloat(calories);
        var ingredient = {};
        ingredient.id_ingrediente = $(`#recipeNewForm__ingredient_id_${rowid}`).val(),
        ingredient.quantita = $(`#recipeNewForm__ingredient_quantita_${rowid}`).val(),
        ingredients.list.push(ingredient);
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
    delete RecipeId;
    delete FormInitialState;
    delete WarningIds;
    delete AllIngredients;
    delete InitialIngredientsCount;
    delete WarningMessages;
}

/* Init */
init();