package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import util.json.JSONArray;
import util.json.JSONObject;

public class Util {

    public static int generaRandom(int ini, int fin) {
	return (int) Math.floor(Math.random() * (fin - ini + 1) + ini);
    }
    
    public static JSONObject getObjectFromUrl(String ruta){
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
	    System.out.println(ex);
	    return new JSONObject();
	}
    }
    
    public static JSONArray getArrayFromUrl(String ruta){
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
