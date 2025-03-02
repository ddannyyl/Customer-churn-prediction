import sqlite3

data = ""

conn = sqlite3.connect('products.db')
cursor = conn.cursor()

cursor.execute('''
    CREATE TABLE IF NOT EXISTS products (
        price REAL,
        rating REAL,
        reviews INTEGER,
        name TEXT,
        link TEXT
    )
''')
conn.commit()

for item in data:
    cursor.execute('''
        INSERT INTO products (price, rating, reviews, name, link)
        VALUES (:price, :rating, :reviews, :name, :link)
    ''', item)
        
conn.commit()
conn.close()
