<%@include file='classIncludes.inc'%>
<%@ page import="asst.perennity.ShipmentObject,
asst.dbase.ResultSetModel, java.net.URLEncoder"
%>
<!-- ShipmentMaintain.jsp

Utility to enter and maintain shipment-specific parameters, enter a
new shipment into the database, or maintain an existing shipment.  All
the action takes place in this .jsp program.

   Copyright (c) 2002 by Advanced Systems and Software Technologies.
   All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: ShipmentMaintain.jsp,v $
   Revision 1.12  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.11  2002/09/27 02:36:40  peren
   more mac fixes

   Revision 1.10  2002/09/26 19:18:22  peren
   Change for the Mac

   Revision 1.9  2002/09/25 08:32:18  peren
   report shipment history for each book

   Revision 1.8  2002/09/24 02:30:33  peren
   general cleanup

   Revision 1.7  2002/09/22 02:53:02  peren
   added pop-up notes

   Revision 1.6  2002/09/21 03:11:57  peren
   user interface smoothing

   Revision 1.5  2002/09/20 21:13:31  peren
   close to showing

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
String anyParam;
int editID;
ShipmentObject so;
int i;
String retTo;
ResultSetModel model;
String tableTitle;
String tableVerb;
String query;
SelectorManager[] fieldMgrs;
SelectorFieldPreload ShipmentID;
boolean beenShipped;
boolean hasBooks;
String directionString;
%>
<% sessionIDsuff = ";jsessionid=" + session.getId(); %>
<%@include file='jsputils/verifySession.jsp'%>
<%@include file='permSettings.inc'%>
<%@include file='userSettings.inc'%>

<% DBProp.PropertyConnection(PereConst.DATABASE_NAME);

model  = new ResultSetModel();

if ( (retTo = request.getParameter("retTo")) == null) {
  retTo = "findCustomerShipment.jsp"; // Default return path
}

// Check to be sure there is a shipment object in the session and
// create one if there is not.
if ( (so = (ShipmentObject)session.getAttribute(PereConst.SHIPMENT_ATTR)) == null) {
  so = new ShipmentObject();
  if ( (anyParam = request.getParameter("editID")) == null) {
    sb.append("<LI>Did not define an edit ID on startup.</li>");
  } else {
    editID = SQLUtilities.integerFromString(anyParam);
    so.setRecordID(editID);
    so.readRecord();		// Reads or clears the field managers

    if (editID <= 0) {
      if (!shipToProcessingPerm && !shipToCustomerPerm) {
	so.Direction.setDirtyChoice("1"); // Going to office
      } else {
	so.Direction.setDirtyChoice("0"); // Not yet know where it is going
	if (shipToProcessingPerm) { // Limit choices for a customer
	  so.Direction.setSelections(ShipmentObject.CUST_DIRECTION_SELECTIONS);
	}
      }
      so.CustomerID.setDirtyChoice(request.getParameter("customerID"));
      so.CreatedBy.setDirtyChoice(loginID);
    }
    session.setAttribute(PereConst.SHIPMENT_ATTR, so); // Remember for later
   }
} else {
  so.readFormValues(request);	// Get new values from the form
}

beenShipped = so.Status.testCharacterOfChoice(ShipmentObject.SHIPMENT_SHIPPED);

if ("0".equals(so.Direction.getChoice())) { // 0 -> do not know
  directionString = so.Direction.getHTMLOnly().toString();
} else {
  directionString = ShipmentObject.SHIPPING_ADDRESSES[SQLUtilities.integerFromString(so.Direction.getChoice())];
  if (directionString == null) { // should be the customer's address
//CODE TO DISPLAY CUSTOMER'S ADDRESS GOES HERE
    directionString = "Need cust address";
  }
}

if (request.getParameter("remove") != null) {
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
      if (( (cval = request.getParameter(name)) !=null)) {
	System.out.println(name + " " + cval);
	name = name.substring(3);
	ShipmentID.setDirtyChoice("0");
	ChangeLog.LogDirtyChanges(fieldMgrs, name, loginID, userID,
				  PereConst.ES);
	TwixtTableAndForm.AllFormToTable(fieldMgrs, PereConst.ID_COL, Integer.parseInt(name));
      }
    }
  }
}

// List books currently flagged as being in the shipment
  query = "select ID, Name, Author from Books where ShipmentID =" + so.getRecordID()+ " and CustomerID=" + so.CustomerID.getChoice();
  System.out.println(query);
   model.setResultSetFromQuery(query);
   if (model.getRowCount() > 0) { // There are books in the shipment
     tableTitle = "Books in this Shipment";
     if (beenShipped) {
       tableVerb = PereConst.ES;
     } else {
       tableVerb = "<BR><input type=submit name=remove value=\"Remove Books from Shipment\">";
     }
     hasBooks = true;
     if (!beenShipped) {
       for (i=0; i<model.getRowCount(); i++) {
	 anyParam = (String)model.getValueAt(i, 0);
	 model.setValueAt(i, 0, "<input type=\"checkbox\" value=\"remove\" name=\"bK_" + anyParam + "\"> " + anyParam);
       }
     }
   } else {
     tableTitle = "No Books have been assigned to this Shipment";
     tableVerb = PereConst.ES;
     hasBooks = false;
   }

  if (( (anyParam = request.getParameter("hitShipped")) != null) &&
       !PereConst.ES.equals(anyParam))  {
    if (hasBooks) {
      so.Status.setCharacterOfChoice(ShipmentObject.SHIPMENT_SHIPPED, 'Y');
    } else {
      sb.append("<LI>This shipment has no books, it may not be shipped</li>");
    }
  }
  if (( (anyParam = request.getParameter("hitReceived")) != null) &&
	!PereConst.ES.equals(anyParam)) {
    so.Status.setCharacterOfChoice(ShipmentObject.SHIPMENT_RECEIVED, 'Y');
  }

  so.updateStatusChanges(loginID); // Adjust statii

if (request.getParameter(PereConst.SAVE_PARAM) != null) {
  sb = so.authenticate(sb);	// Check for errata and/or omissions
  sb = TwixtTableAndForm.gripeNonUniqueValues(so.getSelectorManagerArray(), PereConst.ID_COL, so.getRecordID(), sb, "CustomerID="+so.CustomerID.getChoice());
  if (sb.length() <= 0) {
    if (so.getRecordID() == 0) {
      so.createWriteNewRecord();
    } else {
      // Use old customer ID and write only changed parameters
      ChangeLog.LogDirtyChanges(so.getSelectorManagerArray(),
				String.valueOf(so.getRecordID()),
				loginID, userID, PereConst.ES);
      so.writeRecord();
    }
  if (!request.getParameter("refresh").equals("y")) {
  session.removeAttribute(PereConst.SHIPMENT_ATTR);
%>
<SCRIPT language="JavaScript">
location.href='<%=retTo+sessionIDsuff%>?customerID=<%=customerID%>&saved=<%=URLEncoder.encode(so.Name.getChoice())%>'
</script>
<%
}
    } // Save parameter
  } // Form is OK

if (sb.length() > 0) {
%>
<font color="red"> Please correct the following errors:</font>
<UL> <%=sb%> </ul>
<%
}
sb = null;
%>
<HTML><HEAD><TITLE>
Shipment Data
</TITLE>
<script language="JavaScript" SRC="jsputils/openWindow.js"></script>
<SCRIPT language="JavaScript">

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>?disFr=findCustomerShipment.jsp");
}

function gonnaShip() {
if (!<%=hasBooks%>) {
alert("You need to put some books in the shipment before you send it.");
return false;
}
var radioChecked = false;
for (i=1; i<document.ShipmentForm.<%=so.ShippedVia.getName()%>.length; i++) {
if (document.ShipmentForm.<%=so.ShippedVia.getName()%>[i].checked) {
radioChecked = true;
break;
}
}
if (radioChecked == false) {
alert("You need to select a shipping carrier first.");
return false;
}
if (document.ShipmentForm.<%=so.TrackingCode.getName()%>.value == "") {
alert("You have not entered a Tracking Code\nPlease enter tracking information.");
return false;
}
  document.ShipmentForm.hitShipped.value = "Y";
  document.ShipmentForm.<%=PereConst.SAVE_PARAM%>.click();
}

function setReceived() {
  document.ShipmentForm.hitReceived.value = "Y";
  document.ShipmentForm.<%=PereConst.SAVE_PARAM%>.click();
}

function fieldCheck() {
if (document.ShipmentForm.<%=so.Name.getName()%>.value == "") {
alert("You must have a Name for this shipment.");
return false;
}
return true;
}

</script>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<BODY>
<center>
<% if (so.getRecordID() == 0) { %>
<h2>Enter New Shipment for <%=customerGreet%></h2>
<% } else { %>
<h2>Shipment &quot;<%=so.Name.getChoiceAsText()%>&quot; for <%=customerGreet%></h2>
<p>Shipment # <%=so.getRecordID()%></p>
<% } %>
<p>Required fields are marked with a <font color=red size="+2">*</font>.</p>

<FORM action="<%=response.encodeURL("ShipmentMaintain.jsp")%>" method=post
onSubmit="return fieldCheck()" name="ShipmentForm">
<input type="hidden" name="retTo" value="<%=retTo%>">
<input type="hidden" name="customerID" value="<%=customerID%>">
<input type="hidden" name="refresh" value="">
<input type=button value="Cancel"
onClick="location.href='<%=retTo%><%=sessionIDsuff%>?customerID=<%=customerID%>'">

<% if (!beenShipped) { %>
<input type=button value="Add Books to Shipment"
onClick="openChildWindowHTML('findAddableBooks.jsp<%=sessionIDsuff%>?customerID=<%=customerID%>&editID=<%=editID%>')">
<%}%>
<input type=button name="getNotes" value="View or Add Notes" onClick="openChildWindowHTML('notes.jsp<%=sessionIDsuff%>?typeID=<%=PereConst.SHIPMENT_NOTE%>&editID=<%=editID%>&name=<%=URLEncoder.encode(so.Name.getChoice())%>');">
<input type=submit name="<%=PereConst.SAVE_PARAM%>" value="Save the Data"> <input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Shipments</h2><p>This screen allows you to enter and edit information about shipments you will be sending to Perennity Publishing.  You need to enter books using the My Books area, and then you can add them to a shipment.  When you are ready to send a shipment, you can enter the tracking number and shipper so we can keep an eye on its progress.  You can also record notes about the shipment, and review notes that others may have added.</p>')">
<table border=1 cellpadding=3 cellspacing=0>
<tr><td align=right>Name: <font color=red size="+2">*</font></td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Name</h2><p>To keep track of which shipment is which, you need to enter a Name describing the contents of the shipment, such as &quot;Complete Works of Shakespeare&quot;.</p>')"></td>
<td><%=so.Name.getHTMLOnly()%></td></tr>
<tr><td align=right>Description: </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Description</h2><p>If the Name is not descriptive enough, you can add a more detailed description of the Shipment here.</p>')"></td><td><%=so.Description.getHTMLOnly(30,4)%></td></tr>

<tr><td align=right>Destination: </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Direction</h2><p>This displays the direction of the shipment: to Perennity offices; to the Perennity processing center; or back.</p>')"></td><td><%=directionString%></td></tr>

<tr><td align=right>Created:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Created</h2><p>This records the login ID of the person who first entered this book, and the time.  It is recorded automatically for you.</p>')"></td>
<td><%=so.Created.getChoiceAsText() + " by " +
so.CreatedBy.getChoiceAsText()%></td></tr>
<%
if (!beenShipped) {
%>
<tr><td align=right><input type=button name="Ship" value="Ship Now" onClick='gonnaShip()'>
<input type=hidden value="" name="hitShipped"></td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Ship Now</h2><p>This allows you to record when and how your shipment was sent, so we can keep track of it in its travels.  Select the shipping company you are using, and enter the tracking code in the space below.</p>')"></td>
<td>
<%=so.ShippedVia.getHTMLOnly()%></td></tr>
<tr><td align=center colspan=3>NOTE: By sending books to Perennity Publishing,<br>you are agreeing to our <a href="javascript:openChildWindowHTML('agreement.html')">Republishing Agreement</a>.</td></tr>
<tr><td align=right>Tracking Code:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Tracking Code</h2><p>It is useful to be able to keep track of packages as they travel, so please enter the tracking code here.</p>')"></td><td><%=so.TrackingCode.getHTMLOnly()%></td></tr>
<%
} else {
%>
<tr><td align=right>Shipped:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Shipped</h2><p>This field shows when the package was shipped, and with whom.</p>')"></td>
<TD><%=so.Shipped.getChoiceAsText() + " by " +
so.ShippedBy.getChoiceAsText() +
" via " +
so.ShippedVia.getChoiceAsText()%></td></tr>
<tr><td align=right>Tracking Code: </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Tracking Code</h2><p>This field records the tracking number under which the package was shipped.</p>')"></td><td><%=so.TrackingCode.getChoiceAsText()%></td></tr>

<tr><td align=right>
<%
if (so.Status.testCharacterOfChoice(ShipmentObject.SHIPMENT_RECEIVED)) {
%>
Received:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Received</h2><p>This field shows that the shipment has been received, as well as the date and person involved.</p>')"></td>
<td><%=so.Received.getChoiceAsText() + " by " +
so.ReceivedBy.getChoiceAsText()%>
<%
} else if (PereOpsPerm) {
%>
<input type=button name="Received" value="Received" onClick="setReceived()">
<input type=hidden value="" name="hitReceived">

</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Received</h2><p>This button allows you to indicate that this shipment was received.  Please make sure that you have selected the right shipment to set as Received!</p>')"></td>
<td>
<%}%>
<%}%>
</td>
</tr>
</table>
<%
if (hasBooks) {
%>
<TABLE border="1" cellspacing="2">
<TR><TH colspan=3><%=tableTitle%></th></tr>
<%=model.makeTableBody()%></table>
<%=tableVerb%>
<%} else {%>
<p align=center>No books have been assigned to this shipment.</p>
<% if (!beenShipped) { %>
<input type=button value="Add Books to Shipment"
onClick="openChildWindowHTML('findAddableBooks.jsp<%=sessionIDsuff%>?customerID=<%=customerID%>&editID=<%=editID%>')">
<%}
}%>
</form>
<%@include file='debugDisplay.inc'%>
</body>
</html>
