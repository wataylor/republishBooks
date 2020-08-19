<%@ page import="java.sql.*,
java.util.Enumeration,
asst.perennity.PereConst,
asst.perennity.PereUtils,
asst.servlet.SessionExpiry,
asst.dbase.DataBase,
asst.dbase.SQLUtilities,
asst.debug.DebugUtils,
asst.dbase.DBProp"
errorPage="jsputils/runError.jsp"%>
<HTML><HEAD><TITLE>
Perennity Log In
</TITLE>

<!-- logIn.jsp

login screen.

   Copyright (c) 2002 by Advanced Systems and Software Technologies.
   All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: logIn.jsp,v $
   Revision 1.9  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.8  2002/09/26 19:18:22  peren
   Change for the Mac

   Revision 1.7  2002/09/25 08:32:18  peren
   report shipment history for each book

   Revision 1.6  2002/09/22 02:53:02  peren
   added pop-up notes

   Revision 1.5  2002/09/20 21:48:57  peren
   cleanup

   Revision 1.4  2002/09/20 21:13:31  peren
   close to showing

   Revision 1.3  2002/09/17 17:01:34  peren
   smaller top frame, new graphics

   Revision 1.2  2002/09/11 01:29:03  peren
   contngent

   Revision 1.1  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

--%>

<%!
String getHintMessage(String loginID) {
  String hm = PereConst.ES;
  Statement stmt = null;
  ResultSet results = null;
  String query = "select PasswordHint from Customers where LoginID='" +
    loginID + "'";
  /**/

  if ((loginID == null) || PereConst.ES.equals(loginID)) {
    return "You must specify a login ID in order to receive a hint.";
  }

  try {
    stmt    = DataBase.connDB.createStatement();
    results = stmt.executeQuery(query);
    if (results.next()) {
      hm = SQLUtilities.stringFromResult(results, 1);
    }
    if (PereConst.ES.equals(hm)) {
      hm = "There is no password hint recorded for " + loginID;
    } else {
      hm = "Your password hint is " + hm;
    }
  } catch (Exception e) {
    System.out.println("Hint exception " + e.toString());
  } finally {
    try {
      if (results != null) { results.close(); }
      if (stmt    != null) { stmt.close(); }
    } catch (SQLException e) {}
  }
  return hm;
}
%>
<%!
String sessionIDsuff;
String LoginID;
String Password;
String forwardPlace;
String anyParam;
String hintMessage;
boolean bummer;
int i;
%>
<script language="JavaScript" SRC="jsputils/openWindow.js"></script>
<%
sessionIDsuff = ";jsessionid=" + session.getId();
if (session.getAttribute(PereConst.USERID_ATTR) != null) {
%> <jsp:forward page="custmenu.jsp" /> <%
}

bummer = false;
DBProp.PropertyConnection("Perennity");

LoginID  = request.getParameter("LoginID");
Password = request.getParameter("Password");
if (request.getParameter("hint") != null) {
  hintMessage = getHintMessage(LoginID);
  System.out.println("H " + hintMessage);
} else {
  hintMessage = null;
}
%>

<script language="JavaScript">

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>?disFr=logIn.jsp");
}

function setFocus() {
if (document.SubForm.LoginID.value=="") {
document.SubForm.LoginID.focus();
} else {
document.SubForm.Password.focus();
}
}

var sessionIDsuff = "<%=sessionIDsuff%>"

function checkChar(e) {
var charCode = (navigator.appName == "Netscape") ? e.which : e.keyCode
//status = charCode
if (charCode==13){
document.SubForm.submit();
}
}
</script>
<link rel="stylesheet" href="style.css">
</HEAD>
<BODY bgcolor=white onLoad="setFocus()">
<%
if (hintMessage == null) {
if ((LoginID != null) && (Password != null)) {
//If login succeeds, sets the session attributes
  if (PereUtils.Authenticate(LoginID, Password, request, true)) {
//System.out.println("U " + LoginID + " P " + Password);
%> <jsp:forward page="custmenu.jsp" /> <%
  } else {
    bummer = true;
    %>
<font Color="red" size="+1">Invalid Login ID or Password, please try again.</font>
<%
}
}
}

// Get initial ID from URL if possible
if ((LoginID == null) || (LoginID.equals(PereConst.ES))) {
  LoginID = request.getParameter(PereConst.URLID_PARAM);
  if ((LoginID == null) || (LoginID.equals(PereConst.ES))) {
    LoginID = (String)session.getAttribute(PereConst.URLID_ATTR);
  }
  if (LoginID == null) {
    LoginID = PereConst.ES;
  }
}

if (request.getParameter("expired") != null) {
    bummer = true;
%>
<p>Your session has expired.  For security reasons, we ask that you log
in again.</p>
<SCRIPT LANGUAGE="JavaScript">
<!--
top.nav.justLoggedOut();
top.nav.sessionIDsuff = "<%=sessionIDsuff%>"
// -->
</SCRIPT>
<%
}

if ( (anyParam = request.getParameter("noperm")) != null) {
    bummer = true;
%>
<p>You have logged in properly, but <%=LoginID%> does not have permission to
<%=anyParam%></p>
<%
}

if (request.getParameter("mustlog") != null) {
    bummer = true;
%>
<p>You have tried to enter a secure part of this site which requires
that you log in.</p>
<%
}

%>

<h1>Log In to Customer Services</h1>

<p>Perennity Publishing provides this online system to track your books through our shipping, scanning, proofing, and republishsing process.  This helps us communicate with you if there are any questions concerning individual books.</p>

<p><a href="servicesinfo.html">More information about this system</a></p>

<p>If you are a new customer, you can <a href="contact.jsp<%=sessionIDsuff%>">contact us</a> to open your account.  If you would like to explore our tracking system first, feel free to log in as &quot;guest&quot;, password &quot;guest&quot; and look around.</p>

<P>Please enter your Login Name and Password:</p>

<FORM name=SubForm method="post" action="<%=response.encodeURL("logIn.jsp")%>">
<table border=0 cellpadding=2>
<tr><td align=right>Login Name: </td><td><input type=text name="LoginID" value="<%=LoginID%>" width="20"></td></tr>
<tr><td align=right>Password: </td><td><input type=password name="Password" value="" width="20" onKeyPress="return checkChar(event)"></td></tr>
<tr><td colspan=2 align=center><input type=submit name="<%=PereConst.LOGIN_PARAM%>" value="Login">
<input type="submit" name="hint" value="Show Password Hint"></td></tr>
</table>
</form>

<%
if (bummer) {
  %><script language="JavaScript">alert("There has been an error, please look for the error messages");</script><%
}
if (session.getAttribute("debug") != null) {
%>
<%= DebugUtils.makeFormParamTable(request) %>
<%= DebugUtils.makeSessionTable(request) %>
<%
}
%>
<%
if (hintMessage != null) {
%>
<script language="JavaScript">
openHelpWindow('<%=hintMessage%>');
t=setTimeout("OpenWindow.focus()",500);
</script>
<%
}
%>
</body>
</html>
