import sqlite3


db_name = "gts.db"
conn = sqlite3.connect(db_name)

with open("gts.sql", "r", encoding="utf-8") as f:
    sql_script = f.read()

conn.executescript(sql_script)

conn.commit()
conn.close()

