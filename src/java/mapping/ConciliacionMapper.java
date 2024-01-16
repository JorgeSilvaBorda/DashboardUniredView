/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package mapping;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import util.json.JSONArray;
import util.json.JSONObject;

/**
 *
 * @author jsilvab
 */
public class ConciliacionMapper extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JSONObject datos = new JSONObject(request.getParameter("datos"));
        PrintWriter out = response.getWriter();

        switch (datos.getString("tipo")) {
            case "resumen-conciliacion":
                out.print(getObjectFromUrl("http://0.0.0.0:8082/procesoconciliacion/resumen"));
                break;
            case "conciliacion-programadas-dia":
                out.print(getArrayFromUrl("http://0.0.0.0:8082/procesoconciliacion/dia/"));
                break;
            case "conciliacion-ejecutadas-dia":
                out.print(getArrayFromUrl("http://0.0.0.0:8082/procesoconciliacion/dia/ejecutados"));
                break;
            case "conciliacion-exitosas-dia":
                out.print(getArrayFromUrl("http://0.0.0.0:8082/procesoconciliacion/dia/exitosos"));
                break;
            case "conciliacion-errores-dia":
                out.print(getArrayFromUrl("http://0.0.0.0:8082/procesoconciliacion/dia/errores"));
                break;
            case "conciliacion-pendientes-dia":
                out.print(getArrayFromUrl("http://0.0.0.0:8082/procesoconciliacion/dia/pendientes"));
                break;
            default:
                out.print("{}");
                break;
        }
    }

    public static JSONObject getObjectFromUrl(String ruta) {
        try {
            URL url = new URL(ruta);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String linea;
            StringBuilder mensaje = new StringBuilder();
            while ((linea = reader.readLine()) != null) {
                mensaje.append(linea);
            }
            return new JSONObject(mensaje.toString());

        } catch (Exception ex) {
            System.out.println("No se puede obtener el objeto desde la URL (ConciliacionMapper)");
            System.out.println("Ruta: " + ruta);
            System.out.println(ex);
            ex.printStackTrace();
            return new JSONObject();
        }
    }

    public static JSONArray getArrayFromUrl(String ruta) {
        try {
            URL url = new URL(ruta);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String linea;
            StringBuilder mensaje = new StringBuilder();
            while ((linea = reader.readLine()) != null) {
                mensaje.append(linea);
            }
            return new JSONArray(mensaje.toString());

        } catch (Exception ex) {
            System.out.println("No se puede obtener el array desde la URL (ConciliacionMapper)");
            System.out.println("Ruta: " + ruta);
            System.out.println(ex);
            ex.printStackTrace();
            return new JSONArray();
        }
    }

    public static JSONObject postObject(String ruta, String JsonContent) {
        try {
            URL url = new URL(ruta);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setRequestProperty("Accept", "application/json");
            con.setDoOutput(true);
            try (OutputStream os = con.getOutputStream()) {
                byte[] input = JsonContent.getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(con.getInputStream(), "utf-8"))) {
                StringBuilder response = new StringBuilder();
                String responseLine = null;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
                return new JSONObject(response.toString());
            }

        } catch (Exception ex) {
            System.out.println("No se puede hacer post (ConciliacionMapper)");
            System.out.println("Ruta: " + ruta);
            System.out.println(ex);
            ex.printStackTrace();
            return new JSONObject();
        }
    }

}
