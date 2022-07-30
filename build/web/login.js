function login() {

    if (validaCampos()) {
        var userName = $('#userName').val();
        var password = $('#password').val();
        var datos = {
            tipo: "login",
            userName: userName,
            password: password
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
                    window.location.href = "index.jsp";
                }
            },
            error: function (a, b, c) {
                console.log(a);
                console.log(b);
                console.log(c);
            }
        });
    }

}

function validaCampos() {
    if ($('#userName').val() === '') {
        alert("El nombre de usuario no puede estar vacío.");
        return false;
    }

    if ($('#password').val() === '') {
        alert("El password no puede estar vacío");
    }

    if ($('#userName').val().length < 4) {
        alert("El largo de un nombre de usuario debe ser mayor a 4 caracteres.");
        return false;
    }

    if ($('#password').val().length < 6) {
        alert("El largo de la contraseña debe ser igual o superior a 6 caracteres.");
        return false;
    }
    return true;
}
