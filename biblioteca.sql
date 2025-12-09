-- Base de datos para sistema de biblioteca
CREATE DATABASE biblioteca;
USE biblioteca;

-- Tabla de autores
CREATE TABLE autores (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  fecha_nacimiento DATE,
  nacionalidad VARCHAR(50),
  biografia TEXT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_autor (nombre, apellido)
);

-- Tabla de categorías
CREATE TABLE categorias (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  descripcion TEXT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de libros
CREATE TABLE libros (
  id INT PRIMARY KEY AUTO_INCREMENT,
  titulo VARCHAR(200) NOT NULL,
  isbn VARCHAR(20) UNIQUE,
  autor_id INT NOT NULL,
  categoria_id INT,
  editorial VARCHAR(100),
  anio_publicacion YEAR,
  numero_paginas INT,
  descripcion TEXT,
  precio DECIMAL(8,2),
  stock INT DEFAULT 0,
  disponible BOOLEAN DEFAULT TRUE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (autor_id) REFERENCES autores(id) ON DELETE CASCADE,
  FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL,
  
  INDEX idx_titulo (titulo),
  INDEX idx_autor (autor_id),
  INDEX idx_categoria (categoria_id),
  INDEX idx_disponible (disponible)
);

-- Tabla de usuarios/socios
CREATE TABLE usuarios (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  telefono VARCHAR(20),
  direccion TEXT,
  fecha_nacimiento DATE,
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  activo BOOLEAN DEFAULT TRUE,
  
  INDEX idx_email (email),
  INDEX idx_activo (activo)
);

-- Tabla de préstamos
CREATE TABLE prestamos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario_id INT NOT NULL,
  libro_id INT NOT NULL,
  fecha_prestamo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_devolucion_esperada DATE NOT NULL,
  fecha_devolucion_real DATE NULL,
  estado ENUM('activo', 'devuelto', 'atrasado', 'perdido') DEFAULT 'activo',
  multa DECIMAL(6,2) DEFAULT 0.00,
  notas TEXT,
  
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (libro_id) REFERENCES libros(id) ON DELETE CASCADE,
  
  INDEX idx_usuario (usuario_id),
  INDEX idx_libro (libro_id),
  INDEX idx_estado (estado),
  INDEX idx_fecha_prestamo (fecha_prestamo)
);

-- Insertar datos de ejemplo
INSERT INTO categorias (nombre, descripcion) VALUES
('Ficción', 'Novelas y relatos de ficción'),
('No Ficción', 'Libros basados en hechos reales'),
('Ciencia', 'Libros científicos y técnicos'),
('Historia', 'Libros de historia'),
('Biografías', 'Vidas de personajes históricos');

INSERT INTO autores (nombre, apellido, fecha_nacimiento, nacionalidad) VALUES
('Gabriel', 'García Márquez', '1927-03-06', 'Colombiano'),
('Isabel', 'Allende', '1942-08-02', 'Chilena'),
('Julio', 'Cortázar', '1914-08-26', 'Argentino');

INSERT INTO libros (titulo, isbn, autor_id, categoria_id, editorial, anio_publicacion, numero_paginas, precio, stock) VALUES
('Cien años de soledad', '978-84-376-0494-7', 1, 1, 'Editorial Sudamericana', 1967, 417, 25.99, 5),
('La casa de los espíritus', '978-84-204-3246-6', 2, 1, 'Plaza & Janés', 1982, 352, 22.50, 3),
('Rayuela', '978-84-339-6725-9', 3, 1, 'Editorial Sudamericana', 1963, 736, 28.75, 2);

INSERT INTO usuarios (nombre, apellido, email, telefono) VALUES
('María', 'González', 'maria@example.com', '+34 600 123 456'),
('Carlos', 'Rodríguez', 'carlos@example.com', '+34 600 654 321'),
('Ana', 'Martínez', 'ana@example.com', '+34 600 987 654');

-- Consultas útiles
SELECT 
  l.titulo,
  CONCAT(a.nombre, ' ', a.apellido) as autor,
  c.nombre as categoria,
  l.stock,
  l.disponible
FROM libros l
JOIN autores a ON l.autor_id = a.id
LEFT JOIN categorias c ON l.categoria_id = c.id;

SELECT 
  u.nombre,
  u.apellido,
  COUNT(p.id) as total_prestamos,
  COUNT(CASE WHEN p.estado = 'activo' THEN 1 END) as prestamos_activos
FROM usuarios u
LEFT JOIN prestamos p ON u.id = p.usuario_id
GROUP BY u.id, u.nombre, u.apellido;