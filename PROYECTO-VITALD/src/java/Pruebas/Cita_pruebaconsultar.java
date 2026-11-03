package Pruebas;

import Controlador.CitaDAO;
import Modelo.Cita;


public class Cita_pruebaconsultar{
    public static void main(String[] args) {
        
        CitaDAO dao = new CitaDAO();
        
        
        int idABuscar = 1; 
        Cita citaEncontrado = dao.consultaCita(idABuscar);
        
        
        if (citaEncontrado != null) {
            System.out.println("--- cita Encontrada ---");    
            System.out.println("ID: " + citaEncontrado.getid_Cita());
            System.out.println("fecha y hora de la cita: " + citaEncontrado.getfecha_hora());
            System.out.println("Descripcion: " + citaEncontrado.getdescripcion_cita());
            System.out.println("ID de usuario: " + citaEncontrado.getUsuario_id_Usuario());
            System.out.println("ID de cita: " + citaEncontrado.getEstado_cita_idEstado_cita());
            System.out.println("ID de tratamiento: " + citaEncontrado.getTipo_Tratamiento_id_Tipotratam());
           
        } else {
            System.out.println("No se encontró ninguna cita con el ID: " + idABuscar);
        }
    }
}