var http = require('http');
var port = process.env.PORT || 1337;

http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end("Hello world");
}).listen(port);

console.log('Server running at http://127.0.0.1:' + port);
