"""
---------
dbconnect
---------

This script attempts to resolve a connection to
a database of interest.
"""

import os
import psycopg2
pgpassword = "Ff6H8z2uJ45f5jpnaZlm1xtL"
conn = None
try:
    conn = psycopg2.connect(
        user = "postgres",
        password = pgpassword,
        host = "postgres",
        port = "5432",
        database = "postgres")
except Exception as e:
    print("Error connecting to data warehouse")
    print(e)
else:
    print("Successfully connected to warehouse")
finally:
    if conn:
        conn.close()
        print("Connection closed")
