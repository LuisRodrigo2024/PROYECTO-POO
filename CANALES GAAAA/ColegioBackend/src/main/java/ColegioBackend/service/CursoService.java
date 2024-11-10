package ColegioBackend.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import ColegioBackend.dto.CursoDto;


@Service
public class CursoService {
	@Autowired
	private JdbcTemplate jdbcTemplate;

	
	public List<CursoDto> getCurso() {
	    String sql = "SELECT * FROM CURSO";

	    List<CursoDto> cursos = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(CursoDto.class));
	    return cursos;
	}


}
