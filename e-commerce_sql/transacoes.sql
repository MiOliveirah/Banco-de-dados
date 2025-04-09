-- Desabilitar autocommit
SET autocommit = 0;

-- Iniciar transação
START TRANSACTION;

-- Atualizando status de pedido e reduzindo quantidade em estoque
UPDATE orders
SET orderStatus = 'Confirmado'
WHERE idOrder = 1;

UPDATE productStorage
SET quantity = quantity - 1
WHERE idProdStorage = 1;

-- Confirmar transação
COMMIT;

-- Ou em caso de erro:
ROLLBACK;