CREATE database world;

CREATE TABLE world.country (
	Code varchar(4) not null unique primary key,
    Code2 varchar(4) not null,
    Name varchar(20) not null,
    Continent char(20) not null,
    SurfaceArea int,
    Population int,
    LifeExpectancy decimal(3,1),
    GNP int);
    
INSERT INTO world.country VALUES
	('CHN', 'CHN', '중국', 'Asia', 9572900, 1277558000, 71.4, 982268),
    ('DEU', 'EU', '독일', 'Europe', 357022, 82164700, 77.4, 2133367),
    ('GBR', 'GBR', '영국', 'Europe', 242900, 59623400, 77.7, 1378330),
    ('JPN', 'JPN', '일본', 'Asia', 377829, 126714000, 80.7, 3787042),
    ('USA', 'USA', '미국', 'North America', 9363520, 278357000, 77.1, 8510700);