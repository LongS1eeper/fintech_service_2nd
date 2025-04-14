CREATE database world;

CREATE TABLE world.exchange_rate (
	code2 varchar(4) not null unique primary key,
    country_name varchar(20),
    Currency_Name varchar(20),
    Exchange_rate decimal(6,2),
    Cash_Buying decimal(6,2),
    Cash_Selling decimal(6,2),
    Remit_Sending decimal(6,2),
    Remit_Receiving decimal(6,2),
    USD_Conv_Rate decimal(4,3),
    date datetime not null);
    
INSERT INTO world.exchange_rate VALUES
	('USA', '미국', 'USD', 1377, 1401.09, 1352.91, 1390.4, 1363.6, 1, 20240713),
	('EU', '유럽연합', 'EUR', 1501.55, 1531.43, 1471.67, 1516.56, 1486.54, 1.091, 20240713),
	('JPN', '일본', 'JPY (100엔)', 872.07, 887.33, 856.81, 880.61, 863.53, 0.633, 20240713),
	('CHN', '중국', 'CNY', 189.37, 198.83, 179.91, 191.26, 187.48, 0.138, 20240713),
	('GBR', '영국', 'GBP', 1788.1, 1823.32, 1752.88, 1805.98, 1770.22, 1.299, 20240713);
    
SELECT * FROM world.exchange_rate