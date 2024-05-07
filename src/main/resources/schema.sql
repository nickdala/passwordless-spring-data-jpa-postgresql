create sequence if not exists todos_seq start with 1 increment by 50;

create table if not exists todos (
    todo_id bigint not null, 
    title varchar(255), 
    is_completed boolean, 
    primary key (todo_id)
);
