<%@include file='classIncludes.inc'%>
<!-- contact.jsp

FormMail form to let users email their comments.  If they are already
logged in, their userids and email addresses are automatically filled
in so all they have to type is the message.

   Copyright (c) 2001 by Perennity Publishing.  All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: contact.jsp,v $
   Revision 1.9  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.8  2002/09/26 20:51:08  peren
   did not send

   Revision 1.7  2002/09/26 19:18:22  peren
   Change for the Mac

   Revision 1.6  2002/09/24 02:30:33  peren
   general cleanup

   Revision 1.5  2002/09/22 02:53:02  peren
   added pop-up notes

   Revision 1.4  2002/09/17 17:01:34  peren
   smaller top frame, new graphics

   Revision 1.3  2002/09/12 14:15:28  peren
   contact repairs

   Revision 1.2  2002/09/11 01:29:03  peren
   contngent

   Revision 1.1  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

--%>
<%!
String anyParam;
String sessionIDsuff;
SelectorManager [] fieldMgrs;
SelectorFieldPreload emailAddress;
String mtbl="Customers";
boolean isLoggedIn;
%>
<%@include file='userSettings.inc'%>
<%
sessionIDsuff = ";jsessionid=" + session.getId();
isLoggedIn = (userID > 0);

if (isLoggedIn) {

DBProp.PropertyConnection("Perennity");

if (fieldMgrs == null) {
fieldMgrs = new SelectorManager[2];
fieldMgrs[0] = (emailAddress = new SelectorFieldPreload("Email_Address", mtbl, PereConst.EMAIL_COL));
}
TwixtTableAndForm.TableToForm(fieldMgrs, "ID", userID);
}
%>
<HTML>
<HEAD>
<TITLE>Contact Perennity Publishing</TITLE>
<link rel="stylesheet" href="style.css">
<script language="JavaScript">
<!--

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>?disFr=contact.jsp");
}

// -->
</script>
</HEAD>
<body>
<center>
<h1>Contact Us</h1>

<p class=bq><b>Perennity Publishing</b></p>
<br>
<p class=bq>41 Ridge Rd.</p>
<p class=bq>New Hampton, NH</p>
<p class=bq>03256</p>
<p class=bq>USA</p>
<br>
<p class=bq>(603) 744-5168</p>
<p class=bq>Fax: (603) 744-5167</p>

<h2>E-Mail</h2>
</center>
<table align=center border=0 cellpadding=0 width=450>
<tr><th colspan=2>You can e-mail us directly at <a href="mailto:contact@perennitypublishing.com">contact@perennitypublishing.com</a> or you can enter your message here.  The more information you include, the better we can help you.<% if (isLoggedIn) { %>  Since you are already logged in, we know who you are, so you don't need to re-enter your contact information.<%}%></th></tr>

<FORM METHOD=POST ACTION="/cgi-bin/formmail.pl" name="contactForm">
<input type=hidden name="recipient" value="contact@perennitypublishing.com">
<input type=hidden name="subject" value="PP Website Contact Message">
<input type=hidden name="redirect" value="/sent.html">

<% if (isLoggedIn) {
%>
<input type=hidden name="loginID" value="<%=loginID%>">
<input type=hidden name="realname" value="<%=userGreet%>">
<input type=hidden name="email" value="<%=emailAddress.getChoice()%>">
<%} else {%>
<input type=hidden name="required" value="email,realname">
<script language="JavaScript" SRC="jsputils/stateList.js"></script>
<tr><td align=right>Your Name:</td>
<td><input type=text name="realname" size="20"><font color=red>*</font></td></tr>
<tr><td align=right>Your E-mail: </td>
<td><input type=text name="email" size="20"><font color=red>*</font></td></tr>
<tr><td align=right>Phone: </td>
<td><input type=text name="phone" size="15"></td></tr>
<tr><td align=right>Company: </td>
<td><input type=text name="company" size="20"></td></tr>
<tr><td align=right>Street Address: </td>
<td><input type=text name="address" size="20"></td></tr>
<tr><td align=right>City: </td>
<td><input type=text name="city" size="15"></td></tr>

<tr><td align=right>State/Province:</td><td>
<SELECT NAME="state">
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
</SELECT>
<script language="JavaScript" SRC="jsputils/stateList.js"></script>
<script language="JavaScript">
loadStates(document.contactForm.state);
</script>
</td></tr>
<tr><td align=right>Country:</td><td>
<SELECT NAME="country">
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
</SELECT>

<script language="JavaScript" SRC="jsputils/countryList.js"></script>
<script language="JavaScript">
loadCountries(document.contactForm.country);
if (document.contactForm.country.options[0].selected) {
document.contactForm.country.options[1].selected = true;
}
</script>
</td></tr>
<tr><td align=right>ZIP/Postal Code: </td><td><input type=text name="zip" size="10"></td></tr>
<%}%>
<tr><td colspan=2 align=center>
<p>Your Message:<BR>
<TEXTAREA COLS="40" ROWS="6" NAME="comments"></TEXTAREA>
</p>
<INPUT TYPE="reset" VALUE="Blank Form"> <input type=submit value="Send Message!" name=submit>
</td></tr>
</table>
</form>

<p align=center>Technical difficulties?  Tell the <A HREF="mailto:webmaster@perennitypublishing.com">Webmaster</a>.</p>

<%
if (session.getAttribute("debug") != null) {
%>
<%= DebugUtils.makeFormParamTable(request) %>
<%= DebugUtils.makeSessionTable(request) %>
<%}%>
</body>
</html>
