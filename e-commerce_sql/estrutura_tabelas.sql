create database ecommerce;
use ecommerce;

create table clients(
    idClient int auto_increment primary key,
    clientType enum('PF', 'PJ') not null,
    address varchar(30) not null,
    contact char(11) not null
);

Alter table clients auto_increment=1;

create table client_pf(
	idClient int primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null unique,
    foreign key (idClient) references clients(idClient)
);

create table client_pj(
	idClient int primary key,
    SocialName varchar(45),
    FantasyName varchar(45),
    CNPJ char(15) not null unique,
    foreign key (idClient) references clients(idClient)
);

create table product(
    idProduct int auto_increment primary key,
    Pname varchar(20),
    classification_kids bool default false,
    category enum ('Eletrônico','Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    avaliação float default 0,
    size varchar(10)
);

ALTER TABLE product 
MODIFY COLUMN Pname VARCHAR(50);

create table card(
	idCard int auto_increment primary key,
    idClient int not null,
    cardNumber char(16) not null,
    cardHolder varchar(45) not null,
	expiryDate char(5) not null,
	securityCode char(3) not null,
	cardType enum('Crédito', 'Débito') not null,
	isDefault bool default false,
    constraint fk_card_client foreign key (idClient) references clients(idClient)
);

create table payments(
    idClient int not null,
    id_payment int not null,
    idCard int,
    typePayment enum ('Boleto', 'Cartão', 'Dois cartões', 'PIX') not null,
    amount decimal(10,2) not null,
    paymentDate datetime default current_timestamp,
    status enum('Pendente', 'Processando', 'Aprovado', 'Recusado') default 'Pendente',
    primary key (idClient, id_payment),
	constraint fk_payment_card foreign key (idCard) references card(idCard)
);

create table orders(
    idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum ('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar (255),
    sendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
);
  
create table productStorage(
    idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

create table supplier(
    idSupplier int auto_increment primary key,
    SocialName varchar(255),
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

create table supplier_product(
	idSupplier int not null,
    idProduct int not null,
    prodQuantity int not null,
    primary key (idSupplier, idProduct),
    constraint fk_supplierprod_supplier foreign key (idSupplier) references supplier(idSupplier),
    constraint fk_supplierprod_product foreign key (idProduct) references product(idProduct)
);

create table seller(
    idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    abstName varchar(255),
    CNPJ char(15),
    CPF char(11),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

create table productSeller(
    idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

create table productOrder(
    idPOproduct int,
    idPOorder int,
    prodQuantity int default 1,
    poStatus enum ('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
    idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storagelocation_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storagelocation_storage foreign key (idLstorage) references productStorage(idProdStorage)
); 

create table delivery(
	idDelivery int auto_increment primary key,
    idOrder int not null,
    deliveryCompany varchar(50) not null,
    deliveryAddress varchar(255) not null,
    trackingCode varchar(50),
    status enum('Preparando', 'Enviado', 'Em transito', 'Entregue', 'Devolvido') default 'Preparando',
    shippingDate datetime,
    deliveryDate datetime,
    constraint fk_delivery_order foreign key (idOrder) references orders(idOrder)
);

show tables;

show databases;
use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';