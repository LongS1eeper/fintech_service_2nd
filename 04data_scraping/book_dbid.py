from sqlalchemy import create_engine, text
import pymysql
pymysql.install_as_MySQLdb()

def modulebook(df, word):
    engine = create_engine("mysql+pymysql://root:1234@localhost:3306/naver_book")
    conn = engine.connect()
    df.to_sql(f'{word}_book_info', con=conn, if_exists='append', index=False)
    conn.close()