/* @name PereUtils.java

Utility routines for the Perennity web site

    Copyright (c) 2002 by Advanced Systems and Software Technologies.
    All Rights Reserved<br>

    Under revision by: $Locker:  $<br>
    Change Log:<br>
    $Log: PereUtils.java,v $
    Revision 1.6  2002/09/29 02:45:44  peren
    ship to Perennity or to India

    Revision 1.5  2002/09/28 03:49:44  peren
    Customer service function - switch users

    Revision 1.4  2002/09/22 02:53:02  peren
    added pop-up notes

    Revision 1.3  2002/09/17 17:01:34  peren
    smaller top frame, new graphics

    Revision 1.2  2002/09/05 02:19:43  peren
    customer-generated shipments, some info

    Revision 1.1.1.1  2002/08/15 03:18:07  peren
    upload
<br>

*/

package asst.perennity;

import java.lang.RuntimeException;

import java.sql.*;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;

import asst.dbase.DBTokenizer;
import asst.dbase.DataBase;
import asst.dbase.Quotable;
import asst.dbase.SQLUtilities;
import asst.dbase.SelectorManager;
import asst.dbase.SetFieldCheckBoxes;
import asst.dbase.TwixtTableAndForm;

import asst.perennity.PereConst;

/**
 *
 * @author money
 * @version %I%, %G%
 * @since
 *
 * @see <classname>
 */

public class PereUtils {

  /** Obligatory constructor.*/
  public PereUtils() {
  }

  /**
   * Look up the specified LoginID and see if the password matches,
   * returning true if there is a match and false otherwise.</p>

   * @param loginID - customer Login ID to be checked.
   * @param Password - the password which was supplied with the Login
   * ID
   * @param request - the request object posted from the form so that
   * browser parameters may be recorded.
   * @param setSession - TRUE -> record user attributes as standard
   * session attributes, otherwise do not affect the session.  This
   * permits the routine to be used merely for validating a LoginID
   * and password without necessarily logging on.
   * @return true -> the login ID and password were acceptable.*/
  public static boolean Authenticate(String LoginID, String Password,
				     HttpServletRequest request,
				     boolean setSession)
    throws RuntimeException, SQLException {
    HttpSession session = request.getSession();
    ResultSet results = null;	// Results of the retrieval
    Statement stmt = null;		// retrieve the customer record
    String idNO;		// Customer ID index
    String greet;
    String uAgent;		// user agent request parameter
    String query;
    /**/

    stmt  = DataBase.connDB.createStatement();
    query = "select ID, Permissions, NamePrefix, FirstName, MiddleName, LastName, NameSuffix, TypeSet, Password from Customers where LoginID = '"
      + Quotable.QuoteForSQLString(LoginID) + "'";
    try {			// Finally closes the statement
      results = stmt.executeQuery(query);

      if (results.next() && Password.equals(results.getString(9))) {
	if (setSession) {
	  session.setAttribute(PereConst.URLID_ATTR, LoginID);

	  session.setAttribute(PereConst.USERLOGIN_ATTR, LoginID);
	  session.setAttribute(PereConst.CUSTOMERLOGIN_ATTR, LoginID);
	  idNO = results.getString(1);
	  session.setAttribute(PereConst.USERID_ATTR, idNO);
	  session.setAttribute(PereConst.CUSTOMERID_ATTR, idNO);

	  greet = SQLUtilities.stringFromResult(results, 8);
	  if (PereConst.ES.equals(greet)) {
	    greet = PereConst.DEFAULT_CUST_TYPE_STRING;
	  }
	  session.setAttribute(PereConst.USER_TYPE_ATTR, greet);
	  session.setAttribute(PereConst.CUSTOMER_TYPE_ATTR, greet);

	  String perms = SQLUtilities.stringFromResult(results, 2);
	  session.setAttribute(PereConst.PERMS_ATTR, perms);

	  greet = PereUtils.PersonGreet(3, results);
	  session.setAttribute(PereConst.USERGREET_ATTR, greet);
	  session.setAttribute(PereConst.CUSTOMERGREET_ATTR, greet);
	  results.close();
	  uAgent = request.getHeader("user-agent");
	  stmt.execute("update Customers set TimesLoggedIn = TimesLoggedIn+1, LastLogin = null, UserAgent='" + uAgent +
			 "', RemoteAddr='" + request.getRemoteAddr() +
			 "', RemoteHost='" + request.getRemoteHost() + "' where ID=" + idNO);
	  session.setAttribute(PereConst.USER_AGENT_ATTR, uAgent);

	  /* Clean the session of leftover editing attributes just in
	   * case. */
	  session.removeAttribute(PereConst.BOOK_ATTR);
	  session.removeAttribute(PereConst.SHIPMENT_ATTR);
	  session.removeAttribute(PereConst.EDIT_STATE_ATTR);
	  session.removeAttribute(PereConst.EDITID_ATTR);
	}
	return true;
      } else {
	if (setSession) {
	  PereUtils.CleanSessionLoginAttributes(session);
	}
	return false;
      }
    } catch (SQLException e) {
      throw new RuntimeException("Authenticate excp " + query + " " +
				 e.toString());
    } finally {
      if (results != null) { results.close();}
      if (stmt != null)    { stmt.close(); }
    }
  }

  /** Remove the customer-related session attributes, this is used on
      logging out and on various other cleanup situations.  This is
      used because the "invalidate" method does not always work.
  @param session object whose attributes are to be removed.*/
  public static void CleanSessionLoginAttributes(HttpSession session) {
    session.removeAttribute(PereConst.USERID_ATTR);
    session.removeAttribute(PereConst.CUSTOMERID_ATTR);
    session.removeAttribute(PereConst.USERLOGIN_ATTR);
    session.removeAttribute(PereConst.CUSTOMERLOGIN_ATTR);
    session.removeAttribute(PereConst.USERGREET_ATTR);
    session.removeAttribute(PereConst.CUSTOMERGREET_ATTR);
    session.removeAttribute(PereConst.USER_TYPE_ATTR);
    session.removeAttribute(PereConst.CUSTOMER_TYPE_ATTR);
    session.removeAttribute(PereConst.PERMS_ATTR);
    session.removeAttribute(PereConst.BOOK_ATTR);
    session.removeAttribute(PereConst.SHIPMENT_ATTR);
  }

  /** Determine whether a user has been granted a permissions.  Each
      previliged .jsp page checks the current permissions before
      proceeding; returning to customer services if the permissions do
      not suffice.
  @param perm - integer representing a specific permission; should be
  one of the permission constants defined in PereConst.
  @param session - the session object in which the current user
  permissions are stored.
  @return true -> the user has the speecified permission.  */
  public static boolean PermissionCheck(int perm, HttpSession session) {
    String perms = (String) session.getAttribute(PereConst.PERMS_ATTR);
    /**/

    if (perms == null) { return false; }

    try {
      if (perms.charAt(perm) == 'Y') { return true; }
    } catch (StringIndexOutOfBoundsException e) {}
    return false;
  }

  /**
   * Construct a greeting from a result set starting at a specified
   * string in the result set.  This assumes that the personal data
   * are returned as prefix, first name, middle name, last name,
   * suffix in that order starting at some offset within the result set.
   @param offset - the string in the result set which holds the first
   string in the name, that is, the salutation.
  @param results - a result set holding the 5 parts of a name in order.
  @return a name as a combined string.  */
  public static String PersonGreet(int offset, ResultSet results)
    throws SQLException {
    return Quotable.glueStrings((String)null, // results.getString(offset),
				results.getString(offset+1),
				results.getString(offset+2),
				results.getString(offset+3),
				results.getString(offset+4));
  }

  /** Return the complete address information from a result set
      assuming that the address data are selected L1, L2, L3, City,
      State, Country, Post Code
  @param offset into the result set where the address starts
  @param results of the SQL query*/
  public static String BuilAddress(int offset, ResultSet results)
    throws SQLException {
    String addr;
    /**/

    addr = Quotable.glueStrings(results.getString(offset),
				results.getString(offset+1),
				results.getString(offset+2),
				results.getString(offset+3),
				results.getString(offset+4));
    addr = Quotable.glueStrings(addr, results.getString(offset+5),
				(String)null, (String)null,
				(String)null);
    return addr;
  }

/** Examine a set of edited user data in a form and determine whether
      the user has entered a set of consistent and allowable data.
      Return a string buffer of .html which complains about columns
      and values in the specified table.
@param form an array of selector field objects which contains the
current user data which has been entered into a .html form.
@param sb String Buffer to which errata are to be appended
@return a possibly-empty string buffer containing error descriptions
expressed as .html list elements.*/
  public static StringBuffer AuthenticateCustomerData(SelectorManager[] form,
						      StringBuffer sb)
    throws SQLException {
    SelectorManager sm;
    /**/

    sb.append(TwixtTableAndForm.gripeNeededField(form,PereConst.FIRSTNAME_COL));
    sb.append(TwixtTableAndForm.gripeNeededField(form,PereConst.LASTNAME_COL));
    sb.append(TwixtTableAndForm.gripeNeededField(form,PereConst.LOGINID_COL));
    sb.append(TwixtTableAndForm.gripeNeededField(form,PereConst.PASSWORD_COL));

    sm = TwixtTableAndForm.findFormRow(form, PereConst.PASSWORD_COL);
    if (!sm.getIsValid()) {
      sb.append("<LI>A password may not contain asterisks.</li>");
    }

    //sb.append(TwixtTableAndForm.gripeNeededField(form, PereConst.NAMEPREFIX_COL));
    //sb.append(TwixtTableAndForm.gripeNeededField(form, PereConst.EMAIL_COL));
    //sb.append(TwixtTableAndForm.gripeNeededField(form, PereConst.ADDRESS1LINE1_COL));
    //sb.append(TwixtTableAndForm.gripeNeededField(form, PereConst.ADDRESS1CITY_COL));
    //sb.append(TwixtTableAndForm.gripeNeededField(form, PereConst.ADDRESS1STATE_COL));
    //sb.append(TwixtTableAndForm.gripeNeededField(form, PereConst.ADDRESS1COUNTRY_COL));
    //sb.append(TwixtTableAndForm.gripeNeededField(form, PereConst.ADDRESS1POSTALCODE_COL));

    return sb;
  }

  /** Return two strings about a customer ID.
   @param editID string representation of the numerical customer ID
   which selects customer data in other tables
  @return string array, element [0] is the customer login ID, element
  [1] is the customer greeting.*/
  public static String[] CustomerData(String editID) throws SQLException {
    String[] answer = new String[2];
    ResultSet results = null;		// Results of the retrieval
    Statement stmt = null;		// Retrieve the sequence number
    /**/

    stmt  = DataBase.connDB.createStatement();
    try {
      results = stmt.executeQuery("select LoginID,NamePrefix,FirstName,MiddleName,LastName,NameSuffix from Customers where ID=" + editID);
      if (results.next()) {
	answer[0] = results.getString(1);
	answer[1] = PereUtils.PersonGreet(2, results);
      }
    } finally {
      if (results != null) { results.close();}
      if (stmt != null)    { stmt.close(); }
    }
    return answer;
  }

  /** Examine the Customers table to convert a LoginID character string
      to the numerical ID.  The numerical ID is applicable to multiple
      tables.  This entry does NOT check the password, only whether
      the ID exists.  */
  public static int MapLoginIDToID (String LoginID) throws SQLException {
    ResultSet results = null;	// Results of the retrieval
    Statement stmt = null;	// Retrieve the sequence number
    /**/

    if ((LoginID == null) || PereConst.ES.equals(LoginID)) return 0;

    stmt  = DataBase.connDB.createStatement();
    try {
      results = stmt.executeQuery("select ID from Customers where LoginID = '"
				  + Quotable.QuoteForSQLString(LoginID) + "'");
      if (results.next()) {
	return results.getInt(1);
      }
    } finally {
      if (results != null) { results.close();}
      if (stmt != null)    { stmt.close(); }
    }
    return 0;			// The Login ID was not found, ID is 0.
  }

  /** Determine whether a given entity has any notes.  This is needed
   * when creating an editor, the notes should pop up automatically
   * when the object is edited.
   @param type identifies the note type
   @param link identifies the object ID, if zero, has no notes
   @return true if the object has notes, false otherwise*/
  public static boolean HasNotes(int type, int link) throws SQLException {
    ResultSet results = null;	// Results of the retrieval
    Statement stmt = null;	// Retrieve the sequence number
    /**/

    if (link <= 0) return false; // It does not really exist, no notes

    stmt  = DataBase.connDB.createStatement();

    try {
      results = stmt.executeQuery("select ID from Notes where TypeID="
				    + type + " and LinkID=" + link +
				    " limit 1");
      if (results.next()) {
	return true;		// There is at least one note
      }
    } finally {
      if (results != null) { results.close();}
      if (stmt != null)    { stmt.close(); }
    }
    return false;	       // There are no notes.
  }
}
