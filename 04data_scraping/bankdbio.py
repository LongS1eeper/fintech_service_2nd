from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()
import pandas as pd
# from datetime import datetime
import time

def dbconnect():
    engine = create_engine("mysql+pymysql://root:1234@localhost:3306/bank_reviews")
    conn = engine.connect()
    return conn

def to_bank_db(bank, df):
    """
    google play 은행 앱 리뷰를 DB에 저장하는 함수
    """
    # Database 쿼리창 오픈
    conn = dbconnect()
    time.sleep(1)
    df.to_sql(f'{bank}_reviews', con=conn,  if_exists="append", index=False)
    conn.close()
    
