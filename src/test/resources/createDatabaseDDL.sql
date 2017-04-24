CREATE DATABASE shop;
CREATE DATABASE testdb;

CREATE TABLE attribute_name
(
    name VARCHAR(255) PRIMARY KEY NOT NULL
);
CREATE TABLE category
(
    id INTEGER PRIMARY KEY NOT NULL,
    description VARCHAR(255),
    name VARCHAR(255),
    category INTEGER,
    CONSTRAINT "FKlef57s6da5w87lt7yyhneytb5" FOREIGN KEY (category) REFERENCES category (id)
);
CREATE TABLE product_card
(
    sku VARCHAR(255) PRIMARY KEY NOT NULL,
    amount INTEGER NOT NULL,
    dislikes INTEGER NOT NULL,
    likes INTEGER NOT NULL,
    name VARCHAR(255),
    price INTEGER NOT NULL,
    product_description VARCHAR(255),
    category INTEGER,
    CONSTRAINT "FKllyanr6fbqi704kdo67r3gikn" FOREIGN KEY (category) REFERENCES category (id)
);
CREATE TABLE attribute_value
(
    id INTEGER PRIMARY KEY NOT NULL,
    value VARCHAR(255),
    attributename VARCHAR(255) NOT NULL,
    productcard VARCHAR(255),
    CONSTRAINT "FK5y9xaik6fx8j6hoyipoo12wi0" FOREIGN KEY (attributename) REFERENCES attribute_name (name),
    CONSTRAINT "FK73txamlgrbytg5jy2y685r4d1" FOREIGN KEY (productcard) REFERENCES product_card (sku)
);
CREATE TABLE visualization
(
    id INTEGER PRIMARY KEY NOT NULL,
    type INTEGER NOT NULL,
    url VARCHAR(255),
    product_card VARCHAR(255),
    CONSTRAINT "FKbfsslb0p9okr09yypskc3gusq" FOREIGN KEY (product_card) REFERENCES product_card (sku)
);
CREATE TABLE customer
(
    email VARCHAR(255) PRIMARY KEY NOT NULL,
    name VARCHAR(255),
    phone VARCHAR(255),
    subscribe BOOLEAN NOT NULL
);
CREATE TABLE order_main
(
    order_id INTEGER PRIMARY KEY NOT NULL,
    address VARCHAR(255),
    status INTEGER NOT NULL,
    customer VARCHAR(255) NOT NULL,
    CONSTRAINT "FKsy17lqd0gidvahyujevwpg8at" FOREIGN KEY (customer) REFERENCES customer (email)
);
CREATE TABLE order_item
(
    id INTEGER PRIMARY KEY NOT NULL,
    amount INTEGER NOT NULL,
    totalprice INTEGER NOT NULL,
    order_main INTEGER NOT NULL,
    product_card VARCHAR(255),
    CONSTRAINT "FKghco3npd7upgiajjj1xvye8hq" FOREIGN KEY (order_main) REFERENCES order_main (order_id),
    CONSTRAINT "FKdf23g63bruf5cs69ed61rhpae" FOREIGN KEY (product_card) REFERENCES product_card (sku)
);
