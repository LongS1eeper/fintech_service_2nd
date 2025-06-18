import requests
from bs4 import BeautifulSoup
import pandas as pd
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import os

def clean_title(title_html):
    # BeautifulSoup으로 HTML 파싱
    soup = BeautifulSoup(title_html, 'html.parser')
    # mark 태그 제거
    for mark in soup.find_all('mark'):
        mark.unwrap()
    return soup.get_text().strip()

def extract_blog_content(blog_url):
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0'
        }
        res = requests.get(blog_url, headers=headers)
        soup = BeautifulSoup(res.text, 'html.parser')

        # iframe 구조일 경우 본문 실제 주소 추출
        iframe = soup.find('iframe', {'id': 'mainFrame'})
        if iframe:
            real_blog_url = 'https://blog.naver.com' + iframe['src']
            res = requests.get(real_blog_url, headers=headers)
            soup = BeautifulSoup(res.text, 'html.parser')

        # 본문 내용 추출 (클래스는 블로그에 따라 다름, 가장 일반적인 선택자 기준)
        content_area = soup.select_one('div.se-main-container')
        if content_area:
            return content_area.get_text(separator='\n').strip()

        # 구형 블로그 에디터 대응
        content_area = soup.select_one('#postViewArea')
        if content_area:
            return content_area.get_text(separator='\n').strip()

    except Exception as e:
        print(f"본문 크롤링 실패: {blog_url} / 오류: {e}")
        return None
    

def search_naver_blog(keyword, max_pages=1):
    # 검색 결과를 저장할 리스트
    results = []
    print('시작')
    
    # Selenium 설정
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1920,1080')
    
    
    driver = webdriver.Chrome(options=options)
    
    try:
        for page in range(1, 11):
            url = f"https://section.blog.naver.com/Search/Post.naver?pageNo={page}&rangeType=ALL&orderBy=sim&keyword={keyword}"
            print(url)
            driver.get(url)
            
            # 페이지 로딩 대기
            time.sleep(3)
            
            # 블로그 포스트 목록 찾기
           
            posts = driver.find_elements(By.CSS_SELECTOR, "div.area_list_search > div.list_search_post")
            if posts:
                print(f"{len(posts)}개의 포스트 발견!")
            else:
                print('없어용')
            
            for post in posts:
                try:
                   
                    title_elements = post.find_elements(By.CSS_SELECTOR, "div.info_post div.desc a.desc_inner strong")
                    title_element = post.find_element(By.CSS_SELECTOR, "div.info_post div.desc a.desc_inner strong")
                    title = title_element.text.strip()

        
                    link_element = post.find_element(By.CSS_SELECTOR, "div.info_post div.desc a.desc_inner")
                    link = link_element.get_attribute("href")

                    try:
                        author_element = post.find_element(By.CSS_SELECTOR, "div.info_post div.writer_info a > em")
                        author_id = author_element.text.strip()

                    except:
                        print('작성자 id 없음: ', link)
                        author_id = "Unknown"
                    
                    # 내용 추출
                    content = extract_blog_content(link)
                    
                    results.append({
                        'author_id': author_id,
                        'title': title,
                        'link': link,
                        'content': content

                    })
                except Exception as e:
                    print(f"게시물 처리 중 오류 발생: {e}")
                    continue
            
            print(f"페이지 {page} 처리 완료")
            # print(results)
    
    finally:
        driver.quit()
    
    return results


def main():
    # data 디렉토리 생성
    os.makedirs('C:/fintech/08INTALK/data', exist_ok=True)
    
    # 검색할 키워드 입력
    keyword = input("검색할 키워드를 입력하세요: ")
    
    # 블로그 검색 실행
    print(f"'{keyword}' 키워드로 네이버 블로그 검색을 시작합니다...")
    results = search_naver_blog(keyword)
    
    # 결과를 DataFrame으로 변환
    df = pd.DataFrame(results)
    
    # 결과 출력
    print("\n검색 결과:")
    
    # 결과를 CSV 파일로 저장
    filename = f"./data/{keyword}.csv"
    df.to_csv(filename, index=False, encoding='utf-8-sig')
    print(f"\n결과가 {filename} 파일에 저장되었습니다.")
    print(len(results))


if __name__ == "__main__":
    main() 