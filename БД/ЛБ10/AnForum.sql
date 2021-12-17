create database AnForum;
use anforum;

create table Usr(
id int auto_increment,
username varchar(200) unique not null,
passhash varchar(512) not null,
rights varchar(10) not null default '100100100',
#Слева направо:
#0 символ- Просмотр пользователей
#1-Редактирование пользователей
#2-Удаление пользователей
#3-Просмотр категорий
#4-Редактирование категорий
#5-Удаление категорий
#6-Создание постов (просматривать посты могут все пользователи)
#7-Редактирование постов
#8-Удаление постов
descr varchar(200),
primary key (id)
);

create table Category(
c_name varchar(60) not null,
iconPath varchar(150) not null,
primary key (c_name)
);

create table Post(
id int auto_increment,
author int not null,
category varchar(50),
title varchar(200) not null,
content text,
primary key(id),
foreign key (author) references Usr(id),
foreign key (category) references Category(c_name)
);

insert into usr(username, passhash, rights, descr)
values('psrar', '25d55ad283aa400af464c76d713c07ad', '101111111', 'Я ваш отец'),
('sashkaool', '5e8667a439c68f5145dd2fcbecf02209', '100100100', 'Ненавижу феминитивы');

insert into category
values('Игры', 'path/to/icon'),
('Технологии', 'path/to/icon'),
('Аниме', 'path/to/icon');

select * from usr where username = 'psrar';