-- Base de Datos
--CREATE DATABASE Blogch;

-- USE Blogch;

-- Tabla Roles
CREATE TABLE Roles (
    Rol_id INT PRIMARY KEY IDENTITY(1,1), 
    Nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla Categorías
CREATE TABLE Categorias (
    Categoria_id INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla Etiquetas
CREATE TABLE Etiquetas (
    Etiqueta_id INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla Subcategorías
CREATE TABLE Subcategorias (
    Subcategoria_id INT PRIMARY KEY IDENTITY(1,1),
    Categoria_id INT,
    Nombre VARCHAR(100) NOT NULL,
    FOREIGN KEY (Categoria_id) REFERENCES Categorias(Categoria_id)
);
CREATE INDEX idx_categoria_id ON Subcategorias (Categoria_id);

-- Tabla Páginas
CREATE TABLE Paginas (
    Pagina_id INT PRIMARY KEY IDENTITY(1,1),
    Titulo VARCHAR(150) NOT NULL,
    Contenido NVARCHAR(MAX),
    Fecha_Creacion DATETIME DEFAULT GETDATE()
);

-- Tabla Usuarios
CREATE TABLE Usuarios( 
    Usuario_id INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Usuario VARCHAR(150) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE, 
    Clave VARCHAR(50) NOT NULL, 
    Rol_id INT, 
    Notificaciones BIT DEFAULT 1, 
    Fecha_Creacion DATETIME DEFAULT GETDATE(), 
    Avatar VARCHAR(255),
    FOREIGN KEY (Rol_id) REFERENCES Roles (Rol_id)
);
CREATE INDEX idx_email ON Usuarios (Email);

-- Tabla Publicaciones
CREATE TABLE Publicaciones (
    Publicacion_id INT PRIMARY KEY IDENTITY(1,1),
    Titulo VARCHAR(200) NOT NULL,
    URLSlug VARCHAR(255) NOT NULL UNIQUE,
    Contenido NVARCHAR(MAX) NOT NULL,
    Imagen_Destacada VARCHAR(255),
    Fecha_Publicacion DATETIME DEFAULT GETDATE(),
    Usuario_id INT,
    Categoria_id INT,
    Subcategoria_id INT,
    FOREIGN KEY (Usuario_id) REFERENCES Usuarios (Usuario_id),
    FOREIGN KEY (Categoria_id) REFERENCES Categorias (Categoria_id),
    FOREIGN KEY (Subcategoria_id) REFERENCES Subcategorias (Subcategoria_id)
);
CREATE INDEX idx_usuario_id ON Publicaciones (Usuario_id);
CREATE INDEX idx_categoria_subcategoria ON Publicaciones (Categoria_id, Subcategoria_id);

-- Tabla Publicación Etiquetas
CREATE TABLE PublicacionEtiquetas (
    Publicacion_id INT,
    Etiqueta_id INT,
    FOREIGN KEY (Publicacion_id) REFERENCES Publicaciones(Publicacion_id),
    FOREIGN KEY (Etiqueta_id) REFERENCES Etiquetas(Etiqueta_id),
    PRIMARY KEY (Publicacion_id, Etiqueta_id)
);

-- Tabla Comentarios
CREATE TABLE Comentarios (
    Comentario_id INT PRIMARY KEY IDENTITY(1,1),
    Texto VARCHAR(1000) NOT NULL,
    Fecha_Creacion DATETIME DEFAULT GETDATE(),
    Usuario_id INT,
    Publicacion_id INT,
    ParentCommentId INT NULL,
    FOREIGN KEY (Usuario_id) REFERENCES Usuarios (Usuario_id),
    FOREIGN KEY (Publicacion_id) REFERENCES Publicaciones (Publicacion_id),
    FOREIGN KEY (ParentCommentId) REFERENCES Comentarios (Comentario_id)
);

-- Tabla Archivos
CREATE TABLE Archivos(
    Archivo_id INT PRIMARY KEY IDENTITY (1,1),
    Publicacion_id INT,
    Tipo VARCHAR(50),
    URL VARCHAR(255) NOT NULL,
    FOREIGN KEY (Publicacion_id) REFERENCES Publicaciones (Publicacion_id)
);

-- Tabla Configuraciones
CREATE TABLE Configuraciones ( 
    Configuracion_id INT PRIMARY KEY IDENTITY (1,1),
    Titulo VARCHAR(200),
    Descripcion TEXT,
    Logo VARCHAR(255), 
    D_ImagenDestacada VARCHAR(50), 
    Imagen_Ancho INT, 
    Imagen_Alto INT
);

-- Tabla Menús
CREATE TABLE Menus (
    MenuId INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    URL VARCHAR(255),
    Orden INT NOT NULL,
    ParentMenuId INT NULL,
    FOREIGN KEY (ParentMenuId) REFERENCES Menus(MenuId)
);

-- Tabla Me Gusta Publicaciones
CREATE TABLE MeGusta_Publicaciones (
    MeGusta_id INT PRIMARY KEY IDENTITY(1,1),
    Publicacion_id INT,
    Usuario_id INT,
    MeGusta BIT NOT NULL,
    FOREIGN KEY (Publicacion_id) REFERENCES Publicaciones (Publicacion_id),
    FOREIGN KEY (Usuario_id) REFERENCES Usuarios (Usuario_id)
);
CREATE INDEX idx_publicacion_usuario ON MeGusta_Publicaciones (Publicacion_id, Usuario_id);

-- Tabla Me Gusta Comentarios
CREATE TABLE MeGusta_Comentarios (
    MeGusta_id INT PRIMARY KEY IDENTITY(1,1),
    Comentario_id INT,
    Usuario_id INT,
    MeGusta BIT NOT NULL,
    FOREIGN KEY (Comentario_id) REFERENCES Comentarios (Comentario_id),
    FOREIGN KEY (Usuario_id) REFERENCES Usuarios (Usuario_id)
);

-- Inserciones iniciales
INSERT INTO Roles (Nombre) VALUES ('Lector'), ('Autor'), ('Admin'), ('Editor');
INSERT INTO Categorias (Nombre) VALUES ('Tecnología'), ('Salud'), ('Viajes');
INSERT INTO Subcategorias (Categoria_id, Nombre) VALUES 
(1, 'Programación'), (1, 'Gadgets'),
(2, 'Nutrición'), (2, 'Ejercicio'),
(3, 'Aventura'), (3, 'Relax');
INSERT INTO Configuraciones (Titulo, Descripcion, Logo, D_ImagenDestacada, Imagen_Ancho, Imagen_Alto)
VALUES ('Configuración General', 'Descripción de la configuración general', 'logo_general.png', 'imagen_destacada_general.jpg', 800, 300);
