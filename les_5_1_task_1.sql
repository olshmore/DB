-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

UPDATE users SET created_at = CURRENT_TIMESTAMP WHERE created_at = NULL;
UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE updated_at = NULL;
