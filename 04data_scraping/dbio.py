from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()
import pandas as pd
from datetime import datetime

def year_month():
    today = datetime.today()
    return today.year, today.month

def dbconnect():
    engine = create_engine("mysql+pymysql://root:1234@localhost:3306/stock_info")
    conn = engine.connect()
    return conn

def stock_codes():
    """
    MySQL에 접속해서 상장 정보를 가져와 데이터프레임으로 반환해주는 함수
    상장 회사의 종목 코드 6자리를 반환
    """
    conn = dbconnect()
    data = pd.read_sql('stock_company_info_2025_04_04', con=conn)
    conn.close()
    stock_code = data['종목코드'].apply(lambda x: x+"0")
    return stock_code


def to_stock_db(idx, stock_code, stock_name, df):
    """
    idx, stock_code, stock_name, df 를 입력받아
    stock_price_{year}_{month:02d} 형식의 테이블을 mysql에 저장
    """
    # 오늘기준 연도, 달 출력
    year, month = year_month()
    # Database 쿼리창 오픈
    conn = dbconnect()
    df.to_sql(f'stock_price_{year}_{month:02d}', con=conn,  if_exists="append", index=False)
    conn.close()
    print(f"{idx}/{len(stock_code)-1} {stock_name}DB 저장 완료", end="\r")
    return 