package pe.edu.uni.ProyectoColegio.dto;

import java.util.List;

import lombok.Data;

@Data
public class CursosProfesorResponse {
    private ProfesorDto profesor;
    private List<ClasesDto> clases;
}
