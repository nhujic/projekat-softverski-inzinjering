function registracijaStudent() {

    var ime = $("#ime").val();
    var prezime = $("#prezime").val();
    var datumRodjenja = $("#datumRodjenja").val();
    var fakultet = $("#fakultet").val();
    var odsjek = $("#odsjek").val();
    var smjer = $("#smjer").val();
    var brojIndexa = $("#brojIndexa").val();
    var username = $("#username").val();
    var email = $("#email").val();
    var password = $("#password").val();

    $.post("/users/registracija/student", {ime: ime, prezime: prezime, datumRodjenja: datumRodjenja, fakultet: fakultet, odsjek: odsjek, smjer: smjer, brojIndexa: brojIndexa, email: email, username: username, password: password})
        .done(function (data) {
            if(data.status == 200){
                $(alert(data.poruka));
                window.location.href = "../login";
            }else if (data.status == 401) {
                $(alert(data.poruka));
            }
            else if (data.status == 402) {
                $(alert(data.poruka));
            }
            else if (data.status == 403) {
                $(alert(data.poruka));
            }
            else{
                $(alert("Greska"));
            }

        });
}

function registracijaProfesor() {

    var ime = $("#ime").val();
    var prezime = $("#prezime").val();
    var fakultet = $("#fakultet").val();
    var odsjek = $("#odsjek").val();
    var username = $("#username").val();
    var email = $("#email").val();
    var password = $("#password").val();

    $.post("/users/registracija/profesor", {ime: ime, prezime: prezime, fakultet: fakultet, odsjek: odsjek, email: email, username: username, password: password})
        .done(function (data) {
            if(data.status == 200){
                $(alert(data.poruka));
                window.location.href = "../login";
            }else if (data.status == 401) {
                $(alert(data.poruka));
            }
            else if (data.status == 402) {
                $(alert(data.poruka));
            }
            else{
                $(alert("Greska"));
            }


        });
}