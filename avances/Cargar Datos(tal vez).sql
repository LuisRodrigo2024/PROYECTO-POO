USE BDCOLEGIO;
GO

-- Insertar Usuarios con contrasenas en formato 0001, 0002, 0003, etc.
INSERT INTO USUARIO (nombre_usuario, contrasena, rol, correo_electronico)
VALUES 
    ('director', '0001', 'DIRECTOR', 'director@colegio.com'),
    ('subdirector', '0002', 'SUBDIRECTOR', 'subdirector@colegio.com'),
    ('administrativo', '0003', 'ADMINISTRATIVO', 'administrativo@colegio.com');

-- Insertar en PRECIO
INSERT INTO PRECIO (mensualidad) 
VALUES 
    (400.00);


-- Insertar Grados
INSERT INTO GRADO (grad_id)
VALUES 
    (1),
    (2),
    (3),
    (4),
    (5),
    (6);

-- Insertar Anios
DECLARE @anio INT = 2023;
WHILE @anio <= 2024
BEGIN
    DECLARE @anio_inicio DATE = DATEADD(DAY, (9 - DATEPART(WEEKDAY, DATEFROMPARTS(@anio, 3, 1))) % 7, DATEFROMPARTS(@anio, 3, 1));
    DECLARE @anio_fin DATE = DATEADD(DAY, (5 - DATEPART(WEEKDAY, DATEFROMPARTS(@anio, 12, 1)) + 7) % 7 + 7, DATEFROMPARTS(@anio, 12, 1));

    INSERT INTO ANIO (anio_id, anio_inicio, anio_fin)
    VALUES 
        (@anio, @anio_inicio, @anio_fin);

    SET @anio = @anio + 1;
END;

-- Insertar Secciones asegurando que sec_vacantes y sec_matriculados sumen 30
DECLARE @grad_id INT = 1;
WHILE @grad_id <= 6
BEGIN
    INSERT INTO SECCION (anio_id, grad_id, sec_nombre, sec_vacantes, sec_matriculados)
    VALUES 
        (2023, @grad_id, 'A', 30, 0),
        (2023, @grad_id, 'B', 30, 0)
    SET @grad_id = @grad_id + 1;
END;

SET @grad_id = 1;
WHILE @grad_id <= 6
BEGIN
    INSERT INTO SECCION (anio_id, grad_id, sec_nombre, sec_vacantes, sec_matriculados)
    VALUES 
        (2024, @grad_id, 'A', 30, 0),
        (2024, @grad_id, 'B', 30, 0)
    SET @grad_id = @grad_id + 1;
END;

-- Insertar Cursos
SET @grad_id = 1;

-- Cursos para cada grado de Primaria (1 a 6)
WHILE @grad_id <= 6
BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'COMUNICACION'),
            (@grad_id, 'RAZONAMIENTO VERBAL'),
            (@grad_id, 'MATEMATICAS'),
            (@grad_id, 'RAZONAMIENTO MATEMATICO'),
            (@grad_id, 'INGLES'),
            (@grad_id, 'PERSONAL SOCIAL'),
            (@grad_id, 'RELIGION'),
            (@grad_id, 'CIENCIA Y TECNOLOGIA'),
            (@grad_id, 'COMPUTO');
    SET @grad_id = @grad_id + 1;
END;

-- Crear Trigger para actualizar vacantes y matriculados en cada seccion
GO
CREATE TRIGGER trg_UpdateMatriculados
ON MATRICULA
AFTER INSERT, DELETE
AS
BEGIN
    -- Actualizacion despues de una insercion
    IF EXISTS(SELECT * FROM inserted)
    BEGIN
        UPDATE SECCION
        SET sec_matriculados = sec_matriculados + 1,
            sec_vacantes = sec_vacantes - 1
        FROM SECCION S
        INNER JOIN inserted I ON S.sec_id = I.sec_id;
    END

    -- Actualizacion despues de una eliminacion
    IF EXISTS(SELECT * FROM deleted)
    BEGIN
        UPDATE SECCION
        SET sec_matriculados = sec_matriculados - 1,
            sec_vacantes = sec_vacantes + 1
        FROM SECCION S
        INNER JOIN deleted D ON S.sec_id = D.sec_id;
    END

    -- Validacion de que la suma de vacantes y matriculados sea 30 en cada seccion
    IF EXISTS(SELECT 1 FROM SECCION WHERE sec_vacantes + sec_matriculados != 30)
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('Error: La suma de vacantes y matriculados debe ser 30 en cada seccion.', 16, 1);
    END
END;
GO

-- Insertar Alumnos
INSERT INTO ALUMNO (alu_apellido, alu_nombre, alu_direccion, alu_telefono)
VALUES 
    ('PEREZ GUTIERREZ', 'JUAN CARLOS', 'Av. Siempre Viva 123', '984731256'),
    ('GOMEZ RAMIREZ', 'MARIA', 'Calle Falsa 456', '972643851'),
    ('LOPEZ FERNANDEZ', 'CARLOS ALBERTO', 'Jr. Primavera 789', '953172684'),
    ('RODRIGUEZ SALAZAR', 'ANA LUCIA', 'Av. Los Rosales 321', '968234715'),
    ('MARTINEZ SOTO', 'JOSE', 'Calle Los Olivos 654', '987415263'),
    ('GARCIA HERNANDEZ', 'LUIS MIGUEL', 'Jr. Lima 123', '945362178'),
    ('HERNANDEZ PEREIRA', 'CLAUDIA', 'Av. Tupac Amaru 456', '962487315'),
    ('TORRES QUISPE', 'ROSA MARIA', 'Jr. Ayacucho 789', '976543218'),
    ('SANCHEZ RIVERA', 'PEDRO', 'Av. Grau 321', '953267481'),
    ('DIAZ ROMERO', 'ELENA PATRICIA', 'Calle Central 654', '987354621');


-- Insertar Empleados
INSERT INTO EMPLEADO (emp_apellido, emp_nombre, emp_direccion, emp_email, emp_usuario, emp_clave)
VALUES 
    ('GOMEZ PEREZ', 'CARLOS ALBERTO', 'Av. Los Cedros 145', 'carlos@gcolegio.com', 'cgomez', '92837465'),
    ('LOPEZ DIAZ', 'ANA MARIA', 'Jr. La Esperanza 231', 'ana@colegio.com', 'alopez', '73529184'),
    ('MARTINEZ LOPEZ', 'PEDRO', 'Calle Los Tulipanes 678', 'pedro@colegio.com', 'pmartinez', '18273645'),
    ('FERNANDEZ CASTRO', 'LUCIA CAROLINA', 'Av. Los Pinos 321', 'lucia@colegio.com', 'lfernandez', '64739281'),
    ('SANCHEZ RAMIREZ', 'JORGE', 'Jr. Los Rosales 555', 'jorge@colegio.com', 'jsanchez', '53928471');

-- Insertar Profesores con nombres y apellidos en mayúsculas y DNIs de 8 dígitos
INSERT INTO PROFESOR (prof_apellido, prof_nombre, prof_dni, prof_direccion, prof_email, prof_telefono)
VALUES 
    ('RAMIREZ GUTIERREZ', 'ALBERTO', '72456391', 'Calle Los Sauces 123', 'ramirez.alberto@colegio.com', '987643201'),
    ('QUISPE RODRIGUEZ', 'MARTA ELENA', '81234567', 'Av. Las Flores 456', 'quispe.marta@colegio.com', '912354678'),
    ('CASTRO TORRES', 'JULIA PATRICIA', '76543210', 'Jr. Pinos 789', 'castro.julia@colegio.com', '945672389'),
    ('SALAZAR GOMEZ', 'FERNANDO JOSE', '63527182', 'Av. San Juan 321', 'salazar.fernando@colegio.com', '976823491'),
    ('ROJAS VASQUEZ', 'INES', '85341297', 'Calle Sol 654', 'rojas.ines@colegio.com', '984561230'),
    ('MENDOZA SANCHEZ', 'PABLO EDUARDO', '72458963', 'Jr. Lirios 123', 'mendoza.pablo@colegio.com', '987345621'),
    ('PAREDES HERNANDEZ', 'LUZ MARINA', '83725491', 'Av. Olivos 456', 'paredes.luz@colegio.com', '944567283'),
    ('CHAVEZ REYES', 'ANDRES', '61235478', 'Jr. Palmeras 789', 'chavez.andres@colegio.com', '972345678'),
    ('VEGA RIVERA', 'CARMEN JOSEFINA', '79243865', 'Calle Los Alamos 321', 'vega.carmen@colegio.com', '953217846'),
    ('ORTEGA VALDEZ', 'LUIS', '63421587', 'Av. Nogales 654', 'ortega.luis@colegio.com', '987312549'),
    ('NAVARRO QUINTANA', 'SILVIA TERESA', '81243657', 'Calle Azucenas 123', 'navarro.silvia@colegio.com', '961243578'),
    ('REYES PEREZ', 'RICARDO ANTONIO', '72536419', 'Av. Jazmines 456', 'reyes.ricardo@colegio.com', '975312486'),
    ('GUTIERREZ DIAZ', 'ANGELA', '84321765', 'Jr. Rosas 789', 'gutierrez.angela@colegio.com', '982435617'),
    ('VALDEZ HERRERA', 'MARIO ENRIQUE', '76231458', 'Av. Sauce 321', 'valdez.mario@colegio.com', '956213487'),
    ('ESCOBAR RAMOS', 'PATRICIA', '69231485', 'Calle Lima 654', 'escobar.patricia@colegio.com', '968245316'),
    ('RIOS MARTINEZ', 'HUGO CESAR', '78245639', 'Av. Central 123', 'rios.hugo@colegio.com', '943215867'),
    ('FIGUEROA CARRILLO', 'CELIA', '84123765', 'Jr. Esperanza 456', 'figueroa.celia@colegio.com', '967432815'),
    ('VILLANUEVA TORRES', 'RAUL FERNANDO', '65421378', 'Calle Nueva 789', 'villanueva.raul@colegio.com', '953278416'),
    ('ACOSTA ROSALES', 'BLANCA', '73241568', 'Av. Los Heroes 321', 'acosta.blanca@colegio.com', '986345127'),
    ('RUIZ PEREZ', 'EDUARDO ALONSO', '82134675', 'Jr. Alameda 654', 'ruiz.eduardo@colegio.com', '958214637');


-- Insertar Matrículas (asegurando la referencia de sec_id, alu_id y emp_id existentes)
INSERT INTO MATRICULA (alu_id, sec_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_estado)
VALUES 
    (1, 1, 1, 'REGULAR', '2023-03-01', 400, 'Activo'),
    (2, 2, 1, 'REGULAR', '2023-03-01', 400, 'Activo'),
    (3, 3, 1, 'REGULAR', '2023-03-01', 400, 'Activo');

-- Insertar tipos de pago en la tabla TIPO_PAGO
INSERT INTO TIPO_PAGO (nombre)
VALUES 
    ('Matricula'),
    ('Pension');


-- Insertar Pagos asegurando que pag_importe no sea NULL
DECLARE @mat_id INT = 1;
DECLARE @pag_fecha DATE;
DECLARE @pag_cuota INT;
DECLARE @mensualidad DECIMAL(10,2);

WHILE @mat_id <= 3
BEGIN
    -- Obtener la mensualidad desde la tabla PRECIO
    -- Si no se encuentra un valor, asignar 0 como valor predeterminado.
    SELECT TOP 1 @mensualidad = COALESCE(mensualidad, 0) 
    FROM PRECIO;

    -- Pago de la matrícula (último día de febrero)
    SET @pag_fecha = EOMONTH('2023-02-01');
    SET @pag_cuota = 1;
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_fecha_prog, pag_pension, pag_importe, tipo_pago_id)
    VALUES (@mat_id, 1, @pag_fecha, @pag_fecha, @pag_cuota, @mensualidad, 1); -- tipo_pago_id = 1 para matrícula

    -- Primer mes (último día de marzo)
    SET @pag_fecha = EOMONTH('2023-03-01');
    SET @pag_cuota = 2;
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_fecha_prog, pag_pension, pag_importe, tipo_pago_id)
    VALUES (@mat_id, 1, @pag_fecha, @pag_fecha, @pag_cuota, @mensualidad, 2); -- tipo_pago_id = 2 para pagos mensuales

    -- Segundo mes (último día de abril)
    SET @pag_fecha = EOMONTH('2023-04-01');
    SET @pag_cuota = 3;
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_fecha_prog, pag_pension, pag_importe, tipo_pago_id)
    VALUES (@mat_id, 1, @pag_fecha, @pag_fecha, @pag_cuota, @mensualidad, 2); -- tipo_pago_id = 2 para pagos mensuales

    -- Incremento de mat_id para el siguiente ciclo
    SET @mat_id = @mat_id + 1;
END;

-- Inserciones simplificadas en SECCION_CURSO
INSERT INTO SECCION_CURSO (sec_id, cur_id, prof_id) VALUES 
    (1, 1, 1), (1, 2, 1), (1, 3, 5), (1, 4, 5), (1, 5, 9), (1, 6, 11), (1, 7, 11), (1, 8, 15), (1, 9, 18),
    (2, 1, 1), (2, 2, 1), (2, 3, 5), (2, 4, 5), (2, 5, 9), (2, 6, 11), (2, 7, 11), (2, 8, 15), (2, 9, 18),
    (3, 10, 1), (3, 11, 1), (3, 12, 5), (3, 13, 5), (3, 14, 9), (3, 15, 11), (3, 16, 11), (3, 17, 15), (3, 18, 18),
    (4, 10, 2), (4, 11, 2), (4, 12, 6), (4, 13, 6), (4, 14, 9), (4, 15, 12), (4, 16, 12), (4, 17, 15), (4, 18, 18),
    (5, 19, 2), (5, 20, 2), (5, 21, 6), (5, 22, 6), (5, 23, 9), (5, 24, 12), (5, 25, 12), (5, 26, 16), (5, 27, 18),
    (6, 19, 2), (6, 20, 2), (6, 21, 6), (6, 22, 6), (6, 23, 9), (6, 24, 12), (6, 25, 12), (6, 26, 16), (6, 27, 18),
    (7, 28, 3), (7, 29, 3), (7, 30, 7), (7, 31, 7), (7, 32, 10), (7, 33, 13), (7, 34, 13), (7, 35, 16), (7, 36, 19),
    (8, 28, 3), (8, 29, 3), (8, 30, 7), (8, 31, 7), (8, 32, 10), (8, 33, 13), (8, 34, 13), (8, 35, 16), (8, 36, 19),
    (9, 37, 3), (9, 38, 3), (9, 39, 7), (9, 40, 7), (9, 41, 10), (9, 42, 13), (9, 43, 13), (9, 44, 17), (9, 45, 19),
    (10, 37, 4), (10, 38, 4), (10, 39, 8), (10, 40, 8), (10, 41, 10), (10, 42, 14), (10, 43, 14), (10, 44, 17), (10, 45, 19),
    (11, 46, 4), (11, 47, 4), (11, 48, 8), (11, 49, 8), (11, 50, 10), (11, 51, 14), (11, 52, 14), (11, 53, 17), (11, 54, 19),
    (12, 46, 4), (12, 47, 4), (12, 48, 8), (12, 49, 8), (12, 50, 10), (12, 51, 14), (12, 52, 14), (12, 53, 17), (12, 54, 19);

-- Inserciones de horarios
INSERT INTO HORARIO(asig_id, hor_dia, hor_inicio, hor_fin) VALUES 
(1,'MARTES','10:30','11:15'),(1,'MARTES','11:15','12:00'),(1,'MIERCOLES','10:30','11:15'),(1,'MIERCOLES','11:15','12:00'),
(2,'MIERCOLES','12:15','13:00'),(2,'MIERCOLES','13:00','13:45'),(2,'MIERCOLES','13:45','14:30'),(2,'JUEVES','08:00','08:45'),
(3,'MARTES','12:15','13:00'),(3,'MARTES','13:00','13:45'),(3,'MARTES','13:45','14:30'),(3,'JUEVES','12:15','13:00'),(3,'JUEVES','13:00','13:45'),(3,'JUEVES','13:45','14:30'),
(4,'JUEVES','08:45','09:30'),(4,'JUEVES','09:30','10:15'),(4,'JUEVES','10:30','11:15'),(4,'JUEVES','11:15','12:00'),
(5,'LUNES','08:00','08:45'),(5,'LUNES','08:45','09:30'),(5,'LUNES','09:30','10:15'),(5,'LUNES','10:30','11:15'),
(6,'VIERNES','08:00','08:45'),(6,'VIERNES','08:45','09:30'),(6,'VIERNES','09:30','10:15'),(6,'VIERNES','10:30','11:15'),
(7,'VIERNES','11:15','12:00'),(7,'VIERNES','12:15','13:00'),(7,'VIERNES','13:00','13:45'),(7,'VIERNES','13:45','14:30'),
(8,'MARTES','08:00','08:45'),(8,'MARTES','08:45','09:30'),(8,'MARTES','09:30','10:15'),(8,'MIERCOLES','08:00','08:45'),(8,'MIERCOLES','08:45','09:30'),(8,'MIERCOLES','09:30','10:15'),
(9,'LUNES','11:15','12:00'),(9,'LUNES','12:15','13:00'),(9,'LUNES','13:00','13:45'),(9,'LUNES','13:45','14:30'),
(10,'LUNES','08:00','08:45'),(10,'LUNES','08:45','09:30'),(10,'LUNES','09:30','10:15'),(10,'LUNES','10:30','11:15'),
(11,'LUNES','11:15','12:00'),(11,'LUNES','12:15','13:00'),(11,'LUNES','13:00','13:45'),(11,'LUNES','13:45','14:30'),
(12,'MIERCOLES','11:15','12:00'),(12,'MIERCOLES','12:15','13:00'),(12,'MIERCOLES','13:00','13:45'),(12,'VIERNES','12:15','13:00'),(12,'VIERNES','13:00','13:45'),(12,'VIERNES','13:45','14:30'),
(13,'MIERCOLES','08:00','08:45'),(13,'MIERCOLES','08:45','09:30'),(13,'MIERCOLES','09:30','10:15'),(13,'MIERCOLES','10:30','11:15'),
(14,'MARTES','08:00','08:45'),(14,'MARTES','08:45','09:30'),(14,'MARTES','09:30','10:15'),(14,'MARTES','10:30','11:15'),
(15,'MIERCOLES','13:45','14:30'),(15,'JUEVES','08:00','08:45'),(15,'JUEVES','08:45','09:30'),(15,'JUEVES','09:30','10:15'),
(16,'JUEVES','10:30','11:15'),(16,'JUEVES','11:15','12:00'),(16,'JUEVES','12:15','13:00'),(16,'JUEVES','13:00','13:45'),
(17,'JUEVES','13:45','14:30'),(17,'VIERNES','08:00','08:45'),(17,'VIERNES','08:45','09:30'),(17,'VIERNES','09:30','10:15'),(17,'VIERNES','10:30','11:15'),(17,'VIERNES','11:15','12:00'),
(18,'MARTES','11:15','12:00'),(18,'MARTES','12:15','13:00'),(18,'MARTES','13:00','13:45'),(18,'MARTES','13:45','14:30'),
(19,'VIERNES','11:15','12:00'),(19,'VIERNES','12:15','13:00'),(19,'VIERNES','13:00','13:45'),(19,'VIERNES','13:45','14:30'),
(20,'JUEVES','11:15','12:00'),(20,'JUEVES','12:15','13:00'),(20,'JUEVES','13:00','13:45'),(20,'JUEVES','13:45','14:30'),
(21,'LUNES','08:00','08:45'),(21,'LUNES','08:45','09:30'),(21,'LUNES','09:30','10:15'),(21,'MARTES','08:00','08:45'),(21,'MARTES','08:45','09:30'),(21,'MARTES','09:30','10:15'),
(22,'VIERNES','08:00','08:45'),(22,'VIERNES','08:45','09:30'),(22,'VIERNES','09:30','10:15'),(22,'VIERNES','10:30','11:15'),
(23,'MIERCOLES','08:00','08:45'),(23,'MIERCOLES','08:45','09:30'),(23,'MIERCOLES','09:30','10:15'),(23,'MIERCOLES','10:30','11:15'),
(24,'LUNES','10:30','11:15'),(24,'LUNES','11:15','12:00'),(24,'LUNES','12:15','13:00'),(24,'LUNES','13:00','13:45'),
(25,'LUNES','13:45','14:30'),(25,'MARTES','10:30','11:15'),(25,'MARTES','11:15','12:00'),(25,'MIERCOLES','11:15','12:00'),
(26,'LUNES','13:00','13:45'),(26,'LUNES','13:45','14:30'),(26,'LUNES','08:00','08:45'),(26,'LUNES','08:45','09:30'),(26,'LUNES','09:30','10:15'),(26,'LUNES','10:30','11:15'),
(27,'MIERCOLES','12:15','13:00'),(27,'MIERCOLES','13:00','13:45'),(27,'MIERCOLES','13:45','14:30'),(27,'JUEVES','08:00','08:45'),
(28,'LUNES','11:15','12:00'),(28,'LUNES','12:15','13:00'),(28,'LUNES','13:00','13:45'),(28,'LUNES','13:45','14:30'),
(29,'LUNES','08:00','08:45'),(29,'LUNES','08:45','09:30'),(29,'LUNES','09:30','10:15'),(29,'LUNES','10:30','11:15'),
(30,'MARTES','12:15','13:00'),(30,'MARTES','13:00','13:45'),(30,'MARTES','13:45','14:30'),(30,'MIERCOLES','08:00','08:45'),(30,'MIERCOLES','08:45','09:30'),(30,'VIERNES','08:00','08:45'),
(31,'MARTES','10:30','11:15'),(31,'MARTES','11:15','12:00'),(31,'MIERCOLES','10:30','11:15'),(31,'MIERCOLES','11:15','12:00'),
(32,'JUEVES','08:00','08:45'),(32,'JUEVES','08:45','09:30'),(32,'JUEVES','09:30','10:15'),(32,'JUEVES','10:30','11:15'),
(33,'VIERNES','08:45','09:30'),(33,'VIERNES','09:30','10:15'),(33,'VIERNES','10:30','11:15'),(33,'VIERNES','11:15','12:00'),
(34,'MARTES','08:00','08:45'),(34,'MARTES','08:45','09:30'),(34,'MARTES','09:30','10:15'),(34,'MIERCOLES','09:30','10:15'),
(35,'MIERCOLES','12:15','13:00'),(35,'MIERCOLES','13:00','13:45'),(35,'MIERCOLES','13:45','14:30'),(35,'VIERNES','12:15','13:00'),(35,'VIERNES','13:00','13:45'),(35,'VIERNES','13:45','14:30'),
(36,'JUEVES','11:15','12:00'),(36,'JUEVES','12:15','13:00'),(36,'JUEVES','13:00','13:45'),(36,'JUEVES','13:45','14:30'),
(37,'MARTES','11:15','12:00'),(37,'MARTES','12:15','13:00'),(37,'MARTES','13:00','13:45'),(37,'MARTES','13:45','14:30'),
(38,'MARTES','08:00','08:45'),(38,'MARTES','08:45','09:30'),(38,'MARTES','09:30','10:15'),(38,'MARTES','10:30','11:15'),
(39,'LUNES','08:00','08:45'),(39,'LUNES','08:45','09:30'),(39,'LUNES','09:30','10:15'),(39,'JUEVES','08:00','08:45'),(39,'JUEVES','08:45','09:30'),(39,'JUEVES','09:30','10:15'),
(40,'LUNES','10:30','11:15'),(40,'LUNES','11:15','12:00'),(40,'JUEVES','10:30','11:15'),(40,'JUEVES','11:15','12:00'),
(41,'VIERNES','08:00','08:45'),(41,'VIERNES','08:45','09:30'),(41,'VIERNES','09:30','10:15'),(41,'VIERNES','10:30','11:15'),
(42,'MIERCOLES','10:30','11:15'),(42,'MIERCOLES','11:15','12:00'),(42,'MIERCOLES','12:15','13:00'),(42,'MIERCOLES','13:00','13:45'),
(43,'MIERCOLES','13:45','14:30'),(43,'JUEVES','12:15','13:00'),(43,'JUEVES','13:00','13:45'),(43,'JUEVES','13:45','14:30'),
(44,'LUNES','12:15','13:00'),(44,'LUNES','13:00','13:45'),(44,'LUNES','13:45','14:30'),(44,'MIERCOLES','08:00','08:45'),(44,'MIERCOLES','08:45','09:30'),(44,'MIERCOLES','09:30','10:15'),
(45,'VIERNES','11:15','12:00'),(45,'VIERNES','12:15','13:00'),(45,'VIERNES','13:00','13:45'),(45,'VIERNES','13:45','14:30'),
(46,'MIERCOLES','11:15','12:00'),(46,'MIERCOLES','12:15','13:00'),(46,'MIERCOLES','13:00','13:45'),(46,'MIERCOLES','13:45','14:30'),
(47,'MIERCOLES','08:00','08:45'),(47,'MIERCOLES','08:45','09:30'),(47,'MIERCOLES','09:30','10:15'),(47,'MIERCOLES','10:30','11:15'),
(48,'JUEVES','12:15','13:00'),(48,'JUEVES','13:00','13:45'),(48,'JUEVES','13:45','14:30'),(48,'VIERNES','08:45','09:30'),(48,'VIERNES','09:30','10:15'),(48,'VIERNES','10:30','11:15'),
(49,'VIERNES','11:15','12:00'),(49,'VIERNES','12:15','13:00'),(49,'VIERNES','13:00','13:45'),(49,'VIERNES','13:45','14:30'),
(50,'LUNES','11:15','12:00'),(50,'LUNES','12:15','13:00'),(50,'LUNES','13:00','13:45'),(50,'LUNES','13:45','14:30'),
(51,'MARTES','10:30','11:15'),(51,'MARTES','11:15','12:00'),(51,'JUEVES','10:30','11:15'),(51,'JUEVES','11:15','12:00'),
(52,'MARTES','12:15','13:00'),(52,'MARTES','13:00','13:45'),(52,'MARTES','13:45','14:30'),(52,'VIERNES','08:00','08:45'),
(53,'MARTES','08:00','08:45'),(53,'MARTES','08:45','09:30'),(53,'MARTES','09:30','10:15'),(53,'JUEVES','08:00','08:45'),(53,'JUEVES','08:45','09:30'),(53,'JUEVES','09:30','10:15'),
(54,'LUNES','08:00','08:45'),(54,'LUNES','08:45','09:30'),(54,'LUNES','09:30','10:15'),(54,'LUNES','10:30','11:15'),
(55,'MARTES','10:30','11:15'),(55,'MARTES','11:15','12:00'),(55,'MIERCOLES','10:30','11:15'),(55,'MIERCOLES','11:15','12:00'),
(56,'MIERCOLES','12:15','13:00'),(56,'MIERCOLES','13:00','13:45'),(56,'MIERCOLES','13:45','14:30'),(56,'JUEVES','08:00','08:45'),
(57,'MARTES','12:15','13:00'),(57,'MARTES','13:00','13:45'),(57,'MARTES','13:45','14:30'),(57,'JUEVES','12:15','13:00'),(57,'JUEVES','13:00','13:45'),(57,'JUEVES','13:45','14:30'),
(58,'JUEVES','08:45','09:30'),(58,'JUEVES','09:30','10:15'),(58,'JUEVES','10:30','11:15'),(58,'JUEVES','11:15','12:00'),
(59,'LUNES','08:00','08:45'),(59,'LUNES','08:45','09:30'),(59,'LUNES','09:30','10:15'),(59,'LUNES','10:30','11:15'),
(60,'VIERNES','08:00','08:45'),(60,'VIERNES','08:45','09:30'),(60,'VIERNES','09:30','10:15'),(60,'VIERNES','10:30','11:15'),
(61,'VIERNES','11:15','12:00'),(61,'VIERNES','12:15','13:00'),(61,'VIERNES','13:00','13:45'),(61,'VIERNES','13:45','14:30'),
(62,'MARTES','08:00','08:45'),(62,'MARTES','08:45','09:30'),(62,'MARTES','09:30','10:15'),(62,'MIERCOLES','08:00','08:45'),(62,'MIERCOLES','08:45','09:30'),(62,'MIERCOLES','09:30','10:15'),
(63,'LUNES','11:15','12:00'),(63,'LUNES','12:15','13:00'),(63,'LUNES','13:00','13:45'),(63,'LUNES','13:45','14:30'),
(64,'LUNES','08:00','08:45'),(64,'LUNES','08:45','09:30'),(64,'LUNES','09:30','10:15'),(64,'LUNES','10:30','11:15'),
(65,'LUNES','11:15','12:00'),(65,'LUNES','12:15','13:00'),(65,'LUNES','13:00','13:45'),(65,'LUNES','13:45','14:30'),
(66,'MIERCOLES','11:15','12:00'),(66,'MIERCOLES','12:15','13:00'),(66,'MIERCOLES','13:00','13:45'),(66,'VIERNES','12:15','13:00'),(66,'VIERNES','13:00','13:45'),(66,'VIERNES','13:45','14:30'),
(67,'MIERCOLES','08:00','08:45'),(67,'MIERCOLES','08:45','09:30'),(67,'MIERCOLES','09:30','10:15'),(67,'MIERCOLES','10:30','11:15'),
(68,'MARTES','08:00','08:45'),(68,'MARTES','08:45','09:30'),(68,'MARTES','09:30','10:15'),(68,'MARTES','10:30','11:15'),
(69,'MIERCOLES','13:45','14:30'),(69,'JUEVES','08:00','08:45'),(69,'JUEVES','08:45','09:30'),(69,'JUEVES','09:30','10:15'),
(70,'JUEVES','10:30','11:15'),(70,'JUEVES','11:15','12:00'),(70,'JUEVES','12:15','13:00'),(70,'JUEVES','13:00','13:45'),
(71,'JUEVES','13:45','14:30'),(71,'VIERNES','08:00','08:45'),(71,'VIERNES','08:45','09:30'),(71,'VIERNES','09:30','10:15'),(71,'VIERNES','10:30','11:15'),(71,'VIERNES','11:15','12:00'),
(72,'MARTES','11:15','12:00'),(72,'MARTES','12:15','13:00'),(72,'MARTES','13:00','13:45'),(72,'MARTES','13:45','14:30'),
(73,'VIERNES','11:15','12:00'),(73,'VIERNES','12:15','13:00'),(73,'VIERNES','13:00','13:45'),(73,'VIERNES','13:45','14:30'),
(74,'JUEVES','11:15','12:00'),(74,'JUEVES','12:15','13:00'),(74,'JUEVES','13:00','13:45'),(74,'JUEVES','13:45','14:30'),
(75,'LUNES','08:00','08:45'),(75,'LUNES','08:45','09:30'),(75,'LUNES','09:30','10:15'),(75,'MARTES','08:00','08:45'),(75,'MARTES','08:45','09:30'),(75,'MARTES','09:30','10:15'),
(76,'VIERNES','08:00','08:45'),(76,'VIERNES','08:45','09:30'),(76,'VIERNES','09:30','10:15'),(76,'VIERNES','10:30','11:15'),
(77,'MIERCOLES','08:00','08:45'),(77,'MIERCOLES','08:45','09:30'),(77,'MIERCOLES','09:30','10:15'),(77,'MIERCOLES','10:30','11:15'),
(78,'LUNES','10:30','11:15'),(78,'LUNES','11:15','12:00'),(78,'LUNES','12:15','13:00'),(78,'LUNES','13:00','13:45'),
(79,'LUNES','13:45','14:30'),(79,'MARTES','10:30','11:15'),(79,'MARTES','11:15','12:00'),(79,'MIERCOLES','11:15','12:00'),
(80,'LUNES','13:00','13:45'),(80,'LUNES','13:45','14:30'),(80,'LUNES','08:00','08:45'),(80,'LUNES','08:45','09:30'),(80,'LUNES','09:30','10:15'),(80,'LUNES','10:30','11:15'),
(81,'MIERCOLES','12:15','13:00'),(81,'MIERCOLES','13:00','13:45'),(81,'MIERCOLES','13:45','14:30'),(81,'JUEVES','08:00','08:45'),
(82,'LUNES','11:15','12:00'),(82,'LUNES','12:15','13:00'),(82,'LUNES','13:00','13:45'),(82,'LUNES','13:45','14:30'),
(83,'LUNES','08:00','08:45'),(83,'LUNES','08:45','09:30'),(83,'LUNES','09:30','10:15'),(83,'LUNES','10:30','11:15'),
(84,'MARTES','12:15','13:00'),(84,'MARTES','13:00','13:45'),(84,'MARTES','13:45','14:30'),(84,'MIERCOLES','08:00','08:45'),(84,'MIERCOLES','08:45','09:30'),(84,'VIERNES','08:00','08:45'),
(85,'MARTES','10:30','11:15'),(85,'MARTES','11:15','12:00'),(85,'MIERCOLES','10:30','11:15'),(85,'MIERCOLES','11:15','12:00'),
(86,'JUEVES','08:00','08:45'),(86,'JUEVES','08:45','09:30'),(86,'JUEVES','09:30','10:15'),(86,'JUEVES','10:30','11:15'),
(87,'VIERNES','08:45','09:30'),(87,'VIERNES','09:30','10:15'),(87,'VIERNES','10:30','11:15'),(87,'VIERNES','11:15','12:00'),
(88,'MARTES','08:00','08:45'),(88,'MARTES','08:45','09:30'),(88,'MARTES','09:30','10:15'),(88,'MIERCOLES','09:30','10:15'),
(89,'MIERCOLES','12:15','13:00'),(89,'MIERCOLES','13:00','13:45'),(89,'MIERCOLES','13:45','14:30'),(89,'VIERNES','12:15','13:00'),(89,'VIERNES','13:00','13:45'),(89,'VIERNES','13:45','14:30'),
(90,'JUEVES','11:15','12:00'),(90,'JUEVES','12:15','13:00'),(90,'JUEVES','13:00','13:45'),(90,'JUEVES','13:45','14:30'),
(91,'MARTES','11:15','12:00'),(91,'MARTES','12:15','13:00'),(91,'MARTES','13:00','13:45'),(91,'MARTES','13:45','14:30'),
(92,'MARTES','08:00','08:45'),(92,'MARTES','08:45','09:30'),(92,'MARTES','09:30','10:15'),(92,'MARTES','10:30','11:15'),
(93,'LUNES','08:00','08:45'),(93,'LUNES','08:45','09:30'),(93,'LUNES','09:30','10:15'),(93,'JUEVES','08:00','08:45'),(93,'JUEVES','08:45','09:30'),(93,'JUEVES','09:30','10:15'),
(94,'LUNES','10:30','11:15'),(94,'LUNES','11:15','12:00'),(94,'JUEVES','10:30','11:15'),(94,'JUEVES','11:15','12:00'),
(95,'VIERNES','08:00','08:45'),(95,'VIERNES','08:45','09:30'),(95,'VIERNES','09:30','10:15'),(95,'VIERNES','10:30','11:15'),
(96,'MIERCOLES','10:30','11:15'),(96,'MIERCOLES','11:15','12:00'),(96,'MIERCOLES','12:15','13:00'),(96,'MIERCOLES','13:00','13:45'),
(97,'MIERCOLES','13:45','14:30'),(97,'JUEVES','12:15','13:00'),(97,'JUEVES','13:00','13:45'),(97,'JUEVES','13:45','14:30'),
(98,'LUNES','12:15','13:00'),(98,'LUNES','13:00','13:45'),(98,'LUNES','13:45','14:30'),(98,'MIERCOLES','08:00','08:45'),(98,'MIERCOLES','08:45','09:30'),(98,'MIERCOLES','09:30','10:15'),
(99,'VIERNES','11:15','12:00'),(99,'VIERNES','12:15','13:00'),(99,'VIERNES','13:00','13:45'),(99,'VIERNES','13:45','14:30'),
(100,'MIERCOLES','11:15','12:00'),(100,'MIERCOLES','12:15','13:00'),(100,'MIERCOLES','13:00','13:45'),(100,'MIERCOLES','13:45','14:30'),
(101,'MIERCOLES','08:00','08:45'),(101,'MIERCOLES','08:45','09:30'),(101,'MIERCOLES','09:30','10:15'),(101,'MIERCOLES','10:30','11:15'),
(102,'JUEVES','12:15','13:00'),(102,'JUEVES','13:00','13:45'),(102,'JUEVES','13:45','14:30'),(102,'VIERNES','08:45','09:30'),(102,'VIERNES','09:30','10:15'),(102,'VIERNES','10:30','11:15'),
(103,'VIERNES','11:15','12:00'),(103,'VIERNES','12:15','13:00'),(103,'VIERNES','13:00','13:45'),(103,'VIERNES','13:45','14:30'),
(104,'LUNES','11:15','12:00'),(104,'LUNES','12:15','13:00'),(104,'LUNES','13:00','13:45'),(104,'LUNES','13:45','14:30'),
(105,'MARTES','10:30','11:15'),(105,'MARTES','11:15','12:00'),(105,'JUEVES','10:30','11:15'),(105,'JUEVES','11:15','12:00'),
(106,'MARTES','12:15','13:00'),(106,'MARTES','13:00','13:45'),(106,'MARTES','13:45','14:30'),(106,'VIERNES','08:00','08:45'),
(107,'MARTES','08:00','08:45'),(107,'MARTES','08:45','09:30'),(107,'MARTES','09:30','10:15'),(107,'JUEVES','08:00','08:45'),(107,'JUEVES','08:45','09:30'),(107,'JUEVES','09:30','10:15'),
(108,'LUNES','08:00','08:45'),(108,'LUNES','08:45','09:30'),(108,'LUNES','09:30','10:15'),(108,'LUNES','10:30','11:15');

-- Inserciones de notas
INSERT INTO NOTA (alu_id,asig_id,not_bimestre1) VALUES 
  (1,1,16),
  (1,2,17),
  (1,3,15),
  (1,4,18),
  (1,5,14),
  (1,6,13),
  (1,7,17),
  (1,8,12),
  (1,9,16),
  (2,10,14),
  (2,11,17),
  (2,12,16),
  (2,13,13),
  (2,14,15),
  (2,15,11),
  (2,16,15),
  (2,17,14),
  (2,18,13),
  (3,19,13),
  (3,20,13),
  (3,21,13),
  (3,22,13),
  (3,23,13),
  (3,24,13),
  (3,25,13),
  (3,26,13),
  (3,27,13);