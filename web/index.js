$(document).ready(function () {
    $('#contenido').load("modulos/dashboard-nominas.jsp");
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