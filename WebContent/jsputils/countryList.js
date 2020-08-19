/* countryList.js

Standard country selector which is intended to be used in a JavaScript
include.  This program is used by calling it and passing the OBJECT of
the select field you want to populate with the list.  It automatically
sets the USA option as selected; if you know what it should be you can
add a line of code into the calling file to change the selected index.

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

The lines of dashes force Netscape to make the box sufficiently wide.
Don't worry about them, they are overwritten when populated.

Copyright (c) 2002 by Advanced Systems and Software Technologies.
All Rights Reserved

   Under revision by: $Locker:  $
   Change Log:
   $Log: countryList.js,v $
   Revision 1.1  2002/09/05 02:19:43  peren
   customer-generated shipments, some info

*/

function loadCountries(field) {
var i = 0
countries = new Array();

countries[i++] = new country("", "--Select from list--");
countries[i++] = new country("USA", "United States");
countries[i++] = new country("Canada", "Canada");
countries[i++] = new country("Afghanistan", "Afghanistan");
countries[i++] = new country("Albania", "Albania");
countries[i++] = new country("Algeria", "Algeria");
countries[i++] = new country("American Samoa", "American Samoa");
countries[i++] = new country("Andorra", "Andorra");
countries[i++] = new country("Angola", "Angola");
countries[i++] = new country("Anguilla", "Anguilla");
countries[i++] = new country("Antarctica", "Antarctica");
countries[i++] = new country("Antigua and Barbuda", "Antigua and Barbuda");
countries[i++] = new country("Argentina", "Argentina");
countries[i++] = new country("Armenia", "Armenia");
countries[i++] = new country("Aruba", "Aruba");
countries[i++] = new country("Australia", "Australia");
countries[i++] = new country("Austria", "Austria");
countries[i++] = new country("Azerbaijan", "Azerbaijan");
countries[i++] = new country("Bahamas", "Bahamas");
countries[i++] = new country("Bahrain", "Bahrain");
countries[i++] = new country("Bangladesh", "Bangladesh");
countries[i++] = new country("Barbados", "Barbados");
countries[i++] = new country("Belarus", "Belarus");
countries[i++] = new country("Belgium", "Belgium");
countries[i++] = new country("Belize", "Belize");
countries[i++] = new country("Benin", "Benin");
countries[i++] = new country("Bermuda", "Bermuda");
countries[i++] = new country("Bhutan", "Bhutan");
countries[i++] = new country("Bolivia", "Bolivia");
countries[i++] = new country("Bonaire", "Bonaire");
countries[i++] = new country("Bosnia and Herzegovina", "Bosnia and Herzegovina");
countries[i++] = new country("Botswana", "Botswana");
countries[i++] = new country("Bouvet Island", "Bouvet Island");
countries[i++] = new country("Brazil", "Brazil");
countries[i++] = new country("British Indian Ocean Territory", "British Indian Ocean Territory");
countries[i++] = new country("Brunei", "Brunei");
countries[i++] = new country("Bulgaria", "Bulgaria");
countries[i++] = new country("Burkina Faso", "Burkina Faso");
countries[i++] = new country("Burundi", "Burundi");
countries[i++] = new country("Cambodia", "Cambodia");
countries[i++] = new country("Cameroon", "Cameroon");
countries[i++] = new country("Cape Verde", "Cape Verde");
countries[i++] = new country("Cayman Islands", "Cayman Islands");
countries[i++] = new country("Central African Republic", "Central African Republic");
countries[i++] = new country("Chad", "Chad");
countries[i++] = new country("Chile", "Chile");
countries[i++] = new country("China", "China");
countries[i++] = new country("Christmas Island", "Christmas Island");
countries[i++] = new country("Cocos Islands", "Cocos (Keeling) Islands");
countries[i++] = new country("Colombia", "Colombia");
countries[i++] = new country("Comoros", "Comoros");
countries[i++] = new country("Congo", "Congo");
countries[i++] = new country("Cook Islands", "Cook Islands");
countries[i++] = new country("Costa Rica", "Costa Rica");
countries[i++] = new country("Cote D'Ivoire", "Cote D'Ivoire (Ivory Coast)");
countries[i++] = new country("Croatia ", "Croatia (local name: Hrvatska)");
countries[i++] = new country("Cuba", "Cuba");
countries[i++] = new country("Cyprus", "Cyprus");
countries[i++] = new country("Czech Republic", "Czech Republic");
countries[i++] = new country("Denmark", "Denmark");
countries[i++] = new country("Djibouti", "Djibouti");
countries[i++] = new country("Dominica", "Dominica");
countries[i++] = new country("Dominican Republic", "Dominican Republic");
countries[i++] = new country("East Timor", "East Timor");
countries[i++] = new country("Ecuador", "Ecuador");
countries[i++] = new country("Egypt", "Egypt");
countries[i++] = new country("El Salvador", "El Salvador");
countries[i++] = new country("Equatorial Guinea", "Equatorial Guinea");
countries[i++] = new country("Eritrea", "Eritrea");
countries[i++] = new country("Estonia", "Estonia");
countries[i++] = new country("Ethiopia", "Ethiopia");
countries[i++] = new country("Falkland Islands", "Falkland Islands (Malvinas)");
countries[i++] = new country("Faroe Islands", "Faroe Islands");
countries[i++] = new country("Fiji", "Fiji");
countries[i++] = new country("Finland", "Finland");
countries[i++] = new country("France", "France");
countries[i++] = new country("French Guiana", "French Guiana");
countries[i++] = new country("French Polynesia", "French Polynesia");
countries[i++] = new country("French Southern Territories", "French Southern Territories");
countries[i++] = new country("Gabon", "Gabon");
countries[i++] = new country("Gambia", "Gambia");
countries[i++] = new country("Georgia", "Georgia");
countries[i++] = new country("Germany", "Germany");
countries[i++] = new country("Ghana", "Ghana");
countries[i++] = new country("Gibraltar", "Gibraltar");
countries[i++] = new country("Greece", "Greece");
countries[i++] = new country("Greenland", "Greenland");
countries[i++] = new country("Grenada", "Grenada");
countries[i++] = new country("Guadeloupe", "Guadeloupe");
countries[i++] = new country("Guam", "Guam");
countries[i++] = new country("Guatemala", "Guatemala");
countries[i++] = new country("Guinea", "Guinea");
countries[i++] = new country("Guinea-Bissau", "Guinea-Bissau");
countries[i++] = new country("Guyana", "Guyana");
countries[i++] = new country("Haiti", "Haiti");
countries[i++] = new country("Heard and McDonald Islands", "Heard and McDonald Islands");
countries[i++] = new country("Honduras", "Honduras");
countries[i++] = new country("Hong Kong", "Hong Kong");
countries[i++] = new country("Hungary", "Hungary");
countries[i++] = new country("Iceland", "Iceland");
countries[i++] = new country("India", "India");
countries[i++] = new country("Indonesia", "Indonesia");
countries[i++] = new country("Iran", "Iran");
countries[i++] = new country("Iraq", "Iraq");
countries[i++] = new country("Ireland", "Ireland");
countries[i++] = new country("Israel", "Israel");
countries[i++] = new country("Italy", "Italy");
countries[i++] = new country("Jamaica", "Jamaica");
countries[i++] = new country("Japan", "Japan");
countries[i++] = new country("Jordan", "Jordan");
countries[i++] = new country("Kazakhstan", "Kazakhstan");
countries[i++] = new country("Kenya", "Kenya");
countries[i++] = new country("Kiribati", "Kiribati");
countries[i++] = new country("North Korea", "Korea, North");
countries[i++] = new country("South Korea", "Korea, South");
countries[i++] = new country("Kuwait", "Kuwait");
countries[i++] = new country("Kyrgyzstan", "Kyrgyzstan");
countries[i++] = new country("Laos", "Laos");
countries[i++] = new country("Latvia", "Latvia");
countries[i++] = new country("Lebanon", "Lebanon");
countries[i++] = new country("Lesotho", "Lesotho");
countries[i++] = new country("Liberia", "Liberia");
countries[i++] = new country("Libya", "Libya");
countries[i++] = new country("Liechtenstein", "Liechtenstein");
countries[i++] = new country("Lithuania", "Lithuania");
countries[i++] = new country("Luxembourg", "Luxembourg");
countries[i++] = new country("Macau", "Macau");
countries[i++] = new country("Macedonia", "Macedonia");
countries[i++] = new country("Madagascar", "Madagascar");
countries[i++] = new country("Madeira", "Madeira");
countries[i++] = new country("Malawi", "Malawi");
countries[i++] = new country("Malaysia", "Malaysia");
countries[i++] = new country("Maldives", "Maldives");
countries[i++] = new country("Mali", "Mali");
countries[i++] = new country("Malta", "Malta");
countries[i++] = new country("Marshall Islands", "Marshall Islands");
countries[i++] = new country("Martinique", "Martinique");
countries[i++] = new country("Mauritania", "Mauritania");
countries[i++] = new country("Mauritius", "Mauritius");
countries[i++] = new country("Mayotte", "Mayotte");
countries[i++] = new country("Mexico", "Mexico");
countries[i++] = new country("Micronesia", "Micronesia");
countries[i++] = new country("Moldova", "Moldova");
countries[i++] = new country("Monaco", "Monaco");
countries[i++] = new country("Mongolia", "Mongolia");
countries[i++] = new country("Montserrat", "Montserrat");
countries[i++] = new country("Morocco", "Morocco");
countries[i++] = new country("Mozambique", "Mozambique");
countries[i++] = new country("Myanmar", "Myanmar");
countries[i++] = new country("Namibia", "Namibia");
countries[i++] = new country("Nauru", "Nauru");
countries[i++] = new country("Nepal", "Nepal");
countries[i++] = new country("Netherlands", "Netherlands");
countries[i++] = new country("Netherlands Antilles", "Netherlands Antilles");
countries[i++] = new country("New Caledonia", "New Caledonia");
countries[i++] = new country("New Zealand", "New Zealand");
countries[i++] = new country("Nicaragua", "Nicaragua");
countries[i++] = new country("Niger", "Niger");
countries[i++] = new country("Nigeria", "Nigeria");
countries[i++] = new country("Niue", "Niue");
countries[i++] = new country("Norfolk Island", "Norfolk Island");
countries[i++] = new country("Northern Mariana Islands", "Northern Mariana Islands");
countries[i++] = new country("Norway", "Norway");
countries[i++] = new country("Oman", "Oman");
countries[i++] = new country("Pakistan", "Pakistan");
countries[i++] = new country("Palau", "Palau");
countries[i++] = new country("Panama", "Panama");
countries[i++] = new country("Papua New Guinea", "Papua New Guinea");
countries[i++] = new country("Paraguay", "Paraguay");
countries[i++] = new country("Peru", "Peru");
countries[i++] = new country("Philippines", "Philippines");
countries[i++] = new country("Pitcairn", "Pitcairn");
countries[i++] = new country("Poland", "Poland");
countries[i++] = new country("Portugal", "Portugal");
countries[i++] = new country("Puerto Rico", "Puerto Rico");
countries[i++] = new country("Qatar", "Qatar");
countries[i++] = new country("Reunion", "Reunion");
countries[i++] = new country("Romania", "Romania");
countries[i++] = new country("Russia", "Russia");
countries[i++] = new country("Rwanda", "Rwanda");
countries[i++] = new country("Saint Kitts and Nevis", "Saint Kitts and Nevis");
countries[i++] = new country("Saint Lucia", "Saint Lucia");
countries[i++] = new country("Saint Vincent and the Grenadines", "Saint Vincent and the Grenadines");
countries[i++] = new country("Samoa", "Samoa");
countries[i++] = new country("San Marino", "San Marino");
countries[i++] = new country("Sao Tome and Principe", "Sao Tome and Principe");
countries[i++] = new country("Saudi Arabia", "Saudi Arabia");
countries[i++] = new country("Senegal", "Senegal");
countries[i++] = new country("Seychelles", "Seychelles");
countries[i++] = new country("Sierra Leone", "Sierra Leone");
countries[i++] = new country("Singapore", "Singapore");
countries[i++] = new country("Slovakia", "Slovakia");
countries[i++] = new country("Slovenia", "Slovenia");
countries[i++] = new country("Solomon Islands", "Solomon Islands");
countries[i++] = new country("Somalia", "Somalia");
countries[i++] = new country("South Africa", "South Africa");
countries[i++] = new country("Spain", "Spain");
countries[i++] = new country("Sri Lanka", "Sri Lanka");
countries[i++] = new country("St. Helena", "St. Helena");
countries[i++] = new country("St. Pierre and Miquelon", "St. Pierre and Miquelon");
countries[i++] = new country("Sudan", "Sudan");
countries[i++] = new country("Suriname", "Suriname");
countries[i++] = new country("Svalbard and Jan Mayen Islands", "Svalbard and Jan Mayen Islands");
countries[i++] = new country("Swaziland", "Swaziland");
countries[i++] = new country("Sweden", "Sweden");
countries[i++] = new country("Switzerland", "Switzerland");
countries[i++] = new country("Syria", "Syria");
countries[i++] = new country("Taiwan", "Taiwan");
countries[i++] = new country("Tajikistan", "Tajikistan");
countries[i++] = new country("Tanzania", "Tanzania");
countries[i++] = new country("Thailand", "Thailand");
countries[i++] = new country("Togo", "Togo");
countries[i++] = new country("Tokelau", "Tokelau");
countries[i++] = new country("Tonga", "Tonga");
countries[i++] = new country("Trinidad and Tobago", "Trinidad and Tobago");
countries[i++] = new country("Tunisia", "Tunisia");
countries[i++] = new country("Turkey", "Turkey");
countries[i++] = new country("Turkmenistan", "Turkmenistan");
countries[i++] = new country("Turks and Caicos Islands", "Turks and Caicos Islands");
countries[i++] = new country("Tuvalu", "Tuvalu");
countries[i++] = new country("Uganda", "Uganda");
countries[i++] = new country("Ukraine", "Ukraine");
countries[i++] = new country("United Arab Emirates", "United Arab Emirates");
countries[i++] = new country("UK", "United Kingdom");
countries[i++] = new country("US Islands", "U.S. Minor Outlying Islands");
countries[i++] = new country("Uruguay", "Uruguay");
countries[i++] = new country("Uzbekistan", "Uzbekistan");
countries[i++] = new country("Vanuatu", "Vanuatu");
countries[i++] = new country("Vatican City", "Vatican City");
countries[i++] = new country("Venezuela", "Venezuela");
countries[i++] = new country("Vietnam", "Vietnam");
countries[i++] = new country("British Virgin Islands", "Virgin Islands (British)");
countries[i++] = new country("U.S. Virgin Islands", "Virgin Islands (U.S.)");
countries[i++] = new country("Wallis and Futuna Islands", "Wallis and Futuna Islands");
countries[i++] = new country("Western Sahara", "Western Sahara");
countries[i++] = new country("Yemen", "Yemen");
countries[i++] = new country("Yugoslavia", "Yugoslavia");
countries[i++] = new country("Zaire", "Zaire");
countries[i++] = new country("Zambia", "Zambia");
countries[i++] = new country("Zimbabwe", "Zimbabwe");

for (i=0; i<countries.length; i++) {
var option = new Option(countries[i].dispName,countries[i].storeName,0,0);
field[i]=option;
}
}

function country(storeName, dispName) {
this.storeName = storeName;
this.dispName = dispName;
}
