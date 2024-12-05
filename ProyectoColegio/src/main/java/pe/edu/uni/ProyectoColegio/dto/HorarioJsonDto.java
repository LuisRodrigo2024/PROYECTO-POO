package pe.edu.uni.ProyectoColegio.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString 
public class HorarioJsonDto {
	
	private String inicio;
	private String fin;
	private String lunes;
	private String martes;
	private String miercoles;
	private String jueves;
	private String viernes;

}
