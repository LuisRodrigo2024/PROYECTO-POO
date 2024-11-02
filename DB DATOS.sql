USE BDCOLEGIO;
GO

-- Insertar Usuarios
INSERT INTO USUARIO (nombre_usuario, contrasena, rol, correo_electronico)
VALUES 
    ('director', '1234', 'director', 'director@colegio.com'),
    ('subdirector', '1234', 'subdirector', 'subdirector@colegio.com'),
    ('administrativo', '1234', 'administrativo', 'administrativo@colegio.com');

-- Insertar Grados (1ero a 6to de primaria y 1ero a 5to de secundaria)
INSERT INTO GRADO (grad_numero, grad_nivel, grad_mensualidad)
VALUES 
    (1, 'Primaria', 450),
    (2, 'Primaria', 450),
    (3, 'Primaria', 450),
    (4, 'Primaria', 450),
    (5, 'Primaria', 450),
    (6, 'Primaria', 450),
    (1, 'Secundaria', 450),
    (2, 'Secundaria', 450),
    (3, 'Secundaria', 450),
    (4, 'Secundaria', 450),
    (5, 'Secundaria', 450);

-- Insertar Año
INSERT INTO ANIO (anio_id, anio_inicio, anio_fin)
VALUES 
    (2023, '2023-03-01', '2023-12-31'),
    (2024, '2024-03-01', '2024-12-31');

-- Insertar Secciones 2023
DECLARE @grad_id INT = 1;
WHILE @grad_id <= 11  -- Ahora hay 11 grados en total (6 de primaria y 5 de secundaria)
BEGIN
    INSERT INTO SECCION (anio_id, grad_id, sec_nombre, sec_vacantes, sec_matriculados)
    VALUES 
        (2023, @grad_id, 'A', 30, 10)
    SET @grad_id = @grad_id + 1;
END;
-- Insertar Secciones 2023
SET @grad_id = 1;
WHILE @grad_id <= 11  -- Ahora hay 11 grados en total (6 de primaria y 5 de secundaria)
BEGIN
    INSERT INTO SECCION (anio_id, grad_id, sec_nombre, sec_vacantes, sec_matriculados)
    VALUES 
        (2024, @grad_id, 'A', 30, 0)
    SET @grad_id = @grad_id + 1;
END;

-- Insertar Cursos
SET @grad_id = 1; -- Reutilizamos la variable
WHILE @grad_id <= 11
BEGIN
    INSERT INTO CURSO (grad_id, cur_nombre)
    VALUES 
        (@grad_id, 'Matemáticas'),
        (@grad_id, 'Lenguaje'),
        (@grad_id, 'Personal Social'),
        (@grad_id, 'Química y Física'),
        (@grad_id, 'Informática');
    SET @grad_id = @grad_id + 1;
END;

-- Insertar Alumnos
DECLARE @alu_id INT = 1;
WHILE @alu_id <= 110
BEGIN
    INSERT INTO ALUMNO (alu_apellido, alu_nombre, alu_direccion, alu_telefono)
    VALUES 
        ('Apellido' + CAST(@alu_id AS VARCHAR), 'Nombre' + CAST(@alu_id AS VARCHAR), 'Direccion' + CAST(@alu_id AS VARCHAR), 'Telefono' + CAST(@alu_id AS VARCHAR));
    SET @alu_id = @alu_id + 1;
END;

-- Insertar Empleados
INSERT INTO EMPLEADO (emp_apellido, emp_nombre, emp_direccion, emp_email, emp_usuario, emp_clave)
VALUES 
    ('Gomez', 'Carlos', 'Calle 123', 'carlos@colegio.com', 'carlos', 'clave1'),
    ('Lopez', 'Ana', 'Calle 456', 'ana@colegio.com', 'ana', 'clave2'),
    ('Martinez', 'Pedro', 'Calle 789', 'pedro@colegio.com', 'pedro', 'clave3'),
    ('Fernandez', 'Lucia', 'Calle 101', 'lucia@colegio.com', 'lucia', 'clave4'),
    ('Sanchez', 'Jorge', 'Calle 202', 'jorge@colegio.com', 'jorge', 'clave5');

-- Insertar Profesores
DECLARE @prof_id INT = 1;
WHILE @prof_id <= 11  -- Se ajusta el número de profesores a 22 para cubrir las secciones adicionales
BEGIN
    INSERT INTO PROFESOR (prof_apellido, prof_nombre, prof_dni, prof_direccion, prof_email, prof_telefono)
    VALUES 
        ('Apellido' + CAST(@prof_id AS VARCHAR), 'Nombre' + CAST(@prof_id AS VARCHAR), 'DNI' + CAST(@prof_id AS VARCHAR), 'Direccion' + CAST(@prof_id AS VARCHAR), 'profesor' + CAST(@prof_id AS VARCHAR) + '@colegio.com', 'Telefono' + CAST(@prof_id AS VARCHAR));
    SET @prof_id = @prof_id + 1;
END;

-- Insertar Matrículas
SET @alu_id = 1; -- Reutilizamos la variable
DECLARE @sec_id INT = 1;
DECLARE @emp_id INT = 1;
WHILE @alu_id <= 110
BEGIN
    INSERT INTO MATRICULA (alu_id, sec_id, emp_id, mat_fecha, mat_precio, mat_estado)
    VALUES 
        (@alu_id, @sec_id, @emp_id, '2023-03-01', 100, 'Activo');
    SET @sec_id = CASE WHEN @alu_id % 10 = 0 THEN @sec_id + 1 ELSE @sec_id END;
	SET @alu_id = @alu_id + 1;
END;

-- Insertar Pagos
DECLARE @mat_id INT = 1;
DECLARE @pag_fecha DATE = '2023-03-01';
DECLARE @pag_cuota INT = 1;
WHILE @mat_id <= 110
BEGIN
    SET @pag_fecha = '2023-03-01';
    SET @pag_cuota = 1;
    WHILE @pag_cuota <= 11
    BEGIN
        INSERT INTO PAGO (mat_id, emp_id, pag_fecha, pag_cuota, pag_importe)
        VALUES 
            (@mat_id, 1, @pag_fecha, @pag_cuota, CASE WHEN @pag_cuota = 1 THEN 100 ELSE 450 END);
        SET @pag_fecha = DATEADD(MONTH, 1, @pag_fecha);
        SET @pag_cuota = @pag_cuota + 1;
    END;
    SET @mat_id = @mat_id + 1;
END;

-- Insertar Sección Curso
SET @sec_id = 1; -- Reutilizamos la variable
SET @prof_id = 1; -- Reutilizamos la variable
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

-- Insertar Horarios
DECLARE @asig_id INT = 1;
DECLARE @hor_dia INT = 1;
DECLARE @hor_inicio TIME = '08:00:00';
DECLARE @hor_fin TIME = '09:00:00';
WHILE @asig_id <= 55  -- Se ajusta para 110 asignaciones curso-sección
BEGIN
    SET @hor_dia = 1;
    WHILE @hor_dia <= 5
    BEGIN
        INSERT INTO HORARIO (asig_id, hor_dia, hor_inicio, hor_fin)
        VALUES 
            (@asig_id, CASE @hor_dia WHEN 1 THEN 'Lunes' WHEN 2 THEN 'Martes' WHEN 3 THEN 'Miercoles' WHEN 4 THEN 'Jueves' WHEN 5 THEN 'Viernes' END, @hor_inicio, @hor_fin);
        SET @hor_dia = @hor_dia + 1;
    END;
    SET @asig_id = @asig_id + 1;
END;
GO

 
SELECT * FROM [dbo].[ALUMNO]
SELECT * FROM [dbo].[ANIO]
SELECT * FROM [dbo].[CURSO]
SELECT * FROM [dbo].[EMPLEADO]
SELECT * FROM [dbo].[GRADO]
SELECT * FROM [dbo].[HORARIO]
SELECT * FROM [dbo].[MATRICULA]
SELECT * FROM [dbo].[NOTA]
SELECT * FROM [dbo].[PAGO]
SELECT * FROM [dbo].[PROFESOR]
SELECT * FROM [dbo].[SECCION]
SELECT * FROM [dbo].[SECCION_CURSO]
SELECT * FROM [dbo].[USUARIO]