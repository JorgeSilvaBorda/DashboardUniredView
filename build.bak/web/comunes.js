function getDetalleRendiciones(tipo) {
    cargarModulo("detalle-rendiciones", "tipo=" + tipo);
}

function getDetalleNominas(tipo) {
    cargarModulo("detalle-nominas", "tipo=" + tipo);
}

function getDetalleExtract(tipo) {
    cargarModulo("detalle-extract", "tipo=" + tipo);
}

function getDetalleConciliacion(tipo) {
    cargarModulo("detalle-conciliacion", "tipo=" + tipo);
}

function dateTimeToLocalDate(date, sep) {
    var fecha = new Date(date);
    return (fecha.getUTCDate() < 10 ? "0" : "") + fecha.getUTCDate() + sep + (fecha.getUTCMonth() < 9 ? "0" : "") + (fecha.getUTCMonth() + 1) + sep + fecha.getUTCFullYear();
}

function dateTimeToLocalDateInvertYaEnUTC(date, sep) {
    var fe = new Date(date);
    var anio = fe.getFullYear();
    var mes = (fe.getMonth() < 9 ? "0" : "") + (fe.getMonth() + 1);
    var dia = (fe.getDate() < 10 ? "0" : "") + fe.getDate();
    
    return anio + sep + mes + sep + dia;
    
}

function getHoraFromDateTime(date) {
    var fecha = new Date(date);
    return (fecha.getUTCHours() < 10 ? "0" : "") + fecha.getUTCHours() + ":" + (fecha.getUTCMinutes() < 10 ? "0" : "") + fecha.getUTCMinutes();
}