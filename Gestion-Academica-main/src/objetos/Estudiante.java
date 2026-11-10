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
    private String Documento;
    private int idEstudiante;
    private String nombre;
    private String nota;

    public Estudiante(String Documento, int idEstudiante, String nombre, String nota) {
        this.Documento = Documento;
        this.idEstudiante = idEstudiante;
        this.nombre = nombre;
        this.nota = nota;
    }

    public String getDocumento() {
        return Documento;
    }

    public int getIdEstudiante() {
        return idEstudiante;
    }

    public String getNombre() {
        return nombre;
    }

    public String getNota() {
        return nota;
    }
    

    
    
}
