window.RecipeId = 0;
var usersDTOptions = {
    dom: 'Bftpil',
    buttons: true,
    select: true,
    columns: [
        { data: "id_utente" },
        { data: "username" },
        { data: "nome" },
        { data: "cognome" },
        { data: "deleghe" },
    ],
    columnDefs: [{
        targets: [ ],
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
var usersDT = {};
var usersContainerSelector = "#usersContainer";
var usersContainer = $(usersContainerSelector);

function initAccounts() {
    var accountsApi = new AccountsApi();
    var loader = new Loader(usersContainerSelector); 
    loader.showLoader();
    accountsApi.getUsersAccounts()
        .done(getUsersAccountsSuccess)
        .fail();
}

function getUsersAccountsSuccess(data) {
    var accounts = JSON.parse(data);
    var tableName = "UsersTable";
    var html = `<table class="table mt-3" id="${tableName}">`
    html +=         BuidUserRecipesTableHead();
    html +=        `<tbody>`;            
    for(var i = 0; i < accounts.length; i++) {
        var account = accounts[i].account[0];
        var deleghe = accounts[i].deleghe
        var identitiesCell = formatIdentitiesCell(deleghe);
            html +=     `<tr>
                            <td>${account.id_utente}</td>
                            <td>${account.username}</td>
                            <td>${account.nome}</td>  
                            <td>${account.cognome}</td>                           
                            <td>${identitiesCell}</td>
                        </tr>`;
    }	
    html += `       </tbody>
                </table>`;
    usersContainer.html(html);
    usersDT = $(`#${tableName}`).DataTable(usersDTOptions);
    // enableEditButtonLogic();
}

function BuidUserRecipesTableHead() {
    var html = `<thead>
                    <tr>`;
    for(var i = 0; i < usersDTOptions.columnDefs[0].targets.length; i++) {
        html += `       <th scope="col"></th>`;
    }
    html += `           <th scope="col">Id</th>
                        <th scope="col">Username</th>
                        <th scope="col">Nome</th>
                        <th scope="col">Cognome</th>
                        <th scope="col">Deleghe</th>
                    </tr>
                </thead>`;
    return html;
}

function formatIdentitiesCell(deleghe) {
    var html = ``;
    for(var i = 0; i < deleghe.length; i++) {
        var delega = deleghe[i];
        html += `${delega.delega_nome}`;
        if(i < deleghe.length - 1) {
            html += `, `;
        }
    }
    html.trim()
    return html;
}

// function enableEditButtonLogic() {
//     usersDT.on("select deselect", (e, dt, node, config) => {
//         canEnableButton = dt.rows({selected: true}).data().length == 1 && dt.rows({selected: true}).data()[0].codice_stato_approvativo == Approval.getStates().bozza;
//         dt.buttons([".recipeEditButton"]).enable(canEnableButton);
//     });
// }

/* BUTTONS */
function createRecipe() {
    pageContentController.setSwitchableSecondaryPage(views.allForms.accounts.newForm);
    pageContentController.switch();
}

function editRecipe(e, dt, node, config) {
    window.RecipeId = dt.rows({ selected: true }).data()[0].id_ricetta;
    pageContentController.setSwitchableSecondaryPage(views.allForms.accounts.editForm);
    pageContentController.switch();
}

function viewRecipe(e, dt, node, config) {
    var row = dt.rows({ selected: true }).data()[0];
    window.RecipeId = row.id_ricetta;
    window.RecipeApprovaFlowState = row.codice_stato_approvativo;
    pageContentController.setSwitchableSecondaryPage(views.allForms.accounts.viewForm);
    pageContentController.switch();
}

function isRecipeEditable(e, dt, node, config) {
    console.log(dt);
    return false;
}

/* INIT */
initAccounts();

