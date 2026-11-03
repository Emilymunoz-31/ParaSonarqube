/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package pruebas;

import Controlador.Categoria_TratamientoDAO;
import Modelo.Categoria_Tratamiento;

public class CategoriaTratamiento_pruebaconsultar {
    public static void main(String[] args) {
        
        Categoria_TratamientoDAO dao = new Categoria_TratamientoDAO();
        
        int idABuscar = 1; 
        
        Categoria_Tratamiento categoriaEncontrada = dao.consultaCategoria_Tratamiento(idABuscar);
        
        if (categoriaEncontrada != null) {
            System.out.println("--- Categoría Encontrada ---");    
            System.out.println("ID: " + categoriaEncontrada.getid_Categoria());
            System.out.println("Nombre de la categoría: " + categoriaEncontrada.getnombre_categoria());
            
        } else {
            System.out.println("No se encontró ninguna categoría con el ID: " + idABuscar);
        }
    }
}