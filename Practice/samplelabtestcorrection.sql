#Qn. 13

#1. create a table for each aircraft name with its corresponding min salary & max salary
#2. use that table to find the aname that has min salary as 60000 & max salary as 85000

select aname
from (select aname, min(salary) as MinSalary, max(salary) as MaxSalary
		from employee e, certified c, aircraft a
		where e.eid = c.eid and c.aid = a.aid
		group by aname) as temp
where MinSalary >= 60000 and MinSalary <= 85000;

#Qn.14

#1. find eid with salary more than 70000
#2. find eid with aircrafts of cruisingrange more than dist of flno 3
#3. find eid with aircrafts of cruisingrange less than dist of flno 3
#4. find ename and salary in 1 and 2 but not 3

#better way -> more efficient & logical
#1. find eid with salary more than 70000
#2. find eid with aircraft of cruisingrange less than dist of flno 3
#3. find ename and salary of eid in 1 and not 2
# they ask for having aircraft only with cruisingrange more than dist of flno 3
# if the pilot have any aircraft with cruisingrange less than or equal to -> immediately out
# so use not in the one that is immediately out

select ename, salary
from employee
where eid in (select eid
				from employee
				where salary > 70000) 
and eid in (select distinct eid
			from certified c, aircraft a
			where c.aid = a.aid and cruisingrange > (select distance from flight where flno = 3)) 
and eid not in (select distinct eid
				from certified c, aircraft a
				where c.aid = a.aid and cruisingrange <= (select distance from flight where flno = 3));
                
select distinct ename, salary
from employee e, certified c
where e.eid = c.eid
and salary >70000 and e.eid not in
(select d.eid from certified d, aircraft f
where d.aid=f.aid and cruisingrange <= (select distance from flight where FLNO = 3));

#Qn.15

#1. find eid that have aircrafts with cruisingrange more than 1000
#2. find eid with aircrafts that have b in the aname
# find ename with eid in 1 but not 2 -> the qn say all aircrafts eid owns must not have b in aname 

select ename
from employee
where eid in (select distinct eid 
				from certified c, aircraft a 
                where c.aid = a.aid and cruisingrange > 1000)
and eid not in (select distinct eid 
				from certified c, aircraft a 
                where c.aid = a.aid and aname like '%b%');

