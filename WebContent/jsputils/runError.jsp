<%@ page import="java.io.ByteArrayOutputStream,
java.io.PrintStream" isErrorPage="true" %>
<html>
<head><title>Run Error</title>

<%-- runError.jsp

   Copyright (c) 2001 by Advanced Systems and Software Technologies.
   All Rights Reserved

   Under revision by: $Locker:  $
   Change Log:
   $Log: runError.jsp,v $
   Revision 1.1  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

--%>

</head>
<body>
<h1 align="center">Execution Error</h1>
<p><font color="red"><%= exception.toString() %></font>
<hr />

<pre>
<%
    ByteArrayOutputStream ostr = new ByteArrayOutputStream();
    exception.printStackTrace(new PrintStream(ostr));
    out.print(ostr);
%>
</pre>

<hr />
<p>Please copy this display and email it to the owner of this page.</p>
<p>Here's his email:
<a href="mailto:krtaylor@as-st.com">krtaylor@as-st.com</a></p>
</body></html>
