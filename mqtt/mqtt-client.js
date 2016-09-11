(function(){
    var mqtt = require('mqtt')
    console.log('connecting to mqtt')
    var client = mqtt.connect({ host: '52.209.72.167', port: 1883 });

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