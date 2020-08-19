<!-- debugDisplay.inc

Code to display all parameters of the page, used for debugging, can be
turned on and off via a session parameter which is set by the first screen
in the series.  Requires that asst.debug.DebugUtils be included in the
calling page.

    Copyright (c) 2002 by Advanced Systems and Software Technologies.
    All Rights Reserved
--><%--
    Under revision by: $Locker:  $<br>
    Change Log:<br>
    $Log: debugDisplay.inc,v $
    Revision 1.2  2002/10/01 01:52:57  peren
    Respond to Raj suggestions

--%><% if (session.getAttribute("debug") != null) { %>
<%= DebugUtils.makeFormParamTable(request) %>
<%= DebugUtils.makeSessionTable(request) %>
<% } %>
