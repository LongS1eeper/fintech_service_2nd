# view 뷰
# select로 조회한 내용을 테이블을 만드는 것처럼 저장하는 것
# 읽기 전용
# CREATE VIEW 뷰이름 AS SELECT문
# DROP VIEW 뷰이름

USE korea_exchange_rate;
SELECT * FROM exchange_rate;

# Q1. view 생성
# 1997년 1월 1일부터 2001년 12월 31일까지 환율변동 조회
# 통화별로 현찰_살때_환율, 현찰_팔때_환율의 
# MIN() 살때최저환율, MAX() 살때최고환율, AVG() 살때평균환율
# MAX() - MIN() 살때환율변동량
# MIN() 팔때최저환율, MAX() 팔때최고환율, AVG() 팔때평균환율
# MAX() - MIN() 팔때환율변동량
CREATE VIEW exchange_rate_1997_2001 AS
SELECT 통화, 
	MIN(현찰_살때_환율) 살때최저환율, 
    MAX(현찰_살때_환율) 살때최고환율, 
    round(AVG(현찰_살때_환율),2) 살때평균환율, 
    round(MAX(현찰_살때_환율) - MIN(현찰_살때_환율),2) 살때환율변동량,
	MIN(현찰_팔때_환율) 팔때최저환율, 
    MAX(현찰_팔때_환율) 팔때최고환율, 
    round(AVG(현찰_팔때_환율),2) 팔때평균환율, 
    round(MAX(현찰_팔때_환율) - MIN(현찰_팔때_환율),2) 팔때환율변동량
FROM exchange_rate 
WHERE date BETWEEN '1997-01-01' AND '2001-12-31'
GROUP BY 통화;

# VIEW 읽기
SELECT * FROM exchange_rate_1997_2001 WHERE 통화='미국 USD';
UPDATE exchange_rate_1997_2001 SET 통화 = '미국 USD' WHERE; 


# 실습과제
USE academic_management;
show tables;

SELECT * FROM department;
INSERT into department values
	(1, '수학'),
	(2, '국문학'),
    (3, '정보통신공학'),
    (4, '모바일공학');
    
SELECT * FROM student;
INSERT into student values
	(1, '가길동', 177, 1),
    (2, '나길동', 178, 1),
    (3, '다길동', 179, 1),
    (4, '라길동', 180, 2),
    (5, '마길동', 170, 2),
    (6, '바길동', 172, 3),
    (7, '사길동', 166, 4),
    (8, '아길동', 192, 4);

SELECT * FROM professor;
INSERT INTO professor values
	(1, '가교수', 1),
    (2, '나교수', 2),
    (3, '다교수', 3),
    (4, '빌게이츠', 4),
    (5, '스티브잡스', 3);
    
SELECT * FROM course;
INSERT INTO course values
	(1, '교양영어', 1, 20160902, 20161130),
	(2, '데이터베이스 입문', 3, 20160820, 20161030),
	(3, '회로이론', 2, 20161020, 20161230),
	(4, '공업수학', 4, 20161102, 20170128),
	(5, '객체지향프로그래밍', 3, 20161101, 20170130);
    
ALTER table course drop column Coursecol;	# 오류 수정

SELECT * FROM student_course;
INSERT INTO student_course VALUES
	(1, 1),
    (2, 1),
    (3, 2),
    (4, 3),
    (5, 4),
    (6, 5),
    (7, 5);

truncate table student_course;

# 문제 1: 학생번호, 학생명, 키높이, 학과번호, 학과명 정보를 출력합니다.
SELECT S.student_id, S.student_name, S.height, S.department_id, D.department_name
FROM Student S LEFT JOIN Department D ON S.department_id = D.department_id;

# 문제 2: '가교수' 교수의 교수아이디를 출력하세요.
SELECT professor_id
FROM Professor
WHERE professor_name = '가교수';

# 문제 3: 학과이름별 교수의 수를 출력하세요.
SELECT department_name, count(p.professor_id)
FROM Department D LEFT JOIN Professor P ON D.department_id = P.department_id
GROUP BY department_name;

# 문제 4: '정보통신공학'과의 학생정보를 출력하세요.
SELECT S.student_id, S.student_name, S.height, S.department_id, D.department_name
FROM Student S LEFT JOIN Department D ON S.department_id = D.department_id
WHERE department_name = '정보통신공학';

# 문제 5: '정보통신공학'과의 교수명을 출력하세요.
SELECT P.professor_id, P.professor_name, D.department_id, D.department_name
FROM Professor P INNER JOIN Department D ON P.department_id = D.department_id
WHERE department_name = '정보통신공학';

# 문제 6: 학생 중 성이 '아'인 학생이 속한 학과명과 학생명을 출력하세요.
SELECT S.student_name, D.department_name
FROM Student S LEFT JOIN Department D ON S.department_id = D.department_id
WHERE S.student_name LIKE "아%";

# 문제 7: 키가 180~190 사이에 속하는 학생 수를 출력하세요.
SELECT count(student_id)
FROM Student
WHERE height BETWEEN 180 AND 190;

# 문제 8: 학과이름별 키의 최고값, 평균값을 출력하세요.
SELECT D.department_name, max(s.height), round(avg(s.height))
FROM Student S LEFT JOIN Department D ON S.department_id = D.department_id
GROUP BY D.department_id;

# 문제 9: '다길동' 학생과 같은 학과에 속한 학생의 이름을 출력하세요.
SELECT student_name
FROM student
WHERE department_id = (SELECT department_id FROM student WHERE student_name = '다길동');

# 문제 10: 2016년 11월 시작하는 과목을 수강하는 학생의 이름과 수강과목을 출력하세요.
SELECT student_name, course_name
FROM (Student S LEFT JOIN Student_course SC ON S.student_id = SC.student_id) LEFT JOIN Course C ON SC.course_id = C.course_id
WHERE C.start_date BETWEEN 20161101 AND 20161130;

SELECT student_name, C.course_name
FROM Student S LEFT JOIN Student_course SC ON S.student_id = SC.student_id, Course C
WHERE SC.course_id = (SELECT course_id FROM Course C WHERE start_date >= 20161101);

# 문제 11: '데이터베이스 입문' 과목을 수강신청한 학생의 이름은?
# 1안
SELECT S.student_name
FROM (Student S LEFT JOIN Student_course SC ON S.student_id = SC.student_id) LEFT JOIN Course C ON SC.course_id = C.course_id
WHERE C.course_name = '데이터베이스 입문';
# 2안
SELECT S.student_name
FROM Student S LEFT JOIN Student_course SC ON S.student_id = SC.student_id
WHERE SC.course_id = (SELECT C.course_id FROM course C WHERE C.course_name = '데이터베이스 입문');

# 문제 12: '빌게이츠' 교수의 과목을 수강신청한 학생수는?
SELECT count(S.student_id)
FROM Student S LEFT JOIN Student_course SC ON S.student_id = SC.student_id, Professor P LEFT JOIN Course C ON P.professor_id = C.professor_id
WHERE P.professor_name = '빌게이츠' AND SC.course_id = C.course_id;

SELECT count(S.student_id)
FROM Student S LEFT JOIN Student_course SC ON S.student_id = SC.student_id
WHERE SC.course_id = (SELECT C.course_id FROM Professor P LEFT JOIN Course C ON P.professor_id = C.professor_id WHERE P.professor_name = '빌게이츠');