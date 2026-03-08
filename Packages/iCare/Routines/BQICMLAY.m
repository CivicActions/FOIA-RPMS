BQICMLAY ;GDIT/NSCD/ALA - File Care Mmgt group layouts ; 20 Apr 2023  4:07 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**5**;Mar 01, 2021;Build 20
 ;
FIL(OWNR,PLIEN,CARE,TEMPL,SOR,SDIR,DOR) ; EP - Filer
 NEW CRN,CTYP
 S CRN=$O(^BQI(90506.5,"B",CARE,""))
 S CTYP=$P(^BQI(90506.5,CRN,0),U,2)
 ; If the user is the owner
 I OWNR=DUZ D  Q
 . ; If template, delete any customized
 . I $G(TEMPL)'="" D
 .. ; Check if template is in node 4
 .. S PLTN=$O(^BQICARE(OWNR,1,PLIEN,4,"B",TEMPL,""))
 .. ; if template is already in node 4, okay
 .. ; if template is not in node 4, clean up template list and move template from master
 .. I PLTN="" D CTM,MV
 .. S CRIEN=$O(^BQICARE(OWNR,1,PLIEN,23,"B",CARE,""))
 .. I CRIEN'="" D CUS,DCST
 . ;
 . ; if not template then must be customized
 . I $G(TEMPL)="" D
 .. S CRIEN=$O(^BQICARE(OWNR,1,PLIEN,23,"B",CARE,""))
 .. ; if already customized view, clean up customized fields and set new
 .. I CRIEN'="" D CUS
 .. I CRIEN="" D
 ... NEW DA,DIC
 ... S DA(2)=OWNR,DA(1)=PLIEN,X=CARE
 ... S DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",23,",DIC(0)="FL",DLAYGO=90505.123
 ... K DO,DD D FILE^DICN
 ... S CRIEN=+Y
 .. ; If customized 
 .. F DI=1:1:$L(DOR,$C(29)) S GCODE=$P(DOR,$C(29),DI) Q:GCODE=""  D
 ... NEW DA,X,DINUM,DIC,DIE,DLAYGO,IENS
 ... S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=CRIEN
 ... S DIC="^BQICARE("_DA(3)_",1,"_DA(2)_",23,"_DA(1)_",1,",DIE=DIC
 ... S DLAYGO=90505.1231,DIC(0)="FL",DIC("P")=DLAYGO
 ... ;S GIEN=$O(^BQI(90506.1,"B",GCODE,""))
 ... S X=GCODE
 ... I $G(^BQICARE(DA(3),1,DA(2),23,0))="" S ^BQICARE(DA(3),1,DA(2),23,0)="^90505.123^^"
 ... K DO,DD D FILE^DICN
 ... S DA=+Y I DA<1 S ERROR=1 Q
 ... I $G(^BQICARE(DA(3),1,DA(2),23,DA(1),1,0))="" S ^BQICARE(DA(3),1,DA(2),23,DA(1),1,0)="^90505.1231^^"
 ... S IENS=$$IENS^DILF(.DA)
 ... S BQIUPD(90505.1231,IENS,.02)=DI
 ... D FILE^DIE("","BQIUPD","ERROR")
 .. ;
 .. F SI=1:1:$L(SOR,$C(29)) S SIEN=$P(SOR,$C(29),SI) Q:SIEN=""  D
 ... NEW DA,X,IENS,BQIUPD
 ... ;I SIEN'?.N S SIEN=$O(^BQI(90506.1,"B",SIEN,""))
 ... S SN=$O(^BQICARE(OWNR,1,PLIEN,23,CRIEN,1,"B",SIEN,""))
 ... S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=CRIEN,DA=SN,IENS=$$IENS^DILF(.DA)
 ... ;S BQIUPD(90505.1231,IENS,.03)=SIEN
 ... S BQIUPD(90505.1231,IENS,.03)=SI
 ... S BQIUPD(90505.1231,IENS,.04)=$P(SDIR,$C(29),SI)
 ... D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; If the user is sharing someone else's panel, then it is automatically a customized
 I OWNR'=DUZ D
 . I $G(TEMPL)'="" D  Q
 .. S CRIEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,23,"B",CARE,""))
 .. I CRIEN'="" D CSS,DCST
 .. S PLTN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,4,"B",$E(TEMPL,1,30),""))
 .. ; if template is already in node 4, okay
 .. ; if template is not in node 4, clean up template list and move template from master
 .. I PLTN="" D MVS
 .. S LYIEN=$O(^BQICARE(DUZ,15,"B",$E(TEMPL,1,30),"")) NEW DATA D DFLT^BQITMPLE(.DATA,DUZ,LYIEN,CTYP,TEMPL)
 .. ;I PLTN'="" S $P(^BQICARE(OWNR,1,PLIEN,30,DUZ,4,PLTN,0),"^",3)=1
 . S CRIEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,23,"B",CARE,""))
 . ; If already a customized view
 . I CRIEN'="" D CSS
 . I CRIEN="" D
 .. NEW DA,DIC
 .. S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ,X=CARE
 .. S DIC="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_",23,",DIC(0)="FL",DLAYGO=90505.323
 .. K DO,DD D FILE^DICN
 .. S CRIEN=+Y
 . ; If customized
 . F DI=1:1:$L(DOR,$C(29)) S GCODE=$P(DOR,$C(29),DI) Q:GCODE=""  D
 .. NEW DA,X,DINUM,DIC,DIE,DLAYGO,IENS
 .. S DA(4)=OWNR,DA(3)=PLIEN,DA(2)=DUZ,DA(1)=CRIEN
 .. S DIC="^BQICARE("_DA(4)_",1,"_DA(3)_",30,"_DA(2)_",23,"_DA(1)_",1,",DIE=DIC
 .. S DLAYGO=90505.3231,DIC(0)="FL",DIC("P")=DLAYGO
 .. S X=GCODE
 .. I $G(^BQICARE(DA(4),1,DA(3),30,DA(2),23,0))="" S ^BQICARE(DA(4),1,DA(3),30,DA(2),23,0)="^90505.323^^"
 .. K DO,DD D FILE^DICN
 .. S DA=+Y I DA<1 S ERROR=1
 .. I $G(^BQICARE(DA(4),1,DA(3),30,DA(2),23,DA(1),1,0))="" S ^BQICARE(DA(4),1,DA(3),30,DA(2),23,DA(1),1,0)="^90505.3231^^"
 . ;
 . F SI=1:1:$L(SOR,$C(29)) S SIEN=$P(SOR,$C(29),SI) Q:SIEN=""  D
 .. NEW DA,X,IENS
 .. S SN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,23,CRIEN,1,"B",SIEN,""))
 .. S DA(4)=OWNR,DA(3)=PLIEN,DA(2)=DUZ,DA(1)=CRIEN,DA=SN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90505.3231,IENS,.02)=SI
 .. S BQIUPD(90505.3231,IENS,.03)=$P(SDIR,$C(29),SI)
 . D FILE^DIE("I","BQIUPD","ERROR")
 . K BQIUPD
 Q
 ;
MV ;Move template from master list to panel list
 ; if owner is user
 NEW DA,DIC,DLAYGO,IENS,DIE
 S DA(2)=OWNR,DA(1)=PLIEN
 S DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",4,",DIE=DIC
 S DLAYGO=90505.14,DIC(0)="FL",DIC("P")=DLAYGO
 I '$D(^BQICARE(DA(2),1,DA(1),4,0)) S ^BQICARE(DA(2),1,DA(1),4,0)="^90505.14^^"
 S X=TEMPL
 D ^DIC
 S DA=+Y
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(90505.14,IENS,.02)=CTYP,BQIUPD(90505.14,IENS,.03)=1
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
MVS ; Move template for shared user
 NEW TN,TPNM,DA,IENS,DIC,DLAYGO,DIE
 S TN="" F  S TN=$O(^BQICARE(DUZ,15,"C",CTYP,TN)) Q:TN=""  D
 . S TPNM=$P(^BQICARE(DUZ,15,TN,0),"^",1),DEF=$P(^(0),"^",5)
 . I $D(^BQICARE(OWNR,1,PLIEN,30,DUZ,4,"B",$E(TPNM,1,30))) D  Q
 .. S OTN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,4,"B",$E(TPNM,1,30),""))
 .. I TEMPL=TPNM Q
 .. S $P(^BQICARE(OWNR,1,PLIEN,30,DUZ,4,OTN,0),"^",3)=""
 . S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ
 . S DIC="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_",4,",DIE=DIC
 . S DLAYGO=90505.34,DIC(0)="FL",DIC("P")=DLAYGO
 . I '$D(^BQICARE(DA(3),1,DA(2),30,DA(1),4,0)) S ^BQICARE(DA(3),1,DA(2),30,DA(1),4,0)="^90505.34^^"
 . S X=TPNM
 . D ^DIC
 . S DA=+Y
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.34,IENS,.02)=CTYP,BQIUPD(IENS,.03)=1
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
CUS ; Clean up customized list
 NEW DA,IENS
 S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=CRIEN,DA=0
 F  S DA=$O(^BQICARE(OWNR,1,PLIEN,23,CRIEN,1,DA)) Q:'DA  D
 . S IENS=$$IENS^DILF(.DA)
 . S BQIDEL(90505.1231,IENS,.01)="@"
 I $D(BQIDEL) D FILE^DIE("","BQIDEL","ERROR")
 Q
 ;
CSS ; Clean up customized list for shared user
 NEW DA,IENS
 S DA(4)=OWNR,DA(3)=PLIEN,DA(2)=DUZ,DA(1)=CRIEN,DA=0
 F  S DA=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,23,CRIEN,1,DA)) Q:'DA  D
 . S IENS=$$IENS^DILF(.DA)
 . S BQIDEL(90505.3231,IENS,.01)="@"
 I $D(BQIDEL) D FILE^DIE("","BQIDEL","ERROR")
 Q
 ;
CTM ; Clean up template list
 NEW PLTN
 S PLTN=""
 F  S PLTN=$O(^BQICARE(OWNR,1,PLIEN,4,"C",CTYP,PLTN)) Q:PLTN=""  D
 . NEW DA,IENS
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=PLTN,IENS=$$IENS^DILF(.DA)
 . S BQIDEL(90505.14,IENS,.01)="@"
 I $D(BQIDEL) D FILE^DIE("","BQIDEL","ERROR")
 Q
 ;
DCST ; Delete high level customized
 I OWNR=DUZ D
 . NEW DA,IENS
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=CRIEN,IENS=$$IENS^DILF(.DA)
 . S BQIDCUS(90505.123,IENS,.01)="@"
 . I $D(BQIDCUS) D FILE^DIE("","BQIDCUS","ERROR")
 I OWNR'=DUZ D
 . NEW DA,IENS
 . S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ,DA=CRIEN,IENS=$$IENS^DILF(.DA)
 . S BQIDCUS(90505.323,IENS,.01)="@"
 . I $D(BQIDCUS) D FILE^DIE("","BQIDCUS","ERROR")
 Q
