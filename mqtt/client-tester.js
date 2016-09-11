var mqtt = require('mqtt')

client = mqtt.connect({ host: '52.209.72.167', port: 1883 });

var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIkX18iOnsic3RyaWN0TW9kZSI6dHJ1ZSwiZ2V0dGVycyI6e30sIndhc1BvcHVsYXRlZCI6ZmFsc2UsImFjdGl2ZVBhdGhzIjp7InBhdGhzIjp7Il9fdiI6ImluaXQiLCJwYXNzd29yZCI6ImluaXQiLCJob3N0IjoiaW5pdCIsIl9pZCI6ImluaXQifSwic3RhdGVzIjp7Imlnbm9yZSI6e30sImRlZmF1bHQiOnt9LCJpbml0Ijp7Il9fdiI6dHJ1ZSwicGFzc3dvcmQiOnRydWUsImhvc3QiOnRydWUsIl9pZCI6dHJ1ZX0sIm1vZGlmeSI6e30sInJlcXVpcmUiOnt9fSwic3RhdGVOYW1lcyI6WyJyZXF1aXJlIiwibW9kaWZ5IiwiaW5pdCIsImRlZmF1bHQiLCJpZ25vcmUiXX0sImVtaXR0ZXIiOnsiZG9tYWluIjpudWxsLCJfZXZlbnRzIjp7fSwiX2V2ZW50c0NvdW50IjowLCJfbWF4TGlzdGVuZXJzIjowfX0sImlzTmV3IjpmYWxzZSwiX2RvYyI6eyJfX3YiOjAsInBhc3N3b3JkIjoiNTVkYzg3YzE3MzIyIiwiaG9zdCI6ImlkbyIsIl9pZCI6IjU3ZDUwY2ZmODRiN2I5MGI5MzEzN2FhNCJ9LCJfcHJlcyI6eyIkX19vcmlnaW5hbF9zYXZlIjpbbnVsbCxudWxsXSwiJF9fb3JpZ2luYWxfdmFsaWRhdGUiOltudWxsXSwiJF9fb3JpZ2luYWxfcmVtb3ZlIjpbbnVsbF19LCJfcG9zdHMiOnsiJF9fb3JpZ2luYWxfc2F2ZSI6W10sIiRfX29yaWdpbmFsX3ZhbGlkYXRlIjpbXSwiJF9fb3JpZ2luYWxfcmVtb3ZlIjpbXX0sImlhdCI6MTQ3MzU4MDUzNywiZXhwIjoxNjE3NTgwNTM3fQ.8JEKMSW2RgvLxHy68Dhbw8LbuQPvpT0dpopZUJnttl8"

client.on('message', function(topic, message) {
    console.log(message.toString());
});


//register_test();
//auth_test();
update_record_test()
console.log('Client started...');

function register_test(){
    client.subscribe('register_ido');
    client.publish('register',JSON.stringify({host:'ido',pass:'123123'}));
}

function auth_test(){
    client.subscribe('authenticate_ido');
    client.publish('authenticate',JSON.stringify({host:'ido',pass:'123123'}));
}

function update_record_test(){
    client.subscribe('update_record_ido');
    client.publish('update_record',JSON.stringify({host:'ido',token:token,newIp:'127.1.1.0'}));
}