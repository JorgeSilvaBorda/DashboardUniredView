var graficoTorta;

$(document).ready(function () {
    getResumen();
    $('.nav-item').removeClass("active");
    $('#btn-menu-extract').addClass("active");
    setInterval(function () {
        actualizar();
    }, 60000);

});

function getResumen() {

    var datos = {tipo: "resumen-extract"};

    $.ajax({
        type: 'POST',
        url: 'ExtractMapper',
        data: {
            datos: JSON.stringify(datos)
        },
        success: function (response) {

            var resumen = JSON.parse(response);

            var porcentajeEjecucion = 0.00;
            var porcentajeExitoso = 0.00;
            var porcentajeEspera = 0.00;
            
            var tasaError = 0.00;
            var ejecutados = resumen.exitoso + resumen.error;

            if (resumen.programadosHoy > 0) {
                if (resumen.error > 0) {
                    tasaError = ((resumen.error * 100) / resumen.programadosHoy);
                    if (isNaN(tasaError)) {
                        tasaError = 0.00;
                    }
                }
                porcentajeEjecucion = ((resumen.programadosHoy * 100) / ejecutados);
                if (isNaN(porcentajeEjecucion)) {
                    porcentajeEjecucion = 0.00;
                }
                
                porcentajeExitoso = ((resumen.exitoso * 100) / resumen.programadosHoy);
                if(resumen.pendientes !== 0){
                    porcentajeEspera = ((resumen.pendientes * 100) / resumen.programadosHoy);
                }
                
            }

            $('#pendiente').html(resumen.pendientes);
            $('#ejecucion').html(resumen.enEjecucion);
            $('#exitosa').html(resumen.exitoso);
            $('#error').html(resumen.error);
            
            $('#porcentaje-ejecucion').html(porcentajeEjecucion.toFixed(2) + "%");
            $('#progress-ejecucion').css({"width": porcentajeEjecucion.toFixed(2) + "%"});
            $('#progress-ejecucion').attr("aria-valuenow", porcentajeEjecucion);
            
            crearGrafico(porcentajeExitoso.toFixed(2), porcentajeEspera.toFixed(2), tasaError.toFixed(2));

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
    var datos = {tipo: "resumen-extract"};

    $.ajax({
        type: 'POST',
        url: 'ExtractMapper',
        data: {
            datos: JSON.stringify(datos)
        },
        success: function (response) {

            var resumen = JSON.parse(response);

            var porcentajeEjecucion = 0.00;
            var porcentajeExitoso = 0.00;
            var porcentajeEspera = 0.00;
            
            var tasaError = 0.00;
            var ejecutados = resumen.exitoso + resumen.error;

            if (resumen.programadosHoy > 0) {
                if (resumen.error > 0) {
                    tasaError = ((resumen.error * 100) / resumen.programadosHoy);
                    if (isNaN(tasaError)) {
                        tasaError = 0.00;
                    }
                }
                porcentajeEjecucion = ((resumen.programadosHoy * 100) / ejecutados);
                if (isNaN(porcentajeEjecucion)) {
                    porcentajeEjecucion = 0.00;
                }
                
                porcentajeExitoso = ((resumen.exitoso * 100) / resumen.programadosHoy);
                if(resumen.pendientes !== 0){
                    porcentajeEspera = ((resumen.pendientes * 100) / resumen.programadosHoy);
                }
                
            }

            $('#pendiente').html(resumen.pendientes);
            $('#ejecucion').html(resumen.enEjecucion);
            $('#exitosa').html(resumen.exitoso);
            $('#error').html(resumen.error);
            
            $('#porcentaje-ejecucion').html(porcentajeEjecucion.toFixed(2) + "%");
            $('#progress-ejecucion').css({"width": porcentajeEjecucion.toFixed(2) + "%"});
            $('#progress-ejecucion').attr("aria-valuenow", porcentajeEjecucion);
            
             //crearGrafico(porcentajeExitoso.toFixed(2), porcentajeEspera.toFixed(2), porcentajeError.toFixed(2));
             graficoTorta.data.datasets[0].data = [porcentajeExitoso.toFixed(2), porcentajeEspera.toFixed(2), tasaError.toFixed(2)];
             graficoTorta.update();
             
        },
        error: function (a, b, c) {
            console.log(a);
            console.log(b);
            console.log(c);
        }
    });
}