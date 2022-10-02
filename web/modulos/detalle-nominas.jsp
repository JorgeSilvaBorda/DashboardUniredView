<%@include file="../head.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>



<link href="vendor/datatables/dataTables.bootstrap4.min.css?=<% out.print(util.Util.generaRandom(10000, 99999)); %>" rel="stylesheet">

<script type="text/javascript" >
    var TAB = '<table class="table table-bordered table-hover" id="cont-tabla" width="100%" cellspacing="0" style="font-size: 12px;">'
    var TABDETALLE = '<table class="table table-bordered table-hover" id="cont-tabla-detalle" width="100%" cellspacing="0" style="font-size: 12px;">'
    var OPCIONES_TABLA = {
        "language": {
            "lengthMenu": "Mostrando _MENU_ registros por página",
            "zeroRecords": "No se han encontrado registros para la búsqueda",
            "info": "Mostrando página _PAGE_ de _PAGES_",
            "infoEmpty": "No se han encontrado registros para la búsqueda",
            "infoFiltered": "(Filtrado de _MAX_ registros totales)",
            "search": "Buscar:",
            "paginate": {
                "first": "Primero",
                "last": "Último",
                "next": "Siguiente",
                "previous": "Anterior"
            },
            "aria": {
                "sortAscending": ": activar para ordenar asendente por esta columna",
                "sortDescending": ": activar para ordenar descendente por esta columna"
            }
        }
    };
    $(document).ready(function () {
        procesarDetalle();
    });
    function procesarDetalle() {
        var tipo = '<%=request.getParameter("tipo")%>';
        switch (tipo) {
            case "programadas":
                $('#titulo-detalle-nominas').html("Detalle nominas programadas");
                procesarProgramadas();
                break;
            case "ejecutadas":
                $('#titulo-detalle-nominas').html("Detalle nominas ejecutadas");
                procesarEjecutadas();
                break;
            case "exitosas":
                $('#titulo-detalle-nominas').html("Detalle nominas ejecutadas con éxito");
                procesarExitosas();
                break;
            case "errores":
                $('#titulo-detalle-nominas').html("Detalle nominas con errores");
                procesarErrores();
                break;
            case "pendientes":
                $('#titulo-detalle-nominas').html("Detalle nominas pendientes por ejecutar");
                procesarPendientes();
                break;
            case "norecibidas":
                $('#titulo-detalle-nominas').html("Detalle nominas no recibidas");
                procesarNoRecibidas();
                break;
            case "sinprocesar":
                $('#titulo-detalle-nominas').html("Detalle nominas sin procesar");
                procesarSinProcesar();
                break;
            case "parcialmente":
                $('#titulo-detalle-nominas').html("Detalle nominas parcialmente recibidas");
                procesarParcialmenteRecibidas();
                break;
            case "nocumple":
                $('#titulo-detalle-nominas').html("Detalle nominas no cumplen con Header/Footer");
                procesarNoCumple();
                break;
        }
    }

    function procesarProgramadas() {

        var datos = {
            tipo: 'nominas-programadas-dia'
        };
        $.ajax({
            type: 'POST',
            url: 'NominasMapper',
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Cod Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Termino</th>'
                        + '<th>Minutos</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nomEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaIni + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaFin + "</td>";
                    if (procesos[i].estado === null) {
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                    } else {
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaTermino, "-") + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].minutos + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].idEstado + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    }

                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                var optsTabla = OPCIONES_TABLA;
                optsTabla.order = [[1, 'asc']]
                $('#cont-tabla').DataTable(optsTabla);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });

    }

    function procesarEjecutadas() {

        var datos = {
            tipo: "nominas-ejecutadas-dia"
        };
        $.ajax({
            type: 'POST',
            url: "NominasMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Cod Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Termino</th>'
                        + '<th>Minutos</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nomEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaIni + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaFin + "</td>";
                    if (procesos[i].estado === null) {
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                    } else {
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaTermino, "-") + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].minutos + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].idEstado + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    }

                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable(OPCIONES_TABLA);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarExitosas() {

        var datos = {
            tipo: "nominas-exitosas-dia"
        };
        $.ajax({
            type: 'POST',
            url: "NominasMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Cod Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Termino</th>'
                        + '<th>Minutos</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nomEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaIni + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaFin + "</td>";
                    if (procesos[i].estado === null) {
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                    } else {
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaTermino, "-") + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].minutos + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].idEstado + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    }

                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable(OPCIONES_TABLA);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarErrores() {

        var datos = {
            tipo: "nominas-errores-dia"
        };
        $.ajax({
            type: 'POST',
            url: "NominasMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Cod Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Termino</th>'
                        + '<th>Minutos</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nomEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaIni + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaFin + "</td>";
                    if (procesos[i].estado === null) {
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                    } else {
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaTermino, "-") + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].minutos + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].idEstado + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    }

                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable(OPCIONES_TABLA);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarPendientes() {

        var datos = {
            tipo: "nominas-pendientes-dia"
        };
        $.ajax({
            type: 'POST',
            url: "NominasMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Cod Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Termino</th>'
                        + '<th>Minutos</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nomEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaIni + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaFin + "</td>";
                    if (procesos[i].estado === null) {
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                    } else {
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaTermino, "-") + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].minutos + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].idEstado + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    }

                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable(OPCIONES_TABLA);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarNoRecibidas() {

        var datos = {
            tipo: "nominas-no-recibidas-dia"
        };
        $.ajax({
            type: 'POST',
            url: "NominasMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Cod Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Termino</th>'
                        + '<th>Minutos</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nomEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaIni + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaFin + "</td>";
                    if (procesos[i].estado === null) {
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                    } else {
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaTermino, "-") + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].minutos + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].idEstado + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    }

                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable(OPCIONES_TABLA);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarSinProcesar() {

        var datos = {
            tipo: "nominas-sin-procesar-dia"
        };
        $.ajax({
            type: 'POST',
            url: "NominasMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Cod Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Termino</th>'
                        + '<th>Minutos</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nomEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaIni + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaFin + "</td>";
                    if (procesos[i].estado === null) {
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                    } else {
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaTermino, "-") + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].minutos + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].idEstado + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    }

                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable(OPCIONES_TABLA);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarParcialmenteRecibidas() {

        var datos = {
            tipo: "nominas-parcialmente-recibidas-dia"
        };
        $.ajax({
            type: 'POST',
            url: "NominasMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Cod Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Termino</th>'
                        + '<th>Minutos</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nomEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaIni + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaFin + "</td>";
                    if (procesos[i].estado === null) {
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                    } else {
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaTermino, "-") + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].minutos + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].idEstado + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    }

                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable(OPCIONES_TABLA);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarGeneradas() {

        var datos = {
            tipo: "nominas-nocumple-headerfooter"
        };
        $.ajax({
            type: 'POST',
            url: "NominasMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Cod Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Termino</th>'
                        + '<th>Minutos</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nomEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaIni + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaFin + "</td>";
                    if (procesos[i].estado === null) {
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                        tablaProgramadas += "<td></td>";
                    } else {
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                        tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaTermino, "-") + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].minutos + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].idEstado + "</td>";
                        tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    }

                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable(OPCIONES_TABLA);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

</script>

<div class="container-fluid">

    <!-- Page Heading -->
    <button type="button" class="btn btn-sm btn-outline-primary" onclick="cargarModulo('dashboard-nominas');">Volver</button>
    <br/>
    <br/>
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary" id="titulo-detalle-nominas"></h6>
        </div>
        <div class="card-body">
            <div class="table-responsive" id="div-tabla">

            </div>
        </div>
    </div>

</div>

<script src="vendor/datatables/jquery.dataTables.min.js"></script>
<script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

<script src="js/demo/datatables-demo.js"></script>
