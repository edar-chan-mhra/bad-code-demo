# bad_code.py

import sqlite3
import os
from flask import Flask, request

app = Flask(__name__)
DATABASE = 'test.db'

def get_db():
    conn = sqlite3.connect(DATABASE)
    return conn

@app.route('/')
def index():
    return 'Welcome to the insecure app!'

@app.route('/search', methods=['GET'])
def search():
    query = request.args.get('query')
    conn = get_db()
    cursor = conn.cursor()
    # SQL Injection vulnerability
    cursor.execute("SELECT * FROM users WHERE name = '%s'" % query)
    results = cursor.fetchall()
    conn.close()
    return str(results)

@app.route('/execute', methods=['POST'])
def execute():
    command = request.form['command']
    # Command Injection vulnerability
    os.system(command)
    return 'Command executed'

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['file']
    # Directory Traversal vulnerability
    file.save(os.path.join('uploads', file.filename))
    return 'File uploaded'

if __name__ == '__main__':
    app.run(debug=True)

# Issues:
# - SQL Injection: User input is directly used in SQL queries without sanitization.
# - Command Injection: User input is directly passed to os.system.
# - Directory Traversal: Uploaded file paths are not properly sanitized.
# - Poor error handling: No try-except blocks or logging for error handling.
# - Debug mode enabled in Flask: Should not be used in production.
