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
            SELECT user_nombre AS username, user_clave AS password, 1 AS posicion
        		FROM USUARIO WHERE user_nombre = ? AND user_clave = ?
        		UNION
        		SELECT emp_usuario AS username, emp_clave AS password, 2 AS posicion
        		FROM EMPLEADO WHERE emp_usuario = ? AND emp_clave = ?
        		UNION
        		SELECT prof_usuario AS username, prof_clave AS password, 3 AS posicion
        		FROM PROFESOR WHERE prof_usuario = ? AND prof_clave = ?
        """;
        Map<String,Object> rec;

        try {
            rec = jdbcTemplate.queryForMap(sql, username, password, username, password, username, password);
        } catch (Exception e) {
            rec = null;
        }
        return rec;
    }
}

