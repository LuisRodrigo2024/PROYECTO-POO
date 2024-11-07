USE MASTER 
GO

IF NOT EXISTS (SELECT NAME FROM sys.databases WHERE NAME = 'BDCOLEGIO')
    CREATE DATABASE BDCOLEGIO;
GO

USE BDCOLEGIO;
GO

-- Tabla ANIO
CREATE TABLE ANIO (
    anio_id INT PRIMARY KEY,
    anio_inicio DATETIME NOT NULL,
    anio_fin DATETIME NOT NULL
);

-- Tabla GRADO
CREATE TABLE GRADO (
    grad_id INT PRIMARY KEY IDENTITY(1,1),
    grad_numero INT NOT NULL,
    grad_nivel VARCHAR(10) CHECK (grad_nivel IN ('PRIMARIA', 'SECUNDARIA'))
);

CREATE TABLE PRECIO (
    nivel VARCHAR(10) PRIMARY KEY CHECK (nivel IN ('PRIMARIA', 'SECUNDARIA')),
    mensualidad DECIMAL(10,2) NOT NULL
);

-- Tabla SECCION
CREATE TABLE SECCION (
    sec_id INT PRIMARY KEY IDENTITY(1,1),
    anio_id INT,
    grad_id INT,
    sec_nombre VARCHAR(10) NOT NULL,
    sec_vacantes INT,
    sec_matriculados INT,
    FOREIGN KEY (anio_id) REFERENCES ANIO(anio_id),
    FOREIGN KEY (grad_id) REFERENCES GRADO(grad_id)
);

-- Tabla CURSO
CREATE TABLE CURSO (
    cur_id INT PRIMARY KEY IDENTITY(1,1),
    grad_id INT,
    cur_nombre VARCHAR(100) NOT NULL,
    FOREIGN KEY (grad_id) REFERENCES GRADO(grad_id)
);

-- Tabla ALUMNO
CREATE TABLE ALUMNO (
    alu_id INT PRIMARY KEY IDENTITY(1,1),
    alu_apellido VARCHAR(100) NOT NULL,
    alu_nombre VARCHAR(100) NOT NULL,
    alu_direccion VARCHAR(100) NOT NULL,
    alu_telefono VARCHAR(20)
);

-- Tabla EMPLEADO
CREATE TABLE EMPLEADO (
    emp_id INT PRIMARY KEY IDENTITY(1,1),
    emp_apellido VARCHAR(100) NOT NULL,
    emp_nombre VARCHAR(100) NOT NULL,
    emp_direccion VARCHAR(100) NOT NULL,
    emp_email VARCHAR(100) NOT NULL,
    emp_usuario VARCHAR(20) NOT NULL,
    emp_clave VARCHAR(100) NOT NULL
);

-- Tabla MATRICULA
CREATE TABLE MATRICULA (
    mat_id INT PRIMARY KEY IDENTITY(1,1),
    sec_id INT NOT NULL,
    alu_id INT NOT NULL,
    emp_id INT NOT NULL,
    mat_tipo VARCHAR(10),
    CONSTRAINT chk_matricula_tipo CHECK (mat_tipo IN ('REGULAR', 'BECA', 'MEDIABECA')),
    mat_fecha DATETIME NOT NULL,
    mat_precio DECIMAL(10,2) NOT NULL,
    mat_estado VARCHAR(10) CHECK (mat_estado IN ('Activo', 'Retirado')),
    FOREIGN KEY (alu_id) REFERENCES ALUMNO(alu_id),
    FOREIGN KEY (sec_id) REFERENCES SECCION(sec_id),
    FOREIGN KEY (emp_id) REFERENCES EMPLEADO(emp_id)
);

-- Tabla PAGO
CREATE TABLE PAGO (
    pag_id INT PRIMARY KEY IDENTITY(1,1),
    mat_id INT NOT NULL,
    emp_id INT NOT NULL,
	pag_pension INT NOT NULL,
	pag_importe DECIMAL(10,2) NOT NULL,
    pag_fecha DATETIME NOT NULL,
    FOREIGN KEY (mat_id) REFERENCES MATRICULA(mat_id),
    FOREIGN KEY (emp_id) REFERENCES EMPLEADO(emp_id)
);

-- Tabla PROFESOR
CREATE TABLE PROFESOR (
    prof_id INT PRIMARY KEY IDENTITY(1,1),
    prof_apellido VARCHAR(100) NOT NULL,
    prof_nombre VARCHAR(100) NOT NULL,
    prof_dni VARCHAR(15) NOT NULL,
    prof_direccion VARCHAR(100),
    prof_email VARCHAR(100),
    prof_telefono VARCHAR(15)
);

-- Tabla SECCION_CURSO
CREATE TABLE SECCION_CURSO (
    asig_id INT PRIMARY KEY IDENTITY(1,1),
    sec_id INT NOT NULL,
    cur_id INT NOT NULL,
    prof_id INT NOT NULL,
    FOREIGN KEY (sec_id) REFERENCES SECCION(sec_id),
    FOREIGN KEY (cur_id) REFERENCES CURSO(cur_id),
    FOREIGN KEY (prof_id) REFERENCES PROFESOR(prof_id)
);

-- Tabla NOTA
CREATE TABLE NOTA (
    not_id INT PRIMARY KEY IDENTITY(1,1),
    alu_id INT NOT NULL,
    asig_id INT NOT NULL,
    not_bimestre1 DECIMAL(5,2),
    not_bimestre2 DECIMAL(5,2),
    not_bimestre3 DECIMAL(5,2),
    not_bimestre4 DECIMAL(5,2),
    not_final DECIMAL(5,2),
    FOREIGN KEY (alu_id) REFERENCES ALUMNO(alu_id),
    FOREIGN KEY (asig_id) REFERENCES SECCION_CURSO(asig_id)
);

-- Tabla HORARIO
CREATE TABLE HORARIO (
    hor_id INT PRIMARY KEY IDENTITY(1,1),
    asig_id INT NOT NULL,
    hor_dia VARCHAR(10) CHECK (hor_dia IN ('LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES')),
    hor_inicio TIME,
    hor_fin TIME,
    FOREIGN KEY (asig_id) REFERENCES SECCION_CURSO(asig_id)
);

-- Tabla USUARIO
CREATE TABLE USUARIO (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    nombre_usuario VARCHAR(50) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol VARCHAR(20) CHECK (rol IN ('DIRECTOR', 'SUBDIRECTOR', 'PROFESOR', 'ADMINISTRATIVO', 'SUPERADMIN')),
    correo_electronico VARCHAR(100),
    ultimo_acceso DATETIME,
    estado_activo BIT DEFAULT 1
);
