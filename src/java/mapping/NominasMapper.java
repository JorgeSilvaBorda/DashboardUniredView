/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package mapping;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;
import util.json.JSONArray;
import util.json.JSONObject;

/**
 *
 * @author jsilvab
 */
public class NominasMapper extends HttpServlet {
    private static Map<String, String> entorno = System.getenv();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	JSONObject datos = new JSONObject(request.getParameter("datos"));
	PrintWriter out = response.getWriter();

	switch (datos.getString("tipo")) {
	    case "resumen-nominas":
		out.print(getObjectFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/resumen"));
		break;
	    case "nominas-programadas-dia":
		out.print(getArrayFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/dia/"));
		break;
	    case "nominas-ejecutadas-dia":
		out.print(getArrayFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/dia/ejecutados"));
		break;
	    case "nominas-exitosas-dia":
		out.print(getArrayFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/dia/exitosos"));
		break;
	    case "nominas-errores-dia":
		out.print(getArrayFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/dia/errores"));
		break;
	    case "nominas-pendientes-dia":
		out.print(getArrayFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/dia/pendientes"));
		break;
	    case "nominas-no-recibidas-dia":
		out.print(getArrayFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/dia/norecibidas"));
		break;
	    case "nominas-sin-procesar-dia":
		out.print(getArrayFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/dia/sinprocesar"));
		break;
	    case "nominas-parcialmente-recibidas-dia":
		out.print(getArrayFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/dia/parcialmente"));
		break;
	    case "nominas-nocumple-headerfooter":
		out.print(getArrayFromUrl("http://" + entorno.get("BACKEND_APLICACION") + ":" + entorno.get("BACKEND_APLICACION_PORT") + "/procesonominas/dia/nocumple"));
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
            System.out.println("No se puede obtener el objeto desde la URL (NominasMapper)");
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
            System.out.println("No se puede obtener el array desde la URL (NominasMapper)");
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
	    try ( OutputStream os = con.getOutputStream()) {
		byte[] input = JsonContent.getBytes("utf-8");
		os.write(input, 0, input.length);
	    }
	    try ( BufferedReader br = new BufferedReader(
		    new InputStreamReader(con.getInputStream(), "utf-8"))) {
		StringBuilder response = new StringBuilder();
		String responseLine = null;
		while ((responseLine = br.readLine()) != null) {
		    response.append(responseLine.trim());
		}
		return new JSONObject(response.toString());
	    }

	} catch (Exception ex) {
	    System.out.println("No se puede hacer post (RendicionesMapper)");
            System.out.println("Ruta: " + ruta);
	    System.out.println(ex);
            ex.printStackTrace();
	    return new JSONObject();
	}
    }

}
