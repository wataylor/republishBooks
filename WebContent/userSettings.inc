<%--
Java variables for user and customer data

   Copyright (c) 2002 by Advanced Systems and Software Technologies
   All Rights Reserved

   Under revision by: $Locker:  $
   Change Log:
   $Log: userSettings.inc,v $
   Revision 1.1  2002/09/22 02:53:02  peren
   added pop-up notes

--%>
<%!
int userID;			// person using the editors
int customerID;		        // person who owns the data being edited
String loginID;			// person using the editors
String customerLoginID;		// person who owns the data being edited
String userType;		// Type information for the user
String customerType;		// Type information for the customer
String userGreet;
String customerGreet;
StringBuffer sb;		// All-purpose error string
%>
<%
// find out whose data is being manipulated
customerID = SQLUtilities.integerFromString((String)session.getAttribute(PereConst.CUSTOMERID_ATTR));
// Find out the ID of whomever is logged on at this time
userID = SQLUtilities.integerFromString((String)session.getAttribute(PereConst.USERID_ATTR));

loginID = (String)session.getAttribute(PereConst.USERLOGIN_ATTR);
customerLoginID = (String)session.getAttribute(PereConst.CUSTOMERLOGIN_ATTR);

userType = (String)session.getAttribute(PereConst.USER_TYPE_ATTR);
customerType = (String)session.getAttribute(PereConst.CUSTOMER_TYPE_ATTR);

userGreet = (String)session.getAttribute(PereConst.USERGREET_ATTR);
customerGreet = (String)session.getAttribute(PereConst.CUSTOMERGREET_ATTR);

sb = new StringBuffer();
{
  int doink;
  if (( (doink = SQLUtilities.integerFromString(request.getParameter("customerID"))) > 0) && (doink != customerID)) {
    sb.append("<LI>Customer ID from request " + doink + " does not equal customer ID from session " + customerID);
  }
}
%>
