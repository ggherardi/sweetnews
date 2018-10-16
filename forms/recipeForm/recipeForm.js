var FormInitialState = [];
var WarningIds = [];
var AllIngredients = [];
var InitialIngredientsCount;
var WarningMessages = {
    saveWarning: "saveWarning",
    noIngredientsWarning: "noIngredientsWarning"
}

/* Autocomplete click override */
autoCompleteClickEvent = function(e){
    console.log("test");
    closeAllLists();
}

/* RIBBON ACTIONS */
function save() {
    if(ingredientsCount = $("#recipeNewForm__ingredients .form-row").length < 0) {

    } else {
        $("#recipeNewForm").submit();
        if(WarningIds[WarningMessages.saveWarning]) {
            removeWarning(WarningMessages.saveWarning);
        }
    }
    // Restart form initial state
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
    
}

/* FORM POPULATION */
function init() {
    populateTipologiaSelect();
    populateIngredientsControl();
    retrieveIngredientsFromDBAndInitAutocomplete();
    getInitialState();
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

function populateIngredientsControl() {
    createNewIngredientControl();
}

function createNewIngredientControl() {
    var ingredientsControlsContainer = $("#recipeNewForm__ingredients");
    var ingredientsCount = $("#recipeNewForm__ingredients .form-row").length;    
    if(ingredientsCount == 0) {
        removeWarning(WarningMessages.noIngredientsWarning);
    }
    if(!isFormStateDirty()) {
        removeWarning(WarningMessages.saveWarning);
    }
    var currentControlNumber = ingredientsCount + 1;
    var html = `<div class="ingredientRow form-row mt-2" data-rowid="${currentControlNumber}">
                    <input id="recipeNewForm__ingredient_id_${currentControlNumber}" type="hidden">
                    <div class="col-sm-5 autocomplete">
                        <input id="recipeNewForm__ingredient_nome_${currentControlNumber}" class="form-control" type="text" placeholder="ingrediente" required>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipeNewForm__ingredient_quantita_${currentControlNumber}" class="form-control" type="number" min="0" placeholder="qt." title="quantità" required>
                    </div>
                    <div class="col-sm-3">
                        <input id="recipeNewForm__ingredient_calorie_${currentControlNumber}" class="form-control" type="number" min="0" placeholder="cal." title="calorie" required disabled>
                    </div>
                    <div class="col-sm-1"><span class="icon fa-remove delete-cross c-pointer" onclick="deleteIngredientControl(this)"></span></div>
                </div>`;
    ingredientsControlsContainer.append(html);
}

function deleteIngredientControl(sender) {
    $(sender).parents(".form-row").remove();        
    if($(".ingredientRow").length < 1) {
        var id = Ribbon.setMessage("Attenzione, la ricetta deve contenere almeno un ingrediente");
        WarningIds[WarningMessages.noIngredientsWarning] = id;
    }
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
            }
        })
        .fail(RestClient.reportError);
}

function initAutoComplete(inputId) {
    var inputControl = document.getElementById(inputId);
    autocomplete(inputControl, AllIngredients);
}

function getInitialState() {
    InitialIngredientsCount = 1;
    var controls = $("#recipeNewForm").find(".form-control");
    for(var i = 0; i < controls.length; i++) {
	    var control = controls[i];
        FormInitialState[control.id] = { value: control.value, isDirty: false };
        control.addEventListener("change", checkCurrentstate);
    }
}

function checkCurrentstate(e) {
    var controlId = e.srcElement.id;
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
function test(sender, e) {
    e.preventDefault();
    console.log("test");
}

function getRecipeFromForm() {
    $("#recipeNewForm__difficolta input:checked"); //difficoltà
    $("#recipeNewForm__ingredients .form-row").first().find("input.recipeNewForm__ingredient_quantita"); //ingredienti
}

/* AUX */
function removeWarning(warning) {
    if(WarningIds[warning]) {
        var id = WarningIds[warning];
        Ribbon.removeMessage(id);
        WarningIds[warning] = undefined;
    }
}

/* Init */
init();