loginController = new Controller("#login");

function switchToLogin() {
    pageContentController.switch();
}

function buildIdentitiesList() {
    var html = "<div>test</div>";
    shared.buildRepeaterHtml(html, shared.userIdentities, "#identitiesForm");
}

buildIdentitiesList();