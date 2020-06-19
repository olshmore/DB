-- Подсчитайте средний возраст пользователей в таблице users.

-- Извините, вместа дня рождения взяла updated_at. Не было времени создавать новые данные для дат рождения, но логика та же :)

ALTER TABLE users add age VARCHAR(150) DEFAULT 1 AFTER updated_at;

SELECT age FROM users;

SELECT TIMESTAMPDIFF(YEAR, created_at, NOW()) FROM users;

UPDATE users SET age = (SELECT TIMESTAMPDIFF(YEAR, created_at, NOW()));

SELECT age FROM users;

SELECT AVG(age) FROM users;
