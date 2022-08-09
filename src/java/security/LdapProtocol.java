package security;

import java.util.Properties;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.Attributes;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;
import util.json.JSONObject;

public class LdapProtocol {

    private String adHost;
    private String adOu;
    private String adDc1;
    private String adDc2;

    /**
     * Clase con el método para autenticar al usuario con Active Directory y buscar su información.
     * 
     * @param adHost {@link java.lang.String} - Nombre de la variable de entorno
     * que contiene el host de Active Directory.
     * @param adOu {@link java.lang.String} - Nombre de la variable de entorno
     * que contiene el OU.
     * @param adDc1 {@link java.lang.String} - Nombre de la variable de entorno
     * que contiene el DC #1.
     * @param adDc2 {@link java.lang.String} - Nombre de la variable de entorno
     * que contiene el DC #2.
     */
    public LdapProtocol(String adHost, String adOu, String adDc1, String adDc2) {
	this.adHost = adHost;
	this.adOu = adOu;
	this.adDc1 = adDc1;
	this.adDc2 = adDc2;
    }

    public JSONObject getUserInfo(String user, String pass) {
	
	LdapContext ctx = getLdapContext(user, pass);
	SearchControls searchControls = getSearchControls();
	JSONObject usuario = new JSONObject();
	try {
	    NamingEnumeration<SearchResult> respuesta = ctx.search("dc=" + System.getenv(adDc1) + ",dc=" + System.getenv(adDc2), "sAMAccountName=" + user, searchControls);
	    if (respuesta.hasMore()) {
		Attributes attrs = respuesta.next().getAttributes();
		usuario.put("estadoLogin", "success");
		usuario.put("login", user);
		usuario.put("nombre", attrs.get("givenname").get());
		usuario.put("apellido", attrs.get("sn").get());
		/*
		System.out.println(attrs.get("distinguishedname"));
		System.out.println(attrs.get("cn"));
		System.out.println(attrs.get("givenname"));
		System.out.println(attrs.get("fullname"));
		System.out.println(attrs.get("displayname"));
		System.out.println(attrs.get("name"));
		System.out.println(attrs.get("lastname"));
		System.out.println(attrs.get("sn"));
		System.out.println(attrs.get("mail"));
		System.out.println(attrs.get("telephonenumber"));
		*/
		System.out.println("Autenticación existosa");
	    }
	} catch (Exception ex) {
	    System.out.println("No se pudo obtener la información del usuario");
	    System.out.println(ex);
	    usuario.put("estadoLogin", "error");
	}
	return usuario;
    }

    private LdapContext getLdapContext(String user, String pass) {
	
	LdapContext ctx = null;
	Properties env = new Properties();
	String host = System.getenv(adHost);
	String ou = System.getenv(adOu);
	String dc1 = System.getenv(adDc1);
	String dc2 = System.getenv(adDc2);

	try {
	    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
	    env.put(Context.PROVIDER_URL, "ldap://" + host + ":389");
	    env.put(Context.SECURITY_PRINCIPAL, "cn=" + user + ",ou=" + ou + ",dc=" + dc1 + ",dc=" + dc2);
	    env.put(Context.SECURITY_CREDENTIALS, pass);
	    env.put(Context.SECURITY_PRINCIPAL, user + "@" + dc1);
	    ctx = new InitialLdapContext(env, null);
	    //System.out.println("LDAP Context construction finished succesfully");
	} catch (Exception ex) {
	    System.out.println("Login Failed");
	    System.out.println(ex);
	}
	return ctx;
    }

    private SearchControls getSearchControls() {
	SearchControls controls = new SearchControls();
	controls.setSearchScope(SearchControls.SUBTREE_SCOPE);
	String[] attrIds = {"distinguishedName", "sn", "givenname", "mail", "telephonenumber"};
	controls.setReturningAttributes(attrIds);
	return controls;
    }

}
