package pe.edu.uni.ProyectoColegio.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data 
@AllArgsConstructor 
@NoArgsConstructor 
@ToString 
public class MatriculaDto {
    private int  mat_id ;
    private int alu_id;
    private int sec_id;
    private int  emp_id;
    private String mat_tipo;
    private String mat_fecha;
    private String mat_estado;
    
}