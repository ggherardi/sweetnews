class ApprovalFlowSteps {
    constructor(recipeState, allStates) {
        this.recipeState = recipeState;
        this.allStates = allStates;
        this.allSteps = [];
        this.buildSteps(recipeState);
        this.buildHtml()
    }

    buildSteps(step) {
        this.allSteps.push(step);
        var nextStep = this.allStates.filter((s) => s.id_stato_approvativo == step.id_stato_approvativo_precedente)[0];
        if(!nextStep.id_stato_approvativo_precedente) {
            return;
        }
        this.buildSteps(nextStep);
    }

    buildHtml() {        
        this.html = `<div class="crumbs">
                        <ul>`;
        var tempAllSteps = this.allSteps.sort(this.sortByCodiceStatoApprovativo)
        for(var i = 0; i < tempAllSteps.length; i++) {
            console.log(`i: ${i}, step: ${tempAllSteps[i].nome_stato_approvativo}`);
            this.html += `  <li class="${tempAllSteps[i].codice_stato_approvativo == this.recipeState.codice_stato_approvativo ? "activeState" : "pastStep"}"> 
                                <a>${tempAllSteps[i].nome_stato_approvativo}</a>
                            </li>`;
        }
        if(!this.recipeState.stato_approvativo_isLeaf) {
            var remainingSteps = this.allStates
                .filter((s) => s.codice_stato_approvativo > this.recipeState.codice_stato_approvativo && !s.stato_approvativo_isLeaf)
                .sort(this.sortByCodiceStatoApprovativo);
            for(var i = 0; i < remainingSteps.length; i++) {
                this.html += `  <li class="futureStep">
                                    <a>${remainingSteps[i].nome_stato_approvativo}</a>
                                </li>`;
            }
        }   
        this.html += `  </ul>
                    </div>`;
    }

    sortByCodiceStatoApprovativo(a, b) {
        return a.codice_stato_approvativo > b.codice_stato_approvativo ? 1 : -1;
    }

    getHtml() {
        return this.html;
    }
}