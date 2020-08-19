<%@include file='classIncludes.inc'%>
<%@ page import="asst.perennity.BookObject, asst.perennity.ShipmentObject, java.net.URLEncoder,
java.sql.*, asst.dbase.ResultSetModel"
%>
<!-- BookMaintain.jsp

Utility to enter and maintain book-specific parameters, enter a
new book into the database, or maintain an existing book.  All
the action takes place in this .jsp program.

   Copyright (c) 2002 by Advanced Systems and Software Technologies.
   All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: BookMaintain.jsp,v $
   Revision 1.10  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.9  2002/09/28 03:49:44  peren
   Customer service function - switch users

   Revision 1.8  2002/09/27 02:36:40  peren
   more mac fixes

   Revision 1.7  2002/09/26 19:18:22  peren
   Change for the Mac

   Revision 1.6  2002/09/25 08:32:17  peren
   report shipment history for each book

   Revision 1.5  2002/09/24 02:30:33  peren
   general cleanup

   Revision 1.4  2002/09/22 02:53:02  peren
   added pop-up notes

   Revision 1.3  2002/09/21 03:11:57  peren
   user interface smoothing

   Revision 1.2  2002/09/20 21:13:31  peren
   close to showing

   Revision 1.1  2002/09/20 02:10:57  peren
   smaller top image, edit and ship books

--%>
<%!
String sessionIDsuff;
String anyParam;
int editID;
ResultSetModel model;
BookObject bo;
int i;
String retTo;
boolean hasNotes;
ResultSet results = null;	// Results of the retrieval
Statement stmt;			// Retrieve the customer record
String s[];
String query;
%>
<% sessionIDsuff = ";jsessionid=" + session.getId(); %>
<%@include file='jsputils/verifySession.jsp'%>
<%@include file='permSettings.inc'%>
<%@include file='userSettings.inc'%>

<% DBProp.PropertyConnection("Perennity");

model  = new ResultSetModel();

if ( (retTo = request.getParameter("retTo")) == null) {
  retTo = "findBook.jsp"; // Default return path
}

// Check to be sure there is a book object in the session and create
// one if there is not.
if ( (bo = (BookObject)session.getAttribute(PereConst.BOOK_ATTR)) == null) {
  bo = new BookObject();
  if ( (anyParam = request.getParameter("editID")) == null) {
    sb.append("<LI>Did not define an edit ID on startup</li>");
  } else {
    editID = SQLUtilities.integerFromString(anyParam);
    bo.setRecordID(editID);
    bo.readRecord();		// Reads or clears the field managers
    bo.CustomerID.setDirtyChoice(request.getParameter("customerID"));
    bo.CreatedBy.setDirtyChoice(loginID);
    session.setAttribute(PereConst.BOOK_ATTR, bo); // Remember for later
  }
} else {			// had a shipment, already running
  bo.Type.setIsInForm(true);    // displayed, ask it to be read.
  bo.readFormValues(request);

  if (( (anyParam = request.getParameter("buttonClicked")) != null) &&
       !PereConst.ES.equals(anyParam))  {

    if (anyParam.equals("copyClear")) {
      bo.Status.setCharacterOfChoice(BookObject.COPYRIGHT_CLEARED, 'Y');
    }

    if (anyParam.equals("scanDone")) {
      bo.Status.setCharacterOfChoice(BookObject.IN_SCANNING, 'Y');
    }

    if (anyParam.equals("proofDone")) {
      bo.Status.setCharacterOfChoice(BookObject.IN_PROOFING, 'Y');
    }

    if (anyParam.equals("ready2Ship")) {
      bo.Status.setCharacterOfChoice(BookObject.READY_TO_SHIP, 'Y');
    }

    if (anyParam.equals("wasPaid")) {
      bo.Status.setCharacterOfChoice(BookObject.BOOK_PAID, 'Y');
    }
  }

  bo.updateStatusChanges(loginID); // Adjust statii
  sb = bo.authenticate(sb);	// Check for errata and/or omissions
  sb = TwixtTableAndForm.gripeNonUniqueValues(bo.getSelectorManagerArray(), PereConst.ID_COL, bo.getRecordID(), sb, "CustomerID="+bo.CustomerID.getChoice());
  if ((sb != null) && (sb.length() <= 0)) {
    if (bo.getRecordID() == 0) {
      bo.createWriteNewRecord();
    } else {
      // Use old customer ID and write only changed parameters
      ChangeLog.LogDirtyChanges(bo.getSelectorManagerArray(),
				String.valueOf(bo.getRecordID()),
				loginID, userID, PereConst.ES);
      bo.writeRecord();
    }
    if (request.getParameter(PereConst.SAVE_PARAM) != null) {
      session.removeAttribute(PereConst.BOOK_ATTR);
%>
<SCRIPT language="JavaScript">
location.replace("<%=retTo+sessionIDsuff%>?customerID=<%=customerID%>&saved=<%=URLEncoder.encode(bo.Name.getChoice())%>");
</script>
<%
    } // Save parameter
  } // Form is OK
} // Already running

// List shipment history for this book if it is not new
if (bo.getRecordID() > 0) {
  query = "select Modified, NewValue from ChangeLog where TableName='Books' and ColumnName='ShipmentID' and RecordID=" + bo.getRecordID();
  System.out.println(query);
  try {
    stmt    = DataBase.connDB.createStatement();
    results = stmt.executeQuery(query);
    if (results.next()) {
      s = new String[4];
      s[0] = "Edit";
      s[1] = "Name";
      s[2] = "Date Assigned";
      s[3] = "Direction";
      model.setColumnHeadings(s);
      do {
	s = new String[4];
	s[0] = "<input type=\"button\" value=\"View\" onClick='goShip(\"" + results.getString(2) + "\")'>";
	s[1] = DataBase.StringFromTableColumn(PereConst.SHIPMENT_TABLE, "Name",
					      results.getInt(2));
	s[2] = SelectorFieldPreload.
	  SQL_DATE_STRING.format(results.getTimestamp(1));
	s[3] = ShipmentObject.DIRECTION_SELECTIONS[SQLUtilities.integerFromString(DataBase.StringFromTableColumn(PereConst.SHIPMENT_TABLE, "Direction", results.getInt(2)))].substring(2);
	model.addOneRow(s);
      } while (results.next());
    } else {
      s = new String[1];
      s[0] = "This book has never been assigned to a shipment";
      model.setColumnHeadings(s);
    }
  } finally {
    if (results != null) { results.close(); results=null; }
    if (stmt    != null) { stmt.close();    stmt=null; }
  }
} else {
  s = new String[1];
  s[0] = "This book has never been assigned to a shipment";
  model.setColumnHeadings(s);
}

bo.PubDate.setAddParam("onKeyDown='return justNums(event,this)' onFocus='this.select()'");

hasNotes = PereUtils.HasNotes(PereConst.BOOK_NOTE,bo.getRecordID());

if ((sb != null) && (sb.length() > 0)) {
%>
<font color="red"> Please correct the following errors:</font>
<UL> <%=sb%> </ul>
<%
}
sb = null;
%>
<HTML><HEAD><TITLE>
Book Data
</TITLE>
<script language="JavaScript" SRC="jsputils/openWindow.js"></script>
<SCRIPT language="JavaScript">

var sessionIDsuff = "<%=sessionIDsuff%>";

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>");
}

function goShip(id) {
  document.location.href = "ShipmentMaintain.jsp<%=sessionIDsuff%>?retTo=findBook.jsp&editID=" + id;
}

function justNums(e, field) {
var charC
if (navigator.appName=="Netscape") {
charC = e.which
} else { charC = e.keyCode;}

if (((charC < 48) || (charC > 57)) && ((charC <96) || (charC > 107)) && (charC != 8) && (charC != 9) && (charC != 13) && (charC != 37) &&
 (charC != 39)) {
alert("Please type only digits into the Publication Date field.\nEnter all four digits, e.g. 1859.");
e.cancelBubble
return false;
}
return true;
}

function fieldCheck() {
if (document.BookForm.<%=bo.Name.getName()%>.value == "") {
alert("You must have a Title for this book.");
return false;
}
document.BookForm.submit();
}

</script>
<link rel="stylesheet" href="style.css">
</head>
<BODY>
<center>
<% if (bo.getRecordID() == 0) { %>
<h2>Enter New Book for <%=customerGreet%></h2>
<% } else { %>
<h2>Book <i><%=bo.Name.getChoiceAsText()%></i> for <%=customerGreet%></h2>
Book # <%=bo.getRecordID()%>
<% } %>
<br>Required fields are marked with a <font color=red size="+2">*</font>.</p>

<FORM action="<%=response.encodeURL("BookMaintain.jsp")%>" method=post
onSubmit="return fieldCheck()" name="BookForm">
<input type="hidden" name="retTo" value="<%=retTo%>">
<input type="hidden" name="customerID" value="<%=customerID%>">
<input type="hidden" name="buttonClicked" value="">

<input type=button value="Cancel" onClick="location.href='<%=retTo%><%=sessionIDsuff%>?customerID=<%=customerID%>'">
<input type=button name="getNotes" value="View or Add Notes" onClick="openChildWindowHTML('notes.jsp<%=sessionIDsuff%>?typeID=<%=PereConst.BOOK_NOTE%>&editID=<%=editID%>&name=<i><%=URLEncoder.encode(bo.Name.getChoice())%></i>');">
<input type=submit name="<%=PereConst.SAVE_PARAM%>" value="Save the Data">
<input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Books</h2><p>This screen allows you to enter and edit information about books you will be submitting to Perennity Publishing for electronic conversion and republishing.  After you have sent us the books, you can watch their progress here, and download the resulting electronic files.  You can also record notes about the book, and review notes that others may have added.</p>')">
<table border=1 cellpadding=3 cellspacing=0>

<tr><td align=right>Title:<font color=red size="+2">*</font> </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Title</h2><p>Enter the book&acute;s title here.</p>')"></td><td><%=bo.Name.getHTMLOnly()%></td></tr>

<tr><td align=right>Author: </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Author</h2><p>Enter the full name of the book&acute;s author here.</p>')"></td><td><%=bo.Author.getHTMLOnly()%></td></tr>

<tr><td align=right>ISBN: </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>ISBN</h2><p>Most modern books have an ISBN number that uniquely identifies them.  This number is usually found on the back cover, often near the UPS code if there is one.  The ISBN number almost always says &quot;ISBN&quot; next to it.  If your book has an ISBN number, enter it here.</p>')"></td><td><%=bo.ISBN.getHTMLOnly()%></td></tr>

<tr><td align=right>Earliest Publication Year: </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Earliest Publication Year</h2><p>Most books state the year of publication on the verso, which is the back side of the title page.  This page talks about the copyrights, publisher, and other similar information that libraries use.</p><p>If a book has several printings, they will usually all be listed.  You are looking for the EARLIEST year listed.  Enter that year here.</p><p>If there is no publication year listed on the verso, title page, back cover, or anywhere else, probably the book is old enough to be out of copyright, but we will examine the book when you send it to make sure.</p>')"></td><td><%=bo.PubDate.getHTMLOnly(6)%></td></tr>

<tr><td align=right>Attributes: </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Attributes</h2><p>There may be various standard options available for book processing that can be individually selected here as desired.  Simply select the options you prefer.</p>')"></td><td><%=bo.Type.getHTMLOnly()%></td></tr>

<tr><td align=right>Description: </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Description</h2><p>This is the place to enter any important descriptive charactertics of the book that might be relevant to us.</p>')"></td><td><%=bo.Description.getHTMLOnly(30,4)%></td></tr>
<tr><td align=right>Special Processing Instructions:<br><a href="javascript:openChildWindowHTML('procrules.html')">Standard Processing Rules</a> </td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Special Processing Instructions</h2><p>Perennity Publishing has <a href=procrules.html>standard processing rules</a> that we follow for books.  If you want your book handled differently, we will be glad to do so, but you have to tell us what to do.  Enter your instructions in this field.</p><p>NOTE: Some special instructions will entail additional charges.  Please contact us for more information if required.</p>')"></td><td><%=bo.Instructions.getHTMLOnly(30,4)%></td></tr>
<tr><td align=right>Created:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Created</h2><p>This field shows when you first began entering this book.</p>')"></td>
<td><%=bo.Created.getChoiceAsText() + " by " +
bo.CreatedBy.getChoiceAsText()%></td></tr>

<%
if (StringSetUtils.TestASetStringMember(bo.Status.getChoice(), BookObject.COPYRIGHT_CLEARED)) {
%>
<tr><td align=right>Copyright Proof:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Copyright Proof</h2><p>For legal reasons, we must request that you demonstrate to us proof that you have the right to produce copies of the book.</p><p>If the book was originally published prior to 1907, it is by definition out of copyright, so no proof is necessary.  This field records our approval of your copyright information.</p>')"></td>
<td><%=bo.CopyClear.getChoiceAsText() + " by " +
bo.CopyClearBy.getChoiceAsText()%></td></tr>
<%
} else if (PereCopyClearPerm) {
%>
<tr><td align=center colspan=3><input type="submit" value="Accept Copyright Proof" onClick="document.BookForm.buttonClicked.value='copyClear'"> <input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Copyright Proof</h2><p>For legal reasons, we must request proof that the customer has the right to produce copies of the book.</p><p>If the book was originally published prior to 1907, it is by definition out of copyright, so no proof is necessary.  This field records our approval of the copyright information.  We cannot go ahead with a scanning project without this.</p>')"></td></tr>
<%
}

if (StringSetUtils.TestASetStringMember(bo.Status.getChoice(), BookObject.IN_SCANNING)) {
%>
<tr><td align=right>Scanned:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Scanned</h2><p>This field shows you that our staff has completed the scanning of your book.</p>')"></td>
<td><%=bo.InScan.getChoiceAsText() + " by " +
bo.InScanBy.getChoiceAsText()%></td></tr>
<%
} else if (PereOpsPerm) {
%>
<tr><td align=center colspan=3><input type="submit" value="Book Scanning Completed" onClick="document.BookForm.buttonClicked.value='scanDone'"> <input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Book Scanning Completed</h2><p>This button should be clicked to record that the scanning of the book has been completed.</p>')"></td></tr>
<%
}

if (StringSetUtils.TestASetStringMember(bo.Status.getChoice(), BookObject.IN_SCANNING)) {

if (StringSetUtils.TestASetStringMember(bo.Status.getChoice(), BookObject.IN_PROOFING)) {
%>
<tr><td align=right>Proofread:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Proofread</h2><p>This field shows you that our staff has completed the proofreading of your book.</p>')"></td>
<td><%=bo.InProof.getChoiceAsText() + " by " +
bo.InProofBy.getChoiceAsText()%></td></tr>
<%
} else if (PereOpsPerm) {
%>
<tr><td align=center colspan=3><input type="submit" value="Book Proofreading Completed" onClick="document.BookForm.buttonClicked.value='proofDone'"> <input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Book Proofreading Completed</h2><p>This button should be clicked to record that the proofreading of the book has been completed.</p>')"></td></tr>
<%
}

if (StringSetUtils.TestASetStringMember(bo.Status.getChoice(), BookObject.IN_PROOFING)) {

if (StringSetUtils.TestASetStringMember(bo.Status.getChoice(), BookObject.READY_TO_SHIP)) {
%>
<tr><td align=right>Processing Completed:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Processing Completed</h2><p>This field shows you that we have finished processing your book, and are ready to send it back to you.  You will also find links to the electronic files we generated, so you can download and use them even before your book has returned to you.</p>')"></td>
<td><%=bo.ClearToShip.getChoiceAsText() + " by " +
bo.ClearToShipBy.getChoiceAsText()%></td></tr>
<%
} else if (PereOpsPerm) {
%>
<tr><td align=center colspan=3><input type="submit" value="Processing Completed" onClick="document.BookForm.buttonClicked.value='ready2Ship'"> <input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Processing Completed</h2><p>This button should be clicked to record that the processing of the book, including all files, has been completed, and the book is now ready to be returned to the customer.</p>')"></td></tr>
<%
}
}
}

if (StringSetUtils.TestASetStringMember(bo.Status.getChoice(), BookObject.BOOK_PAID)) {
%>
<tr><td align=right>Payment Received:</td><td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Payment Received</h2><p>This field indicates that we have received and logged the payment for the book processing.</p>')"></td>
<td><%=bo.Paid.getChoiceAsText() + " by " +
bo.PaidBy.getChoiceAsText()%></td></tr>
<%
} else if (PerePaidPerm) {
%>
<tr><td align=center colspan=3><input type="submit" value="Payment Received" onClick="document.BookForm.buttonClicked.value='wasPaid'"> <input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Payment Received</h2><p>This button should be clicked to record that the payment has been received.  When payment is received, the electronic files will become visible to the customer, and the book may be sent back if required.</p>')"></td></tr>
<%
}%>
</table>

<TABLE border="1" cellspacing="2">
<TR><TH colspan=4>Shipment History</th></tr>
<%=model.makeTableBody()%></table>

</form>
<%
if (hasNotes) {
%>
<SCRIPT language="JavaScript">
document.BookForm.getNotes.click();
</script>
<%
}
%>
</center>
<%@include file='debugDisplay.inc'%>
</body>
</html>
