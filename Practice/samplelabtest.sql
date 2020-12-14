#Provided by Dian Farah Binte Riduan (ID:***)
CREATE DATABASE sample_lab_test;
USE sample_lab_test;

CREATE TABLE Aircraft (
       aid                  int NOT NULL,
       aname                varchar(20) ,
       cruisingrange         int,
       CONSTRAINT AircraftPK PRIMARY KEY (aid)
);
CREATE TABLE Employee (
       eid                  int NOT NULL,
       ename                varchar(20) ,
       salary               int,
       CONSTRAINT EmployeePK PRIMARY KEY (eid)
);
CREATE TABLE Certified (
       eid                  int NOT NULL,
       aid                  int NOT NULL,
       CertDate	   Date NOT NULL,
       CONSTRAINT CertifiedPK PRIMARY KEY (eid, aid),
       CONSTRAINT EmpFK FOREIGN KEY (eid) REFERENCES Employee  (eid),
       CONSTRAINT AircraftFK FOREIGN KEY (aid) REFERENCES Aircraft  (aid)
);
CREATE TABLE Flight (
       flno                  int NOT NULL,
       fly_from           varchar(20),
       fly_to               varchar(20),
       distance          int,
       price                int,
       CONSTRAINT FlightPK PRIMARY KEY (flno)
);

INSERT INTO EMPLOYEE VALUES(1,'Jacob',85000);
INSERT INTO EMPLOYEE VALUES(2,'Michael',55000);
INSERT INTO EMPLOYEE VALUES(3,'Emily',80000);
INSERT INTO EMPLOYEE VALUES(4,'Ashley',110000);
INSERT INTO EMPLOYEE VALUES(5,'Daniel',80000);
INSERT INTO EMPLOYEE VALUES(6,'Olivia',70000);

INSERT INTO AIRCRAFT VALUES(1,'a1',800);
INSERT INTO AIRCRAFT VALUES(2,'a2b',700);
INSERT INTO AIRCRAFT VALUES(3,'a3',1000);
INSERT INTO AIRCRAFT VALUES(4,'a4b',1100);
INSERT INTO AIRCRAFT VALUES(5,'a5',1200);

INSERT INTO FLIGHT VALUES(1,'LA','SF',600,65000);
INSERT INTO FLIGHT VALUES(2,'LA','SF',700,70000);
INSERT INTO FLIGHT VALUES(3,'LA','SF',800,90000);
INSERT INTO FLIGHT VALUES(4,'LA','NY',1000,85000);
INSERT INTO FLIGHT VALUES(5,'NY','LA',1100,95000);

INSERT INTO CERTIFIED VALUES(1,1,'2005-01-01');
INSERT INTO CERTIFIED VALUES(1,2,'2001-01-01');
INSERT INTO CERTIFIED VALUES(1,3,'2000-01-01');
INSERT INTO CERTIFIED VALUES(1,5,'2000-01-01');
INSERT INTO CERTIFIED VALUES(2,3,'2002-01-01');
INSERT INTO CERTIFIED VALUES(2,2,'2003-01-01');
INSERT INTO CERTIFIED VALUES(3,3,'2003-01-01');
INSERT INTO CERTIFIED VALUES(3,5,'2004-01-01');

#Qn. 1
alter table employee add speaircraft int;
alter table employee add constraint employee_fk foreign key (speaircraft) references aircraft(aid);

update employee set speaircraft = 1 where eid = 1;
update employee set speaircraft = 3 where eid = 2;
update employee set speaircraft = 4 where eid = 3;
update employee set speaircraft = 3 where eid = 4;

#Qn. 2
select distinct eid
from certified
where aid = 1 or extract(year from certdate) = 2003;

#Qn.3
select distinct fly_to
from flight
order by fly_to desc;

#Qn. 4
select eid
from employee
where salary > 70000 and salary <= 100000;

#Qn. 5
select max(cruisingrange), min(cruisingrange)
from aircraft;

#Qn. 6
select ename, salary, aname
from employee e left outer join (select eid, a.aid, aname from certified c, aircraft a where c.aid = a.aid) as temp
on e.eid = temp.eid;

#Qn. 7
select fly_from, fly_to, min(price)
from flight
group by fly_from, fly_to;

#Qn 8.
select ename, salary
from employee
where eid not in (select distinct eid from certified) and salary > (select avg(salary)
																	from employee e, certified c, aircraft a
																	where e.eid = c.eid and c.aid = a.aid and cruisingrange > 1000);

#Qn. 9
select e.eid, ename, MinCruisingRange
from employee e, (select eid, min(cruisingrange) as MinCruisingRange
					from certified c, aircraft a
					where c.aid = a.aid
					group by eid
					having count(a.aid) >= 2) as temp
where e.eid = temp.eid;

#Qn. 10
select ename, aname, certdate
from employee e, certified c, aircraft a
where e.eid = c.eid and c.aid = a.aid and aname like '%b';

#Qn. 11
select ename
from employee
where salary < (select min(price)
				from flight
				where fly_from = 'LA' and fly_to = 'SF'
				group by fly_from, fly_to);

#Qn. 12
select aname
from employee e, certified c, aircraft a
where e.eid = c.eid and c.aid = a.aid and ename = 'Jacob';

#Qn. 13
select aname
from (select aid, min(salary) as MinSalary, max(salary) as MaxSalary
		from employee e, certified c
		where e.eid = c.eid
		group by aid) as temp, aircraft a
where a.aid = temp.aid and MinSalary >= 60000 and MaxSalary <= 85000;

#Qn.14
select ename, salary
from employee e, (select eid, count(aid) as Count from certified group by eid) as temp1,
(select eid, count(c.aid) as Count from certified c, (select aid
														from flight f, aircraft a
														where flno = 3 and cruisingrange > distance) as temp
where c.aid = temp.aid group by eid) as temp2
where e.eid = temp1.eid and temp1.eid = temp2.eid
and temp1.Count = temp2.Count;

#Qn. 15
select ename
from employee
where eid in (select eid from certified c, aircraft a where c.aid = a.aid and cruisingrange > 1000) 
and eid not in (select distinct eid from certified c, aircraft a where c.aid = a.aid and aname like '%b%');

#Qn. 16
select extract(year from certdate)
from (select certdate, count(aid) as NumberCerts from certified group by certdate) as temp
where NumberCerts = (select max(NumberCerts) 
from (select certdate, count(aid) as NumberCerts from certified group by certdate) as temp);

#Qn. 17
select flno, ename
from (select flno, min(salary) as MinSalary
		from flight f, (select e.eid, salary, max(cruisingrange) as MaxCruisingRange
						from certified c, aircraft a, employee e
						where c.aid = a.aid and c.eid = e.eid
						group by e.eid) as temp
		where MaxCruisingRange >= distance
		group by flno) as temp1, employee e
where MinSalary = salary and e.eid in (select distinct eid from certified);

#Qn. 18
select f.flno, a.aid
from flight f, aircraft a, (select flno, min(cruisingrange - distance) as MinDiff
							from flight f, aircraft a
							where cruisingrange >= distance
							group by flno) as temp
where f.flno = temp.flno 
and MinDiff = cruisingrange - distance;

#table for the aid and number of pilots that can fly each aid
select aid, count(eid) as NumberofPilots
from certified
group by aid;

#table for (flno, aid, eid) group with the difference between cruisingrange & distance for each group
select flno, temp.aid, Diff
from certified c, (select flno, aid, (cruisingrange - distance) as Diff
					from flight f, aircraft a
					where cruisingrange >= distance) as temp
where c.aid = temp.aid;


#Qn. 19
delimiter $$
	create trigger after_certification_more_than_1200 after insert on certified for each row
	begin
		
        declare c_range int;
        declare old_salary int;
        set c_range = (select cruisingrange from aircraft where aid = new.aid);
        set old_salary = (select salary from employee where eid = new.eid);
        
		update employee set salary = old_salary + 200 where eid = new.eid;
			
    end $$
delimiter ;

#Qn. 20
delimiter $$

	create procedure sp_AircraftPilots(in aid_1 int, out total int)
    begin
    
		declare lowest_salary int;
        set lowest_salary = (select min(salary) from employee e, certified c where aid = aid_1 and c.eid = e.eid group by aid);
		set total = (select count(distinct eid) from certified);
        
        select eid, ename
        from employee
        where salary = lowest_salary;
        
    end $$

delimiter ;

set @total = 5;
call sp_AircraftPilots(3, @total);