/* 
Ejercicio: Diseña el esquema de base de datos para un sistema de e-commerce que incluya: 
-  usuarios, 
-  productos, 
-  categorías, 
-  pedidos, 
-  detalles de pedidos, 
-  direcciones de envío, 
-  métodos de pago, y 
- reseñas de productos. 
Asegúrate de que esté en tercera forma normal.
*/

CREATE DATABASE IF NOT EXISTS ecommerce;
use ecommerce;

CREATE TABLE IF NOT EXISTS direcciones_envio (
	id INT PRIMARY KEY AUTO_INCREMENT,
    calle VARCHAR(255) not null,
    numero INT COMMENT "Número de departamento (opcional)",
    depto VARCHAR(5) COMMENT "Número o letra de departamento (opcional)",
    fecha_creacion DATETIME DEFAULT now(),
    fecha_actualizacion DATETIME DEFAULT now(),
    fecha_eliminacion DATETIME DEFAULT NULL	COMMENT "Uso para softdelete"
);

CREATE TABLE IF NOT EXISTS usuarios (
	id INT PRIMARY KEY, 
    rut VARCHAR(12) NOT NULL COMMENT "Ej.: 11.222.333-4",
	nombre varchar(20) NOT NULL,
    apellidos varchar(30) NOT NULL,
    email VARCHAR(255),
    fono VARCHAR(20) COMMENT "Incluye sumbolos cómo + o () Ej.: +56 9 123456789 ó (56 9) 123456789",    
    fecha_creacion DATETIME DEFAULT now(),
    fecha_actualizacion DATETIME DEFAULT now(),
    fecha_eliminacion DATETIME DEFAULT NULL	COMMENT "Uso para softdelete"
);

CREATE TABLE IF NOT EXISTS usuarios_direcciones_envios (
	id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    direccion_envio_id INT,
    CONSTRAINT fk_usuario_direcciones
		FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON DELETE NO ACTION,
	CONSTRAINT fk_direcciones_usuarios 
		FOREIGN KEY (direccion_envio_id) 
        REFERENCES direcciones_envio(id)
        ON DELETE NO ACTION
);


CREATE TABLE IF NOT EXISTS categorias (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    fecha_creacion DATETIME DEFAULT now(),
    fecha_actualizacion DATETIME DEFAULT now(),
    fecha_eliminacion DATETIME DEFAULT NULL	COMMENT "Uso para softdelete"
);

CREATE TABLE IF NOT EXISTS productos (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    descripción TEXT NOT NULL,
    precio DECIMAL(8,2)  NOT NULL,
    stock INT UNSIGNED NOT NULL,
    peso FLOAT,
    fecha_creacion DATETIME DEFAULT now(),
    fecha_actualizacion DATETIME DEFAULT now(),
    fecha_eliminacion DATETIME DEFAULT NULL	COMMENT "Uso para softdelete"    
);

CREATE TABLE IF NOT EXISTS productos_categorias (
	id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    categorias_id INT NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (categorias_id) REFERENCES categorias(id)
);



CREATE TABLE IF NOT EXISTS metodos_pago (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nombre ENUM("Efectivo", "Crédito", "Dévito") DEFAULT "Efectivo",
    fecha_creacion DATETIME DEFAULT now(),
    fecha_actualizacion DATETIME DEFAULT now(),
    fecha_eliminacion DATETIME DEFAULT NULL	COMMENT "Uso para softdelete" 
);

CREATE TABLE IF NOT EXISTS pedidos (
	id INT PRIMARY KEY AUTO_INCREMENT,    
    fecha DATETIME DEFAULT now(),
    metodos_pago_id INT NOT NULL,
    CONSTRAINT fk_pedidos_metodos_pago FOREIGN KEY(metodos_pago_id) REFERENCES metodos_pago(id) ON DELETE NO ACTION,
    fecha_anulacion DATETIME DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS detalle_pedidos (
    pedidos_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT UNSIGNED NOT NULL,
    precio_venta DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (pedidos_id, producto_id), 
    CONSTRAINT fk_detalle_pedidos_pedidos FOREIGN KEY (pedidos_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_pedidos_productos FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS resenas_productos (
	id INT PRIMARY KEY AUTO_INCREMENT,
    usuarios_id INT NOT NULL,
    pedidos_id INT NOT NULL COMMENT "Campo de la clave primaria compuesta de la tabla detalle_pedidos",
    producto_id INT NOT NULL COMMENT "Campo de la clave primaria compuesta de la tabla detalle_pedidos",
    resena TEXT NOT NULL,
    estrellas INT CHECK (estrellas > 0 and estrellas < 6),
    fecha_creacion DATETIME DEFAULT now(),
    fecha_actualizacion DATETIME DEFAULT now(),
    CONSTRAINT fk_resenas_productos_usuarios FOREIGN KEY (usuarios_id) REFERENCES usuarios(id),
    CONSTRAINT fk_resenas_productos_detalle_pedidos FOREIGN KEY (pedidos_id, producto_id) REFERENCES detalle_pedidos(pedidos_id, producto_id) -- Ejemplo de clave foranea compuesta apuntando a la tabla detalle_pedidos
);







