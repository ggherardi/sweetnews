/* RIBBON ACTIONS */
function save() {
    var form = $("#accountNewForm");
    if(form[0].reportValidity()) {
        $("#submitForm").click();
    } 
}

function back() {
    pageContentController.switch();
}

/* FORM POPULATION */
function init() {
    createRolesCheckboxes();
}

function createRolesCheckboxes() {
    var loader = new Loader("#accountNewForm__delega_container");
    loader.showLoader();
    var accountsApi = new AccountsApi();
    accountsApi.getBusinessRoles(permissions.levels.redattore)
        .done(getBusinessRolesSuccess)
        .fail(RestClient.reportError)
        .always(() => loader.hideLoader());
}

function getBusinessRolesSuccess(data) {
    if(data) {
        roles = JSON.parse(data);
        var html = `<div class="accountForm__delega_span">
                        <span>Ruoli*</span>
                    </div>`;
        var delegaContainer = $("#accountNewForm__delega");
        for(var i = 0; i < roles.length; i++) {
            let role = roles[i];            
            html += `<input id="delegaCheckbox_${i}" type="checkbox" name="${role.delega_nome}" value="${role.id_tipo_delega}">
                        <label class="mt-2" for="delegaCheckbox_${i}">${role.delega_nome}</label><br>`;
        }
        delegaContainer.html(html);
    }
}

/* EVENTS */
function createAccount(sender, e) {
    e.preventDefault();
    var loader = new Loader("#accountNewForm");
    loader.showLoader();
    var accountNewForm = getAccountFromForm();
    var accountsApi = new AccountsApi();
    accountsApi.createBusinessAccount(accountNewForm)
        .done(saveSuccess)
        .fail(RestClient.reportError)
        .always(() => loader.hideLoader());
}

function saveSuccess(data) {
    window.AccountId = data;
    pageContentController.setSwitchableSecondaryPage(views.allForms.accounts.editForm);
    initAccounts();
}

function getAccountFromForm() {
    var accountNewForm = {
        username : $("#accountNewForm__username").val(),
        nome : $("#accountNewForm__name").val(),
        cognome : $("#accountNewForm__surname").val(),        
        password : $("#accountNewForm__password").val(),
        deleghe : getDelegheFromCheckboxes()
    };
    return accountNewForm;
}

function getDelegheFromCheckboxes() {
    var deleghe = [];
    var checkboxes = $("#accountNewForm__delega").find("input");
    for(var i = 0; i < checkboxes.length; i++) {
        var checkbox = checkboxes[i];
        if(checkbox.checked) {
            deleghe.push(checkbox.value);
        }        
    }
    return deleghe;
}

/* AUX */
function resetVariables() {
    delete window.AccountId;
}

/* Init */
init();