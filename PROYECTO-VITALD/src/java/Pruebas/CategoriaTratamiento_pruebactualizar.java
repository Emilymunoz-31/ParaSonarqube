/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package pruebas;

import Controlador.Categoria_TratamientoDAO;
import Modelo.Categoria_Tratamiento;
import java.sql.SQLException;
import java.util.Scanner;

public class CategoriaTratamiento_pruebactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        Categoria_TratamientoDAO dao = new Categoria_TratamientoDAO();
        Categoria_Tratamiento m = new Categoria_Tratamiento();
        
        System.out.println("=== ACTUALIZAR CATEGORÍA DE TRATAMIENTO ===");
        

        System.out.print("Ingrese el ID de la categoría a actualizar: ");
        m.setid_Categoria(sc.nextInt());
        sc.nextLine(); 
        
        
        System.out.print("Nuevo nombre de la categoría (ej: Ortodoncia Estética): ");
        m.setnombre_categoria(sc.nextLine());

       
        boolean resultado = dao.actualizarCategoria_Tratamiento(m);
        
        
        if (resultado) {
            System.out.println("\n✅ ¡Éxito! La categoría se actualizó correctamente en VITALEM.");
        } else {
            System.out.println("\n❌ Error: La categoría no se actualizó. Verifica que el ID ingresado realmente exista.");
        }
        
        sc.close();
        
    }
}