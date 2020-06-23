-- 2 Создать и заполнить таблицы лайков и постов.

-- Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;

-- Проверим
SELECT * FROM likes LIMIT 10;

-- Создадим таблицу постов
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  views_counter INT UNSIGNED DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



-- 1 Добавляем внешние ключи в БД vk

USE vk;

DESC profiles;
SELECT * FROM profiles;
DESC users;
DESC media;
SELECT * FROM media;

UPDATE profiles SET photo_id = FLOOR(1 + RAND() * 20);


-- Добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;

     
          
DESC users;
ALTER TABLE users
  ADD CONSTRAINT users_status_id_fk 
    FOREIGN KEY (status_id) REFERENCES user_statuses(id)
      ON DELETE SET NULL;
      
-- Для таблицы сообщений

-- Смотрим структурв таблицы
DESC messages;

-- Добавляем внешние ключи
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);

SHOW TABLES;



-- Для таблицы сообществ

DESC communities_users;

ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT communities_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE SET NULL;

     
   
-- Для таблицы медиа 
DESC media;

ALTER TABLE media
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ;
     
   
-- Для таблицы постов 
DESC posts;

ALTER TABLE posts
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE SET NULL;
   
     
     
-- Для таблицы лайков 
DESC likes;
DESC target_types;

ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ,
  ADD CONSTRAINT likes_target_type_id_fk 
    FOREIGN KEY (target_type_id) REFERENCES target_types(id)
      ;
   

 
-- Для таблицы дружбы

DESC friendship;
SELECT * FROM friendship;

ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ,
  ADD CONSTRAINT friendship_friend_id_fk
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ,
  ADD CONSTRAINT friendship_status_id_fk
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
      ;
     
  -- Для таблиц likes и friendship отказывался работать, пока не удалила ON DELETE SET NULL; В чем может быть дело?
  

     
  -- 3) Определить кто больше поставил лайков (всего) - мужчины или женщины?
  
DESC likes;
DESC profiles;

SELECT * FROM likes;

 
-- у меня в базе 3 пола  - Male, Female & Other.
SELECT 
  (SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender,
  COUNT(*) AS total
FROM
  likes
GROUP BY
  gender
ORDER BY
  total DESC;
 

 
 -- 4) Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
SELECT * FROM likes;
SELECT * FROM users;

SELECT * FROM users ORDER BY age LIMIT 10;

SELECT id FROM (SELECT * FROM users ORDER BY age LIMIT 10) t ORDER BY id;

SELECT * FROM likes WHERE id IN (SELECT id FROM (SELECT * FROM users ORDER BY age LIMIT 10) t ORDER BY id);
