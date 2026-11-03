package Pruebas;

import Controlador.Tipo_documentoDAO;
import Modelo.Tipo_documento;


public class Tipodoc_pruebaconsultar {
    public static void main(String[] args) {
        
        Tipo_documentoDAO dao = new Tipo_documentoDAO();
        
        
        int idABuscar = 1; 
        Tipo_documento tipo_documentoEncontrado = dao.consultaTipo_documento(idABuscar);
        
        
        if (tipo_documentoEncontrado != null) {
            System.out.println("--- Tipo de documento Encontrado ---");
            System.out.println("ID: " + tipo_documentoEncontrado.getid_Tipodocumento());
            System.out.println("Descripcion: " + tipo_documentoEncontrado.getdescripcion_tipodoc());
        } else {
            System.out.println("No se encontró ningún Tipo de tratamiento con el ID: " + idABuscar);
        }
    }
}