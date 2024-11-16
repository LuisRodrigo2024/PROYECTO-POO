package ColegioBackend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ColegioBackend.dto.MatriculaDto;

@Service
public class OpcionalPrueba {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
    public MatriculaDto proc_Matricula(MatriculaDto bean) {
        // Datos del DTO
        int aluId = bean.getAlu_id();
        int secId = bean.getSec_id();
        int empId = bean.getEmp_id();
        String matTipo = bean.getMat_tipo().trim().toUpperCase();
        String matFecha = validarFecha(bean.getMat_fecha().trim());
        String matEstado = "Activo";

        // Validaciones generales
        validarExistencia("ALUMNO", "alu_id", aluId, "El alumno no existe");
        validarExistencia("SECCION", "sec_id", secId, "La sección no existe");
        validarExistencia("EMPLEADO", "emp_id", empId, "El empleado no existe");
        validarTipo(matTipo);
        validarSeccionDisponible(secId);
        validarAlumnoMatriculado(aluId, secId);

        // Validación específica: Progresión del alumno
        if (esAlumnoNuevo(aluId)) {
            System.out.println("Alumno nuevo: se omiten validaciones de grado.");
        } else {
            validarProgresionGrado(aluId, secId);
        }

        // Registrar matrícula
        registrarMatricula(aluId, secId, empId, matTipo, matFecha, matEstado);

        // Actualizar vacantes en la sección
        actualizarVacantes(secId);

        // Generar cronograma de pagos
        double costo = calcularCostoPorTipo(matTipo);
        generarCronogramaPagos(aluId, secId, matFecha, costo);

        // Actualizar el estado en el DTO
        bean.setMat_estado(matEstado);
        bean.setMat_fecha(matFecha);

        return bean;
    }

    // Métodos auxiliares

    private void validarExistencia(String tabla, String columna, int id, String mensajeError) {
        String sql = String.format("SELECT COUNT(*) FROM %s WHERE %s = ?", tabla, columna);
        int count = jdbcTemplate.queryForObject(sql, Integer.class, id);
        if (count == 0) {
            throw new RuntimeException(mensajeError);
        }
    }

    private void validarSeccionDisponible(int secId) {
        String sql = "SELECT sec_vacantes FROM SECCION WHERE sec_id = ?";
        int vacantes = jdbcTemplate.queryForObject(sql, Integer.class, secId);
        if (vacantes <= 0) {
            throw new RuntimeException("La sección no tiene vacantes disponibles");
        }
    }

    private void validarAlumnoMatriculado(int aluId, int secId) {
        String sql = """
            SELECT COUNT(*) 
            FROM MATRICULA 
            WHERE alu_id = ? AND sec_id = ?
        """;
        int count = jdbcTemplate.queryForObject(sql, Integer.class, aluId, secId);
        if (count > 0) {
            throw new RuntimeException("El alumno ya está matriculado en esta sección");
        }
    }

    private boolean esAlumnoNuevo(int aluId) {
        String sql = "SELECT COUNT(*) FROM MATRICULA WHERE alu_id = ?";
        int count = jdbcTemplate.queryForObject(sql, Integer.class, aluId);
        return count == 0; // Si no tiene matrículas previas, es un alumno nuevo
    }

    private void validarProgresionGrado(int aluId, int secId) {
        String sql = """
            WITH GradoAnterior AS (
                SELECT TOP 1 S.grad_id
                FROM MATRICULA M
                JOIN SECCION S ON M.sec_id = S.sec_id
                WHERE M.alu_id = ?
                ORDER BY M.mat_fecha DESC
            )
            SELECT COUNT(*)
            FROM SECCION S
            JOIN GradoAnterior GA ON S.grad_id = GA.grad_id OR S.grad_id = GA.grad_id + 1
            WHERE S.sec_id = ?
        """;
        int count = jdbcTemplate.queryForObject(sql, Integer.class, aluId, secId);
        if (count == 0) {
            throw new RuntimeException("El alumno solo puede matricularse en su último grado o el siguiente");
        }
    }

    private void validarTipo(String matTipo) {
        if (!matTipo.equals("BECA") && !matTipo.equals("REGULAR") && !matTipo.equals("SEMIBECA")) {
            throw new IllegalArgumentException("El tipo de matrícula debe ser BECA, REGULAR o SEMIBECA");
        }
    }

    private String validarFecha(String matFecha) {
        String sql = "SELECT CONVERT(VARCHAR, CONVERT(DATETIME, ?, 103), 103)";
        return jdbcTemplate.queryForObject(sql, String.class, matFecha);
    }

    @Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
    private void registrarMatricula(int aluId, int secId, int empId, String matTipo, String matFecha, String matEstado) {
        String sql = """
            INSERT INTO MATRICULA 
                (alu_id, sec_id, emp_id, mat_tipo, mat_fecha, mat_estado)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        jdbcTemplate.update(sql, aluId, secId, empId, matTipo, matFecha, matEstado);
    }

    @Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
    private void actualizarVacantes(int secId) {
        String sql = """
            UPDATE SECCION 
            SET sec_matriculados = sec_matriculados + 1, 
                sec_vacantes = sec_vacantes - 1 
            WHERE sec_id = ?
        """;
        jdbcTemplate.update(sql, secId);
    }

    private double calcularCostoPorTipo(String matTipo) {
        String sql = "SELECT mensualidad FROM PRECIO";
        double precioBase = jdbcTemplate.queryForObject(sql, Double.class);

        return switch (matTipo) {
            case "BECA" -> 0.0;
            case "SEMIBECA" -> precioBase * 0.5;
            default -> precioBase; // REGULAR
        };
    }

    @Transactional(propagation = Propagation.MANDATORY, rollbackFor = Exception.class)
    private void generarCronogramaPagos(int aluId, int secId, String matFecha, double costo) {
        String sql = """
            INSERT INTO CRONOGRAMA_PAGO (mat_id, tipo_pago_id, cro_monto, cro_fecha_prog)
            SELECT mat_id, 
                   CASE WHEN ROW_NUMBER() OVER (ORDER BY mes) = 1 THEN 1 ELSE 2 END AS tipo_pago_id, 
                   ? AS cro_monto, 
                   DATEFROMPARTS(YEAR(GETDATE()), mes, 15) AS cro_fecha_prog
            FROM (VALUES (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS Meses(mes)
            JOIN MATRICULA ON alu_id = ?
        """;
        jdbcTemplate.update(sql, costo, aluId);
    }
}
