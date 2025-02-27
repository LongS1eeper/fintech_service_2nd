# 데이터베이스, 테이블 만들기, 삭제하기
CREATE database sampleDB;
DROP database sampleDB;

# 데이터베이스 조회하기
SHOW databases;

# 테이블 만들기
USE sampledb;	# 우선 데이터베이스 활성화
# CREATE table 테이블명 (컬럼명1 데이터타입, 컬럼명2 데이터타입, ...);
CREATE Table customers(id int, name varchar(100), sex varchar(20), phone varchar(20), address varchar(255));	# VARCHAR(45) -> 45자 크기의 가변 문자 / NN = Not Null (필수 기입으로 생각)

# 테이블 삭제하기
DROP table customers;

# 실습) market_db 만들기
CREATE database market_db;
USE market_db;

# 실습) hongong1 테이블 만들기 toy_id(int), toy_name(char(4)), age(int)
CREATE table hongong1(toy_id int, toy_name char(4), age int);
SHOW tables;	# 테이블 조회
DESC hongong1;	# hongong1 컬럼 조회

# 생성한 테이블에 데이터 입력하기 
# INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3) VALUES (1, '우디', 25);
INSERT INTO hongong1(toy_id, toy_name, age) VALUES (1, '우디', 25);
INSERT INTO hongong1(toy_id, toy_name) VALUES (2, '버즈');			# NULL 값은 컬럼 생략으로도 가능 / age는 NULL처리
INSERT INTO hongong1(toy_name, age, toy_id) VALUES ('제시', 25, 3);	# 컬럼 순서에 맞춰 데이터 순서만 맞춰주면 됨
INSERT INTO hongong1 VALUES (4, '포테이토', 40);						# 테이블에 지정된 컬럼 순서와 동일하다면 코드에서 컬럼명 생략 가능
INSERT INTO hongong1 VALUES (5, '강아지', NULL);						# 위의 경우 데이터가 없는 값은 NULL로 기입해야함 (개수 맞추기)
INSERT INTO hongong1 VALUES (NULL, '포테이토', 40);	
SELECT * FROM hongong1; 											# 테이블 확인

# primary key(주요키)와 auto increment(숫자 자동 생성) 기능을 추가한 테이블 만들기
CREATE table market_db.hongong2 (
	toy_id int AUTO_INCREMENT PRIMARY KEY, 
    toy_name char(4),
    age int);

# AUTO INCREMENT가 지정된 테이블에 데이터 넣기
INSERT INTO hongong2 VALUES (NULL, '보피', 25);						# NULL 값으로 대체
INSERT INTO hongong2 VALUES (NULL, '슬링키', 25);
INSERT INTO hongong2 VALUES (NULL, '렉스', 25);
SELECT * FROM hongong2;

# 테이블 수정하기 ALTER
# 컬럼 추가: ALTER table 테이블명 ADD COLUMN 컬럼명, 자료형, 속성(NOT NULL, UNIQUE)
# 실습) hongong2 테이블에 country 컬럼 조작하기
ALTER TABLE hongong2 ADD COLUMN country varchar(100);		# 컬럼 추가
ALTER TABLE product CHANGE COLUMN 제조일사 제조일자 DATE;		# 컬럼명 수정

# 기존 테이블에 있는 자료 UPDATE 하기 + WHERE과 함께 씀 (WHERE 안쓰면 컬럼의 모든 값이 변경)
# UPDATE 테이블명 SET 컬럼명 = 업데이트할 값 WHERE 주요키 값
UPDATE hongong2 SET toy_name = '보핍' WHERE toy_id = 1;

# 테이블의 내용은 모두 지우되 구조는 남기고 싶은 경우 truncate
# TRUNCATE table 테이블명;
TRUNCATE table hongong2;

# 테이블의 데이터 삭제 DELETE FROM 테이블명 WHERE 조건
DELETE FROM hongong1 WHERE toy_id = 3;		# 주요키를 조건으로 걸어야 오류가 생기지 않음

# idx 컬럼추가 primary key로 지정 AUTO_INCREMENT
ALTER TABLE hongong1 ADD COLUMN idx_1 int AUTO_INCREMENT Primary key;		# 주요키 컬럼 생성
DELETE FROM hongong1 WHERE idx_1 = 10;										# 삭제

# CREATE, INSERT, UPDATE, DELETE, (CRUD)

# 테이블 만들기 실습 예제
CREATE Table member(
	id int auto_increment primary key, 
    member_id varchar(25), 
    name varchar(20), 
    address varchar(255)
);
INSERT INTO member VALUES (NULL, 'tess', '나훈아', '경기도 부천시 중동');
INSERT INTO member VALUES (NULL, 'hero', '임영웅', '서울 운평구 증산동');
INSERT INTO member VALUES (NULL, 'iyou', '아이유', '인천 남구 주안동');
INSERT INTO member VALUES (NULL, 'jyp', '박진영', '경기 고양시 장항동');

CREATE Table product(
	제품이름 varchar(25), 
    가격 int, 
    제조일자 DATE, 
    제조회사 varchar(25), 
    남은수량 int
);
INSERT INTO product VALUES 
('바나나', 1500, 20240701, '델몬트', 17), 
('카스', 2500, 20231212, 'OB', 3), 
('삼각김밥', 1000, 20250226, 'CJ', 22);

# Product 테이블에 prod_id 컬럼을 추가하고
# Auto_increment, Primary key를 추가하시오.
ALTER table product ADD COLUMN prod_id int auto_increment primary key;
SELECT * FROM member;

INSERT INTO member (id, member_id, name) values (null, 'akmu', '악동뮤지션');	# 입력되지 않은 경우 기본값이 입력됨


# Rollback 연습
CREATE database mywork;
USE mywork;
CREATE table emp_test
(emp_no int not null,
emp_name varchar(30) not null,
hire_date date null,
salary int null,
primary key(emp_no));
DESC emp_test;


INSERT INTO emp_test
	(emp_no, emp_name, hire_date, salary)
values
	(1005, '퀴리', 20210301, 4000),
	(1006, '호킹', 20210305, 5000),
	(1007, '패러데이', 20210401, 2200),
	(1008, '맥스웰', 20210404, 3300),
	(1009, '플랑크', 20210405, 4400);


SELECT * FROM emp_test;

INSERT INTO emp_test
(emp_no, emp_name, hire_date, salary)
values
(1015, '커리', '2001-04-23', 6000);

# update 연습
# 호킹의 salary를 10000으로 변경
# 패러데이의 hire_date를 2023-07-11로 변경
# 플랑크가 있는 데이터를 삭제
UPDATE emp_test SET salary = 10000 WHERE emp_no = 1006;
UPDATE emp_test SET hire_date = 20230711 WHERE emp_no = 1007;
DELETE FROM emp_test WHERE emp_no = 1009;


# 오토커밋 옵션 활성화 확인
SELECT @@autocommit;	# 결과가 1이면 오토커밋 활성화 0이면 비활성화
SET autocommit = 0;		# 오토커밋 비활성화
SELECT @@autocommit;

CREATE table emp_tran1 as SELECT * FROM emp_test;
DESC emp_tran1;
DESC emp_test;

ALTER TABLE emp_tran1 add constraint primary key(emp_no);
drop table emp_tran1;
show tables;
rollback;

SELECT * from emp_test;
insert into emp_test values(1011, '플랑크4', 20240405, 5000);
insert into emp_test values(1012, '플랑크5', 20240405, 5000);
insert into emp_test values(1013, '플랑크6', 20240405, 5000);
insert into emp_test values(1014, '플랑크7', 20240405, 5000);
commit;
rollback;