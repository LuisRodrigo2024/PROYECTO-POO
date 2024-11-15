package pe.edu.uni.ProyectoColegio.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import pe.edu.uni.ProyectoColegio.dto.PagoDto;
import pe.edu.uni.ProyectoColegio.service.ColegioService;

@RestController
@RequestMapping("/api/colegio")
public class PagoController {

    @Autowired
    private ColegioService colegioService;

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
}
