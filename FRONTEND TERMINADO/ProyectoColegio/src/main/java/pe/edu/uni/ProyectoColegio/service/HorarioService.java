package pe.edu.uni.ProyectoColegio.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class HorarioService {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	public List<Map<String,Object>> horario_Seccion(int codigo_seccion){
		
		//Variables
		String sql;
		
		//Validacion
		sql="select COUNT(*) cont from SECCION where sec_id=?";
		int cont=jdbcTemplate.queryForObject(sql,Integer.class,codigo_seccion);
		if(cont!=1) {
			throw new RuntimeException("La sección no existe");
		}
		
		//Desarrollo
		sql="""
			SELECT 
			    h.hor_dia,
				h.hor_inicio, 
			    h.hor_fin, 
				sc.cur_id, 
			    c.cur_nombre
			FROM 
			    SECCION_CURSO sc 
			JOIN 
			    HORARIO h ON sc.asig_id = h.asig_id
			JOIN 
			    CURSO c ON c.cur_id = sc.cur_id 
			WHERE 
			    sc.sec_id = ?
			ORDER BY 
			    CASE 
			        WHEN h.hor_dia = 'LUNES' THEN 1
			        WHEN h.hor_dia = 'MARTES' THEN 2
			        WHEN h.hor_dia = 'MIERCOLES' THEN 3
			        WHEN h.hor_dia = 'JUEVES' THEN 4
			        WHEN h.hor_dia = 'VIERNES' THEN 5
			        ELSE 6
			    END,
			    c.cur_nombre; 
				""";
		List<Map<String,Object>> listado;
		listado = jdbcTemplate.queryForList(sql,codigo_seccion);
		return listado;
	}
	
	
	public List<Map<String,Object>> horario_Profesor(int codigo_profesor){
		//Variables
		String sql;
		
		//Validacion
		sql="select COUNT(*) cont from PROFESOR where prof_id=?";
		int cont=jdbcTemplate.queryForObject(sql,Integer.class,codigo_profesor);
		if(cont!=1) {
			throw new RuntimeException("El profesor no existe");
		}
		
		//Desarrollo
		sql="""
			SELECT 
			    h.hor_dia,
				h.hor_inicio,
				h.hor_fin,
				sc.cur_id, 
			    c.cur_nombre
			FROM 
			    SECCION_CURSO sc
			JOIN 
			    HORARIO h ON sc.asig_id = h.asig_id
			JOIN 
			    CURSO c ON c.cur_id = sc.cur_id 
			WHERE 
			    sc.prof_id =?
			ORDER BY 
			    CASE 
			        WHEN h.hor_dia = 'LUNES' THEN 1
			        WHEN h.hor_dia = 'MARTES' THEN 2
			        WHEN h.hor_dia = 'MIERCOLES' THEN 3
			        WHEN h.hor_dia = 'JUEVES' THEN 4
			        WHEN h.hor_dia = 'VIERNES' THEN 5
			        ELSE 6
			    END,
			    c.cur_nombre;
				""";
		List<Map<String,Object>> listado;
		listado = jdbcTemplate.queryForList(sql,codigo_profesor);
		return listado;
	}
	
	

}
