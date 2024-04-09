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
                $('#titulo-detalle-conciliacion').html("Detalle conciliación programados");
                procesarProgramadas();
                break;
            case "ejecutadas":
                $('#titulo-detalle-conciliacion').html("Detalle conciliación ejecutados");
                procesarEjecutadas();
                break;
            case "exitosas":
                $('#titulo-detalle-conciliacion').html("Detalle conciliación ejecutadas con éxito");
                procesarExitosas();
                break;
            case "errores":
                $('#titulo-detalle-conciliacion').html("Detalle conciliación con errores");
                procesarErrores();
                break;
            case "pendientes":
                $('#titulo-detalle-conciliacion').html("Detalle conciliación pendientes por ejecutar");
                procesarPendientes(); //Abajo se llama al mismo por ahora, porque no tenemos una marca que nos indique cuándo un proceso se encuentra en ejecución. Se asume que al crearlo ya se encuentra en ese estado.
                break;
            case "ejecucion":
                $('#titulo-detalle-conciliacion').html("Detalle conciliación en ejecución");
                procesarPendientes(); //Mismo proceso que el de arriba.
                break;
        }
    }

    function procesarProgramadas() {

        var datos = {
            tipo: 'conciliacion-programadas-dia'
        };
        $.ajax({
            type: 'POST',
            url: 'ConciliacionMapper',
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);

                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Hora Creación</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                procesos.map((proceso) => {
                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + proceso.idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + proceso.nombreEps + "</td>";
                    tablaProgramadas += "<td>" + proceso.fechaCreacion + "</td>";
                    tablaProgramadas += "<td>" + proceso.horaCreacion + "</td>";
                    tablaProgramadas += "</tr>"
                });

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
            tipo: "conciliacion-ejecutadas-dia"
        };
        $.ajax({
            type: 'POST',
            url: "ConciliacionMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '<th>ID Estado</th>'
                        + '<th>Cod. Estado</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';


                tablaProgramadas += "<tr>"
                tablaProgramadas += "<td>" + procesos.procesoInicio.idEmpresa + "</td>";
                tablaProgramadas += "<td>" + procesos.procesoInicio.nombreEps + "</td>";
                tablaProgramadas += "<td>" + procesos.procesoInicio.fechaCreacion + "</td>";
                tablaProgramadas += "<td>" + procesos.procesoInicio.horaCreacion + "</td>";
                tablaProgramadas += "<td>" + procesos.procesoFin.horaCreacion + "</td>";
                tablaProgramadas += "<td>" + procesos.procesoFin.idTipoLog + "</td>";
                tablaProgramadas += "<td>" + procesos.procesoFin.descripcionLog + "</td>";
                tablaProgramadas += "</tr>"


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
            tipo: "conciliacion-exitosas-dia"
        };
        $.ajax({
            type: 'POST',
            url: "ConciliacionMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                if (procesos.procesoInicio !== undefined) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos.procesoInicio.idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos.procesoInicio.nombreEps + "</td>";
                    tablaProgramadas += "<td>" + procesos.procesoInicio.fechaCreacion + "</td>";
                    tablaProgramadas += "<td>" + procesos.procesoInicio.horaCreacion + "</td>";
                    tablaProgramadas += "<td>" + procesos.procesoFin.horaCreacion + "</td>";

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
            tipo: "conciliacion-errores-dia"
        };
        $.ajax({
            type: 'POST',
            url: "ConciliacionMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
		console.log(procesos);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Fecha Proceso</th>'
                        + '<th>Hora Ini</th>'
                        + '<th>Hora Fin</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                //for (var i = 0; i < procesos.length; i++) {
                if (procesos.procesoInicio !== undefined) {

                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + procesos.procesoInicio.idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + procesos.procesoInicio.nombreEps + "</td>";
                    tablaProgramadas += "<td>" + procesos.procesoInicio.fechaCreacion + "</td>";
                    tablaProgramadas += "<td>" + procesos.procesoInicio.horaCreacion + "</td>";
                    tablaProgramadas += "<td>" + procesos.procesoFin.horaCreacion + "</td>";

                    tablaProgramadas += "</tr>"
                }

                //}
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
            tipo: "conciliacion-pendientes-dia"
        };
        $.ajax({
            type: 'POST',
            url: "ConciliacionMapper",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var procesos = JSON.parse(response);
                var tablaProgramadas = TAB
                        + '<thead>'
                        + '<tr>'
                        + '<th>ID Empresa</th>'
                        + '<th>Empresa</th>'
                        + '<th>Fecha Creación</th>'
                        + '<th>Hora Creación</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>';

                procesos.map((proceso) => {
                    tablaProgramadas += "<tr>"
                    tablaProgramadas += "<td>" + proceso.idEmpresa + "</td>";
                    tablaProgramadas += "<td>" + proceso.nombreEps + "</td>";
                    tablaProgramadas += "<td>" + proceso.fechaCreacion + "</td>";
                    tablaProgramadas += "<td>" + proceso.horaCreacion + "</td>";
                    tablaProgramadas += "</tr>"
                });

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
    <button type="button" class="btn btn-sm btn-outline-primary" onclick="cargarModulo('dashboard-conciliacion');">Volver</button>
    <br/>
    <br/>
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary" id="titulo-detalle-conciliacion"></h6>
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

