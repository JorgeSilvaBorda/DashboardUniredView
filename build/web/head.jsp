<%
  if(session.getAttribute("userName") == null){
        session.invalidate();
        response.sendRedirect("login.jsp");
    }  

%>
