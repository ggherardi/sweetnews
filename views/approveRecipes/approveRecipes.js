window.RecipeId = 0;
var approvalDTOptions = {
    dom: 'Bftpil',
    buttons: true,
    select: true,
    columns: [
        { data: "data_flusso_orderable" },
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
        targets: [ 0, 1, 2, 3, 4 ],
        visible: false,
        searchable: false
    }],
    order: [
        [0, "asc"]
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
var rifiutateContainerSelector = "#rifiutateContainer";
var rifiutateContainer = $(rifiutateContainerSelector);
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
        userValidation: {
            needed: true,
            currentUser: false
        },
        dateValidation: true,
        tableName: "daPrendereInCaricoTable",
        tableContainer: daPrendereInCaricoContainer,
        buttons: [
            { extend: "selectedSingle", text: "Visualizza e prendi in carico ricetta", action: viewRecipe.bind("daPrendereInCarico") }
        ]
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
        userValidation: {
            needed: true,
            currentUser: true
        },
        dateValidation: true,
        tableName: "inCaricoTable",
        tableContainer: inCaricoContainer,
        buttons: [
            { extend: "selectedSingle", text: "Approva/Rifiuta Ricetta", action: viewRecipe.bind("inCarico") }
        ]
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
        userValidation: {
            needed: false,
            currentUser: true
        },
        dateValidation: false,
        tableName: "tutteTable",
        tableContainer: tutteContainer,
        buttons: [
            { extend: "selectedSingle", text: "Visualizza ricetta", action: viewRecipe.bind("tutte") }
        ]
    },
    rifiutate: {
        states: [{
            check: function() { return permissions.levels.caporedattore == shared.loginContext.delega_codice},
            minState: null,
            maxState: null
        }, {
            check: function() { return permissions.levels.redattore == shared.loginContext.delega_codice},
            minState: null,
            maxState: null
        }],
        userValidation: {
            needed: null,
            currentUser: null
        },
        dateValidation: false,
        tableName: "rifiutateTable",
        tableContainer: rifiutateContainer,
        buttons: [
            { extend: "selectedSingle", text: "Visualizza ricetta", action: viewRecipe }
        ]
    }
};
var tableMapping;

function initApprovals(table) {
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var tableId = e.relatedTarget.dataset["relatedtableid"]; // previous active tab
        $(tableId).html("");
        var mapping = e.target.dataset["tablemapping"]; // previous active tab
        initTabs(eval(mapping));
    })
    delete window.TableSource;
    var tableMapping;
    switch(table) {
        case "daPrendereInCarico":
            tableMapping = tablesMapping.daPrendereInCarico;
            break;
        case "inCarico":
            tableMapping = tablesMapping.inCarico;
            break;
        case "tutte":
            tableMapping = tablesMapping.tutte;
            break;
        default:
            tableMapping = tablesMapping.daPrendereInCarico;
            break;
    }
    initTabs(tableMapping);
}

function initTabs(tableMapping) {
    var loader = new Loader(tableMapping.tableContainer); 
    loader.showLoader();
    var statePermissions = tableMapping.states.filter(x => x.check())[0];
    var args = {
        minState: statePermissions.minState,
        maxState: statePermissions.maxState,
        needsUserValidation: tableMapping.userValidation.needed,
        currentUser: tableMapping.userValidation.currentUser,
        dateValidation: tableMapping.dateValidation
    };
    var approvalFlowApi = new ApprovalFlowApi();
    approvalFlowApi.getAllRecipesWithStateInRange(args)
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
        var orderableDate = new Date(recipe.data_flusso).toDateString();
            html +=     `<tr>
                            <td>${orderableDate}</td>
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
    approvalDTOptions.buttons = this.buttons;
    approvalDT = $(`#${this.tableName}`).DataTable(approvalDTOptions);
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
    window.TableSource = this.toString();
    window.RecipeId = row.id_ricetta;
    window.RecipeApprovaFlowState = row.codice_stato_approvativo;
    window.RecipeAuthor = row.id_utente_creatore;
    window.RecipeApprover = row.id_utente_approvatore;
    pageContentController.setSwitchableSecondaryPage(views.allForms.recipes.viewForm);
    pageContentController.switch();
}

function isRecipeEditable(e, dt, node, config) {
    console.log(dt);
    return false;
}

/* RIBBON BUTTONS ENABLE SCRIPTS */
function enableRecipeTakeCharge() {
    var enabled = false;
    window.ButtonEnablingWarningMessages = [];
    if(shared.loginContext.id_utente == window.RecipeAuthor 
        && window.RecipeApprovaFlowState == Approval.getStates().inviata 
        && !shared.loginContext.isCapoRedattore) {
        window.ButtonEnablingWarningMessages.push("Non è possibile prendere in carico ricette create da se stessi.")
    }
    if(window.RecipeApprovaFlowState == Approval.getStates().inviata) {
        enabled = shared.loginContext.isRedattore && shared.loginContext.id_utente != window.RecipeAuthor;
    } else if(window.RecipeApprovaFlowState == Approval.getStates().idonea) {
        enabled = shared.loginContext.isCapoRedattore;
    }
    return enabled;
}

function enableApprovalButtons() {
    var enabled = false;
    if(window.RecipeApprover == shared.loginContext.id_utente) {
        if(window.RecipeApprovaFlowState == Approval.getStates().in_validazione) {
            enabled = shared.loginContext.isRedattore && shared.loginContext.id_utente != window.RecipeAuthor;
        } else if(window.RecipeApprovaFlowState == Approval.getStates().in_approvazione) {
            enabled = shared.loginContext.isCapoRedattore;
        }
    }
    return enabled;
}

/* INIT */
initApprovals();
