//> export PATH=/QOpenSys/QIBM/ProdData/Node/bin
//> export LIBPATH=/QOpenSys/QIBM/ProdData/Node/bin
//> node simple_web_server_nodejs.js
var http = require('http');
const PORT=8080; 
function handleRequest(request, response){
    response.end('It Works!! Path Hit: ' + request.url);
}
var server = http.createServer(handleRequest);
server.listen(PORT, function(){
    //Callback triggered!
    console.log("Server listening on: http://localhost:%s", PORT);
});

