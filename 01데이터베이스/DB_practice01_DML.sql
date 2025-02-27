USE titanic;
SHOW tables;
# 데이터 조회 명령 SELECT 컬럼명1, 컬럼명2, * FROM 테이블명;
SELECT * FROM p_info;

# 테이블에서 1개 컬럼만 조회할 때 SELECT 컬럼명1 FROM 테이블명;
SELECT NAME FROM p_info;

# 테이블에서 2개 컬럼만 조회할 때 SELECT 컬럼명1, 컬럼명2 FROM 테이블명;
SELECT NAME, Age FROM p_info;
DESC p_info;

# 테이블에서 데이터를 10개만 조회하고 싶을 때 SELECT * FROM 테이블명 LIMIT 10
SELECT * FROM p_info LIMIT 10;

# 조건에 맞는 데이터 검색하기 WHERE + 비교연산자, 논리연산자
SELECT * FROM p_info WHERE Sex = "male";

# 나이가 40세 이상인 사람만 조회
SELECT * FROM p_info WHERE Age >= 40;

# 조건을 2개 이상 줄 때 논리연산자로 묶음 AND, OR
SELECT * FROM p_info WHERE Sex = "male" AND Age >= 40;

# 20살 이상 50세 미만의 여성을 조회하시오
SELECT * FROM p_info WHERE Sex = "female" AND Age >= 20 AND Age < 50;

# SibSp가 1 이거나 Parch가 1이상인 사람을 조회하시오
SELECT * FROM p_info WHERE SibSp = 1 OR Parch >= 1;

# t_info 테이블에서 Pclass가 1인 승객을 조회하시오
SELECT * FROM t_info WHERE Pclass = 1;

# t_info 테이블에서 Pclass가 2인 또는 Fare가 50초과인 승객을 조회하시오
SELECT * FROM t_info WHERE Pclass = 2 OR Fare > 50;

# survived 테이블에서 Survived가 1인 승객을 조회하시오
SELECT * FROM survived WHERE Survived = 1;

# IN, LIKE, BETWEEN, IS NULL, IN NOT NULL
# p_info 테이블에서 Sibsp 컬럼의 값이 1,2,3인 행을 찾으세요.
SELECT * FROM p_info WHERE Sibsp IN(1,2,3);

# p_info 테이블에서 Sibsp 컬럼의 값이 0,1,2,3이 아닌 행을 찾으세요.
SELECT * FROM p_info WHERE Sibsp NOT IN(0,1,2,3);

# LIKE 문자열 안에서 특정 단어를 포함한 행을 찾을 때. %
SELECT * FROM p_info WHERE name LIKE "R%";
SELECT * FROM p_info WHERE name LIKE "%Eric";

# BETWEEN a AND b, a 이상 b 이하를 찾을 때 (이상, 이하만 가능)
# Age 컬럼의 값이 20 이상 40 이하인 값을 찾는 경우
SELECT * FROM p_info WHERE Age BETWEEN 20 and 40;

# IS NULL, IS NOT NULL
# p_info 테이블에서 Age의 NULL값 찾기
SELECT * FROM p_info WHERE Age IS NULL;

# t_info 테이블에서 Fare가 100이상 1000이하인 승객을 조회하시오
SELECT * FROM t_info WHERE Fare BETWEEN 100 AND 1000;

# t_info 테이블에서 Ticket이 PC로 시작하고 Embarked가 C 혹은 S인 승객을 조회하시오
SELECT * FROM t_info WHERE Ticket LIKE "PC%" AND Embarked IN("C", "S");

# t_info 테이블에서 Pclass가 1 혹은 2인 승객을 조회하시오
SELECT * FROM t_info WHERE Pclass IN(1,2);

# t_info 테이블에서 Cabin에 숫자 59가 포함된 승객을 조회하시오
SELECT * FROM t_info WHERE Cabin LIKE "%59%";

# p_info 테이블에서 Age가 NULL이 아니면서 이름에 James가 포함된 40세 이상의 남성을 조회하시오
SELECT * FROM p_info WHERE NAME LIKE "%James%" AND Age >= 40 AND Sex = "Male";

# 데이터의 순서 정렬하기 ORDER BY
# SELECT * FROM 테이블명 WHERE 컬럼명 + 조건 ORDER BY 기준컬럼 ASC/DESC 오름차순/내림차순;
# p_info 테이블에서 Age가 NULL이 아니면서 이름에 Miss가 포함된 40세 이하의 여성을 조회하고 나이를 기준으로 내림차순 정렬하세요
SELECT * FROM p_info WHERE Age IS NOT NULL AND NAME LIKE "%MISS%" AND Age <= 40 AND Sex = 'Female' ORDER BY Age DESC;

# GROUP BY 특정 컬럼을 기준으로 그룹 연산을 할 때 (평균, 최솟값, 최댓값, 행 갯수)
# SELECT 기준 컬럼명, 그룹연산 함수 FROM 테이블명 WHERE 컬럼명 + 조건 ORDER BY 기준컬럼;
# p_info 테이블에서 나이가 NULL이 아닌 행의 성별별 나이 평균을 구하시오.
# 그룹연산 함수 AVG()_평균, MIN()_최솟값, MAX()_최댓값, COUNT()_행 갯수
SELECT Sex, AVG(Age) FROM p_info WHERE AGE IS NOT NULL GROUP BY Sex; 

# 그룹 연산 후의 결과에서 특정 조건을 충족하는 행을 찾고 싶을 때 having
# t_info 테이블에서 Pclass별 Fare 가격 평균을 구하고 그 중 가격 평균이 50을 초과하는 결과만 조회하시오.
SELECT Pclass, AVG(Fare) FROM t_info GROUP BY Pclass;
SELECT Pclass, AVG(Fare) FROM t_info GROUP BY Pclass HAVING AVG(Fare) > 50;

# INNER JOIN (교집합) 왼쪽, 오른쪽에 있는 테이블에서 기준 컬럼의 값이 일치하는 것만 합침
# SELECT * FROM 테이블1명(왼쪽) INNER JOIN 테이블2명(오른쪽) ON 테이블1명.기준컬럼명 = 테이블2명.기준컬럼명
# passenger 컬럼(왼쪽)과 Ticket 컬럼(오른쪽)을 INNER JOIN 하시오.
SELECT * FROM passenger INNER JOIN Ticket ON passenger.passengerID = Ticket.passengerID;

# LEFT JOIN 왼쪽 데이터에 겹치는 오른쪽 데이터만 추가 (왼쪽 테이블은 유지)
# SELECT * FROM 테이블1명(왼쪽) LEFT JOIN 테이블2명(오른쪽) ON 테이블1명.기준컬럼명 = 테이블2명.기준컬럼명
SELECT * FROM passenger LEFT JOIN Ticket ON passenger.passengerID = Ticket.passengerID;

# RIGHT JOIN 오른쪽 데이터에 겹치는 왼쪽 데이터만 추가 (오른쪽 테이블은 유지)
# SELECT * FROM 테이블1명(왼쪽) RIGHT JOIN 테이블2명(오른쪽) ON 테이블1명.기준컬럼명 = 테이블2명.기준컬럼명
SELECT * FROM passenger RIGHT JOIN Ticket ON passenger.passengerID = Ticket.passengerID;

# 두개의 테이블을 조인 하면서 Name, Age, Pclass, Fare, passengerID 컬럼만 보고 싶을 때
SELECT Name, Age, Pclass, Fare, passengerID FROM passenger INNER JOIN Ticket ON passenger.passengerID = Ticket.passengerID;
# 위의 경우는 출력되지 않으며, 아래와 같이 수정이 필요
SELECT Name, Age, Pclass, Fare, passenger.passengerID FROM passenger INNER JOIN Ticket ON passenger.passengerID = Ticket.passengerID;

# 약칭, 별칭 지정 -> AS를 이용 (생략도 가능)
SELECT Name, Age, Pclass, Fare, p.passengerID FROM passenger AS p INNER JOIN Ticket t ON p.passengerID = T.passengerID;

# 3개의 테이블을 1개로 합치기 ((테이블1 + 테이블2) + 테이블3) + 
SELECT * FROM (passenger P INNER JOIN Ticket T ON P.passengerID = T.passengerID) INNER JOIN survived s ON P.passengerID = S.passengerID;

# 1. passenger, ticket, survived 테이블을 조인하고 Survived가 1인 사람들만 찾아서 Name, Age, Sex, Pclass, survived 컬럼을 출력하시오.
SELECT NAME, Age, Sex, Pclass, survived FROM (passenger P LEFT JOIN Ticket T ON P.passengerID = T.passengerID) LEFT JOIN survived s ON P.passengerID = S.passengerID WHERE survived = 1;

# 2. 1의 결과를 10개만 출력하시오.
SELECT NAME, Age, Sex, Pclass, survived FROM (passenger P LEFT JOIN Ticket T ON P.passengerID = T.passengerID) LEFT JOIN survived s ON P.passengerID = S.passengerID WHERE survived = 1 LIMIT 10;

# 3. Passenger 테이블을 기준 ticket, survived테이블을 LEFT JOIN 한 결과에서 성별이 여성이면서 Pclass가 1인 사람 중 생존자(survived=1)를 찾아 이름, 성별, Pclass를 표시하시오.
SELECT NAME, Sex, Pclass FROM (passenger P LEFT JOIN Ticket T ON P.passengerID = T.passengerID) LEFT JOIN survived s ON P.passengerID = S.passengerID WHERE Pclass = 1 AND survived = 1 AND Sex = 'female';

# 4. passenger, ticket, survived 테이블을 left join 후 나이가 10세 이상 20세 이하 이면서 Pclass 2인 사람 중 생존자를  표시하시오.
SELECT * FROM (passenger P LEFT JOIN Ticket T ON P.passengerID = T.passengerID) LEFT JOIN survived s ON P.passengerID = S.passengerID WHERE Age BETWEEN 10 AND 20 AND Pclass = 2 AND survived = 1;

# 5. passenger, ticket, survived 테이블을 left join 후 성별이 여성 또는 Pclass 가 1인 사람 중 생존자를 표시하시오.
SELECT * FROM (passenger P LEFT JOIN Ticket T ON P.passengerID = T.passengerID) LEFT JOIN survived s ON P.passengerID = S.passengerID WHERE (Pclass = 1 OR Sex = 'female') AND survived = 1 ;

# 6.  passenger, ticket, survived 테이블을 left join 후 생존자 중에서 이름에 Mrs가 포함된 사람을 찾아 이름, Pclass, 나이, Parch, Survived 를 표시하시오.
SELECT NAME, Pclass, Age, Parch, Survived FROM (passenger P LEFT JOIN Ticket T ON P.passengerID = T.passengerID) LEFT JOIN survived s ON P.passengerID = S.passengerID WHERE NAME LIKE "%Mrs%" AND survived = 1;

# 7. passenger, ticket, survived 테이블을 left join 후 Pclass가 1, 2이고 Embarked가 s, c 인 사람중에서 생존자를 찾아 이름, 성별, 나이를 표시하시오.
SELECT NAME, Sex, Age FROM (passenger P LEFT JOIN Ticket T ON P.passengerID = T.passengerID) LEFT JOIN survived s ON P.passengerID = S.passengerID WHERE Pclass IN(1,2) AND Embarked IN('s','c') AND survived = 1;

# 8. passenger, ticket, survived 테이블을 left join 후 이름에 James가 들어간 사람중 생존자를 찾아 이름, 성별, 나이 를 표시하고 나이를 기준으로 내림차순 정렬하시오.
SELECT NAME, Sex, Age FROM (passenger P LEFT JOIN Ticket T ON P.passengerID = T.passengerID) LEFT JOIN survived s ON P.passengerID = S.passengerID WHERE NAME LIKE "%James%" AND survived = 1 ORDER BY Age DESC;

# 9. passenger, ticket, survived 테이블을 INNER JOIN한 데이터에서 성별별, 생존자의 숫자를 구하시오. 생존자 숫자 결과는 별칭을 Total로 하시오.
SELECT Sex, count(survived) as Total FROM (passenger P INNER JOIN Ticket T ON P.passengerID = T.passengerID) INNER JOIN survived s ON P.passengerID = S.passengerID WHERE survived = 1 GROUP BY Sex;

# 10. passenger, ticket, survived 테이블을 INNER JOIN한 데이터에서 성별별, 생존자의 숫자, 생존자 나이의 평균을 구하시오. 생존자 숫자 결과는 별칭을 Total로 하시오.
SELECT Sex, count(survived) as Total, AVG(Age) FROM (passenger P INNER JOIN Ticket T ON P.passengerID = T.passengerID) INNER JOIN survived s ON P.passengerID = S.passengerID WHERE survived = 1 GROUP BY Sex;

# 11. passenger, ticket, survived 테이블을 INNER JOIN한 데이터에서 성별별, pclass별, 생존자별로 pclass, sex, survived , survived의 클래스별 합계, 생존자/사망자의 나이 평균을 구하시오. survived의 별칭은 is_survived로, 생존자 클래스별 합계는 별칭을 survived_total로, 생존자/사망자의 나이 평균은 별칭을 avg_age로 하시오.
SELECT sex, Pclass, survived AS is_survived, count(survived) AS survived_totals, AVG(Age) AS avg_ave FROM (passenger P INNER JOIN Ticket T ON P.passengerID = T.passengerID) INNER JOIN survived s ON P.passengerID = S.passengerID GROUP BY Sex, pclass, survived ORDER BY sex DESC, pclass;

