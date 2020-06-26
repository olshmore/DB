-- 1
-- Составьте список пользователей users, которые осуществили
-- хотя бы один заказ orders в интернет магазине.

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
  users (name)
VALUES
  ('Геннадий'),
  ('Ольга'),
  ('Мария'),
  ('Анатолий'),
  ('Роман'),
  ('Ксения');
 
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  order_quantity INT UNSIGNED
) COMMENT = 'Заказы';

INSERT INTO
  orders (user_id, order_quantity)
VALUES
  (1, 1),
  (2, 0),
  (3, 2),
  (4, 0),
  (5, 1),
  (6, 0);
 
SELECT * FROM orders;

SELECT
  id, name
FROM
  users
WHERE
  id IN (SELECT user_id FROM orders WHERE order_quantity > 0);



-- 2
-- Выведите список товаров products и разделов catalogs, который соответствует товару.


DROP TABLE IF EXISTS products;

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  catalog_id INT UNSIGNED
) COMMENT = 'Товары';

INSERT INTO
  products (name, catalog_id)
VALUES
  ('Процессор 1', 1),
  ('Процессор 2', 1),
  ('Мат. плата 1', 2),
  ('Видеокарта 1', 3),
  ('Видеокарта 2', 3),
  ('Память 1', 4);
 
DROP TABLE IF EXISTS catalogs;

CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
) COMMENT = 'Разделы';

INSERT INTO
  catalogs (name)
VALUES
  ('Процессоры'),
  ('Мат. платы'),
  ('Видеокарты'),
  ('Память');

SELECT 
  p.id, p.name,
  c.id AS cat_id,
  c.name AS catalog
FROM
  products AS p
JOIN
  catalogs AS c
ON
  p.catalog_id = c.id;
  
 
-- 3
-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов.
 
DROP TABLE IF EXISTS flights;

CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  flight_from VARCHAR(255),
  flight_to VARCHAR(255)
);

CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255),
  name VARCHAR(255)
);

INSERT INTO
  cities (label, name)
VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');
 
 INSERT INTO
  flights (flight_from, flight_to)
VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');
 
SELECT * FROM flights;
SELECT * FROM cities;

SELECT
  id AS flight_id,
  (SELECT name FROM cities WHERE label = `flight_from`) as `flight_from`,
  (SELECT name FROM cities WHERE label = `flight_to`) as `flight_to`
FROM
  flights 
ORDER BY
  flight_id;


 
