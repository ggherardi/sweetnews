class Controller {
    constructor(containerSelector) {
        this.baseUrl = window.location.host;
        this.containerSelector = containerSelector;
        this.container = $(this.containerSelector);
        this.ajaxOptions = {
            success: this.renderSuccess.bind(this),
            error: this.renderError.bind(this)
        };
    }

    getActiveView() {
        return this.view;
    }

    setView(view) {       
        this.previousView = this.view;
        this.view = view;
        this.correlatedScripUrl = `/${view.path}.js`;
        this.ajaxOptions.url = `/${view.path}.html`;
    }

    setComponent(component) {
        this.componentName = component.name.toLowerCase();
        this.correlatedScripUrl = `/components/${this.componentName}/${this.componentName}.js`;
        this.ajaxOptions.url = `/components/${this.componentName}/${this.componentName}.html`;
    }

    setForm(form) {
        this.form = form;
        this.formName = form.name ? form.name.toLowerCase() : form;
        this.correlatedScripUrl = `/form/${this.formName}/${this.formName}.js`;
        this.ajaxOptions.url = `/form/${this.formName}/${this.formName}.html`;
    }

    loadView(view) {
        this.setView(view);
        return this.set();
    }

    loadComponent(view) {
        this.setComponent(view);
        return this.set();
    }

    set() {
        return $.ajax(this.ajaxOptions);
    }

    renderSuccess(data) {
        this.loadCorrelatedScript();
        this.container.html(data);
        if(this.view && this.view.ribbon) {
            ribbon.buildRibbon(this.view.ribbon);
        }
    }

    renderError(error) {
        console.log(error);
    }

    loadCorrelatedScript() {
        var allScripts
        allScripts = Array.prototype.slice.call(document.scripts)
        var alreadyLoadedScript = allScripts.find((el) => { return el.src == this.correlatedScripUrl});
        if(!alreadyLoadedScript) {
            var script = document.createElement("script");
            script.setAttribute("src", this.correlatedScripUrl);
            document.head.appendChild(script);
        }
    }
}

class PageContentController {
    constructor(primaryContainer, secondaryContainer) {
        this.primaryContainer = primaryContainer;
        this.secondaryContainer = secondaryContainer;
        this.primaryController = new Controller(`#${this.primaryContainer[0].id}`);
        this.secondaryController = new Controller(`#${this.secondaryContainer[0].id}`);
        this.isMainPageActive = 1;
    }

    setSwitchableSecondaryPage(secondaryPageView) {
        this.primaryPageView = mainContentController.getActiveView();
        this.secondaryPageView = secondaryPageView;
        this.secondaryController.loadView(secondaryPageView);
    }

    switch() {
        this.switchBreadcrumb();
        this.isMainPageActive = !this.isMainPageActive;
        this.primaryContainer.toggle();
        this.secondaryContainer.toggle();
    }

    switchBreadcrumb() {
        if(this.isMainPageActive) {
            breadcrumb.rebuildBreadcrumb(this.secondaryPageView);
        } else {
            breadcrumb.rebuildBreadcrumb(this.primaryPageView);
        }
    }
}

class Menu {
    constructor(menuItems) {
        this.navbarId = placeholders.sideMenu;
        this.menuItems = menuItems;
        this.activeClassName = "active";
    }

    static menuClick(menuItem) {
        if(pageContentController && !pageContentController.isMainPageActive) {
            pageContentController.switch();
        } 
        var view = views.allViews[menuItem.dataset["view"]];
        mainContentController.loadView(view);
        menu.setMenuItemActive(view);
        breadcrumb.rebuildBreadcrumb(view);
    }
    
    buildMenu() {
        this.html = "";
        for(var key in this.menuItems) {
            var item = this.menuItems[key];
            var arePermissionsValid = item.needPermissions || item.maxPermissions
                ? shared.loginContext.delega_codice >= (item.needPermissions ? item.needPermissions : 0) && (item.maxPermissions 
                    ? shared.loginContext.delega_codice <= item.maxPermissions 
                    : true)
                : true;
            if(arePermissionsValid && item.showInMenu == undefined || item.showInMenu) {          
                this.html += `<li id='navbar__${item.name}'>
                                </span><a onclick='Menu.menuClick(this);' data-view='${item.name}'>${item.title}</a>
                            </li>`;   
            }                
        }
        this.appendMenu();
    }

    appendMenu() {
        $(this.navbarId).html(this.html);
    }

    setMenuItemActive(view) {
        var findActiveItem = function(el) { return el.className == this.activeClassName };
        var items = $(this.navbarId).children();
        var prevItem = items.toArray().find(findActiveItem.bind(this));    
        var currItem = $(`#navbar__${view.name}`);
        if(prevItem && prevItem.id == currItem[0].id) return;
        if(prevItem){
            $(prevItem).removeClass(this.activeClassName);
            moveMenuItem($(prevItem.firstElementChild));
        }
        if(currItem){
            currItem.addClass(this.activeClassName);
            moveMenuItem(currItem.children().first());
        }
    }
}

class Views {
    constructor() {
        class AllViews {
            constructor() {
                this.home = { title: "Home", name: "home", path: "views/home/home" };
                this.personal = { title: "Pagina personale", name: "personal", path: "views/personal/personal", showInMenu: false, maxPermissions: permissions.levels.visitatore };
                this.login = { title: "Login", name: "login", path: "views/login/login", showInMenu: false };
                this.identities = { title: "Deleghe utente", name: "identities", path: "views/identities/identities", showInMenu: false, parent: this.login, ribbon: [ ribbon.buttons.back ]};
                this.registration = { title: "Registrazione", name: "registration", path: "views/registration/registration", showInMenu: false, parent: this.personal };
                this.approveRecipes = { title: "Approvazione ricette", name: "approveRecipes", path: "views/approveRecipes/approveRecipes", needPermissions: permissions.levels.redattore };
                this.manageRecipes = { title: "Crea/modifica ricette", name: "manageRecipes", path: "views/manageRecipes/manageRecipes", needPermissions: permissions.levels.visitatore, maxPermissions: permissions.levels.visitatore };
                this.allRecipes = { title: "Catalogo ricette", name: "allRecipes", path: "views/allRecipes/allRecipes" };
                this.manageAccounts = { title: "Gestione account", name: "manageAccounts", path: "views/manageAccounts/manageAccounts", needPermissions: permissions.levels.caporedattore };
            }
        };
        this.allViews = new AllViews();

        class AllForms {
            constructor(views) {
                class RecipeForms {
                    constructor(views) {
                        this.newForm = { title: "Nuova ricetta", name: "recipeNewForm", path: "forms/recipe/recipeNewForm/recipeNewForm", parent: views.allViews.manageRecipes, ribbon: [ ribbon.buttons.back, ribbon.buttons.save ] };
                        this.editForm = { title: "Modifica e invia ricetta", name: "recipeNewForm", path: "forms/recipe/recipeEditForm/recipeEditForm", parent: views.allViews.manageRecipes, ribbon: [ ribbon.buttons.back, ribbon.buttons.save, ribbon.buttons.send ] };    
                        this.viewForm = { title: "Visualizza ricetta", name: "recipeViewForm", path: "forms/recipe/recipeViewForm/recipeViewForm", parent: views.allViews.manageRecipes, ribbon: [ ribbon.buttons.back, ribbon.buttons.takeCharge, ribbon.buttons.approve, ribbon.buttons.reject ] };    
                        this.displayForm = { title: "Dettaglio ricetta", name: "recipeDisplayForm", path: "forms/recipe/recipeDisplayForm/recipeDisplayForm", parent: views.allViews.allRecipes };
                    }
                }
                this.recipes = new RecipeForms(views);
                
                class AccountForms {
                    constructor(views) {
                        this.newForm = { title: "Nuovo account", name: "accountNewForm", path: "forms/account/accountNewForm/accountNewForm", parent: views.allViews.manageAccounts, ribbon: [ ribbon.buttons.back, ribbon.buttons.save ] };
                        this.editForm = { title: "Modifica account", name: "accountEditForm", path: "forms/account/accountEditForm/accountEditForm", parent: views.allViews.manageAccounts, ribbon: [ ribbon.buttons.back, ribbon.buttons.save ] };    
                    }
                }
                this.accounts = new AccountForms(views);
            }
        }
        this.allForms = new AllForms(this);

        class AllComponents {
            constructor() {
                this.sidebar = { title: "Sidebar", name: "sidebar", path: "components/sidebar/sidebar" };
                this.logout = { title: "Logout", name: "logout", path: "components/account/logout" };
                this.account = { title: "Account", name: "account", path: "components/account/account" };
                this.author = { title: "Author", name: "author", path: "components/author/author" };
                this.recipesCart = { title: "RecipesCart", name: "recipesCart", path: "components/recipesCart/recipesCart" };
            }
        }
        this.AllComponents = new AllComponents();
    }
}

var views = new Views();