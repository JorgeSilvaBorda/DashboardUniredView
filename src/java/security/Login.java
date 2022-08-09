/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;
import javax.naming.Context;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import util.json.JSONObject;

/**
 *
 * @author jsilvab
 */
public class Login extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	PrintWriter out = response.getWriter();
	//processRequest(request, response);
	//String contenido = request.getParameter("datos");
	JSONObject mensaje = new JSONObject(request.getParameter("datos"));

	switch (mensaje.getString("tipo")) {
	    case "login":
		out.println(login(mensaje, request));
		break;
	    case "logout":
		out.println(logout(request));
		break;
	}

    }

    private JSONObject login(JSONObject json, HttpServletRequest request) {
	String userName = json.getString("userName");
	String password = json.getString("password");
	//Acá valida usuario contra Active Directory. Implementar LDAP.

	LdapProtocol ldap = new LdapProtocol("DASHBOARD_AD_HOST", "DASHBOARD_AD_OU", "DASHBOARD_AD_DC_1", "DASHBOARD_AD_DC_2");
	JSONObject usuario = ldap.getUserInfo(userName, password);
	System.out.println(usuario);
	JSONObject salida = new JSONObject();
	if (usuario.getString("estadoLogin").equals("success")) {
	    HttpSession session = request.getSession();
	    
	    session.setAttribute("userName", userName);
	    session.setAttribute("nombre", usuario.getString("nombre"));
	    session.setAttribute("apellido", usuario.getString("apellido"));
	    session.setAttribute("login", usuario.getString("login"));
	    System.out.println(usuario);
	    salida.put("status", "ok");
	}else{
	    salida.put("status", "loginInvalido");
	}
	System.out.println(salida);
	return salida;
    }

    private JSONObject logout(HttpServletRequest request) {
	HttpSession session = request.getSession();
	session.removeAttribute("userName");
	session.invalidate();
	JSONObject salida = new JSONObject();
	salida.put("status", "ok");
	return salida;
    }

}
