<%--
Java variables for permission testing

   Copyright (c) 2002 by Advanced Systems and Software Technologies
   All Rights Reserved

   Under revision by: $Locker:  $
   Change Log:
   $Log: permSettings.inc,v $
   Revision 1.3  2002/09/29 02:45:44  peren
   ship to Perennity or to India

   Revision 1.2  2002/09/20 02:10:57  peren
   smaller top image, edit and ship books

   Revision 1.1  2002/09/17 17:01:34  peren
   smaller top frame, new graphics

--%>
<%!
boolean editOtherPerm;
boolean makeNewPerm;
boolean editPermPerm;
boolean editTypePerm;
boolean editStatusPerm;
boolean PereShipPerm;
boolean editOthersShipmentPerm;
boolean editOthersBookPerm;
boolean useForumPerm;
boolean PerePaidPerm;
boolean PereCopyClearPerm;
boolean PereOpsPerm;
boolean shipToProcessingPerm;
boolean shipToCustomerPerm;
%><%
{
  String set = (String)session.getAttribute(PereConst.PERMS_ATTR);
  if (StringSetUtils.TestASetStringMember(set,PereConst.ALL_PERMISSIONS_PERM)) {
    editOtherPerm   = true;
    makeNewPerm     = true;
    editPermPerm    = true;
    editTypePerm    = true;
    editStatusPerm  = true;
    PereShipPerm    = true;
    editOthersShipmentPerm = true;
    editOthersBookPerm = true;
    useForumPerm      = true;
    PerePaidPerm      = true;
    PereCopyClearPerm = true;
    PereOpsPerm       = true;
    shipToProcessingPerm = true;
    shipToCustomerPerm = true;
  } else {
    editOtherPerm = StringSetUtils.TestASetStringMember(set, PereConst.EDIT_OTHER_CUSTOMER_PERM);
    makeNewPerm=StringSetUtils.TestASetStringMember(set, PereConst.EDIT_NEW_CUSTOMER_PERM);
    editPermPerm  = StringSetUtils.TestASetStringMember(set, PereConst.EDIT_PERMS_PERM);
    editTypePerm  = StringSetUtils.TestASetStringMember(set, PereConst.EDIT_TYPE_PERM);
    editStatusPerm= StringSetUtils.TestASetStringMember(set, PereConst.EDIT_STATUS_PERM);
    PereShipPerm  =StringSetUtils.TestASetStringMember(set, PereConst.PERE_SHIP_PERM);
    editOthersShipmentPerm =StringSetUtils.TestASetStringMember(set, PereConst.EDIT_OTHERS_SHIPMENT_PERM);
    editOthersBookPerm =StringSetUtils.TestASetStringMember(set, PereConst.EDIT_OTHERS_BOOK_PERM);
    useForumPerm = StringSetUtils.TestASetStringMember(set, PereConst.USE_FORUMS_PERM);
    PerePaidPerm = StringSetUtils.TestASetStringMember(set, PereConst.PERE_PAID_PERM);
    PereCopyClearPerm = StringSetUtils.TestASetStringMember(set, PereConst.PERE_COPYCLEAR_PERM);
    PereOpsPerm = StringSetUtils.TestASetStringMember(set, PereConst.PERE_OPS_PERM);
shipToProcessingPerm = StringSetUtils.TestASetStringMember(set, PereConst.SHIP_TO_PROCESSING);
shipToCustomerPerm = StringSetUtils.TestASetStringMember(set, PereConst.SHIP_BACK_TO_CUSTOMER);
  }
}
%>
