package Conexion;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class EmailUtil {

    private static final String API_KEY = System.getenv("RESEND_API_KEY");
    private static final String REMITENTE = "VitalDentist Notificaciones <notificaciones@vitaldents.shop>";
    private static final String RESEND_URL = "https://api.resend.com/emails";

    private static boolean enviarCorreo(String correoDestino, String asunto, String cuerpoHTML) {
        try {
            String jsonBody = "{"
                    + "\"from\":\"" + escapar(REMITENTE) + "\","
                    + "\"to\":[\"" + escapar(correoDestino) + "\"],"
                    + "\"subject\":\"" + escapar(asunto) + "\","
                    + "\"html\":\"" + escapar(cuerpoHTML) + "\""
                    + "}";

            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(RESEND_URL))
                    .header("Authorization", "Bearer " + API_KEY)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .timeout(Duration.ofSeconds(15))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            System.out.println("Resend status: " + response.statusCode());
            System.out.println("Resend body: " + response.body());

            return response.statusCode() >= 200 && response.statusCode() < 300;

        } catch (Exception e) {
            System.out.println("Error enviando correo con Resend: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Escapa comillas, saltos de línea, etc. para que el HTML no rompa el JSON
    private static String escapar(String texto) {
        if (texto == null) return "";
        return texto
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "");
    }

    public static boolean enviarCodigoRecuperacion(String correoDestino, String codigo) {
        String cuerpoHTML = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;'>"
                + "<h2 style='color: #0d6efd;'>VitalDentist</h2>"
                + "<p>Hemos recibido una solicitud para restablecer tu contrasena.</p>"
                + "<p>Tu codigo de seguridad temporal es:</p>"
                + "<h1 style='background-color: #f8f9fa; display: inline-block; padding: 10px 20px; color: #0d6efd; border-radius: 5px;'>" + codigo + "</h1>"
                + "<p>Ingresa este codigo para acceder y actualizar tu clave.</p>"
                + "</div>";

        return enviarCorreo(correoDestino, "Recuperacion de Contrasena - VitalDentist", cuerpoHTML);
    }

    public static boolean enviarConfirmacionCita(String correo, String nombrePaciente, String fecha_hora, String Tipo_Tratamiento, String descripcion_cita) {
        String cuerpoHTML = "<div style='font-family: Arial, sans-serif; padding: 25px; border: 1px solid #e0e0e0; border-radius: 12px; max-width: 600px; margin: auto; background-color: #fdfdfd;'>"
                + "<div style='text-align: center; border-bottom: 2px solid #274c77; padding-bottom: 15px; margin-bottom: 20px;'>"
                + "  <h2 style='color: #274c77; margin: 0;'>VitalDentist</h2>"
                + "  <p style='color: #6096ba; font-size: 14px; margin: 5px 0 0;'>Orden y Confirmacion de Cita Medica</p>"
                + "</div>"
                + "<p>Hola <strong>" + nombrePaciente + "</strong>,</p>"
                + "<p>Tu cita odontologica ha sido agendada con exito en nuestro sistema. A continuacion, te compartimos los detalles importantes:</p>"
                + "<table style='width: 100%; border-collapse: collapse; margin-top: 15px; background-color: #f8fafc; border-radius: 8px; overflow: hidden;'>"
                + "  <tr><td style='padding: 12px; border-bottom: 1px solid #e2e8f0; color: #475569;'><strong>Tratamiento:</strong></td><td style='padding: 12px; border-bottom: 1px solid #e2e8f0; color: #1e293b;'>" + Tipo_Tratamiento + "</td></tr>"
                + "  <tr><td style='padding: 12px; border-bottom: 1px solid #e2e8f0; color: #475569;'><strong>Fecha y Hora:</strong></td><td style='padding: 12px; border-bottom: 1px solid #e2e8f0; color: #1e293b;'>" + fecha_hora + "</td></tr>"
                + "  <tr><td style='padding: 12px; color: #475569;'><strong>Observaciones:</strong></td><td style='padding: 12px; color: #1e293b;'>" + (descripcion_cita != null ? descripcion_cita : "Ninguna") + "</td></tr>"
                + "</table>"
                + "<br><div style='background-color: #edf5f8; padding: 12px; border-radius: 6px; font-size: 13px; color: #274c77;'>"
                + "  <strong>Recomendaciones:</strong> Por favor presentate en nuestra clinica 10 minutos antes de la hora programada. Si necesitas cancelar o reprogramar, comunicate con anticipacion."
                + "</div>"
                + "<p style='margin-top: 25px; font-size: 13px; color: #94a3b8; text-align: center;'>Atentamente,<br><strong>Equipo Clinica Odontologica VitalDentist</strong></p>"
                + "</div>";

        return enviarCorreo(correo, "Confirmacion de Cita Odontologica - VitalDentist", cuerpoHTML);
    }
}