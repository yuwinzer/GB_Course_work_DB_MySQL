-- -----------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------
-- База данных малого производства для учета цены и необходимости закупок (на этапе разработки).
-- Основу базы составляют компоненты(краски, материалы, текстиль)
-- и собираемая из них продукция (игрушечные столы, кресла и т.п.)
-- Планируется внедрение цен для учета стоимости, объединение с магазином и покупателями.
-- -----------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------


CREATE DATABASE small_facility_db;

USE small_facility_db;
SET FOREIGN_KEY_CHECKS = 0;
-- =====================================================================
-- ========================================  unit_types
DROP TABLE IF EXISTS unit_types;
CREATE TABLE unit_types (
	id TINYINT UNSIGNED NOT NULL,
	name varchar(32) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY unit_types_idx (name)
) ENGINE=InnoDB;

INSERT INTO unit_types VALUES (1, 'г'), (2, 'м'), (3, 'м кв'), (4, 'лст'), (5, 'шт');

-- ========================================  media_types
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
  id int unsigned NOT NULL AUTO_INCREMENT,
  name varchar(32) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY media_types_idx (name)
) ENGINE=InnoDB;

INSERT INTO media_types VALUES (1,'image'),(2,'sound'),(3,'document'),(4,'video');

-- ========================================  media
DROP TABLE IF EXISTS media;
CREATE TABLE media (
  id bigint unsigned NOT NULL AUTO_INCREMENT,
  media_types_id int unsigned NOT NULL,
  file_name varchar(256) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY media_idx (file_name),
  KEY fk_media_media_types (media_types_id),
  CONSTRAINT fk_med_media_types FOREIGN KEY (media_types_id) REFERENCES media_types (id)
) ENGINE=InnoDB;

-- ========================================  warehouses
DROP TABLE IF EXISTS warehouses;
CREATE TABLE warehouses (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	name varchar(8),
	PRIMARY KEY (id),
	UNIQUE KEY warehouses_idx (name)
) ENGINE=InnoDB;

INSERT INTO warehouses VALUES
	(1, 'MAIN');

-- =====================================================================
-- ========================================  users
DROP TABLE IF EXISTS users;

CREATE TABLE users (
	id bigint unsigned NOT NULL AUTO_INCREMENT,
	nick_name varchar(128) NOT NULL, -- shown
	first_name varchar(128) NOT NULL, -- hidden for other
	last_name varchar(128) NOT NULL, -- hidden for other
	email varchar(64) NOT NULL, -- hidden for other
	phone char(16) DEFAULT NULL, -- hidden for other
	password_hash char(64) NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY nick_name_unique (nick_name),
	UNIQUE KEY email_unique (email),
	UNIQUE KEY phone_unique (phone)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS profiles;

-- ========================================  profiles
CREATE TABLE profiles (
	user_id bigint unsigned NOT NULL,
	gender enum('f','m','x') NOT NULL,  -- hidden for other
-- 	birthday date NOT NULL,
	photo_id bigint unsigned DEFAULT NULL,
	ext_prof_link_1 varchar(255) DEFAULT NULL, -- hidden for other
	ext_prof_link_2 varchar(255) DEFAULT NULL, -- hidden for other
	comentary varchar(255) DEFAULT NULL, -- hidden
	adress varchar(128) DEFAULT NULL, -- hidden for other
	city varchar(64) DEFAULT NULL, -- hidden for other
	state varchar(64) DEFAULT NULL, -- hidden for other
	country varchar(64) DEFAULT NULL, -- hidden for other
	PRIMARY KEY (user_id),
	KEY profiles_photo_fk (photo_id),
	CONSTRAINT fk_prf_profiles_users FOREIGN KEY (user_id) REFERENCES users (id),
	CONSTRAINT fk_prf_profiles_photo FOREIGN KEY (photo_id) REFERENCES media (id)
) ENGINE=InnoDB;

-- ========================================  backorders
DROP TABLE IF EXISTS backorders;
CREATE TABLE backorders (
  id bigint unsigned NOT NULL AUTO_INCREMENT,
  user_id bigint unsigned NOT NULL,
  comment varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY backorders_user_id_fk (user_id),
  CONSTRAINT fk_bo_user_id FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;

-- =====================================================================
-- ========================================  components_types
DROP TABLE IF EXISTS components_types;
CREATE TABLE components_types (
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	name varchar(32) NOT NULL,
	units_id TINYINT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY components_types_idx (name),
	CONSTRAINT fk_ctyp_units_id FOREIGN KEY (units_id) REFERENCES unit_types (id)
) ENGINE=InnoDB;

INSERT INTO components_types VALUES
	(1, 'filament', 1),
	(2, 'resin', 1),
	(3, 'fabric', 3),
	(4, 'stuffing', 1),
	(5, 'thread', 2),
	(6, 'foam_rubber', 3),
	(7, 'carton', 4),
	(8, 'thermoglue', 1),
	(9, 'primer', 1),
	(10, 'paint', 1),
	(11, 'varnish', 1),
	(12, 'magnet', 5),
	(13, 'hair', 1),
	(14, 'misc', 5);

-- ========================================  components_examples
DROP TABLE IF EXISTS components_examples;
CREATE TABLE components_examples (
	id int UNSIGNED NOT NULL AUTO_INCREMENT,
	type_id SMALLINT UNSIGNED NOT NULL,
	manuf varchar(32) DEFAULT NULL,
	name varchar(64) NOT NULL,
	color varchar(32) DEFAULT NULL,
	image_id bigint UNSIGNED DEFAULT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY components_examples_idx (manuf, name, color),
	CONSTRAINT fk_cxmpl_type_id FOREIGN KEY (type_id) REFERENCES components_types (id),
	CONSTRAINT fk_cxmpl_image_id FOREIGN KEY (image_id) REFERENCES media (id)
) ENGINE=InnoDB;

INSERT INTO components_examples VALUES
	(NULL, 1, 'Monofilament', 'COPET', 'metallic', DEFAULT),
	(NULL, 1, 'Monofilament', 'COPET', 'gold', DEFAULT),
	(NULL, 2, 'Anycubic', 'Basic', 'white', DEFAULT),
	(NULL, 2, 'Resione', 'M68', 'white', DEFAULT),
	(NULL, 2, 'Resione', 'F39', 'white', DEFAULT),
	(NULL, 3, DEFAULT, 'Nuri', 'purple', DEFAULT),
	(NULL, 3, DEFAULT, 'Nuri', 'milk', DEFAULT),
	(NULL, 3, DEFAULT, 'Velvet', 'red', DEFAULT),
	(NULL, 3, DEFAULT, 'Velur', 'pink', DEFAULT),
	(NULL, 3, DEFAULT, 'Ardic', 'silver', DEFAULT),
	(NULL, 3, DEFAULT, 'Poldi', 'silver', DEFAULT),
	(NULL, 4, DEFAULT, 'Synthetic fluff', DEFAULT, DEFAULT),
	(NULL, 5, 'China', 'Decor 3mm', 'silver', DEFAULT),
	(NULL, 5, 'China', 'Decor 2mm', 'gold', DEFAULT),
	(NULL, 6, DEFAULT, 'Base foam 5mm', DEFAULT, DEFAULT),
	(NULL, 6, DEFAULT, 'Base foam 10mm', DEFAULT, DEFAULT),
	(NULL, 7, DEFAULT, 'Base carton', DEFAULT, DEFAULT),
	(NULL, 8, DEFAULT, 'Thermoglue', 'clear', DEFAULT),
	(NULL, 9, 'Newton', 'Primer', 'grey', DEFAULT),
	(NULL, 10, 'Bosny', 'Paint', 'white', DEFAULT),
	(NULL, 11, 'Newton', 'Varnish', 'clear', DEFAULT),
	(NULL, 5, DEFAULT, 'For knitting', 'bordo', DEFAULT),
	(NULL, 5, DEFAULT, 'elastic 3mm', DEFAULT, DEFAULT),
	(NULL, 12, DEFAULT, '3x1', DEFAULT, DEFAULT),
	(NULL, 12, DEFAULT, '5x2', DEFAULT, DEFAULT),
	(NULL, 13, DEFAULT, 'Рыжие 1', 'red', DEFAULT),
	(NULL, 14, DEFAULT, 'Cord tassel', 'gold', DEFAULT);

-- ========================================  components

DROP TABLE IF EXISTS components;
CREATE TABLE components (
	id bigint UNSIGNED NOT NULL AUTO_INCREMENT,
	comp_examples_id int UNSIGNED NOT NULL,
	amount FLOAT NOT NULL DEFAULT '0',
	storage_id TINYINT UNSIGNED NOT NULL DEFAULT '1',
	source varchar(128) DEFAULT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY comp_examples_idx (comp_examples_id),
	KEY comp_amount_idx (amount),
	KEY comp_source_idx (source),
	CONSTRAINT fk_comp_examples_id FOREIGN KEY (comp_examples_id) REFERENCES components_examples (id),
	CONSTRAINT fk_comp_storage_id FOREIGN KEY (storage_id) REFERENCES warehouses (id)
) ENGINE=InnoDB;

-- =====================================================================
-- ========================================  product_category
DROP TABLE IF EXISTS product_category;
CREATE TABLE product_category (
	id SMALLINT UNSIGNED AUTO_INCREMENT,
	name varchar(16) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY name (name)
) ENGINE=InnoDB;

INSERT INTO product_category VALUES
	(1, 'furniture'), -- мягкая и твердая мебель, подушки, пуфы, ковры
	(2, 'doll_parts'), -- смола, покрытия, дополнительное !в разработке
	(3, 'dresses'), -- ткани, дополнительное !в разработке
	(4, 'wigs'), -- смолы, волосы, магниты !в разработке
	(5, 'other'); -- резерв !в разработке

-- =====================================================================
-- ========================================  product_designs
DROP TABLE IF EXISTS product_designs;
CREATE TABLE product_designs (
	id SMALLINT UNSIGNED AUTO_INCREMENT,
	prod_cat_id SMALLINT UNSIGNED,
	name varchar(16),
	PRIMARY KEY (id),
	UNIQUE KEY prod_cat_idx_name (prod_cat_id, name),
	CONSTRAINT fk_pdsn_prod_cat_id FOREIGN KEY (prod_cat_id) REFERENCES product_category (id)
) ENGINE=InnoDB;

INSERT INTO product_designs VALUES
	(NULL, 1, 'baroque'),
	(NULL, 1, 'classical'),
	(NULL, 2, '1A'),
	(NULL, 2, '2B'),
	(NULL, 3, 'amelie'),
	(NULL, 3, 'antoinette');

-- ========================================  product_types
DROP TABLE IF EXISTS product_types;
CREATE TABLE product_types (
	id SMALLINT UNSIGNED AUTO_INCREMENT,
	prod_cat_id SMALLINT UNSIGNED,
	name varchar(16) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY prod_cat_idx_name (prod_cat_id, name),
	CONSTRAINT fk_ptyp_prod_cat_id FOREIGN KEY (prod_cat_id) REFERENCES product_category (id)
) ENGINE=InnoDB;

INSERT INTO product_types VALUES
	(NULL, 1, 'armchair'),
	(NULL, 1, 'chair'),
	(NULL, 1, 'barstool'),
	(NULL, 1, 'sofa'),
	(NULL, 1, 'table'),
	(NULL, 1, 'stand'),
	(NULL, 1, 'vase_stand'),
	(NULL, 1, 'pillow'),
	(NULL, 1, 'statuette'),
	(NULL, 1, 'fireplace'),
	(NULL, 2, 'face'),
	(NULL, 2, 'head'),
	(NULL, 2, 'upperarm_left'),
	(NULL, 2, 'forearm_left'),
	(NULL, 2, 'hand_open_left');

-- ========================================  product_examples
DROP TABLE IF EXISTS product_examples;
CREATE TABLE product_examples (
	id bigint UNSIGNED AUTO_INCREMENT, -- id of unique template
	prod_cat_id SMALLINT UNSIGNED NOT NULL,
	prod_design_id SMALLINT UNSIGNED NOT NULL,
	prod_type_id SMALLINT UNSIGNED NOT NULL,
	name VARCHAR(64) DEFAULT NULL,
	prod_size TINYINT UNSIGNED NOT NULL,
	SCU VARCHAR(64) NOT NULL,
	image_id bigint UNSIGNED DEFAULT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY SCU (SCU),
	KEY name (name),
	KEY prod_design_idx (prod_design_id),
	KEY prod_type_idx (prod_type_id),
	CONSTRAINT fk_pxmpl_prod_cat_id FOREIGN KEY (prod_cat_id) REFERENCES product_category (id),
	CONSTRAINT fk_pxmpl_prod_design_id FOREIGN KEY (prod_design_id) REFERENCES product_designs (id),
	CONSTRAINT fk_pxmpl_prod_type_id FOREIGN KEY (prod_type_id) REFERENCES product_types (id),
	CONSTRAINT fk_pxmpl_image_id FOREIGN KEY (image_id) REFERENCES media (id)
) ENGINE=InnoDB;

-- ========================================  product_components (crossection with values)
DROP TABLE IF EXISTS product_components;
CREATE TABLE product_components (
	prod_xmpl_id bigint UNSIGNED NOT NULL, -- link to xmpl
	prod_comp_xmpl_id int UNSIGNED NOT NULL, -- link to component example
	prod_comp_amount FLOAT NOT NULL,         -- component amount
	PRIMARY KEY (prod_xmpl_id, prod_comp_xmpl_id),
	CONSTRAINT fk_ptmp_prod_xmpl_id FOREIGN KEY (prod_xmpl_id) REFERENCES product_examples (id),
	CONSTRAINT fk_ptmp_prod_comp_xmpl_id FOREIGN KEY (prod_comp_xmpl_id) REFERENCES components_examples (id)
) ENGINE=InnoDB;

INSERT INTO product_examples VALUES (1, 1, 1, 2, 'Доминион', 4, 'CLFRARWTNRMK4', NULL);
INSERT INTO product_components VALUES
	(1, 1, 160), (1, 3, 70), (1, 7, 0.8),
	(1, 12, 5), (1, 13, 1), (1, 16, 0.5),
	(1, 17, 0.4), (1, 18, 50), (1, 19, 20),
	(1, 20, 15), (1, 21, 15);
INSERT INTO product_examples VALUES (2, 1, 2, 1, 'Людвиг', 4, 'BQFRTLWTPDSR', NULL);
INSERT INTO product_components VALUES
	(2, 1, 160), (2, 3, 70), (2, 7, 0.8),
	(2, 12, 5), (2, 13, 1), (2, 16, 0.5),
	(2, 17, 0.4), (2, 18, 50), (2, 19, 20),
	(2, 20, 15), (2, 21, 15);
INSERT INTO product_examples VALUES (3, 1, 1, 10, 'Камин виноград', 4, 'BQFRFCWTPDSR', NULL);
INSERT INTO product_components VALUES
	(3, 1, 160), (3, 3, 70), (3, 18, 50), (3, 19, 20),
	(3, 20, 15), (3, 21, 15);
INSERT INTO product_examples VALUES (4, 1, 1, 9, 'Виолетта', 4, 'BQFRSTWTXXXX', NULL);
INSERT INTO product_components VALUES
	(4, 1, 160), (4, 3, 70), (4, 18, 50), (4, 21, 15);

-- ========================================  products
DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id bigint UNSIGNED AUTO_INCREMENT, -- id of unique product
	prod_xmpl_id bigint UNSIGNED NOT NULL,
	readiness bool NOT NULL DEFAULT 0,
	backorder_id bigint UNSIGNED DEFAULT NULL,
	comentary varchar(128) DEFAULT NULL,
	storage_id TINYINT UNSIGNED NOT NULL DEFAULT '1',
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY prod_xmpl_idx (prod_xmpl_id),
	KEY prod_readiness_idx (readiness),
	KEY prod_backorder_idx (backorder_id),
	KEY prod_storage_idx (storage_id),
	KEY prod_created_atx (created_at),
	CONSTRAINT fk_prod_xmpl_id FOREIGN KEY (prod_xmpl_id) REFERENCES product_examples (id),
 	CONSTRAINT fk_prod_backorder_id FOREIGN KEY (backorder_id) REFERENCES backorders (id),
	CONSTRAINT fk_prod_storage_id FOREIGN KEY (storage_id) REFERENCES warehouses (id)
) ENGINE=InnoDB;


SET FOREIGN_KEY_CHECKS = 1;
-- =====================================================================
-- ========================================  logger with triggers


DROP TABLE IF EXISTS income_log;
CREATE TABLE income_log (
	logged_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(255) NOT NULL,
	p_key VARCHAR(255) NOT NULL,
	name VARCHAR(255)
) ENGINE=Archive;

DROP TRIGGER IF EXISTS log_users_on_insert;
DROP TRIGGER IF EXISTS log_components_on_insert;
DROP TRIGGER IF EXISTS log_products_on_insert;

DELIMITER //
CREATE TRIGGER log_users_on_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO income_log VALUES (NEW.created_at, 'users', NEW.id, NEW.nick_name);
END//

CREATE TRIGGER log_components_on_insert AFTER INSERT ON components
FOR EACH ROW
BEGIN
    INSERT INTO income_log VALUES (NEW.created_at, 'components', NEW.id, NEW.comp_examples_id);
END//

CREATE TRIGGER log_products_on_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO income_log VALUES (NEW.created_at, 'products', NEW.id,
		(SELECT pe.name name FROM product_examples pe WHERE pe.id = NEW.prod_xmpl_id));
END//
DELIMITER ;

-- ========================================  add products after log on
INSERT INTO products VALUES
	(NULL, 1, 1, DEFAULT, 'Legendary', 1, DEFAULT),
	(NULL, 1, 0, DEFAULT, DEFAULT, 1, DEFAULT),
	(NULL, 2, 1, DEFAULT, DEFAULT, 1, DEFAULT),
	(NULL, 1, 1, DEFAULT, 'С позолотой', 1, DEFAULT),
	(NULL, 2, 1, DEFAULT, DEFAULT, 1, DEFAULT),
	(NULL, 3, 1, DEFAULT, 'Бронь Monique24', 1, DEFAULT),
	(NULL, 4, 1, DEFAULT, 'Бронь Matias Finki', 1, DEFAULT),
	(NULL, 4, 1, DEFAULT, DEFAULT, 1, DEFAULT),
	(NULL, 4, 0, DEFAULT, DEFAULT, 1, DEFAULT);

-- ================================================== Представления =====
-- ========================================  VIEW show all added products examples
CREATE OR REPLACE VIEW show_all_product_examples AS
SELECT pe.id id, product.name product, design.name design, kind.name kind, pe.name name,
	pe.SCU ___SCU___
FROM product_examples pe
LEFT JOIN product_category as product on product.id = pe.prod_cat_id
LEFT JOIN product_designs as design on design.id = pe.prod_design_id
LEFT JOIN product_types as kind on kind.id = pe.prod_type_id
ORDER BY kind;

-- ========================================  VIEV show all products in stock
CREATE OR REPLACE VIEW show_all_products_in_stock AS
SELECT safe.*, (select if(pr.readiness, 'Ready', 'Not')) ready, pr.backorder_id bk_order, pr.comentary comentary, pr.created_at
FROM products pr
LEFT JOIN show_all_product_examples safe ON safe.id = pr.prod_xmpl_id
ORDER BY kind;
-- ========================================  VIEW show unready products in stock
CREATE OR REPLACE VIEW show_unready_products_in_stock AS
SELECT safe.*, (select if(pr.readiness, 'Ready', 'Not')) ready, pr.backorder_id bk_order, pr.comentary comentary, pr.created_at
FROM products pr
LEFT JOIN show_all_product_examples safe ON safe.id = pr.prod_xmpl_id
WHERE readiness = 0
ORDER BY kind;
-- ================================================== Запросы =====
-- ========================================  show all added products examples
SELECT * FROM show_all_product_examples;

-- ========================================  show all products in stock
SELECT * FROM show_all_products_in_stock;

-- ========================================  show unready products in stock
SELECT * FROM show_unready_products_in_stock;

-- ========================================  show log
SELECT * FROM income_log;

