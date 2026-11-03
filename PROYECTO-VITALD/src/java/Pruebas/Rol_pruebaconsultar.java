package Pruebas;

import Controlador.RolDAO;
import Modelo.Rol;


public class Rol_pruebaconsultar{
    public static void main(String[] args) {
        
        RolDAO dao = new RolDAO();
        
        
        int idABuscar = 1; 
        Rol rolEncontrado = dao.consultaRol(idABuscar);
        
        
        if (rolEncontrado != null) {
            System.out.println("--- Rol Encontrado ---");
            System.out.println("ID: " + rolEncontrado.getid_Rol());
            System.out.println("Descripcion: " + rolEncontrado.getdescripcion_rol());
        } else {
            System.out.println("No se encontró ningún Tipo de tratamiento con el ID: " + idABuscar);
        }
    }
}