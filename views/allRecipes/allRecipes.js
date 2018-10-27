AllIngredients = [];

function initFilters() {
    initCaloriesrange();
    populateTipologiaSelect();
    retrieveIngredientsFromDBAndInitAutocomplete();
}

function initCaloriesrange() {
    var recipesApi = new RecipesApi();
    recipesApi.getMaxCaloriesRecipe()
        .done(getMaxCaloriesRecipeSuccess)
        .fail(RestClient.redirectAccordingToError);
}

function getMaxCaloriesRecipeSuccess(data) {
    if(data && JSON.parse(data)) {
        var calories = JSON.parse(data);
        var maxCalories = Math.ceil(calories.calorie_massime);
        var slider = $("#filtersForm__calorie");
        slider.slider({
            range: true,
            min: 0,
            max: maxCalories,
            values:[0, maxCalories],
            slide: slideEvent
        });
        var textOverSliderLeft = $('<div class="sliderSpanText"><span id="sliderSpanTextLeft">0</span></div>');
        var textOverSliderRight = $(`<div class="sliderSpanText"><span id="sliderSpanTextRight">${maxCalories}</span></div>`);
        $(slider.children("span")[0]).html(textOverSliderLeft);
        $(slider.children("span")[1]).html(textOverSliderRight);
    }
}

function slideEvent(event, ui) {
    $("#sliderSpanTextLeft").text(ui.values[0]);
    $("#sliderSpanTextRight").text(ui.values[1]);
    // $("#amount").val("$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
  }

function populateTipologiaSelect() {
    var recipesApi = new RecipesApi();
    recipesApi.getRecipeTopologies()
        .done(getRecipeTopologiesSuccess)
        .fail(RestClient.redirectAccordingToError);
}

function getRecipeTopologiesSuccess(data) {
    topologies = JSON.parse(data);
    var topologiesSelect = document.getElementById("filtersForm__tipologia");
    for(var i = 0; i < topologies.length; i++) {
        let topology = topologies[i];
        let option = document.createElement("option");
        option.value = topology.id_tipologia;
        option.text = topology.nome_tipologia;        
        topologiesSelect.add(option);
    }
}

function retrieveIngredientsFromDBAndInitAutocomplete() {
    var recipesApi = new RecipesApi();
    recipesApi.getIngredients()
        .done((data) => { 
            if(data) {
                data = JSON.parse(data);
                AllIngredients = data;
                createNewIngredientControl();
            }
        })
        .fail(RestClient.reportError);
}

function createNewIngredientControl() {
    var ingredientsControlsContainer = $("#filtersForm__ingredients");
    var ingredientsCount = $("#filtersForm__ingredients .ingredientRow").length; 
    var currentControlNumber = ingredientsCount + 1;
    var html = `<div id="ingredientRow_${currentControlNumber}" class="ingredientRow form-row mt-2" data-rowid="${currentControlNumber}">
                    <input id="filtersForm__ingredient_id_${currentControlNumber}" class="ingredient_id_${currentControlNumber}" type="hidden">
                    <div class="col-11 autocomplete">
                        <input id="filtersForm__ingredient_nome_${currentControlNumber}" 
                            class="form-control ingredient_nome_${currentControlNumber}" 
                            type="text" 
                            placeholder="ingrediente">
                    </div>
                    <div class="col-1"><span class="icon fa-remove delete-cross c-pointer" onclick="deleteIngredientControl(this)"></span></div>
                </div>`;
    ingredientsControlsContainer.append(html);
    var ingredient = $(`#filtersForm__ingredient_nome_${currentControlNumber}`)[0];
    initAutoComplete(ingredient.id);
    switchAddIngredientButtonState(currentControlNumber);
}

function initAutoComplete(inputId) {
    var inputControl = document.getElementById(inputId);
    autocomplete(inputControl, AllIngredients);
}

function deleteIngredientControl(sender) {
    var controlNumber = $(sender).parents(".ingredientRow")[0].dataset["rowid"];
    $(sender).parents(".form-row").remove();        
    switchAddIngredientButtonState(controlNumber - 1);
}

function switchAddIngredientButtonState(ingredientControlNumber) {
    var button = document.getElementById("createIngredientControl");    
    button.disabled = parseInt(ingredientControlNumber) >= 5;
}

function getIngredientRow(ingredientControlNumber) {
    var ingredientRow = $(`#ingredientRow_${ingredientControlNumber}`);
    var inputs = ingredientRow.find(`input`);
    return inputs;
}

/* Form submit */
function findRecipes(sender, e) {
    e.preventDefault();
    var recipesApi = new RecipesApi();
    var clientFilters = getFilters();
    recipesApi.getRecipesAbstractsWithFilters(clientFilters)
        .done(getRecipesAbstractsWithFiltersSuccess)
        .fail(RestClient.redirectAccordingToError);
}

function getFilters() {

}

function getRecipesAbstractsWithFiltersSuccess(data) {
    console.log(data);
}

/* Init */
initFilters();