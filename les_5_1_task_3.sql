-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
    storehouse_id int unsigned,
    product_id int unsigned,
    value int unsigned comment 'Запас товарной позиции на складе',
    created_at DATETIME default current_timestamp COMMENT 'Дата регистрации',
    updated_at DATETIME default current_timestamp ON UPDATE current_timestamp COMMENT 'Дата последнего обновления записи'
) COMMENT = 'Склады и продукты';

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
  (1, 1, 0),
    (1, 2, 4),
    (1, 3, 0),
    (2, 4, 7),
    (2, 5, 56),
    (1, 6, 0),
    (1, 7, 4);
    
SELECT * FROM storehouses_products;

SELECT 0 AS line, * FROM storehouses_products WHERE value > 0
UNION 
SELECT 1 AS line, * FROM storehouses_products WHERE value < 1
ORDER BY line, value
