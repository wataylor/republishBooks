/* @name TestShipmentObject.java

Test the shipment object

    Copyright (c) 2002 by Advanced Systems and Software Technologies.
    All Rights Reserved<br>

    Under revision by: $Locker:  $<br>
    Change Log:<br>
    $Log: TestShipmentObject.java,v $
    Revision 1.2  2002/09/20 02:10:57  peren
    smaller top image, edit and ship books

    Revision 1.1  2002/09/05 02:19:43  peren
    customer-generated shipments, some info
<br>
*/

package asst.perennity;

import asst.perennity.PereConst;
import asst.perennity.ShipmentObject;

import java.util.Vector;

import asst.dbase.AnyFieldArray;
import asst.dbase.DBProp;
import asst.dbase.TwixtTableAndForm;

/**
 *
 * @author money
 * @version %I%, %G%
 * @since
 *
 * @see <classname>
 */

public class TestShipmentObject {

  /** Obligatory constructor.*/
  public TestShipmentObject() {
  }

  public static void main(String[] args) {
    ShipmentObject so = new ShipmentObject();
    Vector<AnyFieldArray> afa;
    /**/

    DBProp.PropertyConnection("Perennity");

    // Create a new shipment record
    so.Name.setDirtyChoice("Name");
    so.Description.setDirtyChoice("Description");
    so.Direction.setDirtyChoice("1");

    System.out.println(TwixtTableAndForm.FormToUpdateString(so.getSelectorManagerArray(), true));
    System.out.println("Cre " + so.Created.getChoiceAsText());
    System.out.println("Shp " + so.Shipped.getChoiceAsText());
    so.createWriteNewRecord();

    // Create and dump an array of all shipment records in the table
    afa = AnyFieldArray.ReadObjectsFromTable(PereConst.SHIPMENT_TABLE, PereConst.ID_COL, (String)null, "asst.perennity.ShipmentObject");
    for (int i=0; i<afa.size(); i++) {
      so = (ShipmentObject)afa.get(i);
      System.out.println(i + " " + so.getRecordID());
      System.out.println("Cre " + so.Created.getChoiceAsText());
      System.out.println("Shp " + so.Shipped.getChoiceAsText());
    }
  }
}
