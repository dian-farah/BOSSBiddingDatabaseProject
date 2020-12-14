#create tables
CREATE DATABASE G2T10;
use G2T10;

create table school
(sch_name varchar(50) not null primary key,
address varchar(100) not null,
url varchar(60) not null);

create table round
(rid int not null primary key,
start_datetime datetime not null,
end_datetime datetime not null);

create table programme
(pid varchar(10) not null primary key,
prog_name varchar(80) not null,
hmsch_name varchar(50) not null,
secsch_name varchar(50),
constraint programme_fk1 foreign key(hmsch_name) references school(sch_name),
constraint programme_fk2 foreign key(secsch_name) references school(sch_name));

create table student
(sid varchar(10) not null primary key,
stu_name varchar(80) not null,
email varchar(50) not null,
init_edollars decimal(5,2) not null,
type varchar(2) not null,
pid varchar(10) not null,
constraint student_fk foreign key(pid) references programme(pid));

create table double_degree
(sid varchar(10) not null,
gpa decimal(3,2) not null,
pid varchar(10) not null,
constraint double_degree_pk primary key(sid),
constraint double_degree_fk1 foreign key(sid) references student(sid),
constraint double_degree_fk2 foreign key(pid) references programme(pid));

create table second_major
(sid varchar(10) not null,
sch_name varchar(50) not null,
date_declared date not null,
constraint second_major_pk primary key(sid),
constraint second_major_fk1 foreign key(sid) references student(sid),
constraint second_major_fk2 foreign key(sch_name) references school(sch_name));

create table course
(cid varchar(10) not null primary key,
title varchar(80) not null,
pid varchar(10) not null,
constraint course_fk foreign key(pid) references programme(pid));

create table programme_courses
(pid varchar(10) not null,
cid varchar(10) not null,
is_core char(1) not null,
rid int not null,
constraint programme_courses_pk primary key(pid, cid),
constraint programme_courses_fk1 foreign key(pid) references programme(pid),
constraint programme_courses_fk2 foreign key(cid) references course(cid),
constraint programme_courses_fk3 foreign key(rid) references round(rid));

create table section
(cid varchar(10) not null,
sno varchar(3) not null,
sch_day varchar(10),
start_time time not null,
end_time time not null,
capacity int not null,
constraint section_pk primary key(cid, sno),
constraint section_fk1 foreign key(cid) references course(cid));

create table round_release
(cid varchar(10) not null,
sno varchar(3) not null,
rid int not null,
no_seats int not null,
constraint roundrelease_pk primary key(cid, sno, rid),
constraint roundrelease_fk1 foreign key(cid, sno) references section(cid, sno),
constraint roundrelease_fk2 foreign key(rid) references round(rid));

create table bidding
(cid varchar(10) not null,
sno varchar(3) not null,
rid int not null,
sid varchar(10) not null,
edollars int not null,
bid_datetime datetime not null,
outcome char(1) not null,
constraint bidding_pk primary key(cid, sno, rid, sid),
constraint bidding_fk1 foreign key(cid, sno, rid) references round_release(cid, sno, rid),
constraint bidding_fk2 foreign key(sid) references student(sid));

#load data

load data infile 'C:\\wamp64\\tmp\\school.txt' into table school fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\round.txt' into table round fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\programme.txt' into table programme fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\student.txt' into table student fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\double_degree.txt' into table double_degree fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\second_major.txt' into table second_major fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\course.txt' into table course fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\programme_courses.txt' into table programme_courses fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\section.txt' into table section fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\round_release.txt' into table round_release fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

load data infile 'C:\\wamp64\\tmp\\bidding.txt' into table bidding fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines ;

