-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

CREATE TABLE users
    (`created_at` varchar(20))
;

INSERT INTO users
    (`created_at`)
VALUES
    ("06.01.2020 8:10"),
    ("07.01.2020 8:10"),
    ("08.01.2020 8:10"),
    ("09.01.2020 8:10")
    
SELECT STR_TO_DATE(created_at, "%d.%m.%Y %k:%i") FROM users;

UPDATE users SET created_at = STR_TO_DATE(created_at, "%d.%m.%Y %k:%i");
