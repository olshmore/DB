-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

ALTER TABLE users add dow DATETIME DEFAULT CURRENT_TIMESTAMP AFTER age;

CREATE TABLE new_users
SELECT *
FROM users;


SELECT SUBSTRING(created_at, 6, 6) FROM users;
--возвращает -месяц-день


UPDATE new_users SET dow = CONCAT(
  '2020-',
  (SELECT SUBSTRING(created_at, 6, 6) FROM users)
);
--должна бы возвращать год-месяц-день, но не работает
--вначале выдавал ошибку, пришлось скопировать таблицу


--далее было бы так, если бы сработал CONCAT: 
SELECT DAYOFWEEK(dow) FROM users;
SELECT COUNT(*), DAYOFWEEK(dow) as dayweek FROM users GROUP BY dayweek;
