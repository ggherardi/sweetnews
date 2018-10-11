/* Properties */
var authenticationService = new AuthenticationService();
var menu = new Menu(views.allViews);
var mainContentController = new Controller(placeholders.mainContentZone);
var secondaryContentController = new Controller(placeholders.secondaryContentZone);
var pageContentController = new PageContentController(mainContentController.container, secondaryContentController.container);
var sidebarController = new Controller(placeholders.sidebarZone);
var menuLoader = new Loader(placeholders.sidebarZone)
var mainContentLoader = new Loader(placeholders.mainContentZone)
var breadcrumb = new Breadcrumb(placeholders.breadcrumbContainer, views.allViews.home);
var CorrelationID;
var Global_FilmPrices;
var Browser;

/* Document ready */
$().ready(function() {
    mainContentLoader.showLoader();
    initializeCrossBrowserSettings();
    authenticationService.authenticateUser()
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
    initMasterpageComponents();
}

function initHomepageAnonymous() {
    initUser(loginContext = { delega_codice: 0 });
    initMasterpageComponents();
}

function initUser(loginContext) {
    if(!sharedStorage.loginContext) {
        sharedStorage.loginContext = loginContext;
        sharedStorage.loginContext.isAdmin = sharedStorage.loginContext.delega_codice >= 30;
    }
}

function initMasterpageComponents() {
    sidebarController.loadComponent(views.components.sidebar)
        .then(() => { menu.buildMenu() })
        .done(initHome)
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