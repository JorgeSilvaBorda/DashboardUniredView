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
import util.json.JSONArray;
import util.json.JSONObject;

/**
 *
 * @author jsilvab
 */
public class RendicionesMapper extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	JSONObject datos = new JSONObject(request.getParameter("datos"));
	PrintWriter out = response.getWriter();

	switch (datos.getString("tipo")) {
	    case "resumen-rendiciones":
		out.print(getObjectFromUrl("http://0.0.0.0:8082/proceso/resumen"));
		break;
	    case "rendiciones-programadas-dia":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/"));
		break;
	    case "rendiciones-ejecutadas-dia":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/ejecutados"));
		break;
	    case "rendiciones-exitosas-dia":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/exitosos"));
		break;
	    case "rendiciones-errores-dia":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/errores"));
		break;
	    case "rendiciones-pendientes-dia":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/pendientes"));
		break;
	    case "rendiciones-vacias-dia":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/vacias"));
		break;
	    case "rendiciones-enviadas-mail-dia":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/enviadasmail"));
		break;
	    case "rendiciones-en-ejecucion":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/ejecucion"));
		break;
	    case "rendiciones-generadas":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/generadas"));
		break;
	    case "rendiciones-transmitidas":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/dia/transmitidas"));
		break;
	    case "subprocesos-rendicion":
		out.print(getArrayFromUrl("http://0.0.0.0:8082/proceso/" + datos.getInt("idProceso") + "/subprocesos"));
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
	    System.out.println(ex);
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
	    System.out.println(ex);
	    return new JSONObject();
	}
    }

}
