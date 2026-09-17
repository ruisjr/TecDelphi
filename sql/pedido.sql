/* PEDIDO */
CREATE TABLE pedido (
     numero_pedido      integer         NOT NULL
    ,data_emissao       TIMESTAMP       NOT NULL 
    ,codigo_cliente     integer         NOT NULL 
    ,valor_total        numeric(18,2)   DEFAULT 0 NOT null
);

ALTER TABLE pedido ADD CONSTRAINT pk_pedido PRIMARY KEY (numero_pedido);
ALTER TABLE pedido ADD CONSTRAINT fk_pedido_cc FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo);
CREATE SEQUENCE seq_pedido_numero_pedido;
CREATE INDEX idx_pedido_numero_pedido ON pedido (numero_pedido);
