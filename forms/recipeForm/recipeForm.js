function init() {
    populateTipologiaSelect();
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

/* Events */
function save() {
    console.log("test");
}

function getRecipeFromForm() {
    $("#recipeNewForm__difficolta input:checked");
}

/* Init */
init();