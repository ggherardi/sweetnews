var userRecipesDTOptions = {
    dom: 'Bftpil',
    buttons: true,
    select: true,
    columns: [
        { data: "id_ricetta" },
        { data: "codice_stato_approvativo" },
        { data: "preparazione" },
        { data: "note" },
        { data: "ingredienti" },
        {
            class: "more-details",
            orderable: false,
            data: null,
            defaultContent: ""
        },
        { data: "titolo_ricetta" },
        { data: "tipologia" },
        { data: "difficolta" },
        { data: "tempo_cottura" },
        { data: "porzioni" },
        { data: "nome_stato_approvativo" }
    ],
    columnDefs: [{
        targets: [ 0, 1, 2, 3, 4 ],
        visible: false,
        searchable: false
    }],
    buttons: [
        { text: "Crea nuova ricetta", action: createRecipe },
        { extend: "selectedSingle", text: "Visualizza ricetta", action: viewRecipe }
    ],
    language: dataTableLanguage.italian
};
var userRecipesDT = {};
var userRecipesContainerSelector = "#userRecipesContainer";
var userRecipesContainer = $(userRecipesContainerSelector);

function init() {
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
        recipe.cast = castCellRender;
            html +=     `<tr>
                            <td>${recipe.id_ricetta}</td>
                            <td>${recipe.codice_stato_approvativo}</td>
                            <td>${recipe.preparazione}</td>  
                            <td>${recipe.note}</td>                           
                            <td></td>
                            <td>${recipe.titolo}</td>
                            <td>${recipe.tipologia} minuti</td>
                            <td>${recipe.difficolta} €</td>
                            <td>${recipe.tempo_cottura}</td>
                            <td>${recipe.porzioni}</td>
                            <td>${recipe.nome_stato_approvativo}</td>
                        </tr>`;
    }	
    html += `       </tbody>
                </table>`;
    userRecipesContainer.html(html);
    userRecipesDT = $(`#${tableName}`).DataTable(userRecipesDTOptions);
}

function BuidUserRecipesTableHead() {
    var html = `<thead>
                    <tr>`;
    for(var i = 0; i < userRecipesDTOptions.columnDefs[0].targets.length + 1; i++) {
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

function createRecipe() {

}

function viewRecipe() {

}

init();

