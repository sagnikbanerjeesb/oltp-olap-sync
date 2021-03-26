create table student (student_id bigserial primary key, name text);
create table contact (contact_id bigserial primary key, student_id bigint, contact_number text);