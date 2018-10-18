window.RecipeId = 0;
var userRecipesDTOptions = {
    dom: 'Bftpil',
    buttons: true,
    select: true,
    columns: [
        { data: "id_ricetta" },
        { data: "codice_stato_approvativo" },
        { data: "preparazione" },
        { data: "note" },
        // { data: "ingredienti" },
        // {
        //     class: "more-details",
        //     orderable: false,
        //     data: null,
        //     defaultContent: ""
        // },
        { data: "titolo_ricetta" },
        { data: "tipologia" },
        { data: "difficolta" },
        { data: "tempo_cottura" },
        { data: "porzioni" },
        { data: "nome_stato_approvativo" }
    ],
    columnDefs: [{
        targets: [ 0, 1, 2, 3 ],
        visible: false,
        searchable: false
    }],
    buttons: [
        { text: "Crea nuova ricetta", action: createRecipe },
        { extend: "selectedSingle", text: "Modifica/Invia ricetta", action: editRecipe }
    ],
    language: dataTableLanguage.italian,
    responsive: {
        details: {
            type: "inline"
        }
    }
};
var userRecipesDT = {};
var userRecipesContainerSelector = "#userRecipesContainer";
var userRecipesContainer = $(userRecipesContainerSelector);

function initPersonalRecipes() {
    var recipesApi = new RecipesApi();
    var loader = new Loader(userRecipesContainerSelector); 
    loader.showLoader();
    recipesApi.getRecipesForUser()
        .done(getRecipesForUserSuccess)
        .fail();
}

function getRecipesForUserSuccess(data) {
    var recipes = JSON.parse(data);
    var tableName = "UserRecipesTable";
    var html = `<table class="table mt-3" id="${tableName}">`
    html +=         BuidUserRecipesTableHead();
    html +=        `<tbody>`;            
    for(var i = 0; i < recipes.length; i++) {
        var recipe = recipes[i];
        var difficultyCell = formatDifficultyCell(i);
            html +=     `<tr>
                            <td>${recipe.id_ricetta}</td>
                            <td>${recipe.codice_stato_approvativo}</td>
                            <td>${recipe.preparazione}</td>  
                            <td>${recipe.note}</td>                           
                            <td>${recipe.titolo_ricetta}</td>
                            <td>${recipe.nome_tipologia}</td>
                            <td>${difficultyCell}</td>
                            <td>${recipe.tempo_cottura} min</td>
                            <td>${recipe.porzioni}</td>
                            <td>${recipe.nome_stato_approvativo}</td>
                        </tr>`;
    }	
    html += `       </tbody>
                </table>`;
    userRecipesContainer.html(html);
    userRecipesDT = $(`#${tableName}`).DataTable(userRecipesDTOptions);
    setDifficultyCellsInTable(recipes);
}

function BuidUserRecipesTableHead() {
    var html = `<thead>
                    <tr>`;
    for(var i = 0; i < userRecipesDTOptions.columnDefs[0].targets.length; i++) {
        html += `       <th scope="col"></th>`;
    }
    html += `           <th scope="col">Titolo</th>
                        <th scope="col">Tipologia</th>
                        <th scope="col">Difficoltà</th>
                        <th scope="col">Tempo cottura</th>
                        <th scope="col">Porzioni</th>
                        <th scope="col">Stato approvazione</th>
                    </tr>
                </thead>`;
    return html;
}

function formatDifficultyCell(i) {
    return `<form>
                <div class="rate rate-displayOnly">
                    <input type="radio" id="star5_${i}" name="rate" value="5" disabled />
                    <label for="star5_${i}" title="text">5 stars</label>
                    <input type="radio" id="star4_${i}" name="rate" value="4" disabled />
                    <label for="star4_${i}" title="text">4 stars</label>
                    <input type="radio" id="star3_${i}" name="rate" value="3" disabled />
                    <label for="star3_${i}" title="text">3 stars</label>
                    <input type="radio" id="star2_${i}" name="rate" value="2" disabled />
                    <label for="star2_${i}" title="text">2 stars</label>
                    <input type="radio" id="star1_${i}" name="rate" value="1" disabled />
                    <label for="star1_${i}" title="text">1 star</label>
                </div>
            </form>`;
}

function setDifficultyCellsInTable(recipes) {
    for(var i = 0; i < recipes.length; i++) {
        var recipe = recipes[i];
        $(`#star${recipe.difficolta}_${i}`).prop("checked", true);
    }
}

/* BUTTONS */
function createRecipe() {
    pageContentController.setSwitchableSecondaryPage(views.allForms.recipes.newForm);
    pageContentController.switch();
}

function editRecipe(e, dt, node, config) {
    window.RecipeId = dt.rows({ selected: true }).data()[0].id_ricetta;
    pageContentController.setSwitchableSecondaryPage(views.allForms.recipes.editForm);
    pageContentController.switch();
}

/* INIT */
initPersonalRecipes();

