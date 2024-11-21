package pe.edu.uni.ProyectoColegio.service;

import java.util.Arrays;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import pe.edu.uni.ProyectoColegio.dto.MatriculaDto;



@Service
public class MatriculaService {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
	public MatriculaDto proc_Matricula(MatriculaDto bean) {
		//DATOS DTO 
	    int alu_id=bean.getAlu_id();
	    int sec_id=bean.getSec_id();
	    int  emp_id=bean.getEmp_id();
	    String mat_tipo=bean.getMat_tipo();
	    String mat_fecha=bean.getMat_fecha();
	    String mat_estado="1";
	    //auxiliar 
	    double costo;
	   
		// Validaciones
	    
	  //validar seccion
	    validarSeccion(sec_id);
	    
	   //validar si existen vacantes en la seccion
	    validarVacantesSeccion(sec_id);
	    
	    //validando alumno
	    validarAlumno(alu_id, sec_id);
	    
	    //validar empleado
	    validarEmpleado(emp_id);
	    
	    //validar tipo sea beca , regular
	    mat_tipo=validarTipo(mat_tipo);
	    bean.setMat_tipo(mat_tipo);
	    
	    
	    //valdiar fecha ingresada en formato dd/mm/aa
	    bean.setMat_fecha( validarFecha(mat_fecha));
	    mat_fecha=validarFecha(mat_fecha);
	    
	    // VALIDAR ANIO DE MATRICULA 
	    validarAnio(sec_id, mat_fecha);
	   
	    
	   //validar seccion 
	    int val=validarAlumnoNuevo(alu_id);
	    if(val!=0) {
	    	validarSeccionAlumno(alu_id, sec_id); 
	    	validarMatriculaAlumno(alu_id, sec_id);
	    }   
	    
	  
	    //Actualizando estado
	    bean.setMat_estado(mat_estado);
	    //Registro de la tabla Matricula
	    registrarMatricula(alu_id, sec_id, emp_id, mat_tipo, mat_fecha, mat_estado);
	    //Actualizando vacantes 
	    actualizarVacantes(sec_id);
	    
	    //Calculando costo x tipo 
	    costo =costo_Tipo(mat_tipo);
	    

	    //generando cronograma de pagos para el alumno
	    registrarCronograma(sec_id, mat_fecha, costo);
	    

		return bean;
	}
	
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarVacantesSeccion(int sec_id) {
	    // Consulta SQL para obtener la diferencia entre vacantes y matriculados
	    String sql = """
	        SELECT sec_vacantes - sec_matriculados AS vac_dis
	        FROM SECCION
	        WHERE sec_id = ?;
	    """;

	    // Obtener la diferencia entre vacantes y matriculados
	    Integer vacantesDisponibles = jdbcTemplate.queryForObject(sql, Integer.class, sec_id);

	    // Verificar si hay vacantes disponibles
	    if (vacantesDisponibles == null || vacantesDisponibles <= 0) {
	        throw new RuntimeException("No hay vacantes disponibles en esta sección.");
	    }
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void registrarMatricula(int alu_id, int sec_id, int emp_id, String mat_tipo,
	                                 String mat_fecha, String mat_estado) {
	    String sql = """
	        INSERT INTO MATRICULA 
	            ([alu_id], [sec_id], [emp_id], [mat_tipo], [mat_fecha], [mat_estado])
	        VALUES (?, ?, ?, ?, ?, ?)
	    """;

	    jdbcTemplate.update(sql, alu_id, sec_id, emp_id, mat_tipo, mat_fecha, mat_estado);
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void actualizarVacantes(int secId) {
	    String sql = """
	        UPDATE SECCION
	        SET sec_matriculados = sec_matriculados + 1,
	            sec_vacantes = sec_vacantes - 1
	        WHERE sec_id = ?;
	    """;

	    int rowsUpdated = jdbcTemplate.update(sql, secId);

	    if (rowsUpdated != 1) {
	        throw new RuntimeException("La sección de ID: " + secId + " no existe");
	    }
	}
	

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void registrarCronograma(int sec_id, String mat_fecha, double costo) {
	    // Obtener el ID de la última inserción
	    String sql = """
	        SELECT @@IDENTITY AS cro_id
	    """;
	    int cro_id = jdbcTemplate.queryForObject(sql, Integer.class);

	    // Obtener el año de la matrícula
	    sql = """
	        SELECT YEAR(?) AS anio
	    """;
	    String anio = jdbcTemplate.queryForObject(sql, String.class, mat_fecha);

	    // Procedimiento almacenado para insertar cronograma de pagos
	    sql = """
	    DECLARE @matId INT = ?; -- ID de la matrícula
	    DECLARE @anio INT = ?; -- Año del cronograma
	    DECLARE @mesInicio INT = 2; -- Mes de inicio (2 = febrero)
	    DECLARE @mesFin INT = 12; -- Mes de fin (12 = diciembre)
	    DECLARE @montoMensual DECIMAL(10,2) = ?; -- Monto de los pagos mensuales

	    -- Insertar cronograma de pago inicial (tipo_pago_id = 1) a finales de febrero
	    INSERT INTO CRONOGRAMA_PAGO (mat_id, tipo_pago_id, cro_monto, cro_fecha_prog)
	    VALUES (@matId, 1, @montoMensual, EOMONTH(DATEFROMPARTS(@anio, @mesInicio, 1)));

	    -- Insertar cronogramas de pagos mensuales (tipo_pago_id = 2) desde marzo hasta diciembre
	    DECLARE @mes INT = @mesInicio + 1;

	    WHILE @mes <= @mesFin
	    BEGIN
	        IF @mes = @mesFin
	        BEGIN
	            -- Para el último mes (diciembre), establecer la fecha como el 15
	            INSERT INTO CRONOGRAMA_PAGO (mat_id, tipo_pago_id, cro_monto, cro_fecha_prog)
	            VALUES (@matId, 2, @montoMensual, DATEFROMPARTS(@anio, @mes, 15));
	        END
	        ELSE
	        BEGIN
	            -- Para los demás meses, establecer la fecha al final del mes
	            INSERT INTO CRONOGRAMA_PAGO (mat_id, tipo_pago_id, cro_monto, cro_fecha_prog)
	            VALUES (@matId, 2, @montoMensual, EOMONTH(DATEFROMPARTS(@anio, @mes, 1)));
	        END

	        SET @mes = @mes + 1;
	    END;
	    """;

	    jdbcTemplate.update(sql, cro_id, anio, costo);
	}

	
	


	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarAlumno(int alu_id,int sec_id) {
		String sql = """
			SELECT COUNT(*) cont FROM ALUMNO WHERE alu_id=?			
		""";
		int cont = jdbcTemplate.queryForObject(sql, Integer.class, alu_id);
		if(cont==0) {
			throw new RuntimeException("El alumno no Existe.");
		}
		sql = """
				SELECT COUNT(*) cont FROM MATRICULA WHERE alu_id=? AND sec_id=?		
			""";
			cont = jdbcTemplate.queryForObject(sql, Integer.class, alu_id,sec_id);
			if(cont!=0) {
				throw new RuntimeException("El alumno ya se encuentra matriculado en la seccion programada de Id : "+sec_id);
			}
	}
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarSeccion(int sec_id) {
		String sql = """
			SELECT COUNT(*) cont FROM SECCION WHERE sec_id=?			
		""";
		int cont = jdbcTemplate.queryForObject(sql, Integer.class, sec_id);
		if(cont==0) {
			throw new RuntimeException("La Seccion no existe ");
		}
	}
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarEmpleado(int emp_id) {
		String sql = """
			SELECT COUNT(*) cont  FROM EMPLEADO  WHERE emp_id=?		
		""";
		int cont = jdbcTemplate.queryForObject(sql, Integer.class, emp_id);
		if(cont==0) {
			throw new RuntimeException("El empleado no existe");
		}
	}
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private String validarTipo(String mat_tipo) {
	    // Convertir a mayúsculas y eliminar espacios en blanco al inicio y final
	    String tipoMayuscula = mat_tipo.trim().toUpperCase();

	    // Validar si el tipo es válido
	    if (!Arrays.asList("BECA", "REGULAR", "MEDIABECA").contains(tipoMayuscula)) {
	        throw new IllegalArgumentException("El tipo de matrícula debe ser BECA, REGULAR o MEDIABECA");
	    }

	    
	    return tipoMayuscula;
	}
	
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private String validarFecha(String mat_fecha) {
	    String fecha_format;

	    // Eliminar espacios en blanco al inicio y al final
	    String fechaLimpia = mat_fecha.trim();

	    // Expresión regular para validar el formato dd/MM/yyyy
	    String regex = "^\\d{2}/\\d{2}/\\d{4}$";

	    if (!fechaLimpia.matches(regex)) {
	        throw new IllegalArgumentException("La fecha debe tener el formato dd/MM/yyyy");
	    }

	    // Validar día, mes y año
	    String[] partesFecha = fechaLimpia.split("/");
	    int dia = Integer.parseInt(partesFecha[0]);
	    int mes = Integer.parseInt(partesFecha[1]);
	    int anio = Integer.parseInt(partesFecha[2]);

	    if (dia < 1 || dia > 31 || mes < 1 || mes > 12) {
	        throw new IllegalArgumentException("La fecha ingresada no es válida. Verifique el día y el mes.");
	    }

	    // Validar que el mes sea enero o febrero
	    if (mes != 1 && mes != 2) {
	        throw new IllegalArgumentException("La fecha debe estar en los meses de enero o febrero.");
	    }

	    // Validar el número de días en febrero, considerando si el año es bisiesto
	    if (mes == 2) {
	        // Verificar si el año es bisiesto
	        boolean esBisiesto = (anio % 4 == 0 && (anio % 100 != 0 || anio % 400 == 0));

	        // Si el año es bisiesto, febrero puede tener 29 días, si no, solo 28 días
	        if ((esBisiesto && dia > 29) || (!esBisiesto && dia > 28)) {
	            throw new IllegalArgumentException("Febrero solo puede tener " + (esBisiesto ? "29" : "28") + " días en el año " + anio);
	        }
	    }

	    // Si pasa todas las validaciones, procedemos con la conversión
	    String sql = "SELECT CONVERT(DATETIME, ?, 103) fecha";
	    fecha_format = jdbcTemplate.queryForObject(sql, String.class, fechaLimpia);

	    return fecha_format;
	}

	
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarSeccionAlumno(int alu_id, int sec_id) {
	    String sql = """
	        WITH GradoAnterior AS (
	            SELECT TOP 1 S.grad_id
	            FROM MATRICULA M
	            JOIN SECCION S ON M.sec_id = S.sec_id
	            WHERE M.alu_id = ? -- Parámetro para ID del alumno
	            ORDER BY M.mat_fecha DESC
	        )
	        SELECT COUNT(*) AS Cantidad_de_Matriculas_Validas
	        FROM SECCION S
	        JOIN GradoAnterior GA ON S.grad_id = GA.grad_id OR S.grad_id = GA.grad_id + 1
	        WHERE S.sec_id = ?; -- Parámetro para ID de la sección
	    """;
	    
	    int cont = jdbcTemplate.queryForObject(sql, Integer.class, alu_id, sec_id);
	    if (cont == 0) {
	        throw new RuntimeException("El alumno solo puede matricularse en el ultimo grado y el que le sigue");
	    }
	}
	
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private int validarAlumnoNuevo(int alu_id) {
		

		String sql = """
				
				SELECT count (*) cont FROM MATRICULA WHERE  alu_id=?	
			""";
			int cont = jdbcTemplate.queryForObject(sql, Integer.class, alu_id);

	    
	    return cont;
	}
	
	
	
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private double costo_Tipo(String mat_tipo) {

	    // Consulta para obtener el precio base desde la base de datos
	    String sql = "SELECT  mensualidad precio FROM PRECIO";
	    double precioBase = jdbcTemplate.queryForObject(sql, Double.class);

	    double costo = 0;

	    switch (mat_tipo) {
	        case "BECA":
	            costo = 0;
	            break;
	        case "MEDIABECA":
	            costo = precioBase * 0.5;
	            break;
	        case "REGULAR":
	            costo = precioBase;
	            break;
	    }

	    return costo;
	}
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarMatriculaAlumno(int alu_id, int sec_id) {
	    String sql = """
	        SELECT COUNT(*) AS existe
	        FROM MATRICULA M
	        JOIN SECCION S ON M.sec_id = S.sec_id
	        JOIN GRADO G ON S.grad_id = G.grad_id
	        JOIN ANIO A ON S.anio_id = A.anio_id
	        WHERE M.alu_id = ? 
	          AND A.anio_id = (
	              SELECT anio_id
	              FROM SECCION
	              WHERE sec_id = ?
	          );
	    """;
	    
	    int cont = jdbcTemplate.queryForObject(sql, Integer.class, alu_id, sec_id);
	    
	    if (cont > 0) {
	        throw new RuntimeException("El alumno ya está matriculado en otro grado o sección en este año académico.");
	    }
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarAnio( int sec_id, String mat_fecha) {
	    String sql = """
	        SELECT COUNT(*) AS existe
	        FROM SECCION S
	        JOIN ANIO A ON S.anio_id = A.anio_id
	        WHERE S.sec_id = ?
	          AND YEAR(?) BETWEEN YEAR(A.anio_inicio) AND YEAR(A.anio_fin);
	    """;
	    
	    int cont = jdbcTemplate.queryForObject(sql, Integer.class, sec_id, mat_fecha);
	    
	    
	    if (cont == 0) {
	        throw new RuntimeException("El año de la fecha de matrícula no coincide con el año de la sección seleccionada.");
	    }
	}




}
