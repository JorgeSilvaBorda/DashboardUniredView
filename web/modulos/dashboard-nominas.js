var graficoTorta;

$(document).ready(function () {
    getResumen();
    $('.nav-item').removeClass("active");
    $('#btn-menu-nominas').addClass("active");
    setInterval(function () {
        actualizar();
    }, 60000);

});