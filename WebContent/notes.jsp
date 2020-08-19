<%@include file='classIncludes.inc'%>
<%@ page import="java.sql.*, asst.perennity.BookObject"
%>
<!-- notes.jsp

Displays notes for a given customer, book, or shipment.

   Copyright (c) 2002 by Advanced Systems and Software Technologies.
   All Rights Reserved
-->
<%!
String sessionIDsuff;
%>
<% sessionIDsuff = ";jsessionid=" + session.getId(); %>
<%@include file='/jsputils/verifySession.jsp'%>
<%@include file='userSettings.inc'%>
<%!
String anyParam;
ResultSet results = null;	// Results of the order retrieval
Statement getRow = null;		// Retrieve orders
String noteDate;
String noteWho;
String noteText;
String typeID;
String editID;
String name;
%>
<%
DBProp.PropertyConnection(PereConst.DATABASE_NAME);
getRow = DataBase.connDB.createStatement();

typeID = request.getParameter("typeID");
editID = request.getParameter("editID");
name = request.getParameter("name");
if (name == null) { name = editID; }

if ((request.getParameter("submitNote") != null) && 
    ( (anyParam = request.getParameter("noteText")) != null) &&
    !PereConst.ES.equals(anyParam)) {

SQLUtilities.AnyStatement("INSERT INTO Notes (ID, TypeID, LinkID, Created, CreatedBy, NoteText) VALUES (NULL," + typeID + ", " + editID + ", NULL, " +
		       Quotable.ConstructSQLCharacterValue(loginID) + ", " +
		       Quotable.ConstructSQLCharacterValue(anyParam) + ")");
}
%>
<HTML>
<HEAD>
<TITLE>Notes
</TITLE>
<SCRIPT language="JavaScript">
var sessionIDSuff = "<%=sessionIDsuff%>";
window.resizeTo(700,400);
</script>
<link rel="stylesheet" href="style.css">
</HEAD>
<body>
<h2 align=center>Notes for <%=PereConst.NOTE_TYPE_DESCRIPTIONS[SQLUtilities.integerFromString(typeID)]%><%if (!name.equals(PereConst.ES)){%><br><%=name%><%}%><br>Customer <%=customerGreet%></h2>

<FORM name=SubForm action="notes.jsp<%=sessionIDsuff%>" method=post>
<input type=hidden name="typeID" value="<%=typeID%>">
<input type=hidden name="editID" value="<%=editID%>">
<input type=hidden name="name" value="<%=name%>">
<table border="1" cellpadding=3 align=center>
<tr><td align=center><input type=submit name="submitNote" value="Record Note -->"><br>Please put an extra blank line between paragraphs.</td><td><TEXTAREA cols=50 rows=6 wrap=soft name="noteText"></TEXTAREA></td></tr>
<%
try {
String query = "select Created,NoteText,CreatedBy from Notes where TypeID=" + typeID + " and LinkID=" + editID + " ORDER BY Created DESC";
  results=getRow.executeQuery(query);
  while (results.next()) {
    	noteDate = SelectorFieldPreload.
	  SQL_DATE_STRING.format(results.getTimestamp(1));
	noteText = Quotable.QuoteToHTML(results.getString(2));
	noteWho = results.getString(3);
%>
	  <tr><td colspan="2" height="3" bgcolor="brown"></td></tr>
<tr><td><%=noteDate%></td><td><%=noteWho%></td></tr>
<tr><td colspan=2><%=noteText%></td></tr>
<%
}
} finally {
  if (results  != null) results.close();
  getRow.close();
}
%>
</table>
<br>
<center>
<input type=button value="Click Here To Close" onClick='self.close()'>
</center>
</FORM>

</html>
