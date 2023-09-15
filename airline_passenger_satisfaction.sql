create schema portfolio_project4;
-- TABLE CREATION --
use portfolio_project4;
create table airline_passenger_satisfaction (id int primary key, gender varchar(255), age int, customer_type varchar (255), type_of_travel varchar (255), 
class varchar (255), flight_distance int, departure_delay int, arrival_delay int, departure_and_arrival_convenience int, ease_online_booking int, 
check_in_service int, online_boarding int, gate_location int, on_board_service int, seat_comfort int, leg_room int, cleanliness int, food_and_drink int, 
in_flight_service int, in_flight_wifi_service int, in_flight_entertainment int, baggage_handling int, overall_satisfaction varchar (255));

--	FUNCTIONS EXPLORED - WHERE, OR, IF, COUNTIF, TRIGGER CREATIONS, PROCEDURES, COUNT, GROUP BY, ORDER BY, AVERAGE, ROUND	--

-- LOAD ALL DETAILS --
select * from airline_passenger_satisfaction;

-- TRIGGER TABLE CREATION --
create table  convenience1 (id int,comment_section varchar (255));
create table leg_room_improvement (id int,age int, comments varchar(255));

-- CREATING AFTER INSERT TRIGGERS FOR DEPARTURE AND ARRIVAL CONVENIENCE IMPROVISATION -- 1ST TRIGGER 
delimiter //
create trigger convenience1 after insert on  airline_passenger_satisfaction for each row
begin
if new.departure_and_arrival_convenience = 1 then
insert into conveneince1 ( id, comment_section) values
(new.id,"PLEASE IMPROVE SERVICE");
end if ;
end //
delimiter ;

-- CREATING AFTER INSERT TRIGGER FOR SENIOR CITIZENS COMFORT IDENTIFICATION -- 2ND TRIGGER
delimiter //
create trigger leg_room_improvement after insert on airline_passenger_satisfaction for each row
begin
if new.age >=60 and new.leg_room <=1 then
insert into leg_room_improvement (id, age,comments) values 
(new.id,new.age,"improve leg room");
end if ;
end //
delimiter ;

-- LOADING FIRST TRIGGER CREATED --
select * from convenience1;

-- LOADING SECOND TRIGGER CREATED -- 
select * from leg_room_improvement;

/* How many total passenger of each gender */
select gender, count(id) as total from airline_passenger_satisfaction 
group by gender order by total desc;

/* How many total passenger of each customer type */
select customer_type, count(id) as total_customer_types from airline_passenger_satisfaction 
group by customer_type order by total_customer_types desc;

/* How many total passenger of each type of travel */
select type_of_travel, count(id) as travel_type from airline_passenger_satisfaction 
group by type_of_travel order by travel_type;

/* How many total passenger of each class */
select class, count(id) as class_types from airline_passenger_satisfaction
 group by class order by class_types;

/* How many total passenger of each satisfaction */
select overall_satisfaction, count(id) as satisfaction from airline_passenger_satisfaction 
group by overall_satisfaction order by  satisfaction;

/* How many total passenger and average flight distance where the age less than 20 */
select customer_type,gender,overall_satisfaction, round(avg(flight_distance),2) as average_distance, 
count(id) as total_passenger from airline_passenger_satisfaction 
where age <20 
group by customer_type,gender,overall_satisfaction order by average_distance;

/* How many total passenger and average flight distance where the age between 20 until 30 */
select gender,customer_type,class, round(avg(flight_distance),1) as average_flight, count(id) as total 
from airline_passenger_satisfaction 
where age between 20 and 30
 group by gender,customer_type,class order by average_flight; 

/* How many total passenger and average flight distance where the age greater than 30 */
select gender,customer_type,overall_satisfaction, round(avg(flight_distance),0) as avg_distance, count(id) as total
 from airline_passenger_satisfaction where age >30 
 group by gender,customer_type,overall_satisfaction order by avg_distance;
 
 /* How many total passenger and average departure delay minutes delay where the age less than 20 */
 select gender,customer_type, round(avg(departure_delay),1), count(id) as total from airline_passenger_satisfaction
 where age <20 group by gender,customer_type order by total desc;

/* How many total passenger and average departure delay minutes where the age between 20 until 30 */
 select gender,customer_type,overall_satisfaction, round(avg(departure_delay),1)as rounded, count(id)
 from airline_passenger_satisfaction where age between 20 and 30 
 group by gender,customer_type,overall_satisfaction order by rounded desc;

 /* How many total passenger and average arrival delay minutes where the age less than 20 */
 select gender,type_of_travel,overall_satisfaction, round(avg(arrival_delay),1) as rounded, count(id) from 
 airline_passenger_satisfaction where age <20 group by gender,type_of_travel,overall_satisfaction
 order by rounded desc;

 /* How many ease online booking rating and total passenger where customer type is returning */
 select gender,type_of_travel, round(avg(ease_online_booking),1) as rounded, count(id) as total
 from airline_passenger_satisfaction where customer_type = 'returning' 
 group by gender,type_of_travel order by total desc;
 
 /* How many ease online booking rating and total passenger where customer type is first time */
 select gender,overall_satisfaction, round(avg(ease_online_booking),1) as rounded, count(id) as total from
 airline_passenger_satisfaction where customer_type = 'first-time' 
 group by gender,overall_satisfaction order by total desc;
 
 /* How many total passenger based on class and satisfaction */
select class,overall_satisfaction, count(id) as total_passenger from airline_passenger_satisfaction
group by class,overall_satisfaction order by total_passenger;

/* How many females who didn't like the cleanliness */
select gender,age,cleanliness from airline_passenger_satisfaction where (gender = 'female') and age >55 and cleanliness <1;

/* How many passengers who travelled a lot where they didn't like seat comfort */
select seat_comfort,flight_distance, count(id) as total_passenger from airline_passenger_satisfaction
where seat_comfort <=1 group by seat_comfort,flight_distance order by flight_distance desc;

/* How many passengers who are satisfied */
select id,age, if(overall_satisfaction = 'satisfied','yes','no') as individual from airline_passenger_satisfaction;

/* How many returning customers */
select id,age,gender, count(if(customer_type = 'returning','yes','no')) as total from airline_passenger_satisfaction
group by id,age,gender order by age;

/* How many passengers in business travles */
select id,gender, count(if(type_of_travel = 'business', '1', null)) as total from airline_passenger_satisfaction
group by id,gender order by id;