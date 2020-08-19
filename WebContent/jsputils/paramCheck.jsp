<%@ page import="java.util.Enumeration,
java.util.Vector,
java.util.Properties,
java.lang.Exception" %>
<html>
<head>
<title>JSP Tables</title>
<!-- paramCheck.jsp

JSP script to look at input parameters and display them.  This helps
programmers determine exactly what happens with each different type of
input device.

It appears that when check boxes are not checked, their names do not
appear in getParameterNames().  Text Boxes and Areas, in contrast,
contain "" if the value has not been specified.

   Copyright (c) 2001 by Advanced Systems and Software Technologies.
   All Rights Reserved

   Under revision by: $Locker:  $
   Change Log:
   $Log: paramCheck.jsp,v $
   Revision 1.2  2002/09/03 23:30:55  asst
   Include examples of multi-selection box

   Revision 1.1.1.1  2002/04/11 04:30:06  zonediet
   first import

-->
<style type="text/css">
</style>

<SCRIPT LANGUAGE="javascript">
<!-- Hide from browsers that do not understand JavaScript

var OpenWindow

function commifyArray(obj) {
  var s="";
  if(obj==null||obj.length<=0){return s;}
  for(var i=0;i<obj.length;i++){
    s=s+((s=="")?"":",")+obj[i].toString();
  }
  return s;
}

function getSingleInputValue(obj,use_default) {
  switch(obj.type){
  case 'radio': case 'checkbox':
    return(((use_default)?obj.defaultChecked:obj.checked)?obj.value:null);
  case 'text': case 'hidden': case 'textarea':
    return(use_default)?obj.defaultValue:obj.value;
  case 'select-one':
    if(use_default){
      var o=obj.options;
      for(var i=0;i<o.length;i++){if(o[i].defaultSelected){return o[i].value;}}
      return null;
    }
    return(obj.options.length>0)?obj.options[obj.selectedIndex].value:null;
  case 'select-multiple':
    var values=new Array();
    for(var i=0;i<obj.options.length;i++) {
      if((use_default&&obj.options[i].defaultSelected)||(!use_default&&obj.options[i].selected)) {
	values[values.length]=obj.options[i].value;
      }
    }
    return (values.length==0)?null:commifyArray(values);
  }
  alert("FATAL ERROR: Field type "+obj.type+" is not supported for this function");
  return null;
}

function clickedCheck(obj) {
alert ("You clicked the checkbox " + obj.name + " and its status is " + obj.checked + " and its value is " + obj.value);
}

function whoWhat() {
var content = "<h1 align=center>JavaScript Data Info</h1>";

var whichIdxStr    = "<p>Index of selector &quot;which&quot;: " + document.testForm.which.selectedIndex;
var whichValStr    = "<br>Defined value call of selector &quot;which&quot;: " + document.testForm.which.value;
var whichValIdxStr = "<br>Defined value/index deduce of selector &quot;which&quot;: " + document.testForm.which.options[document.testForm.which.selectedIndex].value;
var autoIdxStr     = "<p>Index of selector &quot;automatic&quot;: " + document.testForm.automatic.selectedIndex;
var autoValStr     = "<br>Defined value call of selector &quot;automatic&quot;: " + document.testForm.automatic.value;
var autoValIdxStr  = "<br>Defined value/index deduce of selector &quot;automatic&quot;: " + document.testForm.automatic.options[document.testForm.automatic.selectedIndex].value;

var multiValStr = "<p>Multi-Value select: " + getSingleInputValue(document.testForm.multi,false);

var listValStr     = "<p>Contents of TextBox &quot;list&quot;: " + document.testForm.list.value;
var whenValStr     = "<br>Contents of TextBox &quot;when&quot;: " + document.testForm.when.value;
var textValStr     = "<br>Contents of TextArea &quot;text&quot;: " + document.testForm.text.value;
var doorCheckStr   = "<br>Checkbox &quot;door&quot is checked: " + document.testForm.door.checked;
var doorValStr     = "<br>Current value of checkbox &quot;door&quot;: " + document.testForm.door.value;
var dosCheckStr    = "<br>Checkbox &quot;dos&quot is checked: " + document.testForm.dos.checked;
var dosValStr      = "<br>Current value of checkbox &quot;dos&quot;: " + document.testForm.dos.value;
var anivValStr     = "<br>Current value of radio &quot;aniv&quot;: " + document.testForm.aniv.value;
content = content + whichIdxStr + whichValStr + whichValIdxStr + autoIdxStr + autoValStr + autoValIdxStr + multiValStr + listValStr + whenValStr + textValStr + doorCheckStr + doorValStr + dosCheckStr + dosValStr + anivValStr + "</p>"

openChildWindow(content);

}

function openChildWindow(content) {

if (!(OpenWindow!=null)) {
OpenWindow=window.open("", "childwin","height=520,width=400,toolbar=no,menubar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes");
} else if (OpenWindow.closed) {
OpenWindow=window.open("", "childwin","height=520,width=400,toolbar=no,menubar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes");
}

OpenWindow.document.write("<HTML>")
OpenWindow.document.write("<HEAD>")
OpenWindow.document.write("<TITLE>More Information</TITLE>")
OpenWindow.document.write("<BODY BGCOLOR='lightblue'>")
OpenWindow.document.write(content)
OpenWindow.document.write("<p align=center><a href='' onClick='self.close()'>Click here to close</a></p>")
OpenWindow.document.write("</body>")
OpenWindow.document.write("</html>")
OpenWindow.document.close()
OpenWindow.focus()

}

-->
</script>

</head>
<body>
<%@include file='tableConstants.jsp'%>
<%@include file='makeFormParamTable.jsp'%>
<%@include file='makeRequestHeaderTable.jsp'%>
<%@include file='makeServletTables.jsp'%>
<%@include file='makeSessionTable.jsp'%>
<%@include file='makeSystemTable.jsp'%>

<FORM METHOD=Get ACTION="<%=response.encodeURL("paramCheck.jsp")%>" name="testForm">

<p>Selector named which:
<SELECT NAME="which">
<OPTION VALUE="One">one</option>
<OPTION VALUE="Two">two</option>
<OPTION VALUE="Three">three</option>
</SELECT>

<p>Submit selector named automatic:
<SELECT NAME="automatic" onchange='document.testForm.submit()'>
<OPTION VALUE="AOne">aone</option>
<OPTION VALUE="ATwo">atwo</option>
<OPTION VALUE="AThree">athree</option>
</SELECT>

<p>Multi-Selector named multi:
<SELECT NAME="multi" size="4" multiple id="multi">
  <OPTION VALUE="Aerospace" SELECTED>Aerospace</option>
  <OPTION VALUE="Component MFR">Component MFR</option>
  <OPTION VALUE="Consumer Products">Consumer Products</option>
  <OPTION VALUE="Kitting">Kitting</option>
  <OPTION VALUE="Medical">Medical</option>
  <OPTION VALUE="Military">Military</option>
  <OPTION VALUE="Power Supply" SELECTED>Power Supply</option>
  <OPTION VALUE="Telecom" selected>Telecom</option>
  <OPTION VALUE="Other">Other</option>
</select></td>

<br>TextBox named list <input type=text name="list" size="10">
TextBox named when <input type=text name="when" size="5" value="1000">
<br>TextArea named text:<br>
<TEXTAREA COLS="30" ROWS="3" NAME="text"></TEXTAREA>
<br>
Check box named door: <INPUT NAME="door" TYPE=checkbox>
Check box named dos:  <INPUT NAME="dos"  TYPE=checkbox onClick="clickedCheck(this)" value="fred">
<INPUT TYPE="reset" VALUE="Reset Form"><BR>
Button name button value button <input type=button value="button" name=button><br><BR>
<input name="aniv" type="radio" value="aniv" CHECKED>Radio group aniv, button named aniv
<input name="aniv" type="radio" value="inter">Radio group aniv, button named inter<BR>
<input type=submit value="submit1" name="submit1">
<input type=submit value="submit2" name="submit2">
<input type=button value="JavaScript values" onClick="whoWhat()">
</form>

Session from Cookie <%= request.isRequestedSessionIdFromCookie() %><br>
Session from URL    <%= request.isRequestedSessionIdFromUrl() %><br>

<%= makeFormParamTable(request) %>

<%= makeSessionTable(request) %>

<%= makeRequestHeaderTable(request) %>

<%= makeServletTables(this, application) %>

<%= makeSystemTable() %>

</body>
</html>
