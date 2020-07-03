-- “Транзакции, переменные, представления”

-- 1 В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
SHOW DATABASES;

DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
use shop;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  birthday_at DATE DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT users (id, name, birthday_at)
VALUES
  (1, 'Jake', '1992-10-09'),
  (2, 'Mary', '1992-10-09'),
  (3, 'Sam', '1992-10-09');
 
SELECT * FROM users;


DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
use sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  birthday_at DATE DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM users;

START TRANSACTION;

INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;

COMMIT;

SELECT * FROM users;

-- 2 Создайте представление, которое выводит название name товарной позиции из
-- таблицы products и соответствующее название каталога name из таблицы catalogs.
use test;

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

CREATE OR REPLACE VIEW products_new(product_id, product_name, catalogue_name) AS
SELECT p.id AS product_id, p.name, c.name
FROM products AS p
LEFT JOIN catalogs AS c
ON p.catalog_id = c.id;

SELECT * FROM products_new;
