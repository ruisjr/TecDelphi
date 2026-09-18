/* CLIENTE */
CREATE TABLE cliente (
     codigo      integer      NOT NULL 
    ,nome        varchar(100) NOT NULL 
    ,cidade      varchar(100) NOT NULL 
    ,uf          varchar(2)   NOT NULL 
);

ALTER TABLE cliente ADD CONSTRAINT pk_cliente PRIMARY KEY (codigo);
CREATE SEQUENCE seq_cliente_codigo;
CREATE INDEX idx_cliente_codigo ON cliente (codigo);

INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Rui Ignácio da Silva Júnior', 'Blumenau', 'SC');
INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Giovanna Cristina de Sousa da Silva', 'Blumenau', 'SC');
INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Natã Sousa Ignácio da Silva', 'Blumenau', 'SC');
INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Lucimar Martins Teixeira da Silva', 'Ribeirão Preto', 'SP');
INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Aleixo Arantes', 'Ribeirão Preto', 'SC');
INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Ronaldo Nazário', 'Rio de Janeiro', 'RJ');
INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Markus Blumenschein', 'Blumenau', 'SC');
INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Dayane Ester Segundo', 'Indaial', 'SC');
INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Josilene Arantes de Sousa', 'Ribeirão Preto', 'SP');
INSERT INTO cliente VALUES (NEXT VALUE FOR seq_cliente_codigo, 'Raquel Ignácio da Silva', 'Araraquara', 'SP');

SELECT * FROM cliente;