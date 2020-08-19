<%@include file='classIncludes.inc'%>
<%@ page import="java.sql.*,
asst.dbase.ResultSetModel,
asst.perennity.ShipmentObject"
%>
<!-- findCustomerShipment.jsp

Find and edit a customer shipment

   Copyright (c) 2002 by AS-ST.  All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: findCustomerShipment.jsp,v $
   Revision 1.10  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.9  2002/09/27 02:36:40  peren
   more mac fixes

   Revision 1.8  2002/09/26 19:18:22  peren
   Change for the Mac

   Revision 1.7  2002/09/24 02:30:33  peren
   general cleanup

   Revision 1.6  2002/09/22 02:53:02  peren
   added pop-up notes

   Revision 1.5  2002/09/21 03:11:57  peren
   user interface smoothing

   Revision 1.4  2002/09/20 02:10:57  peren
   smaller top image, edit and ship books

   Revision 1.3  2002/09/17 17:01:34  peren
   smaller top frame, new graphics

   Revision 1.2  2002/09/11 01:29:03  peren
   contngent

   Revision 1.1  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

--%>
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
SelectorDBPreload shipmentSelector;
ResultSetModel model = null;
String saved;
%>
<%
DBProp.PropertyConnection("Perennity");
session.removeAttribute(PereConst.SHIPMENT_ATTR);

if (fieldMgrs == null) {
fieldMgrs =  new SelectorManager[1];
}
// Always get a new shipment name selector to force the names to refresh
fieldMgrs[0] = (shipmentSelector = new SelectorDBPreload("Name", PereConst.SHIPMENT_TABLE, "Name"));
shipmentSelector.setWhereOrder("where CustomerID=" + customerID);
shipmentSelector.setAddParam("onChange=document.SubForm.edit.click()");
shipmentSelector.setIsNumeric(true);

for (i=0; i<fieldMgrs.length; i++) {
if (fieldMgrs[i] != null) { fieldMgrs[i].setChoice(request); }
}

anyParam=request.getParameter("saved");
if (anyParam != null) {
  saved = "<font Color=\"red\" size=\"+1\">Saved data for &quot;" + anyParam +
    "&quot; shipment.</font>";
} else {
  saved = PereConst.ES;
}

if ( (anyParam = request.getParameter("summary")) != null) {
  model = new ResultSetModel();
  anyParam = "select ID, Name, Description from Shipments where CustomerID=" + customerID;
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
// The "dir" parameter is for a customer setting up a shipment so it
// goes from customer to perennity, note that the direction string
// must agree with the direction strings in the ShipmentObject.
session.removeAttribute(PereConst.SHIPMENT_ATTR);

%>
<jsp:forward page="ShipmentMaintain.jsp">
<jsp:param name="editID" value="0" />
<jsp:param name="customerID" value="<%=customerID%>" />
<jsp:param name="retTo" value="findCustomerShipment.jsp" />
<jsp:param name="dir" value="1" />
</jsp:forward>
<%
}

anyParam = request.getParameter("ID");
// The ID must be non-empty and must have a proper integer value
if ((anyParam != null) && (!PereConst.ES.equals(anyParam))) {
  editID = SQLUtilities.integerFromString(anyParam);
if ((editID > 0) &&
    DataBase.isIntInTableColumn(PereConst.SHIPMENT_TABLE, "ID", editID)) {
session.removeAttribute(PereConst.SHIPMENT_ATTR);
%>
<jsp:forward page="ShipmentMaintain.jsp">
<jsp:param name="editID" value="<%=editID%>" />
<jsp:param name="retTo" value="findCustomerShipment.jsp" />
<jsp:param name="customerID" value="<%=customerID%>" />
</jsp:forward>
<%
} else {
sb.append("<LI>Could not find a shipment whose ID Number is " + anyParam + "</li>");
}
}
%>

<%
anyParam = shipmentSelector.getChoice();
if ((anyParam != null) && (!PereConst.ES.equals(anyParam))) {

    session.removeAttribute(PereConst.SHIPMENT_ATTR);
%>
<jsp:forward page="ShipmentMaintain.jsp">
<jsp:param name="editID" value="<%=anyParam%>" />
<jsp:param name="retTo" value="findCustomerShipment.jsp" />
</jsp:forward>
<%

}
%>
<HTML><HEAD><TITLE>
Maintain Shipment Information
</TITLE>

<script language="JavaScript">
var sessionIDSuff = "<%=sessionIDsuff%>";

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>?disFr=findCustomerShipment.jsp");
}

function checkChar(e) {
var charCode = (navigator.appName == "Netscape") ? e.which : e.keyCode
//status = charCode
if (charCode==13){
document.SubForm.submit();
}
}

function eD(d) {
  location.href="ShipmentMaintain.jsp" + sessionIDSuff + "?state=start&dir=1&editID=" + d + "&customerID=" + <%=customerID%>;
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

<h1>Shipments for <%=customerGreet%></h1>
<p>Please select the shipment to view:</p>

<FORM name=SubForm method="post" target="display"
action="<%=response.encodeURL("findCustomerShipment.jsp")%>">
<input type="hidden" name="customerID" value="<%=customerID%>">
<p>Shipment
<%=shipmentSelector.getPrettyName()%>:
<%=shipmentSelector.getHTMLOnly()%>
<input type=submit name="edit" value="Edit the Selected Shipment"></p>
<p><input type=submit name="create" value="Create a NEW Shipment">
<input type=submit name="summary" value="Show All My Shipments">
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
