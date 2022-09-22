-- drop database ecommerce;
create database ecommerce;
use ecommerce;

-- tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(255),
    constraint unique_cpf_client unique (CPF)    
);
alter table clients auto_increment = 1;

-- tabela produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(45) not null,
    Classification_Kids bool default false,
    Category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    rate float default 0,
    size varchar(10)   
);
alter table product auto_increment = 1;

-- pagamento
create table payments( 
	idClient int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois cartões', 'Pix'),
    limitAvailable float,    
    primary key(idClient, idPayment)
);

-- tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum ('Cancelado', 'Confirmado', 'Em Processamento') default 'Em Processamento',
    orderDescription varchar(255),
    sendValue float default 10.0,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderClient) references  clients(idClient)
			on update cascade
);
alter table orders auto_increment = 1;

   -- tabela estoque
create table productStorage(
	idProductStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0 
);

   -- tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);
alter table supplier auto_increment = 1;

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key(idPsSupplier, idPsProduct),
    constraint fk_produc_supplier_suplier foreign key (idPsSupplier) references supplier (idSupplier),
    constraint fk_product_supplier_product foreign key(idPsProduct) references product (idProduct)
);

   -- tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    socialName varchar(255) not null,
	abstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);
alter table seller auto_increment = 1;

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key(idPseller) references seller(idSeller),
    constraint fk_products_product foreign key(idPproduct) references product(idProduct)    
);

   create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem Estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_product_product foreign key(idPOproduct) references product(idProduct),
    constraint fk_product_order foreign key(idPOorder) references orders(idOrder)    
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key(idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key(idLstorage) references productStorage(idProductStorage)
);
insert into Clients (Fname, Minit, Lname, CPF, Address)
			values('Maria', 'M', 'Silva', '123456789', 'rua silva de prata 29, Carangola - Cidade das flores'),
				  ('Matheus', 'O', 'Pimentel', '987654321', 'alameda 289, Centro - Cidade das flores'),
                  ('Ricardo', 'F', 'Silva', '456789123', 'alameda vinha 1009, Centro - Cidade das flores'),
                  ('Julia', 'S', 'França', '987456321', 'rua laranjeiras 861, Centro - Cidade das flores'),
                  ('Roberta', 'G', 'Assis', '123987456', 'avenida koller 19, Centro - Cidade das flores'),
                  ('Isabela', 'M', 'Cruz', '258147963', 'alameda das flores 28, Centro - Cidade das flores');
                  
insert into product (Pname, Classification_kids, Category, rate, size)
			values('Fone de ouvido', false, 'Eletrônico', '4', null),
				  ('Barbie Elsa', true, 'Brinquedos','3', null),
                  ('Body Carters', true, 'Vestimenta','5', null),
                  ('Microfone Vedo - Youtuber', false, 'Eletrônico', '4', null),
                  ('Sofá Retrátil', false, 'Móveis', '3', '3x57x80'),
                  ('Farinha de arroz', false, 'Alimentos', '2', null),
                  ('Fire Stick Amazon', false, 'Eletrônico','3', null);
                  
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
			values(1, default, 'compra via app', null, 1),
				  (2, default, 'compra via app', 50, 0),
                  (3, 'Confirmado', null, null, 1),
                  (4, default, 'compra via web-site', 150, 0);
                  
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
			values(1, 5, 2, default),
                  (2, 5, 1, default),
                  (3, 6, 1, default);
                  
insert into productStorage (storageLocation, quantity)
			values('Rio de Janeiro', 1000),
				  ('Rio de Janeiro', 500),
                  ('São Paulo', 10),
                  ('São Paulo', 100),
                  ('São Paulo', 10),
                  ('Brasília', 60);
                  
insert into storageLocation (idLproduct, idLstorage, location)
			values(1, 2, 'RJ'),
				  (2, 6, 'GO');
                  
insert into supplier(SocialName, CNPJ, contact)
			values('Almeida e Filhos', '12345678123456', '21985474'),
                  ('Eletrônicos Silva', '98765432145678', '21984567'),
                  ('Eletrônicos Valma', '14785236985214', '219854622');
                  
insert into productSupplier (idPsSupplier, idPsProduct, quantity)
			values(1, 1, 500),
				  (1, 2, 400),
                  (2, 4, 633),
                  (3, 3, 5),
                  (2, 5, 10);
                  
insert into productSeller (idPseller, idPproduct, prodQuantity)
			values(1, 6, 80),
				  (2, 7, 10);

select * from supplier;
select * from orders;
select * from clients;
select * from product;
select * from seller;                  
select * from clients c, orders o where c.idClient = idOrderClient    