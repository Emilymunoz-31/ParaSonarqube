                                                                                                                                                                                                                                                                                                                                                                                                                               package Pruebas;

import Conexion.Conexion;
import java.sql.Connection;

public class Conexionprueba {

    public static void main(String[] args) {

        Conexion con = new Conexion();
        Connection registrar = con.getConn();

        if (registrar != null) {
    System.out.println("Conexión exitosa");
} else {
    System.out.println("Error en la conexión");
}
    }
}