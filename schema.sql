create table users(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username varchar(100) NOT NULL,
    email varchar(100),
    password varchar(100) NOT NULL
);

create table departments(
    dept_id int not null AUTO_INCREMENT PRIMARY KEY,
    dept_name varchar(100)
);

create table leaders (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    department_id int not null,
    FOREIGN KEY (department_id) REFERENCES departments(dept_id)
);

select id, first_name, last_name, dept_name from leaders join departments on leaders.department_id = departments.dept_id;

create table votes(
    user_id int not null,
    leader_id int not null,
    FOREIGN KEY (leader_id) REFERENCES leaders(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);


create table admins(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username varchar(100) NOT NULL,
    email varchar(100),
    password varchar(100) NOT NULL
);


show triggers;
select * from votes;

-- Trigger
DELIMITER //
CREATE TRIGGER Before_Insert_Votes
BEFORE INSERT ON votes
FOR EACH ROW
BEGIN
  IF (EXISTS(SELECT * FROM votes WHERE user_id = NEW.user_id)) THEN
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'User has already voted';
  END IF;
END //
DELIMITER ;

drop trigger Before_Insert_Votes;
--Trigger end

--Trigger test
delete from votes;
select * from votes;
insert into votes(user_id, leader_id) values(2, 4); --Interrupt
insert into votes(user_id, leader_id) values(9, 5); 
--End Trigger Test


select * from votes join users on votes.user_id = users.id;


select username, first_name from (select * from votes join users on votes.user_id = users.id) as A join leaders on A.leader_id = leaders.id;


--STORED PROCEDURE--
DELIMITER //
CREATE PROCEDURE getVoteDetails()
BEGIN
    select username, first_name from (select * from votes join users on votes.user_id = users.id) as A join leaders on A.leader_id = leaders.id;
END //
DELIMITER ;
----END---


--TESTING STORED PROCEDURES--
show create procedure getVoteDetails;
CALL getVoteDetails();
--END--



--STORED PROCEDURE END--


select * from departments;

insert into departments(dept_name) values('CSE');
insert into departments(dept_name) values('ISE');
insert into departments(dept_name) values('ECE');

select * from leaders;

insert into leaders (first_name, last_name, department_id) values ('Lurlene', 'Ewbanck', 1);
insert into leaders (first_name, last_name, department_id) values ('Joelly', 'Northedge', 2);
insert into leaders (first_name, last_name, department_id) values ('Neely', 'Rentoll', 3);
insert into leaders (first_name, last_name, department_id) values ('Kyrstin', 'Dannehl', 2);
insert into leaders (first_name, last_name, department_id) values ('Delora', 'Carlesso', 1);

drop table votes;

insert into admins (id, username, email, password) values (1, 'hmacelroy0', 'vlittleproud0@cdc.gov', 'aWmvMSfEsIhL');
insert into admins (id, username, email, password) values (2, 'sgiamo1', 'breston1@rambler.ru', 'nU9Kq7s');
insert into admins (id, username, email, password) values (3, 'aelgey2', 'egilley2@huffingtonpost.com', 'bB4Oty4');
insert into admins (id, username, email, password) values (4, 'chandrashekarvt', 'chandrashekarvt761@gmail.com', '12345');



select exists(select * from users where username = 'chandrashekarvt' and password = 'abcdefg');

drop table admins;

insert into votes (user_id, leader_id) values (6, 4);
insert into votes (user_id, leader_id) values (3, 4);
insert into votes (user_id, leader_id) values (5, 5);
insert into votes (user_id, leader_id) values (2, 3);
insert into votes (user_id, leader_id) values (11, 3);


select * from votes;





select * from users;

delete from users;

insert into users (username, email, password) values ('Fernando', 'fgueny0@abc.net.au', 't1alohDz3IP');
insert into users (username, email, password) values ('Guilbert', 'gbouch1@bbc.co.uk', '036T3dzdHJH');
insert into users (username, email, password) values ('Clementia', 'cthames2@blog.com', 'mmKhlo5px7');
insert into users (username, email, password) values ('Rudolf', 'ransill3@webnode.com', 'kJKVXG4Eo');
insert into users (username, email, password) values ('Kurtis', 'kgallahar4@ask.com', 'IzHbQ6');
insert into users (username, email, password) values ('Craggie', 'cdinneen5@techcrunch.com', 'Bc1bHqL');
insert into users (username, email, password) values ('Jefferson', 'jinchbald6@google.ca', 'EPnODX7tY7B');
insert into users (username, email, password) values ('Monroe', 'mbrussell7@uiuc.edu', 'JXgM1pT5j');
insert into users (username, email, password) values ('Julia', 'jpischof8@newyorker.com', 'hHGEbibEz');
insert into users (username, email, password) values ('Brice', 'bkosiada9@hao123.com', '4ERysR');


select * from votes;
select * from leaders;