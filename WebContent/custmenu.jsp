<%@include file='classIncludes.inc'%>
<!-- custmenu.jsp

main menu screen

   Copyright (c) 2002 by Advanced Systems and Software Technologies.
   All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: custmenu.jsp,v $
   Revision 1.12  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.11  2002/09/28 03:49:44  peren
   Customer service function - switch users

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
String who;
%>
<%
sessionIDsuff = ";jsessionid=" + session.getId();
%>
<%@include file='jsputils/verifySession.jsp'%>
<%@include file='permSettings.inc'%>
<%@include file='userSettings.inc'%>
<%
if (userID != customerID) {
  who = customerGreet;
} else {
  who = "My";
}
%>
<HTML><HEAD><TITLE>
Customer Services
</TITLE>
<script language="JavaScript" SRC="jsputils/openWindow.js"></script>
<script language="JavaScript">

var sessionIDsuff = "<%=sessionIDsuff%>";

if (!top.inIndex) {
  top.location.replace("index.jsp<%=sessionIDsuff%>?disFr=custmenu.jsp");
}

function gotoJSP(path, params) {
document.location.href = path + sessionIDsuff + params;
}

</script>
<link rel="stylesheet" href="style.css">
</head>
<BODY>

<h1 align="center">Customer Services for <%=customerGreet%></h1>
<%
if (userID != customerID) {
%>
<h3 align="center">Logged in as <%=userGreet%></h3>
<%}%>
<FORM>
<TABLE align="center">

<tr><td colspan="2" align="center"><a href="servicesinfo.html">What are all these buttons?</a></td></tr>

<tr><td align=right><input type=button value="Edit <%=who%> Customer Information" onClick='gotoJSP("CustomerMaintain.jsp", "?state=start&editID=<%=customerID%>")'></td>
<td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>My Customer Information</h2><p>This button gives you access to your customer data where you can edit your addresses, reset passwords, and so on.  It is important to keep your contact information accurate because that is how we will try to contact you if there are any questions about your books, and where we find the address to send your books back to when they are finished.</p>')"></td></tr>

<tr><td align=right><input type=button value="Edit <%=who%> Shipments" onClick='gotoJSP("findCustomerShipment.jsp", "")'></td>
<td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>My Shipments</h2><p>This button gives you access to a list of your shipments so that you can view an old one or create a new one.  A shipment is a collection of books that you send to us in one package, or that we send back to you in one package.  Once a shipment is sent you can&acute;t edit it anymore, of course, but you can view it and use its information to track it via the carrier&acute;s website.</p>')"></td></tr>

<tr><td align=right><input type=button value="Edit <%=who%> Books" onClick='gotoJSP("findBook.jsp", "")'></td>
<td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>My Book List</h2><p>This button gives you access to the records of books you have entered for processing, and lets you enter new ones.  You can look here to track your books through our scanning process.  Books need to be put into shipments to send them to us, and we will put them into shipments to send back to you.  You can also read and respond to any notes our staff may make on a particular book here.  Most importantly, the electronic files resulting from the book scanning will be put here for you to download.</p>')"></td></tr>

<% if (editOtherPerm) {%>
<tr><td align=right><input type=button value="Switch To Other Customer" onClick='gotoJSP("findCustomer.jsp", "")'></td>
<td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Switch To Other Customer</h2><p>This button gives you access to other customer data where you can edit addresses, reset passwords, change shipment status, change book status, and do other administrative functions.</p>')"></td></tr>
<%}%>

<% if (makeNewPerm) {%>
<tr><td align=right><input type=button value="Create New Customer" onClick='gotoJSP("CustomerMaintain.jsp", "?editID=0&state=start")'></td>
<td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Make New Customer</h2><p>This button lets you enter new customer data such as addresses, passwords, other administrative data.</p>')"></td></tr>
<%}%>

<tr><td align=right><input type=button value="Contact Us" onClick='gotoJSP("contact.jsp", "")'></td>
<td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Contact Us</h2><p>This page provides information to contact Perennity Publishing by mail, e-mail and telephone.</p>')"></td></tr>

<tr><td align=right><input type=button value="Log Out" onClick='gotoJSP("logOut.jsp","")'></td>
<td><input type=button value=" ? " onClick="openHelpWindow('<h2 align=center>Log Out</h2><p>This button takes you to the Log Out screen so that no one else can use your account.</p>')"></td></tr>

</table>
</form>
<%@include file='debugDisplay.inc'%>
</body>
</html>
