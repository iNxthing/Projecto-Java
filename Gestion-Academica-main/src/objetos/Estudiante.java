/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package objetos;

/**
 *
 * @author nothing
 */
public class Estudiante {
    private int idEstudiante;
    private String nombre;

    public Estudiante(int idEstudiante, String nombre) {
        this.idEstudiante = idEstudiante;
        this.nombre = nombre;
    }

    public int getIdEstudiante() {
        return idEstudiante;
    }

    public String getNombre() {
        return nombre;
    }
    
}
