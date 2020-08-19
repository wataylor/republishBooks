<%@ page import="java.util.Enumeration"%>
<%-- makeServletTables.jsp

Routine to dump information about the servlet environment.  It is
intended for temporary inclusion in jsp programs to help debug the use
of the environment.  It must be included after the table constants.

It is invoked thus:

makeServletTables(this, application)

   Copyright (c) 2001 by Advanced Systems and Software Technologies.  All Rights Reserved

--%>

<%!
private StringBuffer makeServletTables(Servlet servlet,
				       ServletContext context) {
  StringBuffer sb = new StringBuffer();
  ServletConfig config;
//  ServletContext context;
  Enumeration enumV;
  String name;
  String value;
  Object obj;

  config = servlet.getServletConfig();

// "+config.getServletName()+"

  sb.append(table);
  sb.append("<tr><th colspan=2>ServletConfig getInitParameterNames</th></tr>");

  enumV = config.getInitParameterNames();
  while (enumV.hasMoreElements()) {
    name = (String)enumV.nextElement();
    value = config.getInitParameter(name);
    if (value == null) { value = "null"; }
    sb.append("<tr><td>" + name + "</td>" + "<td>" + value + "</td></tr>");
  }
  sb.append(tableC);

  // context = config.getServletContext();

  sb.append(table);
  sb.append("<tr><th colspan=2>ServletContext getInitParameterNames</th></tr>");

  enumV = context.getInitParameterNames();
  while (enumV.hasMoreElements()) {
    name = (String)enumV.nextElement();
    value = context.getInitParameter(name);
    if (value == null) { value = "null"; }
    sb.append("<tr><td>" + name + "</td>" + "<td>" + value + "</td></tr>");
  }
  sb.append(tableC);

  sb.append(table);
  sb.append("<tr><th colspan=2>ServletContext getAttributeNames</th></tr>");
  try {
    enumV = context.getAttributeNames();
    if (enumV != null) {
      sb.append("<tr><td colspan=2>" + enumV.toString() + "</td></tr>");
      while (enumV.hasMoreElements()) {
	name = (String)enumV.nextElement();
	try {
	  obj = context.getAttribute(name);
	  if (obj instanceof String) { value = (String)obj; }
	  else                       { value = obj.toString(); }
	} catch (Exception e) {
	  value = e.toString();
	}
	if (value == null) { value = "null"; }
	sb.append("<tr><td>" + name + "</td>" + "<td>" + value + "</td></tr>");
      }
    }
  } catch (Exception e) {
    sb.append("<tr><td colspan=2>" + e.toString() + "</td></tr>");
  }
  sb.append(tableC);

//  set = context.getResourcePaths();
//  sb.append(set.toString);

  try {
    sb.append("Major version " + context.getMajorVersion() +
	      " Minor version " + context.getMinorVersion() + "<br>\n" +
	      "Server Info " + context.getServerInfo() + "<br>\n");
  } catch (Exception e) {
    sb.append("context exception" + e.toString() + "<br>\n");
  }

  return sb;
}
%>
