/* RIBBON ACTIONS */
function save() {
    var form = $("#accountEditForm");
    if(form[0].reportValidity()) {
        $("#submitForm").click();
    } 
}

function back() {
    pageContentController.switch();
}

/* FORM POPULATION */
function init() {
    var loader = new Loader("#accountEditForm");
    loader.showLoader();
    var accountsApi = new AccountsApi();
    accountsApi.getUserAccount(window.AccountId)
        .done(initControlsPopulation)
        .fail(RestClient.reportError)
        .always(() => loader.hideLoader());
}

function initControlsPopulation(data) {
    if(data) {
        window.Account = JSON.parse(data);
        populateTextControls();
        createRolesCheckboxes();
    }
}

function populateTextControls() {
    $("#accountEditForm__username").val(Account.username);
    $("#accountEditForm__name").val(Account.nome);
    $("#accountEditForm__surname").val(Account.cognome);
}

function createRolesCheckboxes() {
    var loader = new Loader("#accountEditForm__delega_container");
    loader.showLoader();
    var accountsApi = new AccountsApi();
    accountsApi.getBusinessRoles()
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
        var delegaContainer = $("#accountEditForm__delega");
        for(var i = 0; i < roles.length; i++) {
            let role = roles[i];
            var hasDelega = Account.deleghe.filter((a) => a.delega_codice == role.delega_codice).length;
            html += `<input id="delegaCheckbox_${i}" type="checkbox" name="${role.delega_nome}" 
                        value="${role.id_tipo_delega}" 
                        ${role.delega_codice < 20 ? `disabled class="checkboxDisabled"` : ""}
                        ${hasDelega ? "checked" : ""}>
                        <label class="mt-2" for="delegaCheckbox_${i}">${role.delega_nome}</label><br>`;
        }
        delegaContainer.html(html);
    }
}


/* EVENTS */
function editAccount(sender, e) {
    e.preventDefault();
    var loader = new Loader("#accountEditForm");
    loader.showLoader();
    var accountEditForm = getAccountFromForm();
    var accountsApi = new AccountsApi();
    accountsApi.editBusinessAccount(accountEditForm)
        .done(saveSuccess)
        .fail(RestClient.reportError)
        .always(() => loader.hideLoader());
}

function saveSuccess(data) {
    initAccounts();
}

function getAccountFromForm() {
    var accountEditForm = {
        id_utente: AccountId,
        username: $("#accountEditForm__username").val(),
        nome: $("#accountEditForm__name").val(),
        cognome: $("#accountEditForm__surname").val(),        
        password: $("#accountEditForm__password").val(),
        deleghe: getDelegheFromCheckboxes()
    };
    return accountEditForm;
}

function getDelegheFromCheckboxes() {
    var deleghe = [];
    var checkboxes = $("#accountEditForm__delega").find("input");
    for(var i = 0; i < checkboxes.length; i++) {
        var checkbox = checkboxes[i];
        if(checkbox.checked && !checkbox.disabled) {
            deleghe.push(checkbox.value);
        }        
    }
    return deleghe;
}

/* AUX */
function resetVariables() {
    delete window.AccountId;
    delete window.Account;
}

/* Init */
init();