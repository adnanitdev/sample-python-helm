from flask import Flask, jsonify
import os
import psycopg2

app = Flask(__name__)

# Get environment variables for database connection
db_name = os.getenv('POSTGRES_DB')
db_user = os.getenv('POSTGRES_USER')
db_password = os.getenv('POSTGRES_PASSWORD')
db_host = os.getenv('POSTGRES_HOST', 'postgres')  # Default to 'postgres' service name
db_port = os.getenv('POSTGRES_PORT', '5432')

# Connect to the PostgreSQL database
def get_db_connection():
    conn = psycopg2.connect(
        dbname=db_name,
        user=db_user,
        password=db_password,
        host=db_host,
        port=db_port
    )
    return conn

@app.route('/')
def index():
    return jsonify({'message': 'Hello, this is a DevOps Challenge!'})

@app.route('/data')
def data():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT NOW()')
    current_time = cursor.fetchone()
    cursor.close()
    conn.close()
    return jsonify({'current_time': current_time})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
