start transaction;
-- fix colums names, types and constraints 
alter table properties rename column weight to atomic_mass;
alter table properties rename column melting_point to melting_point_celsius;
alter table properties rename column boiling_point to boiling_point_celsius;
alter table properties alter column melting_point_celsius set not null;
alter table properties alter column boiling_point_celsius set not null;
alter table properties alter column atomic_mass type float;
alter table elements alter column symbol set not null;
alter table elements alter column name set not null;
alter table elements add unique (symbol);
alter table elements add unique (name);
alter table properties add foreign key (atomic_number) references elements (atomic_number);

-- create table types and insert rows
create table types (
  type_id int primary key,
  type varchar(15) not null
);

insert into types (type_id, type) values
  (1, 'metal'),
  (2, 'metalloid'),
  (3, 'nonmetal')
;

-- add and set properties column type_id
alter table properties add column type_id int references types(type_id);
update properties set type_id=(SELECT type_id from types where types.type = properties.type);
-- then drop properties column "type"
alter table properties drop column type;
-- and set the not null constraint to the columns
alter table properties alter column type_id set not null;
-- delete the non existent element
delete from properties where atomic_number = 1000;
delete from elements where atomic_number = 1000;

-- Insert two new elements and relative properties
insert into elements (atomic_number, symbol, name) values
  (9, 'F', 'Fluorine');
insert into elements (atomic_number, symbol, name) values
  (10, 'Ne', 'Neon');
insert into properties (
  atomic_number, type_id, atomic_mass, melting_point_celsius, boiling_point_celsius
) VALUES (9, 3, 18.998, -220, -188.1);
insert into properties (
  atomic_number, type_id, atomic_mass, melting_point_celsius, boiling_point_celsius
) VALUES (10, 3, 20.18, -248.6, -246.1);

-- Set to uppercase the symbol first letter 
update elements set symbol=INITCAP(symbol);
commit;