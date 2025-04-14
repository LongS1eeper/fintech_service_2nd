from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import pandas as pd
from datetime import datetime, timedelta

######################################################################
# 웹사이트 접속
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
driver.get("https://play.google.com/store/apps/details?id=viva.republica.toss&utm_source=apac_med")


######################################################################
# 더보기 -> 목록 -> 최신 순으로 클릭
wait = WebDriverWait(driver, 10)
review_btn = wait.until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'button[aria-label="평점 및 리뷰 자세히 알아보기"]'))
).click()

more_btn = wait.until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'div[aria-label="관련성순"]'))
).click()

recent_btn = wait.until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, 'span[aria-label="최신"]'))
).click()


#######################################################################
# 데이터 추출
i = 0
result = []
columns = ['별점', '날짜', '리뷰내용', '답변']

while(True):
    reviews = driver.find_elements(By.CSS_SELECTOR, 'div.RHo1pe')
    review = reviews[i]
    
    
    ############# 시간 계산
    date = review.find_element(By.CSS_SELECTOR, 'span.bp9Aid').text
    # 문자열을 datetime 객체로 변환
    target_date = datetime.strptime(date, "%Y년 %m월 %d일")     # 2025년 4월 14일 -> 2025-04-14 00:00:00
    today = datetime.now()
    two_years_ago = today - timedelta(days=30*2)
    if target_date < two_years_ago:
        break
    print(f'현재 리뷰 날짜: {target_date}, 총 리뷰 수: {i+1}개', end='\r')
    
    ############ 데이터 출력
    # 날짜
    date = review.find_element(By.CSS_SELECTOR, 'span.bp9Aid').text
    # 별점
    star = review.find_element(By.CSS_SELECTOR, 'div.iXRFPc').get_attribute('aria-label')[10]
    # 리뷰내용
    content = review.find_element(By.CSS_SELECTOR, 'div.h3YV2d').text
    # 답변
    try:
        answer = review.find_element(By.CSS_SELECTOR, 'div.ras4vb > div').text
    except Exception:
        answer = None
    result.append((star, date, content, answer))
    
    
    ############ 스크롤
    driver.execute_script("document.querySelector('.fysCi.Vk3ZVd').scrollBy(0,1000)")
    i += 1


#####################################################################
# 데이터프레임 형성
df = pd.DataFrame(result, index = None, columns = columns)

df.to_csv('./scraping_results/토스_리뷰.csv', header=False, index = False, encoding = 'utf-8')
print("데이터프레임 csv 저장 완료")
