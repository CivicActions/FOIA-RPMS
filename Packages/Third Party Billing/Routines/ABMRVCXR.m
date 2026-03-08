ABMRVCXR ; IHS/SD/SDR - Revenue Code Cross reference FOR MULTIPLES ;   [ 07/27/2007  6:47 AM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**12**;JUL 27, 2007
 ;
 ; This routine is used for the cross reference for pages
 ; 8A, 8E and 8F of the claim editor.  It will try to
 ; populate the rev code (.02) if the field is blank,
 ; looking in the CPT file for a default rev code.
 ;
SET ;EP
 Q:$G(ABMZ("SUB"))=""  ;subfile number not defined
 Q:$P($G(^ABMDCLM(DUZ(2),DA(1),ABMZ("SUB"),DA,0)),U,2)'=""  ;something already there
 S ABMREVCD=$P($G(^ICPT($P($G(^ABMDCLM(DUZ(2),DA(1),ABMZ("SUB"),DA,0)),U),9999999)),U,2)
 I ABMREVCD'="" D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DR=".02////"_ABMREVCD
 .D ^DIE
 Q
KILL ;EP
 Q
