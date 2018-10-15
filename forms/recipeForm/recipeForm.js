
/* Ribbon actions */
function save() {
    $("#recipeNewForm").submit();
}

function back() {
    if(window.confirm(`Attenzione, tornando indietro verranno perse le modifiche non salvate.`)) {
        pageContentController.switch();
    }
}

function send() {
    
}

/* Form Population */
function init() {
    $("#recipeNewForm").
    populateTipologiaSelect();
    populateIngredientsControl();
}

function getInitialState() {
    var formInitialState = [];
    for(var i = 0; i < controls.length; i++) {
	    var control = controls[i];
	    control.addEventListener("onchange", () => )
    }
}

function populateTipologiaSelect() {
    var recipesApi = new RecipesApi();
    recipesApi.getRecipeTopologies()
        .done(getRecipeTopologiesSuccess)
        .fail(RestClient.redirectAccordingToError);
}

function getRecipeTopologiesSuccess(data) {
    topologies = JSON.parse(data);
    console.log(topologies);
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
    var currentControlNumber = ingredientsCount + 1;
    var html = `<div class="form-row mt-2">
                    <div class="col-sm-5">
                        <input class="form-control recipeNewForm__ingredient" type="text" placeholder="ingrediente" required>
                    </div>
                    <div class="col-sm-3">
                        <input class="form-control recipeNewForm__ingredient_quantita" type="number" min="0" placeholder="qt." title="quantità" required>
                    </div>
                    <div class="col-sm-3">
                        <input class="form-control recipeNewForm__ingredient_calorie" type="number" min="0" placeholder="cal." title="calorie" required>
                    </div>
                    <div class="col-sm-1"><span class="icon fa-remove delete-cross c-pointer" onclick="deleteIngredientControl(this)"></span></div>
                </div>`;
    ingredientsControlsContainer.append(html);
}

function deleteIngredientControl(sender) {
    $(sender).parents(".form-row").remove();
}

/* Events */
function test(sender, e) {
    e.preventDefault();
    console.log("test");
}

function getRecipeFromForm() {
    $("#recipeNewForm__difficolta input:checked"); //difficoltà
    $("#recipeNewForm__ingredients .form-row").first().find("input.recipeNewForm__ingredient_quantita"); //ingredienti
}

/* Init */
init();