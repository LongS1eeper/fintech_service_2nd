import pandas as pd
import re, glob, os, math, html
from pathlib import Path


# ---------- 1. 파일 로드 & 병합 ---------- #
file_paths = [
    "./data/naver_blog_보험설계사 2주 합격.csv",
    "./data/naver_blog_보험설계사 준비 이유.csv",
    "./data/naver_blog_보험설계사 합격 후기.csv",
    "./data/보험설계사 불합격 후기.csv",
    "./data/보험설계사 시험 꿀팁.csv",
    "./data/보험설계사 자격증.csv"
]

frames = []
for path in file_paths:
    try:
        df = pd.read_csv(path, encoding="utf-8")
    except UnicodeDecodeError:
        df = pd.read_csv(path, encoding="cp949")
    df["source_file"] = Path(path).name
    frames.append(df)

df = pd.concat(frames, ignore_index=True)


# ---------- 2. 콘텐츠 컬럼 식별 & 정제 ---------- #
# 'content', '본문', '내용' 중 존재하는 컬럼 선택
content_col = None
for cand in ["content", "본문", "내용", "텍스트", "text"]:
    if cand in df.columns:
        content_col = cand
        break

if content_col is None:
    raise ValueError("본문/내용 컬럼을 찾지 못했습니다.")

def clean_text(t):
    if pd.isna(t):
        return ""
    t = html.unescape(str(t))
    # HTML 태그 제거
    t = re.sub(r"<[^>]+>", " ", t)
    # 공백 정리
    t = re.sub(r"\s+", " ", t)
    return t.strip()

df["clean_text"] = df[content_col].apply(clean_text)


# ---------- 3. 부업 여부(business) ---------- #

# 부업이면 1 아니면 0
business_pattern = re.compile(r"(부업|투잡|n[ -]?잡|side[\s-]?job|사이드잡)", re.I)
df["business"] = df["clean_text"].str.contains(business_pattern).astype(int)


# ---------- 4. 준비 기간 추출 & 빠른 준비(quick) ---------- #
# (\d+)\s*(주|개월|일) 패턴 → 일수 환산
def extract_days(text):
    matches = re.findall(r"(\d+)\s*(주|개월|일)", text)
    days_list = []
    for num, unit in matches:
        n = int(num)
        if unit == "일":
            days_list.append(n)
        elif unit == "주":
            days_list.append(n * 7)
        elif unit == "개월":
            days_list.append(n * 30)
    return min(days_list) if days_list else math.nan

df["prep_days"] = df["clean_text"].apply(extract_days)
df["quick"] = df["prep_days"].apply(lambda x: 1 if not math.isnan(x) and x <= 14 else 0)   # 2주 이하면 1 아니면 0


# ---------- 5. 기본 통계 & 교차표 ---------- #
summary_counts = df[["business", "quick"]].agg(['sum', 'mean']).T
summary_counts.rename(columns={'sum': '합계(건)', 'mean': '비율'}, inplace=True)

crosstab_bq = pd.crosstab(df["business"], df["quick"], margins=True)
crosstab_bq.index = ['일반', '부업', '총합']
crosstab_bq.columns = ['일반 준비', '단기 준비', '총합']

# ---------- 6. 결과 출력 / 시각화 ---------- #
print("=== 핵심 통계 ===")
print(summary_counts)

print("\n=== 부업 여부 × 단기 준비 교차표 ===")
print(crosstab_bq)

new_df = df[['author_id','title','link','clean_text','business','prep_days','quick']]
new_df.to_csv('cleaned_text_all.csv')
print("통합본 저장 완료")