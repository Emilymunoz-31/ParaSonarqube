package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    private String driver = "com.mysql.cj.jdbc.Driver";

    private String user = getEnv("MYSQLUSER", "root");
    private String password = getEnv("MYSQLPASSWORD", null);
    private String baseDatos = getEnv("MYSQLDATABASE", "railway");
    private String host = getEnv("MYSQLHOST", "localhost");
    private String port = getEnv("MYSQLPORT", "3306");

    private String url = "jdbc:mysql://" + host + ":" + port + "/" + baseDatos
            + "?useTimezone=true&serverTimezone=America/Bogota&useSSL=false&allowPublicKeyRetrieval=true";

    private static String getEnv(String key, String def) {
        String v = System.getenv(key);
        return (v != null && !v.isBlank()) ? v.trim() : def;
    }

    public Connection getConn() {
        Connection conn = null;
        try {
            if (password == null) {
                throw new IllegalStateException("MYSQLPASSWORD no está definida en las variables de entorno");
            }
            Class.forName(driver);
            conn = DriverManager.getConnection(url, user, password);
        } catch (Exception ex) {
            System.out.println("EXCEPCION CONEXION -> " + ex.getMessage());
        }
        return conn;
    }
}