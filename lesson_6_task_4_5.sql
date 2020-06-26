
-- 4) Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
SELECT * FROM likes;
SELECT * FROM users;

SELECT * FROM users ORDER BY age LIMIT 10;

SELECT id FROM (SELECT * FROM users ORDER BY age LIMIT 10) t ORDER BY id;

SELECT
  COUNT(*) AS total
FROM
  likes
WHERE
  target_id IN (SELECT id FROM (SELECT * FROM users ORDER BY age LIMIT 10) t ORDER BY id);
 

 
-- 5) Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети

-- Выбранный критерий - наименьшее количество поставленных лайков + наименьшее количество друзей

SELECT * FROM likes;
SELECT * FROM users;
SELECT * FROM friendship;
SELECT * FROM friendship_statuses fs ;
-- Requested 1 ,  Rejected 3

-- SELECT DISTINCT user_id from likes;

SELECT id from likes WHERE id NOT IN (SELECT DISTINCT user_id from likes);
-- Эти 38 пользователей никому не поставили лайки


SELECT user_id FROM friendship WHERE user_id NOT IN (SELECT user_id FROM friendship WHERE status_id = 2);
-- У 45 пользователей нет подтвержденной дружбы


SELECT *, COUNT(*) FROM (
SELECT id from likes WHERE id NOT IN (SELECT DISTINCT user_id from likes)
  UNION ALL
SELECT user_id FROM friendship WHERE user_id NOT IN (SELECT user_id FROM friendship WHERE status_id = 2)
) AS smyh
GROUP BY id
HAVING COUNT(*) > 1;
-- пересечение групп пользователей, не ставящей лайки и не имеющей подтвержденной дружбы

SELECT * FROM (
SELECT id from likes WHERE id NOT IN (SELECT DISTINCT user_id from likes)
  UNION ALL
SELECT user_id FROM friendship WHERE user_id NOT IN (SELECT user_id FROM friendship WHERE status_id = 2)
) AS smyh
GROUP BY id
HAVING COUNT(*) > 1 LIMIT 10;
-- 10 пользователей, которые проявляют наименьшую активность
