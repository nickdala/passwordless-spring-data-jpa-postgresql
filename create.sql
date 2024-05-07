create sequence todos_seq start with 1 increment by 50;
create table todos (is_completed boolean, todo_id bigint not null, title varchar(255), primary key (todo_id));
