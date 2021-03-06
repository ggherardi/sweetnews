class Ribbon {
    constructor() {
        this.buttons = {
            back: {
                title: `Indietro`,
                label: `Indietro`,
                action: `back();`,
                icon: `fas fa-arrow-left`,
                cssClass: `purple`,
                order: 1,
                permissions: permissions.levels.anonimo
            },  
            save: {
                title: `Salva modifiche`,
                label: `Salva`,
                action: `save();`,
                icon: `far fa-save`,
                cssClass: `saveButton`,
                order: 2,
                permissions: permissions.levels.visitatore
            },
            delete: {
                title: `Cancella ricetta`,
                label: `Elimina`,
                action: `remove();`,
                icon: `fas fa-times`,
                cssClass: `deleteButton`,
                order: 3,
                permissions: permissions.levels.visitatore
            },
            send: {
                title: `Invia in approvazione`,
                label: `Invia`,
                action: `send();`,
                icon: `fas fa-code-branch`,
                cssClass: `startApprovalButton`,
                order: 4,
                permissions: permissions.levels.visitatore
            },
            takeCharge: {
                title: `Prendi in carico la ricetta corrente`,
                label: `Prendi in carico`,
                action: `takeCharge();`,
                enableScript: `enableRecipeTakeCharge`,
                icon: `fas fa-tasks`,
                cssClass: `takeChargeButton`,
                order: 4,
                permissions: permissions.levels.redattore
            },
            approve: {
                title: `Approva ricetta`,
                label: `Approva`,
                action: `approve();`,
                enableScript: `enableApprovalButtons`,
                icon: `fas fa-thumbs-up`,
                cssClass: `approveButton`,
                order: 5,
                permissions: permissions.levels.redattore
            },
            reject: {
                title: `Rifiuta ricetta`,
                label: `Rifiuta`,
                action: `reject();`,
                enableScript: `enableApprovalButtons`,
                icon: `fas fa-thumbs-down`,
                cssClass: `rejectButton`,
                order: 6,
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
            var buttonEnabled = button.enableScript && typeof(window[enableScriptName]) == "function" ? window[enableScriptName]() : true;
            var isLongText = button.label.length > 9;
            if(parseInt(shared.loginContext.delega_codice) >= button.permissions) {
                this.ribbonHTML += `<div class="ribbonButton mr-2 c-pointer ${buttonEnabled ? "" : "ribbonDisabled"}" onclick="${button.action}" title="${button.title}">
                                        <div class="">
                                            <i class="${button.icon} ribbonIcon ${button.cssClass}"></i>
                                        </div>
                                        <div ${isLongText ? `class="twoRowsButton"` : ""}>
                                            <span>${button.label}</span>
                                        </div>
                                    </div>`
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