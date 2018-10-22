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
            },
            takeCharge: {
                title: `Prendi in carico la ricetta corrente`,
                label: `Prendi in carico`,
                action: `takeCharge();`,
                enableScript: `enableRecipeTakeCharge`,
                icon: `share-boxed`,
                cssClass: `grey`,
                order: 4,
                permissions: permissions.levels.redattore
            },
            validate: {
                title: `Approva ricetta`,
                label: `Approva`,
                action: `approve();`,
                enableScript: `enableApprove`,
                icon: `share-boxed`,
                cssClass: `grey`,
                order: 4,
                permissions: permissions.levels.redattore
            },
            reject: {
                title: `Rifiuta ricetta`,
                label: `Rifiuta`,
                action: `validate();`,
                enableScript: `enableReject`,
                icon: `share-boxed`,
                cssClass: `grey`,
                order: 5,
                permissions: permissions.levels.redattore
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
            var enableScriptName = button.enableScript;
            var buttonDisabled = button.enableScript ? window[enableScriptName]() : true;
            if(parseInt(shared.loginContext.delega_codice) >= button.permissions) {
                this.ribbonHTML += `<div class="c-pointer ribbonButton mr-4 ${buttonDisabled ? "ribbonDisabled" : ""}" onclick="${button.action}" title="${button.title}">
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