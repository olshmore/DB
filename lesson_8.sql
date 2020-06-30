-- Переписать запросы, заданые к ДЗ урока 6 с использованием JOIN

-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

/*
SELECT
  (SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender
  FROM likes;
 
SELECT
  (SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender,
  COUNT(*) AS total
  FROM likes
  GROUP BY gender 
  ORDER BY total DESC
  LIMIT 1;
*/
 
SELECT gender FROM profiles p JOIN likes l ON p.user_id = l.user_id;

SELECT gender, COUNT(*) AS total
  FROM profiles p
    JOIN likes l
  ON p.user_id = l.user_id
  GROUP BY gender 
  ORDER BY total DESC
  LIMIT 1;
 

-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям
--    (сколько лайков получили 10 самых молодых пользователей).
/*
SELECT * FROM target_types;
SELECT * FROM profiles ORDER BY birthday DESC LIMIT 10;

SELECT 
  (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) AS likes_total
  FROM profiles
  ORDER BY birthday 
  DESC LIMIT 10;
 
 SELECT SUM(likes_total) FROM 
 (SELECT
  (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) AS likes_total
  FROM profiles
  ORDER BY birthday 
  DESC LIMIT 10) AS user_likes;
*/

SELECT * FROM likes;
SELECT * FROM profiles;
SELECT * FROM likes JOIN profiles ON likes.target_id = profiles.user_id AND target_type_id = 2;
 
SELECT COUNT(*) AS likes_total
  FROM profiles JOIN likes ON likes.target_id = profiles.user_id AND target_type_id = 2
    WHERE target_id IN (SELECT id FROM (SELECT * FROM users ORDER BY age LIMIT 10) t ORDER BY id);

 
 -- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
 
 SELECT 
   CONCAT(first_name, ' ',last_name) AS user,
     (SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id) +
     (SELECT COUNT(*) FROM media WHERE media.user_id = users.id) +
     (SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) AS overall_activity
       FROM users
       ORDER BY overall_activity 
       LIMIT 10;
      
SELECT (SELECT COUNT(*) FROM likes WHERE likes.target_id = users.id) FROM users;

SELECT (SELECT COUNT(*) FROM likes l JOIN users u ON l.user_id = u.id) FROM users;

SELECT * FROM likes l JOIN users u ON l.target_id = u.id;

 -- 
SELECT DISTINCT CONCAT(first_name, ' ',last_name) AS user
FROM users u
  JOIN likes l ON (l.target_id = u.id)
  JOIN media m ON (m.user_id = u.id )
  JOIN messages m2 ON (m2.from_user_id = u.id);
  
SELECT DISTINCT u.id, CONCAT(first_name, ' ',last_name) AS user
  FROM users u
    JOIN likes l ON (l.target_id = u.id);
  
SELECT DISTINCT u.id, CONCAT(first_name, ' ',last_name) AS user
  FROM users u
    JOIN media m ON (m.user_id = u.id );
