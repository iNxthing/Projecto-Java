/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package objetos;

/**
 *
 * @author nothing
 */
public class Periodo {
    private int idPeriodo;
    private String nombre;

    public Periodo(int idPeriodo, String nombre) {
        this.idPeriodo = idPeriodo;
        this.nombre = nombre;
    }

    public int getIdPeriodo() {
        return idPeriodo;
    }

    public String getNombre() {
        return nombre;
    }
    
}
