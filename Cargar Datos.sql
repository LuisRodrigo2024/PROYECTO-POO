USE BDCOLEGIO;
GO

-- Insertar Usuarios con contrasenas en formato 0001, 0002, 0003, etc.
INSERT INTO USUARIO (nombre_usuario, contrasena, rol, correo_electronico)
VALUES 
    ('director', '0001', 'director', 'director@colegio.com'),
    ('subdirector', '0002', 'subdirector', 'subdirector@colegio.com'),
    ('administrativo', '0003', 'administrativo', 'administrativo@colegio.com');

-- Insertar Grados
INSERT INTO GRADO (grad_numero, grad_nivel, grad_mensualidad)
VALUES 
    (1, 'Primaria', 200),
    (2, 'Primaria', 225),
    (3, 'Primaria', 250),
    (4, 'Primaria', 275),
    (5, 'Primaria', 300),
    (6, 'Primaria', 325),
    (1, 'Secundaria', 400),
    (2, 'Secundaria', 450),
    (3, 'Secundaria', 500),
    (4, 'Secundaria', 550),
    (5, 'Secundaria', 600);

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
WHILE @grad_id <= 11
BEGIN
    INSERT INTO SECCION (anio_id, grad_id, sec_nombre, sec_vacantes, sec_matriculados)
    VALUES 
        (2023, @grad_id, 'A', 30, 0),
        (2023, @grad_id, 'B', 30, 0),
        (2023, @grad_id, 'C', 30, 0),
        (2024, @grad_id, 'A', 30, 0),
        (2024, @grad_id, 'B', 30, 0),
        (2024, @grad_id, 'C', 30, 0);
    SET @grad_id = @grad_id + 1;
END;

-- Insertar Cursos
SET @grad_id = 1;

-- Cursos para cada grado de Primaria (1 a 6)
WHILE @grad_id <= 6
BEGIN
    IF @grad_id = 1
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Personal Social'),
            (@grad_id, 'Ingles'),
            (@grad_id, 'Ciencia y Tecnologia'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Matematicas'),
            (@grad_id, 'Comunicacion'),
            (@grad_id, 'Razonamiento Matematico'),
            (@grad_id, 'Religion');
    END
    ELSE IF @grad_id = 2
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Personal Social'),
            (@grad_id, 'Ciencia y Tecnologia'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Comunicacion'),
            (@grad_id, 'Religion'),
            (@grad_id, 'Matematicas'),
            (@grad_id, 'Ingles'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Razonamiento Matematico');
    END
    ELSE IF @grad_id = 3
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Ciencia y Tecnologia'),
            (@grad_id, 'Personal Social'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Comunicacion'),
            (@grad_id, 'Ingles'),
            (@grad_id, 'Religion'),
            (@grad_id, 'Matematicas'),
            (@grad_id, 'Razonamiento Matematico');
    END
    ELSE IF @grad_id = 4
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Ingles'),
            (@grad_id, 'Ciencia y Tecnologia'),
            (@grad_id, 'Matematicas'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Religion'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Comunicacion'),
            (@grad_id, 'Razonamiento Matematico'),
            (@grad_id, 'Personal Social');
    END
    ELSE IF @grad_id = 5
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Personal Social'),
            (@grad_id, 'Razonamiento Matematico'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Comunicacion'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Matematicas'),
            (@grad_id, 'Religion'),
            (@grad_id, 'Ingles'),
            (@grad_id, 'Ciencia y Tecnologia');
    END
    ELSE IF @grad_id = 6
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Razonamiento Matematico'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Comunicacion'),
            (@grad_id, 'Ciencia y Tecnologia'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Personal Social'),
            (@grad_id, 'Matematicas'),
            (@grad_id, 'Religion'),
            (@grad_id, 'Ingles');
    END
    SET @grad_id = @grad_id + 1;
END;

-- Cursos para cada grado de Secundaria (1 a 5)
SET @grad_id = 7;
WHILE @grad_id <= 11
BEGIN
    IF @grad_id = 7
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Algebra'),
            (@grad_id, 'Aritmetica'),
            (@grad_id, 'Biologia'),
            (@grad_id, 'Fisica'),
            (@grad_id, 'Quimica'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Geografia'),
            (@grad_id, 'Historia del Peru'),
            (@grad_id, 'Literatura'),
            (@grad_id, 'Lengua'),
            (@grad_id, 'Razonamiento Matematico'),
            (@grad_id, 'Historia Universal'),
            (@grad_id, 'Geometria'),
            (@grad_id, 'Ingles');
    END
    ELSE IF @grad_id = 8 OR @grad_id = 9 OR @grad_id = 10
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Algebra'),
            (@grad_id, 'Aritmetica'),
            (@grad_id, 'Biologia'),
            (@grad_id, 'Fisica'),
            (@grad_id, 'Quimica'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Geografia'),
            (@grad_id, 'Historia del Peru'),
            (@grad_id, 'Literatura'),
            (@grad_id, 'Lengua'),
            (@grad_id, 'Razonamiento Matematico'),
            (@grad_id, 'Historia Universal'),
            (@grad_id, 'Geometria'),
            (@grad_id, 'Ingles');
    END
    ELSE IF @grad_id = 11
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Geometria'),
            (@grad_id, 'Quimica'),
            (@grad_id, 'Razonamiento Matematico'),
            (@grad_id, 'Literatura'),
            (@grad_id, 'Historia Universal'),
            (@grad_id, 'Biologia'),
            (@grad_id, 'Economia'),
            (@grad_id, 'Historia del Peru'),
            (@grad_id, 'Lengua'),
            (@grad_id, 'Trigonometria'),
            (@grad_id, 'Fisica'),
            (@grad_id, 'Aritmetica'),
            (@grad_id, 'Algebra'),
            (@grad_id, 'Ingles');
    END
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
    ('Perez', 'Juan', 'Av. Siempre Viva 123', '984731256'),
    ('Gomez', 'Maria', 'Calle Falsa 456', '972643851'),
    ('Lopez', 'Carlos', 'Jr. Primavera 789', '953172684'),
    ('Rodriguez', 'Ana', 'Av. Los Rosales 321', '968234715'),
    ('Martinez', 'Jose', 'Calle Los Olivos 654', '987415263'),
    ('Garcia', 'Luis', 'Jr. Lima 123', '945362178'),
    ('Hernandez', 'Claudia', 'Av. Tupac Amaru 456', '962487315'),
    ('Torres', 'Rosa', 'Jr. Ayacucho 789', '976543218'),
    ('Sanchez', 'Pedro', 'Av. Grau 321', '953267481'),
    ('Diaz', 'Elena', 'Calle Central 654', '987354621');

-- Insertar Empleados
INSERT INTO EMPLEADO (emp_apellido, emp_nombre, emp_direccion, emp_email, emp_usuario, emp_clave)
VALUES 
    ('Gomez', 'Carlos', 'Av. Los Cedros 145', 'carlos@colegio.com', 'cgomez', '92837465'),
    ('Lopez', 'Ana', 'Jr. La Esperanza 231', 'ana@colegio.com', 'alopez', '73529184'),
    ('Martinez', 'Pedro', 'Calle Los Tulipanes 678', 'pedro@colegio.com', 'pmartinez', '18273645'),
    ('Fernandez', 'Lucia', 'Av. Los Pinos 321', 'lucia@colegio.com', 'lfernandez', '64739281'),
    ('Sanchez', 'Jorge', 'Jr. Los Rosales 555', 'jorge@colegio.com', 'jsanchez', '53928471');

-- Insertar Profesores con nombres y apellidos específicos y DNIs de 8 dígitos y teléfonos más realistas
INSERT INTO PROFESOR (prof_apellido, prof_nombre, prof_dni, prof_direccion, prof_email, prof_telefono)
VALUES 
    ('Ramirez', 'Alberto', '72456391', 'Calle Los Sauces 123', 'ramirez.alberto@colegio.com', '987643201'),
    ('Quispe', 'Marta', '81234567', 'Av. Las Flores 456', 'quispe.marta@colegio.com', '912354678'),
    ('Castro', 'Julia', '76543210', 'Jr. Pinos 789', 'castro.julia@colegio.com', '945672389'),
    ('Salazar', 'Fernando', '63527182', 'Av. San Juan 321', 'salazar.fernando@colegio.com', '976823491'),
    ('Rojas', 'Ines', '85341297', 'Calle Sol 654', 'rojas.ines@colegio.com', '984561230'),
    ('Mendoza', 'Pablo', '72458963', 'Jr. Lirios 123', 'mendoza.pablo@colegio.com', '987345621'),
    ('Paredes', 'Luz', '83725491', 'Av. Olivos 456', 'paredes.luz@colegio.com', '944567283'),
    ('Chavez', 'Andres', '61235478', 'Jr. Palmeras 789', 'chavez.andres@colegio.com', '972345678'),
    ('Vega', 'Carmen', '79243865', 'Calle Los Alamos 321', 'vega.carmen@colegio.com', '953217846'),
    ('Ortega', 'Luis', '63421587', 'Av. Nogales 654', 'ortega.luis@colegio.com', '987312549'),
    ('Navarro', 'Silvia', '81243657', 'Calle Azucenas 123', 'navarro.silvia@colegio.com', '961243578'),
    ('Reyes', 'Ricardo', '72536419', 'Av. Jazmines 456', 'reyes.ricardo@colegio.com', '975312486'),
    ('Gutierrez', 'Angela', '84321765', 'Jr. Rosas 789', 'gutierrez.angela@colegio.com', '982435617'),
    ('Valdez', 'Mario', '76231458', 'Av. Sauce 321', 'valdez.mario@colegio.com', '956213487'),
    ('Escobar', 'Patricia', '69231485', 'Calle Lima 654', 'escobar.patricia@colegio.com', '968245316'),
    ('Rios', 'Hugo', '78245639', 'Av. Central 123', 'rios.hugo@colegio.com', '943215867'),
    ('Figueroa', 'Celia', '84123765', 'Jr. Esperanza 456', 'figueroa.celia@colegio.com', '967432815'),
    ('Villanueva', 'Raul', '65421378', 'Calle Nueva 789', 'villanueva.raul@colegio.com', '953278416'),
    ('Acosta', 'Blanca', '73241568', 'Av. Los Heroes 321', 'acosta.blanca@colegio.com', '986345127'),
    ('Ruiz', 'Eduardo', '82134675', 'Jr. Alameda 654', 'ruiz.eduardo@colegio.com', '958214637');

-- Insertar Matriculas (asegurando la referencia de sec_id existente)
INSERT INTO MATRICULA (alu_id, sec_id, emp_id, mat_fecha, mat_precio, mat_estado)
VALUES 
    (1, 1, 1, '2023-03-01', 100, 'Activo'),
    (2, 2, 1, '2023-03-01', 100, 'Activo'),
    (3, 3, 1, '2023-03-01', 100, 'Activo');

-- Insertar Pagos asegurando que pag_importe no sea NULL
DECLARE @mat_id INT = 1;
DECLARE @pag_fecha DATE;
DECLARE @pag_cuota INT;
DECLARE @mensualidad DECIMAL(10,2);

WHILE @mat_id <= 3
BEGIN
    -- Verificar que @mensualidad no sea NULL
    SELECT @mensualidad = grad_mensualidad 
    FROM GRADO 
    WHERE grad_id = (SELECT grad_id FROM SECCION WHERE sec_id = (SELECT sec_id FROM MATRICULA WHERE mat_id = @mat_id));

    -- Si @mensualidad es NULL, asignarle un valor predeterminado (por ejemplo, 0)
    IF @mensualidad IS NULL
    BEGIN
        SET @mensualidad = 0;
    END

    -- Primer mes (ultimo dia de marzo)
    SET @pag_fecha = EOMONTH('2023-03-01');
    SET @pag_cuota = 1;
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_cuota, pag_importe)
    VALUES (@mat_id, 1, @pag_fecha, @pag_cuota, @mensualidad);

    -- Segundo mes (ultimo dia de abril)
    SET @pag_fecha = EOMONTH('2023-04-01');
    SET @pag_cuota = 2;
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_cuota, pag_importe)
    VALUES (@mat_id, 1, @pag_fecha, @pag_cuota, @mensualidad);

    SET @mat_id = @mat_id + 1;
END;

