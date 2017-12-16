function log() {
    var username = $("#username").val();
    var password = $("#password").val();
    $.post("/users/login", {username: username, password: password})
        .done(function (data) {
            if (data.status == 200) {
                if(data.tip == 'student'){
                    window.location.href = "/users/pocetna/student";
                }
                else if(data.tip == 'profesor'){
                    window.location.href = "/users/pocetna/profesor";
                }
            } else if(data.status == 404) {
                alert(data.poruka);
            }else{
                alert('Greska!');
            }

        });
}




//pocetna je stranica koja ce se otvarati nakon sto je tacno ispunjena login forma