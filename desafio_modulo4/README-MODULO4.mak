# 📦 Otimização de Banco de Dados E-Commerce

## Índices Criados
1. `idx_cpf_unique`, `idx_cnpj_unique` - Índices únicos para documentos de clientes
2. `idx_product_category`, `idx_product_name` - Índices para buscas de produtos
3. `idx_order_status`, `idx_order_client` - Índices para filtros de pedidos
4. `idx_storage_location` - Índice para gestão de estoque
5. `idx_payment_status`, `idx_payment_type` - Índices para relatórios financeiros

## Procedures Implementadas
1. `ManageProduct` - Gerencia CRUD de produtos
2. `ManageOrder` - Gerencia criação e atualização de pedidos

## Justificativas
Os índices foram criados nos campos mais utilizados em:
- Buscas de clientes (por documento)
- Filtros de produtos (categoria e nome)
- Acompanhamento de pedidos (status e cliente)
- Operações logísticas (localização de estoque)
- Relatórios financeiros (status e tipo de pagamento)

As procedures centralizam operações críticas do e-commerce, garantindo:
- Integridade dos dados
- Controle de transações
- Padronização de operações