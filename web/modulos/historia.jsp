<%@include file="../head.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>



<link href="vendor/datatables/dataTables.bootstrap4.min.css?=<% out.print(util.Util.generaRandom(10000, 99999)); %>" rel="stylesheet">

<script type="text/javascript" >
    var TIPOPROCESO = "";
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
        setDefaultDate();
        var tipo = '<%=request.getParameter("tipo")%>';

        //Validar que el request tenga alguno de esos dos valores
        if (tipo === 'rendiciones') {
            TIPOPROCESO = 'rendiciones';
            $('#titulo-historia').html("Histórico de Rendiciones");
        } else if (tipo === 'nominas') {
            TIPOPROCESO = 'nominas';
            $('#titulo-historia').html("Histórico de Nóminas");
        } else if (tipo === 'extract') {
            TIPOPROCESO = 'extract';
            $('#titulo-historia').html("Histórico de Extract");
        } else if (tipo === 'conciliacion') {
            TIPOPROCESO = 'conciliacion';
            $('#titulo-historia').html("Histórico de Conciliación");
        }

    });

    function setDefaultDate() {
        var ahora = new Date();
        var primerdia = new Date(ahora.getFullYear(), ahora.getMonth(), 1);
        var ultimodia = new Date(ahora.getFullYear(), ahora.getMonth() + 1, 0);

        var primero = primerdia.toISOString();
        var ultimo = ultimodia.toISOString();

        $('#fecha-desde').val(primero.substring(0, 10));
        $('#fecha-hasta').val(ultimo.substring(0, 10));

    }

    function validarCampos() {
        var fechaDesde = $('#fecha-desde').val();
        var fechaHasta = $('#fecha-hasta').val();

        if (fechaDesde === null || fechaDesde === undefined || fechaDesde === '' || fechaDesde.length < 10) {
            alert('Debe ingresar una fecha de inicio válida para la búsqueda.');
            $('#fecha-desde').focus();
            return false;
        }

        if (fechaHasta === null || fechaHasta === undefined || fechaHasta === '' || fechaHasta.length < 10) {
            alert('Debe ingresar una fecha de término válida para la búsqueda.');
            $('#fecha-hasta').focus();
            return false;
        }

        var fechaIni = new Date(fechaDesde);
        var fechaFin = new Date(fechaHasta);
        //var diffTime = Math.abs(fechaFin - fechaIni);
        //var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 

        if (fechaIni > fechaFin) {
            alert("La fecha de inicio de la búsqueda no puede ser posterior a la fecha de térimno.");
            return false;
        }

        return true;
    }

    function procesarHistoria() {

        if (!validarCampos()) {
            return false;
        }

        var fechaDesde = new Date($('#fecha-desde').val()).toISOString().substring(0, 10);
        var fechaHasta = new Date($('#fecha-hasta').val()).toISOString().substring(0, 10);

        var datos = {
            tipo: 'historia',
            proceso: TIPOPROCESO,
            fechaDesde: fechaDesde,
            fechaHasta: fechaHasta
        };

        $.ajax({
            url: "HistoriaMapper",
            type: 'POST',
            data: {
                datos: JSON.stringify(datos)
            },
            success: function (response) {
                var obj = JSON.parse(response);
                pintarHistoria(obj, TIPOPROCESO);
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

    function pintarHistoria(listado, tipoProceso) {

        var tabla = TAB;
        var contenedor = '<div class="card shadow mb-6">';
        contenedor += '<div class="card-header py-3">';
        contenedor += '<h6 class="m-0 font-weight-bold text-primary" id="titulo-historia"></h6>';
        contenedor += '</div>';
        contenedor += '<div class="card-body">';
        contenedor += '<div class="table-responsive" id="div-tabla">';

        if (tipoProceso === 'rendiciones') {
            tabla += "<thead><tr>";
            tabla += "<th>ID Proceso</th>";
            tabla += "<th>ID Empresa</th>";
            tabla += "<th>Empresa</th>";
            tabla += "<th>Fecha Proceso</th>";
            tabla += "<th>Fecha Creación</th>";
            tabla += "<th>Inicio Proceso</th>";
            tabla += "<th>Fin Proceso</th>";
            tabla += "<th>Cod Estado</th>";
            tabla += "<th>Estado</th>";
            tabla += "<th>Tipo Estado</th>";
            tabla += "</tr></thead><tbody>";
            contenedor += tabla;
            var optsTabla = OPCIONES_TABLA;
            optsTabla.order = [[3, 'desc']]

            for (var i = 0; i < listado.length; i++) {

                contenedor += "<tr>";
                contenedor += "<td>" + listado[i].idProceso + "</td>";
                contenedor += "<td>" + listado[i].idEmpresa + "</td>";
                contenedor += "<td>" + listado[i].nombreEmpresa + "</td>";
                contenedor += "<td>" + new Date(listado[i].fechaProceso).toISOString().substring(0, 19).replace("T", " ") + "</td>";
                contenedor += "<td>" + new Date(listado[i].fechaCreacion).toISOString().substring(0, 19).replace("T", " ") + "</td>";
                contenedor += "<td>" + new Date(listado[i].inicioProceso).toISOString().substring(0, 19).replace("T", " ") + "</td>";
                contenedor += "<td>" + new Date(listado[i].finProceso).toISOString().substring(0, 19).replace("T", " ") + "</td>";
                contenedor += "<td>" + listado[i].codEstado + "</td>";
                contenedor += "<td>" + listado[i].estado + "</td>";
                contenedor += "<td>" + listado[i].tipoEstado + "</td>";
                contenedor += "</tr>";
            }
        } else if (tipoProceso === 'nominas') {
            tabla += "<thead><tr>";
            tabla += "<th>ID Proceso</th>";
            tabla += "<th>Cod Empresa</th>";
            tabla += "<th>Empresa</th>";
            tabla += "<th>Hora Ini</th>";
            tabla += "<th>Hora Fin</th>";
            tabla += "<th>Fecha Proceso</th>";
            tabla += "<th>Fecha Término</th>";
            tabla += "<th>Duración (mins.)</th>";
            tabla += "<th>ID Estado</th>";
            tabla += "<th>Estado</th>";
            tabla += "</tr></thead><tbody>";
            contenedor += tabla;
            var optsTabla = OPCIONES_TABLA;
            optsTabla.order = [[5, 'desc']]

            for (var i = 0; i < listado.length; i++) {

                contenedor += "<tr>";
                contenedor += "<td>" + listado[i].idProceso + "</td>";
                contenedor += "<td>" + listado[i].codEmpresa + "</td>";
                contenedor += "<td>" + listado[i].nomEmpresa + "</td>";
                contenedor += "<td>" + listado[i].horaIni + "</td>";
                contenedor += "<td>" + listado[i].horaFin + "</td>";
                contenedor += "<td>" + new Date(listado[i].fechaProceso).toISOString().substring(0, 19).replace("T", " ") + "</td>";
                contenedor += "<td>" + new Date(listado[i].fechaTermino).toISOString().substring(0, 19).replace("T", " ") + "</td>";
                contenedor += "<td>" + listado[i].minutos + "</td>";
                contenedor += "<td>" + listado[i].idEstado + "</td>";
                contenedor += "<td>" + listado[i].estado + "</td>";
                contenedor += "</tr>";
            }
        } else if (tipoProceso === 'extract') {

            tabla += "<thead><tr>";
            tabla += "<th>Fecha Proceso</th>";
            tabla += "<th>Hora Inicio<br />Proceso</th>";
            tabla += "<th>Id Estado<br />Inicial</th>";
            tabla += "<th>Descripción<br />Inicial</th>";
            tabla += "<th>Hora Fin</th>";
            tabla += "<th>Id Estado<br />Final</th>";
            tabla += "<th>Descripción<br />Final</th>";
            tabla += "</tr></thead><tbody>";
            contenedor += tabla;
            var optsTabla = OPCIONES_TABLA;
            optsTabla.order = [[0, 'desc']]


            listado.map((proceso) => {
                contenedor += "<tr>";
                contenedor += "<td>" + proceso.fechaProceso + "</td>";
                contenedor += "<td>" + proceso.horaIniProceso + "</td>";
                contenedor += "<td>" + proceso.idEstadoIniProceso + "</td>";
                contenedor += "<td>" + proceso.descEstadoIniProceso + "</td>";
                contenedor += "<td>" + proceso.horaFinProceso + "</td>";
                contenedor += "<td>" + proceso.idEstadoFinProceso + "</td>";
                contenedor += "<td>" + proceso.descEstadoFinProceso + "</td>";
                contenedor += "</tr>";
            });

        } else if (tipoProceso === 'conciliacion') {
            tabla += "<thead><tr>";
            tabla += "<th>Fecha Proceso</th>";
            tabla += "<th>Hora Inicio<br />Proceso</th>";
            tabla += "<th>Id Estado<br />Inicial</th>";
            tabla += "<th>Descripción<br />Inicial</th>";
            tabla += "<th>Hora Fin</th>";
            tabla += "<th>Id Estado<br />Final</th>";
            tabla += "<th>Descripción<br />Final</th>";
            tabla += "</tr></thead><tbody>";
            contenedor += tabla;
            var optsTabla = OPCIONES_TABLA;
            optsTabla.order = [[0, 'desc']]


            listado.map((proceso) => {
                contenedor += "<tr>";
                contenedor += "<td>" + proceso.fechaProceso + "</td>";
                contenedor += "<td>" + proceso.horaIniProceso + "</td>";
                contenedor += "<td>" + proceso.idEstadoIniProceso + "</td>";
                contenedor += "<td>" + proceso.descEstadoIniProceso + "</td>";
                contenedor += "<td>" + proceso.horaFinProceso + "</td>";
                contenedor += "<td>" + proceso.idEstadoFinProceso + "</td>";
                contenedor += "<td>" + proceso.descEstadoFinProceso + "</td>";
                contenedor += "</tr>";
            });
        }


        contenedor += "</tbody></table>";
        contenedor += '</div>';
        contenedor += '</div>';
        contenedor += '</div>';
        $('#detalle-historia').html(contenedor);
        $('#cont-tabla').DataTable(optsTabla);
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
    <!--button type="button" class="btn btn-sm btn-outline-primary" onclick="cargarModulo('dashboard-nominas');">Volver</button>
    <br/>
    <br/-->
    <!--p class="mb-4">DataTables is a third party plugin that is used to generate the demo table below.
        For more information about DataTables, please visit the <a target="_blank"
                                                                   href="https://datatables.net">official DataTables documentation</a>.</p-->

    <!-- DataTable -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h4 class="m-0 font-weight-bold text-primary" id="titulo-historia"></h4>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-sm-2">
                    <div class="form-group"  >
                        <label for="fecha-desde" >Desde</label>
                        <input type="date" class="form-control" id="fecha-desde" />
                    </div>
                </div>
                <div class="col-sm-2">
                    <div class="form-group">
                        <label for="fecha-hasta" >Hasta</label>
                        <input type="date" class="form-control" id="fecha-hasta" />
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <div class="form-group">
                        <button onclick="procesarHistoria();" class="btn btn-primary btn-sm" >Buscar</button> 
                    </div>
                </div>
            </div>



        </div>
    </div>
    <div class="container-fuid" id="detalle-historia" ></div>
    <!--
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary" id="titulo-historia"></h6>
        </div>
        <div class="card-body">
            <div class="table-responsive" id="div-tabla">
                
            </div>
        </div>
    </div>
    -->
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