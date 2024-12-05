package pe.edu.uni.ProyectoColegio.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString 
public class ProfesorJsonDto {
	
	private String curso;
	private String profesor;

}
