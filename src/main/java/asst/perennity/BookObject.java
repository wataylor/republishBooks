/* @name BookObject.java

    Copyright (c) 2002 by Advanced Systems and Software Technologies.
    All Rights Reserved<br>

    Under revision by: $Locker:  $<br>
    Change Log:<br>
    $Log: BookObject.java,v $
    Revision 1.5  2002/09/24 02:30:33  peren
    general cleanup

    Revision 1.4  2002/09/22 02:53:02  peren
    added pop-up notes

    Revision 1.3  2002/09/20 02:10:57  peren
    smaller top image, edit and ship books

    Revision 1.2  2002/09/17 17:01:33  peren
    smaller top frame, new graphics

    Revision 1.1  2002/09/05 02:19:43  peren
    customer-generated shipments, some info
<br>
*/

package asst.perennity;

import asst.perennity.PereConst;

import asst.dbase.AnyFieldArray;
import asst.dbase.SelectorCheckboxSet;
import asst.dbase.SelectorDBPreload;
import asst.dbase.SelectorDatePreload;
import asst.dbase.SelectorFieldPreload;
import asst.dbase.SelectorManager;
import asst.dbase.SelectorRadioPreload;
import asst.dbase.TwixtTableAndForm;

/** Implement and manage the fields in a book object.  All selectors
* must have the same names as the matching database columns including
* case and must be public so that they are accessible from outside the
* class.  Their column names must match the field names.

 * @author money
 * @version %I%, %G%
 * @since
 *
 * @see <classname>
 */

public class BookObject extends AnyFieldArray {

  /** These integers define indexes into the book status field. */
  static public final int BOOK_ENTERED  = 0;
  static public final int COPYRIGHT_CLEARED  = 1;
  static public final int IN_SCANNING = 2;
  static public final int IN_PROOFING = 3;
  static public final int READY_TO_SHIP = 4;
  static public final int BOOK_PAID = 5;

  /** These strings describe the various book status states; they are
   *  used to label the various checkboxes and status indicators in
   *  the form. */
  static public final String[] BOOK_STATUS_DESCRIPTIONS = {
    "Entered",			// 0
    "Copyright Cleared",	// 1
    "In Scanning",		// 2
    "In Proofing",		// 3
    "Ready to Ship",		// 4
    "Paid"                      // 5
  };

  /** Default book status when it is created.  The extra n characters
   * supply defaults as status values multiply..*/
  static public final String BOOK_STATUS_DEFAULT = "Ynnnnnnnnnnnn";

  /** These integers define indexes into the book type field. */
  public static final int BOOK_NOT_RETURN = 0;

  /** These strings describe the various book types; they are
   *  used to label the various checkboxes and type indicators in
   *  the form. */
  static public final String[] BOOK_TYPE_DESCRIPTIONS = {
    "Need not return book after processing",
  };

  /** Record the customer ID with which the book is associated.*/
  public SelectorFieldPreload CustomerID;

  /** Record the shipment ID with which the book is associated.  The
   * shipment ID is zero from the time the book is created until the
   * time it is assigned to a shipment.  It is nonzero until the book
   * is recorded as having been found in the shipment when the
   * shipment arrives at its destination, at which point, it is zero
   * until the book is assigned to another shipment. */
  public SelectorFieldPreload ShipmentID;

  /** Date when the book is first entered into the database.  */
  public SelectorDatePreload  Created;

  /** Login ID string of whomever created the book. */
  public SelectorFieldPreload CreatedBy;

  /** Title of the book.  The database column and the title object are
   * both called "Name" because a number of utilities process database
   * tables which have numerical index columns named "ID" and
   * character columns named "Name."  The "Name" object is given a
   * .html field name of "Title" when it is placed in a form. */
  public SelectorFieldPreload Name;
  public SelectorFieldPreload Description;
  public SelectorFieldPreload Author;
  public SelectorFieldPreload Publisher;
  public SelectorFieldPreload ISBN;
  public SelectorFieldPreload Status;
  public SelectorFieldPreload PubDate;
  public SelectorFieldPreload Instructions;
  public SelectorDatePreload  CopyClear;
  public SelectorFieldPreload CopyClearBy;
  public SelectorDatePreload  InScan;
  public SelectorFieldPreload InScanBy;
  public SelectorDatePreload  InProof;
  public SelectorFieldPreload InProofBy;
  public SelectorDatePreload  ClearToShip;
  public SelectorFieldPreload ClearToShipBy;
  public SelectorDatePreload  Paid;
  public SelectorFieldPreload PaidBy;
  public SelectorCheckboxSet  Type;

  /** This constructor uses the super constructor to specify the
   * table and column, there are no supplemental tables.*/
  public BookObject() {
    super(PereConst.BOOK_TABLE, PereConst.ID_COL, null);
    this.makeFields();		// Create the fields for the book
    this.specifyDefaults();	// Put in initial default values
  }

  /** Fill in default values either for a new object or after the
   * field array is cleared. */
  public void specifyDefaults() {
    this.Status.setDirtyChoice(BookObject.BOOK_STATUS_DEFAULT);
    this.Created.setChoiceToNow();
  }

  /** Change various attribute values based on status flag changes.
   * This is called from the editor .jsp after an update and before a
   * write.  This method requires that the associated selector fields
   * be located in the fieldMgrs array in an order which matches the
   * order in which messages appear in BOOK_STATUS_DESCRIPTIONS.</p>

   * <P>Selection objects for status indications appear in pairs, the
   * first is the date object and the second is the text field for the
   * perpetrator. For example, the first element of
   * BOOK_STATUS_DESCRIPTIONS is "Entered" which matches the
   * "Created" and "CreatedBy" database fields whose selectors are the
   * 0th and 1st elements of the fieldMgrs array.</p>

   * <P>There may be any number of status descriptions in
   * BOOK_STATUS_DESCRIPTIONS but each of them requires a pair of
   * selectors at the appropriate location in fieldMgrs.
   @param loginID identifies the person who made the changes.*/
  public void updateStatusChanges(String loginID) {
    int i;
    String now  = this.Status.getChoice();
    String then = this.Status.getPriorChoice();
    /**/

    if (!this.Status.getDirtyFlag()) { return; } // No changes

    for (i=0; i<BookObject.BOOK_STATUS_DESCRIPTIONS.length; i++) {
      try {
	/* The then string may be too short, especially when the
	 * object is first created.  If so, treat any missing
	 * characters as non-Y */
	if ((now.charAt(i) == 'Y') &&
	    ((then.length() <= i) || (then.charAt(i) != 'Y'))) {
	  ((SelectorDatePreload)this.fieldMgrs[2*i]).setChoiceToNow();
	  this.fieldMgrs[2*i+1].setDirtyChoice(loginID);
	}
      } catch (Exception e) {
	break;
      }
    }
  }

  /** Instantiate all the field managers in the object.  Note that the
   * first 12 fields MUST appear in the order specified so that they
   * line up with the status change messages, see the documentation of
   * the <CODE>updateStatusChanges</code> method. */
  private void makeFields() {
    int i;
    /**/

    this.fieldMgrs = new SelectorManager[26];
    i = 0;

    fieldMgrs[i++] = (Created = new SelectorDatePreload("Created", this.tableName, "Created"));
    fieldMgrs[i++] = (CreatedBy = new SelectorFieldPreload("Created_By", this.tableName, "CreatedBy"));

    fieldMgrs[i++] = (CopyClear = new SelectorDatePreload("CopyClear", this.tableName, "CopyClear"));
    fieldMgrs[i++] = (CopyClearBy = new SelectorFieldPreload("CopyClearBy", this.tableName, "CopyClearBy"));

    fieldMgrs[i++] = (InScan = new SelectorDatePreload("InScan", this.tableName, "InScan"));
    fieldMgrs[i++] = (InScanBy = new SelectorFieldPreload("InScanBy", this.tableName, "InScanBy"));

    fieldMgrs[i++] = (InProof = new SelectorDatePreload("InProof", this.tableName, "InProof"));
    fieldMgrs[i++] = (InProofBy = new SelectorFieldPreload("InProofBy", this.tableName, "InProofBy"));

    fieldMgrs[i++] = (ClearToShip = new SelectorDatePreload("ClearToShip", this.tableName, "ClearToShip"));
    fieldMgrs[i++] = (ClearToShipBy = new SelectorFieldPreload("ClearToShipBy", this.tableName, "ClearToShipBy"));

    fieldMgrs[i++] = (Paid = new SelectorDatePreload("Paid", this.tableName, "Paid"));
    fieldMgrs[i++] = (PaidBy = new SelectorFieldPreload("PaidBy", this.tableName, "PaidBy"));

    fieldMgrs[i++]=(CustomerID = new SelectorFieldPreload("CustomerID", this.tableName, "CustomerID"));
    CustomerID.setIsNumeric(true);

    fieldMgrs[i++]=(Name = new SelectorFieldPreload("Title", this.tableName, "Name"));

    fieldMgrs[i++]=(Description = new SelectorFieldPreload("Description", this.tableName, "Description"));

    fieldMgrs[i++]=(Instructions = new SelectorFieldPreload("Instructions", this.tableName, "Instructions"));

    fieldMgrs[i++] = (Author = new SelectorFieldPreload("Author", this.tableName, "Author"));

    fieldMgrs[i++] = (Publisher = new SelectorFieldPreload("Publisher", this.tableName, "Publisher"));

    fieldMgrs[i++] = (ISBN = new SelectorFieldPreload("ISBN", this.tableName, "ISBN"));

    fieldMgrs[i++] = (Status = new SelectorFieldPreload("Status", this.tableName, "Status"));
    Status.setIsLogged(true);

    fieldMgrs[i++] = (PubDate = new SelectorFieldPreload("PubDate", this.tableName, "PubDate"));
    PubDate.setIsNumeric(true);

    fieldMgrs[i++] = (ShipmentID = new SelectorFieldPreload("In_Shipment", this.tableName, "ShipmentID"));
    ShipmentID.setIsNumeric(true);
    ShipmentID.setIsLogged(true);

    fieldMgrs[i++] = (Type = new SelectorCheckboxSet("Book_Type", this.tableName, "Type"));
    Type.setSelections(BOOK_TYPE_DESCRIPTIONS);

    this.fieldsUsed = i;	// Remember how many fields were used.
  }

  /** Do error checking on the book.*/
  public StringBuffer authenticate(StringBuffer sb) {
    sb.append(TwixtTableAndForm.gripeNeededField(this.fieldMgrs, "Name"));
    return sb;
  }

}
