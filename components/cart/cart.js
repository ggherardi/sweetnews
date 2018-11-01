function initSavedRecipes() {
    getRecipes();        
}

function getRecipes() {
    var recipesCartsApi = new RecipesCartApi();
    recipesCartsApi.getRecipesInCart()
        .done(getRecipesInCartSuccess)
        .fail(RestClient.redirectAccordingToError);
}

function getRecipesInCartSuccess(data) {
    if(data && JSON.parse(data)) {
        window.SavedRecipes = [];
        data = JSON.parse(data);
        for(var i = 0; i < data.length; i++) {
            window.SavedRecipes.push(data[i]);
        }
        buildCartHtml();
    }
}

function buildCartHtml() {
    var html = ``;
    var totalCalories = 0;
    if(window.SavedRecipes.length > 0) {
        for(var i = 0; i < window.SavedRecipes.length; i++) {
            var recipe = window.SavedRecipes[i];
            totalCalories += parseFloat(recipe.calorie_totali);
            if(!i % 2) {
                if(i > 0) {
                    html += `</div>`;
                }
                html += `    <div class="row">`;
            }
            html += `           <div class="col-12 col-sm-6">
                                    <input class="hdRecipeId" type="hidden" value="${recipe.id_ricetta}">
                                    <div class="row">
                                        <div class="col-10">
                                            <span>${recipe.titolo_ricetta}</span><span> (${recipe.calorie_totali} cal)</span>
                                        </div>
                                        <div class="col-2">
                                            <span class="icon fa-times c-pointer" onclick="removeRecipe(this);"></span>
                                        </div>
                                    </div>                                    
                                </div>`;
        }
    }
    else {
        html = `Non hai ancora salvato ricette.`;
    }
    $("#cartTotalCalories").text(new Number(totalCalories).toFixed(2));
    $(".recipesCart").html(html);
}

function removeRecipe(sender) {
    sender = $(sender);
    var id_ricetta = sender.parents(".row").siblings(".hdRecipeId").val();
    var recipesCartsApi = new RecipesCartApi();
    recipesCartsApi.removeRecipeFromCart(id_ricetta)
        .done(removeRecipeSuccess)
        .fail(RestClient.redirectAccordingToError);
}

function removeRecipeSuccess() {
    getRecipes();
}

initSavedRecipes();