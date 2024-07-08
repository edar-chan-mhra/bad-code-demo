// bad_code.ts

import * as http from 'http';
import * as url from 'url';
import * as fs from 'fs';
import * as mysql from 'mysql';
import * as crypto from 'crypto';

// Connection details should not be hardcoded
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'testdb'
});

connection.connect((err: mysql.MysqlError | null) => {
    if (err) throw err;
    console.log('Connected to database');
});

http.createServer((req: http.IncomingMessage, res: http.ServerResponse) => {
    const q = url.parse(req.url || '', true);
    const pathname = q.pathname;
    const query = q.query;

    if (pathname === "/") {
        fs.readFile('index.html', (err, data) => {
            if (err) {
                res.writeHead(404, { 'Content-Type': 'text/html' });
                res.write("404 Not Found");
                return res.end();
            }
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.write(data);
            return res.end();
        });
    } else if (pathname === "/search") {
        const searchQuery = query.q as string;
        // Vulnerable to SQL Injection
        connection.query(`SELECT * FROM users WHERE name = '${searchQuery}'`, (err, result) => {
            if (err) throw err;
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.write(JSON.stringify(result));
            return res.end();
        });
    } else if (pathname === "/eval") {
        const code = query.code as string;
        // Extremely dangerous: using eval with user input
        eval(code);
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.write("Code executed");
        return res.end();
    } else if (pathname === "/md5") {
        const input = query.input as string;
        // Use of weak hash function (MD5)
        const hash = crypto.createHash('md5').update(input).digest('hex');
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.write("MD5 Hash: " + hash);
        return res.end();
    } else {
        res.writeHead(404, { 'Content-Type': 'text/html' });
        res.write("404 Not Found");
        return res.end();
    }
}).listen(8080);

console.log('Server running at http://localhost:8080/');

// Issues:
// - SQL Injection: User input is directly inserted into SQL query without sanitization
// - XSS: Not escaping user input before displaying it on the page
// - Use of eval(): Executing user-provided code
// - Hardcoded database credentials
// - Use of weak hash function (MD5)
// - Lack of proper error handling and logging
// - Inconsistent use of single and double quotes
// - No input validation or sanitization
// - Potential information disclosure through error messages
// - Use of synchronous functions that block the event loop
// - Inefficient use of server resources and poor coding practices
