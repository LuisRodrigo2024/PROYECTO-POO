package pe.edu.uni.ProyectoColegio.service;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class LoginService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public Map<String, Object> autenticar(String username, String password) {
    	
        String sql = """
            SELECT emp_id codigo, emp_apellido apellido,emp_nombre nombre, 1 AS posicion
        		FROM EMPLEADO WHERE emp_usuario = ? AND emp_clave = ?
        		UNION
        		SELECT prof_id codigo, prof_apellido apellido ,prof_nombre nombre, 2 AS posicion
        		FROM PROFESOR WHERE prof_usuario = ? AND prof_clave = ?
        """;
        Map<String,Object> rec;

        try {
            rec = jdbcTemplate.queryForMap(sql, username, password, username, password);
        } catch (Exception e) {
            rec = null;
        }
        
        return rec;
        
    }
}

