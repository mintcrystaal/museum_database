import psycopg2

def execute_query(query):
    conn = psycopg2.connect(
        host='localhost',
        port="5432",
        user='postgres',
        password='postgres',
        database='postgres'
    )
    cursor = conn.cursor()
    cursor.execute(query)
    result = cursor.fetchall()
    conn.close()
    return result
