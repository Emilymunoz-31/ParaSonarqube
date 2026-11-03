package Pruebas;

import Controlador.Tipo_tratamientoDAO;
import Modelo.Tipo_tratamiento;
import java.sql.SQLException;
import java.util.Scanner;

/**
 *
 * @author Aprendiz
 */
public class Tipotratamiento_pruebainsertar {

    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);

        Tipo_tratamiento tipo_tratamiento = new Tipo_tratamiento();
        Tipo_tratamientoDAO dao = new Tipo_tratamientoDAO();

        System.out.println("=== PRUEBA: INSERTAR TIPO DE TRATAMIENTO ===");



        System.out.print("Ingrese la descripción del tipo de tratamiento (ej: Montaje - Brackets MBT): ");
        tipo_tratamiento.setdescripcion_tipotratam(sc.nextLine());

        System.out.print("Ingrese el costo del tratamiento: ");
        tipo_tratamiento.setcosto(sc.nextDouble());
        

        sc.nextLine();

        System.out.print("Ingrese el ID de la Categoría a la que pertenece (Ej: 1, 2, 3...): ");
        tipo_tratamiento.setCategoria_Tratamiento_id_Categoria(sc.nextInt());

        boolean resultado = dao.insertarTipo_tratamiento(tipo_tratamiento);

        if (resultado) {
            System.out.println("\n✅ El tipo de tratamiento se guardó correctamente en VITALEM.");
        } else {
            System.out.println("\n❌ El tipo de tratamiento no se guardó. Revisa que el ID de la categoría exista.");
        }
        
        sc.close();
    }
}