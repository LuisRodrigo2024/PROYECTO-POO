package ColegioBackend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data @AllArgsConstructor @NoArgsConstructor @ToString  

public class CursoDto {
	private String cur_id;
	private String grad_id;
	private String cur_nombre;


}
