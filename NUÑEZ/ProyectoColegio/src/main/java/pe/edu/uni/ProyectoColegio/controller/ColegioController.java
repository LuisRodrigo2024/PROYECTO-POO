package pe.edu.uni.ProyectoColegio.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import pe.edu.uni.ProyectoColegio.dto.MatriculaDto;
import pe.edu.uni.ProyectoColegio.dto.PagoDto;
import pe.edu.uni.ProyectoColegio.service.ColegioService;
import pe.edu.uni.ProyectoColegio.service.HorarioService;
import pe.edu.uni.ProyectoColegio.service.MatriculaService;

@RestController
@RequestMapping("/api/colegio")
public class ColegioController {

    @Autowired
    private ColegioService colegioService;
    
    @Autowired
	private MatriculaService matriculaService;
    
    @Autowired
	private HorarioService horario;

    @PostMapping("/pago")
    public ResponseEntity<?> realizarPago(@RequestBody PagoDto dto) {
    	try {
			dto = colegioService.pagoCuota(dto);
			return ResponseEntity.status(HttpStatus.CREATED).body(dto);
		} catch (Exception e) {
			// Manejo de excepción y respuesta con error 500
			return ResponseEntity.status(HttpStatus.BAD_REQUEST)
					.body("Error en el proceso: " + e.getMessage());
		}		
    }
    
    @PostMapping("/matricula")
	public ResponseEntity<?> matricula(@RequestBody MatriculaDto bean){
		try {
			bean = matriculaService.proc_Matricula(bean);
			return ResponseEntity.status(HttpStatus.CREATED).body(bean);
		} catch (Exception e) {
			// Manejo de excepción y respuesta con error 500
			return ResponseEntity.status(HttpStatus.BAD_REQUEST)
					.body("Error en el proceso: " + e.getMessage());
		}		
	}
    
    @GetMapping("/horario/{codigo}")
	public ResponseEntity<?> getHorario_seccion(@PathVariable int codigo){
		try {
			horario.horario_Seccion(codigo);
			return ResponseEntity.ok(horario.horario_Seccion(codigo));
		} catch (RuntimeException e) {
			//Mensaje de error
			String error=e.getMessage();
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
		}
	}
	
	@GetMapping("/horario_profesor/{codigo1}")
	public ResponseEntity<?> getHorario_profesor(@PathVariable int codigo1){
		try {
			List<Map<String, Object>> horarioProfesor=horario.horario_Profesor(codigo1);
			return ResponseEntity.ok(horarioProfesor);
		} catch (RuntimeException e) {
			//Mensaje de error
			String error=e.getMessage();
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
		}
	}
    
}
