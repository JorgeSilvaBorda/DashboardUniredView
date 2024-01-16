<%@include file="../head.jsp" %>
<script src="js/demo/chart-pie-demo.js?=<% out.print(util.Util.generaRandom(10000, 99999)); %>"></script>
<script type="text/javascript" src="modulos/dashboard-extract.js?=<% out.print(util.Util.generaRandom(10000, 99999)); %>" ></script>
<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Extract</h1>
        <!--a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i
                class="fas fa-download fa-sm text-white-50"></i> Generate Report</a-->
    </div>

    <!-- Content Row -->

    <!-- Fila Porcentajes -->
    <div class="row">
        <div class="col-xl-6 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Porcentaje ejecución
                            </div>
                            <div class="row no-gutters align-items-center">
                                <div class="col-auto">
                                    <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800" id="porcentaje-ejecucion"></div>
                                </div>
                                <div class="col">
                                    <div class="progress progress-sm mr-2">
                                        <div class="progress-bar bg-info" id="progress-ejecucion" role="progressbar"
                                             style="width: 0%" aria-valuenow="0" aria-valuemin="0"
                                             aria-valuemax="100"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-percentage fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!--div class="col-xl-6 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Tasa de error
                            </div>
                            <div class="row no-gutters align-items-center">
                                <div class="col-auto">
                                    <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800" id="tasa-error"></div>
                                </div>
                                <div class="col">
                                    <div class="progress progress-sm mr-2">
                                        <div class="progress-bar bg-warning" id="progress-error" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-question-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div-->
    </div>
    <!-- /Fila Porcentajes -->


    <!-- Primera Fila de tarjetas -->
    <div class="row">

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body cursor-pointer" onclick="getDetalleExtract('pendientes')">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Pendiente</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="pendiente"></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-pause fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>




        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body cursor-pointer" onclick="getDetalleExtract('ejecucion')">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                En Ejecución</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="ejecucion"></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-tachometer-alt fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body cursor-pointer" onclick="getDetalleExtract('exitosas')">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Ejecución Exitosa</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="exitosa"></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-star fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-danger shadow h-100 py-2">
                <div class="card-body cursor-pointer" onclick="getDetalleExtract('errores')">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
                                Ejecuciones con Error</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="error"></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>



    </div>
    <!-- /Primera Fila de tarjetas -->

    <!-- Segunda Fila de tarjetas -->
    <!--div class="row">

        

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-danger shadow h-100 py-2">
                <div class="card-body cursor-pointer" onclick="getDetalleNominas('errores')">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
                                Ejecuciones con error</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="error"></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-secondary shadow h-100 py-2">
                <div class="card-body cursor-pointer" onclick="getDetalleNominas('norecibidas')">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-secondary text-uppercase mb-1">
                                No Recibidas</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="norecibidas"></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-expand fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-secondary shadow h-100 py-2">
                <div class="card-body cursor-pointer" onclick="getDetalleNominas('sinprocesar')">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-secondary text-uppercase mb-1">
                                Sin Procesar</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="sinprocesar"></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-envelope-square fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-secondary shadow h-100 py-2">
                <div class="card-body cursor-pointer" onclick="getDetalleNominas('parcialmente')">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-secondary text-uppercase mb-1">
                                Recibidas Parcialmente</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="parcialmente"></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-adjust fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>



    </div-->
    <!-- /Segunda Fila de tarjetas -->

    <!-- Tercera Fila de tarjetas -->
    <!--div class="row">

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-secondary shadow h-100 py-2">
                <div class="card-body cursor-pointer" onclick="getDetalleNominas('noheaderfooter')">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-secondary text-uppercase mb-1">
                                No cumple Header/Footer</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="noheaderfooter"></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-file-code fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div -->
    <!-- /Tercera Fila de tarjetas -->



    <!-- Content Row -->


    <div class="row">
        <!-- Gráfico de torta -->
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div
                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Resumen ejecuciones (%)</h6>
                </div>
                <div class="card-body">
                    <div class="chart-pie pt-4 pb-2">
                        <canvas id="grafico-torta"></canvas>
                    </div>
                    <div class="mt-4 text-center small">
                        <span class="mr-2">
                            <i class="fas fa-circle text-success"></i> Exitosas
                        </span>
                        <span class="mr-2">
                            <i class="fas fa-circle text-warning"></i> Pendientes
                        </span>
                        <span class="mr-2">
                            <i class="fas fa-circle text-danger"></i> Errores
                        </span>
                    </div>
                </div>
            </div>
        </div>                        
    </div>
</div>
<!-- /.container-fluid -->