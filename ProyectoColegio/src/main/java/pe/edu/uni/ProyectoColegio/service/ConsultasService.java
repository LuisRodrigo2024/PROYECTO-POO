package pe.edu.uni.ProyectoColegio.service;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.stereotype.Service;

import pe.edu.uni.ProyectoColegio.dto.ClasesDto;
import pe.edu.uni.ProyectoColegio.dto.CursosProfesorResponse;
import pe.edu.uni.ProyectoColegio.dto.FechapagoDto;
import pe.edu.uni.ProyectoColegio.dto.HoraDto;
import pe.edu.uni.ProyectoColegio.dto.HorarioDto;
import pe.edu.uni.ProyectoColegio.dto.ProfesorDto;

@Service
public class ConsultasService {
	
	
	@Autowired
	private JdbcTemplate jdbcTemplate;

	
	public List<Map<String, Object>> ConPagosDetallado(String fecha, int alu_id) {
	    // Definir la consulta SQL
	    String sql = """
	    SELECT 
	        CP.cro_id AS cro_id,
	        CASE 
	            WHEN CP.tipo_pago_id = 1 THEN 'MATRÍCULA'
	            WHEN CP.tipo_pago_id = 2 THEN 'PENSIÓN'
	            ELSE 'OTRO'
	        END AS concepto,
	        CP.cro_monto AS monto_base,
	        CASE 
	            WHEN P.pag_id IS NOT NULL THEN P.pag_importe - CP.cro_monto -- Mora calculada para pagos realizados
	            ELSE 
	                CASE 
	                    WHEN DATEDIFF(DAY, CP.cro_fecha_prog, CONVERT(DATE, ?, 103)) > 0 THEN 
	                        DATEDIFF(DAY, CP.cro_fecha_prog, CONVERT(DATE, ?, 103)) * 0.05 * CP.cro_monto
	                    ELSE 0
	                END
	        END AS mora,
	        CASE 
	            WHEN P.pag_id IS NOT NULL THEN P.pag_importe -- Total pagado si el estado es PAGADO
	            ELSE 
	                CP.cro_monto + 
	                CASE 
	                    WHEN DATEDIFF(DAY, CP.cro_fecha_prog, CONVERT(DATE, ?, 103)) > 0 THEN 
	                        DATEDIFF(DAY, CP.cro_fecha_prog, CONVERT(DATE, ?, 103)) * 0.05 * CP.cro_monto
	                    ELSE 0
	                END
	        END AS monto_total,
	        CASE 
	            WHEN P.pag_id IS NOT NULL THEN 'PAGADO'
	            ELSE 'PENDIENTE'
	        END AS estado,
	        FORMAT(CP.cro_fecha_prog, 'dd/MM/yyyy') AS fecha_limite
	    FROM CRONOGRAMA_PAGO CP
	    LEFT JOIN PAGO P ON CP.cro_id = P.cro_id
	    INNER JOIN MATRICULA M ON CP.mat_id = M.mat_id
	    WHERE M.alu_id = ?
	      AND YEAR(CP.cro_fecha_prog) = YEAR(CONVERT(DATE, ?, 103));
	    """;

	    // Ejecutar la consulta y devolver los resultados
	    return jdbcTemplate.queryForList(sql, fecha, fecha, fecha, fecha, alu_id, fecha);
	}




 
	
	
	
	
	public String cronogramaPago(int alu_id) throws Exception {
		int contador = 0;
		StringBuilder reporte = new StringBuilder();
		List<FechapagoDto> lista = new LinkedList<>();
		try {
			
			String sql = """
					SELECT COUNT(*)
					FROM ALUMNO
					WHERE alu_id = ?
										""";
			int aux = jdbcTemplate.queryForObject(sql, Integer.class, alu_id);
			if (aux == 0) {
				throw new Exception("Alumno no existe");
			}
			
			sql = """
					SELECT
					COUNT(*)
					FROM MATRICULA
					WHERE alu_id = ?
										""";
			aux = jdbcTemplate.queryForObject(sql, Integer.class, alu_id);
			if (aux == 0) {
				throw new Exception("Alumno no está matriculado");
			}
			
			sql = """
					SELECT
					cro_monto mensualidad,
					cro_fecha_prog fecha
					FROM CRONOGRAMA_PAGO
					WHERE mat_id=?
										         """;

			List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, alu_id);
			for (Map<String, Object> row : rows) {
				FechapagoDto dto = new FechapagoDto();
				dto.setFecha(row.get("fecha").toString());
				dto.setMonto(Double.parseDouble(row.get("mensualidad").toString()));
				dto.setCuota(contador);
				lista.add(dto);
				contador++;
			}

			reporte.append(String.format("%-15s %-27s %-27s%n", "CUOTA", "MONTO A PAGAR", "FECHA DE PAGO"));
			reporte.append("------------------------------------------------------------------------\n");
			String cuota = "";
			for (FechapagoDto elemento : lista) {
				cuota = Integer.toString(elemento.getCuota());
				if (elemento.getCuota() == 0) {
					cuota = "Matricula";
				}
				reporte.append(String.format("%-15s %-27s %-27s%n", cuota, elemento.getMonto(), elemento.getFecha()));
			}
			reporte.append("------------------------------------------------------------------------\n");
			

		} catch (DataAccessException e) {
			System.err.println("ERROR AL OBTENER LA INFORMACION: " + e.getMessage());
		}

		return reporte.toString();
	}

	public List<FechapagoDto> pagoJSON(int alu_id) throws Exception {
		int contador = 0;
		List<FechapagoDto> lista = new LinkedList<>();
		try {
			
			String sql = """
					SELECT COUNT(*)
					FROM ALUMNO
					WHERE alu_id = ?
										""";
			int aux = jdbcTemplate.queryForObject(sql, Integer.class, alu_id);
			if (aux == 0) {
				throw new Exception("Alumno no existe");
			}
			
			sql = """
					SELECT
					COUNT(*)
					FROM MATRICULA
					WHERE alu_id = ?
										""";
			aux = jdbcTemplate.queryForObject(sql, Integer.class, alu_id);
			if (aux == 0) {
				throw new Exception("Alumno no está matriculado");
			}
			
			sql = """
					SELECT
					cro_monto mensualidad,
					cro_fecha_prog fecha
					FROM CRONOGRAMA_PAGO c JOIN MATRICULA m
					ON c.mat_id = m.mat_id
					WHERE alu_id=?
					""";
			
			List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, alu_id);
			for (Map<String, Object> row : rows) {
				FechapagoDto dto = new FechapagoDto();
				dto.setFecha(row.get("fecha").toString());
				dto.setMonto(Double.parseDouble(row.get("mensualidad").toString()));
				dto.setCuota(contador);
				lista.add(dto);
				contador++;
			}

		} catch (DataAccessException e) {
			System.err.println("ERROR AL OBTENER LA INFORMACION: " + e.getMessage());
		}

		return lista;
	}

	@SuppressWarnings("deprecation")
	public CursosProfesorResponse cursosProfesor(int id_prof) throws Exception {
	    String sql;
	    CursosProfesorResponse response = new CursosProfesorResponse();
		ProfesorDto pdto = new ProfesorDto();
		List<ClasesDto> lista = new LinkedList<>();
		try {
			sql = """
					SELECT
					COUNT(prof_id)
					FROM SECCION_CURSO
					WHERE prof_id = ?
										""";
			int aux = jdbcTemplate.queryForObject(sql, Integer.class, id_prof);
			if (aux == 0) {
				throw new Exception("Profesor no existe");
			}
			sql = """
					SELECT
					CONCAT(prof_apellido,', ',prof_nombre) profesor,
					prof_dni dni,
					prof_email email,
					prof_telefono telefono
					FROM PROFESOR
					WHERE prof_id=?
									 """;

			pdto = jdbcTemplate.queryForObject(
				    sql,
				    new Object[]{id_prof},
				    new BeanPropertyRowMapper<>(ProfesorDto.class)
				);
			
			sql = """
					SELECT
					CONCAT(a.grad_id, a.sec_nombre) seccion,
					c.cur_nombre curso
					FROM SECCION_CURSO s JOIN CURSO c ON S.cur_id=C.cur_id
					JOIN SECCION a ON a.sec_id=s.sec_id
					WHERE prof_id=?
																				         """;

			List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, id_prof);
			for (Map<String, Object> row : rows) {
				ClasesDto dto = new ClasesDto();
				dto.setCurso(row.get("curso").toString());
				dto.setSeccion(row.get("seccion").toString());
				lista.add(dto);
			}
			response.setProfesor(pdto);
			response.setClases(lista);
		} catch (DataAccessException e) {
			System.err.println("ERROR AL OBTENER LA INFORMACION: " + e.getMessage());
		}

		return response;
	}

	public String horario(int sec_id) throws Exception {
		StringBuilder reporte = new StringBuilder();
		List<HorarioDto> lista = new LinkedList<>();
		List<HoraDto> horas = new LinkedList<>();
		String lunes = "";
		String martes = "";
		String miercoles = "";
		String jueves = "";
		String viernes = "";
		String sql = "";
		try {
			sql = """
					SELECT
					COUNT(h.hor_id)
					FROM HORARIO h
					JOIN SECCION_CURSO s ON h.asig_id = s.asig_id
					WHERE s.sec_id = ?;
										""";
			int aux = jdbcTemplate.queryForObject(sql, Integer.class, sec_id);
			if (aux == 0) {
				throw new Exception("Seccion no existe");
			}
			sql = """
					SELECT
					    CONVERT(VARCHAR(8), h.hor_inicio, 108) AS inicio,
					    h.hor_dia AS dia,
					    c.cur_nombre AS nombre
					FROM HORARIO h
					JOIN SECCION_CURSO s ON h.asig_id = s.asig_id
					JOIN CURSO c ON c.cur_id = s.cur_id
					WHERE s.sec_id = ?;
															         """;

			List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, sec_id);
			for (Map<String, Object> row : rows) {
				HorarioDto dto = new HorarioDto();
				dto.setInicio(row.get("inicio").toString());
				dto.setDia(row.get("dia").toString());
				dto.setNombre(row.get("nombre").toString());
				lista.add(dto);
			}

			sql = """
					SELECT
					    CONVERT(VARCHAR(8), hor_inicio, 108) AS inicio,
					    CONVERT(VARCHAR(8), hor_fin, 108) AS fin
					FROM HORARIO
					GROUP BY
					    CONVERT(VARCHAR(8), hor_inicio, 108),
					    CONVERT(VARCHAR(8), hor_fin, 108);
				""";

			List<Map<String, Object>> filas = jdbcTemplate.queryForList(sql);
			for (Map<String, Object> fila : filas) {
				HoraDto dto = new HoraDto();
				dto.setInicio(fila.get("inicio").toString());
				dto.setFin(fila.get("fin").toString());
				horas.add(dto);
			}

			reporte.append(String.format("%-15s %-15s %-27s %-27s %-27s %-27s %-27s%n", "INICIO", "FIN", "LUNES",
					"MARTES", "MIERCOLES", "JUEVES", "VIERNES"));
			reporte.append(
					"--------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");

			for (HoraDto elemento : horas) {
				for (HorarioDto dto : lista) {
					if (dto.getDia().equals("LUNES") && elemento.getInicio().equals(dto.getInicio())) {
						lunes = dto.getNombre();
					}
					if (dto.getDia().equals("MARTES") && elemento.getInicio().equals(dto.getInicio())) {
						martes = dto.getNombre();
					}
					if (dto.getDia().equals("MIERCOLES") && elemento.getInicio().equals(dto.getInicio())) {
						miercoles = dto.getNombre();
					}
					if (dto.getDia().equals("JUEVES") && elemento.getInicio().equals(dto.getInicio())) {
						jueves = dto.getNombre();
					}
					if (dto.getDia().equals("VIERNES") && elemento.getInicio().equals(dto.getInicio())) {
						viernes = dto.getNombre();
					}
				}
				reporte.append(String.format("%-15s %-15s %-27s %-27s %-27s %-27s %-27s%n", elemento.getInicio(),
						elemento.getFin(), lunes, martes, miercoles, jueves, viernes));
				if (elemento.getInicio().equals("09:30:00")) {
					reporte.append(String.format("%-15s %-15s %-27s %-27s %-27s %-27s %-27s%n", "10:15:00", "10:30:00",
							"RECREO", "RECREO", "RECREO", "RECREO", "RECREO"));
				}
				if (elemento.getInicio().equals("11:15:00")) {
					reporte.append(String.format("%-15s %-15s %-27s %-27s %-27s %-27s %-27s%n", "12:00:00", "12:15:00",
							"RECREO", "RECREO", "RECREO", "RECREO", "RECREO"));
				}
			}
			reporte.append(
					"--------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return reporte.toString();
	}
}
