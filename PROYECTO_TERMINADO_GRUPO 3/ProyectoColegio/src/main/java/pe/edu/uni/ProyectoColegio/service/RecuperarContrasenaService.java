package pe.edu.uni.ProyectoColegio.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RecuperarContrasenaService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
    public void cambiarContrasena(String dni, String email, String nuevaContrasena) {
    	
        // Validar la existencia del usuario y obtener el tipo
        String tipoUsuario = validarDatos(dni, email);

        // Si la validación es exitosa, actualizamos la contraseña
        actualizarContrasena(dni, email, nuevaContrasena, tipoUsuario);
    }

    public String validarDatos(String dni, String email) {
    	
        String sql = """
            SELECT CASE
                WHEN EXISTS (SELECT 1 FROM EMPLEADO WHERE emp_dni = ? AND emp_email = ?) THEN 'EMPLEADO'
                WHEN EXISTS (SELECT 1 FROM PROFESOR WHERE prof_dni = ? AND prof_email = ?) THEN 'PROFESOR'
                ELSE NULL
            END
        """;
        String tipoUsuario = jdbcTemplate.queryForObject(sql, String.class, dni, email, dni, email);

        if (tipoUsuario == null) {
            throw new RuntimeException("Los datos proporcionados no coinciden con ningún usuario.");
        }

        return tipoUsuario;
    }
    
    @Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
    private void actualizarContrasena(String dni, String email, String nuevaContrasena, String tipoUsuario) {
        String sql = "";

        if ("EMPLEADO".equals(tipoUsuario)) {
            sql = """
                UPDATE EMPLEADO
                SET emp_clave = ?
                WHERE emp_dni = ? AND emp_email = ?
            """;
        } else if ("PROFESOR".equals(tipoUsuario)) {
            sql = """
                UPDATE PROFESOR
                SET prof_clave = ?
                WHERE prof_dni = ? AND prof_email = ?
            """;
        }
        jdbcTemplate.update(sql, nuevaContrasena, dni, email);
        
    }
}








