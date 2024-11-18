package pe.edu.uni.ProyectoColegio.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString 
public class PagoDto {
	
	private int cro_id;
	private int emp_id;
	private int pag_pension;
	private double pag_importe;	
	private String pag_fecha;
	private String pag_fecha_prog;

}
