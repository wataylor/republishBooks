<%@ page import='java.util.Enumeration,
asst.perennity.PereConst,
asst.debug.DebugUtils'
errorPage='/jsputils/runError.jsp'
%>
<HTML>
<HEAD>
<!-- index.jsp

   Copyright (c) 2001 by Perennity Publishing.
  All Rights Reserved
-->
<%!
String sessionIDsuff;
String anyParam;
String loginID;
%>
<%
sessionIDsuff = ";jsessionid=" + session.getId();

if (request.getParameter("debug") != null) {
session.setAttribute("debug", "Y");
}

loginID = request.getParameter(PereConst.URLID_PARAM);
if ((loginID == null) || (loginID.equals(PereConst.ES))) {
  loginID = (String)session.getAttribute(PereConst.URLID_ATTR);
} else {
  session.setAttribute(PereConst.URLID_ATTR, loginID);
}
if (loginID == null) {
  loginID = PereConst.ES;
}

if ((session.getAttribute(PereConst.REDIRECT_ATTR) == null) &&
    ( (anyParam = request.getParameter("disFr")) != null)) {
  session.setAttribute(PereConst.REDIRECT_ATTR, anyParam);
}
//System.out.println("Index detects forward as " + (String)session.getAttribute(PereConst.REDIRECT_ATTR));
%>
<SCRIPT language="javascript">
var inIndex="true";
var param=location.search;
var sessionIDsuff = "<%=sessionIDsuff%>";

if (self != top) {
repString = "index.jsp" + sessionIDsuff + param;
top.location.replace(repString);
}

var displayFrame="welcome.html";
var JSPforward="<%=session.getAttribute(PereConst.REDIRECT_ATTR)%>";

if (!(param.indexOf("disFr=")==-1)) {
      if (param.indexOf("&", param.indexOf("disFr="))==-1) {
       displayFrame = param.substring((param.indexOf("disFr=")+6), param.length)
       } else {
       displayFrame = param.substring((param.indexOf("disFr=")+6), param.indexOf("&", param.indexOf("disFr=")))
       }
     }

if (JSPforward != "null") {
displayFrame = JSPforward;
}

if (displayFrame.indexOf(".jsp") != -1) {
displayFrame = displayFrame + sessionIDsuff;
}
</SCRIPT>
<%
//System.out.println("Index clearing redirect");
session.removeAttribute(PereConst.REDIRECT_ATTR);
%>

<TITLE>Perennity Publishing - Bringing rare books back to print</TITLE>
   <META NAME="resource-type" CONTENT="document">
   <META NAME="revisit-after" CONTENT="30 days">
   <META NAME="classification" CONTENT="Homepage">
   <META NAME="keywords" CONTENT="Perennity Publishing, book reprinting, book republishing, on-demand printing, old book, classics">
   <META NAME="robots" CONTENT="ALL">
   <META NAME="distribution" CONTENT="Global">
   <META NAME="rating" CONTENT="Safe for Kids">
   <META NAME="copyright" CONTENT="Perennity Publishing">
   <META NAME="language" CONTENT="en-us">

</HEAD>
<SCRIPT language="javascript">
document.write(
'<FRAMESET ROWS="125, 65, *" FRAMEBORDER="0" FRAMESPACING="0" BORDER="0">',

'<FRAME FRAMEBORDER="0" MARGINHEIGHT="0" FRAMESPACING="0" SRC="top.html" NAME=top SCROLLING="no" border="0">',

'<FRAME FRAMEBORDER="0" MARGINHEIGHT="0" FRAMESPACING="0" SRC="nav.jsp<%=sessionIDsuff%>" NAME="nav" SCROLLING="no" border="0">',

'<frame FRAMEBORDER="0" border="0" MARGINHEIGHT="10" marginwidth="20" FRAMESPACING="0" SRC="', displayFrame, '" NAME=display>',

'</FRAMESET>',

'<noframes>',

'<body>',

'<h1>Perennity Publishing</h1>',

'<h2>Bringing Books of the Past into the New Millenium</h2>',

'<p>&quot;The wisest mind is weaker than the palest ink...&quot;</p>',

'<p>Perennity Publishing provides the most accurate, cost-effective way to bring old, out-of-print books back into availability for purchase by the public.</p>',

'<p>Whether you are a library, a publisher, an unpublished author, or a collector, Perennity will help your works see the light of day.</p>',

'<p><a href="what.html">What We Do</a></p>',

'<p><a href="services.html">Republishing Services</a></p>',

'<p><a href="resources.html">Resources</a></p>',

'<p><a href="logIn.jsp<%=sessionIDsuff%>">Customer Services</a></p>',

'<p><a href="new.html">New Customers</a></p>',

'<p><a href="contact.jsp<%=sessionIDsuff%>">Contact Us</a></p>',

'<P><i>If you are seeing this message it means you are using an obsolete browser that does not support frames.  This website does not support browers which are not frames-capable; you can place an order by calling 1-800-991-5260.  You need to download, for free, a more recent version of either <a href=http://www.microsoft.com>Microsoft Internet Explorer</a> or <a href=http://www.netscape.com>Netscape Communicator or Navigator</a>.  This site appears best in Explorer but also works with Netscape.</i></p>',

'</body>',
'</noframes>'
);

</script>
</HTML>
