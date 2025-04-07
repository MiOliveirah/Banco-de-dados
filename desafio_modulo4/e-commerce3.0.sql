-- índices e procedures e-commerce

use ecommerce;

show tables;

-- 1. Índice para clientes (busca frequente por CPF/CNPJ)
ALTER TABLE client_pf ADD UNIQUE idx_cpf_unique (CPF);
ALTER TABLE client_pj ADD UNIQUE idx_cnpj_unique (CNPJ);

-- 2. Índice para produtos (busca por categoria e nome)
CREATE INDEX idx_product_category ON product(category);
CREATE INDEX idx_product_name ON product(Pname);

-- 3. Índice para pedidos (busca por status e cliente)
CREATE INDEX idx_order_status ON orders(orderStatus);
CREATE INDEX idx_order_client ON orders(idOrderClient);

-- 4. Índice para estoque (busca por localização)
CREATE INDEX idx_storage_location ON productStorage(storageLocation);

-- 5. Índice para pagamentos (busca por status e tipo)
CREATE INDEX idx_payment_status ON payments(status);
CREATE INDEX idx_payment_type ON payments(typePayment);

DELIMITER //
CREATE PROCEDURE ManageProduct(
    IN p_action INT,
    IN p_idProduct INT,
    IN p_Pname VARCHAR(50),
    IN p_category ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'),
    IN p_avaliação FLOAT,
    IN p_size VARCHAR(10)
)
BEGIN
    DECLARE product_count INT;
    
    CASE p_action
        WHEN 1 THEN -- Inserir
            INSERT INTO product (Pname, category, avaliação, size)
            VALUES (p_Pname, p_category, p_avaliação, p_size);
            SELECT CONCAT('Produto inserido com ID: ', LAST_INSERT_ID()) AS Message;
            
        WHEN 2 THEN -- Atualizar
            SELECT COUNT(*) INTO product_count FROM product WHERE idProduct = p_idProduct;
            IF product_count > 0 THEN
                UPDATE product 
                SET Pname = p_Pname, 
                    category = p_category, 
                    avaliação = p_avaliação, 
                    size = p_size
                WHERE idProduct = p_idProduct;
                SELECT 'Produto atualizado com sucesso' AS Message;
            ELSE
                SELECT 'Erro: Produto não encontrado' AS Message;
            END IF;
            
        WHEN 3 THEN -- Deletar
            SELECT COUNT(*) INTO product_count FROM product WHERE idProduct = p_idProduct;
            IF product_count > 0 THEN
                DELETE FROM product WHERE idProduct = p_idProduct;
                SELECT 'Produto removido com sucesso' AS Message;
            ELSE
                SELECT 'Erro: Produto não encontrado' AS Message;
            END IF;
            
        WHEN 4 THEN -- Consultar
            SELECT * FROM product WHERE idProduct = p_idProduct;
            
        ELSE
            SELECT 'Ação inválida. Use: 1-Inserir, 2-Atualizar, 3-Remover, 4-Consultar' AS Message;
    END CASE;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ManageOrder(
    IN p_action INT,
    IN p_idOrder INT,
    IN p_idClient INT,
    IN p_status ENUM('Cancelado','Confirmado','Em processamento'),
    IN p_description VARCHAR(255)
)
BEGIN
    DECLARE order_count INT;
    
    CASE p_action
        WHEN 1 THEN -- Criar pedido
            INSERT INTO orders (idOrderClient, orderStatus, orderDescription)
            VALUES (p_idClient, p_status, p_description);
            SELECT CONCAT('Pedido criado com ID: ', LAST_INSERT_ID()) AS Message;
            
        WHEN 2 THEN -- Atualizar status
            SELECT COUNT(*) INTO order_count FROM orders WHERE idOrder = p_idOrder;
            IF order_count > 0 THEN
                UPDATE orders 
                SET orderStatus = p_status,
                    orderDescription = p_description
                WHERE idOrder = p_idOrder;
                SELECT 'Pedido atualizado com sucesso' AS Message;
            ELSE
                SELECT 'Erro: Pedido não encontrado' AS Message;
            END IF;
            
        WHEN 3 THEN -- Adicionar produto ao pedido
            -- Implementação similar às anteriores
            SELECT 'Funcionalidade a ser implementada' AS Message;
            
        WHEN 4 THEN -- Consultar pedido
            SELECT o.*, c.Fname, c.Lname 
            FROM orders o
            JOIN client_pf c ON o.idOrderClient = c.idClient
            WHERE o.idOrder = p_idOrder;
            
        ELSE
            SELECT 'Ação inválida' AS Message;
    END CASE;
END //
DELIMITER ;

-- Inserir novo produto
CALL ManageProduct(1, NULL, 'Notebook Gamer', 'Eletrônico', 4.5, NULL);

-- Atualizar produto
CALL ManageProduct(2, 1, 'Notebook Gamer Pro', 'Eletrônico', 4.7, '15x25x3');

-- Consultar pedido
CALL ManageOrder(4, 1, NULL, NULL, NULL);

