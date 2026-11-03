/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Pruebas;

import Controlador.Categoria_TratamientoDAO;
import Modelo.Categoria_Tratamiento;
import java.util.Scanner;

/**
 *
 * @author Aprendiz
 */
public class CategoriaTratamiento_pruebainsertar {

    public static void main(String[] args) {
        
        Scanner sc = new Scanner(System.in);
        
        
        Categoria_Tratamiento categoria = new Categoria_Tratamiento();
        Categoria_TratamientoDAO dao = new Categoria_TratamientoDAO();

        System.out.println("=== PRUEBA: INSERTAR CATEGORÍA DE TRATAMIENTO ===");
        

        System.out.print("Ingrese el nombre de la nueva categoría (ej: Ortodoncia - Brackets): ");
        categoria.setnombre_categoria(sc.nextLine());


        boolean resultado = dao.insertarCategoria_Tratamiento(categoria);

       
        if (resultado) {
            System.out.println("\n✅ ¡Éxito! La categoría se guardó correctamente en VITALEM.");
        } else {
            System.out.println("\n❌ Error: La categoría no se guardó. Revisa la consola para más detalles.");
        }
        
       
        sc.close();
    }
}