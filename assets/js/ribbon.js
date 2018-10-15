class Ribbon {
    constructor() {
        this.buttons = {
            back: {
                title: `Indietro`,
                label: `Indietro`,
                action: `back();`,
                icon: `chevron-left`,
                cssClass: `purple`,
                order: 1,
                permissions: permissions.levels.anonimo
            },  
            save: {
                title: `Salva modifiche`,
                label: `Salva`,
                action: `save();`,
                icon: `circle-check`,
                cssClass: `confirmFillColor`,
                order: 2,
                permissions: permissions.levels.visitatore
            },
            send: {
                title: `Invia in approvazione`,
                label: `Invia`,
                action: `send();`,
                icon: `share-boxed`,
                cssClass: `grey`,
                order: 3,
                permissions: permissions.levels.visitatore
            }
        }
    }

    setContainer(containerSelector) {
        this.container = $(containerSelector);
    }

    buildRibbon(ribbon) {
        ribbon = ribbon.sort((a, b) => { return a.order >= b.order ? 1 : -1 });
        this.ribbonHTML = ` <div id="ribbon" class="mt-3">`;
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
        this.ribbonHTML += `</div><div id="warningBanner"></div>`
        this.appendRibbon();
    }

    appendRibbon() {
        var firstChild = this.container.children().first();
        firstChild.prepend(this.ribbonHTML);
    }

    static setMessage(message) {
        var messageId = $(`${placeholders.warningBanner} div`).length + 1;
        var messageSpan = `<div id="warningMessage_${messageId}">${message}</div>`;
        $(placeholders.warningBanner).append(messageSpan);
        $(placeholders.warningBanner).show();
        return messageId;
    }

    static removeMessage(id) {
        $(`${placeholders.warningBanner} #warningMessage_${id}`).remove();
        if(!$(`${placeholders.warningBanner} div`).length) {
            $(placeholders.warningBanner).hide();
        }
    }
}

var ribbon = new Ribbon();