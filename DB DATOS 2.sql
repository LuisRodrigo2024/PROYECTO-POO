USE BDCOLEGIO;
GO

-- Insertar Usuarios con contraseñas en formato 0001, 0002, 0003, etc.
INSERT INTO USUARIO (nombre_usuario, contrasena, rol, correo_electronico)
VALUES 
    ('director', '0001', 'director', 'director@colegio.com'),
    ('subdirector', '0002', 'subdirector', 'subdirector@colegio.com'),
    ('administrativo', '0003', 'administrativo', 'administrativo@colegio.com');

-- Insertar Grados (1ero a 6to de primaria y 1ero a 5to de secundaria)
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

-- -- Insertar Año con fechas de inicio y fin personalizadas
-- Fecha de inicio: Primer lunes de marzo
-- Fecha de fin: Segundo viernes de diciembre

DECLARE @anio INT = 2023;
WHILE @anio <= 2024
BEGIN
    -- Calcular el primer lunes de marzo
    DECLARE @anio_inicio DATE = DATEADD(DAY, 
        (9 - DATEPART(WEEKDAY, DATEFROMPARTS(@anio, 3, 1))) % 7, -- Calcula el desfase para el primer lunes
        DATEFROMPARTS(@anio, 3, 1) -- Fecha base: 1 de marzo
    );

    -- Calcular el segundo viernes de diciembre
    DECLARE @anio_fin DATE = DATEADD(DAY, 
        (5 - DATEPART(WEEKDAY, DATEFROMPARTS(@anio, 12, 1)) + 7) % 7 + 7, -- Calcula el desfase para el segundo viernes
        DATEFROMPARTS(@anio, 12, 1) -- Fecha base: 1 de diciembre
    );

    -- Insertar el año y las fechas calculadas en la tabla
    INSERT INTO ANIO (anio_id, anio_inicio, anio_fin)
    VALUES 
        (@anio, @anio_inicio, @anio_fin);

    -- Incrementar el año para la próxima iteración
    SET @anio = @anio + 1;
END;


-- Insertar Secciones para 2023
DECLARE @grad_id INT = 1;
WHILE @grad_id <= 11
BEGIN
    -- Insertar secciones A, B y C para cada grad_id
    INSERT INTO SECCION (anio_id, grad_id, sec_nombre, sec_vacantes, sec_matriculados)
    VALUES 
        (2023, @grad_id, 'A', 30, 10),
        (2023, @grad_id, 'B', 30, 10),
        (2023, @grad_id, 'C', 30, 10);
    SET @grad_id = @grad_id + 1;
END;

-- Insertar Secciones para 2024
SET @grad_id = 1;
WHILE @grad_id <= 11
BEGIN
    -- Insertar secciones A, B y C para cada grad_id
    INSERT INTO SECCION (anio_id, grad_id, sec_nombre, sec_vacantes, sec_matriculados)
    VALUES 
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
            (@grad_id, 'Inglés'),
            (@grad_id, 'Ciencia y Tecnología'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Matemáticas'),
            (@grad_id, 'Comunicación'),
            (@grad_id, 'Razonamiento Matemático'),
            (@grad_id, 'Religión');
    END
    ELSE IF @grad_id = 2
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Personal Social'),
            (@grad_id, 'Ciencia y Tecnología'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Comunicación'),
            (@grad_id, 'Religión'),
            (@grad_id, 'Matemáticas'),
            (@grad_id, 'Inglés'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Razonamiento Matemático');
    END
    ELSE IF @grad_id = 3
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Ciencia y Tecnología'),
            (@grad_id, 'Personal Social'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Comunicación'),
            (@grad_id, 'Inglés'),
            (@grad_id, 'Religión'),
            (@grad_id, 'Matemáticas'),
            (@grad_id, 'Razonamiento Matemático');
    END
    ELSE IF @grad_id = 4
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Inglés'),
            (@grad_id, 'Ciencia y Tecnología'),
            (@grad_id, 'Matemáticas'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Religión'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Comunicación'),
            (@grad_id, 'Razonamiento Matemático'),
            (@grad_id, 'Personal Social');
    END
    ELSE IF @grad_id = 5
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Personal Social'),
            (@grad_id, 'Razonamiento Matemático'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Comunicación'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Matemáticas'),
            (@grad_id, 'Religión'),
            (@grad_id, 'Inglés'),
            (@grad_id, 'Ciencia y Tecnología');
    END
    ELSE IF @grad_id = 6
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Razonamiento Matemático'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Comunicación'),
            (@grad_id, 'Ciencia y Tecnología'),
            (@grad_id, 'Computo'),
            (@grad_id, 'Personal Social'),
            (@grad_id, 'Matemáticas'),
            (@grad_id, 'Religión'),
            (@grad_id, 'Inglés');
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
            (@grad_id, 'Álgebra'),
            (@grad_id, 'Aritmética'),
            (@grad_id, 'Biología'),
            (@grad_id, 'Física'),
            (@grad_id, 'Química'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Geografía'),
            (@grad_id, 'Historia del Perú'),
            (@grad_id, 'Literatura'),
            (@grad_id, 'Lengua'),
            (@grad_id, 'Razonamiento Matemático'),
            (@grad_id, 'Historia Universal'),
            (@grad_id, 'Geometría'),
            (@grad_id, 'Inglés');
    END
    ELSE IF @grad_id = 8 OR @grad_id = 9 OR @grad_id = 10
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Álgebra'),
            (@grad_id, 'Aritmética'),
            (@grad_id, 'Biología'),
            (@grad_id, 'Física'),
            (@grad_id, 'Química'),
            (@grad_id, 'Razonamiento Verbal'),
            (@grad_id, 'Geografía'),
            (@grad_id, 'Historia del Perú'),
            (@grad_id, 'Literatura'),
            (@grad_id, 'Lengua'),
            (@grad_id, 'Razonamiento Matemático'),
            (@grad_id, 'Historia Universal'),
            (@grad_id, 'Geometría'),
            (@grad_id, 'Inglés');
    END
    ELSE IF @grad_id = 11
    BEGIN
        INSERT INTO CURSO (grad_id, cur_nombre) VALUES 
            (@grad_id, 'Geometría'),
            (@grad_id, 'Química'),
            (@grad_id, 'Razonamiento Matemático'),
            (@grad_id, 'Literatura'),
            (@grad_id, 'Historia Universal'),
            (@grad_id, 'Biología'),
            (@grad_id, 'Economía'),
            (@grad_id, 'Historia del Perú'),
            (@grad_id, 'Lengua'),
            (@grad_id, 'Trigonometría'),
            (@grad_id, 'Física'),
            (@grad_id, 'Aritmética'),
			(@grad_id, 'Álgebra'),
            (@grad_id, 'Inglés');
    END
    SET @grad_id = @grad_id + 1;
END;

-- Insertar Alumnos con teléfonos más realistas
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

-- Insertar Empleados con direcciones más realistas y usuarios que combinan letras de nombres y apellidos
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

-- Insertar Matrículas (solo 3 alumnos matriculados)
INSERT INTO MATRICULA (alu_id, sec_id, emp_id, mat_fecha, mat_precio, mat_estado)
VALUES 
    (1, 1, 1, '2023-03-01', 100, 'Activo'),
    (2, 2, 1, '2023-03-01', 100, 'Activo'),
    (3, 3, 1, '2023-03-01', 100, 'Activo');

-- Insertar Pagos para los alumnos matriculados (primer y segundo mes) con relación a la mensualidad del grado
DECLARE @mat_id INT = 1;
DECLARE @pag_fecha DATE;
DECLARE @pag_cuota INT;
DECLARE @mensualidad DECIMAL(10,2);

WHILE @mat_id <= 3
BEGIN
    -- Obtener la mensualidad del grado al que pertenece la matrícula
    SET @mensualidad = (SELECT grad_mensualidad 
                        FROM GRADO 
                        WHERE grad_id = (SELECT grad_id 
                                         FROM SECCION 
                                         WHERE sec_id = (SELECT sec_id 
                                                         FROM MATRICULA 
                                                         WHERE mat_id = @mat_id)));

    -- Primer mes (último día de marzo)
    SET @pag_fecha = EOMONTH('2023-03-01');
    SET @pag_cuota = 1;
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_cuota, pag_importe)
    VALUES (@mat_id, 1, @pag_fecha, @pag_cuota, @mensualidad);

    -- Segundo mes (último día de abril)
    SET @pag_fecha = EOMONTH('2023-04-01');
    SET @pag_cuota = 2;
    INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_cuota, pag_importe)
    VALUES (@mat_id, 1, @pag_fecha, @pag_cuota, @mensualidad);

    SET @mat_id = @mat_id + 1;
END;
