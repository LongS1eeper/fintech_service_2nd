import os
import requests
import time
import pandas as pd
from bs4 import BeautifulSoup as bs
from datetime import datetime
from sqlalchemy import create_engine, text
import pymysql
pymysql.install_as_MySQLdb()

# 데이터 전처리
company_infos = []
url = 'https://kind.krx.co.kr/corpgeneral/corpList.do'
i = 1

while i <= 28:
    payload = dict(method='searchCorpList', 
               pageIndex=i, 
               currentPageSize=100,
               orderMode=3,
               orderStat='D',
               searchType=13,
               fiscalYearEnd='all',
               location='all')
    r = requests.post(url, data=payload)
    soup = bs(r.content, 'lxml')
    
    time.sleep(0.5)
    
    corp_list = soup.select('tbody > tr')
    
    for corp in corp_list:
        # 주식 종목
        stock_type = corp.select_one('img')['alt']
        # 회사명
        company_name = corp.select_one('td.first').text.strip()
        # 종목 코드
        stock_code = corp.select_one('a')['onclick'].split("'")[1]
        # 업종
        business_type = corp.select('td.textOverflow')[0].text
        # 주요제품
        product = corp.select('td.textOverflow')[1].text
        # 상장
        resi_time = corp.select('td.txc')[0].text
        # 결산월
        settlement = corp.select('td.txc')[1].text
        # 대표자명
        ceo=corp.select('td.txc')[2].text
        # 홈페이지
        if corp.select('td.txc')[3].select_one('a.homepage'):
            homepage = corp.select('td.txc')[3].select_one('a.homepage')['href']
        else:
            homepage = None
        # 지역
        region = corp.select('td.txc')[4].text
        company_infos.append((stock_type, company_name, stock_code, business_type, product, resi_time, settlement, ceo, homepage, region))
    print(i,'/ 26 페이지 출력 완료',end='\r')

    i += 1
    
    
# 컬럼명
columns = soup.select_one("table")['summary'].split(', ')
columns.insert(0,'주식종목')
columns.insert(2,'종목코드')

# 데이터프레임 형성
df = pd.DataFrame(company_infos,columns = columns)
print('데이터프레임 형성')

# 저장 코드
today = datetime.now()
today = f"{today.year}_{today.month:02d}_{today.day:02d}"


# 폴더 자동 생성
if not os.path.exists("./scraping_results"):
    os.mkdir("./scraping_results")


# 시점도 함께 저장하기
df.to_csv(f"./scraping_results/상장기업정보_{today}기준.csv", encoding='utf-8',index=False)
print('csv 파일로 저장')

# 데이터베이스 접속 및 저장
engine = create_engine("mysql+pymysql://root:1234@localhost:3306/stock_info")
conn = engine.connect()         # engine.connect : create_engine에 있는 정보로 DB 접속
# 데이터 프레임명.to_sql('테이블명')
df.to_sql(f'stock_company_info_{today}', con=conn, if_exists='replace', index=False)
conn.close()
print('SQL에 저장')


