/* @name ShipmentObject.java

    Copyright (c) 2002 by Advanced Systems and Software Technologies.
    All Rights Reserved<br>

    Under revision by: $Locker:  $<br>
    Change Log:<br>
    $Log: ShipmentObject.java,v $
    Revision 1.6  2002/09/29 02:45:44  peren
    ship to Perennity or to India

    Revision 1.5  2002/09/21 03:11:57  peren
    user interface smoothing

    Revision 1.4  2002/09/20 02:10:57  peren
    smaller top image, edit and ship books

    Revision 1.3  2002/09/17 17:01:34  peren
    smaller top frame, new graphics

    Revision 1.2  2002/09/11 01:29:03  peren
    contngent

    Revision 1.1  2002/09/05 02:19:43  peren
    customer-generated shipments, some info
<br>
*/

package asst.perennity;

import asst.perennity.PereConst;

import asst.dbase.AnyFieldArray;
import asst.dbase.SelectorDBPreload;
import asst.dbase.SelectorDatePreload;
import asst.dbase.SelectorFieldPreload;
import asst.dbase.SelectorManager;
import asst.dbase.SelectorRadioPreload;
import asst.dbase.TwixtTableAndForm;

/**
 * Define the fields in a shipment object so that multiple batches can be
 * displayed.

 * @author money
 * @version %I%, %G%
 * @since
 *
 * @see asst.perennity.BookObject
 */

public class ShipmentObject extends AnyFieldArray {

  /** Complex classes need empty strings*/
  public static final String ES = "";

  /** Define the available shipping options.*/
  static public final String[] SHIPPER_SELECTIONS = {
    "0|None yet", "1|FedEx", "2|UPS", "3|USPS", "4|Other (specify below)"
  };

  /** Define the available shipping directions.*/
  static public final String[] DIRECTION_SELECTIONS = {
    "0|Not Shipped",
    "1|From Customer to Perennity",
    "2|From Customer to Processing",
    "3|From Perennity to Processing",
    "4|From Processing to Perennity",
    "5|From Processing to Customer",
    "6|From Perennity to Customer",
  };

  /** Define directions for customer-originated shipment where
   * customer may ship to processing center.*/
   static public final String[] CUST_DIRECTION_SELECTIONS = {
    "0|Not Shipped",
    "1|From Customer to Perennity",
    "2|From Customer to Processing",
   };

  /** Perennity address.  */
  public static final String PERENNITY_ADDRESS = "Perennity Publishing<BR>41 Ridge Road<BR>New Hampton, NH<BR>03256 USA<BR>Phone: 603-744-5168";

  /** Processing address.  */
  public static final String PROCESSING_ADDRESS = "CCE Software Private Limited<BR>Perennity Publishing<BR>1st Floor, Rajeshwari Business Chambers<BR>806/1, B.E.M.L Main Road,<BR>New Thippasandra, Bangalore 560 075<BR>INDIA<BR>Phone: +91-80-5292884<BR>NOTE: Enclose a declaration that &quot;This package contains books for demonstration, not for sale, has no commercial value and is on returnable basis.&quot;";

  /** Array of shipping addresses.*/
  public static final String[] SHIPPING_ADDRESSES = {
    ES, PERENNITY_ADDRESS, PROCESSING_ADDRESS, PROCESSING_ADDRESS,
    PERENNITY_ADDRESS, null, null
  };

  /** These integers define indexes into the shipment status field. */
  static public final int SHIPMENT_WAITING  = 0;
  static public final int SHIPMENT_SHIPPED  = 1;
  static public final int SHIPMENT_RECEIVED = 2;

  /** These strings describe the various shipment status states; they
   *  are used to label the various checkboxes. */
  static public final String[] SHIPMENT_STATUS_DESCRIPTIONS = {
    "Waiting",			// 0
    "Shipped",			// 1
    "Received",			// 2
  };

  /** Default shipment status when it is created.  The extra n
   * characters supply defaults as status values multiply..*/
  static public final String SHIPMENT_STATUS_DEFAULT = "Ynnnnnnnnnnnn";

  /** All selectors must have the same names as the matching database
   * columns.  They must be public so that they are accessible from
   * outside.*/
  public SelectorFieldPreload CustomerID;
  public SelectorDatePreload  Created;
  public SelectorFieldPreload CreatedBy;
  public SelectorDatePreload  Shipped;
  public SelectorFieldPreload ShippedBy;
  public SelectorDatePreload  Received;
  public SelectorFieldPreload ReceivedBy;
  public SelectorFieldPreload Status;
  public SelectorRadioPreload ShippedVia;
  public SelectorFieldPreload TrackingCode;
  public SelectorRadioPreload Direction;
  public SelectorFieldPreload Name;
  public SelectorFieldPreload Description;

  /** Obligatory constructor, use the super constructor to specify the
   * table and column, there are no supplemental tables.*/
  public ShipmentObject() {
    super(PereConst.SHIPMENT_TABLE, PereConst.ID_COL, null);
    this.makeFields();
    this.specifyDefaults();	// Put in initial values
  }

  /** Fill in default values either for a new object or after the
   * field array is cleared. */
  public void specifyDefaults() {
    this.Status.setDirtyChoice(ShipmentObject.SHIPMENT_STATUS_DEFAULT);
    this.Created.setChoiceToNow();
  }

  /** Change various attribute values based on status flag changes.
   * This is called from the editor .jsp after an update and before a
   * write.  This method requires that the associated selector fields
   * be located in the fieldMgrs array in an order which matches the
   * order in which messages appear in SHIPMENT_STATUS_DESCRIPTIONS.</p>

   * <P>Selection objects for status indications appear in pairs, the
   * first is the date object and the second is the text field for the
   * perpetrator. For example, the first element of
   * SHIPMENT_STATUS_DESCRIPTIONS is "Waiting" which matches the
   * "Created" and "CreatedBy" database fields whose selectors are the
   * 0th and 1st elements of the fieldMgrs array.  The 2nd element of
   * SHIPMENT_STATUS_DESCRIPTIONS is "Shipped" which matches selectors
   * named Shipped and ShippedBy which are the 2nd and 3rd elements
   * of fieldMgrs and so on.</p>

   * <P>There may be any number of status descriptions in
   * SHIPMENT_STATUS_DESCRIPTIONS but each of them requires a pair of
   * selectors at the appropriate location in fieldMgrs.
   @param loginID identifies the person who made the changes.*/
  public void updateStatusChanges(String loginID) {
    int i;
    String now  = this.Status.getChoice();
    String then = this.Status.getPriorChoice();
    /**/

    if (!this.Status.getDirtyFlag()) { return; } // No changes

    for (i=0; i<ShipmentObject.SHIPMENT_STATUS_DESCRIPTIONS.length; i++) {
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
   * first 6 fields MUST appear in the order specified so that they
   * line up with the status change messages, see the documentation of
   * the <CODE>updateStatusChanges</code> method. */
  private void makeFields() {
    int i;
    /**/

    this.fieldMgrs = new SelectorManager[20];
    i = 0;

    fieldMgrs[i++] = (Created = new SelectorDatePreload("Created", this.tableName, "Created"));
    fieldMgrs[i++] = (CreatedBy = new SelectorFieldPreload("Created_By", this.tableName, "CreatedBy"));

    fieldMgrs[i++] = (Shipped = new SelectorDatePreload("Shipped", this.tableName, "Shipped"));
    fieldMgrs[i++] = (ShippedBy = new SelectorFieldPreload("Shipped_By", this.tableName, "ShippedBy"));

    fieldMgrs[i++] = (Received = new SelectorDatePreload("Received", this.tableName, "Received"));
    fieldMgrs[i++] = (ReceivedBy = new SelectorFieldPreload("Received_By", this.tableName, "ReceivedBy"));

    fieldMgrs[i++]=(Name = new SelectorFieldPreload("Name", this.tableName, "Name"));
    Name.setUniqueFlag(true);

    fieldMgrs[i++]=(Description = new SelectorFieldPreload("Description", this.tableName, "Description"));

    fieldMgrs[i++] = (CustomerID = new SelectorFieldPreload("Customer", this.tableName, "CustomerID"));
    CustomerID.setNumericFlag(true);

    fieldMgrs[i++] = (ShippedVia = new SelectorRadioPreload("Shipped_Via", this.tableName, "ShippedVia"));
    ShippedVia.setSelections(ShipmentObject.SHIPPER_SELECTIONS);
    ShippedVia.setNumericFlag(true);

    fieldMgrs[i++] = (TrackingCode = new SelectorFieldPreload("Tracking_Code", this.tableName, "TrackingCode"));

    fieldMgrs[i++] = (Status = new SelectorFieldPreload("Status", this.tableName, "Status"));
    Status.setIsLogged(true);

    fieldMgrs[i++] = (Direction = new SelectorRadioPreload("Direction", this.tableName, "Direction"));
    Direction.setNumericFlag(true);
    Direction.setSelections(ShipmentObject.DIRECTION_SELECTIONS);

    this.fieldsUsed = i;	// Remember how many fields were used.
  }

  /** Do error checking on the shipment.*/
  public StringBuffer authenticate(StringBuffer sb) {
    sb.append(TwixtTableAndForm.gripeNeededField(this.fieldMgrs, "Name"));
    return sb;
  }

}
