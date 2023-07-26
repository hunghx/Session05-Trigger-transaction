-- Trigger , transaction
 -- trigger : trình tự kích hoạt khi có sự thay đổi dữ liệu trên 1 bảng
 -- transaction - phiên giao dịch quản lí , quan sát các tác vụ thêm sửa xôas dữ liệu 
 -- 
 -- 1. start a new transaction
START TRANSACTION;

-- 2. Get the latest order number
SELECT 
    @orderNumber:=MAX(orderNUmber)+1
FROM
    orders;

-- 3. insert a new order for customer 145
INSERT INTO orders(orderNumber,
                   orderDate,
                   requiredDate,
                   shippedDate,
                   status,
                   customerNumber)
VALUES(@orderNumber,
       '2005-05-31',
       '2005-06-10',
       '2005-06-11',
       'In Process',
        145);
        
-- 4. Insert order line items
INSERT INTO orderdetails(orderNumber,
                         productCode,
                         quantityOrdered,
                         priceEach,
                         orderLineNumber)
VALUES(@orderNumber,'S18_1749', 30, '136', 1),
      (@orderNumber,'S18_2248', 50, '55.09', 2); 
      
-- 5. commit changes    
COMMIT;
 
--  CREATE TRIGGER trigger_name
-- {BEFORE | AFTER} {INSERT | UPDATE| DELETE }
-- ON table_name FOR EACH ROW
-- trigger_body;
drop trigger insert_catalog_after;
drop trigger before_catalog_update;
-- tạo 1 trigger cho phép thay đổi giá trị của trường description thành "hello world" trước khi lưu vào bảng
create trigger insert_catalog_before
before  insert 
on catalogs for each row
	set NEW.descriptions = "hello world";

insert into catalogs(name, descriptions,status,image) value("đồng hồ","rất xấu",1,"image");





-- khi tạo mới tài khoản thì tự dộng ạo giỏ hàng cho ngườidùng
create table account (
id int primary key auto_increment,
username varchar(100),
pass varchar(50),
age int 
);

create  table Cart(
id int primary key auto_increment,
account_id int ,
foreign key(account_id) references account(id)
);

create trigger insert_account_after 
after insert on account  for each row 
insert into cart(account_id) value(New.id);

insert into account(username, pass,age) value("hunghx1","123456",17);

-- trước khi xóa 1 tài khoản thì  
drop trigger acc ;


create trigger delete_account_before 
before delete 
on account for each row 
delete from cart where account_id = 4; -- id: 4 , username: "hunghx1" ,pass:"12345"

delete from account where id =4;
-- không cho phép account có age <18 hoặc >80 tuổi
-- Hiếu 
-- cấp phát bộ nhớ
set delimiter // 
create trigger acc 
before insert on account for each row 
if New.age < 18 or New.age >80 then
SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'tuoi ban tre nge hoac tuoi gia ghe' ; 
end if;
// delimiter ;










