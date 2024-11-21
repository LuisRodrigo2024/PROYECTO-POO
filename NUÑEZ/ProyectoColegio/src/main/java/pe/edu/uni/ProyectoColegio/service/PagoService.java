package pe.edu.uni.ProyectoColegio.service;

import java.sql.Timestamp;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.uni.ProyectoColegio.dto.PagoDto;

@Service
public class PagoService {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
	public PagoDto pagoCuota(PagoDto dto) {
		// Validaciones
		validarCronogramaid(dto.getCro_id(), dto.getPag_fecha());
		validarFecha(dto.getCro_id(), dto.getPag_fecha());
		validarMatricula(dto.getCro_id());
		validarPago(dto.getCro_id());
		validarOrden(dto.getCro_id());
		validarEmpleado(dto.getEmp_id());
		dto.setPag_fecha_prog(recuperarFechaProg(dto.getCro_id()));
		dto.setPag_fecha(convertirFecha(dto.getPag_fecha()));
		validarImporte(dto.getPag_importe(), dto.getCro_id(), dto.getPag_fecha_prog(), dto.getPag_fecha());

		// Proceso
		dto.setPag_pension(recuperarPension(dto.getCro_id()));
		registrarPago(dto);

		// Reporte final
		System.out.println("Proceso ok.");
		return dto;
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void registrarPago(PagoDto bean) {
		String sql = """
				INSERT INTO PAGO (cro_id, emp_id, pag_pension, pag_importe, pag_fecha, pag_fecha_prog)
				VALUES (?, ?, ?, ?, ?, ?)
				""";
		jdbcTemplate.update(sql, bean.getCro_id(), bean.getEmp_id(), bean.getPag_pension(), bean.getPag_importe(),
				bean.getPag_fecha(), bean.getPag_fecha_prog());
	}
	
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private int recuperarPension(int idcronograma) {
		int numero_pension = (idcronograma - 1) % 11;
		return numero_pension;
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarImporte(double importe, int idcronograma, String fecha_prog, String fecha) {
		String sql = """
				SELECT cro_monto FROM CRONOGRAMA_PAGO
				WHERE cro_id = ?
				""";
		double costo = jdbcTemplate.queryForObject(sql, Double.class, idcronograma);
		double mora = calcularMora(fecha_prog, fecha, costo);
		costo = costo + mora;

		if (costo != importe) {
			throw new RuntimeException("El importe no es correcto");
		}
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	public double calcularMora(String fecha_prog, String fecha, double costo) {
		// Definir los formatos esperados para cada fecha
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

		// Convertir las cadenas de fechas a LocalDate con el formato especificado para
		// cada una
		LocalDate fechaProg = LocalDate.parse(fecha_prog, formatter);
		LocalDate fechaActual = LocalDate.parse(fecha, formatter);

		// Inicializar la variable para la mora
		double mora = 0;

		// Calcular la diferencia en días solo si fechaActual es después de fechaProg
		if (fechaActual.isAfter(fechaProg)) {
			double diasDiferencia = ChronoUnit.DAYS.between(fechaProg, fechaActual);
			double tasaMora = 0.05;
			mora = diasDiferencia * tasaMora * costo;
		}

		return mora;
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	public String convertirFecha(String fecha) {
		// Definir los formatos: de entrada (dd/MM/yyyy) y de salida (yyyy-MM-dd)
		DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
		DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

		// Parsear la fecha de entrada y formatearla al nuevo formato
		LocalDate date = LocalDate.parse(fecha, inputFormatter);
		return date.format(outputFormatter);
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	public String recuperarFechaProg(int idcronograma) {
		String sql = """
				SELECT cro_fecha_prog FROM CRONOGRAMA_PAGO
				WHERE cro_id = ?
				""";

		// Recuperar la fecha como Timestamp
		Timestamp timestamp = jdbcTemplate.queryForObject(sql, Timestamp.class, idcronograma);

		// Convertir el Timestamp a LocalDate
		LocalDate fecha = timestamp.toLocalDateTime().toLocalDate();

		// Formatear la fecha a String en el formato yyyy-MM-dd
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		return fecha.format(formatter);
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarEmpleado(int idempleado) {
		String sql = """
				SELECT COUNT(*) FROM EMPLEADO
				WHERE emp_id = ?
				""";
		int cont = jdbcTemplate.queryForObject(sql, Integer.class, idempleado);
		if (cont != 1) {
			throw new RuntimeException("El id del empleado no existe");
		}
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarOrden(int idcronograma) {
		// Recuperando el id de cronograma
		String sql = """
			    SELECT m.mat_id FROM MATRICULA m
				JOIN CRONOGRAMA_PAGO c ON m.mat_id = c.mat_id 
				WHERE c.cro_id = ?
			""";
		int idmatricula = jdbcTemplate.queryForObject(sql, Integer.class, idcronograma);
		sql = """
				    SELECT COUNT(*)
				    FROM PAGO p
				    JOIN CRONOGRAMA_PAGO c ON p.cro_id = c.cro_id
				    WHERE c.mat_id = ?
				""";
		
		// Consulta que cuenta la cantidad de filas de la tabla Pago por id de matricula
		int cont = jdbcTemplate.queryForObject(sql, Integer.class, idmatricula);

		// Numero de cuota que va a pagar
		int cuota = (idcronograma - 1) % 11;

		// Verificar si el contador coincide con el numero de cuota que va a pagar
		if (cuota != cont) {
			throw new RuntimeException("El pago se debe realizar en orden.");
		}

	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarPago(int idcronograma) {
		// Validar si ya está pagado
		String sql = """
				SELECT COUNT(*) FROM PAGO WHERE cro_id = ?
				""";
		int cont = jdbcTemplate.queryForObject(sql, Integer.class, idcronograma);
		if (cont != 0) {
			throw new RuntimeException("El pago ya se ha realizado");
		}
	}
	
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarMatricula(int idcronograma) {
		String sql = """
				SELECT m.mat_estado FROM MATRICULA m
				JOIN CRONOGRAMA_PAGO c ON m.mat_id = c.mat_id
				WHERE cro_id = ?
				""";
		int cont = jdbcTemplate.queryForObject(sql, Integer.class, idcronograma);
		if (cont != 1) {
			throw new RuntimeException("La matricula no se encuentra activa");
		}
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarFecha(int idcronograma, String fecha) {
		// Validar que la fecha sea igual a la del año programado
		// Recuperando año programado
		String sql = """
				SELECT YEAR(cro_fecha_prog) FROM CRONOGRAMA_PAGO WHERE cro_id = ?
				""";
		int anio_prog = jdbcTemplate.queryForObject(sql, Integer.class, idcronograma);

		// Definir el formato de las fechas
		LocalDate fechaPaga = convertirYValidarFecha(fecha);

		// Convertir LocalDate a java.sql.Date para usarlo en la consulta SQL
		java.sql.Date sqlFecha = java.sql.Date.valueOf(fechaPaga);

		// Consultar el año de la fecha proporcionada
		sql = """
				SELECT YEAR(?)
				""";
		int anio = jdbcTemplate.queryForObject(sql, Integer.class, sqlFecha);

		// Comparar el año proporcionado con el año programado
		if (anio_prog != anio) {
			throw new RuntimeException("La Fecha no corresponde al año programado.");
		}
	}
	
	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private LocalDate convertirYValidarFecha(String fecha) {
	    try {
	        // Separar los componentes de la fecha (dd/MM/yyyy)
	        String[] partes = fecha.split("/");
	        if (partes.length != 3) {
	            throw new RuntimeException("Formato de fecha invalido. Debe ser dd/MM/yyyy: " + fecha);
	        }

	        int dia = Integer.parseInt(partes[0]);
	        int mes = Integer.parseInt(partes[1]);
	        int anio = Integer.parseInt(partes[2]);

	        // Validar que la fecha sea válida usando LocalDate.of
	        return LocalDate.of(anio, mes, dia);
	    } catch (NumberFormatException | DateTimeException e) {
	        throw new RuntimeException("La fecha proporcionada no es valida: " + fecha, e);
	    }
	}

	@Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
	private void validarCronogramaid(int idcronograma, String fecha) {
		// Validar que el id del cronograma exista
		String sql = """
				SELECT COUNT(*) FROM CRONOGRAMA_PAGO
				WHERE cro_id = ?
				""";
		int cont = jdbcTemplate.queryForObject(sql, Integer.class, idcronograma);
		if (cont != 1) {
			throw new RuntimeException("El id del cronograma no existe");
		}
	}

}
