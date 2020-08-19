/* @name PereConst.java

Constants for the Perennity web site

    Copyright (c) 2002 by Advanced Systems and Software Technologies.
    All Rights Reserved<br>

    Under revision by: $Locker:  $<br>
    Change Log:<br>
    $Log: PereConst.java,v $
    Revision 1.8  2002/09/29 02:45:44  peren
    ship to Perennity or to India

    Revision 1.7  2002/09/22 02:53:02  peren
    added pop-up notes

    Revision 1.6  2002/09/20 02:10:57  peren
    smaller top image, edit and ship books

    Revision 1.5  2002/09/17 17:01:34  peren
    smaller top frame, new graphics

    Revision 1.4  2002/09/11 01:29:03  peren
    contngent

    Revision 1.3  2002/09/05 02:19:43  peren
    customer-generated shipments, some info

    Revision 1.2  2002/08/16 04:50:32  peren
    added nav.jsp

    Revision 1.1.1.1  2002/08/15 03:18:06  peren
    upload
<br>

*/

package asst.perennity;

/**
 *
 * @author money
 * @version %I%, %G%
 * @since
 *
 * @see <classname>
 */

public class PereConst {

  /** Obligatory constructor.*/
  public PereConst() {
  }

  /** One instance of the empty string is sufficient.  Creating empty
      strings as needed generates unnecessary garbage.  */
  static public final String ES = "";

  /** This parameter identifies user ID which is entered as a
      parameter.  This may be EITHER the default Login ID if the user
      requests to log in OR the default sponsor if the user signs up.*/
  static public final String URLID_PARAM  = "usr";

  /** This parameter identifies a login submit button.*/
  static public final String LOGIN_PARAM  = "loGin";
  /** This parameter identifies a cancel submit button.*/
  static public final String CANCEL_PARAM  = "caNcel";
  /** This parameter identifies a confirm submit button.*/
  static public final String CONFIRM_PARAM  = "ConFirm";
  /** This parameter identifies a save submit button.*/
  static public final String SAVE_PARAM  = "sAVe";
  /** This parameter identifies a find submit button.*/
  static public final String FIND_PARAM  = "fInd";

  /** This session attribute gives the user ID which is entered as an
      URL fragment.  This may be EITHER the default Login ID if the
      user requests to log in OR the default sponsor if the user signs
      up.  This attribute is retained for the life of the session. */
  static public final String URLID_ATTR  = "urlid";

  /** This session attribute defines the location within the web site
      to which the authentication routine should redirect the request
      after authentication.  Whenever a non-authenticated user
      attempts to enter a part of the site which requires a password,
      the user is redirected to the login screen.  After successful
      authentication, the user is redirected back to the screen from
      which login was requested; the same holds true for signups.  If
      the user gives up and cancels the authentication, the
      authenticator redirects to the top-level screen; there is no
      point in going back to the secure screen which originally
      requested the authentication.  */
  static public final String REDIRECT_ATTR      = "redirect";

 /** This session attribute is set ONLY after successful
      authentication, it is a string which stores the numerical
      database ID of the user.  This attribute is deleted each time
      authentication fails. */
  static public final String USERID_ATTR  = "userID";
 /** This session attribute is set ONLY after successful
      authentication, it is a string which stores the authenticated
      Login ID string.  This attribute is deleted each time
      authentication fails. */
  static public final String USERLOGIN_ATTR  = "userLogin";
  /** This session attribute is set ONLY after authentication, it is a
      string by which the user is greeted on certain dynamic
      screens.  It is constructed from the Name Prefix, First Name,
      Last Name, and Title from the database.  This string is
      constructed by the authentication routine when authentication
      succeeds.  If this attribute is present, a customer has logged in,
      if not, no one is logged in. */
  static public final String USERGREET_ATTR  = "usergreet";
  /** This session attribute is set ONLY after successful
      authentication, it is a string which stores the user type.
      This attribute is deleted on logout and whenever authentication
      fails.  On authentication, this attribute is set to one of the
      USER_TYPE_STRINGS. */
  static public final String USER_TYPE_ATTR  = "utYpe";

 /** This session attribute indicates which customer's records we are
     editing.  When an ordinary customer logs in, the User and
     Customer attributes will be the same.  However, when a
     customer-service staffer logs in, they will select different
     customer records to edit (one at a time).  In this case, the User
     attributes will relfect the staffer that actually logged in, and
     the Customer attributes will reflect whoever's record they are
     working on right now.  This particular attribute stores the
     numerical database ID of the customer being worked on. */
  static public final String CUSTOMERID_ATTR  = "customerID";
 /** This session attribute indicates which customer's records we are
     editing.  When an ordinary customer logs in, the User and
     Customer attributes are the same.  However, when a
     customer-service staffer logs in, they select different customer
     records to edit (one at a time).  In this case, the User
     attributes reflect the staffer that logged in, and the Customer
     attributes reflect whoever's records they are working on right
     now.  This particular attribute stores the LoginID string of the
     customer being worked on. */
  static public final String CUSTOMERLOGIN_ATTR  = "customerLogin";
  /** This session attribute indicates which customer's records are
      being edited.  When an ordinary customer logs in, the User and
      Customer attributes are the same.  However, when a
      customer-service staffer logs in, they select different customer
      records to edit (one at a time).  In this case, the User
      attributes reflect the staffer that actually logged in and the
      Customer attributes reflect whoever's records they are working
      on right now.  This particular attribute stores their human
      readable name, constructed from the Name Prefix, First Name,
      Last Name, and Title from the database.  */
  static public final String CUSTOMERGREET_ATTR  = "customergreet";
  /** This session attribute stores the customer type string.  This
   * affects how the various editors work.*/
  static public final String CUSTOMER_TYPE_ATTR  = "customertype";

  /** This session attribute is set ONLY after authentication; it
      stores the user's permission string as extracted from the
      database. */
  static public final String PERMS_ATTR  = "perms";
 /** This session attribute is set ONLY after successful
      authentication, it is a string which identifies the browser and
      version by which the customer logged in.  It is deleted if
      authentication fails. */
  static public final String USER_AGENT_ATTR = "uaGent";
  /** String representation of the numerical key to select which data
      record is being edited.  This attribute is set by the edit
      initialization routine and cleared by the editor when it saves
      the updated values.  The ID is GENERALLY the same as the log in
      customer ID because only a very few customers are permitted to
      edit other customer's data.  If a high-powered customer logs on
      and asks to edit customer data, the form asks which customer.
      Lower-powered customers get their own data when they ask to edit
      data without being asked. */
  static public final String EDITID_ATTR  = "editid";
  /** Attribute which stores the shipment object for the shipment
   * editor.  The existence or lack thereof of this object defines the
   * editor state.*/
  static public final String SHIPMENT_ATTR  = "sHIPment";
  /** Attribute which stores the book object for the book
   * editor.  The existence or lack thereof of this object defines the
   * editor state.*/
  static public final String BOOK_ATTR  = "bOoK";

  /** These integers define indexes into the Permissions string
      retrieved from the database and stored in the session object.
      If the character indexed by one of these integers has the value
      'Y', the user has that privilege, if the character has any other
      value or if a StringLength exception is generated or if the
      permissions attribute string is empty, the user does not have
      the privilege.  Parenthetically, any customer may edit his own
      data and view his own shipments and books; the goal is for
      customers to do most data maintenance themselves.  */
  static public final int ALL_PERMISSIONS_PERM      = 0;
  static public final int EDIT_OTHER_CUSTOMER_PERM  = 1;
  static public final int EDIT_NEW_CUSTOMER_PERM    = 2;
  static public final int EDIT_PERMS_PERM           = 3;
  static public final int EDIT_TYPE_PERM            = 4;
  static public final int EDIT_STATUS_PERM          = 5;
  static public final int PERE_SHIP_PERM            = 6;
  static public final int EDIT_OTHERS_SHIPMENT_PERM = 7;
  static public final int EDIT_OTHERS_BOOK_PERM     = 8;
  static public final int USE_FORUMS_PERM           = 9;
  static public final int PERE_PAID_PERM            = 10;
  static public final int PERE_COPYCLEAR_PERM       = 11;
  static public final int PERE_OPS_PERM             = 12;
  static public final int SHIP_TO_PROCESSING        = 13;
  static public final int SHIP_BACK_TO_CUSTOMER     = 14;

  /** Strings which describe the various permissions. */
  static public final String[] PERM_DESCRIPTIONS = {
    "Has All Permissions",	 // 0
    "Edit Other Customer",	 // 1
    "Make New Customer",	 // 2
    "Edit Customer Permissions", // 3
    "Edit Customer Type",	 // 4
    "Edit Customer Status",	 // 5
    "Perennity Mailroom",	 // 6
    "Change Other's Shipment",   // 7
    "Change Other's Book",       // 8
    "Participate in Forums",     // 9
    "Log Payments",              //10
    "Log Copyright Clearance",   //11
    "Log Processing Status",     //12
    "May Ship to India",         //13
    "Ship Back to Customer",     //14
   };

  /** This session session attribute records what the editor is doing.
      The editor states are start and edit.  This attribute is
      manipulated by the editor and cleared when the editor is
      finished.  */
  static public final String EDIT_STATE_ATTR = "edstate";
  /** This is a value of the EDIT_STATE_ATTR, it indicates that the
      editor is starting to edit.  This forces it to read member data
      from the database if the member exists or to clear the form if
      this is a new member.  */
  static public final String EDIT_START_STATE = "start";
  /** This is a value of the EDIT_STATE_ATTR, it indicates that the
      editor is in the process of editing.  It validates the form and
      saves it if the "save" button was pressed and the data are OK.  */
   static public final String EDIT_STEADY_STATE = "steady";

  /** Whenever a customer has no type, this default type is used.*/
  static public final String DEFAULT_CUST_TYPE_STRING = "Ynnnn";

  /** Define the name of the database.*/
  static public final String DATABASE_NAME = "Perennity";
  /** Define the name of the customer table.  This string avoids
   * having multiple instances of the same constant. */
  static public final String CUSTOMER_TABLE = "Customers";

  /** Define the name of the shipment table.  This string avoids
   * having multiple instances of the same constant. */
  static public final String SHIPMENT_TABLE = "Shipments";

   /** Define the name of the book table.  This string avoids
   * having multiple instances of the same constant. */
  static public final String BOOK_TABLE = "Books";

  /** These constants define the names of the Customers table columns
      which are checked for valid values during editing or are
      otherwise processed on a column-by-column basis.  Login IDs are
      stored in many tables so the length thereof is a constant to
      ensure uniformity.  */
  static public final String ID_COL                 = "ID";
  static public final String PASSWORD_COL           = "Password";
  static public final String HINT_COL               = "PasswordHint";
  static public final String EMAIL_COL              = "EmailAddress";
  static public final String NAMEPREFIX_COL         = "NamePrefix";
  static public final String FIRSTNAME_COL          = "FirstName";
  static public final String LASTNAME_COL           = "LastName";
  /** The Login ID is a unique string which identifies the user to the
      database; the associated password is used for authentication.*/
  static public final String LOGINID_COL            = "LoginID";
  static public final String PERMISSIONS_COL        = "Permissions";
  static public final String ADDRESS1LINE1_COL      = "Address1Line1";
  static public final String ADDRESS1CITY_COL       = "Address1City";
  static public final String ADDRESS1COUNTRY_COL    = "Address1Country";
  static public final String ADDRESS1POSTALCODE_COL = "Address1PostalCode";
  static public final String ADDRESS1STATE_COL      = "Address1State";
  static public final String ADDRESS2LINE1_COL      = "Address2Line1";
  static public final String ADDRESS2CITY_COL       = "Address2City";
  static public final String ADDRESS2COUNTRY_COL    = "Address2Country";
  static public final String ADDRESS2POSTALCODE_COL = "Address2PostalCode";
  static public final String ADDRESS2STATE_COL      = "Address2State";
  static public final String ADDRESS3LINE1_COL      = "Address3Line1";
  static public final String ADDRESS3CITY_COL       = "Address3City";
  static public final String ADDRESS3COUNTRY_COL    = "Address3Country";
  static public final String ADDRESS3POSTALCODE_COL = "Address3PostalCode";
  static public final String ADDRESS3STATE_COL      = "Address3State";
  static public final String NAMEONCHECK_COL        = "NameOnCheck";
  static public final String TAXPAYERID_COL         = "TaxpayerID";
  static public final String TAXABLEENTITY_COL      = "TaxableEntity";
  /** This column stores database-generated modification times; the
      MySQL database automatically updates the first TIMESTAMP column
      in a row whenever any field is changed.  That is why the column
      declaration includes the SQL data type as well as the column
      name; other data bases have different types for such fields.  */
  static public final String MODIFIED_COL           = "Modified";
  /** The customer table has a field which defines
      the customer type as a character string.  Each character of the
      string is either Y or N to indicate that the customer meets the
      requirements specified by the corresponding label in
      CUSTOMER_TYPE_STRINGS.  The data structure permits a customer to
      fall into multiple categories; this may or may not make business
      sense.  If no type characters are set, the customer defaults to
      Customer.*/
  static public final String CUST_TYPE_COL = "TypeSet";
  /** Array of labels for customer types.*/
  static public final String[] CUSTOMER_TYPE_STRINGS = {
    "Library",
    "Academic",
    "Employee",
  };

  /** Array of name prefix strings.*/
  static public final String[] PREFIXES = {"Mrs.", "Mr.", "Miss", "Ms.", "Dr."};
  /** Array of name suffix strings.*/
  static public final String[] SUFFIXES = {"Esq.", "M.D.", "Ph.D."};

  /** These strings indicate various status values pertaining to the
   * customer.*/
  static public final String[] CUSTOMER_STATUS_STRINGS = {
    "Do Not Sell To This Customer",
    "May Pay By Check",
    "May Pay By Invoice",
  };

  /** All notes for books, shipments, and customers are stored in the
   * same table with a type flag.  This constant indicates a note
   * about a customer.*/
  static public final int CUSTOMER_NOTE = 1;

  /** All notes for books, shipments, and shipments are stored in the
   * same table with a type flag.  This constant indicates a note
   * about a shipment.*/
  static public final int SHIPMENT_NOTE = 2;

  /** All notes for books, books, and books are stored in the
   * same table with a type flag.  This constant indicates a note
   * about a book.*/
  static public final int BOOK_NOTE = 3;

  /** Define the names of the objects which match the note types.*/
  static public final String[] NOTE_TYPE_DESCRIPTIONS = {
    "", "Customer", "Shipment", "Book",
  };
}
