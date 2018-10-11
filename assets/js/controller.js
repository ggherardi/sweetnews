class Controller {
    constructor(containerSelector) {
        this.baseUrl = window.location.host;
        this.containerSelector = containerSelector;
        this.container = $(this.containerSelector);
        this.renderSuccess = function(data) {
            this.loadCorrelatedScript();
            this.container.html(data);
        }
        this.renderError = function(error) {
            console.log(error);
        }
        this.ajaxOptions = {
            success: this.renderSuccess.bind(this),
            error: this.renderError.bind(this)
        };
    }

    getActiveView() {
        return this.view;
    }

    setView(view) {
        this.view = view;
        this.previousViewName = this.viewName;
        this.viewName = view.name ? view.name.toLowerCase() : view;
        this.correlatedScripUrl = `/views/${this.viewName}/${this.viewName}.js`;
        this.ajaxOptions.url = `/views/${this.viewName}/${this.viewName}.html`;
    }

    setComponent(component) {
        this.componentName = component.name.toLowerCase();
        this.correlatedScripUrl = `/components/${this.componentName}/${this.componentName}.js`;
        this.ajaxOptions.url = `/components/${this.componentName}/${this.componentName}.html`;
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

    loadCorrelatedScript() {
        var allScripts
        allScripts = [].slice.call(document.scripts)
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
    }

    setSwitchableSecondaryPage(secondaryPageView) {
        this.activeBreadcrumb = 1;
        this.primaryPageView = mainContentController.getActiveView();
        this.secondaryPageView = secondaryPageView;
        this.secondaryController.loadView(secondaryPageView);
    }

    switch() {
        this.switchBreadcrumb();
        this.primaryContainer.toggle();
        this.secondaryContainer.toggle();
    }

    switchBreadcrumb() {
        if(this.activeBreadcrumb == 1) {
            this.activeBreadcrumb--;
            breadcrumb.rebuildBreadcrumb(this.secondaryPageView);
        } else {
            this.activeBreadcrumb++;
            breadcrumb.rebuildBreadcrumb(this.primaryPageView);
        }
    }
}

class Menu {
    constructor(menuItems) {
        this.navbarId = placeholders.sidebarZone;
        this.menuItems = menuItems;
        this.activeClassName = "active";
    }

    static menuClick(menuItem) {
        var view = views.allViews[menuItem.dataset["view"]];
        mainContentController.loadView(view);
        menu.setMenuItemActive(view);
        breadcrumb.rebuildBreadcrumb(view);
    }
    
    buildMenu() {
        this.html = "";
        for(var key in this.menuItems) {
            var item = this.menuItems[key];
            var arePermissionsValid = item.needPermissions ? sharedStorage.loginContext.delega_codice >= item.needPermissions : true;
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