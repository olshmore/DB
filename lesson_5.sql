-- 
-- 5.1 Операторы, фильтрация, сортировка и ограничение
-- 

-- 1) Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  birthday_at DATE,
  created_at DATETIME,
  updated_at DATETIME
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', NULL, NULL),
  ('Ольга', '1984-11-12', NULL, NULL),
  ('Мария', '1980-11-06', NULL, NULL),
  ('Анатолий', '1999-10-20', NULL, NULL),
  ('Роман', '1994-01-12', NULL, NULL),
  ('Ксения', '2000-10-06', NULL, NULL);
 
SELECT * FROM users;
 
UPDATE
	users
SET
	created_at = NOW(),
	updated_at = NOW();




-- 2) Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  birthday_at DATE,
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '12.01.2017 8:56', '12.01.2017 8:56'),
  ('Ольга', '1984-11-12', '12.01.2017 8:56', '12.01.2017 8:56'),
  ('Мария', '1980-11-06', '12.01.2017 8:56', '12.01.2017 8:56'),
  ('Анатолий', '1999-10-20', '12.01.2017 8:56', '12.01.2017 8:56'),
  ('Роман', '1994-01-12', '12.01.2017 8:56', '12.01.2017 8:56'),
  ('Ксения', '2000-10-06', '12.01.2017 8:56', '12.01.2017 8:56');
 
SELECT * FROM users;

UPDATE
  users
SET
  created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
  updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');
 
ALTER TABLE
  users
CHANGE
  created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
 
ALTER TABLE
  users
CHANGE
  updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
 
 DESCRIBE users;




-- 3) В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

DROP TABLE IF EXISTS storehouse_products;
CREATE TABLE storehouse_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

SELECT * FROM storehouse_products;

INSERT INTO
  storehouse_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 5454, 0),
  (1, 854, 30),
  (1, 737,500);

SELECT 
  *
FROM
  storehouse_products
ORDER BY 
  IF (value > 0, 0, 1),
  value;
 
 -- так работает
SELECT
IF (value > 0, 0, 1),
  value
FROM
  storehouse_products;
 
 
-- другой способ
SELECT 
  *
FROM
  storehouse_products
ORDER BY 
  value = 0, value;
 -- получаем 1 если value=1, 0 если не равно
 
 
 
 
-- 4) (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

SELECT name FROM users WHERE DATE_FORMAT(birthday_at, '%M') in ('may', 'august');




-- 5) (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 
SELECT * FROM catalogs;

SELECT
  *
FROM
  catalogs
WHERE
  id IN (5, 1, 2)
ORDER BY
  FIELD(id, 5, 1, 2);
 
 
--  
-- 5.2 Агрегация данных
-- 

 
-- 1) Подсчитайте средний возраст пользователей в таблице users.

 SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) as age FROM users;




-- 2) Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT 
  DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at) )), '%W') AS day,
  COUNT(*) AS total
FROM
  users
GROUP BY
  day
ORDER BY
  total DESC;
 
 

 
-- 3) (по желанию) Подсчитайте произведение чисел в столбце таблицы.

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 
SELECT * FROM catalogs;

SELECT ROUND(EXP(SUM(LN(id)))) FROM catalogs;
