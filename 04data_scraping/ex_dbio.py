from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()
import pandas as pd
# from datetime import datetime
import time

def dbconnect():
    engine = create_engine("mysql+pymysql://root:1234@localhost:3306/exchange_rate")
    conn = engine.connect()
    return conn

def to_ex_db(df):
    """
    
    """
    # Database 쿼리창 오픈
    conn = dbconnect()
    time.sleep(1)
    df.to_sql(f'exchange_rate', con=conn,  if_exists="append", index=False)
    conn.close()
    
def to_ex_db_test(df):
    """
    
    """
    # Database 쿼리창 오픈
    conn = dbconnect()
    time.sleep(1)
    df.to_sql(f'exchange_rate_today', con=conn,  if_exists="append", index=False)
    conn.close()