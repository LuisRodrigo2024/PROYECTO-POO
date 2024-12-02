package pe.edu.uni.ProyectoColegio.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data 
@AllArgsConstructor 
@NoArgsConstructor 
@ToString 
public class LoginDto {
	
	private String username;
	private String password;
	private int posicion;

}
