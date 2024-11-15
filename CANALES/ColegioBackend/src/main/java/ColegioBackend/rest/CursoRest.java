package ColegioBackend.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ColegioBackend.dto.CursoDto;
import ColegioBackend.service.CursoService;




@RestController	
@RequestMapping("/colegio")
public class CursoRest {
	@Autowired
	private CursoService cursoservice;
	
	 @GetMapping("/curso")
    public List<CursoDto> getAllCursos() {
        return cursoservice.getCurso();
    }
	
	

}
