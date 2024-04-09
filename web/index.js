var TAB = '<table class="table table-bordered table-hover" id="cont-tabla" width="100%" cellspacing="0" style="font-size: 12px;">'

$(document).ready(function () {
    $('#contenido').load("modulos/dashboard-nominas.jsp");
    getNotificacionesProceso();
    //Hace polling cada un minuto para ver si hay nuevas alertas
    setInterval(function () {
	getNotificacionesProceso();
    }, 1000);

});

function cargarModulo(nombre, params) {
    $('#contenido').load("modulos/" + nombre + ".jsp" + (params !== '' && params !== null ? '?' + params : ''));
}

function logout() {

    var datos = {
	tipo: "logout"
    };
    $.ajax({
	url: "Login",
	type: "POST",
	data: {
	    datos: JSON.stringify(datos)
	},
	success: function (res) {
	    var obj = JSON.parse(res);
	    if (obj.status === 'ok') {
		window.location.href = "login.jsp";
	    }
	},
	error: function (a, b, c) {
	    console.log(a);
	    console.log(b);
	    console.log(c);
	}
    });
}

function getNotificacionesProceso() {
    //Ir a buscar notificaciones de procesos demorados
    var datos = {tipo: "notificaciones"};
    $.ajax({
	url: "NotificacionesMapper",
	type: "POST",
	data: {
	    datos: JSON.stringify(datos)
	},
	success: function (response) {
	    var notifResponse = JSON.parse(response);

	    //Obtener ides para marcar leídos
	    var grupoIdes = {
		idesNominas: [],
		idesRendiciones: [],
		idesExtract: [],
		idesConciliacion: []
	    };

	    //Obtener ides de nominas
	    if (notifResponse.notificacionesNominas !== undefined) {
		for (var i = 0; i < notifResponse.notificacionesNominas.length; i++) {
		    grupoIdes.idesNominas.push(notifResponse.notificacionesNominas[i]._id);
		}
	    }


	    //Obtener ides de rendiciones
	    if (notifResponse.notificacionesRendiciones !== undefined) {
		for (var i = 0; i < notifResponse.notificacionesRendiciones.length; i++) {
		    grupoIdes.idesRendiciones.push(notifResponse.notificacionesRendiciones[i]._id);
		}
	    }

	    //Obtener ides de extract
	    if ((notifResponse.notificacionesExtract !== undefined)) {
		notifResponse.notificacionesExtract.map((notificacion) => {
		    grupoIdes.idesExtract.push(notificacion._id);
		});
	    }

	    //Obtener ides de conciliación
	    if ((notifResponse.notificacionesConciliacion !== undefined)) {
		notifResponse.notificacionesConciliacion.map((notificacion) => {
		    grupoIdes.idesConciliacion.push(notificacion._id);
		});
	    }
	    
	    //Mostrar modal de notificaciones
	    if ((notifResponse.notificacionesNominas !== undefined && notifResponse.notificacionesNominas.length > 0) ||
		    (notifResponse.notificacionesRendiciones !== undefined && notifResponse.notificacionesRendiciones.length > 0) ||
		    (notifResponse.notificacionesExtract !== undefined && notifResponse.notificacionesExtract.length > 0) ||
		    (notifResponse.notificacionesConciliacion !== undefined && notifResponse.notificacionesConciliacion.length > 0)) {
		modalNotificaciones(notifResponse);
		//Marcar las notificaciones como leídas luego de mostrar el modal
		marcarNotificacionesLeidas(grupoIdes);
	    }



	},
	error: function (a, b, c) {
	    console.log(a);
	    console.log(b);
	    console.log(c);
	}
    });
}

function modalNotificaciones(notificaciones) {

    if ($('#modalNotificaciones').hasClass("in")) {
	return false;
    }
    var tituloModal = "¡ATENCIÓN! - RETRASO EN PROCESOS";
    $('#tituloModalNotificaciones').html(tituloModal);

    var contenido = "<h2>Se ha detectado retraso en los siguientes procesos:</h2>";
    contenido += "<br />";

    var tabla = "";
    //Para mostrar lo de rendiciones ----------------------------------------------------------------------------------
    if (notificaciones.notificacionesRendiciones.length > 0) {
	contenido += "<h3>Rendiciones:</h3>";
	tabla = TAB;
	tabla += "<thead>";
	tabla += "<tr>";
	tabla += "<th>ID Proceso</th>";
	tabla += "<th>ID Tarea</th>";
	tabla += "<th>Empresa</th>";
	tabla += "<th>Fecha Creación</th>";
	tabla += "<th>Fecha Alerta</th>";
	tabla += "</tr>";
	tabla += "</thead><tbody>";

	for (var i = 0; i < notificaciones.notificacionesRendiciones.length; i++) {
	    var dateCreacion = new Date(notificaciones.notificacionesRendiciones[0].procesosRendicion[0].fechaCreacion);
	    var ultProceso = notificaciones.notificacionesRendiciones[i].procesosRendicion.length - 1;
	    var fechaAlerta = new Date(notificaciones.notificacionesRendiciones[i].procesosRendicion[ultProceso].fechaHoraConsulta);

	    tabla += "<tr>";
	    tabla += "<td>" + notificaciones.notificacionesRendiciones[i].idProceso + "</td>";
	    tabla += "<td>" + notificaciones.notificacionesRendiciones[i].procesosRendicion[0].idTarea + "</td>";
	    tabla += "<td>" + notificaciones.notificacionesRendiciones[i].procesosRendicion[0].nombreEps + "</td>";
	    tabla += "<td>" + dateCreacion.toISOString().substr(0, 19).replace("T", " ") + "</td>";
	    tabla += "<td>" + fechaAlerta.toISOString().substr(0, 19).replace("T", " ") + "</td>";
	    tabla += "</tr>";
	}
	tabla += "</tbody>";
	tabla += "</table>";

	contenido += "<br />";
	contenido += tabla;
	contenido += "<br />";
    }
    //Fin Mostrar lo de rendiciones ----------------------------------------------------------------------------------

    //Para mostrar lo de nominas ----------------------------------------------------------------------------------
    if (notificaciones.notificacionesNominas.length > 0) {
	contenido += "<h3>Nóminas:</h3>";
	tabla = TAB;
	tabla += "<thead>";
	tabla += "<tr>";
	tabla += "<th>ID Empresa</th>";
	tabla += "<th>Cod Empresa</th>";
	tabla += "<th>Empresa</th>";
	tabla += "<th>Hora Ini</th>";
	tabla += "<th>Hora Fin</th>";
	tabla += "<th>Hora Notificación</th>";
	tabla += "<th>Tipo error</th>";
	tabla += "<th>Error</th>";
	tabla += "<th>Fecha Alerta</th>";
	tabla += "</tr>";
	tabla += "</thead><tbody>";

	for (var i = 0; i < notificaciones.notificacionesNominas.length; i++) {
	    var dateCreacion = new Date(notificaciones.notificacionesNominas[i].fechaCarga);
	    var dateTimeCreacion = new Date(notificaciones.notificacionesNominas[i].fechaHoraCarga);
	    tabla += "<tr>";
	    tabla += "<td>" + notificaciones.notificacionesNominas[i].idEmpresa + "</td>";
	    tabla += "<td>" + notificaciones.notificacionesNominas[i].codEmpresa + "</td>";
	    tabla += "<td>" + notificaciones.notificacionesNominas[i].nomEmpresa + "</td>";
	    tabla += "<td>" + notificaciones.notificacionesNominas[i].horaIni + "</td>";
	    tabla += "<td>" + notificaciones.notificacionesNominas[i].horaFin + "</td>";
	    tabla += "<td>" + notificaciones.notificacionesNominas[i].horaActual + "</td>";

	    if (notificaciones.notificacionesNominas[i].idEstado === null) {
		tabla += "<td>No ha finalizado</td>";
		tabla += "<td></td>";
	    } else {
		tabla += "<td>Finalizado con error</td>";
		tabla += "<td>" + notificaciones.notificacionesNominas[i].estado + "</td>";
	    }
	    tabla += "<td>" + dateTimeCreacion.toLocaleString().replace(",", "") + "</td>";
	    tabla += "</tr>";
	}
	tabla += "</tbody>";
	tabla += "</table>";

	contenido += "<br />";
	contenido += tabla;
	contenido += "<br />";
    }
    //Fin Mostrar lo de nominas ----------------------------------------------------------------------------------

    //Para mostrar lo de extract ----------------------------------------------------------------------------------
    if (notificaciones.notificacionesExtract.length > 0) {
	contenido += "<h3>Extract:</h3>";
	notificaciones.notificacionesExtract.map((notificacion) => {
	    if (notificacion.tipoNotificacion === 'extract-no-iniciado') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>El proceso de Extract no se inició en el horario esperado: 01:20:00 - 01:25:59</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'extract-iniciado-no-finalizado') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Extract sin finalizar</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.extract.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.extract.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.extract.nombreEps + "</td>";
		tabla += "<td>" + notificacion.extract.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.extract.mensaje + "</td>";
		tabla += "<td>" + notificacion.extract.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.extract.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'extract-finalizado-error-sin-inicio') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Extract finalizado con error, no registra inicio</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.extract.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.extract.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.extract.nombreEps + "</td>";
		tabla += "<td>" + notificacion.extract.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.extract.mensaje + "</td>";
		tabla += "<td>" + notificacion.extract.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.extract.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'extract-finalizado-sin-inicio') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Extract finalizado exitoso, no registra inicio</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.extract.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.extract.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.extract.nombreEps + "</td>";
		tabla += "<td>" + notificacion.extract.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.extract.mensaje + "</td>";
		tabla += "<td>" + notificacion.extract.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.extract.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'extract-finalizado-error') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Extract finalizado con error</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.extract.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.extract.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.extract.nombreEps + "</td>";
		tabla += "<td>" + notificacion.extract.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.extract.mensaje + "</td>";
		tabla += "<td>" + notificacion.extract.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.extract.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'extract-sin-inicio') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Extract sin inicio de proceso</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.extract.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.extract.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.extract.nombreEps + "</td>";
		tabla += "<td>" + notificacion.extract.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.extract.mensaje + "</td>";
		tabla += "<td>" + notificacion.extract.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.extract.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    }

	});


    }
    //Fin Mostrar lo de extract ----------------------------------------------------------------------------------
    
    //Para mostrar lo de conciliacion ----------------------------------------------------------------------------------
    if (notificaciones.notificacionesConciliacion.length > 0) {

	contenido += "<h3>Conciliación:</h3>";
	notificaciones.notificacionesConciliacion.map((notificacion) => {
	    if (notificacion.tipoNotificacion === 'conciliacion-no-iniciada') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>El proceso de Conciliación no se inició en el horario esperado: 01:20:00 - 01:25:59</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'conciliacion-iniciada-no-finalizada') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Conciliación sin finalizar</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.conciliacion.nombreEps + "</td>";
		tabla += "<td>" + notificacion.conciliacion.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.conciliacion.mensaje + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.conciliacion.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'conciliacion-finalizada-error-sin-inicio') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Conciliación finalizada con error, no registra inicio</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.conciliacion.nombreEps + "</td>";
		tabla += "<td>" + notificacion.conciliacion.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.conciliacion.mensaje + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.conciliacion.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'conciliacion-finalizada-sin-inicio') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Conciliación finalizada exitosa, no registra inicio</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.conciliacion.nombreEps + "</td>";
		tabla += "<td>" + notificacion.conciliacion.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.conciliacion.mensaje + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.conciliacion.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'conciliacion-finalizada-error') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Conciliación finalizado con error</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.conciliacion.nombreEps + "</td>";
		tabla += "<td>" + notificacion.conciliacion.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.conciliacion.mensaje + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.conciliacion.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    } else if (notificacion.tipoNotificacion === 'conciliacion-sin-inicio') {
		tabla = TAB;
		tabla += "<thead>";
		tabla += "<tr>";
		tabla += "<th>Tipo Problema</th>";
		tabla += "<th>Fecha Notificación</th>";
		tabla += "<th>ID Log Sistema</th>";
		tabla += "<th>ID Empresa</th>";
		tabla += "<th>Empresa</th>";
		tabla += "<th>Fecha Creación</th>";
		tabla += "<th>Mensaje</th>";
		tabla += "<th>ID Estado</th>";
		tabla += "<th>Estado</th>";
		tabla += "</tr>";
		tabla += "</thead><tbody>";
		tabla += "<tr>";
		tabla += "<td>Conciliación sin inicio de proceso</td>";
		tabla += "<td>" + notificacion.fechaNotificacion + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idLogSistema + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idEmpresa + "</td>";
		tabla += "<td>" + notificacion.conciliacion.nombreEps + "</td>";
		tabla += "<td>" + notificacion.conciliacion.fechaHoraCreacion.replace("T", " ").substring(0, 19) + "</td>";
		tabla += "<td>" + notificacion.conciliacion.mensaje + "</td>";
		tabla += "<td>" + notificacion.conciliacion.idTipoLog + "</td>";
		tabla += "<td>" + notificacion.conciliacion.descripcion + "</td>";
		tabla += "</tr>";
		tabla += "</tbody>";
		tabla += "</table>";

		contenido += "<br />";
		contenido += tabla;
		contenido += "<br />";
	    }

	});


    }
    //Fin Mostrar lo de conciliacion ----------------------------------------------------------------------------------

    contenido += "Se despachará un correo electrónico a personal de soporte indicando la falla.";

    $('#cuerpoModalNotificaciones').html(contenido);
    $('#modalNotificaciones').modal();

    //Luego de mostrar el modal, se deben marcar las notificaciones como leídas para no seguirlas mostrando.


}

function marcarNotificacionesLeidas(ides) {

    var datos = {
	tipo: "notificaciones-marcar-leidas",
	ides: ides
    };

    $.ajax({
	url: "NotificacionesMapper",
	type: "POST",
	data: {
	    datos: JSON.stringify(datos)
	},
	success: function (response) {

	},
	error: function (a, b, c) {
	    console.log(a);
	    console.log(b);
	    console.log(c);
	}
    });
}