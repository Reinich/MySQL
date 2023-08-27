/*Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.*/
Select TIMESTAMPDIFF(YEAR, profiles.birthday, curdate()) AS age, count(likes.media_id) as Likes From media
 join profiles on media.user_id = profiles.user_id
 join likes on likes.media_id = media.id
 group by age
 having age < 12;
 
 /*Определить кто больше поставил лайков (всего): мужчины или женщины*/ 
 Select gender, count(likes.media_id) as Likes from likes
 join profiles on likes.user_id = profiles.user_id
 group by gender
 order by Likes desc
 limit 1;
 
 
 /*Вывести всех пользователей, которые не отправляли сообщения*/
 select users.id from users
 left join messages on users.id = messages.from_user_id
 where messages.from_user_id is null
 group by users.id;


 /*Некоторый пользователь = 1. Из всех друзей этого пользователя найдите человека, который больше всех написал ему сообщений*/
 select initiator_user_id as Id_friends, count(*) as Messages
 from friend_requests
 join messages on initiator_user_id = messages.from_user_id
 where target_user_id = 1 and status = 'approved'
 group by Id_friends
 union 
 select target_user_id, count(*) as Messages
 from friend_requests 
 where friend_requests.status = 'approved'
 group by target_user_id
 order by Messages desc
 limit 1;
 
