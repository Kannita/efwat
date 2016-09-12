(function(){
    var mqtt = require('mqtt')
    var configuraion = require('./../configuration.js')

    var host = configuraion.getKey('EFWHAT_SERVER')
    console.log('connecting to mqtt')
    console.log(host);
    var client = mqtt.connect({ host: host, port: 1883 });

    function subscribe(topic,cb){
        client.subscribe(topic);

        client.on('message', function(topic, message) {
            cb(topic,message)
        });
    }

    function publish(topic,message){
        client.publish(topic,message);
    }

    function unsubscribe(topic,cb){
        client.unsubscribe(topic,cb);
    }

    module.exports = {
        publish : publish,
        subscribe : subscribe,
        unsubscribe: unsubscribe
    }

})()