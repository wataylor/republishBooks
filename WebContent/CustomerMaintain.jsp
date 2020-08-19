<%@include file='classIncludes.inc'%>
<!-- CustomerMaintain.jsp

Utility to validate all user-specific parameters, enter a new person
into the database, or maintain an existing person.  All the action
takes place in this .jsp program.  This program puts up ALL data which
is somewhat intimidating to newbies; it is intended for maintenance
staff who desire to see all the data at once.

   Copyright (c) 2002 by Advanced Systems and Software Technologies.
   All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: CustomerMaintain.jsp,v $
   Revision 1.10  2002/10/02 03:08:18  peren
   Add more fields to customers

   Revision 1.9  2002/10/01 01:52:57  peren
   Respond to Raj suggestions

   Revision 1.8  2002/09/29 04:05:27  peren
   JavaScript looked for newsletter

   Revision 1.7  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.6  2002/09/26 19:18:22  peren
   Change for the Mac

   Revision 1.5  2002/09/22 02:53:02  peren
   added pop-up notes

   Revision 1.4  2002/09/17 17:01:34  peren
   smaller top frame, new graphics

   Revision 1.3  2002/09/11 01:29:03  peren
   contngent

   Revision 1.2  2002/09/07 00:10:15  peren
   type

   Revision 1.1  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

--%>
<%!
String sessionIDsuff;
%>
<% sessionIDsuff = ";jsessionid=" + session.getId(); %>
<%@include file='jsputils/verifySession.jsp'%>
<%@include file='userSettings.inc'%>

<%!
String anyParam;
int editID;
int i;
String editState;  // Extracted from session property
%>

<%@include file='permSettings.inc'%>
<% DBProp.PropertyConnection("Perennity"); %>
<%@include file='fieldCustomers.inc'%>
<%

// Find out the numerical ID of the row which is being edited
if ( (anyParam = request.getParameter("editID")) != null) {
  session.setAttribute(PereConst.EDITID_ATTR, anyParam);
}
editID = SQLUtilities.integerFromString((String)session.getAttribute(PereConst.EDITID_ATTR));

// Check to see what permissions this user has with respect to editing
if (editID == userID) {		// Customer may not edit own permissions
  editPermPerm = false;
  editTypePerm = false;
}

// Find out the current editor state.  The initial state may be
// specified by a form parameter and is stored in the session
// thereafter.

if ( (editState = request.getParameter("state")) == null) {
  editState = (String)session.getAttribute(PereConst.EDIT_STATE_ATTR);
} else {
  session.setAttribute(PereConst.EDIT_STATE_ATTR, editState);
}

// If running, read values from the form, check for errors, write
// form back to database if OK, delete all editor states

if (PereConst.EDIT_STEADY_STATE.equals(editState)) {
  if (request.getParameter(PereConst.SAVE_PARAM) != null) {
    if (editID <= 0) {
      TwixtTableAndForm.ClearAllFormFields(customerMgrs);
    } else {
      TwixtTableAndForm.TableToForm(customerMgrs, "ID", editID);
    }

    custCategorySet.setIsInForm(editTypePerm);
    permissions.setIsInForm(editPermPerm);
    custStatus.setIsInForm(editStatusPerm);

    for (i=0; i<customerMgrs.length; i++) {
      if (customerMgrs[i] != null) { customerMgrs[i].setChoice(request); }
    }

    sb = PereUtils.AuthenticateCustomerData(customerMgrs, sb);
    sb = TwixtTableAndForm.gripeNonUniqueValues(customerMgrs,PereConst.ID_COL,editID, sb, null);

    if (!((sb != null) && (sb.length() > 10))) {
// Form is OK, will save it, usr asked for a save
      if (editID == 0) {
	// Get a new customer ID to create an entire new row
	editID = DataBase.nextIDForTable(ctbl, null, ctbl, null);
	TwixtTableAndForm.AllFormToTable(customerMgrs, PereConst.ID_COL, editID);
	SQLUtilities.AnyStatement("update Customers set Created=null where ID=" +
			          editID);	// Set creation time
      } else {
        // Use old customer ID and write only changed parameters
	ChangeLog.LogDirtyChanges(customerMgrs, String.valueOf(editID),
				  (String)session.getAttribute(PereConst.USERID_ATTR),
				  userID, PereConst.ES);
	TwixtTableAndForm.FormToTable(customerMgrs, PereConst.ID_COL, editID);
      }

// Blow out of the editor by clearing editor attributes
      session.removeAttribute(PereConst.EDIT_STATE_ATTR);

%> <jsp:forward page="custmenu.jsp" /> <%

    } // No errors in buffer
  } // Save param found
} // Steady state

if (PereConst.EDIT_START_STATE.equals(editState)) {
  if (editID <= 0) {
    TwixtTableAndForm.ClearAllFormFields(customerMgrs);
  } else {
    if (!TwixtTableAndForm.TableToForm(customerMgrs, "ID", editID)) {
      sb.append("<LI>Cannot read data for customer " + editID + "</li>");
    }
    password2.setChoice(password.getChoice());
  }
// Have initialized the form, switch to steady state
  session.setAttribute(PereConst.EDIT_STATE_ATTR, PereConst.EDIT_STEADY_STATE);
}

// The error string must be displayed if it is not empty
if (sb.length() > 0) {
%>
<font color="red"> Please correct the following errors:</font>
<UL> <%=sb%> </ul>
<%
}
sb = null;
%>

<HTML><HEAD><TITLE>
Customer Data
</TITLE>
<script language="JavaScript" SRC="jsputils/emailAddressCheck.js"></script>
<script language="JavaScript">

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>?disFr=findCustomer.jsp");
}

     NS6 = (document.getElementById && !document.all) ? true : false;

function fieldCheck() {

var somethingBad = "false";
var badString = "The following fields were missing or invalid:";

if (document.AllCustomerDataForm.Password.value != document.AllCustomerDataForm.Password2.value) {
alert("Your two password fields do not contain the same password.\nPlease make them the same so we can be sure they are right.")
return false;
}

if ((document.AllCustomerDataForm.Email_Address.value != "") && !emailCheck(document.AllCustomerDataForm.Email_Address.value)) {
return false;
}
var lid = document.AllCustomerDataForm.Login_ID.value;
var oneChar;
for (i=0; i<lid.length; i++) {
oneC = lid.charCodeAt(i);
if (!(((oneC>=97)&&(oneC<=122)) || ((oneC>=65)&&(oneC<=90)) || ((oneC>=48)&&(oneC<=57)) || (oneC==45))) {
alert(lid.charAt(i) + " is an illegal character.\nPlease use only letters and numbers in your Login ID.");
return false;
   }
}
<%--
if (document.AllCustomerDataForm.Salutation.selectedIndex==0) {
badString = badString + "\n\t-- Salutation";
somethingBad = true;
}
--%>
if (document.AllCustomerDataForm.First_Name.value=="") {
badString = badString + "\n\t-- First Name";
somethingBad = true;
}

if (document.AllCustomerDataForm.Last_Name.value=="") {
badString = badString + "\n\t-- Last Name";
somethingBad = true;
}

if (document.AllCustomerDataForm.Login_ID.value=="") {
badString = badString + "\n\t-- Login ID";
somethingBad = true;
}

if (document.AllCustomerDataForm.Password.value=="") {
badString = badString + "\n\t-- Password";
somethingBad = true;
}
<%--
if (document.AllCustomerDataForm.<%=PereConst.ADDRESS1LINE1_COL%>.value=="") {
badString = badString + "\n\t-- Mailing Address";
somethingBad = true;
}

if (document.AllCustomerDataForm.<%=PereConst.ADDRESS1CITY_COL%>.value=="") {
badString = badString + "\n\t-- City";
somethingBad = true;
}

if (!NS6) {
if ((document.AllCustomerDataForm.<%=PereConst.ADDRESS1STATE_COL%>.selectedIndex==0 || document.AllCustomerDataForm.<%=PereConst.ADDRESS1STATE_COL%>.value=="") && (document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.selectedIndex==1 || document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.selectedIndex==2 || document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.selectedIndex==0)) {
badString = badString + "\n\t-- State or Province";
somethingBad = true;
}

if (document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.selectedIndex==0) {
badString = badString + "\n\t-- Country";
somethingBad = true;
}
}

if (document.AllCustomerDataForm.<%=PereConst.ADDRESS1POSTALCODE_COL%>.value=="") {
badString = badString + "\n\t-- Zip/Postal Code";
somethingBad = true;
}
--%>
if (somethingBad==true) {
badString = badString + "\nPlease enter the correct data in\nthese fields, then try again.";

alert(badString);
return false;
} else {
return true; }
}

</script>
<link rel="stylesheet" href="style.css">
</HEAD>
<BODY>

<center>
<% if (editID == 0) { %>
<h2>Enter New Customer</h2>
<% } else { %>
<h2>Update Customer Number <%=editID%></h2>
<% } %>
Required fields are marked with a <font color=red size="+2">*</font>.</p>

<FORM action="<%=response.encodeURL("CustomerMaintain.jsp")%>" method=post
onSubmit="return fieldCheck()" name="AllCustomerDataForm">

<input type=button value="Cancel" onClick="location.href='custmenu.jsp<%=sessionIDsuff%>'">
<input type=submit name="<%=PereConst.SAVE_PARAM%>" value="Save the Data">
<table border=1 cellpadding=3 cellspacing=0>
<tr><td valign=top>

<table border=1 cellpadding=3 cellspacing=0>
<tr><th valign=top align=center colspan=2>Required Information:</th></tr>
<tr><td align=right><%=namePrefix.getPrettyName()%>:</td><td><%=namePrefix.getHTMLOnly()%></td></tr>
<tr><td align=right><%=firstName.getPrettyName()%>:<font color=red size="+2">*</font></td><td><%=firstName.getHTMLOnly()%></td></tr>
<tr><td align=right><%=middleName.getPrettyName()%>:</td><td><%=middleName.getHTMLOnly()%></td></tr>
<tr><td align=right><%=lastName.getPrettyName()%>:<font color=red size="+2">*</font></td><td><%=lastName.getHTMLOnly()%></td></tr>
<tr><td align=right>Suffix:</td><td><%=nameSuffix.getHTMLOnly()%></td></tr>
<tr><td align=right><%=company.getPrettyName()%>:</td><td><%=company.getHTMLOnly()%></td></tr>
<tr><td align=right><%=emailAddress.getPrettyName()%>:</td><td><%=emailAddress.getHTMLOnly()%></td></tr>
<tr><td align=right>Desired Login ID:<font color=red size="+2">*</font></td><td><%=loginIDField.getHTMLOnly()%></td></tr>
<tr><td align=right>Desired Password:<font color=red size="+2">*</font></td><td><%=password.getHTMLOnly()%></td></tr>
<tr><td align=right>Repeat the Password:<font color=red size="+2">*</font></td><td><%=password2.getHTMLOnly()%></td></tr>
<tr><td align=right>Password Hint:</td><td><%=passwordHint.getHTMLOnly()%></td></tr>
</table>

</td><td valign=top>

<table border=1 cellpadding=3 cellspacing=0>
<tr><th colspan=2>Mailing Address:</th></tr>
<tr><td align=right></td><td><%=a1l1.getHTMLOnly()%></td></tr>
<tr><td align=right></td><td><%=a1l2.getHTMLOnly()%></td></tr>
<tr><td align=right></td><td><%=a1l3.getHTMLOnly()%></td></tr>
<tr><td align=right>City:</td><td><%=a1city.getHTMLOnly()%></td></tr>
<tr><td align=right>State/Province:</td><td>
<SELECT NAME="<%=PereConst.ADDRESS1STATE_COL%>">
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
</SELECT>
<script language="JavaScript" SRC="jsputils/stateList.js"></script>

<script language="JavaScript">
loadStates(document.AllCustomerDataForm.<%=PereConst.ADDRESS1STATE_COL%>);
var i=0
if ("<%=a1state.getChoice()%>" != "") {
for (i; i<document.AllCustomerDataForm.<%=PereConst.ADDRESS1STATE_COL%>.length; i++){
if (document.AllCustomerDataForm.<%=PereConst.ADDRESS1STATE_COL%>.options[i].value == "<%=a1state.getChoice()%>") {
document.AllCustomerDataForm.<%=PereConst.ADDRESS1STATE_COL%>.options[i].selected = true;
break;
}
}
}
</script>

</td></tr>
<tr><td align=right>Country:</td><td>
<SELECT NAME="<%=PereConst.ADDRESS1COUNTRY_COL%>">
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
</SELECT>

<script language="JavaScript" SRC="jsputils/countryList.js"></script>

<script language="JavaScript">
loadCountries(document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>);
if (document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.options[0].selected) {
document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.options[1].selected = true;
}
var i=0
if ("<%=a1country.getChoice()%>" != "") {
for (i; i<document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.length; i++){
if (document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.options[i].value == "<%=a1country.getChoice()%>") {
document.AllCustomerDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.options[i].selected = true;
break;
}
}
}
</script>

</td></tr>
<tr><td align=right>ZIP/Postal Code</td>
<td><%=a1postalcode.getHTMLOnly()%></td></tr>

<% if (editTypePerm) { %><TR><TD colspan="2">
<%=custCategorySet.getHTML()%></td></tr>
<% } %>

<% if (editStatusPerm) { %><TR><TD colspan="2">
<%=custStatus.getHTML()%></td></tr>
<% } %>

<!--
<tr><th colspan=2>How we pay you:</th></tr>
<tr><td align=right>Name on Check</td>
<td><%=checkName.getHTMLOnly()%></td></tr>
<tr><td align=right>Taxpayer Name for Check</td>
<td><%=businessName.getHTMLOnly()%></td></tr>
-->
</table>

</td></tr><tr><td valign=top>

<table border=1 cellpadding=3 cellspacing=0>
<tr><th colspan=2>Shipping address if it&acute;s different from Mailing:</th></tr>
<tr><td align=right></td><td><%=a2l1.getHTMLOnly()%></td></tr>
<tr><td align=right></td><td><%=a2l2.getHTMLOnly()%></td></tr>
<tr><td align=right></td><td><%=a2l3.getHTMLOnly()%></td></tr>
<tr><td align=right>City: </td><td><%=a2city.getHTMLOnly()%></td></tr>
<tr><td align=right>State/Province: </td><td>
<SELECT NAME="<%=PereConst.ADDRESS2STATE_COL%>">
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
</SELECT>

<script language="JavaScript">
loadStates(document.AllCustomerDataForm.<%=PereConst.ADDRESS2STATE_COL%>);
var i=0
if ("<%=a2state.getChoice()%>" != "") {
for (i; i<document.AllCustomerDataForm.<%=PereConst.ADDRESS2STATE_COL%>.length; i++){
if (document.AllCustomerDataForm.<%=PereConst.ADDRESS2STATE_COL%>.options[i].value == "<%=a2state.getChoice()%>") {
document.AllCustomerDataForm.<%=PereConst.ADDRESS2STATE_COL%>.options[i].selected = true;
break;
}
}
}
</script>

</td></tr>
<tr><td align=right>Country: </td><td>
<SELECT NAME="<%=PereConst.ADDRESS2COUNTRY_COL%>">
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
</SELECT>

<script language="JavaScript">
loadCountries(document.AllCustomerDataForm.<%=PereConst.ADDRESS2COUNTRY_COL%>);
var i=0
if ("<%=a2country.getChoice()%>" != "") {
for (i; i<document.AllCustomerDataForm.<%=PereConst.ADDRESS2COUNTRY_COL%>.length; i++){
if (document.AllCustomerDataForm.<%=PereConst.ADDRESS2COUNTRY_COL%>.options[i].value == "<%=a2country.getChoice()%>") {
document.AllCustomerDataForm.<%=PereConst.ADDRESS2COUNTRY_COL%>.options[i].selected = true;
break;
}
}
} else {
document.AllCustomerDataForm.<%=PereConst.ADDRESS2COUNTRY_COL%>.options[0].selected = true;
}
</script>

</td></tr>
<tr><td align=right>ZIP/Postal Code</td><td><%=a2postalcode.getHTMLOnly()%></td></tr>
<tr><th colspan=2>Billing address if it&acute;s different from Mailing:</th></tr>
<tr><td align=right></td><td><%=a3l1.getHTMLOnly()%></td></tr>
<tr><td align=right></td><td><%=a3l2.getHTMLOnly()%></td></tr>
<tr><td align=right></td><td><%=a3l3.getHTMLOnly()%></td></tr>
<tr><td align=right>City: </td><td><%=a3city.getHTMLOnly()%></td></tr>
<tr><td align=right>State/Province: </td><td>
<SELECT NAME="<%=PereConst.ADDRESS3STATE_COL%>">
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
</SELECT>

<script language="JavaScript">
loadStates(document.AllCustomerDataForm.<%=PereConst.ADDRESS3STATE_COL%>);
var i=0
if ("<%=a3state.getChoice()%>" != "") {
for (i; i<document.AllCustomerDataForm.<%=PereConst.ADDRESS3STATE_COL%>.length; i++){
if (document.AllCustomerDataForm.<%=PereConst.ADDRESS3STATE_COL%>.options[i].value == "<%=a3state.getChoice()%>") {
document.AllCustomerDataForm.<%=PereConst.ADDRESS3STATE_COL%>.options[i].selected = true;
break;
}
}
}
</script>

</td></tr>
<tr><td align=right>Country: </td><td>
<SELECT NAME="<%=PereConst.ADDRESS3COUNTRY_COL%>">
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
</SELECT>

<script language="JavaScript">
loadCountries(document.AllCustomerDataForm.<%=PereConst.ADDRESS3COUNTRY_COL%>);
var i=0
if ("<%=a3country.getChoice()%>" != "") {
for (i; i<document.AllCustomerDataForm.<%=PereConst.ADDRESS3COUNTRY_COL%>.length; i++){
if (document.AllCustomerDataForm.<%=PereConst.ADDRESS3COUNTRY_COL%>.options[i].value == "<%=a3country.getChoice()%>") {
document.AllCustomerDataForm.<%=PereConst.ADDRESS3COUNTRY_COL%>.options[i].selected = true;
break;
}
}
} else {
document.AllCustomerDataForm.<%=PereConst.ADDRESS3COUNTRY_COL%>.options[0].selected = true;
}
</script>

</td></tr>
<tr><td align=right>ZIP/Postal Code</td><td><%=a3postalcode.getHTMLOnly()%></td></tr>
</table>

</td><td valign=top>

<table border=1 cellpadding=3 cellspacing=0>
<tr><th colspan=2>Contact Information:</th></tr>
<tr><td align=right>Home Phone: </td><td><%=homePhone.getHTMLOnly()%></td></tr>
<tr><td align=right>Work Phone: </td><td><%=workPhone.getHTMLOnly()%></td></tr>
<tr><td align=right>Cell Phone: </td><td><%=cellPhone.getHTMLOnly()%></td></tr>
<tr><td align=right>Fax: </td><td><%=faxPhone.getHTMLOnly()%></td></tr>

<% if (editPermPerm) { %><TR><TD colspan="2">
<%=permissions.getHTML()%></td></tr>
<% } %>

</table>
</td></tr>
</table>
<input type=button value="Cancel" onClick="location.href='custmenu.jsp<%=sessionIDsuff%>'">
<input type=submit name="<%=PereConst.SAVE_PARAM%>" value="Save the Data">
</form>
</center>
<%@include file='debugDisplay.inc'%>
</BODY>
</HTML>
