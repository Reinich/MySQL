/*1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия,
город и пол), которые не старше 20 лет*/
Create view younger as 
Select firstname, lastname, gender, hometown
From users, profiles
Where TIMESTAMPDIFF(YEAR, profiles.birthday, curdate()) <= 20;

Select * from younger;

/*2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите
ранжированный список пользователей, указав имя и фамилию пользователя, количество
отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным
количеством сообщений) . (используйте DENSE_RANK)*/
Select users.id, firstname, lastname, count(from_user_id) as count_messages,
Dense_rank()
OVER (Order by count(from_user_id) DESC) as rank_messages
From users
Join messages on users.id = messages.from_user_id
Group by users.id;

/*3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления
(created_at) и найдите разницу дат отправления между соседними сообщениями, получившегося
списка. (используйте LEAD или LAG)*/
Select id, body, created_at, TIMESTAMPDIFF(MINUTE, messages.created_at, 
	(LEAD(created_at, 1, 0) OVER(Order by created_at))) as Times_Diff
From messages
Order by created_at;
