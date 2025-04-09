-- Triggers para ações automáticas

DELIMITER $$
CREATE TRIGGER trg_before_insert_order
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.sendValue < 10 THEN
        SET NEW.sendValue = 10;
    END IF;
END $$
DELIMITER ;

-- Tabela de log
CREATE TABLE IF NOT EXISTS order_log (
    idLog INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    client_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger AFTER INSERT
DELIMITER $$
CREATE TRIGGER trg_after_insert_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_log (order_id, client_id)
    VALUES (NEW.idOrder, NEW.idOrderClient);
END $$
DELIMITER ;