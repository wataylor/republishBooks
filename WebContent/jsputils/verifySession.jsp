<%-- verifySession.jsp 

Code to check that the session is not new and that someone is logged in

   Copyright (c) 2002 by Advanced Systems & Software Technologies.
   All Rights Reserved
--%><%@ page import="
asst.perennity.PereConst"
%>
<%
if (session.isNew()) {%>
<jsp:forward page="/logIn.jsp">
<jsp:param name="expired" value="y" />
</jsp:forward><%
}

if (session.getAttribute(PereConst.USERID_ATTR) == null) {%>
<jsp:forward page="logIn.jsp">
<jsp:param name="mustlog" value="y" />
</jsp:forward><%
}%>
