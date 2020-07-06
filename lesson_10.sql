-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы
-- приложения и добавить необходимые индексы.

SELECT * FROM users;

SHOW INDEX FROM users;

-- скорее всего, самой распространенной комбинацией будет имя+фамилия пользователя
SELECT first_name, last_name FROM users;

CREATE INDEX first_name_last_name_idx ON users (first_name, last_name);

-- также частым будет запрос по лайкам, т.к. их необходимо отображать под каждым постом
SELECT * FROM likes;

CREATE INDEX target_id_idx ON likes(target_id);

-- также частым будет запрос по сообщениям
SELECT * FROM messages;

CREATE INDEX messages_from_user_id_to_user_id_idx ON messages (from_user_id, to_user_id);

-- возможно статус юзера будет играть роль при отправке сообщения, а также, возможно, отображаться справа от его имени, тогда:
SELECT * FROM users;

CREATE INDEX status_id_idx ON users (status_id);

-- мне не кажется, что имэйл будет использоваться часто, но оставлю его тут чтобы был пример удаления и создания уникальных индексов)
CREATE INDEX users_email_idx ON users(email);
DROP INDEX users_email_idx ON users;
CREATE UNIQUE INDEX users_email_uq ON users(email);


-- 2. Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

SHOW TABLES;
SELECT * FROM users;
SELECT * FROM communities;
SELECT * FROM communities_users;
SELECT name FROM communities WHERE id = (SELECT DISTINCT id FROM communities_users);
SELECT * FROM users ORDER BY age LIMIT 1;
SELECT * FROM users ORDER BY age DESC LIMIT 1;
SELECT * FROM users;

SELECT DISTINCT communities.name,                                          -- имя группы
  SUM(1) OVER() / SUM(1) OVER() * 5 AS average_in_group,                   -- среднее количество пользователей в группах
  MIN(users.age) OVER(PARTITION BY communities.name) AS youngest,          -- самый молодой пользователь в группе
  MAX(users.age) OVER(PARTITION BY communities.name) AS oldest,            -- самый старший пользователь в группе
  SUM(1) OVER(PARTITION BY communities.name) AS total_in_group,            -- общее количество пользователей в группе 
  SUM(1) OVER() AS users_in_system,                                        -- всего пользователей в системе
  SUM(1) OVER(PARTITION BY communities.name) / SUM(1) OVER() * 100 AS "%%" -- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
    FROM communities_users
      JOIN communities
        ON communities_users.community_id = communities.id
          JOIN users
            ON communities_users.user_id = users.id;
