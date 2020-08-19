<%@ page import="java.util.Enumeration"%>
<%-- makeFormParamTable.jsp

Generate information about all parameters of the form as well as any
cookies which may be available.  This file is intended to be included
in .jsp pages to help debug entry form field processing.  It must be
included after the table constants.  It is invoked thus:

makeFormParamTable(request)

The most common interest is in form parameters, but the request
carries header information as well.  There is another entry which
prints the headers, it is called thus:

makeRequestHeaderTable(request)

   Copyright (c) 2001 by Advanced Systems and Software Technologies.
   All Rights Reserved

--%>

<%!
StringBuffer makeFormParamTable(HttpServletRequest request)
{
  StringBuffer sb = new StringBuffer();
  Enumeration enumV;
  String name;
  String value = null;
  String [] selections;

  sb.append(table);
  sb.append("<tr><th colspan=2>HTTPServletRequest getParameterNames</th></tr>");
  enumV = request.getParameterNames();
  while (enumV.hasMoreElements()) {
    name = (String) enumV.nextElement();
    selections = request.getParameterValues(name); // May be multi-valued
    if (selections == null) {
      value = null;
    } else {
      if (selections.length < 2) {
	value = selections[0];
      } else {
	value = "";
	for (int axi = 0; axi < selections.length; axi++) {
	  value=value+((("").equals(value))?"":",")+selections[axi];
	}
      }
    }
    if (value == null) { value = "null"; }
    if ("".equals(value)) { value = "empty string"; }
    sb.append("<tr><td>" + name + "</td>" + "<td>" + value + "</td></tr>");
  }

  sb.append(tableC);

  Cookie[] aCookies = request.getCookies();
  if ((aCookies != null) && (aCookies.length > 0)) {
    sb.append(table);
    sb.append("<tr><th>Cookie</th><th>Value</th></tr>\n");
    for (int i = 0; i < aCookies.length; i++) {
      sb.append("<tr><td>" + aCookies[i].getName()  + "</td>" +
		"<td>" + aCookies[i].getValue() + "</td></tr>");
    }
    sb.append(tableC);
  } else {
    sb.append("No cookies for this session<BR>");
  }

//    enum = request.getAttributeNames();
//    while (enum.hasMoreElements()) {
//        name = (String) enum.nextElement();
//        value = request.getAttribute(name);
//        if (value == null) { value = "null"; }
//        sb.append("<tr><td>" + name + "</td>" + "<td>" + value + "</td></tr>");
//      }
  return sb;
}
%>
