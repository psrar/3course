create database ZOO;
use zoo;

/* Должности */
create table Positions(
pos_name varchar(80) not null primary key,
min_earnings float not null);

/* Вольеры */
create table Aviaries(
id int identity(1,1) not null primary key,
av_name varchar(80),
av_route varchar(1000),
descr varchar(1000));

create table Animals(
id int identity(1,1) not null primary key,
kind varchar(100) not null,
animal_name varchar(80) not null,
birthdate date not null,
mother int not null
foreign key references Animals(id),
father int not null
foreign key references Animals(id),
aviary int not null
foreign key references aviaries(id));

create table Workers(
id int identity(1,1) not null primary key,
fio varchar(100) not null,
sex varchar(10),
birthdate date not null,
position varchar(80) not null
foreign key references positions(pos_name),
aviary int
foreign key references aviaries(id));

create table Food(
id int not null primary key,
food_name varchar(150) not null,
kitchener int not null
foreign key references workers(id),
composition varchar(1000),
energy int);

create table Eatings(
id int identity(1,1) not null primary key,
eatdatetime datetime not null,
animal int not null
foreign key references animals(id),
food int not null
foreign key references food(id));