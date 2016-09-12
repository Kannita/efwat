(function(){
    var mosca = require('mosca')

    var SECURE_KEY = __dirname + '/../tsl/host.key';
    var SECURE_CERT = __dirname  +'/../tsl/host.crt';

    var settings = {
        port: 1883,
        secure : {
            keyPath: SECURE_KEY,
            certPath: SECURE_CERT
        }
    };

    var server = new mosca.Server(settings);

    server.on('ready', setup);

    function setup() {
        console.log('Mosca server is up and running')
    }

    server.on('clientConnected', function(client) {
        console.log('client connected', client.id);
    });

    server.on('published', function(packet, client) {
        console.log('Published : ', packet.payload);
    });

    server.on('subscribed', function(topic, client) {
        console.log('subscribed : ', topic);
    });

    server.on('unsubscribed', function(topic, client) {
        console.log('unsubscribed : ', topic);
    });

    server.on('clientDisconnecting', function(client) {
        console.log('clientDisconnecting : ', client.id);
    });

    server.on('clientDisconnected', function(client) {
        console.log('clientDisconnected : ', client.id);
    });







})()
