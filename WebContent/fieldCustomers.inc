<%--
Field objects for customer editing, reading, writing, etc.

   Copyright (c) 2002 by AS-ST.  All Rights Reserved

   Under revision by: $Locker:  $
   Change Log:
   $Log: fieldCustomers.inc,v $
   Revision 1.5  2002/10/02 03:08:18  peren
   Add more fields to customers

   Revision 1.4  2002/09/22 02:53:02  peren
   added pop-up notes

   Revision 1.3  2002/09/17 17:01:34  peren
   smaller top frame, new graphics

   Revision 1.2  2002/09/11 01:29:03  peren
   contngent

   Revision 1.1  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

--%>
<%!
// Addresses are stored as contiguous fields in the field array, there
// are utilities which manipulate addresses as a whole
// These integers define where the 3 addreses start in the array.
int a1start;
int a2start;
int a3start;

String ctbl="Customers";
String[] OtherIDTables = null;
SelectorManager [] customerMgrs;
SelectorDBPreload namePrefix;
SelectorFieldPreload firstName;
SelectorFieldPreload middleName;
SelectorFieldPreload lastName;
SelectorDBPreload nameSuffix;
SelectorFieldPreload emailAddress;
SelectorPasswordPreload password;
SelectorPasswordPreload password2;
SelectorFieldPreload passwordHint;
SelectorFieldPreload loginIDField;
SelectorDBPreload newsletter;
SelectorDBPreload howHear;
SelectorFieldPreload a1l1;
SelectorFieldPreload a1l2;
SelectorFieldPreload a1l3;
SelectorFieldPreload a1city;
SelectorFieldPreload a1state;
SelectorFieldPreload a1country;
SelectorFieldPreload a1postalcode;
SelectorFieldPreload checkName;
SelectorFieldPreload businessName;
SelectorFieldPreload a2l1;
SelectorFieldPreload a2l2;
SelectorFieldPreload a2l3;
SelectorFieldPreload a2city;
SelectorFieldPreload a2state;
SelectorFieldPreload a2country;
SelectorFieldPreload a2postalcode;
SelectorFieldPreload a3l1;
SelectorFieldPreload a3l2;
SelectorFieldPreload a3l3;
SelectorFieldPreload a3city;
SelectorFieldPreload a3state;
SelectorFieldPreload a3country;
SelectorFieldPreload a3postalcode;
SelectorFieldPreload homePhone;
SelectorFieldPreload workPhone;
SelectorFieldPreload cellPhone;
SelectorFieldPreload faxPhone;
SelectorCheckboxSet  custStatus;
SelectorCheckboxSet  custCategorySet;
SelectorFieldPreload sponsorID;
SelectorCheckboxSet  permissions;
SelectorFieldPreload company;
%>

<%
if (customerMgrs == null) {
customerMgrs = new SelectorManager[51];
i = 0;
customerMgrs[i++] = (namePrefix = new SelectorDBPreload("Salutation", ctbl, PereConst.NAMEPREFIX_COL, PereConst.PREFIXES));
customerMgrs[i++] = (firstName = new SelectorFieldPreload("First_Name", ctbl, PereConst.FIRSTNAME_COL));
customerMgrs[i++] = (middleName = new SelectorFieldPreload("Middle_Name", ctbl, "MiddleName"));
customerMgrs[i++] = (lastName = new SelectorFieldPreload("Last_Name", ctbl, PereConst.LASTNAME_COL));
customerMgrs[i++] = (nameSuffix = new SelectorDBPreload("Title", ctbl, "NameSuffix", PereConst.SUFFIXES));
customerMgrs[i++] = (emailAddress = new SelectorFieldPreload("Email_Address", ctbl, PereConst.EMAIL_COL));
customerMgrs[i++] = (password = new SelectorPasswordPreload("Password", ctbl, PereConst.PASSWORD_COL));
password.setIsLogged(true);

customerMgrs[i++] = (passwordHint = new SelectorFieldPreload("Password Hint", ctbl, PereConst.HINT_COL));
customerMgrs[i++] = (loginIDField = new SelectorFieldPreload("Login_ID", ctbl, PereConst.LOGINID_COL));
loginIDField.setUniqueFlag(true);
loginIDField.setIsLogged(true);

a1start = i;			// Array entry where address 1 starts
customerMgrs[i++] = (a1l1 = new SelectorFieldPreload(PereConst.ADDRESS1LINE1_COL, ctbl, PereConst.ADDRESS1LINE1_COL));
customerMgrs[i++] = (a1l2 = new SelectorFieldPreload("Address 1 Line2", ctbl, "Address1Line2"));
customerMgrs[i++] = (a1l3 = new SelectorFieldPreload("Address 1 Line3", ctbl, "Address1Line3"));
customerMgrs[i++] = (a1city = new SelectorFieldPreload(PereConst.ADDRESS1CITY_COL, ctbl, PereConst.ADDRESS1CITY_COL));
customerMgrs[i++] = (a1state = new SelectorFieldPreload(PereConst.ADDRESS1STATE_COL, ctbl, PereConst.ADDRESS1STATE_COL));
customerMgrs[i++] = (a1country = new SelectorFieldPreload(PereConst.ADDRESS1COUNTRY_COL, ctbl, PereConst.ADDRESS1COUNTRY_COL));
a1country.setChoice("USA");
customerMgrs[i++] = (a1postalcode = new SelectorFieldPreload(PereConst.ADDRESS1POSTALCODE_COL, ctbl, PereConst.ADDRESS1POSTALCODE_COL));

a2start = i;			// Array element where address 2 starts
customerMgrs[i++] = (a2l1 = new SelectorFieldPreload(PereConst.ADDRESS2LINE1_COL, ctbl, PereConst.ADDRESS2LINE1_COL));
customerMgrs[i++] = (a2l2 = new SelectorFieldPreload("Address 2 Line2", ctbl, "Address2Line2"));
customerMgrs[i++] = (a2l3 = new SelectorFieldPreload("Address 2 Line3", ctbl, "Address2Line3"));
customerMgrs[i++] = (a2city = new SelectorFieldPreload(PereConst.ADDRESS2CITY_COL, ctbl, PereConst.ADDRESS2CITY_COL));
customerMgrs[i++] = (a2state = new SelectorFieldPreload(PereConst.ADDRESS2STATE_COL, ctbl, PereConst.ADDRESS2STATE_COL));
customerMgrs[i++] = (a2country = new SelectorFieldPreload(PereConst.ADDRESS2COUNTRY_COL, ctbl, PereConst.ADDRESS2COUNTRY_COL));
a2country.setChoice("USA");
customerMgrs[i++] = (a2postalcode = new SelectorFieldPreload(PereConst.ADDRESS2POSTALCODE_COL, ctbl, PereConst.ADDRESS2POSTALCODE_COL));

a3start = i;		// Array element where address 3 starts
customerMgrs[i++] = (a3l1 = new SelectorFieldPreload(PereConst.ADDRESS3LINE1_COL, ctbl, "Address3Line1"));
customerMgrs[i++] = (a3l2 = new SelectorFieldPreload("Address 3 Line2", ctbl, "Address3Line2"));
customerMgrs[i++] = (a3l3 = new SelectorFieldPreload("Address 3 Line3", ctbl, "Address3Line3"));
customerMgrs[i++] = (a3city = new SelectorFieldPreload(PereConst.ADDRESS3CITY_COL, ctbl, PereConst.ADDRESS3CITY_COL));
customerMgrs[i++] = (a3state = new SelectorFieldPreload(PereConst.ADDRESS3STATE_COL, ctbl, PereConst.ADDRESS3STATE_COL));
customerMgrs[i++] = (a3country = new SelectorFieldPreload(PereConst.ADDRESS3COUNTRY_COL, ctbl, PereConst.ADDRESS3COUNTRY_COL));
a3country.setChoice("USA");
customerMgrs[i++] = (a3postalcode = new SelectorFieldPreload(PereConst.ADDRESS3POSTALCODE_COL, ctbl, PereConst.ADDRESS3POSTALCODE_COL));
customerMgrs[i++] = (homePhone = new SelectorFieldPreload("Home Phone Number", ctbl, "HomePhoneNumber"));
customerMgrs[i++] = (workPhone = new SelectorFieldPreload("Work Phone Number", ctbl, "WorkPhoneNumber"));
customerMgrs[i++] = (cellPhone = new SelectorFieldPreload("Cell Phone Number", ctbl, "CellPhoneNumber"));
customerMgrs[i++] = (faxPhone = new SelectorFieldPreload("Fax Number", ctbl, "FaxNumber"));
customerMgrs[i++] = (checkName = new SelectorFieldPreload("Name On Check",ctbl, PereConst.NAMEONCHECK_COL));
customerMgrs[i++] = (businessName = new SelectorFieldPreload("Taxpayer Name", ctbl, PereConst.TAXABLEENTITY_COL));
customerMgrs[i++] = (custStatus = new SelectorCheckboxSet("Status", ctbl, "Status"));
custStatus.setSelections(PereConst.CUSTOMER_STATUS_STRINGS);

customerMgrs[i++] = (custCategorySet = new SelectorCheckboxSet("Category", ctbl, "TypeSet"));
custCategorySet.setIsLogged(true);
custCategorySet.setSelections(PereConst.CUSTOMER_TYPE_STRINGS);

customerMgrs[i++] = (permissions = new SelectorCheckboxSet("Permissions", ctbl, "Permissions"));
permissions.setIsLogged(true);
permissions.setSelections(PereConst.PERM_DESCRIPTIONS);
customerMgrs[i++] = (company = new SelectorFieldPreload("Company", ctbl, "TaxableEntity"));

// THE BLANK array customer GOES HERE, any fields AFTER the blank are
// NOT related to the database, the form is ended by a null in the array.
i++;
customerMgrs[i++] = (password2 = new SelectorPasswordPreload("Password2", ctbl, "Password2"));
}
%>
