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
  CONSTRAINT fk_media_media_types FOREIGN KEY (media_types_id) REFERENCES media_types (id)
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
	CONSTRAINT fk_pr_profiles_users FOREIGN KEY (user_id) REFERENCES users (id),
	CONSTRAINT fk_pr_profiles_photo FOREIGN KEY (photo_id) REFERENCES media (id)
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
	CONSTRAINT fk_ct_units_id FOREIGN KEY (units_id) REFERENCES unit_types (id)
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
	CONSTRAINT fk_ce_type_id FOREIGN KEY (type_id) REFERENCES components_types (id),
	CONSTRAINT fk_ce_image_id FOREIGN KEY (image_id) REFERENCES media (id)
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
-- ========================================  product_types
DROP TABLE IF EXISTS product_types;
CREATE TABLE product_types (
	id TINYINT UNSIGNED AUTO_INCREMENT,
	name varchar(16) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY name (name)
) ENGINE=InnoDB;

INSERT INTO product_types VALUES
	(1, 'furniture'), -- мягкая и твердая мебель, подушки, пуфы, ковры
	(2, 'doll_parts'), -- смола, покрытия, дополнительное !в разработке
	(3, 'dresses'), -- ткани, дополнительное !в разработке
	(4, 'wigs'), -- смолы, волосы, магниты !в разработке
	(5, 'other'); -- резерв !в разработке
	
-- =====================================================================
-- ========================================  furniture_designs
DROP TABLE IF EXISTS furniture_designs;
CREATE TABLE furniture_designs (
	id TINYINT UNSIGNED AUTO_INCREMENT,
	name varchar(16),
	PRIMARY KEY (id),
	UNIQUE KEY name (name)
) ENGINE=InnoDB;

INSERT INTO furniture_designs VALUES
	(NULL, 'baroque'),
	(NULL, 'classical');

-- ========================================  furniture_types
DROP TABLE IF EXISTS furniture_types;
CREATE TABLE furniture_types (
	id SMALLINT UNSIGNED AUTO_INCREMENT,
	name varchar(16) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY name (name)
) ENGINE=InnoDB;

INSERT INTO furniture_types VALUES
	(NULL, 'armchair'),
	(NULL, 'chair'),
	(NULL, 'barstool'),
	(NULL, 'sofa'),
	(NULL, 'table'),
	(NULL, 'stand'),
	(NULL, 'vase_stand'),
	(NULL, 'pillow'),
	(NULL, 'statuette'),
	(NULL, 'fireplace');

-- ========================================  furniture_examples
DROP TABLE IF EXISTS furniture_examples;
CREATE TABLE furniture_examples (
	id bigint UNSIGNED AUTO_INCREMENT,
	prod_type_id TINYINT UNSIGNED NOT NULL,
	furn_design_id TINYINT UNSIGNED NOT NULL,
	furn_type_id SMALLINT UNSIGNED NOT NULL,
	name VARCHAR(64) DEFAULT NULL,
	SCU VARCHAR(64) NOT NULL,
	comp_filament int UNSIGNED DEFAULT NULL,
	comp_filament_amount FLOAT NOT NULL DEFAULT '0',
	comp_resin int UNSIGNED DEFAULT NULL,
	comp_resin_amount FLOAT NOT NULL DEFAULT '0',
	comp_fabric int UNSIGNED DEFAULT NULL,
	comp_fabric_amount FLOAT NOT NULL DEFAULT '0',
	comp_stuffing int UNSIGNED DEFAULT NULL,
	comp_stuffing_amount FLOAT NOT NULL DEFAULT '0',
	comp_cord int UNSIGNED DEFAULT NULL,
	comp_cord_amount FLOAT NOT NULL DEFAULT '0',
	comp_foam_rubber int UNSIGNED DEFAULT NULL,
	comp_foam_rubber_amount FLOAT NOT NULL DEFAULT '0',
	comp_carton int UNSIGNED DEFAULT NULL,
	comp_carton_amount FLOAT NOT NULL DEFAULT '0',
	comp_thermoglue int UNSIGNED DEFAULT NULL,
	comp_thermoglue_amount FLOAT NOT NULL DEFAULT '0',
	comp_primer int UNSIGNED DEFAULT NULL,
	comp_primer_amount FLOAT NOT NULL DEFAULT '0',
	comp_paint int UNSIGNED DEFAULT NULL,
	comp_paint_amount FLOAT NOT NULL DEFAULT '0',
	comp_varnish int UNSIGNED DEFAULT NULL,
	comp_varnish_amount FLOAT NOT NULL DEFAULT '0',
	comp_accessory_1 int UNSIGNED DEFAULT NULL,
	comp_accessory_1_amount FLOAT NOT NULL DEFAULT '0',
	comp_accessory_2 int UNSIGNED DEFAULT NULL,
	comp_accessory_2_amount FLOAT NOT NULL DEFAULT '0',
	comp_accessory_3 int UNSIGNED DEFAULT NULL,
	comp_accessory_3_amount FLOAT NOT NULL DEFAULT '0',
	PRIMARY KEY (id),
	UNIQUE KEY SCU (SCU),
	KEY name (name),
	KEY furn_design_idx (furn_design_id),
	KEY furn_type_idx (furn_type_id),
	CONSTRAINT fk_fe_prod_type_id FOREIGN KEY (prod_type_id) REFERENCES product_types (id),
	CONSTRAINT fk_fe_furn_design_id FOREIGN KEY (furn_design_id) REFERENCES furniture_designs (id),
	CONSTRAINT fk_fe_furn_type_id FOREIGN KEY (furn_type_id) REFERENCES furniture_types (id),
	CONSTRAINT fk_fe_comp_filament FOREIGN KEY (comp_filament) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_resin FOREIGN KEY (comp_resin) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_fabric FOREIGN KEY (comp_fabric) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_stuffing FOREIGN KEY (comp_stuffing) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_cord FOREIGN KEY (comp_cord) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_foam_rubber FOREIGN KEY (comp_foam_rubber) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_carton FOREIGN KEY (comp_carton) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_thermoglue FOREIGN KEY (comp_thermoglue) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_primer FOREIGN KEY (comp_primer) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_paint FOREIGN KEY (comp_paint) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_varnish FOREIGN KEY (comp_varnish) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_accessory_1 FOREIGN KEY (comp_accessory_1) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_accessory_2 FOREIGN KEY (comp_accessory_2) REFERENCES components_examples (id),
	CONSTRAINT fk_fe_comp_accessory_3 FOREIGN KEY (comp_accessory_3) REFERENCES components_examples (id)
) ENGINE=InnoDB;

INSERT INTO furniture_examples VALUES
	(NULL, 1, 1, 2, 'Доминион 1/4', 'CLFRARWTNRMK',
		1, 0.1, NULL, 0, 7, 0.3, 12, 0.02, 13, 0.8, 16, 0.05, 17, 3, 18, 5,
		19, 0.05, 20, 0.05, 21, 0.05, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
	(NULL, 1, 2, 1, 'Людвик 1/4', 'BQFRTLWTPDSR',
		2, 0.2, NULL, 0, 11, 0.3, 12, 0.02, 13, 0.9, 16, 0.06, 17, 3, 18, 5,
		19, 0.05, 20, 0.05, 21, 0.05, 27, 1, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
	(NULL, 1, 1, 10, 'Камин виноград 1/4', 'BQFRFCWTPDSR',
		2, 0.2, NULL, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 18, 5,
		19, 0.05, 20, 0.05, 21, 0.05, 27, 1, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
	(NULL, 1, 1, 9, 'Виолетта 1/4', 'BQFRSTWTXXXX',
		DEFAULT, DEFAULT, 3, 0.02, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
		DEFAULT, DEFAULT, 20, DEFAULT, 21, 0.05, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

-- ========================================  furniture
DROP TABLE IF EXISTS furniture;
CREATE TABLE furniture (
	id bigint UNSIGNED AUTO_INCREMENT,
	example_id bigint UNSIGNED NOT NULL,
	readiness bool NOT NULL DEFAULT 0,
	backorder_id bigint UNSIGNED DEFAULT NULL,
	comentary varchar(128) DEFAULT NULL,
	storage_id TINYINT UNSIGNED NOT NULL DEFAULT '1',
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY example_id (example_id),
	KEY furn_readiness_idx (readiness),
	KEY furn_backorder_idx (backorder_id),
	KEY furn_created_atx (created_at),
 	CONSTRAINT fk_furn_backorder_id FOREIGN KEY (backorder_id) REFERENCES backorders (id),
	CONSTRAINT fk_furn_storage_id FOREIGN KEY (storage_id) REFERENCES warehouses (id),
	CONSTRAINT fk_furn_examples_id FOREIGN KEY (example_id) REFERENCES furniture_examples (id)
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
DROP TRIGGER IF EXISTS log_furniture_on_insert;

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

CREATE TRIGGER log_furniture_on_insert AFTER INSERT ON furniture
FOR EACH ROW
BEGIN
	INSERT INTO income_log VALUES (NEW.created_at, 'furniture', NEW.id, 
		(SELECT fe.name name FROM furniture_examples fe WHERE fe.id = NEW.example_id));
END//
DELIMITER ;

-- ========================================  add furn after log on
INSERT INTO furniture VALUES
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
-- ========================================  VIEV show all added furniture examples
CREATE OR REPLACE VIEW show_all_furniture_examples AS
SELECT fe.id id, product.name product, design.name design, kind.name kind, fe.name name,
	color.color color, concat(fabric.name,' ', fabric.color) fabric, fe.SCU ___SCU___
FROM furniture_examples fe
LEFT JOIN product_types as product on product.id = fe.prod_type_id
LEFT JOIN furniture_designs as design on design.id = fe.furn_design_id
LEFT JOIN furniture_types as kind on kind.id = fe.furn_type_id
LEFT JOIN components_examples as color on color.id = fe.comp_paint
LEFT JOIN components_examples as fabric on fabric.id = fe.comp_fabric ORDER BY kind;
-- ========================================  VIEV show all furniture in stock
CREATE OR REPLACE VIEW show_all_furniture_in_stock AS
SELECT safe.*, (select if(fu.readiness, 'Ready', 'Not')) ready, fu.backorder_id bk_order, fu.comentary comentary, fu.created_at
FROM furniture fu
LEFT JOIN show_all_furniture_examples safe ON safe.id = fu.example_id
ORDER BY kind;
-- ========================================  VIEV show unready products in stock
CREATE OR REPLACE VIEW show_unready_products_in_stock AS
SELECT safe.*, (select if(fu.readiness, 'Ready', 'Not')) ready, fu.backorder_id bk_order, fu.comentary comentary, fu.created_at
FROM furniture fu
LEFT JOIN show_all_furniture_examples safe ON safe.id = fu.example_id
WHERE readiness = 0
ORDER BY kind;
-- ================================================== Запросы =====
-- ========================================  show all added furniture examples
SELECT * FROM show_all_furniture_examples;

-- ========================================  show all furniture in stock
SELECT * FROM show_all_furniture_in_stock;

-- ========================================  show unready products in stock
SELECT * FROM show_unready_products_in_stock;

-- ========================================  show log
SELECT * FROM income_log;


