# 지난 내용 간단정리
CREATE database testdb;																			# 데이터베이스 생성
use testdb;																						# 데이터베이스 접속
CREATE Table test_table(id int, name varchar(100), phone varchar(20), address varchar(255));	# 테이블 컬럼 추가	
SELECT * FROM testdb.test_table;																# 테이블 확인

INSERT INTO test_table VALUES(1, '이정', '010-4444-5455', '안산시', null);	alter					# 테이블에 데이터 추가
SELECT * FROM test_table;																		# 데이터 추가 확인

ALTER table test_table ADD COLUMN id_new int auto_increment primary key;						# 테이블 컬럼 추가

UPDATE test_table SET address='고양시' WHERE id_new=1;											# 입력된 데이터 값 수정
DELETE FROM test_table WHERE id_new = 4;														# 입력된 데이터 삭제


# DATA Import korea_exchange_rate, korea_stock_info
use korea_stock_info;						# 데이터베이스 접속
show tables;								# 컬럼 확인
select * from 2024_09_stock_price_info;		# 로딩 확인
USE korea_exchange_rate;					# 데이터베이스 접속
show tables;								# 컬럼 확인
select count(*) from exchange_rate;			# 로딩 확인(총 개수 확인)


# Q. 2020년 1년치 데이터에서 통화별 현찰_살때_환율의 최소, 최대, 평균가 구하기
SELECT 통화, MAX(현찰_살때_환율) MAX, MIN(현찰_살때_환율) MIN, round(AVG(현찰_살때_환율),2) AVG
FROM korea_exchange_rate.exchange_rate 
WHERE date >= "2020-01-01" AND date <= "2020-12-31" 
GROUP BY 통화;


# 테이블 통합하는 방법
USE korea_stock_info;						# 데이터베이스 접속
SHOW tables;								# 컬럼 확인


# 7,8,9월 자료 통합을 위해 UNION 활용
CREATE table 2024_all_stock_price			# 2024_all_stock_price라는 이름으로 테이블 생성
SELECT * FROM 2024_07_stock_price_info
UNION ALL
SELECT * FROM 2024_08_stock_price_info
UNION ALL
SELECT * FROM 2024_09_stock_price_info
ORDER BY 수집일;


# SQL 함수 => SELECT 함수(값) 형태로 적용
# 1. 절댓값: ABS()
SELECT ABS(-34), ABS(1), ABS(-256);

# 2. 문자열 길이 측정: LENGTH(문자열) 
SELECT LENGTH("my sql") as 길이;

# 3. 반올림 함수: round(값, 반올림 받을 자리)
SELECT round(3.14592,2);

# 4. 정수로 소수점 올림 ceil(), 내림 floor()
SELECT ceil(4.1);
SELECT floor(4.624);

# 5. 연산자를 통한 계산 (div = 몫 / mod = 나머지 / power(밑, 지수) = 제곱 / sqrt(값) = 제곱근 / sign = 부호판단) 
SELECT 7/21, 7*2, 7+2, 7-2, 7%2, 7 div 2, 7 mod 2;
SELECT power(4,3); 	# 64
SELECT sqrt(3);		# 루트3
SELECT sign(5), sign(-78);	# 1, -1

# 6. 버림 함수: truncate(값, 자릿수)
SELECT round(2.2345, 3), truncate(2.2345, 3);	# 2.235, 2.234

## 문자열 함수
# 7. 문자의 길이를 알아보는 함수: char_length
SELECT char_length('my sql'), length('my sql');	# 6, 6
SELECT char_length('홍 길동 '), length('홍 길동');	# 4, 10(한글자 3, 공백 1로 간주)

# 8. 문자열 연결하는 함수: concat(), concat_ws(구분자, 내용1, 내용2, 내용3,..,)
SELECT concat('this', ' is ', 'mysql') as concat1, concat(' this', ' is ', 'mysql ') as concat2;	# 공백 확인 어려움
SELECT concat('this', NULL, 'mysql') as concat1;		# NULL 값이 존재하면 NULL 출력
SELECT concat_ws(' VS ', '아이언맨', '헐크', '타노스') as concat3;	# 아이언맨 VS 헐크 VS 타노스

# 9. 대문자 -> 소문자 lower(), 소문자 -> 대문자 upper()
SELECT LOWER('ABcd'), UPPER('efgh');	# abcd, EFGH

# 10. 문자열의 자릿수를 일정하게 하고 빈 공간을 지정한 문자로 채우는 함수: lpad(값, 자릿수, 채울문자), rpand(값, 자릿수, 채울문자)
SELECT LPAD('sql', 7, '#');		# ####sql
SELECT rpad('sql', 7, '#');		# sql####

# 11. 공백을 없애는 함수: ltrim(문자열), rtrim(문자열)
SELECT ltrim('  sn di  ');		# sn_di__
SELECT rtrim('  sn di  ');		# __sn_di

# 12. 공백을 앞뒤로 없애는 함수: trim(문자열)
SELECT trim('  sn di  ');		# sn_di

# 13. 문자열을 잘라내는 함수: left(문자열, 길이), right(문자열, 길이)
SELECT left('this is mysql', 7);	# this is
SELECT left('이것이 내 데이터다', 7);	# 이것이 내 데		(한글자 = 1 간주)
SELECT right('this is my sql', 6); 	# my sql

# 14. 문자열을 중간에서 잘라내는 함수: substr(문자열, 시작위치, 길이)
SELECT substr('내 이름은 이정호입니다.', 7, 3);	# 이정호
SELECT substr('내 이름은 이정호입니다.', 7);	# 이정호 입니다.

# 15. 문자열의 공백을 앞 뒤로 삭제하고 문자열 앞 뒤에 포함된 특정 문자도 삭제하는 함수: trim(leading '삭제할 문자' from '전체 문자열')
SELECT trim(leading '*' from '****my sql****');		# my sql****
SELECT trim(trailing '*' from '****my sql****');	# ****my sql
SELECT trim(both '*' from '****my sql****');		# my sql
SELECT trim(both '*' from '****my sql*!**');		# my sql*!

## 날짜형 함수
# 16. 간단한 날짜형 함수
SELECT curdate();			# 현재 년월일				2025-02-27
SELECT curtime();			# 현재 시간				16:19:58
SELECT now();				# 현재 년월일 + 시간		2025-02-27 16:19:54
SELECT current_timestamp();	# 현재 년월일 + 현재 시간	2025-02-27 16:19:38

# 17. 요일 표시 함수: dayname(날짜)
SELECT dayname(now());		# Thursday
SELECT dayname(20250505);	# Monday

# 18. 요일을 번호로 표시: dayofweek(날짜) -> 일(1)~토(7)
SELECT dayofweek(now());	# 5
SELECT dayofweek(20250505);	# 2

# 19. 1년 중 오늘이 몇일째인지: dayofyear(날짜)
SELECT dayofyear(now());	# 58
SELECT dayofyear(20250505);	# 125

# 20. 현재 달의 마지막 날이 언제인지: last_day(날짜)
SELECT last_day(now());		# 2025-02-28
SELECT last_day(20250505);	# 2025-05-31

# 21. 입력한 날짜에서 연도만 추출: year(날짜)
SELECT year(now());			# 2025
SELECT year(20250505);		# 2025

# 22. 입력한 날짜에서 월만 추출: month(날짜)
SELECT month(now());		# 2
SELECT month(20250505);		# 5
SELECT monthname(now());	# February

# 23. 몇 분기인지 출력: quarter()
SELECT quarter(now());		# 1
SELECT quarter(20250505);	# 2

# 24. 몇 주차인지 출력: weekofyear()
SELECT weekofyear(now());	# 9
SELECT weekofyear(20250505);# 19

# 25. 날짜와 시간이 같이 있는 데이터에서 날짜와 시간을 구분해주는 함수: date(), time()
SELECT date(now());			# 2025-02-27
SELECT time(now());			# 16:36:51

# 26. 날짜를 지정한 날 수 만큼 더하는 함수: date_add(날짜, interval 더할 날 수 day), adddate(날짜, 숫자)
SELECT date_add(now(), interval 5 day);		# 2025-03-04 16:38:28
SELECT adddate(now(), 5);					# 2025-03-04 16:39:12

# 27. 날짜를 지정한 날 수 만큼 빼는 함수: subdate(날짜, interval 뺄 날 수 day)
SELECT subdate(now(), interval 5 day);		# 2025-02-22 16:42:00
SELECT subdate(now(), 5);					# 2025-02-22 16:42:14

# 28. 날짜와 시간을 년월, 날 시간, 분초 단위로 추출하는 함수: extract(옵션, from 날짜시간)
SELECT extract(year_month from now());		# 202502
SELECT extract(hour_minute from now());		# 1643
SELECT extract(minute_second from now());	# 4549

# 29. 날짜1에서 날짜2를 뺀 일 수 게산: datediff(날짜1, 날짜2)
SELECT datediff(now(), 20241225);			# 64

# 30. 날짜 포멧 함수 - 지정한 형식에 맞춰서 출력해주는 함수: date_format(날짜, '형식')
# %Y 4자리 연도, %y 2자리 연도
# %M 월의 영문표기, %b 월의 축약 영문표기, %m 2자리 월 표기
# %D 일의 영문표기, %d 2자리 일 표기, %e 1자리 일 표기
SELECT date_format(now(), '%d-%b-%Y');		# 27-Feb-2025
SELECT date_format(now(), '%Y-%m-%D');		# 2025-02-27th
SELECT date_format(20250101, '%e-%M-%Y');	# 1-January-2025
SELECT date_format(20250101, '%d-%M-%Y');	# 01-January-2025

# 31. 시간 표기: date_format(날짜, '형식')
# %H 24시간, %h 12시간, %p AM/PM 표시, %i 2자리 분 표기, %S 2자리 초 표기
# %T 24시간 표기법 시:분:초, %r 12시간 표기법 시:분:초 AM/PM
# %W 요일의 영문표기, %w 숫자로 요일 표시 (일 0 ~ 토 7)
SELECT date_format(now(), '%H:%i:%S');		# 17:18:34
SELECT date_format(now(), '%h:%i:%S');		# 05:19:23
SELECT date_format(now(), '%h:%i:%S %p');	# 05:19:48 PM
SELECT date_format(now(), '%T');			# 17:20:19
SELECT date_format(now(), '%r');			# 05:20:32 PM
SELECT date_format(now(), '%W %r');			# Thursday 05:25:21 PM

