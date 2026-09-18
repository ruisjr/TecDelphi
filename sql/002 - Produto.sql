/* PRODUTO */
CREATE TABLE produto (
     codigo         integer         NOT NULL
    ,descricao      varchar(100)    NOT NULL
    ,preco_venda    numeric(18,2)   NOT NULL 
);

ALTER TABLE produto ADD CONSTRAINT pk_produto PRIMARY KEY (codigo);
CREATE SEQUENCE seq_produto_codigo;
CREATE INDEX idx_cliente_codigo ON cliente (codigo);

INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'Teclado', 299);
INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'Mouse', 29.9);
INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'Hub USB', 99.99);
INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'Suporte Notebook', 72.98);
INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'Pen Drive 128GB', 199);
INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'Pen Drive 256GB', 299);
INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'Placa Vídeo GeForce RTX 5800', 5480.99);
INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'SSD Kingston 256GB', 469);
INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'SSD Kingston 512GB', 899);
INSERT INTO produto VALUES (NEXT VALUE FOR seq_produto_codigo, 'Notebook Asus 16GB SSD 512GB Ryzen', 3899.98);

SELECT * FROM produto;