package pe.edu.uni.ProyectoColegio.service;

//import java.sql.ResultSet;
//import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import pe.edu.uni.ProyectoColegio.dto.FechapagoDto;
import pe.edu.uni.ProyectoColegio.dto.HoraDto;
import pe.edu.uni.ProyectoColegio.dto.HorarioDto;

@Service
public class ColegioService {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	public String cronogramaPago() throws Exception {
		int contador = 1;
		StringBuilder reporte = new StringBuilder();
		List<FechapagoDto> lista = new LinkedList<>();
		try {
			String sql = """
					SELECT
					(SELECT mensualidad FROM PRECIO) mensualidad,
					cro_fecha_prog fecha
					FROM CRONOGRAMA_PAGO
					WHERE anio_id=2024
										         """;

			List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
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

			for (FechapagoDto elemento : lista) {
				reporte.append(String.format("%-15s %-27s %-27s%n", elemento.getCuota(), elemento.getMonto(),
						elemento.getFecha()));
			}
			reporte.append("------------------------------------------------------------------------\n");

		} catch (DataAccessException e) {
			System.err.println("ERROR AL OBTENER LA INFORMACION: " + e.getMessage());
		}

		return reporte.toString();
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
			System.out.println(aux);
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
			throw new Exception("Error en registro de venta: " + e.getMessage());
		}

		return reporte.toString();
	}

}
