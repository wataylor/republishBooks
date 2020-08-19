/* stateList.js

Standard selector of US states and Canadian provinces which is
intended to be used in a JavaScript include.  This program is used by
calling it and passing the OBJECT of the select field you want to
populate with the list.  It automatically sets the blank option as
selected; if you know what it should be you can add a line of code
into the calling file to change the selected index.

Note: The select object has to already exist in the HTML code before
this functions is called - it has to be there to be populated.
Logically it shouldn't need any options in it before it is populated,
and in IE it doesn't, but Netscape will make the drop-down only as big
as the number of options BEFORE it is populated.  So the
to-be-populated selector is best expressed like so:

<SELECT NAME="country">
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
<option VALUE="">------------------------------</OPTION>
</SELECT>

The lines of dashes forces Netscape to make the box sufficiently wide.
Don't worry about them, they are overwritten when populated.

   Copyright (c) 2001 by Advanced Systems and Software Technologies.
   All Rights Reserved

   Under revision by: $Locker:  $
   Change Log:
   $Log: stateList.js,v $
   Revision 1.1  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

*/

function loadStates(field) {
var i = 0
states = new Array();

states[i++] = new state("", "--Select State--");
states[i++] = new state("", "--(Provinces at end)--");
states[i++] = new state("AL", "Alabama");
states[i++] = new state("AK", "Alaska");
states[i++] = new state("AZ", "Arizona");
states[i++] = new state("AR", "Arkansas");
states[i++] = new state("CA", "California");
states[i++] = new state("CO", "Colorado");
states[i++] = new state("CT", "Connecticut");
states[i++] = new state("DE", "Delaware");
states[i++] = new state("DC", "District of Columbia");
states[i++] = new state("FL", "Florida");
states[i++] = new state("GA", "Georgia");
states[i++] = new state("HI", "Hawaii");
states[i++] = new state("ID", "Idaho");
states[i++] = new state("IL", "Illinois");
states[i++] = new state("IN", "Indiana");
states[i++] = new state("IA", "Iowa");
states[i++] = new state("KS", "Kansas");
states[i++] = new state("KY", "Kentucky");
states[i++] = new state("LA", "Louisiana");
states[i++] = new state("ME", "Maine");
states[i++] = new state("MD", "Maryland");
states[i++] = new state("MA", "Massachusetts");
states[i++] = new state("MI", "Michigan");
states[i++] = new state("MN", "Minnesota");
states[i++] = new state("MS", "Mississippi");
states[i++] = new state("MO", "Missouri");
states[i++] = new state("MT", "Montana");
states[i++] = new state("NE", "Nebraska");
states[i++] = new state("NV", "Nevada");
states[i++] = new state("NH", "New Hampshire");
states[i++] = new state("NJ", "New Jersey");
states[i++] = new state("NM", "New Mexico");
states[i++] = new state("NY", "New York");
states[i++] = new state("NC", "North Carolina");
states[i++] = new state("ND", "North Dakota");
states[i++] = new state("OH", "Ohio");
states[i++] = new state("OK", "Oklahoma");
states[i++] = new state("OR", "Oregon");
states[i++] = new state("PA", "Pennsylvania");
states[i++] = new state("RI", "Rhode Island");
states[i++] = new state("SC", "South Carolina");
states[i++] = new state("SD", "South Dakota");
states[i++] = new state("TN", "Tennessee");
states[i++] = new state("TX", "Texas");
states[i++] = new state("UT", "Utah");
states[i++] = new state("VT", "Vermont");
states[i++] = new state("VA", "Virginia");
states[i++] = new state("WA", "Washington");
states[i++] = new state("WV", "West Virginia");
states[i++] = new state("WI", "Wisconsin");
states[i++] = new state("WY", "Wyoming");
states[i++] = new state("", "--Provinces--");
states[i++] = new state("AB", "Alberta (AB)");
states[i++] = new state("BC", "British Columbia (BC)");
states[i++] = new state("MB", "Manitoba (MB)");
states[i++] = new state("NB", "New Brunswick (NB)");
states[i++] = new state("NF", "Newfoundland (NF)");
states[i++] = new state("NS", "Nova Scotia (NS)");
states[i++] = new state("NT", "Northwest Territories (NT)");
states[i++] = new state("NU", "Nunavut (NU)");
states[i++] = new state("ON", "Ontario (ON)");
states[i++] = new state("PE", "Prince Edward Island (PE)");
states[i++] = new state("QC", "Quebec (QC)");
states[i++] = new state("SK", "Saskatchewan (SK)");
states[i++] = new state("YT", "Yukon (YT)");

for (i=0; i<states.length; i++) {
var option = new Option(states[i].dispName,states[i].storeName,0,0);
field[i]=option;
}
field.options[0].selected=true;
}

function state(storeName, dispName) {
this.storeName = storeName;
this.dispName = dispName;
}
