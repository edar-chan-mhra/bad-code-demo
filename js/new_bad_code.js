// new_bad_code.js

var http = require('http');
var url = require('url');
var fs = require('fs');
var mysql = require('mysql');
var crypto = require('crypto');
var userList = require('./userList.json'); // Imagine this contains a list of users

// Connection details should not be hardcoded
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
        // Vulnerable to SQL Injection
        connection.query("SELECT * FROM users WHERE name = '" + searchQuery + "'", function (err, result) {
            if (err) throw err;
            res.writeHead(200, {'Content-Type': 'application/json'});
            res.write(JSON.stringify(result));
            return res.end();
        });
    } else if (pathname === "/command") {
        var command = query.cmd;
        // Dangerous: executing system commands from user input
        require('child_process').exec(command, function (err, stdout, stderr) {
            if (err) {
                res.writeHead(500, {'Content-Type': 'text/plain'});
                res.write("Command execution error");
                return res.end();
            }
            res.writeHead(200, {'Content-Type': 'text/plain'});
            res.write("Command output: " + stdout);
            return res.end();
        });
    } else if (pathname === "/crypto") {
        var input = query.input;
        // Use of weak hash function (MD5)
        var hash = crypto.createHash('md5').update(input).digest('hex');
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.write("MD5 Hash: " + hash);
        return res.end();
    } else if (pathname === "/userinfo") {
        var userId = query.id;
        // Information Disclosure: Exposing user details
        var user = userList[userId];
        res.writeHead(200, {'Content-Type': 'application/json'});
        res.write(JSON.stringify(user));
        return res.end();
    } else if (pathname === "/upload") {
        if (req.method === 'POST') {
            var fileData = '';
            req.on('data', function(data) {
                fileData += data;
            });
            req.on('end', function() {
                // Insecure file upload
                fs.writeFile('/uploads/' + query.filename, fileData, function(err) {
                    if (err) {
                        res.writeHead(500, {'Content-Type': 'text/plain'});
                        res.write("File upload error");
                        return res.end();
                    }
                    res.writeHead(200, {'Content-Type': 'text/plain'});
                    res.write("File uploaded");
                    return res.end();
                });
            });
        } else {
            res.writeHead(405, {'Content-Type': 'text/plain'});
            res.write("Method not allowed");
            return res.end();
        }
    } else {
        res.writeHead(404, {'Content-Type': 'text/html'});
        res.write("404 Not Found");
        return res.end();
    }
}).listen(8080);

console.log('Server running at http://localhost:8080/');

// Issues:
// - SQL Injection: User input is directly inserted into SQL query without sanitization
// - Command Injection: Executing system commands from user input
// - Use of weak hash function (MD5)
// - Information Disclosure: Exposing user details from a JSON file
// - Insecure file upload: Storing uploaded files without validation or sanitization
// - Hardcoded database credentials
// - Lack of proper error handling and logging
// - Inconsistent use of single and double quotes
// - No input validation or sanitization
// - Potential information disclosure through error messages
// - Use of synchronous functions that block the event loop
// - Inefficient use of server resources and poor coding practices
