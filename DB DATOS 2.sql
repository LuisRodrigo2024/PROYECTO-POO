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

-- Insertar Año con fechas de inicio y fin personalizadas
-- Fecha de inicio: Primer lunes de marzo
-- Fecha de fin: Viernes a mitad de diciembre

DECLARE @anio INT = 2023;
WHILE @anio <= 2024
BEGIN
    -- Calcular el primer lunes de marzo
    DECLARE @anio_inicio DATE = DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEFROMPARTS(@anio, 3, 1)), 1);

    -- Calcular un viernes en la segunda semana de diciembre
    DECLARE @anio_fin DATE = DATEADD(DAY, 11, DATEFROMPARTS(@anio, 12, 1));
    
    INSERT INTO ANIO (anio_id, anio_inicio, anio_fin)
    VALUES 
        (@anio, @anio_inicio, @anio_fin);

    SET @anio = @anio + 1;
END;

-- Insertar Secciones para 2023
DECLARE @grad_id INT = 1;
WHILE @grad_id <= 11
BEGIN
    INSERT INTO SECCION (anio_id, grad_id, sec_nombre, sec_vacantes, sec_matriculados)
    VALUES 
        (2023, @grad_id, 'A', 30, 10);
    SET @grad_id = @grad_id + 1;
END;

-- Insertar Secciones para 2024
SET @grad_id = 1;
WHILE @grad_id <= 11
BEGIN
    INSERT INTO SECCION (anio_id, grad_id, sec_nombre, sec_vacantes, sec_matriculados)
    VALUES 
        (2024, @grad_id, 'A', 30, 0);
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

-- Insertar Alumnos
INSERT INTO ALUMNO (alu_apellido, alu_nombre, alu_direccion, alu_telefono)
VALUES 
    ('Perez', 'Juan', 'Av. Siempre Viva 123', '987654321'),
    ('Gomez', 'Maria', 'Calle Falsa 456', '987654322'),
    ('Lopez', 'Carlos', 'Jr. Primavera 789', '987654323'),
    ('Rodriguez', 'Ana', 'Av. Los Rosales 321', '987654324'),
    ('Martinez', 'Jose', 'Calle Los Olivos 654', '987654325'),
    ('Garcia', 'Luis', 'Jr. Lima 123', '987654326'),
    ('Hernandez', 'Claudia', 'Av. Tupac Amaru 456', '987654327'),
    ('Torres', 'Rosa', 'Jr. Ayacucho 789', '987654328'),
    ('Sanchez', 'Pedro', 'Av. Grau 321', '987654329'),
    ('Diaz', 'Elena', 'Calle Central 654', '987654330');

-- Insertar Empleados con contraseñas en formato 000001, 000002, etc.
INSERT INTO EMPLEADO (emp_apellido, emp_nombre, emp_direccion, emp_email, emp_usuario, emp_clave)
VALUES 
    ('Gomez', 'Carlos', 'Calle 123', 'carlos@colegio.com', 'carlos', '000001'),
    ('Lopez', 'Ana', 'Calle 456', 'ana@colegio.com', 'ana', '000002'),
    ('Martinez', 'Pedro', 'Calle 789', 'pedro@colegio.com', 'pedro', '000003'),
    ('Fernandez', 'Lucia', 'Calle 101', 'lucia@colegio.com', 'lucia', '000004'),
    ('Sanchez', 'Jorge', 'Calle 202', 'jorge@colegio.com', 'jorge', '000005');

-- Insertar Profesores con nombres y apellidos específicos y DNIs de 8 dígitos
INSERT INTO PROFESOR (prof_apellido, prof_nombre, prof_dni, prof_direccion, prof_email, prof_telefono)
VALUES 
    ('Ramirez', 'Alberto', '10000001', 'Calle Los Sauces 123', 'ramirez.alberto@colegio.com', '987654331'),
    ('Quispe', 'Marta', '10000002', 'Av. Las Flores 456', 'quispe.marta@colegio.com', '987654332'),
    ('Castro', 'Julia', '10000003', 'Jr. Pinos 789', 'castro.julia@colegio.com', '987654333'),
    ('Salazar', 'Fernando', '10000004', 'Av. San Juan 321', 'salazar.fernando@colegio.com', '987654334'),
    ('Rojas', 'Ines', '10000005', 'Calle Sol 654', 'rojas.ines@colegio.com', '987654335'),
    ('Mendoza', 'Pablo', '10000006', 'Jr. Lirios 123', 'mendoza.pablo@colegio.com', '987654336'),
    ('Paredes', 'Luz', '10000007', 'Av. Olivos 456', 'paredes.luz@colegio.com', '987654337'),
    ('Chavez', 'Andres', '10000008', 'Jr. Palmeras 789', 'chavez.andres@colegio.com', '987654338'),
    ('Vega', 'Carmen', '10000009', 'Calle Los Alamos 321', 'vega.carmen@colegio.com', '987654339'),
    ('Ortega', 'Luis', '10000010', 'Av. Nogales 654', 'ortega.luis@colegio.com', '987654340'),
    ('Navarro', 'Silvia', '10000011', 'Calle Azucenas 123', 'navarro.silvia@colegio.com', '987654341'),
    ('Reyes', 'Ricardo', '10000012', 'Av. Jazmines 456', 'reyes.ricardo@colegio.com', '987654342'),
    ('Gutierrez', 'Angela', '10000013', 'Jr. Rosas 789', 'gutierrez.angela@colegio.com', '987654343'),
    ('Valdez', 'Mario', '10000014', 'Av. Sauce 321', 'valdez.mario@colegio.com', '987654344'),
    ('Escobar', 'Patricia', '10000015', 'Calle Lima 654', 'escobar.patricia@colegio.com', '987654345'),
    ('Rios', 'Hugo', '10000016', 'Av. Central 123', 'rios.hugo@colegio.com', '987654346'),
    ('Figueroa', 'Celia', '10000017', 'Jr. Esperanza 456', 'figueroa.celia@colegio.com', '987654347'),
    ('Villanueva', 'Raul', '10000018', 'Calle Nueva 789', 'villanueva.raul@colegio.com', '987654348'),
    ('Acosta', 'Blanca', '10000019', 'Av. Los Heroes 321', 'acosta.blanca@colegio.com', '987654349'),
    ('Ruiz', 'Eduardo', '10000020', 'Jr. Alameda 654', 'ruiz.eduardo@colegio.com', '987654350');

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

-- Insertar Sección Curso (relacionar secciones con cursos y profesores)
DECLARE @sec_id INT = 1;
DECLARE @prof_id INT = 1;
DECLARE @cur_id INT = 1;
WHILE @sec_id <= 11
BEGIN
    SET @cur_id = (SELECT MIN(cur_id) FROM CURSO WHERE grad_id = (SELECT grad_id FROM SECCION WHERE sec_id = @sec_id));
    WHILE @cur_id IS NOT NULL
    BEGIN
        INSERT INTO SECCION_CURSO (sec_id, cur_id, prof_id)
        VALUES 
            (@sec_id, @cur_id, @prof_id);
        SET @cur_id = (SELECT MIN(cur_id) FROM CURSO WHERE grad_id = (SELECT grad_id FROM SECCION WHERE sec_id = @sec_id) AND cur_id > @cur_id);
    END;
    SET @prof_id = @prof_id + 1;
    SET @sec_id = @sec_id + 1;
END;
