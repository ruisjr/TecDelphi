
/* PEDIDO ITEM */
CREATE TABLE pedido_item (
     id             integer         NOT NULL
    ,numero_pedido  integer         NOT NULL
    ,codigo_produto integer         NOT NULL
    ,quantidade     numeric(18,2)   DEFAULT 0 NOT NULL 
    ,vlr_unitario   numeric(18,2)   DEFAULT 0 NOT NULL
    ,vlr_total      numeric(18,2)   DEFAULT 0 NOT NULL 
);

ALTER TABLE pedido_item ADD CONSTRAINT pk_pedido_item PRIMARY KEY (id);
ALTER TABLE pedido_item ADD CONSTRAINT fk_pedido_item_np FOREIGN KEY (numero_pedido) REFERENCES pedido(numero_pedido);
ALTER TABLE pedido_item ADD CONSTRAINT fk_pedido_item_cp FOREIGN KEY (codigo_produto) REFERENCES produto(codigo);

CREATE INDEX idx_pedido_codigo_produto ON pedido_item (codigo_produto);

SELECT CURRENT_DATE FROM RDB$DATABASE;