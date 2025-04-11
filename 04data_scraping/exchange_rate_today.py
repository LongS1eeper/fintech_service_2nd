from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import pandas as pd
import holidays
from io import StringIO
from pandas.tseries.offsets import CustomBusinessDay
import datetime
from sqlalchemy import create_engine, text
import pymysql
pymysql.install_as_MySQLdb()

# sql 저장 함수
def to_sql(df):
    engine = create_engine("mysql+pymysql://root:1234@localhost:3306/exchange_rate")
    conn = engine.connect()
    df.to_sql('exchange_rate', con=conn, if_exists='append', index=False)
    conn.close()


# 공휴일이 아닌 평일 날짜 리스트 생성
def is_weekday(today):
    kr_holidays = holidays.KR(years=today.year)
    # holiday를 제외하고 datetimeIndex로 변환
    if (today.weekday() < 5) and (today not in kr_holidays):
        return True
    else:
        return False 

options = Options()
options.add_experimental_option("detach", True)
options.add_argument("star-maximized")
# options.add_argument("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36")
options.add_argument("land=ko_KR")
options.add_argument("Chrome/135.0.0.0")

# 백그라운드에서 돌아가도록 지정
options.add_argument("--headless")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

driver = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()),
    options=options
    )
driver.get("https://www.kebhana.com/cms/rate/index.do?contentUrl=/cms/rate/wpfxd651_01i.do#//HanaBank")


wait = WebDriverWait(driver, 10)

# 날짜 설정
today = datetime.datetime.now()
date = f"{today.year}-{today.month:02d}-{today.day:02d}"
if is_weekday(today) == True:

    # 날짜 기입 후 조회
    date_box = driver.find_element(By.ID, 'tmpInqStrDt')
    date_box.clear()
    date_box.send_keys(date)
    date_box.send_keys(Keys.ENTER)

    date_button = driver.find_element(By.CSS_SELECTOR, 'a.btnDefault.bg')
    date_button.click()

    # 테이블 로드까지 기다리기
    wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, 'table.tblBasic.leftNone')))

    # 테이블 추출
    table_html = driver.find_element(By.CSS_SELECTOR, 'table.tblBasic.leftNone').get_attribute('outerHTML')
    df = pd.read_html(StringIO(table_html))[0]  
    df.columns = [
        '통화', '현찰_살때_환율', '현찰_살때_Spread','현찰_팔때_환율', 
        '현찰_팔때_Spread','송금_보낼때', '송금_받을때',
        '외화수표_팔때', '매매기준율', '환가료율', '미화환산율'
    ]

    # 데이터프레임 맨 앞에 날짜 삽입
    df.insert(0, 'date',f'{date}')
    # df['date'] = date 설정 후 df = df[['date','그외 --']] 로 순서 바꾸기 가능
    # new_column = new_col(df) 후 df.columns = new_columns 후 df = df[['date','그외 --']] 

    to_sql(df)
    print(f'{date}자 데이터 SQL 저장 완료', end='\r')

else:
    print("은행 업무일이 아닙니다.")