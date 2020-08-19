<%@include file='classIncludes.inc'%>
<%@ page import="java.sql.*,
asst.dbase.ResultSetModel,
asst.perennity.BookObject"
%>
<!-- findBook.jsp

Find and edit a book

   Copyright (c) 2002 by AS-ST.  All Rights Reserved
-->
<%!
String sessionIDsuff;
%>
<%
sessionIDsuff = ";jsessionid=" + session.getId();
%>
<%@include file='jsputils/verifySession.jsp'%>
<%@include file='userSettings.inc'%>

<%!
String anyParam;
int i;
int editID;
Statement getRow;		// Retrieve all the rows
String query;
ResultSet results;		// List of all values in the query
SelectorManager [] fieldMgrs;
SelectorDBPreload bookSelector;
ResultSetModel model = null;
String saved;
%>
<%
DBProp.PropertyConnection("Perennity");
session.removeAttribute(PereConst.BOOK_ATTR);

if (fieldMgrs == null) {
fieldMgrs =  new SelectorManager[1];
}
// Always get a new shipment name selector to force the names to refresh
fieldMgrs[0] = (bookSelector = new SelectorDBPreload("Title", PereConst.BOOK_TABLE, "Name"));
bookSelector.setWhereOrder("where CustomerID=" + customerID);
bookSelector.setAddParam("onChange=document.SubForm.edit.click()");
bookSelector.setIsNumeric(true);

for (i=0; i<fieldMgrs.length; i++) {
if (fieldMgrs[i] != null) { fieldMgrs[i].setChoice(request); }
}

anyParam=request.getParameter("saved");
if (anyParam != null) {
  saved = "<font Color=\"red\" size=\"+1\">Saved data for <i>" + anyParam +
    "</i>.</font>";
} else {
  saved = PereConst.ES;
}

if ( (anyParam = request.getParameter("summary")) != null) {
  model = new ResultSetModel();
  anyParam = "select ID, Name, Author from Books where CustomerID=" + customerID;
  model.setResultSetFromQuery(anyParam);;
  for (i=0; i<model.getRowCount(); i++) {
    anyParam = (String)model.getValueAt(i, 0);
    model.setValueAt(i, 0, "<input type=\"button\" value=\"Edit\" onClick='eD(\"" + anyParam + "\")'> " + anyParam);
  }
} else {
  model = null;
}

if (request.getParameter("create") != null) {
System.out.println("Creating");

session.removeAttribute(PereConst.BOOK_ATTR);

%>
<jsp:forward page="BookMaintain.jsp">
<jsp:param name="editID" value="0" />
<jsp:param name="customerID" value="<%=customerID%>" />
<jsp:param name="retTo" value="findBook.jsp" />
<jsp:param name="dir" value="1" />
</jsp:forward>
<%
}

anyParam = request.getParameter("ID");
// The ID must be non-empty and must have a proper integer value
if ((anyParam != null) && (!PereConst.ES.equals(anyParam))) {
  editID = SQLUtilities.integerFromString(anyParam);
if ((editID > 0) &&
    DataBase.isIntInTableColumn(PereConst.BOOK_TABLE, "ID", editID)) {
session.removeAttribute(PereConst.BOOK_ATTR);
%>
<jsp:forward page="BookMaintain.jsp">
<jsp:param name="editID" value="<%=editID%>" />
<jsp:param name="retTo" value="findBook.jsp" />
<jsp:param name="customerID" value="<%=customerID%>" />
</jsp:forward>
<%
} else {
sb.append("<LI>Could not find a book whose ID Number is " + anyParam + "</li>");
}
}
%>

<%
anyParam = bookSelector.getChoice();
if ((anyParam != null) && (!PereConst.ES.equals(anyParam))) {

    session.removeAttribute(PereConst.BOOK_ATTR);
%>
<jsp:forward page="BookMaintain.jsp">
<jsp:param name="editID" value="<%=anyParam%>" />
<jsp:param name="retTo" value="findBook.jsp" />
</jsp:forward>
<%
}
%>
<HTML><HEAD><TITLE>
Maintain Book Information
</TITLE>

<script language="JavaScript">
var sessionIDSuff = "<%=sessionIDsuff%>";

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>?disFr=findBook.jsp");
}

function checkChar(e) {
var charCode = (navigator.appName == "Netscape") ? e.which : e.keyCode
//status = charCode
if (charCode==13){
document.SubForm.submit();
}
}

function eD(d) {
  location.href="BookMaintain.jsp" + sessionIDSuff + "?state=start&dir=1&editID=" + d + "&customerID=" + <%=customerID%>;
}

</script>
<link rel="stylesheet" href="style.css">
</HEAD>
<BODY>

<%=saved%>

<% if (sb.length() != 0) { %>
<font color="red"> Please correct the following errors:</font>
<UL> <%=sb%> </ul>
<%
}
sb = null;
%>
<h1>Books for <%=customerGreet%></h1>
<p>Please select the book to view:</p>

<FORM name=SubForm method="post" target="display"
action="<%=response.encodeURL("findBook.jsp")%>">
<input type="hidden" name="customerID" value="<%=customerID%>">

<p>Book <%=bookSelector.getPrettyName()%>:
<%=bookSelector.getHTMLOnly()%>
<input type=submit name="edit" value="Edit the Selected Book"></p>
<p><input type=submit name="create" value="Create a NEW Book">
<input type=submit name="summary" value="Show All My Books">
<input type=button value="Cancel"
onClick="location.href='custmenu.jsp<%=sessionIDsuff%>'">
</form>

<%
if (model != null) {
%><TABLE border="1" cellspacing="2"><%=model.makeTableBody()%></table><%
model = null;			// Promote garbage collection
}

if (session.getAttribute("debug") != null) {
%>
<%= DebugUtils.makeSessionTable(request) %>
<%= DebugUtils.makeFormParamTable(request) %>
<%
}
%>

</body>
</html>
