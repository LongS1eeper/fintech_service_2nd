from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

options = Options()
options.add_experimental_option("detach", True)
options.add_argument("star-maximized")
# options.add_argument("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36")
options.add_argument("land=ko_KR")
options.add_argument("Chrome/135.0.0.0")


def kor2eng(keyword):
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        options=options
        )
    driver.get("https://translate.google.com/?hl=ko&tab=TT&sl=ko&tl=en&op=translate")

    # 파이썬 검색
    search_box = driver.find_element(By.CSS_SELECTOR, 'div.QFw9Te textarea')
    search_box.clear()
    search_box.send_keys(keyword)

    wait = WebDriverWait(driver,10)      # 최대 10초동안 기다려라
    search_text_box = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, 'div.lRu31')))

    return search_text_box.text