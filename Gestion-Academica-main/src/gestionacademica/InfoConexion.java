/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package gestionacademica;

/**
 *
 * @author cymaniatico
 */
public class InfoConexion {
    String url = "jdbc:mysql://localhost/gestion_academica";
    String username="root";
    String password="72564025";

    public InfoConexion() {
    }
    

    public String getUrl() {
        return url;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }
}
