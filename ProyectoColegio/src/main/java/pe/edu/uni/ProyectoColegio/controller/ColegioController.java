package pe.edu.uni.ProyectoColegio.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import pe.edu.uni.ProyectoColegio.service.ColegioService;

@RestController
@RequestMapping("/colegio")
public class ColegioController {
	
	@Autowired
	private ColegioService colegioService;

	@GetMapping("/cronograma")
    public ResponseEntity<String> getCronograma() {
		String reporte;
        try {
        	reporte = colegioService.cronogramaPago();
        	return ResponseEntity.ok(reporte);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error en el proceso: " + e.getMessage());
		}
    }
	
	@GetMapping("/horario")
    public ResponseEntity<String> getHorarios(@RequestParam("sec_id")  int sec_id) {
		String reporte;
        try {
        	reporte = colegioService.horario(sec_id);
        	return ResponseEntity.ok(reporte);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error en el proceso: " + e.getMessage());
		}
    }

}
