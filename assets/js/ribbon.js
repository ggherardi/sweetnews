class Ribbon {
    constructor() {
        this.buttons = {
            back: {
                title: `Indietro`,
                label: `Indietro`,
                action: `pageContentController.switch();`,
                icon: `chevron-left`,
                cssClass: `purple`,
                order: 1,
                permissions: permissions.levels.anonimo
            },  
            save: {
                title: `Salva modifiche`,
                label: `Salva`,
                action: `pageContentController.switch();`,
                icon: `circle-check`,
                cssClass: `confirmFillColor`,
                order: 2,
                permissions: permissions.levels.anonimo
            }
        }
    }

    setContainer(containerSelector) {
        this.container = $(containerSelector);
    }

    buildRibbon(ribbon) {
        ribbon = ribbon.sort((a, b) => { return a.order >= b.order ? 1 : -1 });
        this.ribbonHTML = `<div id="ribbon" class="mt-3">`;
        for(var i = 0; i < ribbon.length; i++) {
            var button = ribbon[i];
            if(parseInt(shared.loginContext.delega_codice) >= button.permissions) {
                this.ribbonHTML += `<div class="c-pointer ribbonButton mr-4" style="display: inline-block" onclick="${button.action}" title="${button.title}">
                                        <svg class="baseIcon ${button.cssClass}">
                                            <use xlink:href="/assets/svg/sprite.svg#${button.icon}"></use>
                                        </svg>
                                        <span>${button.label}</span>
                                    </div>`;
            }            
        }
        this.ribbonHTML += `</div>`
        this.appendRibbon();
    }

    appendRibbon() {
        var firstChild = this.container.children().first();
        firstChild.prepend(this.ribbonHTML);
    }
}

var ribbon = new Ribbon();