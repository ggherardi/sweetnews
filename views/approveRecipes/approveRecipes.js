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
        { extend: "selectedSingle", text: "Visualizza e prendi in carico ricetta", action: viewRecipe }
    ],
    language: dataTableLanguage.italian,
    responsive: {
        details: {
            type: "inline"
        }
    }
};
var approvalDT = {};
var daPrendereInCaricoContainerSelector = "#daPrendereInCaricoContainer";
var daPrendereInCaricoContainer = $(daPrendereInCaricoContainerSelector);
var inCaricoContainerSelector = "#inCaricoContainer";
var inCaricoContainer = $(inCaricoContainerSelector);
var tutteContainerSelector = "#tutteContainer";
var tutteContainer = $(tutteContainerSelector);
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
        var tableId = e.relatedTarget.dataset["relatedtableid"]; // previous active tab
        $(tableId).html("");
        var func = e.target.dataset["relatedfunction"]; // previous active tab
        window[func]();
      })
    initDaPrendereInCaricoTab();
}

function initDaPrendereInCaricoTab() {
    var tableMapping = tablesMapping.daPrendereInCarico;
    var statePermissions = tableMapping.states.filter(x => x.check())[0];
    var approvalFlowApi = new ApprovalFlowApi();
    var loader = new Loader(daPrendereInCaricoContainerSelector); 
    loader.showLoader();
    approvalFlowApi.getAllRecipesWithStateInRange(statePermissions)
        .done(getAllRecipesWithStateSuccess.bind(tableMapping))
        .fail(RestClient.redirectAccordingToError)
        .always(() => loader.hideLoader());
}

function initInCaricoTab() {
    var tableMapping = tablesMapping.inCarico;
    var statePermissions = tableMapping.states.filter(x => x.check())[0];
    var approvalFlowApi = new ApprovalFlowApi();
    var loader = new Loader(inCaricoContainerSelector); 
    loader.showLoader();
    approvalFlowApi.getAllRecipesWithStateInRange(statePermissions)
        .done(getAllRecipesWithStateSuccess.bind(tableMapping))
        .fail(RestClient.redirectAccordingToError)
        .always(() => loader.hideLoader());
}

function initTutteTab() {
    var tableMapping = tablesMapping.tutte;
    var statePermissions = tableMapping.states.filter(x => x.check())[0];
    var approvalFlowApi = new ApprovalFlowApi();
    var loader = new Loader(tutteContainerSelector); 
    loader.showLoader();
    approvalFlowApi.getAllRecipesWithStateInRange(statePermissions)
        .done(getAllRecipesWithStateSuccess.bind(tableMapping))
        .fail(RestClient.redirectAccordingToError)
        .always(() => loader.hideLoader());
}

function getAllRecipesWithStateSuccess(data) {
    var recipes = JSON.parse(data);
    var html = `<table class="table mt-3" id="${this.tableName}">`
    html +=         BuidUserRecipesTableHead();
    html +=        `<tbody>`;            
    for(var i = 0; i < recipes.length; i++) {
        var recipe = recipes[i];
        var dateCell = formatDateCell(recipe.data_flusso);
            html +=     `<tr>
                            <td>${recipe.id_ricetta}</td>
                            <td>${recipe.id_utente_creatore}</td>
                            <td>${recipe.id_utente_approvatore}</td>
                            <td>${recipe.codice_stato_approvativo}</td>
                            <td>${recipe.titolo_ricetta}</td>  
                            <td>${recipe.nome_tipologia}</td>                           
                            <td>${recipe.username_utente_creatore}</td>
                            <td>${recipe.username_utente_approvatore ? recipe.username_utente_approvatore : "da prendere in carico"}</td>
                            <td>${recipe.nome_stato_approvativo}</td>
                            <td>${dateCell}</td>
                        </tr>`;
    }	
    html += `       </tbody>
                </table>`;
    this.tableContainer.html(html);
    approvalDT = $(`#${this.tableName}`).DataTable(approvalDTOptions);
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
                        <th scope="col">Autore</th>
                        <th scope="col">Approvatore</th>
                        <th scope="col">Stato approvativo</th>
                        <th scope="col">Data flusso</th>
                    </tr>
                </thead>`;
    return html;
}

function formatDateCell(strDate) {
    return shared.dateUtilities.formatDateFromString(strDate);
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

/* RIBBON BUTTONS ENABLE SCRIPTS */
function enableRecipeTakeCharge() {
    return window.RecipeApprovaFlowState == Approval.getStates().inviata && shared.loginContext.delega_codice == permissions.levels.redattore
}

/* INIT */
initApprovals();

