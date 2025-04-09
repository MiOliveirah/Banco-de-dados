-- BACKUP E RECOVERY

-- BACKUP DO BANCO DE DADOS E-COMMERCE
-- Execute os comandos abaixo no terminal ou prompt de comando:

-- Backup completo com procedures, triggers e eventos:
-- mysqldump -u root -p --routines --triggers --events ecommerce_db > ecommerce_backup.sql

-- Para fazer backup de múltiplos bancos:
-- mysqldump -u root -p --databases ecommerce_db outro_banco > multi_backup.sql

-- BACKUP DE APENAS UMA TABELA:
-- mysqldump -u root -p ecommerce_db orders > orders_backup.sql

-- RESTAURAR O BANCO DE DADOS:
-- mysql -u root -p ecommerce_db < ecommerce_backup.sql