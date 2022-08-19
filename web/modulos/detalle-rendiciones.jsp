<%@include file="../head.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>



<link href="vendor/datatables/dataTables.bootstrap4.min.css?=<% out.print(util.Util.generaRandom(10000, 99999)); %>" rel="stylesheet">

<!-- Remover estos javascript -->

<script type="text/javascript" src="modulos/muestras.js?=<% out.print(util.Util.generaRandom(10000, 99999)); %>"></script>

<!-- /Remover -->

<script type="text/javascript" >
    var TAB = '<table class="table table-bordered table-hover" id="cont-tabla" width="100%" cellspacing="0" style="font-size: 12px;">'
    var TABDETALLE = '<table class="table table-bordered table-hover" id="cont-tabla-detalle" width="100%" cellspacing="0" style="font-size: 12px;">'
    $(document).ready(function () {
        procesarDetalle();
    });
    function procesarDetalle() {
        var tipo = '<%=request.getParameter("tipo")%>';
        switch (tipo) {
            case "programadas":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones programadas");
                procesarProgramadas();
                break;
            case "ejecutadas":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones ejecutadas");
                procesarEjecutadas();
                break;
            case "exitosas":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones ejecutadas con éxito");
                procesarExitosas();
                break;
            case "errores":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones con errores");
                procesarErrores();
                break;
            case "pendientes":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones pendientes por ejecutar");
                procesarPendientes();
                break;
            case "vacias":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones vacías");
                procesarVacias();
                break;
            case "enviadasmail":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones enviadas a Mail");
                procesarEnviadasMail();
                break;
            case "ejecucion":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones en Ejecución");
                procesarEnEjecucion();
                break;
            case "generado":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones Generadas");
                procesarGeneradas();
                break;
            case "transmitido":
                $('#titulo-detalle-rendiciones').html("Detalle rendiciones Transmitidas");
                procesarTransmitidas();
                break;
        }
    }

    function procesarProgramadas() {

        var datos = {
            tipo: 'rendiciones-programadas-dia'
        };
        $.ajax({
            type: 'POST',
            url: 'RendicionesMapper',
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Tarea</th>'
                        + '<th>Hora Ejecución</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Nombre Empresa</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idTarea + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].horaEjecucion + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEps + "</td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
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
            tipo: "rendiciones-ejecutadas-dia"
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Proceso</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Cod Estado</th>'
                        + '<th>Estado</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Inicio Proceso</th>'
                        + '<th>Fin Proceso</th>'
                        + '<th>Sub Procesos</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idProceso + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEstado + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaCreacion, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].inicioProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].finProceso, "-") + "</td>";
                    tablaProgramadas += "<td><a href='#' onclick='mostrarSubprocesos(" + procesos[i].idProceso + ")'>Ver</a></td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
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
            tipo: "rendiciones-exitosas-dia"
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Proceso</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Cod Estado</th>'
                        + '<th>Estado</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Inicio Proceso</th>'
                        + '<th>Fin Proceso</th>'
                        + '<th>Sub Procesos</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idProceso + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEstado + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaCreacion, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].inicioProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].finProceso, "-") + "</td>";
                    tablaProgramadas += "<td><a href='#' onclick='mostrarSubprocesos(" + procesos[i].idProceso + ")'>Ver</a></td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
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
            tipo: "rendiciones-errores-dia"
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Proceso</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Cod Estado</th>'
                        + '<th>Estado</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Inicio Proceso</th>'
                        + '<th>Fin Proceso</th>'
                        + '<th>Sub Procesos</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idProceso + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEstado + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaCreacion, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].inicioProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].finProceso, "-") + "</td>";
                    tablaProgramadas += "<td><a href='#' onclick='mostrarSubprocesos(" + procesos[i].idProceso + ")'>Ver</a></td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
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
            tipo: "rendiciones-pendientes-dia"
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Proceso</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Cod Estado</th>'
                        + '<th>Estado</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Inicio Proceso</th>'
                        + '<th>Fin Proceso</th>'
                        + '<th>Sub Procesos</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idProceso + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEstado + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaCreacion, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].inicioProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].finProceso, "-") + "</td>";
                    tablaProgramadas += "<td><a href='#' onclick='mostrarSubprocesos(" + procesos[i].idProceso + ")'>Ver</a></td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarVacias() {

        var datos = {
            tipo: "rendiciones-vacias-dia"
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Proceso</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Cod Estado</th>'
                        + '<th>Estado</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Inicio Proceso</th>'
                        + '<th>Fin Proceso</th>'
                        + '<th>Sub Procesos</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idProceso + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEstado + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaCreacion, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].inicioProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].finProceso, "-") + "</td>";
                    tablaProgramadas += "<td><a href='#' onclick='mostrarSubprocesos(" + procesos[i].idProceso + ")'>Ver</a></td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarEnviadasMail() {

        var datos = {
            tipo: "rendiciones-enviadas-mail-dia"
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Proceso</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Cod Estado</th>'
                        + '<th>Estado</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Inicio Proceso</th>'
                        + '<th>Fin Proceso</th>'
                        + '<th>Sub Procesos</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idProceso + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEstado + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaCreacion, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].inicioProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].finProceso, "-") + "</td>";
                    tablaProgramadas += "<td><a href='#' onclick='mostrarSubprocesos(" + procesos[i].idProceso + ")'>Ver</a></td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function procesarEnEjecucion() {

        var datos = {
            tipo: "rendiciones-en-ejecucion"
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Proceso</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Cod Estado</th>'
                        + '<th>Estado</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Inicio Proceso</th>'
                        + '<th>Fin Proceso</th>'
                        + '<th>Sub Procesos</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idProceso + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEstado + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaCreacion, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].inicioProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].finProceso, "-") + "</td>";
                    tablaProgramadas += "<td><a href='#' onclick='mostrarSubprocesos(" + procesos[i].idProceso + ")'>Ver</a></td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
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
            tipo: "rendiciones-generadas"
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Proceso</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Cod Estado</th>'
                        + '<th>Estado</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Inicio Proceso</th>'
                        + '<th>Fin Proceso</th>'
                        + '<th>Sub Procesos</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idProceso + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEstado + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaCreacion, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].inicioProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].finProceso, "-") + "</td>";
                    tablaProgramadas += "<td><a href='#' onclick='mostrarSubprocesos(" + procesos[i].idProceso + ")'>Ver</a></td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }
    
    function procesarTransmitidas() {

        var datos = {
            tipo: "rendiciones-transmitidas"
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Proceso</th>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Cod Estado</th>'
                        + '<th>Estado</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Inicio Proceso</th>'
                        + '<th>Fin Proceso</th>'
                        + '<th>Sub Procesos</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                for (var i = 0; i < procesos.length; i++) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos[i].idProceso + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].nombreEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].codEstado + "</td>";
                    tablaProgramadas += "<td>" + procesos[i].estado + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].fechaCreacion, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].inicioProceso, "-") + "</td>";
                    tablaProgramadas += "<td>" + dateTimeToLocalDate(procesos[i].finProceso, "-") + "</td>";
                    tablaProgramadas += "<td><a href='#' onclick='mostrarSubprocesos(" + procesos[i].idProceso + ")'>Ver</a></td>";
                    tablaProgramadas += "</tr>"
                }
                tablaProgramadas += "</tbody></table>"
                $('#div-tabla').html(tablaProgramadas);
                $('#cont-tabla').DataTable();
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function mostrarSubprocesos(idProceso) {

        var datos = {
            tipo: "subprocesos-rendicion",
            idProceso: idProceso
        };
        $.ajax({
            type: 'POST',
            url: "RendicionesMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var subProcesos = JSON.parse(response);
                var tabla = TABDETALLE
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Bitácora</th>'
                        + '<th>Descripción</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Hora Creación</th>'
                        + '<th>ID Proceso</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';
                for (var i = 0; i < subProcesos.length; i++) {

                    tabla += "<tr>"
                    tabla += "<td>" + subProcesos[i].idSubProceso + "</td>";
                    tabla += "<td>" + subProcesos[i].descripcion + "</td>";
                    tabla += "<td>" + dateTimeToLocalDate(subProcesos[i].fechaCreacion, "/") + "</td>";
                    tabla += "<td>" + getHoraFromDateTime(subProcesos[i].fechaCreacion) + "</td>";
                    tabla += "<td>" + subProcesos[i].idProceso + "</td>";
                    tabla += "</tr>"


                }
                tabla += "</tbody></table>"
                $('#cuerpo-modal').html(tabla);
                $('#titulo-subprocesos').html("Subprocesos ID " + idProceso);
                $('#cont-tabla-detalle').DataTable();
                $('#modalSubprocesos').modal();
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
    <!--h1 class="h3 mb-2 text-gray-800">Rendiciones <h3><a href="#" onclick="cargarModulo('detalle-rendiciones', null);">Volver</a></h3></h1-->
    <button type="button" class="btn btn-sm btn-outline-primary" onclick="cargarModulo('dashboard-rendiciones');">Volver</button>
    <br/>
    <br/>
    <!--p class="mb-4">DataTables is a third party plugin that is used to generate the demo table below.
        For more information about DataTables, please visit the <a target="_blank"
                                                                   href="https://datatables.net">official DataTables documentation</a>.</p-->

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary" id="titulo-detalle-rendiciones"></h6>
        </div>
        <div class="card-body">
            <div class="table-responsive" id="div-tabla">

            </div>
        </div>
    </div>

</div>

<div class="modal fade" id="modalSubprocesos" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl" modal-dialog-centered role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="titulo-subprocesos"></h5>
                <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body" id="cuerpo-modal">Acá el detalle</div>
            <div class="modal-footer">
                <a class="btn btn-primary" data-dismiss="modal" href="#">Cerrar</a>
            </div>
        </div>
    </div>
</div>

<script src="vendor/datatables/jquery.dataTables.min.js"></script>
<script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

<script src="js/demo/datatables-demo.js"></script>