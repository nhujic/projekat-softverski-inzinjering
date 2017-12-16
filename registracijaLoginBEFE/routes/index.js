var express = require('express');
var router = express.Router();



/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('login');
    //res.render('choose');
});

router.get('/choose', function(req, res, next) {
    res.render('choose');
});



module.exports = router;
