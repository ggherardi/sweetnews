/* Properties */
var authenticationApi = new AuthenticationApi();
var menu = new Menu(views.allViews);
var mainContentController = new Controller(placeholders.mainContentZone);
var secondaryContentController = new Controller(placeholders.secondaryContentZone);
var pageContentController = new PageContentController(mainContentController.container, secondaryContentController.container);
var sidebarController = new Controller(placeholders.sideMenu);
var logoutController = new Controller(placeholders.logoutContainer);
var accountController = new Controller(placeholders.accountContainer);
var flowController = new Controller("#flowSteps");
var menuLoader = new Loader(placeholders.sideMenu)
var mainContentLoader = new Loader(placeholders.mainContentZone)
var breadcrumb = new Breadcrumb(placeholders.breadcrumbContainer, views.allViews.home);

/* Global */
var Global_AllApprovalSteps;
var CorrelationID;
var Browser;

/* Document ready */
$().ready(function() {
    ribbon.setContainer(secondaryContentController.container);
    shared.loginContext.delega_codice = 0;
    mainContentLoader.showLoader();
    initializeCrossBrowserSettings();
    initializeResponsivenessSettings();
    authenticationApi.authenticateUser()
        .done((data) => {
            var data = JSON.parse(data);
            if(data) {
                initHomepage(data);
            } else {
                initHomepageAnonymous();
            }
        })
        .fail(RestClient.redirectAccordingToError);
    mainContentLoader.hideLoader();
})

/* Init functions */
function initHomepage(loginContext) {
    initUser(loginContext);
    initTopologies();
    initMasterpageComponents();
}

function initHomepageAnonymous() {
    initUser(loginContext = { delega_codice: 0 });
    initMasterpageComponents();
}

function initUser(loginContext) {
    if(shared.loginContext.delega_codice == 0) {
        shared.loginContext = loginContext;
        shared.loginContext.isAdmin = shared.loginContext.delega_codice >= 30;
    }
}

function initTopologies() {
    var approvalFlowApi = new ApprovalFlowApi();
    approvalFlowApi.getAllApprovaFlowSteps()
        .done((data) => {
            if(data) {
                data = JSON.parse(data);
                Global_AllApprovalSteps = data;
            }
        })
        .fail(RestClient.reportError);
}

function initMasterpageComponents() {
    menu.buildMenu();
    accountController.loadComponent(views.AllComponents.account);
    initHome();
    if(shared.loginContext.delega_codice > 0) {
        logoutController.loadComponent(views.AllComponents.logout);
    }
}

function initHome() {
    mainContentController.loadView(views.allViews.home);
    menu.setMenuItemActive(views.allViews.home);
}

function initLogin() {
    mainContentController.loadView(views.allViews.login);
}

/* Shared functions */
function validateForm(formId) {
    return $(formId)[0].checkValidity();
}

function restCallError(jqXHR, textStatus, errorThrown) {
    console.log(jqXHR.status);
}

function formatDateFromString(dateString) {
    var date = new Date(dateString);
    var day = date.getDate();
    var month = date.getMonth() + 1;
    var year = date.getFullYear();
    return `${day < 10 ? `0${day}` : day}-${month < 10 ? `0${month}` : month}-${year}`;
}

function formatDateGenericToday() {
    var today = new Date();
    var day = today.getDate();
    var month = today.getMonth() + 1;
    var year = today.getFullYear();
    return `${year}-${month < 10 ? `0${month}` : month}-${day < 10 ? `0${day}` : day}`;
}

function switchDateDigitsPosition(dateString) {
    dateString = dateString.replace(/\//g, "-");
    var arr = dateString.split("-");
    var newDateString = `${arr[2]}-${arr[1]}-${arr[0]}`;
    return newDateString;
}

function base64ToArrayBuffer(base64) {
    var binaryString = window.atob(base64);
    var binaryLen = binaryString.length;
    var bytes = new Uint8Array(binaryLen);
    for (var i = 0; i < binaryLen; i++) {
       var ascii = binaryString.charCodeAt(i);
       bytes[i] = ascii;
    }
    return bytes;
 }

 function saveByteArray(reportName, byte) {
    var blob = new Blob([byte], {type: "application/pdf"});
    var link = document.createElement('a');
    link.href = window.URL.createObjectURL(blob);
    var fileName = reportName;
    link.download = fileName;
    return link;
};

/* Reponsiveness */
function initializeResponsivenessSettings() {
    window.addEventListener("resize", setLogo);
    setLogo();
}

function setLogo() {
    if(window.innerWidth >= 700) {
        $("#mainLogo").attr("src", "/images/sweetnewslogo.png");
    } else {
        $("#mainLogo").attr("src", "/images/sweetnewslogo-onlyimage.png");
    }
}

/* Cross Browser Settings */
function initializeCrossBrowserSettings() {
    detectBrowser();
    setStylesCrossBrowser();
}

function detectBrowser() {
    isIE = /*@cc_on!@*/false || !!document.documentMode;
    isEdge = !isIE && !!window.StyleMedia;
    if(navigator.userAgent.indexOf("Chrome") != -1 && !isEdge)
    {
        Browser = 'chrome';
    }
    else if(navigator.userAgent.indexOf("Safari") != -1 && !isEdge)
    {
        Browser = 'safari';
    }
    else if(navigator.userAgent.indexOf("Firefox") != -1 ) 
    {
        Browser = 'firefox';
    }
    else if((navigator.userAgent.indexOf("MSIE") != -1 ) || (!!document.documentMode == true )) //IF IE > 10
    {
        Browser = 'ie';
    }
    else if(isEdge)
    {
        Browser = 'edge';
    }
    else 
    {
        Browser = 'other-browser';
    }
}

function setStylesCrossBrowser() {
    if(Browser == "edge") {
        $(`body`).css(`font-family`, `Arial, Helvetica, sans-serif!important;`);
    }
}

/* Animations */
function moveMenuItem(jqItem) {
    var container = jqItem.parent().first();
    var containerWidth = container.width();
    var itemWidth = jqItem.width();
    var remainingWidth = parseFloat(new Number(containerWidth - itemWidth).toFixed(2));
    var leftPosition = parseInt(jqItem.css("left"));
    jqItem.animate({left: leftPosition == 0 ? remainingWidth : 0});
}