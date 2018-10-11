class Breadcrumb {
    constructor(breadcrumbContainerSelector, rootNode) { 
        this.breadcrumbContainer = $(breadcrumbContainerSelector);
        this.breadCrumbArray = [
            rootNode
        ];
        this.build();
    }

    rebuildBreadcrumb(node) {
        this.breadCrumbArray = [];
        this.getNodes(node);
        this.breadCrumbArray.reverse();
        this.build();
    }

    getNodes(node) {
        this.breadCrumbArray.push(node);
        if(node.parent) {
            this.getNodes(node.parent);
        }
    }

    build() {
        var bcHtml = "";
        for(var i = 0; i < this.breadCrumbArray.length; i++) {
            var breadcrumbNode = this.breadCrumbArray[i];
            bcHtml += `<span>${breadcrumbNode.title}</span>`;
            if(i + 1 < this.breadCrumbArray.length) {
                bcHtml += ` > `;
            }
        }
        this.breadcrumbContainer.html(bcHtml);
    }
}