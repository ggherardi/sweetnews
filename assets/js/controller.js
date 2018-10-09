class Controller {
    constructor(containerSelector) {
        this.baseUrl = window.location.host;
        this.containerSelector = containerSelector;
        this.renderSuccess = function(data) {
            this.loadCorrelatedScript();
            $(this.containerSelector).html(data);
        }
        this.renderError = function(error) {
            console.log(error);
        }
        this.ajaxOptions = {
            success: this.renderSuccess.bind(this),
            error: this.renderError.bind(this)
        };
    }

    setView(view) {
        var viewName = view.name.toLowerCase();
        this.correlatedScripUrl = `/views/${viewName}/${viewName}.js`;
        this.ajaxOptions.url = `/views/${viewName}/${viewName}.html`;
        return this.set();
    }

    setComponent(component) {
        var componentName = component.name.toLowerCase();
        this.correlatedScripUrl = `/components/${componentName}/${componentName}.js`;
        this.ajaxOptions.url = `/components/${componentName}/${componentName}.html`;
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

class Menu {
    constructor(menuItems) {
        this.navbarId = "#navbar";
        this.menuItems = menuItems;
        this.activeClassName = "active";
    }

    static menuClick(menuItem) {
        var view = views[menuItem.dataset["view"]];
        mainContentController.setView(view);
        menu.setMenuItemActive(view);
    }
    
    buildMenu() {
        this.html = "";
        for(var key in this.menuItems) {
            var item = this.menuItems[key];
            var arePermissionsValid = item.needPermissions ? sharedStorage.loginContext.delega_codice >= item.needPermissions : true;
            if(arePermissionsValid && item.showInMenu == undefined || item.showInMenu) {          
                this.html += `<li id='NavItem_${item.name}'>
                                <span onclick='Menu.menuClick(this);' data-view='${item.name}'>${item.title}</span>
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
        if(prevItem){
            $(prevItem).removeClass(this.activeClassName);
        }
        var currItem = $(`#NavItem_${view.name}`);
        if(currItem){
            $(currItem).addClass(this.activeClassName);
        }
    }
}