<%@ page import="java.util.Enumeration, java.util.Properties"%>
<%-- makeSystemTable.jsp

Generate a table of various information about the current session.
This utility is intended for temporary inclusion in jsp pages while
debugging the session.  This include must be preceded by the table
constants.

It is invoked thus:

makeSystemTable(request)

   Copyright (c) 2001 by Advanced Systems and Software Technologies.  All Rights Reserved

--%>

<%!
StringBuffer makeSystemTable()
{
  StringBuffer sb = new StringBuffer();
  Enumeration enumV;
  String name;
  String value;
  HttpSession session;
  Object obj;
  Properties prop;

  sb.append(table);
  sb.append("<tr><th colspan=2>System getProperties</th></tr>");

  try {
    prop = System.getProperties();
    enumV = prop.propertyNames();
      if (enumV != null) {
	while (enumV.hasMoreElements()) {
	  name = (String)enumV.nextElement();
	  try {
	    obj = System.getProperty(name);
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

  return sb;
}
%>
