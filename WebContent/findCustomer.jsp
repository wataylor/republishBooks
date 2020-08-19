<%@include file='classIncludes.inc'%>
<%@ page import="java.sql.*, asst.dbase.VariableSetModel"%>
<!-- findCustomer.jsp

   Copyright (c) 2002 by Advanced Systems and Software Technologies.
   All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: findCustomer.jsp,v $
   Revision 1.8  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.7  2002/09/28 03:49:44  peren
   Customer service function - switch users

   Revision 1.6  2002/09/26 19:18:22  peren
   Change for the Mac

   Revision 1.5  2002/09/25 08:32:18  peren
   report shipment history for each book

   Revision 1.4  2002/09/22 02:53:02  peren
   added pop-up notes

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
<% sessionIDsuff = ";jsessionid=" + session.getId(); %>
<%!
StringBuffer query;
String where;
String anyParam;
String dbaseLoginID;
int editID;
int i;
String editState;  // Extracted from session property

Statement getRow;
ResultSet results = null;
VariableSetModel model;
%>
<%@include file='jsputils/verifySession.jsp'%>
<% DBProp.PropertyConnection("Perennity"); %>
<%@include file='fieldCustomers.inc'%>
<%@include file='permSettings.inc'%>
<%@include file='userSettings.inc'%>
<%

if (!editOtherPerm && makeNewPerm) {
%>
<jsp:forward page="CustomerMaintain.jsp">
<jsp:param name="state" value="start" />
<jsp:param name="editID" value="0" />
</jsp:forward>
<%
}

if (!editOtherPerm) {
%>
<jsp:forward page="custmenu.jsp" />
<%
}

if (request.getParameter(PereConst.CANCEL_PARAM) != null) {
%>
<jsp:forward page="custmenu.jsp" />
<%
}

// See if returning from a selection
if ( (anyParam = request.getParameter("CID")) != null) {
  session.setAttribute(PereConst.CUSTOMERID_ATTR, anyParam);
  String[] answer = PereUtils.CustomerData(anyParam);
  session.setAttribute(PereConst.CUSTOMERLOGIN_ATTR, answer[0]);
  session.setAttribute(PereConst.CUSTOMERGREET_ATTR, answer[1]);
%>
<jsp:forward page="custmenu.jsp" />
<%
}

// See if told to find a new one.
if ( (anyParam = request.getParameter("new")) != null) {
	  session.setAttribute(PereConst.EDITID_ATTR, "0");
	  session.setAttribute(PereConst.EDIT_STATE_ATTR,
			       PereConst.EDIT_START_STATE);
%>
<jsp:forward page="CustomerMaintain.jsp" />
<%
}

if (request.getParameter(PereConst.FIND_PARAM) != null) {
  String id;
  String name;
  String addr;
  String [] s;

  String loginID = PereConst.ES;

  TwixtTableAndForm.ClearAllFormFields(customerMgrs);

  for (i=0; i<customerMgrs.length; i++) {
    if (customerMgrs[i] != null) { customerMgrs[i].setChoice(request); }
  }

  where  = TwixtTableAndForm.FormToWhereString(customerMgrs);
  if (PereConst.ES.equals(where)) {
    sb.append("<LI>You have not specified any search criteria.  Please enter some data into the form and search again.</li>");
  } else {
    //System.out.println(where);
    query = new StringBuffer("select " +
			     PereConst.ID_COL + ", " +
			     PereConst.NAMEPREFIX_COL + ", " +
			     PereConst.FIRSTNAME_COL + ", MiddleName, " +
			     PereConst.LASTNAME_COL + ", NameSuffix, " +
			     PereConst.ADDRESS1LINE1_COL +
			     ", Address1Line2, Address1line3, " +
			     PereConst.ADDRESS1CITY_COL + ", " +
			     PereConst.ADDRESS1STATE_COL + ", " +
			     PereConst.ADDRESS1COUNTRY_COL + ", " +
			     PereConst.ADDRESS1POSTALCODE_COL + ", " +
	                     PereConst.LOGINID_COL + " from Customers where ");
    }
    query.append(where);
    System.out.println(query);
    getRow  = DataBase.connDB.createStatement();
    try {
      results = getRow.executeQuery(query.toString());
      if (results.next()) {
	id = results.getString(1); // Maybe can edit one user ID.
	name = PereUtils.PersonGreet(2, results);
	addr = PereUtils.BuilAddress(7, results);
	loginID = results.getString(14);
	if (!results.next()) {	// Only one, become it
	  session.setAttribute(PereConst.CUSTOMERID_ATTR, id);
	  String[] answer = PereUtils.CustomerData(id);
	  session.setAttribute(PereConst.CUSTOMERLOGIN_ATTR, answer[0]);
	  session.setAttribute(PereConst.CUSTOMERGREET_ATTR, answer[1]);
%>
<jsp:forward page="custmenu.jsp" />
<%
	} else {
// Have more than one result, build table
	  model = new VariableSetModel();
	  i = 0;
	  s = new String[4];
	  s[i++] = "Login ID";
	  s[i++] = "Name";
	  s[i++] = "Address";
	  s[i++] = "Select";
	  model.setColumnHeadings(s);
	  i = 0;
	  s = new String[4];
	  s[i++] = loginID;
	  s[i++] = name;
	  s[i++] = addr;
	  s[i++] = "<input type=button value=\"Select\" onClick='goEdit(\"" + id + "\")'\">";
	  model.addOneRow(s);
	  do {
	    id = results.getString(1); // Maybe can edit one user ID.
	    name = PereUtils.PersonGreet(2, results);
	    addr = PereUtils.BuilAddress(7, results);
	    loginID = results.getString(14);
	    i = 0;
	    s = new String[4];
	    s[i++] = loginID;
	    s[i++] = name;
	    s[i++] = addr;
	    s[i++] = "<input type=button value=\"Select\" onClick='goEdit(\"" + id + "\")'\">";
	    model.addOneRow(s);
	  } while (results.next());
%>
      <FORM><table border=1 cellpadding=3>
	 <%=model.makeTableBody()%>
      </table></form>
<%
	 model = null;
	}
      } else {
// No matches, gripe.
	sb.append("<LI>Nobody matched your search criteria of " + where + ", please try again.</li>");
      }
    } finally {
      if (results != null) { results.close(); }
      getRow.close();
    }
} else {
  for (i=0; i<customerMgrs.length; i++) {
    if (customerMgrs[i] != null) { customerMgrs[i].setChoice((String)null); }
  }
}

// The error string must be displayed if it is not empty
if ((sb != null) && (sb.length() > 10)) {
%>
<font color="red"> Please correct the following errors:</font>
<UL> <%=sb%> </ul>
<%
}
sb = new StringBuffer();	// Never use it again
%>

<HTML><HEAD><TITLE>
Find People
</TITLE>
<link rel="stylesheet" href="style.css">
<script language="JavaScript">

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>?disFr=findCustomer.jsp");
}
var sessionIDsuff = "<%=sessionIDsuff%>";
function goEdit(id) {
location.href = "findCustomer.jsp" + sessionIDsuff + "?CID=" + id;
}
</script>
</HEAD>
<BODY bgcolor=white>

<h1 align=center>Search For A Person To Edit</h1>

<p>This screen searches for information which matches the search
parameters you set.  <B>ALL</b> parameters you set must match for
anyone to be found.  Spelling MATTERS.</p>

<P>A percent character (%) matches any number of characters.  A city
pattern of New% finds everyone whose city begins with "New" which
includes New York and Newton, for example.</p>

<center>
<form action="<%=response.encodeURL("findCustomer.jsp")%>" method=post
name="AllMemberDataForm">
<input type=button name="<%=PereConst.CANCEL_PARAM%>" value="Cancel"
onClick="document.location.href='custmenu.jsp<%=sessionIDsuff%>'">
<input type=submit name="<%=PereConst.FIND_PARAM%>" value="Find & Switch">
<%
if (makeNewPerm) {
%>
<input type=submit name="new" value="Make New">
<% } %>
<br>

<table border=0 cellpadding=3 cellspacing=0>
<tr><td valign=top>

<table border=1 cellpadding=3 cellspacing=0>
<tr><th valign=top align=center colspan=2>Identity:</th></tr>
<tr><td align=right><%=namePrefix.getPrettyName()%>:</td><td><%=namePrefix.getHTMLOnly()%></td></tr>
<tr><td align=right><%=firstName.getPrettyName()%>:</td><td><%=firstName.getHTMLOnly()%></td></tr>
<tr><td align=right><%=middleName.getPrettyName()%>:</td><td><%=middleName.getHTMLOnly()%></td></tr>
<tr><td align=right><%=lastName.getPrettyName()%>:</td><td><%=lastName.getHTMLOnly()%></td></tr>
<tr><td align=right><%=nameSuffix.getPrettyName()%>:</td><td><%=nameSuffix.getHTMLOnly()%></td></tr>

<tr><td align=right>Login ID:</td><td><%=loginIDField.getHTMLOnly()%></td></tr>

</table>

</td><td valign=top>

<table border=1 cellpadding=3 cellspacing=0>
<tr><th colspan=2>Contact Data:</th></tr>
<tr><td align=right>Address:</td><td><%=a1l1.getHTMLOnly()%></td></tr>
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
loadStates(document.AllMemberDataForm.<%=PereConst.ADDRESS1STATE_COL%>);
var i=0
if ("<%=a1state.getChoice()%>" != "") {
for (i; i<document.AllMemberDataForm.<%=PereConst.ADDRESS1STATE_COL%>.length; i++){
if (document.AllMemberDataForm.<%=PereConst.ADDRESS1STATE_COL%>.options[i].value == "<%=a1state.getChoice()%>") {
document.AllMemberDataForm.<%=PereConst.ADDRESS1STATE_COL%>.options[i].selected = true;
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
loadCountries(document.AllMemberDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>);
var i=0
if ("<%=a1country.getChoice()%>" != "") {
for (i; i<document.AllMemberDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.length; i++){
if (document.AllMemberDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.options[i].value == "<%=a1country.getChoice()%>") {
document.AllMemberDataForm.<%=PereConst.ADDRESS1COUNTRY_COL%>.options[i].selected = true;
break;
}
}
}
</script>

</td></tr>
<tr><td align=right>ZIP/Postal Code</td><td><%=a1postalcode.getHTMLOnly()%></td></tr>

<tr><td align=right><%=emailAddress.getPrettyName()%>:</td><td><%=emailAddress.getHTMLOnly()%></td></tr>

<tr><td align=right><%=workPhone.getPrettyName()%>:</td><td><%=workPhone.getHTMLOnly()%></td></tr>
<tr><td align=right><%=homePhone.getPrettyName()%>:</td><td><%=homePhone.getHTMLOnly()%></td></tr>
<tr><td align=right><%=cellPhone.getPrettyName()%>:</td><td><%=cellPhone.getHTMLOnly()%></td></tr>

</table>

</td></tr>
<tr><td>
&nbsp;
</td><td valign=top>
&nbsp;
</td></tr>
</table>

<input type=submit name="<%=PereConst.FIND_PARAM%>" value="Find & Switch">
</form>
</center>
<%@include file='debugDisplay.inc'%>
</BODY></HTML>
