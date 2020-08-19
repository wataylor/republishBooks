<%@ page import="java.util.Enumeration"%>
<%-- makeSessionTable.jsp

Generate a table of various information about the current session.
This utility is intended for temporary inclusion in jsp pages while
debugging the session.  This include must be preceded by the table
constants.

It is invoked thus:

makeSessionTable(request)

   Copyright (c) 2001 by Advanced Systems and Software Technologies.  All Rights Reserved

   Under revision by: $Locker:  $
   Change Log:
   $Log: makeSessionTable.jsp,v $
   Revision 1.1.1.1  2002/04/11 04:30:00  zonediet
   first import


--%>

<%!
StringBuffer makeSessionTable(HttpServletRequest request)
{
  StringBuffer sb = new StringBuffer();
  Enumeration enumV;
  String name;
  String value;
  HttpSession session;
  Object obj;

  sb.append(table);
  sb.append("<tr><th colspan=2>HTTPSession getAttributeNames</th></tr>");

  try {
    session = request.getSession();
    enumV = session.getAttributeNames();
    if (enumV != null) {
      sb.append("<tr><td colspan=2>" + enumV.toString() + "</td></tr>");
      while (enumV.hasMoreElements()) {
	name = (String)enumV.nextElement();
	try {
	  obj = session.getAttribute(name);
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

  try {
    session = request.getSession();
    sb.append("Id " + session.getId() + " New " + session.isNew() +
	      " Timeout " + session.getMaxInactiveInterval() +
	"<br>Created " +
    java.text.DateFormat.getInstance().format(new java.util.Date(session.getCreationTime())) +
    " Displayed " +
    java.text.DateFormat.getInstance().format(new java.util.Date()) +
 "<br>\n");
  } catch (Exception e) {
    sb.append("session exception" + e.toString() + "<br>\n");
  }

  return sb;
}
%>
