import sys

from flask import Flask, render_template, request, redirect, url_for
import os
import psycopg2
from pyservicebinding import binding

try:
    sb = binding.ServiceBinding()
    bindings_list = sb.bindings("postgresql")
    binding = bindings_list[0]

    db_uri = 'postgresql://%s:%s@%s/%s' % (binding['username'], binding['password'], binding['host'], binding['database'])
except binding.ServiceBindingRootMissingError as msg:
    # log the error message and retry/exit
    print("SERVICE_BINDING_ROOT env var not set")

app = Flask(__name__)
def get_db_connection():
    app.logger.info("get_db_connection- DB-URI------------")
    app.logger.info(db_uri)
    # Connect to an existing database
    conn = psycopg2.connect(
        host=binding['host'],
        database=binding['database'],
        user=binding['username'],
        password=binding['password'])

    return conn

def create_tables():
    """ create tables in the PostgreSQL database"""
    commands = (
        """
        CREATE TABLE IF NOT EXISTS  CUSTOMER (
                          ID VARCHAR(50) NOT NULL PRIMARY KEY,
                          FIRST_NAME VARCHAR(50) NOT NULL ,
                          LAST_NAME VARCHAR(50) NOT NULL ,
                          COMPANY_NAME VARCHAR(50) NOT NULL);
        """
        )
    conn = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        # create table one by one
        for command in commands:
            cur.execute(command)

        app.logger.info("Table created")
        # close communication with the PostgreSQL database server
        cur.close()
        # commit the changes
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        app.logger.error(error)
    finally:
        if conn is not None:
            conn.close()

@app.route('/create/', methods=('GET', 'POST'))
def create():
    if request.method == 'POST':
        cust_id = request.form['id']
        cust_first_name = request.form['firstName']
        cust_last_name = request.form['name']
        cust_company_name = request.form['companyName']

        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('INSERT INTO CUSTOMER (ID, FIRST_NAME, LAST_NAME, COMPANY_NAME)'
                    'VALUES (%s, %s, %s, %s)',
                    (cust_id, cust_first_name, cust_last_name, cust_company_name))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))

    return render_template('create.html')

@app.route('/')
def index():
    create_tables()

    conn = get_db_connection()

    cur = conn.cursor()
    cur.execute('SELECT * FROM CUSTOMER;')
    customers = cur.fetchall()
    cur.close()
    conn.close()

    return render_template('index.html', customers=customers)

if __name__ == "__main__":
    port = int(os.environ.get('PORT', 5066))
    app.run(debug=True, host='0.0.0.0', port=port)