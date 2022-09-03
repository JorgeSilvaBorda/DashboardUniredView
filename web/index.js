var TAB = '<table class="table table-bordered table-hover" id="cont-tabla" width="100%" cellspacing="0" style="font-size: 12px;">'

$(document).ready(function () {
    $('#contenido').load("modulos/dashboard-nominas.jsp");
    
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
        url: "RendicionesMapper",
        type: "POST",
        data: {
            datos: JSON.stringify(datos)
        },
        success: function(response){
            var notificaciones = JSON.parse(response);
            if(notificaciones.length > 0){
                //Mostrar Modal y marcar como leídas
                modalNotificaciones(notificaciones);
                var idesNotificaciones = [];
                
                for(var i = 0; i< notificaciones.length; i++){
                    idesNotificaciones.push(notificaciones[i]._id);
                }
                //Marcarlas como leídas
                marcarNotificacionesLeidas(idesNotificaciones);
            }
        },
        error: function(a, b, c){
            console.log(a);
            console.log(b);
            console.log(c);
        }
    });
}

function modalNotificaciones(notificaciones){
    //Si el modal no se está mostrando, se muestra.
    if(!$('#modalNotificaciones').hasClass("in")){
        var tituloModal = "Demoras en proceso";
        $('#tituloModalNotificaciones').html(tituloModal);
        
        var contenido = "Se ha detectado retraso en los siguientes procesos:";
        
        var tabla = TAB;
        tabla += "<thead>";
        tabla += "<tr>";
        tabla += "<th>ID Proceso</th>";
        tabla += "<th>ID Tarea</th>";
        tabla += "<th>Empresa</th>";
        tabla += "<th>Fecha Creación</th>";
        tabla += "</tr>";
        tabla += "</thead><tbody>";
        
        for(var i = 0; i < notificaciones.length; i++){
            var dateCreacion = new Date(notificaciones[i].procesosRendicion[0].fechaCreacion);
            
            tabla += "<tr>";
            tabla += "<td>" + notificaciones[i].idProceso + "</td>";
            tabla += "<td>" + notificaciones[i].procesosRendicion[0].idTarea + "</td>";
            tabla += "<td>" + notificaciones[i].procesosRendicion[0].nombreEps + "</td>";
            tabla += "<td>" + dateCreacion.toISOString().substr(0,19).replace("T", " ") + "</td>";
            tabla += "</tr>";
        }
        tabla += "</tbody>"
        tabla += "</table>"
        
        contenido += "<br />"
        contenido += tabla;
        contenido += "<br />"
        contenido += "Se despachará un correo electrónico a personal de soporte indicando la falla."
        
        $('#cuerpoModalNotificaciones').html(contenido);
        $('#modalNotificaciones').modal();
        
        //Luego de mostrar el modal, se deben marcar las notificaciones como leídas para no seguirlas mostrando.
        
    }
    
}

function marcarNotificacionesLeidas(ides){
        
        var datos = {
            tipo: "notificaciones-marcar-leidas",
            ides: ides
        };
        
        $.ajax({
            url: "RendicionesMapper",
            type: "POST",
            data: {
                datos: JSON.stringify(datos)
            },
            success: function(response){
                
            },
            error: function(a, b, c){
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }