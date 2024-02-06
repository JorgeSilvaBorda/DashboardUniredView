var graficoTorta;

$(document).ready(function () {
    getResumen();
    $('.nav-item').removeClass("active");
    $('#btn-menu-conciliacion').addClass("active");
    setInterval(function () {
        actualizar();
    }, 60000);

});

function getResumen() {

    var datos = {tipo: "resumen-conciliacion"};

    $.ajax({
        type: 'POST',
        url: 'ConciliacionMapper',
        data: {
            datos: JSON.stringify(datos)
        },
        success: function (response) {

            var resumen = JSON.parse(response);
            $('#programados').html(resumen.programadosHoy);
            $('#pendientes').html(resumen.pendientes);
            $('#ejecucion').html(resumen.enEjecucion);
            $('#ejecutados').html(resumen.ejecutados);
            $('#exitosas').html(resumen.exitoso);
            $('#error').html(resumen.error);

            var porcentajeEjecucion = ((resumen.ejecutados * 100) / resumen.programadosHoy);
            if (isNaN(porcentajeEjecucion) || porcentajeEjecucion === undefined || porcentajeEjecucion === null || porcentajeEjecucion < 0) {
                porcentajeEjecucion = 0.00;
            }
            $('#porcentaje-ejecucion').html(porcentajeEjecucion.toFixed(2) + "%");
            $('#progress-ejecucion').css({"width": porcentajeEjecucion.toFixed(2) + "%"});
            $('#progress-ejecucion').attr("aria-valuenow", porcentajeEjecucion.toFixed(2));
            //porcentajeEjecucion = porcentajeEjecucion.toFixed(2);

            var porcentajeError = ((resumen.error * 100) / resumen.ejecutados);
            if (isNaN(porcentajeError) || porcentajeError === undefined || porcentajeError === null || porcentajeError < 0) {
                porcentajeError = 0.00;
            }
            $('#tasa-error').html(porcentajeError.toFixed(0) + "%");
            $('#progress-error').css({"width": porcentajeError.toFixed(2) + "%"});
            $('#progress-error').attr("aria-valuenow", porcentajeError.toFixed(2));

            var porcentajeExitoso = (resumen.exitoso * 100) / resumen.programadosHoy;
            var porcentajeError = (resumen.error * 100) / resumen.programadosHoy;
            var porcentajeEspera = (resumen.pendientes * 100) / resumen.programadosHoy;
            crearGrafico(porcentajeExitoso.toFixed(2), porcentajeEspera.toFixed(2), porcentajeError.toFixed(2));

        },
        error: function (a, b, c) {
            console.log(a);
            console.log(b);
            console.log(c);
        }
    });
}

function crearGrafico(porcentajeExitoso, porcentajeEspera, porcentajeError) {

    Chart.defaults.global.defaultFontFamily = 'Nunito', '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
    Chart.defaults.global.defaultFontColor = '#858796';


    var ctx = document.getElementById("grafico-torta");

    if (ctx !== null) {
        graficoTorta = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ["Exitosas", "Pendientes", "Errores"],
                datasets: [{
                        data: [porcentajeExitoso, porcentajeEspera, porcentajeError],
                        backgroundColor: ['#1cc88a', '#f6c23e', '#e74a3b'],
                        hoverBackgroundColor: ['#21eba2', '#f5d687', '#ed7a6f'],
                        hoverBorderColor: "rgba(234, 236, 244, 1)",
                    }],
            },
            options: {
                maintainAspectRatio: false,
                tooltips: {
                    backgroundColor: "rgb(255,255,255)",
                    bodyFontColor: "#858796",
                    borderColor: '#dddfeb',
                    borderWidth: 1,
                    titleSpacing: 0,
                    footerSpacing: 6,
                    footerMarginTop: 10,
                    bodySpacing: 10,
                    displayColors: false,
                    callbacks: {
                        title: function (tooltipItem, data) {
                            return data.labels[tooltipItem[0].index];
                        },
                        label: function (tooltipItem, data) {
                            var amount = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                            return amount + '%';
                        },
                    },
                },
                legend: {
                    display: false
                },
                cutoutPercentage: 60,
            },
        });
    }
}

function actualizar() {
    var datos = {tipo: "resumen-conciliacion"};

    $.ajax({
        type: 'POST',
        url: 'ConciliacionMapper',
        data: {
            datos: JSON.stringify(datos)
        },
        success: function (response) {

            var resumen = JSON.parse(response);
            $('#programados').html(resumen.programadosHoy);
            $('#pendientes').html(resumen.pendientes);
            $('#ejecucion').html(resumen.enEjecucion);
            $('#ejecutados').html(resumen.ejecutados);
            $('#exitosas').html(resumen.exitoso);
            $('#error').html(resumen.error);

            var porcentajeEjecucion = ((resumen.ejecutados * 100) / resumen.programadosHoy);
            if (isNaN(porcentajeEjecucion) || porcentajeEjecucion === undefined || porcentajeEjecucion === null || porcentajeEjecucion < 0) {
                porcentajeEjecucion = 0.00;
            }
            $('#porcentaje-ejecucion').html(porcentajeEjecucion.toFixed(2) + "%");
            $('#progress-ejecucion').css({"width": porcentajeEjecucion.toFixed(2) + "%"});
            $('#progress-ejecucion').attr("aria-valuenow", porcentajeEjecucion.toFixed(2));
            //porcentajeEjecucion = porcentajeEjecucion.toFixed(2);

            var porcentajeError = ((resumen.error * 100) / resumen.ejecutados);
            if (isNaN(porcentajeError) || porcentajeError === undefined || porcentajeError === null || porcentajeError < 0) {
                porcentajeError = 0.00;
            }
            $('#tasa-error').html(porcentajeError.toFixed(0) + "%");
            $('#progress-error').css({"width": porcentajeError.toFixed(2) + "%"});
            $('#progress-error').attr("aria-valuenow", porcentajeError.toFixed(2));

            var porcentajeExitoso = (resumen.exitoso * 100) / resumen.programadosHoy;
            var porcentajeError = (resumen.error * 100) / resumen.programadosHoy;
            var porcentajeEspera = (resumen.pendientes * 100) / resumen.programadosHoy;
            
            //crearGrafico(porcentajeExitoso.toFixed(2), porcentajeEspera.toFixed(2), porcentajeError.toFixed(2));
            graficoTorta.data.datasets[0].data = [porcentajeExitoso.toFixed(2), porcentajeEspera.toFixed(2), porcentajeError.toFixed(2)];
            graficoTorta.update();

        },
        error: function (a, b, c) {
            console.log(a);
            console.log(b);
            console.log(c);
        }
    });
}