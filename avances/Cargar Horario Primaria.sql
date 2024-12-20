--------------------------------------
-- Cargar tablas:
-- Curso_Seccion
--------------------------------------
-- Cargamos datos de primaria para la tabla SECCION_CURSO
-- Configuraci�n de la tabla SECCION_CURSO con un l�mite de dos cursos por profesor
DECLARE @sec_id INT = 1;         -- ID de la secci�n, comienza en 1 y avanza con cada grado
DECLARE @prof_id INT = 1;        -- ID del profesor, comienza en 1
DECLARE @curso1 INT;             -- Primer curso asignado al profesor
DECLARE @curso2 INT;             -- Segundo curso asignado al profesor
DECLARE @max_prof_id INT = 20;   -- N�mero m�ximo de profesores en el colegio (ajustar seg�n necesidad)

-- Asignaci�n inicial de cursos a profesores para limitar cada uno a dos cursos espec�ficos
DECLARE @prof_curso TABLE (prof_id INT, curso1 INT, curso2 INT);

-- Asignamos dos cursos �nicos a cada profesor
INSERT INTO @prof_curso (prof_id, curso1, curso2)
VALUES 
    (1, 1, 2), (2, 3, 4), (3, 5, 6), (4, 7, 8), (5, 9, 10),
    (6, 11, 12), (7, 13, 14), (8, 15, 16), (9, 17, 18), (10, 19, 20),
    (11, 21, 22), (12, 23, 24), (13, 25, 26), (14, 27, 28), (15, 29, 30),
    (16, 31, 32), (17, 33, 34), (18, 35, 36), (19, 37, 38), (20, 39, 40);

-- Bucle para asignar cursos a cada secci�n
WHILE @sec_id <= 18              -- Cambia este l�mite seg�n el n�mero total de secciones
BEGIN
    -- Obtener los cursos asignados para el profesor actual
    SELECT @curso1 = curso1, @curso2 = curso2
    FROM @prof_curso
    WHERE prof_id = @prof_id;

    -- Insertar el primer curso para la secci�n actual
    INSERT INTO SECCION_CURSO (sec_id, cur_id, prof_id)
    VALUES (@sec_id, @curso1, @prof_id);

    -- Insertar el segundo curso para la secci�n actual
    INSERT INTO SECCION_CURSO (sec_id, cur_id, prof_id)
    VALUES (@sec_id, @curso2, @prof_id);

    -- Avanzar a la siguiente secci�n
    SET @sec_id = @sec_id + 1;

    -- Avanzar al siguiente profesor
    SET @prof_id = @prof_id + 1;

    -- Reiniciar el ID de profesor si supera el n�mero m�ximo de profesores
    IF @prof_id > @max_prof_id
        SET @prof_id = 1;
END


--Cargamos el horario de primaria

INSERT INTO HORARIO([asig_id], [hor_dia], [hor_inicio], [hor_fin]) VALUES
--Primer grado
(8,'Lunes','08:00','08:45'),
(8,'Lunes','08:45','09:30'),
(8,'Lunes','09:30','10:15'),
(8,'Lunes','10:30','11:15'),
(1,'Lunes','11:15','12:00'),
(1,'Lunes','12:15','01:00'),
(1,'Lunes','01:00','01:45'),
(1,'Lunes','01:45','02:30'),
(9,'Martes','08:00','08:45'),
(9,'Martes','08:45','09:30'),
(9,'Martes','09:30','10:15'),
(9,'Martes','10:30','11:15'),
(2,'Martes','11:15','12:00'),
(2,'Martes','12:15','01:00'),
(2,'Martes','01:00','01:45'),
(2,'Martes','01:45','02:30'),
(6,'Miercoles','08:00','08:45'),
(6,'Miercoles','08:45','09:30'),
(6,'Miercoles','09:30','10:15'),
(7,'Miercoles','10:30','11:15'),
(7,'Miercoles','11:15','12:00'),
(3,'Miercoles','12:15','01:00'),
(3,'Miercoles','01:00','01:45'),
(3,'Miercoles','01:45','02:30'),
(6,'Jueves','08:00','08:45'),
(6,'Jueves','08:45','09:30'),
(6,'Jueves','09:30','10:15'),
(7,'Jueves','10:30','11:15'),
(7,'Jueves','11:15','12:00'),
(3,'Jueves','12:15','01:00'),
(3,'Jueves','01:00','01:45'),
(3,'Jueves','01:45','02:30'),
(5,'Viernes','08:00','08:45'),
(5,'Viernes','08:45','09:30'),
(5,'Viernes','09:30','10:15'),
(5,'Viernes','10:30','11:15'),
(4,'Viernes','11:15','12:00'),
(4,'Viernes','12:15','01:00'),
(4,'Viernes','01:00','01:45'),
(4,'Viernes','01:45','02:30'),
(18,'Lunes','08:00','08:45'),
(18,'Lunes','08:45','09:30'),
(18,'Lunes','09:30','10:15'),
(11,'Lunes','10:30','11:15'),
(11,'Lunes','11:15','12:00'),
(12,'Lunes','12:15','01:00'),
(12,'Lunes','01:00','01:45'),
(12,'Lunes','01:45','02:30'),
(15,'Martes','08:00','08:45'),
(15,'Martes','08:45','09:30'),
(15,'Martes','09:30','10:15'),
(17,'Martes','10:30','11:15'),
(17,'Martes','11:15','12:00'),
(10,'Martes','12:15','01:00'),
(10,'Martes','01:00','01:45'),
(10,'Martes','01:45','02:30'),
(14,'Miercoles','08:00','08:45'),
(14,'Miercoles','08:45','09:30'),
(14,'Miercoles','09:30','10:15'),
(16,'Miercoles','10:30','11:15'),
(16,'Miercoles','11:15','12:00'),
(13,'Miercoles','12:15','01:00'),
(13,'Miercoles','01:00','01:45'),
(13,'Miercoles','01:45','02:30'),
(10,'Jueves','08:00','08:45'),
(10,'Jueves','08:45','09:30'),
(10,'Jueves','09:30','10:15'),
(15,'Jueves','10:30','11:15'),
(15,'Jueves','11:15','12:00'),
(18,'Jueves','12:15','01:00'),
(18,'Jueves','01:00','01:45'),
(18,'Jueves','01:45','02:30'),
(12,'Viernes','08:00','08:45'),
(12,'Viernes','08:45','09:30'),
(12,'Viernes','09:30','10:15'),
(11,'Viernes','10:30','11:15'),
(11,'Viernes','11:15','12:00'),
(17,'Viernes','12:15','01:00'),
(17,'Viernes','01:00','01:45'),
(17,'Viernes','01:45','02:30'),
(24,'Lunes','08:00','08:45'),
(24,'Lunes','08:45','09:30'),
(24,'Lunes','09:30','10:15'),
(27,'Lunes','10:30','11:15'),
(27,'Lunes','11:15','12:00'),
(20,'Lunes','12:15','01:00'),
(20,'Lunes','01:00','01:45'),
(20,'Lunes','01:45','02:30'),
(21,'Martes','08:00','08:45'),
(21,'Martes','08:45','09:30'),
(21,'Martes','09:30','10:15'),
(23,'Martes','10:30','11:15'),
(23,'Martes','11:15','12:00'),
(22,'Martes','12:15','01:00'),
(22,'Martes','01:00','01:45'),
(22,'Martes','01:45','02:30'),
(26,'Miercoles','08:00','08:45'),
(26,'Miercoles','08:45','09:30'),
(26,'Miercoles','09:30','10:15'),
(25,'Miercoles','10:30','11:15'),
(25,'Miercoles','11:15','12:00'),
(19,'Miercoles','12:15','01:00'),
(19,'Miercoles','01:00','01:45'),
(19,'Miercoles','01:45','02:30'),
(20,'Jueves','08:00','08:45'),
(20,'Jueves','08:45','09:30'),
(20,'Jueves','09:30','10:15'),
(21,'Jueves','10:30','11:15'),
(21,'Jueves','11:15','12:00'),
(24,'Jueves','12:15','01:00'),
(24,'Jueves','01:00','01:45'),
(24,'Jueves','01:45','02:30'),
(27,'Viernes','08:00','08:45'),
(27,'Viernes','08:45','09:30'),
(27,'Viernes','09:30','10:15'),
(23,'Viernes','10:30','11:15'),
(23,'Viernes','11:15','12:00'),
(26,'Viernes','12:15','01:00'),
(26,'Viernes','01:00','01:45'),
(26,'Viernes','01:45','02:30'),
--Segundo Grado
(30,'Lunes','08:00','08:45'),
(30,'Lunes','08:45','09:30'),
(30,'Lunes','09:30','10:15'),
(29,'Lunes','10:30','11:15'),
(29,'Lunes','11:15','12:00'),
(36,'Lunes','12:15','01:00'),
(36,'Lunes','01:00','01:45'),
(36,'Lunes','01:45','02:30'),
(32,'Martes','08:00','08:45'),
(32,'Martes','08:45','09:30'),
(32,'Martes','09:30','10:15'),
(34,'Martes','10:30','11:15'),
(34,'Martes','11:15','12:00'),
(28,'Martes','12:15','01:00'),
(28,'Martes','01:00','01:45'),
(28,'Martes','01:45','02:30'),
(33,'Miercoles','08:00','08:45'),
(33,'Miercoles','08:45','09:30'),
(33,'Miercoles','09:30','10:15'),
(35,'Miercoles','10:30','11:15'),
(35,'Miercoles','11:15','12:00'),
(31,'Miercoles','12:15','01:00'),
(31,'Miercoles','01:00','01:45'),
(31,'Miercoles','01:45','02:30'),
(28,'Jueves','08:00','08:45'),
(28,'Jueves','08:45','09:30'),
(28,'Jueves','09:30','10:15'),
(29,'Jueves','10:30','11:15'),
(29,'Jueves','11:15','12:00'),
(33,'Jueves','12:15','01:00'),
(33,'Jueves','01:00','01:45'),
(33,'Jueves','01:45','02:30'),
(36,'Viernes','08:00','08:45'),
(36,'Viernes','08:45','09:30'),
(36,'Viernes','09:30','10:15'),
(30,'Viernes','10:30','11:15'),
(30,'Viernes','11:15','12:00'),
(32,'Viernes','12:15','01:00'),
(32,'Viernes','01:00','01:45'),
(32,'Viernes','01:45','02:30'),
(45,'Lunes','08:00','08:45'),
(45,'Lunes','08:45','09:30'),
(45,'Lunes','09:30','10:15'),
(41,'Lunes','10:30','11:15'),
(41,'Lunes','11:15','12:00'),
(39,'Lunes','12:15','01:00'),
(39,'Lunes','01:00','01:45'),
(39,'Lunes','01:45','02:30'),
(38,'Martes','08:00','08:45'),
(38,'Martes','08:45','09:30'),
(38,'Martes','09:30','10:15'),
(42,'Martes','10:30','11:15'),
(42,'Martes','11:15','12:00'),
(37,'Martes','12:15','01:00'),
(37,'Martes','01:00','01:45'),
(37,'Martes','01:45','02:30'),
(40,'Miercoles','08:00','08:45'),
(40,'Miercoles','08:45','09:30'),
(40,'Miercoles','09:30','10:15'),
(43,'Miercoles','10:30','11:15'),
(43,'Miercoles','11:15','12:00'),
(44,'Miercoles','12:15','01:00'),
(44,'Miercoles','01:00','01:45'),
(44,'Miercoles','01:45','02:30'),
(42,'Jueves','08:00','08:45'),
(42,'Jueves','08:45','09:30'),
(42,'Jueves','09:30','10:15'),
(37,'Jueves','10:30','11:15'),
(37,'Jueves','11:15','12:00'),
(45,'Jueves','12:15','01:00'),
(45,'Jueves','01:00','01:45'),
(45,'Jueves','01:45','02:30'),
(39,'Viernes','08:00','08:45'),
(39,'Viernes','08:45','09:30'),
(39,'Viernes','09:30','10:15'),
(38,'Viernes','10:30','11:15'),
(38,'Viernes','11:15','12:00'),
(41,'Viernes','12:15','01:00'),
(41,'Viernes','01:00','01:45'),
(41,'Viernes','01:45','02:30'),
(51,'Lunes','08:00','08:45'),
(51,'Lunes','08:45','09:30'),
(51,'Lunes','09:30','10:15'),
(54,'Lunes','10:30','11:15'),
(54,'Lunes','11:15','12:00'),
(47,'Lunes','12:15','01:00'),
(47,'Lunes','01:00','01:45'),
(47,'Lunes','01:45','02:30'),
(53,'Martes','08:00','08:45'),
(53,'Martes','08:45','09:30'),
(53,'Martes','09:30','10:15'),
(48,'Martes','10:30','11:15'),
(48,'Martes','11:15','12:00'),
(52,'Martes','12:15','01:00'),
(52,'Martes','01:00','01:45'),
(52,'Martes','01:45','02:30'),
(50,'Miercoles','08:00','08:45'),
(50,'Miercoles','08:45','09:30'),
(50,'Miercoles','09:30','10:15'),
(46,'Miercoles','10:30','11:15'),
(46,'Miercoles','11:15','12:00'),
(49,'Miercoles','12:15','01:00'),
(49,'Miercoles','01:00','01:45'),
(49,'Miercoles','01:45','02:30'),
(52,'Jueves','08:00','08:45'),
(52,'Jueves','08:45','09:30'),
(52,'Jueves','09:30','10:15'),
(51,'Jueves','10:30','11:15'),
(51,'Jueves','11:15','12:00'),
(46,'Jueves','12:15','01:00'),
(46,'Jueves','01:00','01:45'),
(46,'Jueves','01:45','02:30'),
(47,'Viernes','08:00','08:45'),
(47,'Viernes','08:45','09:30'),
(47,'Viernes','09:30','10:15'),
(50,'Viernes','10:30','11:15'),
(50,'Viernes','11:15','12:00'),
(48,'Viernes','12:15','01:00'),
(48,'Viernes','01:00','01:45'),
(48,'Viernes','01:45','02:30'),
--Tercer Grado
(59,'Lunes','08:00','08:45'),
(59,'Lunes','08:45','09:30'),
(59,'Lunes','09:30','10:15'),
(61,'Lunes','10:30','11:15'),
(61,'Lunes','11:15','12:00'),
(57,'Lunes','12:15','01:00'),
(57,'Lunes','01:00','01:45'),
(57,'Lunes','01:45','02:30'),
(60,'Martes','08:00','08:45'),
(60,'Martes','08:45','09:30'),
(60,'Martes','09:30','10:15'),
(63,'Martes','10:30','11:15'),
(63,'Martes','11:15','12:00'),
(56,'Martes','12:15','01:00'),
(56,'Martes','01:00','01:45'),
(56,'Martes','01:45','02:30'),
(58,'Miercoles','08:00','08:45'),
(58,'Miercoles','08:45','09:30'),
(58,'Miercoles','09:30','10:15'),
(55,'Miercoles','10:30','11:15'),
(55,'Miercoles','11:15','12:00'),
(62,'Miercoles','12:15','01:00'),
(62,'Miercoles','01:00','01:45'),
(62,'Miercoles','01:45','02:30'),
(56,'Jueves','08:00','08:45'),
(56,'Jueves','08:45','09:30'),
(56,'Jueves','09:30','10:15'),
(57,'Jueves','10:30','11:15'),
(57,'Jueves','11:15','12:00'),
(60,'Jueves','12:15','01:00'),
(60,'Jueves','01:00','01:45'),
(60,'Jueves','01:45','02:30'),
(63,'Viernes','08:00','08:45'),
(63,'Viernes','08:45','09:30'),
(63,'Viernes','09:30','10:15'),
(55,'Viernes','10:30','11:15'),
(55,'Viernes','11:15','12:00'),
(59,'Viernes','12:15','01:00'),
(59,'Viernes','01:00','01:45'),
(59,'Viernes','01:45','02:30'),
(66,'Lunes','08:00','08:45'),
(66,'Lunes','08:45','09:30'),
(66,'Lunes','09:30','10:15'),
(65,'Lunes','10:30','11:15'),
(65,'Lunes','11:15','12:00'),
(68,'Lunes','12:15','01:00'),
(68,'Lunes','01:00','01:45'),
(68,'Lunes','01:45','02:30'),
(72,'Martes','08:00','08:45'),
(72,'Martes','08:45','09:30'),
(72,'Martes','09:30','10:15'),
(70,'Martes','10:30','11:15'),
(70,'Martes','11:15','12:00'),
(69,'Martes','12:15','01:00'),
(69,'Martes','01:00','01:45'),
(69,'Martes','01:45','02:30'),
(71,'Miercoles','08:00','08:45'),
(71,'Miercoles','08:45','09:30'),
(71,'Miercoles','09:30','10:15'),
(64,'Miercoles','10:30','11:15'),
(64,'Miercoles','11:15','12:00'),
(67,'Miercoles','12:15','01:00'),
(67,'Miercoles','01:00','01:45'),
(67,'Miercoles','01:45','02:30'),
(69,'Jueves','08:00','08:45'),
(69,'Jueves','08:45','09:30'),
(69,'Jueves','09:30','10:15'),
(72,'Jueves','10:30','11:15'),
(72,'Jueves','11:15','12:00'),
(65,'Jueves','12:15','01:00'),
(65,'Jueves','01:00','01:45'),
(65,'Jueves','01:45','02:30'),
(70,'Viernes','08:00','08:45'),
(70,'Viernes','08:45','09:30'),
(70,'Viernes','09:30','10:15'),
(66,'Viernes','10:30','11:15'),
(66,'Viernes','11:15','12:00'),
(68,'Viernes','12:15','01:00'),
(68,'Viernes','01:00','01:45'),
(68,'Viernes','01:45','02:30'),
(78,'Lunes','08:00','08:45'),
(78,'Lunes','08:45','09:30'),
(78,'Lunes','09:30','10:15'),
(75,'Lunes','10:30','11:15'),
(75,'Lunes','11:15','12:00'),
(81,'Lunes','12:15','01:00'),
(81,'Lunes','01:00','01:45'),
(81,'Lunes','01:45','02:30'),
(74,'Martes','08:00','08:45'),
(74,'Martes','08:45','09:30'),
(74,'Martes','09:30','10:15'),
(77,'Martes','10:30','11:15'),
(77,'Martes','11:15','12:00'),
(79,'Martes','12:15','01:00'),
(79,'Martes','01:00','01:45'),
(79,'Martes','01:45','02:30'),
(73,'Miercoles','08:00','08:45'),
(73,'Miercoles','08:45','09:30'),
(73,'Miercoles','09:30','10:15'),
(76,'Miercoles','10:30','11:15'),
(76,'Miercoles','11:15','12:00'),
(80,'Miercoles','12:15','01:00'),
(80,'Miercoles','01:00','01:45'),
(80,'Miercoles','01:45','02:30'),
(79,'Jueves','08:00','08:45'),
(79,'Jueves','08:45','09:30'),
(79,'Jueves','09:30','10:15'),
(78,'Jueves','10:30','11:15'),
(78,'Jueves','11:15','12:00'),
(75,'Jueves','12:15','01:00'),
(75,'Jueves','01:00','01:45'),
(75,'Jueves','01:45','02:30'),
(77,'Viernes','08:00','08:45'),
(77,'Viernes','08:45','09:30'),
(77,'Viernes','09:30','10:15'),
(74,'Viernes','10:30','11:15'),
(74,'Viernes','11:15','12:00'),
(81,'Viernes','12:15','01:00'),
(81,'Viernes','01:00','01:45'),
(81,'Viernes','01:45','02:30'),
--Cuarto Grado
(82,'Lunes','08:00','08:45'),
(82,'Lunes','08:45','09:30'),
(82,'Lunes','09:30','10:15'),
(87,'Lunes','10:30','11:15'),
(87,'Lunes','11:15','12:00'),
(84,'Lunes','12:15','01:00'),
(84,'Lunes','01:00','01:45'),
(84,'Lunes','01:45','02:30'),
(90,'Martes','08:00','08:45'),
(90,'Martes','08:45','09:30'),
(90,'Martes','09:30','10:15'),
(83,'Martes','10:30','11:15'),
(83,'Martes','11:15','12:00'),
(86,'Martes','12:15','01:00'),
(86,'Martes','01:00','01:45'),
(86,'Martes','01:45','02:30'),
(85,'Miercoles','08:00','08:45'),
(85,'Miercoles','08:45','09:30'),
(85,'Miercoles','09:30','10:15'),
(88,'Miercoles','10:30','11:15'),
(88,'Miercoles','11:15','12:00'),
(89,'Miercoles','12:15','01:00'),
(89,'Miercoles','01:00','01:45'),
(89,'Miercoles','01:45','02:30'),
(83,'Jueves','08:00','08:45'),
(83,'Jueves','08:45','09:30'),
(83,'Jueves','09:30','10:15'),
(82,'Jueves','10:30','11:15'),
(82,'Jueves','11:15','12:00'),
(87,'Jueves','12:15','01:00'),
(87,'Jueves','01:00','01:45'),
(87,'Jueves','01:45','02:30'),
(90,'Viernes','08:00','08:45'),
(90,'Viernes','08:45','09:30'),
(90,'Viernes','09:30','10:15'),
(84,'Viernes','10:30','11:15'),
(84,'Viernes','11:15','12:00'),
(86,'Viernes','12:15','01:00'),
(86,'Viernes','01:00','01:45'),
(86,'Viernes','01:45','02:30'),
(93,'Lunes','08:00','08:45'),
(93,'Lunes','08:45','09:30'),
(93,'Lunes','09:30','10:15'),
(95,'Lunes','10:30','11:15'),
(95,'Lunes','11:15','12:00'),
(99,'Lunes','12:15','01:00'),
(99,'Lunes','01:00','01:45'),
(99,'Lunes','01:45','02:30'),
(96,'Martes','08:00','08:45'),
(96,'Martes','08:45','09:30'),
(96,'Martes','09:30','10:15'),
(92,'Martes','10:30','11:15'),
(92,'Martes','11:15','12:00'),
(91,'Martes','12:15','01:00'),
(91,'Martes','01:00','01:45'),
(91,'Martes','01:45','02:30'),
(98,'Miercoles','08:00','08:45'),
(98,'Miercoles','08:45','09:30'),
(98,'Miercoles','09:30','10:15'),
(97,'Miercoles','10:30','11:15'),
(97,'Miercoles','11:15','12:00'),
(94,'Miercoles','12:15','01:00'),
(94,'Miercoles','01:00','01:45'),
(94,'Miercoles','01:45','02:30'),
(92,'Jueves','08:00','08:45'),
(92,'Jueves','08:45','09:30'),
(92,'Jueves','09:30','10:15'),
(99,'Jueves','10:30','11:15'),
(99,'Jueves','11:15','12:00'),
(96,'Jueves','12:15','01:00'),
(96,'Jueves','01:00','01:45'),
(96,'Jueves','01:45','02:30'),
(97,'Viernes','08:00','08:45'),
(97,'Viernes','08:45','09:30'),
(97,'Viernes','09:30','10:15'),
(93,'Viernes','10:30','11:15'),
(93,'Viernes','11:15','12:00'),
(95,'Viernes','12:15','01:00'),
(95,'Viernes','01:00','01:45'),
(95,'Viernes','01:45','02:30'),
(105,'Lunes','08:00','08:45'),
(105,'Lunes','08:45','09:30'),
(105,'Lunes','09:30','10:15'),
(102,'Lunes','10:30','11:15'),
(102,'Lunes','11:15','12:00'),
(108,'Lunes','12:15','01:00'),
(108,'Lunes','01:00','01:45'),
(108,'Lunes','01:45','02:30'),
(101,'Martes','08:00','08:45'),
(101,'Martes','08:45','09:30'),
(101,'Martes','09:30','10:15'),
(104,'Martes','10:30','11:15'),
(104,'Martes','11:15','12:00'),
(106,'Martes','12:15','01:00'),
(106,'Martes','01:00','01:45'),
(106,'Martes','01:45','02:30'),
(100,'Miercoles','08:00','08:45'),
(100,'Miercoles','08:45','09:30'),
(100,'Miercoles','09:30','10:15'),
(103,'Miercoles','10:30','11:15'),
(103,'Miercoles','11:15','12:00'),
(107,'Miercoles','12:15','01:00'),
(107,'Miercoles','01:00','01:45'),
(107,'Miercoles','01:45','02:30'),
(106,'Jueves','08:00','08:45'),
(106,'Jueves','08:45','09:30'),
(106,'Jueves','09:30','10:15'),
(105,'Jueves','10:30','11:15'),
(105,'Jueves','11:15','12:00'),
(102,'Jueves','12:15','01:00'),
(102,'Jueves','01:00','01:45'),
(102,'Jueves','01:45','02:30'),
(104,'Viernes','08:00','08:45'),
(104,'Viernes','08:45','09:30'),
(104,'Viernes','09:30','10:15'),
(101,'Viernes','10:30','11:15'),
(101,'Viernes','11:15','12:00'),
(108,'Viernes','12:15','01:00'),
(108,'Viernes','01:00','01:45'),
(108,'Viernes','01:45','02:30'),
--Quinto Grado
(114,'Lunes','08:00','08:45'),
(114,'Lunes','08:45','09:30'),
(114,'Lunes','09:30','10:15'),
(117,'Lunes','10:30','11:15'),
(117,'Lunes','11:15','12:00'),
(112,'Lunes','12:15','01:00'),
(112,'Lunes','01:00','01:45'),
(112,'Lunes','01:45','02:30'),
(111,'Martes','08:00','08:45'),
(111,'Martes','08:45','09:30'),
(111,'Martes','09:30','10:15'),
(110,'Martes','10:30','11:15'),
(110,'Martes','11:15','12:00'),
(109,'Martes','12:15','01:00'),
(109,'Martes','01:00','01:45'),
(109,'Martes','01:45','02:30'),
(113,'Miercoles','08:00','08:45'),
(113,'Miercoles','08:45','09:30'),
(113,'Miercoles','09:30','10:15'),
(115,'Miercoles','10:30','11:15'),
(115,'Miercoles','11:15','12:00'),
(116,'Miercoles','12:15','01:00'),
(116,'Miercoles','01:00','01:45'),
(116,'Miercoles','01:45','02:30'),
(109,'Jueves','08:00','08:45'),
(109,'Jueves','08:45','09:30'),
(109,'Jueves','09:30','10:15'),
(114,'Jueves','10:30','11:15'),
(114,'Jueves','11:15','12:00'),
(110,'Jueves','12:15','01:00'),
(110,'Jueves','01:00','01:45'),
(110,'Jueves','01:45','02:30'),
(117,'Viernes','08:00','08:45'),
(117,'Viernes','08:45','09:30'),
(117,'Viernes','09:30','10:15'),
(111,'Viernes','10:30','11:15'),
(111,'Viernes','11:15','12:00'),
(113,'Viernes','12:15','01:00'),
(113,'Viernes','01:00','01:45'),
(113,'Viernes','01:45','02:30'),
(126,'Lunes','08:00','08:45'),
(126,'Lunes','08:45','09:30'),
(126,'Lunes','09:30','10:15'),
(120,'Lunes','10:30','11:15'),
(120,'Lunes','11:15','12:00'),
(119,'Lunes','12:15','01:00'),
(119,'Lunes','01:00','01:45'),
(119,'Lunes','01:45','02:30'),
(118,'Martes','08:00','08:45'),
(118,'Martes','08:45','09:30'),
(118,'Martes','09:30','10:15'),
(123,'Martes','10:30','11:15'),
(123,'Martes','11:15','12:00'),
(122,'Martes','12:15','01:00'),
(122,'Martes','01:00','01:45'),
(122,'Martes','01:45','02:30'),
(121,'Miercoles','08:00','08:45'),
(121,'Miercoles','08:45','09:30'),
(121,'Miercoles','09:30','10:15'),
(124,'Miercoles','10:30','11:15'),
(124,'Miercoles','11:15','12:00'),
(125,'Miercoles','12:15','01:00'),
(125,'Miercoles','01:00','01:45'),
(125,'Miercoles','01:45','02:30'),
(119,'Jueves','08:00','08:45'),
(119,'Jueves','08:45','09:30'),
(119,'Jueves','09:30','10:15'),
(120,'Jueves','10:30','11:15'),
(120,'Jueves','11:15','12:00'),
(126,'Jueves','12:15','01:00'),
(126,'Jueves','01:00','01:45'),
(126,'Jueves','01:45','02:30'),
(123,'Viernes','08:00','08:45'),
(123,'Viernes','08:45','09:30'),
(123,'Viernes','09:30','10:15'),
(118,'Viernes','10:30','11:15'),
(118,'Viernes','11:15','12:00'),
(122,'Viernes','12:15','01:00'),
(122,'Viernes','01:00','01:45'),
(122,'Viernes','01:45','02:30'),
(128,'Lunes','08:00','08:45'),
(128,'Lunes','08:45','09:30'),
(128,'Lunes','09:30','10:15'),
(127,'Lunes','10:30','11:15'),
(127,'Lunes','11:15','12:00'),
(129,'Lunes','12:15','01:00'),
(129,'Lunes','01:00','01:45'),
(129,'Lunes','01:45','02:30'),
(134,'Martes','08:00','08:45'),
(134,'Martes','08:45','09:30'),
(134,'Martes','09:30','10:15'),
(130,'Martes','10:30','11:15'),
(130,'Martes','11:15','12:00'),
(132,'Martes','12:15','01:00'),
(132,'Martes','01:00','01:45'),
(132,'Martes','01:45','02:30'),
(131,'Miercoles','08:00','08:45'),
(131,'Miercoles','08:45','09:30'),
(131,'Miercoles','09:30','10:15'),
(135,'Miercoles','10:30','11:15'),
(135,'Miercoles','11:15','12:00'),
(133,'Miercoles','12:15','01:00'),
(133,'Miercoles','01:00','01:45'),
(133,'Miercoles','01:45','02:30'),
(132,'Jueves','08:00','08:45'),
(132,'Jueves','08:45','09:30'),
(132,'Jueves','09:30','10:15'),
(128,'Jueves','10:30','11:15'),
(128,'Jueves','11:15','12:00'),
(127,'Jueves','12:15','01:00'),
(127,'Jueves','01:00','01:45'),
(127,'Jueves','01:45','02:30'),
(129,'Viernes','08:00','08:45'),
(129,'Viernes','08:45','09:30'),
(129,'Viernes','09:30','10:15'),
(135,'Viernes','10:30','11:15'),
(135,'Viernes','11:15','12:00'),
(131,'Viernes','12:15','01:00'),
(131,'Viernes','01:00','01:45'),
(131,'Viernes','01:45','02:30'),
--Sexto Grado
(144,'Lunes','08:00','08:45'),
(144,'Lunes','08:45','09:30'),
(144,'Lunes','09:30','10:15'),
(141,'Lunes','10:30','11:15'),
(141,'Lunes','11:15','12:00'),
(139,'Lunes','12:15','01:00'),
(139,'Lunes','01:00','01:45'),
(139,'Lunes','01:45','02:30'),
(138,'Martes','08:00','08:45'),
(138,'Martes','08:45','09:30'),
(138,'Martes','09:30','10:15'),
(136,'Martes','10:30','11:15'),
(136,'Martes','11:15','12:00'),
(137,'Martes','12:15','01:00'),
(137,'Martes','01:00','01:45'),
(137,'Martes','01:45','02:30'),
(140,'Miercoles','08:00','08:45'),
(140,'Miercoles','08:45','09:30'),
(140,'Miercoles','09:30','10:15'),
(142,'Miercoles','10:30','11:15'),
(142,'Miercoles','11:15','12:00'),
(143,'Miercoles','12:15','01:00'),
(143,'Miercoles','01:00','01:45'),
(143,'Miercoles','01:45','02:30'),
(137,'Jueves','08:00','08:45'),
(137,'Jueves','08:45','09:30'),
(137,'Jueves','09:30','10:15'),
(136,'Jueves','10:30','11:15'),
(136,'Jueves','11:15','12:00'),
(141,'Jueves','12:15','01:00'),
(141,'Jueves','01:00','01:45'),
(141,'Jueves','01:45','02:30'),
(144,'Viernes','08:00','08:45'),
(144,'Viernes','08:45','09:30'),
(144,'Viernes','09:30','10:15'),
(138,'Viernes','10:30','11:15'),
(138,'Viernes','11:15','12:00'),
(140,'Viernes','12:15','01:00'),
(140,'Viernes','01:00','01:45'),
(140,'Viernes','01:45','02:30'),
(148,'Lunes','08:00','08:45'),
(148,'Lunes','08:45','09:30'),
(148,'Lunes','09:30','10:15'),
(147,'Lunes','10:30','11:15'),
(147,'Lunes','11:15','12:00'),
(153,'Lunes','12:15','01:00'),
(153,'Lunes','01:00','01:45'),
(153,'Lunes','01:45','02:30'),
(146,'Martes','08:00','08:45'),
(146,'Martes','08:45','09:30'),
(146,'Martes','09:30','10:15'),
(145,'Martes','10:30','11:15'),
(145,'Martes','11:15','12:00'),
(150,'Martes','12:15','01:00'),
(150,'Martes','01:00','01:45'),
(150,'Martes','01:45','02:30'),
(149,'Miercoles','08:00','08:45'),
(149,'Miercoles','08:45','09:30'),
(149,'Miercoles','09:30','10:15'),
(151,'Miercoles','10:30','11:15'),
(151,'Miercoles','11:15','12:00'),
(152,'Miercoles','12:15','01:00'),
(152,'Miercoles','01:00','01:45'),
(152,'Miercoles','01:45','02:30'),
(147,'Jueves','08:00','08:45'),
(147,'Jueves','08:45','09:30'),
(147,'Jueves','09:30','10:15'),
(153,'Jueves','10:30','11:15'),
(153,'Jueves','11:15','12:00'),
(146,'Jueves','12:15','01:00'),
(146,'Jueves','01:00','01:45'),
(146,'Jueves','01:45','02:30'),
(145,'Viernes','08:00','08:45'),
(145,'Viernes','08:45','09:30'),
(145,'Viernes','09:30','10:15'),
(150,'Viernes','10:30','11:15'),
(150,'Viernes','11:15','12:00'),
(149,'Viernes','12:15','01:00'),
(149,'Viernes','01:00','01:45'),
(149,'Viernes','01:45','02:30'),
(154,'Lunes','08:00','08:45'),
(154,'Lunes','08:45','09:30'),
(154,'Lunes','09:30','10:15'),
(155,'Lunes','10:30','11:15'),
(155,'Lunes','11:15','12:00'),
(159,'Lunes','12:15','01:00'),
(159,'Lunes','01:00','01:45'),
(159,'Lunes','01:45','02:30'),
(162,'Martes','08:00','08:45'),
(162,'Martes','08:45','09:30'),
(162,'Martes','09:30','10:15'),
(156,'Martes','10:30','11:15'),
(156,'Martes','11:15','12:00'),
(157,'Martes','12:15','01:00'),
(157,'Martes','01:00','01:45'),
(157,'Martes','01:45','02:30'),
(158,'Miercoles','08:00','08:45'),
(158,'Miercoles','08:45','09:30'),
(158,'Miercoles','09:30','10:15'),
(160,'Miercoles','10:30','11:15'),
(160,'Miercoles','11:15','12:00'),
(161,'Miercoles','12:15','01:00'),
(161,'Miercoles','01:00','01:45'),
(161,'Miercoles','01:45','02:30'),
(159,'Jueves','08:00','08:45'),
(159,'Jueves','08:45','09:30'),
(159,'Jueves','09:30','10:15'),
(155,'Jueves','10:30','11:15'),
(155,'Jueves','11:15','12:00'),
(154,'Jueves','12:15','01:00'),
(154,'Jueves','01:00','01:45'),
(154,'Jueves','01:45','02:30'),
(156,'Viernes','08:00','08:45'),
(156,'Viernes','08:45','09:30'),
(156,'Viernes','09:30','10:15'),
(162,'Viernes','10:30','11:15'),
(162,'Viernes','11:15','12:00'),
(158,'Viernes','12:15','01:00'),
(158,'Viernes','01:00','01:45'),
(158,'Viernes','01:45','02:30')


--Abrimos las tablas
SELECT * FROM HORARIO
select * from SECCION_CURSO