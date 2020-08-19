<%@ page import="java.util.Enumeration"%>
<%-- makeRequestHeaderTable.jsp

Generate information about request headers.  This file is intended to
be included in .jsp pages to help debug header processing.  It must be
included after the table constants.  It is invoked thus:

makeRequestHeaderTable(request)

   Copyright (c) 2001 by Advanced Systems and Software Technologies.  All Rights Reserved

--%>

<%!

StringBuffer makeRequestHeaderTable(HttpServletRequest request)
{
  StringBuffer sb = new StringBuffer();
  Enumeration enumV;
  String name;
  String value;

  sb.append(table);
  sb.append("<tr><th colspan=2>HTTPServletRequest getHeaderNames</th></tr>\n");
  enumV = request.getHeaderNames();
  while (enumV.hasMoreElements()) {
    name = (String) enumV.nextElement();
    value = request.getHeader(name);
    if (value == null) { value = "null"; }
    sb.append("<tr><td>" + name + "</td><td>" + value + "</td></tr>");
  }

  sb.append("<tr><th>Method</th><th>Result</th></tr>");
  sb.append("<tr><td>getAuthType()</td><td>" +
	    request.getAuthType() + "</td></tr>");
  sb.append("<tr><td>getContentLength()</td><td>" +
	    request.getContentLength() + "</td></tr>");
  sb.append("<tr><td>getContentType()</td><td>" +
	    request.getContentType() + "</td></tr>");
  sb.append("<tr><td>getCharacterEncoding()</td><td>" +
	    request.getCharacterEncoding() + "</td></tr>");
  sb.append("<tr><td>getPathTranslated()</td><td>" +
	    request.getPathTranslated() + "</td></tr>");
  sb.append("<tr><td>getPathInfo()</td><td>" +
	    request.getPathInfo() + "</td></tr>");
  sb.append("<tr><td>getQueryString()</td><td>" +
	    request.getQueryString() + "</td></tr>");
  sb.append("<tr><td>getRemoteAddr()</td><td>" +
	    request.getRemoteAddr() + "</td></tr>");
  sb.append("<tr><td>getRemoteHost()</td><td>" +
	    request.getRemoteHost() + "</td></tr>");
  sb.append("<tr><td>getRemoteUser()</td><td>" +
	    request.getRemoteUser() + "</td></tr>");
  sb.append("<tr><td>getMethod()</td><td>"+request.getMethod()+"</td></tr>");
  sb.append("<tr><td>getRequestURI()</td><td>" +
	    request.getRequestURI() + "</td></tr>");
  sb.append("<tr><td>getServerName()</td><td>" +
	    request.getServerName() + "</td></tr>");
  sb.append("<tr><td>getServerPort()</td><td>" +
	    request.getServerPort() + "</td></tr>");
  sb.append("<tr><td>getProtocol()</td><td>" +
	    request.getProtocol() + "</td></tr>");

  sb.append(tableC);
  return sb;
}
%>
