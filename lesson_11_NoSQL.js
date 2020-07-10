// 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

SADD ip '127.0.0.1' '127.0.0.2' '127.0.0.3'

SADD ip '127.0.0.1' 

SMEMBERS ip

SCARD ip


// 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу
// и наоброт, поиск электронного адреса пользователя по его имени.

set alex@mail.ru alex 
set alex alex@mail.ru

get alex@mail.ru 
get alex 


// 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

use products
db.products.insert({"name": "Intel Core i3-8100", "description": "Процессор для настольных ПК", "price": "8000.00", "catalog_id": "Процессоры", "created_at": new Date(), "updated_at": new Date()}) 

db.products.insertMany([
	{"name": "AMD FX-8320", "description": "Процессор", "price": "9000.00", "catalog_id": "Процессоры", "created_at": new Date(), "updated_at": new Date()},
	{"name": "AMD FX-6570", "description": "Процессор", "price": "10000.00", "catalog_id": "Процессоры", "created_at": new Date(), "updated_at": new Date()}])

db.products.find().pretty()
db.products.find({name: "AMD FX-8320"}).pretty()


use catalogs
db.catalogs.insertMany([{"name": "Процессоры"}, {"name": "Видеокарты"}])
