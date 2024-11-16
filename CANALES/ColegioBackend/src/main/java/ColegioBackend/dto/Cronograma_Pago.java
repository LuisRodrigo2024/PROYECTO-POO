package ColegioBackend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data @AllArgsConstructor @NoArgsConstructor @ToString  
public class Cronograma_Pago {
	private int cro_id;
	private int mat_id;
	private int tipo_pago_id;
	private double cro_monto;
	private String cro_fecha_prog;

}
