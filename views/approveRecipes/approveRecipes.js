window.RecipeId = 0;
var approvalDTOptions = {
    dom: 'Bftpil',
    buttons: true,
    select: true,
    columns: [
        { data: "id_ricetta" },
        { data: "id_utente_creatore" },
        { data: "id_utente_approvatore" },
        { data: "codice_stato_approvativo" },
        { data: "titolo_ricetta" },
        { data: "nome_tipologia" },
        { data: "difficolta" },
        { data: "username_utente_creatore" },
        { data: "username_utente_approvatore" },
        { data: "nome_stato_approvativo" },
        { data: "data_flusso" }
    ],
    columnDefs: [{
        targets: [ 0, 1, 2, 3 ],
        visible: false,
        searchable: false
    }],
    buttons: [
        // { text: "Crea nuova ricetta", action: createRecipe },
        // { text: "Modifica/Invia ricetta", className:"recipeEditButton", action: editRecipe, enabled: false },
        // { extend: "selectedSingle", text: "Visualizza ricetta", action: viewRecipe }
    ],
    language: dataTableLanguage.italian,
    responsive: {
        details: {
            type: "inline"
        }
    }
};
var approvalDT = {};
var daPrendereInCaricoContainerSelector = "#approvalContainer";
var daPrendereInCaricoContainer = $(daPrendereInCaricoContainerSelector);
var inCaricoContainerSelector = "#inCaricoContainer";
var inCaricoContainer = $(daPrendereInCaricoContainerSelector);
var tutteContainerSelector = "#tutteContainer";
var tutteContainer = $(daPrendereInCaricoContainerSelector);
var tablesMapping = {
    daPrendereInCarico: {
        states: [{
            check: function() { return permissions.levels.caporedattore == shared.loginContext.delega_codice},
            minState: Approval.getStates().idonea,
            maxState: Approval.getStates().idonea
        }, {
            check: function() { return permissions.levels.redattore == shared.loginContext.delega_codice},
            minState: Approval.getStates().inviata,
            maxState: Approval.getStates().inviata
        }],
        tableName: "daPrendereInCaricoTable",
        tableContainer: daPrendereInCaricoContainer
    },
    inCarico: {
        states: [{
            check: function() { return permissions.levels.caporedattore == shared.loginContext.delega_codice},
            minState: Approval.getStates().in_approvazione,
            maxState: Approval.getStates().approvata
        }, {
            check: function() { return permissions.levels.redattore == shared.loginContext.delega_codice},
            minState: Approval.getStates().in_validazione,
            maxState: Approval.getStates().idonea
        }],
        tableName: "inCaricoTable",
        tableContainer: inCaricoContainer
    },
    tutte: {
        states: [{
            check: function() { return permissions.levels.caporedattore == shared.loginContext.delega_codice},
            minState: Approval.getStates().inviata,
            maxState: Approval.getStates().approvata
        }, {
            check: function() { return permissions.levels.redattore == shared.loginContext.delega_codice},
            minState: Approval.getStates().inviata,
            maxState: Approval.getStates().approvata
        }],
        tableName: "tutteTable",
        tableContainer: tutteContainer
    }
};
var tableMapping;

function initApprovals() {
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        e.target // newly activated tab
        e.relatedTarget // previous active tab
      })
    // tableMapping = tablesMapping.filter(x => x.check())[0].permissions;
    initDaPrendereInCaricoTab();
}

function initDaPrendereInCaricoTab() {
    var tableMapping = tablesMapping.daPrendereInCarico;
    var approvalFlowApi = new ApprovalFlowApi();
    var loader = new Loader(daPrendereInCaricoContainerSelector); 
    loader.showLoader();
    approvalFlowApi.getAllRecipesWithState(statePermissions.daPrendereInCarico.minState, statePermissions.daPrendereInCarico.maxState)
        .done(getAllRecipesWithStateSuccess.bind(tableMapping))
        .fail(RestClient.redirectAccordingToError);
}

function initInCaricoTab() {
    var tableMapping = tablesMapping.inCarico;
    var approvalFlowApi = new ApprovalFlowApi();
    var loader = new Loader(inCaricoContainerSelector); 
    loader.showLoader();
    approvalFlowApi.getAllRecipesWithState(statePermissions.inCarico.minState, statePermissions.inCarico.maxState)
        .done(getAllRecipesWithStateSuccess.bind(tableMapping))
        .fail(RestClient.redirectAccordingToError);
}

function initDaPrendereInCaricoTab() {
    var tableMapping = tablesMapping.tutte;
    var approvalFlowApi = new ApprovalFlowApi();
    var loader = new Loader(tutteContainerSelector); 
    loader.showLoader();
    approvalFlowApi.getAllRecipesWithState(statePermissions.tutte.minState, statePermissions.tutte.maxState)
        .done(getAllRecipesWithStateSuccess.bind(tableMapping))
        .fail(RestClient.redirectAccordingToError);
}

function getAllRecipesWithStateSuccess(data) {
    var recipes = JSON.parse(data);
    var tableName = "ApprovalTable";
    var html = `<table class="table mt-3" id="${tableName}">`
    html +=         BuidUserRecipesTableHead();
    html +=        `<tbody>`;            
    for(var i = 0; i < recipes.length; i++) {
        var recipe = recipes[i];
        var difficultyCell = formatDifficultyCell(i);
            html +=     `<tr>
                            <td>${recipe.id_ricetta}</td>
                            <td>${recipe.id_utente_creatore}</td>
                            <td>${recipe.id_utente_approvatore}</td>
                            <td>${recipe.codice_stato_approvativo}</td>
                            <td>${recipe.titolo_ricetta}</td>  
                            <td>${recipe.nome_tipologia}</td>                           
                            <td>${difficultyCell}</td>
                            <td>${recipe.username_utente_creatore}</td>
                            <td>${recipe.username_utente_approvatore ? recipe.username_utente_approvatore : "da prendere in carico"}</td>
                            <td>${recipe.nome_stato_approvativo}</td>
                            <td>${recipe.data_flusso}</td>
                        </tr>`;
    }	
    html += `       </tbody>
                </table>`;
    approvaContainer.html(html);
    approvalDT = $(`#${tableName}`).DataTable(approvalDTOptions);
    setDifficultyCellsInTable(recipes);
    // enableEditButtonLogic();
}

function BuidUserRecipesTableHead() {
    var html = `<thead>
                    <tr>`;
    for(var i = 0; i < approvalDTOptions.columnDefs[0].targets.length; i++) {
        html += `       <th scope="col"></th>`;
    }
    html += `           <th scope="col">Titolo ricetta</th>
                        <th scope="col">Tipologia</th>
                        <th scope="col">Difficoltà</th>
                        <th scope="col">Autore</th>
                        <th scope="col">Approvatore</th>
                        <th scope="col">Stato approvativo</th>
                        <th scope="col">Data flusso</th>
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

// function enableEditButtonLogic() {
//     approvalDT.on("select deselect", (e, dt, node, config) => {
//         canEnableButton = dt.rows({selected: true}).data().length == 1 && dt.rows({selected: true}).data()[0].codice_stato_approvativo == Approval.getStates().bozza;
//         dt.buttons([".recipeEditButton"]).enable(canEnableButton);
//     });
// }

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

function viewRecipe(e, dt, node, config) {
    var row = dt.rows({ selected: true }).data()[0];
    window.RecipeId = row.id_ricetta;
    window.RecipeApprovaFlowState = row.codice_stato_approvativo;
    pageContentController.setSwitchableSecondaryPage(views.allForms.recipes.viewForm);
    pageContentController.switch();
}

function isRecipeEditable(e, dt, node, config) {
    console.log(dt);
    return false;
}

/* INIT */
initApprovals();

