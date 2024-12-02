package pe.edu.uni.ProyectoColegio.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class SeguridadService {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;

	public Map<String,Object> validar(String usuario, String clave){
		String sql = """
			SELECT  [emp_id] codigo 
				    ,[emp_apellido] apellido
				    ,[emp_nombre] nombre
			FROM [BDCOLEGIO].[dbo].[EMPLEADO]
			WHERE emp_clave =? and emp_usuario=?
		""";
		Map<String,Object> rec;
		try {
			rec = jdbcTemplate.queryForMap(sql, clave,usuario);
		} catch (Exception e) {
			rec = null;
		}
		return rec;
	}
}
