var express = require('express');
var router = express.Router();
var baza =  require('../konekcija.js');

var konekcija = baza.dbConnection();

/* GET users listing. */

router.get('/registracija/profesor', function (req, res, next) {
    res.render('profRegistration');
});


router.get('/registracija/student', function (req, res, next) {
    res.render('studentRegistration');
});



router.post('/izaberi', function (req, res, next) {
   var tipKorisnika = req.body.tipKorisnika;
   if(tipKorisnika === 'Profesor')
       res.redirect('/users/registracija/profesor');
    else if(tipKorisnika === 'Student')
        res.redirect('/users/registracija/student');
});


router.post('/registracija/profesor', function (req, res, next) {
    var korisnickiDetalji={
        "ime":req.body.ime,
        "prezime":req.body.prezime,
        "brojIndexa":null,
        "datumRodjenja":null,
        "email":req.body.email,
    }

    var ime = req.body.ime;
    var prezime = req.body.prezime;
    var username = req.body.username;
    var email = req.body.email;
    var password = req.body.password;
    var provjeraPassword = req.body.passwordValidation;
    var fakultet = req.body.fakultet;
    var odsjek = req.body.odsjek;
    var tipKorisnika = 'profesor';
    var aktivan = 1;

    req.checkBody('ime', 'Ime je obavezno').notEmpty();
    req.checkBody('prezime', 'Prezime je obavezno').notEmpty();
    req.checkBody('username', 'Username je obavezan').notEmpty();
    req.checkBody('email', 'Email je obavezan').notEmpty();
    req.checkBody('email', 'Email nije ispravan').isEmail();
    req.checkBody('password', 'Password je obavezan').notEmpty();
    // req.checkBody('provjeraPassword', 'Passwordi se ne poklapaju').equals(req.body.password);
    req.checkBody('fakultet', 'Fakultet je obavezan').notEmpty();
    req.checkBody('odsjek', 'Odsjek je obavezan').notEmpty();

    var errors = req.validationErrors();

    if(errors){
        console.log(errors);
        res.redirect('/users/registracija/profesor')
    }
    else {
        konekcija.query("SELECT * FROM KorisnickiDetalji WHERE Email = ?", [email], function (error, results, fields) {
            if (error) {
                throw (error);
                console.log(error);
                res.redirect(400, '/users/registracija/profesor')

            } else if (results.length > 0) {
                console.log('Korisnik sa ovim emailom je vec registrovan, unesite novi email');
                res.redirect(409, '/users/registracija/profesor');
            }
            else {
                konekcija.query("SELECT * FROM Korisnik WHERE Username = ?", [username], function (error, resultsKorisnik, fields) {
                    if (error) {
                        throw (error);
                        console.log(error);
                        res.redirect(400, '/users/registracija/profesor')

                    } else if (resultsKorisnik.length > 0) {
                        console.log('Korisnik sa ovim username-om je vec registrovan, unesite novi username');
                        res.redirect(409, '/users/registracija/profesor');
                    }
                    else {
                        konekcija.query('INSERT INTO KorisnickiDetalji SET ?', korisnickiDetalji, function (error, results, fields) {
                            if (error) {
                                console.log("Greska", error);
                                res.redirect(404, '/users/registracija/profesor')
                            }
                            else {
                                var korisnickiDetaljiId = results.insertId;
                                konekcija.query("INSERT INTO TipKorisnika (Tip, KorisnickiDetalji_KorisnickiDetaljiId) values ('" + tipKorisnika + "', '" + korisnickiDetaljiId + "')", function (error, resultsTip, fields) {
                                    if (error) {
                                        console.log("Greska", error);
                                        res.redirect(404, '/users/registracija/profesor')
                                    }
                                    else {
                                        var tipKorisnikaId = resultsTip.insertId;


                                        var danas = new Date();
                                        var dd = danas.getDate();
                                        var mm = danas.getMonth() + 1;
                                        var yyyy = danas.getFullYear();

                                        if (dd < 10) {
                                            dd = '0' + dd;
                                        }
                                        if (mm < 10) {
                                            mm = '0' + mm;
                                        }

                                        danas = yyyy + '-' + mm + '-' + dd;
                                        var godinaPlus = yyyy + 10;
                                        var vaziDo = godinaPlus + '-' + mm + '-' + dd;

                                        konekcija.query("INSERT INTO Korisnik (TipKorisnika_TipKorisnikaId, Username, Password, Aktivan, DatumKreiranjaAccounta, DatumVazenjaAccounta) VALUES ('" + tipKorisnikaId + "', '" + username + "', password('" + password + "'), b'" + aktivan + "', '" + danas + "', '" + vaziDo + "')", function (error, resultsKorisnik, fields) {
                                            if (error) {
                                                console.log("Greska", error);
                                                res.redirect(404, '/users/registracija/profesor')
                                            }
                                        });


                                    }
                                });
                                konekcija.query("INSERT INTO Odsjek (KorisnickiDetalji_KorisnickiDetaljiId, Naziv, Fakultet) VALUES ('" + korisnickiDetaljiId + "','" + odsjek + "','" + fakultet + "')", function (error, results, fields) {
                                    if (error) {
                                        console.log("Greska", error);
                                        res.redirect(404, '/users/registracija/profesor')
                                    }
                                    else {
                                        console.log('Uspjesno ste se registrovali');
                                        res.redirect('/users/login')
                                    }
                                });


                            }
                        });
                    }
                });
            }
        });
    }
});

router.post('/registracija/student', function (req, res, next) {
    var korisnickiDetalji = {
        "ime": req.body.ime,
        "prezime": req.body.prezime,
        "datumRodjenja": req.body.datumRodjenja,
        "brojIndexa": req.body.brojIndexa,
        "email": req.body.email,
    }
    var ime = req.body.ime;
    var prezime = req.body.prezime;
    var datumRodjenja = req.body.datumRodjenja;
    var brojIndexa = req.body.brojIndexa;
    var email = req.body.email;
    var username = req.body.username;
    var password = req.body.password;
    var provjeraPassword = req.body.passwordValidation;
    var fakultet = req.body.fakultet;
    var odsjek = req.body.odsjek;
    var smjer = req.body.smjer;
    var tipKorisnika = 'student';
    var aktivan = 1;

    req.checkBody('ime', 'Ime je obavezno').notEmpty();
    req.checkBody('prezime', 'Prezime je obavezno').notEmpty();
    req.checkBody('datumRodjenja', 'Datum rodjenja je obavezan').notEmpty();
    req.checkBody('brojIndexa', 'Broj indexa je obavezan').notEmpty();
    req.checkBody('username', 'Username je obavezan').notEmpty();
    req.checkBody('email', 'Email je obavezan').notEmpty();
    req.checkBody('email', 'Email nije ispravan').isEmail();
    req.checkBody('password', 'Password je obavezan').notEmpty();
    req.checkBody('fakultet', 'Fakultet je obavezan').notEmpty();
    req.checkBody('odsjek', 'Odsjek je obavezan').notEmpty();
    req.checkBody('smjer', 'Smjer je obavezan').notEmpty();

    var errors = req.validationErrors();

    if(errors){
        console.log(errors);
        res.redirect('/users/registracija/student')
    }
    else {
        konekcija.query("SELECT * FROM KorisnickiDetalji WHERE Email = ?", [email], function (error, results, fields) {
            if (error) {
                throw (error);
                console.log(error);
                res.redirect(400, '/users/registracija/student');

            } else if (results.length > 0) {
                console.log('Korisnik sa ovim emailom je vec registrovan, unesite novi email');
                res.redirect(409, '/users/registracija/student');
            }
            else {
                konekcija.query("SELECT * FROM KorisnickiDetalji WHERE BrojIndexa = ?", [brojIndexa], function (error, results, fields) {
                    if (error) {
                        throw(error);
                        console.log(error);
                        res.redirect(400, '/users/registracija/student');
                    } else if (results.length > 0) {
                        console.log('Student sa ovim indexom je vec registrovan, unesite novi broj indexa');
                        res.redirect(409, '/users/registracija/student');
                    }
                    else {
                        konekcija.query("SELECT * FROM Korisnik WHERE Username = ?", [username], function (error, resultsKorisnik, fields) {
                            if (error) {
                                throw (error);
                                console.log(error);
                                res.redirect(400, '/users/registracija/student')

                            } else if (resultsKorisnik.length > 0) {
                                console.log('Korisnik sa ovim username-om je vec registrovan, unesite novi username');
                                res.redirect(409, '/users/registracija/student');
                            }
                            else {
                                konekcija.query('INSERT INTO KorisnickiDetalji SET ?', korisnickiDetalji, function (error, results, fields) {
                                    if (error) {
                                        console.log("Greska", error);
                                        res.redirect(404, '/users/registracija/student')
                                    }
                                    else {
                                        var korisnickiDetaljiId = results.insertId;
                                        konekcija.query("INSERT INTO TipKorisnika (Tip, KorisnickiDetalji_KorisnickiDetaljiId) values ('" + tipKorisnika + "', '" + korisnickiDetaljiId + "')", function (error, resultsTip, fields) {
                                            if (error) {
                                                console.log("Greska", error);
                                                res.redirect(404, '/users/registracija/student')
                                            }
                                            else {
                                                var tipKorisnikaId = resultsTip.insertId;
                                                var danas = new Date();
                                                var dd = danas.getDate();
                                                var mm = danas.getMonth() + 1;
                                                var yyyy = danas.getFullYear();

                                                if (dd < 10) {
                                                    dd = '0' + dd;
                                                }
                                                if (mm < 10) {
                                                    mm = '0' + mm;
                                                }

                                                danas = yyyy + '-' + mm + '-' + dd;
                                                var godinaPlus = yyyy + 5;
                                                var vaziDo = godinaPlus + '-' + mm + '-' + dd;


                                                konekcija.query("INSERT INTO Korisnik (TipKorisnika_TipKorisnikaId, Username, Password, Aktivan, DatumKreiranjaAccounta, DatumVazenjaAccounta) VALUES ('" + tipKorisnikaId + "', '" + username + "', password('" + password + "'), b'" + aktivan + "', '" + danas + "', '" + vaziDo + "')", function (error, resultsKorisnik, fields) {
                                                    if (error) {
                                                        console.log("Greska", error);
                                                        res.redirect(404, '/users/registracija/student')
                                                    }
                                                });
                                            }
                                        });
                                        konekcija.query("INSERT INTO Odsjek (KorisnickiDetalji_KorisnickiDetaljiId,Naziv, Smjer, Fakultet) VALUES ('" + korisnickiDetaljiId + "','" + odsjek + "','" + smjer + "','" + fakultet + "')", function (error, results, fields) {
                                            if (error) {
                                                console.log("Greska", error);
                                                res.redirect(404, '/users/registracija/student')
                                            }
                                            else {
                                                console.log('Korisnik je uspjesno registrovan');
                                                res.redirect('/users/login')
                                            }
                                        });


                                    }
                                });
                            }
                        });
                    }

                });
            }
        });
    }
});

router.get('/login', function(req, res, next) {
    res.render('login');
});

router.post('/login', function (req, res, next) {
    var username = req.body.username;
    var password = req.body.password;
    konekcija.query("SELECT TipKorisnika_TipKorisnikaId from Korisnik where Password = password('" + password + "') and username = '" + username + "'", function (err, results, fields) {
        if (err) {
            console.log(err);
            res.redirect('/users/login')
        } else if (results.length > 0) {
            console.log(results[0].TipKorisnika_TipKorisnikaId);
            console.log('Upjesan login');
            konekcija.query("SELECT Tip from TipKorisnika where TipKorisnikaId = ?", [results[0].TipKorisnika_TipKorisnikaId], function (err, resultsTip, fields) {
                if (err) {
                    console.log(err);
                    res.redirect('/users/login');
                } else if (resultsTip[0].Tip == 'student') {
                    res.redirect('/pocetna/student');
                } else if (resultsTip[0].Tip == 'profesor') {
                    res.redirect('/pocetna/profesor');
                }
            });

        } else {
            console.log('Pogresan username ili password');
            res.redirect('/users/login');
        }
    });


});






module.exports = router;
