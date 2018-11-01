class RestClient {
    constructor() {
        this.ajaxOptions = {};
     }

    execute() {
        this.setAjaxOptions();
        return $.ajax(this.ajaxOptions);
    }

    static redirectAccordingToError(jqXHR, textStatus, errorThrown) {
        switch(jqXHR.status) {
            case 401:
                CorrelationID = jqXHR.responseText;
                mainContentController.setView(views.unauthorized);
                modal.openErrorModal();      
                break;
            case 480:
                break;
        }
    }

    static reportError(jqXHR) {
        console.log(jqXHR);
    }

    setAjaxOptions() {
        this.ajaxOptions.url = this.endpoint,
        this.ajaxOptions.data = this.data,
        this.ajaxOptions.type = "POST";
    }
}

class AuthenticationApi extends RestClient {
    constructor() {
        super();
        this.endpoint = "php/AuthenticationApi.php";
    }

    registerUser(registrationForm) {
        registrationForm = JSON.stringify(registrationForm);
        this.data = {
            action: "registerUser",
            registrationForm: registrationForm
        }
        return super.execute();
    }

    asyncCheckUsernameValidity(username) {
        this.data = {
            action: "asyncCheckUsernameValidity",
            username: username
        }
        return super.execute();
    }

    login(credentials) {
        credentials = JSON.stringify(credentials);
        this.data = {
            action: "login",
            credentials: credentials
        }
        return super.execute();
    }

    getDetailsForUser(id_utente, delega_codice) {
        this.data = {
            id_utente: id_utente,
            delega_codice: delega_codice,
            action: "getDetailsForUser"
        }
        return super.execute();
    }

    logout() {
        this.data = {
            action: "logout"
        };
        return super.execute();
    }

    authenticateUser() {
        this.data = {
            action: "authenticateUser"
        }
        return super.execute();
    }
}

class RecipesApi extends RestClient {
    constructor() {
        super();
        this.endpoint = "php/RecipesApi.php";
    }

    getRecipesForUser() {
        this.data = {
            action: "getRecipesForUser"
        }
        return super.execute(); 
    }

    getRecipe(id_ricetta) {
        this.data = {
            action: "getRecipe",
            id_ricetta: id_ricetta
        }
        return super.execute(); 
    }

    getPublicRecipe(id_ricetta) {
        this.data = {
            action: "getPublicRecipe",
            id_ricetta: id_ricetta
        }
        return super.execute(); 
    }

    getRecipesAbstractsWithFilters(clientFilters) {
        clientFilters = JSON.stringify(clientFilters);
        this.data = {
            action: "getRecipesAbstractsWithFilters",
            clientFilters: clientFilters
        }
        return super.execute(); 
    }

    getRecipeTopologies() {
        this.data = {
            action: "getRecipeTopologies"
        }
        return super.execute();
    }

    getIngredients() {
        this.data = {
            action: "getIngredients"
        }
        return super.execute();
    }

    getMaxCalories() {
        this.data = {
            action: "getMaxCalories"
        }
        return super.execute();
    }

    getMaxCookingTime() {
        this.data = {
            action: "getMaxCookingTime"
        }
        return super.execute();
    }
    
    
    insertRecipe(recipeForm) {
        recipeForm = JSON.stringify(recipeForm);
        this.data = {
            action: "insertRecipe",
            recipeForm: recipeForm
        }
        return super.execute();
    }

    editRecipe(recipeForm) {
        recipeForm = JSON.stringify(recipeForm);
        this.data = {
            action: "editRecipe",
            recipeForm: recipeForm
        }
        return super.execute();
    }
}

class ApprovalFlowApi extends RestClient {
    constructor() {
        super();
        this.endpoint = "php/ApprovalFlowApi.php";
    }

    startApprovalFlow(id_ricetta) {
        this.data = {
            action: "startApprovalFlow",
            id_ricetta: id_ricetta
        }
        return super.execute(); 
    }

    startApprovalValidation(parameters) {
        parameters = JSON.stringify(parameters);
        this.data = {
            action: "startApprovalValidation",
            parameters: parameters
        }
        return super.execute(); 
    }
    
    approveRejectRecipe(parameters) {
        parameters = JSON.stringify(parameters);
        this.data = {
            action: "approveRejectRecipe",
            parameters: parameters
        }
        return super.execute(); 
    }

    getAllRecipesWithStateInRange(args) {
        if(!args.minState) {
            return this.getRejectedRecipes();
        }
        args = JSON.stringify(args);
        this.data = {
            action: "getAllRecipesWithStateInRange",
            args: args
        }
        return super.execute(); 
    }   

    getRejectedRecipes() {
        this.data = {
            action: "getRejectedRecipes"
        }
        return super.execute(); 
    }   

    getAllApprovaFlowSteps() {
        this.data = {
            action: "getAllApprovaFlowSteps"
        }
        return super.execute(); 
    }    
}

class AccountsApi extends RestClient {
    constructor() {
        super();
        this.endpoint = "php/AccountsApi.php";
    }

    getUsersAccounts() {
        this.data = {
            action: "getUsersAccounts"
        }
        return super.execute(); 
    }  
    
    getUserAccount(id_utente) {
        this.data = {
            action: "getUserAccount",
            id_utente: id_utente
        }
        return super.execute(); 
    }    

    getBusinessRoles(delega_minima) {
        this.data = {
            action: "getBusinessRoles",
            delega_minima: delega_minima
        }
        return super.execute(); 
    }    

    getRecipeAuthorDetails(id_utente) {
        this.data = {
            action: "getRecipeAuthorDetails",
            id_utente: id_utente
        }
        return super.execute(); 
    }    


    createBusinessAccount(accountNewForm) {
        accountNewForm = JSON.stringify(accountNewForm);
        this.data = {
            action: "createBusinessAccount",
            accountNewForm: accountNewForm
        }
        return super.execute(); 
    }   

    editBusinessAccount(accountEditForm) {
        accountEditForm = JSON.stringify(accountEditForm);
        this.data = {
            action: "editBusinessAccount",
            accountEditForm: accountEditForm
        }
        return super.execute(); 
    }     
}

class RecipesCartApi extends RestClient {
    constructor() {
        super();
        this.endpoint = "php/RecipesCartApi.php";
    }

    getRecipesInCart() {
        this.data = {
            action: "getRecipesInCart"
        }
        return super.execute(); 
    }    
}