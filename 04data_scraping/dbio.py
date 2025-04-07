from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()
import pandas as pd
import requests
import time
from bs4 import BeautifulSoup as bs
from datetime import datetime


def dbconnect():
    engine = create_engine("mysql+pymysql://root:1234@localhost:3306/stock_info")
    conn = engine.connect()
    return conn

def stock_codes():
    """
    MySQL에 접속해서 상장정보를 가져와 데이터프레임으로 반환해주는 함수
    """
    conn = dbconnect()
    data=pd.read_sql('stock_company_info_2025_04_07', con=conn)
    conn.close()
    stock_code = data['종목코드'].apply(lambda x : x+'0')
    return stock_code

def year_month():
    today = datetime.today()
    return today.year, today.month

def to_stock_db(idx, stock_code, stock_name, df):
    # 오늘 기준 연도, 달 출력
    year, month = year_month()
    # Database 쿼리창 오픈
    conn = dbconnect()
    result_df.to_sql(f'stock_price_{year}_{month:02d}', con=conn, if_exists='append', index=False)
    conn.close()
    print('저장완료')

conn = dbconnect()
stock_code = stock_codes()
result = []
for code in stock_code:
    if code[:3] == 'USA' or code[:3] == 'SGP' or code[:3] == 'HKG'or code[:3] == 'JPN'or code[:3] == 'CYM':
        print(code, '건너뛰기')
        print()
        continue
    print(code,'시작',end='\r')
    url = 'https://finance.naver.com/item/main.naver?code='+code
    r = requests.get(url)
    soup = bs(r.text, 'lxml')

    time.sleep(0.1)
    
    # 종목코드
    cd = code
    
    # 종목명
    name = soup.select('dl.blind dd')[1].text.split(' ')[1]
    
    # 현재가
    present = soup.select_one('div.rate_info .no_today').select_one('span.blind').text
    
    # 변동 금액
    if (soup.select('p.no_exday em.no_up')):
        change_cost = soup.select_one('div.rate_info .no_exday').select('span.blind')[0].text
    else:
        change_cost = '-' + soup.select_one('div.rate_info .no_exday').select('span.blind')[0].text
    
    # 변화율
    if (soup.select('p.no_exday em.no_up')):
        change_ratio = soup.select_one('div.rate_info .no_exday').select('span.blind')[1].text
    else:
        change_ratio = '-'+soup.select_one('div.rate_info .no_exday').select('span.blind')[1].text    
        
    # 전일가
    yesterday = soup.select('div.rate_info td')[0].select_one('span.blind').text
    
    # 고가
    high = soup.select('div.rate_info td')[1].select('span.blind')[0].text
    
    # 상한가
    high_limit = soup.select('div.rate_info td')[1].select('span.blind')[1].text
    
    # 저가
    low = soup.select('div.rate_info td')[4].select_one('span.blind').text
    
    # 하한가
    low_limit = ""
    for word in soup.select('div.rate_info td em.no_cha')[1].select('span'):
        low_limit += word.text
    
    # 거래량
    volumn = soup.select('div.rate_info td')[2].select_one('span.blind').text
    
    result.append((cd,name,present,change_cost, change_ratio, yesterday, high,high_limit, low, low_limit, volumn))
    
column = ['종목코드', '종목명', '현재가' , '변동금액', '변동률', '전일가', '고가', '상한가', '저가', '하한가', '거래량']
result_df = pd.DataFrame(result, columns = column)
result_df

to_stock_db()
