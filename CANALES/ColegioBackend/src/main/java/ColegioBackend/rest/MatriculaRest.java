package ColegioBackend.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ColegioBackend.dto.MatriculaDto;
import ColegioBackend.service.MatriculaService;
import ColegioBackend.service.OpcionalPrueba;



@RestController
@RequestMapping("/colegio")
public class MatriculaRest {
	@Autowired
	private MatriculaService matriculaService;
	@Autowired
	private OpcionalPrueba opcion;
	
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

}
