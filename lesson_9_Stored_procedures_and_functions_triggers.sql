-- “Хранимые процедуры и функции, триггеры"

-- 1 Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток.
-- С 6:00 до 12:00 функция должна возвращатьфразу "Доброе утро",
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP PROCEDURE IF EXISTS hello;

DELIMITER //

CREATE PROCEDURE hello()
BEGIN
	IF(CURTIME() BETWEEN '06:00:00' AND '12:00:00') THEN
		SELECT 'Доброе утро';
	ELSEIF(CURTIME() BETWEEN '12:00:00' AND '18:00:00') THEN
		SELECT 'Добрый день';
	ELSEIF(CURTIME() BETWEEN '18:00:00' AND '00:00:00') THEN
		SELECT 'Добрый вечер';
	ELSE
		SELECT 'Доброй ночи';
	END IF;
END //

DELIMITER ;

CALL hello();

-- 2 В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают
-- неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно
-- из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER IF EXISTS nullTrigger;

DELIMITER //

CREATE TRIGGER nullTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger Warning! NULL in both fields!';
	END IF;
END //

DELIMITER ;

INSERT INTO products (name, description, price, catalog_id)
  VALUES (NULL, NULL, 5000, 2);

INSERT INTO products (name, description, price, catalog_id)
  VALUES ("GeForce GTX 1080", NULL, 15000, 12);

INSERT INTO products (name, description, price, catalog_id)
  VALUES ("GeForce GTX 1080", "Мощная видеокарта", 15000, 12);

DROP TRIGGER IF EXISTS nullTrigger;

DELIMITER //

CREATE TRIGGER nullTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name)) THEN
		SET NEW.name = 'NoName';
	END IF;
	IF(ISNULL(NEW.description)) THEN
		SET NEW.description = 'No Desc';
	END IF;
END //

DELIMITER ;

INSERT INTO products (name, description, price, catalog_id)
  VALUES (NULL, NULL, 20000, 12);
