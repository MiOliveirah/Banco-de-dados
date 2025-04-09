-- inseção de dados e queries

use ecommerce;

show tables;

-- Clientes
insert into clients (clientType, address, contact) values
        ('PF', 'Rua A, 123', '15999998888'),
	    	('PJ', 'Av. B, 456', '1522223333');
 
 -- dados especificos de clientes
insert into client_pf (idClient, Fname, Minit, Lname, CPF) values
        ('1', 'João', 'M', 'Silva', '12345678901'),
	    	('2', 'Vitoria', 'O', 'Santos', '15615615615');

insert into client_pj (idClient, SocialName, FantasyName, CNPJ) values
        (2, 'Empresa XYZ Ltda', 'Smurfs', '12345678000199');

-- produtos
insert into product (Pname, classification_kids, category, avaliação, size) values
        ('Fone de ouvido', false, 'Eletrônico', 4, null),
	    	('Barbie Elsa', true, 'Brinquedos', 3, null),
        ('Body Carters', true, 'Vestimenta', 2, null),
        ('Microfone Vedo - youtuber', false, 'Eletrônico', 4, null),
        ('Sofá retrátil', false, 'Móveis', 4, '3x57x80'),
        ('Farinha de arroz',false, 'Alimentos', 5, null),
        ('Fire Stick Amazon', false, 'Eletrônico', 4, null);

-- fornecedores
insert into supplier (SocialName, CNPJ, contact) values
		('Fornecedor Eletrônicos SA', '12312312312312', '16999999999'),
		('Brinquedos Infantis Ltda', '45645645645645', '17888888888');

-- relação fornecedor-produto
insert into supplier_product (idSupplier, idProduct, prodQuantity) values
        (1, 8, 100),
	    	(2, 10, 200);

-- vendedores
insert into seller (SocialName, CNPJ, CPF, contact) values
        ('Loja de Eletrônicos', '99888777000166', '45645645645', '11998887777'),
	    	('Brinquedos Online', '44555666000177', '78978978978', '11997776666');

-- estoque
insert into productStorage (storageLocation, quantity) values
        ('Armazém A', 50),
	    	('Armazém B', 100);

-- localização do estoque
insert into storageLocation (idLproduct, idLstorage, location) values
        (9, 1, 'Prateleira 1'),
	    	(11, 2, 'Prateleira 2');

-- cartões
insert into card (idClient, cardNumber, cardHolder, expiryDate, securityCode, cardType) values
        (1, '4111111111111111', 'JOÃO SILVA', '12/25', '123', 'Crédito');

-- pagamento
insert into payments (idClient, id_payment, idCard, typePayment, amount) values
        (1, 1, 1, 'Cartão', 1500.00);

-- pedido
insert into orders (idOrderClient, orderStatus, sendValue) values
		    (1, 'Confirmado', 15.00);

-- produto por vendedor
insert into productSeller (idPseller, idPproduct, prodQuantity) values
        (1, 12, 10),
        (2, 14, 20);

-- produtos em pedidos
insert into productOrder (idPOproduct, idPOorder, prodQuantity) values
        (8, 1, 1),
        (10, 1, 2);

-- entrega
insert into delivery (idOrder, deliveryCompany, deliveryAddress, status) values
        (1, 'Correios', 'Rua A, 123 - São Paulo/SP', 'Preparando');

-- DESAFIO DE PROJETO:

-- Quais são os clientes pessoa física cadastrados?
SELECT c.idClient, cp.Fname AS 'Nome', cp.Lname AS 'Sobrenome', c.contact AS 'Contato' FROM clients c JOIN client_pf cp ON c.idClient = cp.idClient;

-- Quais produtos estão disponíveis em estoque?
SELECT p.idProduct, p.Pname AS 'Produto', sl.location AS 'Localização', ps.quantity AS 'Quantidade' FROM product p
    JOIN storageLocation sl ON p.idProduct = sl.idLproduct JOIN productStorage ps ON sl.idLstorage = ps.idProdStorage;

-- Quais são os produtos da categoria eletrônicos?
SELECT idProduct, Pname, category FROM product WHERE category = 'Eletrônico';

-- Quais pedidos estão com status confirmado?
SELECT idOrder, idOrderClient, orderStatus FROM orders WHERE orderStatus = 'Confirmado';

-- Qual é o valor total de cada pedido?
SELECT o.idOrder, SUM(py.amount) AS 'Valor Total', COUNT(po.idPOproduct) AS 'Itens no Pedido' FROM orders o LEFT JOIN productOrder po ON o.idOrder = po.idPOorder LEFT JOIN payments py ON o.idOrderClient = py.idClient
  	GROUP BY o.idOrder;

-- Quanto tempo falta para os cartões expirarem?
SELECT idCard, cardHolder, expiryDate,
    TIMESTAMPDIFF(MONTH, CURRENT_DATE, STR_TO_DATE(CONCAT('01/', expiryDate), '%d/%m/%y')) AS 'Meses até expirar' FROM card;

-- Quais são os produtos mais bem avaliados?
SELECT idProduct, Pname, avaliação FROM product ORDER BY avaliação DESC;

-- Quais pedidos têm o maior valor de envio?
SELECT idOrder, idOrderClient, sendValue FROM orders ORDER BY sendValue DESC;

-- Quais clientes fizeram mais de um pedido?
SELECT c.idClient, cp.Fname, COUNT(o.idOrder) AS 'Total Pedidos'
  	FROM clients c JOIN client_pf cp ON c.idClient = cp.idClient JOIN orders o ON c.idClient = o.idOrderClient GROUP BY c.idClient, cp.Fname HAVING COUNT(o.idOrder) > 1;

-- Quais categorias têm média de avaliação superior a 4?
SELECT category, AVG(avaliação) AS 'Média Avaliação' FROM product GROUP BY category HAVING AVG(avaliação) > 4;

-- Qual é a visão completa de um pedido específico?
SELECT o.idOrder, cp.Fname AS 'Cliente', p.Pname AS 'Produto', po.prodQuantity AS 'Quantidade', py.amount AS 'Valor Pago', d.status AS 'Status Entrega'
  	FROM orders o JOIN client_pf cp ON o.idOrderClient = cp.idClient JOIN productOrder po ON o.idOrder = po.idPOorder JOIN product p ON po.idPOproduct = p.idProduct JOIN payments py ON o.idOrderClient = py.idClient JOIN delivery d ON o.idOrder = d.idOrder;

-- Qual é a relação entre fornecedores, produtos e estoque?
SELECT s.SocialName AS 'Fornecedor', p.Pname AS 'Produto', sp.prodQuantity AS 'Quantidade Fornecida', (SELECT SUM(quantity) FROM productStorage ps JOIN storageLocation sl ON ps.idProdStorage = sl.idLstorage WHERE sl.idLproduct = p.idProduct) AS 'Em Estoque'
  	FROM supplier s JOIN supplier_product sp ON s.idSupplier = sp.idSupplier JOIN product p ON sp.idProduct = p.idProduct;