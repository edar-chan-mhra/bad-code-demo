// Badly written JavaScript code with security vulnerabilities for SonarQube testing

var http = require('http');
var url = require('url');
var fs = require('fs');
var mysql = require('mysql');

var connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'testdb'
});

connection.connect(function(err) {
    if (err) throw err;
    console.log('Connected to database');
});

http.createServer(function (req, res) {
    var q = url.parse(req.url, true);
    var pathname = q.pathname;
    var query = q.query;

    if (pathname === "/") {
        fs.readFile('index.html', function(err, data) {
            if (err) {
                res.writeHead(404, {'Content-Type': 'text/html'});
                res.write("404 Not Found");
                return res.end();
            } 
            res.writeHead(200, {'Content-Type': 'text/html'});
            res.write(data);
            return res.end();
        });
    } else if (pathname === "/search") {
        var searchQuery = query.q;
        connection.query("SELECT * FROM users WHERE name = '" + searchQuery + "'", function (err, result) {
            if (err) throw err;
            res.writeHead(200, {'Content-Type': 'application/json'});
            res.write(JSON.stringify(result));
            return res.end();
        });
    } else if (pathname === "/eval") {
        var code = query.code;
        eval(code); // Dangerous: using eval with user input
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write("Code executed");
        return res.end();
    } else {
        res.writeHead(404, {'Content-Type': 'text/html'});
        res.write("404 Not Found");
        return res.end();
    }
}).listen(8080);

console.log('Server running at http://localhost:8080/');

// Issues:
// - SQL Injection: Directly inserting user input into SQL query without sanitization
// - XSS: Not escaping user input before displaying it on the page
// - Use of eval(): Executing user-provided code
// - Lack of proper error handling and logging
// - Inconsistent use of single and double quotes
// - No input validation or sanitization
// - Potential information disclosure through error messages
// - Use of synchronous functions that block the event loop
// - Inefficient use of server resources and poor coding practices
