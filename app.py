from flask import Flask, render_template, request, redirect, url_for
import os
import psycopg2

app = Flask(__name__)

def get_db_connection():
    # Connect to an existing database
    conn = psycopg2.connect(
        host="postgres_demo_python",
        database="customers",
        user=os.environ['DB_USERNAME'],
        password=os.environ['DB_PASSWORD'])
    return conn

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