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
            /*
        }
            var resumen = JSON.parse(response);
            $('#programados-hoy').html(resumen.total);
            var ejecutados = resumen.ejecutados;
            $('#ejecutados').html(ejecutados);

            $('#espera').html(resumen.pendiente);
            var porcEjecucion = ((ejecutados * 100) / resumen.total).toFixed(2);
            $('#porcentaje-ejecucion').html(porcEjecucion + "%");
            $('#progress-ejecucion').css({"width": porcEjecucion + "%"});
            $('#progress-ejecucion').attr("aria-valuenow", porcEjecucion);
            $('#exitoso').html(resumen.exitoso);
            $('#error').html(resumen.error);
            $('#norecibidas').html(resumen.noRecibida);
            $('#sinprocesar').html(resumen.sinProcesar);
            $('#parcialmente').html(resumen.parcialmente);
            $('#noheaderfooter').html(resumen.noCumple);
            var tasaError = ((resumen.fallaEnProceso * 100) / ejecutados).toFixed(2);
            if (isNaN(tasaError)) {
                tasaError = 0;
            }
            $('#tasa-error').html(tasaError + "%");
            $('#progress-error').css({"width": tasaError + "%"});
            $('#progress-error').attr("aria-valuenow", tasaError);


            var porcentajeExitoso = (resumen.exitoso * 100) / resumen.total;
            var porcentajeError = (resumen.fallaEnProceso * 100) / resumen.total;
            var porcentajeEspera = (resumen.pendiente * 100) / resumen.total;
            crearGrafico(porcentajeExitoso.toFixed(2), porcentajeEspera.toFixed(2), porcentajeError.toFixed(2));
            */
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
            /*
        }
            var resumen = JSON.parse(response);
            $('#programados-hoy').html(resumen.total);
            var ejecutados = resumen.ejecutados;
            $('#ejecutados').html(ejecutados);

            $('#espera').html(resumen.pendiente);
            var porcEjecucion = ((ejecutados * 100) / resumen.total).toFixed(2);
            $('#porcentaje-ejecucion').html(porcEjecucion + "%");
            $('#progress-ejecucion').css({"width": porcEjecucion + "%"});
            $('#progress-ejecucion').attr("aria-valuenow", porcEjecucion);
            $('#exitoso').html(resumen.exitoso);
            $('#error').html(resumen.error);
            $('#norecibidas').html(resumen.noRecibida);
            $('#sinprocesar').html(resumen.sinProcesar);
            $('#parcialmente').html(resumen.parcialmente);
            $('#noheaderfooter').html(resumen.noCumple);
            var tasaError = ((resumen.fallaEnProceso * 100) / ejecutados).toFixed(2);
            if (isNaN(tasaError)) {
                tasaError = 0;
            }
            $('#tasa-error').html(tasaError + "%");
            $('#progress-error').css({"width": tasaError + "%"});
            $('#progress-error').attr("aria-valuenow", tasaError);


            var porcentajeExitoso = (resumen.exitoso * 100) / resumen.total;
            var porcentajeError = (resumen.fallaEnProceso * 100) / resumen.total;
            var porcentajeEspera = (resumen.pendiente * 100) / resumen.total;
            //crearGrafico(porcentajeExitoso.toFixed(2), porcentajeEspera.toFixed(2), porcentajeError.toFixed(2));
            graficoTorta.data.datasets[0].data = [porcentajeExitoso.toFixed(2), porcentajeEspera.toFixed(2), porcentajeError.toFixed(2)];
            graficoTorta.update();
            */
        },
        error: function (a, b, c) {
            console.log(a);
            console.log(b);
            console.log(c);
        }
    });
}