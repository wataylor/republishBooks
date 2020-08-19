<%@ page import='java.util.Enumeration,
asst.perennity.PereConst,
asst.debug.DebugUtils,
asst.perennity.PereUtils'
errorPage='jsputils/runError.jsp'
%>
<HTML><HEAD><TITLE>
Perennity Log Out
</TITLE>

<!-- logOut.jsp

   Copyright (c) 2002 by Advanced Systems and Software Technologies.
   All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: logOut.jsp,v $
   Revision 1.5  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.4  2002/09/27 02:48:10  peren
   logout bug

   Revision 1.3  2002/09/24 02:30:33  peren
   general cleanup

   Revision 1.2  2002/09/11 01:29:03  peren
   contngent

   Revision 1.1  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

--%>
<%!
String sessionIDsuff;
String anyParam;
%>
<%
sessionIDsuff = ";jsessionid=" + session.getId();
%>
<%
//session.setAttribute("debug", "y");
anyParam = request.getParameter(PereConst.CONFIRM_PARAM);
if (anyParam != null) {
PereUtils.CleanSessionLoginAttributes(session);
try {
  session.invalidate();
} catch (Exception e) {
  System.out.println("Not invalidate the session " + e.toString());
}
%>
<script language="JavaScript">
  top.location.href="index.jsp<%=sessionIDsuff%>";
</script>
</HEAD>
<BODY>
</BODY>
</HTML>
<%
return;
}
%>

<%
anyParam = request.getParameter(PereConst.CANCEL_PARAM);
// this should not happen
if (anyParam != null) {
%>
<jsp:forward page="custmenu.jsp" />
<%
}
%>

<script language="JavaScript">
var sessionIDsuff = "<%=sessionIDsuff%>"

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>");
}

</script>
<link rel="stylesheet" href="style.css">
</HEAD>
<BODY bgcolor=yellow>

<P>Logging out ends this period of access and keeps anyone from using
your account without logging back in again.  It is
important to log out whenever you are away from your computer,
it is best not to let your session time out.</p>

<P>Do you want to log out?

<FORM name=SubForm method="post"
action="<%=response.encodeURL("logOut.jsp")%>">
<input type=submit name="<%=PereConst.CONFIRM_PARAM%>" value="Yes, Log Out">
</form>

<FORM name=SubForm2 method="post"
action="<%=response.encodeURL("custmenu.jsp")%>">

<input type=submit name="<%=PereConst.CANCEL_PARAM%>" value="No, Cancel">

</form>

<%
if (session.getAttribute("debug") != null) {
%>
<form name=BugForm method="post" target="display"
action="<%=response.encodeURL("jsputils/paramCheck.jsp")%>">
<input type=submit name="Param Check" value="Param Check">
<%= DebugUtils.makeFormParamTable(request) %>
<%= DebugUtils.makeSessionTable(request) %>
</form>
<%
}
%>

</BODY>
</HTML>
