<%@include file='classIncludes.inc'%>
<%@ page import="asst.dbase.ResultSetModel"
%>
<!-- findAddableBooks.jsp

Utility to look at all customer-owned books which are not part of a
shipment and add them to the shipment.

   Copyright (c) 2002 by Advanced Systems and Software Technologies.
   All Rights Reserved
-->
<%!
String sessionIDsuff;
String anyParam;
ResultSetModel model;
String tableTitle;
int i;
String editID;
String query;
SelectorManager[] fieldMgrs;
SelectorFieldPreload ShipmentID;
boolean empty;
%>
<% sessionIDsuff = ";jsessionid=" + session.getId(); %>
<%@include file='jsputils/verifySession.jsp'%>
<%@include file='userSettings.inc'%>
<% DBProp.PropertyConnection("Perennity");
editID =  request.getParameter("editID");
empty = false;
if (request.getParameter("add") != null) {
  Enumeration enumV;
  String name;
  String cval = null;

  if (fieldMgrs == null) {
    fieldMgrs = new SelectorManager[3];
    fieldMgrs[0] = (ShipmentID = new SelectorFieldPreload("In_Shipment", PereConst.BOOK_TABLE, "ShipmentID"));
    ShipmentID.setIsNumeric(true);
    ShipmentID.setIsLogged(true);
  }

  enumV = request.getParameterNames();
  while (enumV.hasMoreElements()) {
    name = (String) enumV.nextElement();
    if (name.startsWith("bK_")) {
      System.out.println(name + " " + cval);
      if (( (cval = request.getParameter(name)) !=null)) {
	System.out.println(name + " " + cval);
	name = name.substring(3);
	ShipmentID.setDirtyChoice(editID);
	ChangeLog.LogDirtyChanges(fieldMgrs, name, loginID, userID,
				  PereConst.ES);
	TwixtTableAndForm.AllFormToTable(fieldMgrs, PereConst.ID_COL, Integer.parseInt(name));
      }
    }
  }
  %><HTML><HEAD>
<SCRIPT language="JavaScript">
opener.ShipmentForm.refresh.value="y";
opener.ShipmentForm.<%=PereConst.SAVE_PARAM%>.click();
window.close();
</script></head>
<BODY>
</BODY>
</html><%
return;
} else {
  query = "select ID, Name, Author from Books where ShipmentID=0 and CustomerID=" + customerID;
//System.out.println(query);
  model  = new ResultSetModel();
  model.setResultSetFromQuery(query);
  if (model.getRowCount() > 0) {
    tableTitle = "Books Available for Shipment";
    for (i=0; i<model.getRowCount(); i++) {
      anyParam = (String)model.getValueAt(i, 0);
      model.setValueAt(i, 0, "<input type=\"checkbox\" value=\"add\" name=\"bK_" + anyParam + "\"> " + anyParam);
    }
  } else {
    tableTitle = "No Books are available to be added to this Shipment";
	empty = true;
  }
}
%>
<HTML><HEAD><TITLE>
Add Book To Shipment
</TITLE>
<SCRIPT language="JavaScript">
var sessionIDSuff = "<%=sessionIDsuff%>";
window.resizeTo(600,400);
</script>
<link rel="stylesheet" href="style.css">
</head>
<BODY>
<center>
<FORM name=SubForm method="post"
action="<%=response.encodeURL("findAddableBooks.jsp")%>">
<input type="hidden" name="customerID" value="<%=customerID%>">
<input type=button value="Cancel" onClick="window.close()">
<input type=submit name="add" value="Add Selected Books">
<input type=hidden name="editID" value="<%=editID%>">
<%
if (empty) {
%>
<p align=center>There are no books available to be added.</p>
<p align=center>This could be because you have no books entered, or because all your books have been added to shipments already.</p>

<p align=center><a href="javascript:opener.location.href='BookMaintain.jsp<%=sessionIDsuff%>?editID=0&customerID=<%=customerID%>';window.close();">Click here to enter a new book.</a></p>

<%} else {%>
<TABLE border="1" cellpadding="3">
<TR><TH colspan=3><%=tableTitle%></th></tr>
<%=model.makeTableBody()%>
</table>
<%}%>
<br>
<input type=submit name="add" value="Add Selected Books">
</form>
</center>

<%@include file='debugDisplay.inc'%>
</body>
</html>
