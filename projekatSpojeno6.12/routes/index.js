var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('choose');
});

router.get('/pocetna/student', function(req, res, next) {
    res.render('pocetnaStudent');
});

router.get('/pocetna/profesor', function(req, res, next) {
    res.render('pocetnaProfesor');
});

module.exports = router;
