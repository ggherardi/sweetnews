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
        { text: "Crea account", action: createAccount },
        { extend: "selectedSingle", text: "Modifica account", action: editAccount }
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

/* BUTTONS */
function createAccount() {
    pageContentController.setSwitchableSecondaryPage(views.allForms.accounts.newForm);
    pageContentController.switch();
}

function editAccount(e, dt, node, config) {
    window.AccountId = dt.rows({ selected: true }).data()[0].id_utente;
    pageContentController.setSwitchableSecondaryPage(views.allForms.accounts.editForm);
    pageContentController.switch();
}

/* INIT */
initAccounts();

