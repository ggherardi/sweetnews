var dtOptions = {
    dom: 'Bftpil',
    buttons: true,
    select: true,
    columns: [
        { data: "id_ricetta" },
        { data: "nome_stato_approvativo" },
        {
            class: "more-details",
            orderable: false,
            data: null,
            defaultContent: ""
        },
        { data: "tipologia" },
        { data: "difficolta" },
        { data: "tempo_cottura" },
        { data: "preparazione" },
        { data: "porzioni" },
        { data: "note" }
    ],
    columnDefs: [{
        targets: [ 0, 1 ],
        visible: false,
        searchable: false
    }],
    buttons: [
        // { extend: 'selected', text: "Noleggia film", action: rentVideoAction }
    ]
};
var dataTable = {};
var container = $("#manRecipesContainer");

function init() {
    dataTable = container.DataTable();
}

init();

