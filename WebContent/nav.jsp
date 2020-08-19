<%@ page import='java.util.Enumeration,
asst.perennity.PereConst,
asst.dbase.DBProp,
asst.debug.DebugUtils'
errorPage='/jsputils/runError.jsp'
%>
<HTML>
<HEAD>
<TITLE>Perennity Publishing nav buttons</TITLE>
<!-- nav.jsp

   Copyright (c) 2001 by Perennity Publishing.
  All Rights Reserved
--><%--
   Under revision by: $Locker:  $
   Change Log:
   $Log: nav.jsp,v $
   Revision 1.11  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.10  2002/09/26 19:18:22  peren
   Change for the Mac

   Revision 1.9  2002/09/24 02:30:33  peren
   general cleanup

   Revision 1.8  2002/09/22 02:53:02  peren
   added pop-up notes

   Revision 1.7  2002/09/20 21:48:57  peren
   cleanup

   Revision 1.6  2002/09/20 21:13:31  peren
   close to showing

   Revision 1.5  2002/09/20 02:10:57  peren
   smaller top image, edit and ship books

   Revision 1.4  2002/09/17 17:01:34  peren
   smaller top frame, new graphics

   Revision 1.3  2002/09/11 01:29:03  peren
   contngent

   Revision 1.2  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

   Revision 1.1  2002/09/02 20:00:03  peren
   first graphics

--%>
<%!
boolean isLoggedIn;
String sessionIDsuff;
String memberGreet;
String anyParam;
%>
<%
memberGreet = (String)session.getAttribute(PereConst.USERGREET_ATTR);
sessionIDsuff = ";jsessionid=" + session.getId();
if ((memberGreet != null) && !PereConst.ES.equals(memberGreet)) {
isLoggedIn = true;
} else {
isLoggedIn = false;
}
%>
<SCRIPT LANGUAGE="JavaScript">
<!--

var sessionID = "<%=session.getId()%>";
var sessionIDsuff = ";jsessionid=" + sessionID;

var isLoggedIn = <%=isLoggedIn%>;

function gotoJSP(path, params) {
parent.display.location.href = path + sessionIDsuff + params;
}

Image1= new Image
Image1.src = "images/home2.jpg"

Image2= new Image
Image2.src = "images/wwd2.jpg"

Image3= new Image
Image3.src = "images/repser2.jpg"

Image4= new Image
Image4.src = "images/res2.jpg"

Image5= new Image
Image5.src = "images/custser2.jpg"

Image6= new Image
Image6.src = "images/newcus2.jpg"

Image7= new Image
Image7.src = "images/contact2.jpg"

// -->
</SCRIPT>
</HEAD>
<BODY bgcolor="#FAF0B2">
<table border=0 height=65 align=left cellpadding=0 cellspacing=0>
<tr><td align=left><img src="images/pplogo.jpg" WIDTH=267 HEIGHT=65 ALT="[Perennity Publishing logo]"></td>
<td valign=center align=center><a href="javascript:top.location.href='index.jsp'+sessionIDsuff" target="_top" onMouseOver="document.pic1.src=Image1.src" onMouseOut="document.pic1.src='images/home1.jpg'"><img src="images/home1.jpg" WIDTH=45 HEIGHT=65 ALT="[Home]" border=0 name="pic1"></a></td>
<td valign=center align=center><a href="what.html" target="display" onMouseOver="document.pic2.src=Image2.src" onMouseOut="document.pic2.src='images/wwd1.jpg'"><img src="images/wwd1.jpg" WIDTH=50 HEIGHT=65 ALT="[What We Do]" border=0 name="pic2"></a></td>
<td valign=center align=center><a href="services.html" target="display" onMouseOver="document.pic3.src=Image3.src" onMouseOut="document.pic3.src='images/repser1.jpg'"><img src="images/repser1.jpg" WIDTH=85 HEIGHT=65 ALT="[Republishing Services]" border=0 name="pic3"></a></td>
<td valign=center align=center><a href="resources.html" target="display" onMouseOver="document.pic4.src=Image4.src" onMouseOut="document.pic4.src='images/res1.jpg'"><img src="images/res1.jpg" WIDTH=70 HEIGHT=65 ALT="[Resources]" border=0 name="pic4"></a></td>
<td valign=center align=center><a href="javascript:gotoJSP('logIn.jsp','')" onMouseOver="document.pic5.src=Image5.src" onMouseOut="document.pic5.src='images/custser1.jpg'"><img src="images/custser1.jpg" WIDTH=67 HEIGHT=65 ALT="[Customer Services]" border=0 name="pic5"></a></td>
<td valign=center align=center><a href="new.html" target="display" onMouseOver="document.pic6.src=Image6.src" onMouseOut="document.pic6.src='images/newcus1.jpg'"><img src="images/newcus1.jpg" WIDTH=75 HEIGHT=65 ALT="[New Customers]" border=0 name="pic6"></a></td>
<td valign=center align=center><a href="javascript:gotoJSP('contact.jsp','')" onMouseOver="document.pic7.src=Image7.src" onMouseOut="document.pic7.src='images/contact1.jpg'"><img src="images/contact1.jpg" WIDTH=60 HEIGHT=65 ALT="[Contact Us]" border=0 name="pic7"></a></td>
</tr>
</table>
</BODY>
</HTML>
