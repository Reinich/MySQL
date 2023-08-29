/*1. Создайте таблицу users_old, аналогичную таблицу users. Создайте процедуру,
 с помощью которой можно переместить любого (одного) польозвателя из таблицы
 users в таблицу users_old. (использование транзакции с выбором commit/rollback)*/
 Drop table if exists users_old;
 Create table users_old (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE);
    
Start transaction;
Insert into users_old Select * from users Where users.id = 1;
Commit;

/*2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в
зависимости от текущего времени суток. 
С 06:00:00 до 12:00:00 - "Доброе утро",
 с 12:00:00 до 18:00:00 - "Добрый день", 
 с 18:00:00 до 00:00:00 - "Добрый вечер", 
 с 00:00:00 до 06:00:00 - "Доброй ночи"*/
Drop function if exists hello;
DELIMITER //
Create function hello()
Returns varchar(25) READS SQL DATA
BEGIN
set @time := curtime();

if (@time between "06:00:00" and "12:00:00") then 
 set @hello:="Доброе утро";
 elseif (@time between "12:00:01" and "18:00:00") then
 set @hello := "Добрый день";
 elseif (@time between "18:00:01" and "00:00:00") then
 set @hello := "Добрый вечер";
 else
 set @hello:="Доброй ночи";
end if;

RETURN @hello;
END//

DELIMITER ;
SELECT hello() AS hello_time;

/*3. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
communities и messages в таблицу logs помещается время и дата создания записи, название таблицы,
идентификатор первичного ключа*/
Drop table if exists logs;
CREATE TABLE IF NOT EXISTS logs (
   id INT auto_increment primary key,
   created_at DATETIME DEFAULT NOW(),
   name_table varchar(20) NOT NULL   
 ) ENGINE=ARCHIVE DEFAULT CHARSET=utf8mb4;
 
 DELIMITER //
CREATE TRIGGER update_users  AFTER INSERT ON users
FOR EACH ROW BEGIN
   INSERT INTO logs set
   name_table = "users";
END//

 DELIMITER //
CREATE TRIGGER update_communities  AFTER INSERT ON communities
FOR EACH ROW BEGIN
   INSERT INTO logs set
   name_table = "communities";
END//

 DELIMITER //
CREATE TRIGGER update_messages  AFTER INSERT ON messages
FOR EACH ROW BEGIN
   INSERT INTO logs set
   name_table = "messages";
END//
