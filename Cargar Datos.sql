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
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_pension, pag_importe, tipo_pago_id)
    VALUES (@mat_id, 1, @pag_fecha, @pag_cuota, @mensualidad, 1); -- tipo_pago_id = 1 para matrícula

    -- Primer mes (último día de marzo)
    SET @pag_fecha = EOMONTH('2023-03-01');
    SET @pag_cuota = 2;
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_pension, pag_importe, tipo_pago_id)
    VALUES (@mat_id, 1, @pag_fecha, @pag_cuota, @mensualidad, 2); -- tipo_pago_id = 2 para pagos mensuales

    -- Segundo mes (último día de abril)
    SET @pag_fecha = EOMONTH('2023-04-01');
    SET @pag_cuota = 3;
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_pension, pag_importe, tipo_pago_id)
    VALUES (@mat_id, 1, @pag_fecha, @pag_cuota, @mensualidad, 2); -- tipo_pago_id = 2 para pagos mensuales

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