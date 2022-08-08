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
	
	switch(datos.getString("tipo")){
	    case "resumen-rendiciones": out.print(getObjectFromUrl("http://localhost:8082/proceso/resumen"));
	    break;
	    case "rendiciones-programadas-dia": out.print(getArrayFromUrl("http://localhost:8082/proceso/dia/"));
	    break;
	    case "rendiciones-ejecutadas-dia": out.print(getArrayFromUrl("http://localhost:8082/proceso/dia/ejecutados"));
	    break;
	    case "rendiciones-exitosas-dia": out.print(getArrayFromUrl("http://localhost:8082/proceso/dia/exitosos"));
	    break;
	    case "rendiciones-errores-dia": out.print(getArrayFromUrl("http://localhost:8082/proceso/dia/errores"));
	    break;
	    case "rendiciones-pendientes-dia": out.print(getArrayFromUrl("http://localhost:8082/proceso/dia/pendientes"));
	    break;
	    case "subprocesos-rendicion": out.print(getArrayFromUrl("http://localhost:8082/proceso/subprocesos"));
	    break;
	    default: out.print("{}");
	    break;
	}
    } 
    
    private JSONObject getObjectFromUrl(String ruta){
	try{
	    URL url = new URL(ruta);
	    HttpURLConnection con = (HttpURLConnection)url.openConnection();
	    con.setRequestMethod("GET");
	    BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
	    String linea;
	    StringBuilder mensaje = new StringBuilder();
	    while((linea = reader.readLine()) != null){
		mensaje.append(linea);
	    }
	    return new JSONObject(mensaje.toString());
	    
	}catch (Exception ex) {
	    return new JSONObject();
	}
    }
    
    private JSONArray getArrayFromUrl(String ruta){
	try{
	    URL url = new URL(ruta);
	    HttpURLConnection con = (HttpURLConnection)url.openConnection();
	    con.setRequestMethod("GET");
	    BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
	    String linea;
	    StringBuilder mensaje = new StringBuilder();
	    while((linea = reader.readLine()) != null){
		mensaje.append(linea);
	    }
	    return new JSONArray(mensaje.toString());
	    
	}catch (Exception ex) {
	    return new JSONArray();
	}
    }
}
