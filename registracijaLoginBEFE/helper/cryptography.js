var cryptography = {
    crypto: require('crypto'),
    algorithm: 'aes-256-ctr',
    password: 'd6F3Efeq',
    moment: require('moment'),
    /* funkcija koja kriptuje string, koristi se pri radu sa tokenima i koristi aes algoritam */
    encrypt: function (text) {
        var cipher = this.crypto.createCipher(this.algorithm, this.password)
        var crypted = cipher.update(text,'utf8','hex')
        crypted += cipher.final('hex');
        return crypted;
    },
    /* funkcija koja dekriptuje string, koristi se pri radu sa tokenima i koristi simetricni aes algoritam */
    decrypt: function (text) {
        var decipher = this.crypto.createDecipher(this.algorithm, this.password)
        var dec = decipher.update(text, 'hex', 'utf8')
        dec += decipher.final('utf8');
        return dec;
    },
    /* Funkcija koja sifrira password algoritmom sha512, koristi se pri loginu i registraciji za spasavanje u bazu*/
    cryptPassword: function(pass) {
        var key = 'master';
        var hash = this.crypto.createHmac('sha512', key);
        hash.update(pass);
        pass = hash.digest('hex');
        return pass;
    },
    createToken: function(user, days, experiment) {
        var obj = {
            username: user.username,
            admin: user.admin,
            mail: user.mail,
            experiment: experiment,
            expires: this.moment(new Date(), "DD-MM-YYYY").add(days, 'days')
        }

        var str = JSON.stringify(obj);
        var c =  this.encrypt(str);
        return this.encrypt(str);
    },
    getObjectFromToken: function(token) {
        if (!token || token.length === 0) return null;
        str = this.decrypt(token.substr(5));
        var obj = JSON.parse(str);
        return obj;
    }};

module.exports = cryptography;