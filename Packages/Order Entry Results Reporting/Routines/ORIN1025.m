ORIN1025 ;IHS/CIA/PLS - KIDS Inits for OR patch 1025 ;09-Nov-2022 20:29;PLS
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**1025**;Dec 17, 1997;Build 3
 ;=================================================================
EC ;EP - Environment check
 Q
PRE ;EP - Preinit
 D BLDHSH
 Q
 ;
POST ;EP - Postinit
 D BLDHSH
 Q
 ;
DOT Q:$G(OCXAUTO)  W:($X>70) ! W " ." Q
 ;
CHKOR(DNM,ITEM) ;EP
 N DLG,PMT,IEN,FDA
 S DLG=$$FIND1^DIC(101.41,,"XQ",DNM)
 S PMT=$$FIND1^DIC(101.41,,"XQ",ITEM)
 Q:'PMT!'DLG
 S IEN=$O(^ORD(101.41,DLG,10,"D",PMT,0))
 Q:'IEN
 S FDA(101.412,IEN_","_DLG_",",.1)="D ADDNUM^ORCDPSIV"
 D FILE^DIE("","FDA")
 Q
TIME ;Add date/time to file 101.52 for backdoor orders without them
 N IEN,CREATE,ORDER,AIEN,FDA,ERR,TIME
 S IEN=0 F  S IEN=$O(^ORPA(101.52,IEN)) Q:'+IEN  D
 .S CREATE=$$GET1^DIQ(101.52,IEN,9999999.01,"I")
 .I CREATE="" D
 ..S ORDER=$$GET1^DIQ(101.52,IEN,.01,"I")
 ..S TIME=$$GET1^DIQ(100,ORDER,4,"I")
 ..N FDA,AIEN
 ..S AIEN=IEN_","
 ..S FDA(101.52,AIEN,9999999.01)=TIME
 ..D FILE^DIE("","FDA","ERR")
 ..K FDA,ERR
 Q
 ;
MISMATCH ;Find mismatched hashes caused by the DC of a controlled substance
 ;Now loop through ^ORPA(101.52) from that point forward to look for issues
 N IEN,N999,OHSH,RDSC,NH,ORDER,BLOOP,ACTION,DSIG
 S IEN=0
 F  S IEN=$O(^ORPA(101.52,IEN)) Q:'IEN  D
 . S N999=$G(^ORPA(101.52,IEN,9999999))
 . ;Check HASH
 . S OHSH=$P(N999,U,3)
 .;Calculate new one
 . S RDSC=$$GENSOHSH^BEHOEPIC(IEN)
 . S NH=$$GENHASH^BEHOEPIC(RDSC)
 . I NH'=OHSH D
 ..S ORDER=$P($G(^ORPA(101.52,IEN,0)),U)  ;$$GET1^DIQ(101.52,IEN,.01)
 ..Q:'ORDER
 ..;Find last order action
 ..S BLOOP=9999999
 ..S BLOOP=$O(^OR(100,ORDER,8,BLOOP),-1) Q:'+BLOOP  D
 ...S ACTION=$P($G(^OR(100,ORDER,8,BLOOP,0)),U,2)
 ...S DSIG=$P($G(^OR(100,ORDER,8,BLOOP,2)),U,3)
 ...;Update if last order action was a DC and there is a security hash
 ...I DSIG'=""&(ACTION="DC") D
 ....N FDA,ERR
 ....S FDA(101.52,IEN_",",9999999.03)=NH
 ....D UPDATE^DIE("","FDA","","ERR")
 ....W !,"Updated entry: ",IEN
 Q
BLDHSH ;
 N LP,ORIFN
 S LP=0 F  S LP=$O(^ORPA(101.52,LP)) Q:'LP  D
 .Q:$L($P($G(^ORPA(101.52,LP,9999999)),U,3))  ;Security Hash is present
 .S ORIFN=+$G(^ORPA(101.52,LP,0))
 .Q:'ORIFN
 .D GENSOHSH^BEHOEPS(ORIFN)
 Q
