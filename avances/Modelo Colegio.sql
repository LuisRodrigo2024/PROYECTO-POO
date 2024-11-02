IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'BDCOLEGIO')
    CREATE DATABASE BDCOLEGIO;
GO

USE BDCOLEGIO;
GO

-- Tabla Usuario
CREATE TABLE Usuario (
    ID_Usuario INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Usuario VARCHAR(50) UNIQUE NOT NULL,
    Contrasena VARCHAR(255) NOT NULL,
    Rol VARCHAR(20) CHECK (Rol IN ('director', 'subdirector', 'profesor', 'administrativo', 'superadmin')),
    Correo_Electronico VARCHAR(100),
    Ultimo_Acceso DATETIME,
    Estado_Activo BIT DEFAULT 1
);

-- Tabla Anio
CREATE TABLE Anio (
    ID_Anio INT PRIMARY KEY,
    Fecha_Inicio DATE,
    Fecha_Fin DATE
);

-- Tabla Grado (sin vacantes, estas están en la tabla Seccion)
CREATE TABLE Grado (
    ID_Grado INT PRIMARY KEY IDENTITY(1,1),
    Numero_Grado INT NOT NULL,
    Nivel VARCHAR(10) CHECK (Nivel IN ('Primaria', 'Secundaria'))
);

-- Tabla Estudiante
CREATE TABLE Estudiante (
    ID_Estudiante INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL
);

-- Tabla Curso, que depende de Grado
CREATE TABLE Curso (
    ID_Curso INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Curso VARCHAR(100) NOT NULL,
    ID_Grado INT,
    FOREIGN KEY (ID_Grado) REFERENCES Grado(ID_Grado)
);

-- Tabla Seccion, que depende de Grado y Anio
CREATE TABLE Seccion (
    ID_Seccion INT PRIMARY KEY IDENTITY(1,1),
    ID_Anio INT,
    ID_Grado INT,
    Nombre_Seccion VARCHAR(10) NOT NULL,
    Vacantes_Disponibles INT,
    Vacantes_Ocupadas INT,
    FOREIGN KEY (ID_Anio) REFERENCES Anio(ID_Anio),
    FOREIGN KEY (ID_Grado) REFERENCES Grado(ID_Grado)
);

-- Tabla Matricula, que conecta Estudiante con Seccion y Anio
CREATE TABLE Matricula (
    ID_Matricula INT PRIMARY KEY IDENTITY(1,1),
    ID_Estudiante INT,
    ID_Seccion INT,
    Fecha_Matricula DATE,
    Estado_Matricula VARCHAR(10) CHECK (Estado_Matricula IN ('Activo', 'Retirado')),
    FOREIGN KEY (ID_Estudiante) REFERENCES Estudiante(ID_Estudiante),
    FOREIGN KEY (ID_Seccion) REFERENCES Seccion(ID_Seccion)
);

-- Tabla Profesor
CREATE TABLE Profesor (
    ID_Profesor INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    DNI VARCHAR(15) NOT NULL,
    Correo_Electronico VARCHAR(100),
    Telefono VARCHAR(15),
    Direccion VARCHAR(100)
);

-- Tabla Seccion_Curso, que conecta Seccion, Curso y Profesor
CREATE TABLE Seccion_Curso (
    ID_Asignacion INT PRIMARY KEY IDENTITY(1,1),
    ID_Seccion INT,
    ID_Curso INT,
    ID_Profesor INT,
    FOREIGN KEY (ID_Seccion) REFERENCES Seccion(ID_Seccion),
    FOREIGN KEY (ID_Curso) REFERENCES Curso(ID_Curso),
    FOREIGN KEY (ID_Profesor) REFERENCES Profesor(ID_Profesor)
);

-- Tabla Horario, que depende de la asignación de Seccion_Curso
CREATE TABLE Horario (
    ID_Horario INT PRIMARY KEY IDENTITY(1,1),
    ID_Asignacion INT,
    Dia VARCHAR(10) CHECK (Dia IN ('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes')),
    Hora_Inicio TIME,
    Hora_Fin TIME,
    FOREIGN KEY (ID_Asignacion) REFERENCES Seccion_Curso(ID_Asignacion)
);

-- Tabla Nota, que conecta Estudiante y Asignaciones de Seccion_Curso
CREATE TABLE Nota (
    ID_Nota INT PRIMARY KEY IDENTITY(1,1),
    ID_Estudiante INT,
    ID_Asignacion INT,
    Nota_Bimestre1 DECIMAL(5,2),
    Nota_Bimestre2 DECIMAL(5,2),
    Nota_Bimestre3 DECIMAL(5,2),
    Nota_Bimestre4 DECIMAL(5,2),
    FOREIGN KEY (ID_Estudiante) REFERENCES Estudiante(ID_Estudiante),
    FOREIGN KEY (ID_Asignacion) REFERENCES Seccion_Curso(ID_Asignacion)
);