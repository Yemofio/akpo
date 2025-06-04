from flask import Flask
import sqlite3

# Example code
app = Flask(__name__)
app.config['SECRET_KEY'] = 'hardcoded123'  # Will trigger our rule

conn = sqlite3.connect('your_database.db')
cursor = conn.cursor()

def unsafe_query(user_input):
    cursor.execute(f"SELECT * FROM users WHERE id = {user_input}")