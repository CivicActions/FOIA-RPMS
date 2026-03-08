XUSNPIE1 ;FO-OAKLAND/JLI - NATIONAL PROVIDER IDENTIFIER DATA CAPTURE ;11/20/06  10:49
 ;;8.0;KERNEL;**420,410,435**; July 10, 1995;Build 10
 ;
 Q
 ;
SET(XUSIEN,XUSNPI) ;
 ; set value for NPI field (#41.99) in file #200
 N OLDNPI S OLDNPI=$P($G(^VA(200,XUSIEN,"NPI")),"^")
 I OLDNPI K ^VA(200,"ANPI",OLDNPI,XUSIEN)
 S ^VA(200,XUSIEN,"NPI")=XUSNPI_U_"D",^VA(200,"ANPI",XUSNPI,XUSIEN)=""
 Q
 ;
SET1(XUSIEN,XUSNPI) ;
 ; set value for NPI field (#41.99) in file #4
 N OLDNPI S OLDNPI=$P($G(^DIC(4,XUSIEN,"NPI")),"^")
 I OLDNPI K ^DIC(4,"ANPI",OLDNPI,XUSIEN)
 S ^DIC(4,XUSIEN,"NPI")=XUSNPI,^DIC(4,"ANPI",XUSNPI,XUSIEN)=""
 Q
 ;
SIGNON ; .ACT - run at user sign-on display message if NEEDS AN NPI
 N XVAL,DATETIME,OPT,XVALTIME
 I $$CHEKNPI^XUSNPIED(DUZ) W !!,"To enter your NPI value enter  NPI  at a menu prompt to jump to the",!,"edit option.",! H 1
 ; following to insure CBO List is scheduled to run on first day of month
 S XVALTIME=$E(DT,6,7) I '((XVALTIME="01")!(XVALTIME="15")) Q
 S XVAL=+$E($$NOW^XLFDT(),6,10) I XVAL>(XVALTIME_".19"),XVAL<(XVALTIME_".1958") D  ; 7 PM TO 7:58 PM ON 1ST OF MONTH
 . S OPT=$$FIND1^DIC(19.2,"","","XUS NPI CBO LIST") I OPT'>0 L +^TMP("XUS NPI CBO LOCK"):0 Q:'$T  D CBOQUEUE L -^TMP("XUS NPI CBO LOCK") Q
 . S DATETIME=$$GET1^DIQ(19.2,OPT_",",2)
 . I DATETIME'=$$FMTE^XLFDT(DT_".2") L +^DIC(19.2,OPT):0 Q:'$T  D SETQUEUE(OPT,DT_".2") L -^DIC(19.2,OPT) Q
 . I '$$GET1^DIQ(19.2,OPT_",",99.1) L +^DIC(19.2,OPT):0 Q:'$T  D  L -^DIC(19.2,OPT)
 . . D SETQUEUE(OPT,"@")
 . . D SETQUEUE(OPT,DT_".2")
 . . Q
 . Q
 Q
 ;
SETQUEUE(OPT,VALUE) ;
 N FDA S FDA(19.2,OPT_",",2)=VALUE D FILE^DIE("","FDA")
 Q
 ;
POSTINIT ;
 N XUGLOB,XUUSER,XIEN,X,ZTDESC,ZTDTH,ZTIO,ZTRTN
 ;S XIEN=$$FIND1^DIC(19,"","","XUCOMMAND") I XIEN>0,$$FIND1^DIC(19.01,","_XIEN_",","","XUS NPI PROVIDER SELF ENTRY")'>0 S X=$$ADD^XPDMENU("XUCOMMAND","XUS NPI PROVIDER SELF ENTRY","NPI","")
 ;S XIEN=$$FIND1^DIC(19,"","","XU USER SIGN-ON") I XIEN>0,$$FIND1^DIC(19.01,","_XIEN_",","","XUS NPI SIGNON CHECK")'>0 S X=$$ADD^XPDMENU("XU USER SIGN-ON","XUS NPI SIGNON CHECK","","")
 ; get global containing Taxonomy values
 S XUGLOB=$$CHKGLOB^XUSNPIED()
 ; go through file 200 and ma
 S XUUSER=0 F  S XUUSER=$O(^VA(200,XUUSER)) Q:XUUSER'>0  I $$ACTIVE^XUSER(XUUSER) D DOUSER^XUSNPIED(XUUSER,XUGLOB)
 ; and send CBO a starting point list
 ;S ZTIO="",ZTDTH=$$NOW^XLFDT(),ZTRTN="CBOLIST^XUSNPIED",ZTDESC="XUS NPI CBOLIST MESSAGE GENERATION" D ^%ZTLOAD
 ; set up to generate CBO list monthly
 D CBOQUEUE
 Q
 ;
CBOQUEUE ;
 N FDA,XUSVAL
 ; check for already queued
 S XUSVAL=$$FIND1^DIC(19.2,"","","XUS NPI CBO LIST") I XUSVAL>0 D  Q
 . S FDA(19.2,XUSVAL_",",2)=$$SETDATE()
 . S FDA(19.2,XUSVAL_",",6)="1M(1@2000,15@2000)"
 . N ZTQUEUED S ZTQUEUED=1 D FILE^DIE("","FDA") K ZTQUEUED
 . Q
 ; no set up queued job
 S XUSVAL=$$FIND1^DIC(19,"","","XUS NPI CBO LIST") Q:XUSVAL'>0  S FDA(19.2,"+1,",.01)=XUSVAL
 S FDA(19.2,"+1,",2)=$$SETDATE()
 S FDA(19.2,"+1,",6)="1M(1@2000,15@2000)"
 N ZTQUEUED S ZTQUEUED=1 D UPDATE^DIE("","FDA") K ZTQUEUED
 Q
 ;
SETDATE() ;
 Q $S($E($$NOW^XLFDT(),6,10)<1.2:DT,$E($$NOW^XLFDT(),6,10)<15.2:$E(DT,1,5)_"15",$E(DT,4,5)>11:(($E(DT,1,3)+1)_"0101"),1:($E(DT,1,5)+1)_"01")_".2"
 ;
EDITNPI(IEN) ; main entry of NPI value
 ; IEN is the internal entry number in file 200 for the provider
 ;
 N DATEVAL,DESCRIP,DONE,NPIVAL1,NPIVAL2,PROVNAME,XX,Y,CURRNPI
 N ODATEVAL,OIEN,OLDNPI,XUSNONED,DIR,ADDNPI,DELETNPI,NOOLDNPI,XUSQI
 S ADDNPI=1,DELETNPI=2,NOOLDNPI=0
 S PROVNAME=$$GET1^DIQ(200,IEN_",",.01)
 ;I '$$ACTIVE^XUSER(IEN) W !,"This user isn't currently active" Q
 I $$GETTAXON^XUSNPIED(IEN,.DESCRIP)=-1 W !,"This user doesn't have a Taxonomy Code indicating a need for an NPI." S XUSNONED=1 ; but don't quit on that
 I $$NPISTATS^XUSNPIED(IEN)="D" S XUSNONED=1
 I $$NPISTATS^XUSNPIED(IEN)="E" W !,"This provider has been indicated as being EXEMPT from needing an NPI value.",!,"   Use Exempt option to remove it first" Q
 S OLDNPI=NOOLDNPI I $$NPISTATS^XUSNPIED(IEN)="D" D  Q:OLDNPI=NOOLDNPI  ; exit without changing
 . N I,X,DIR
 . S CURRNPI=$$GET1^DIQ(200,IEN_",",41.99) I CURRNPI="" Q
 . S OIEN=$$SRCHNPI^XUSNPI("^VA(200,",IEN,CURRNPI) I OIEN>0 S ODATEVAL=$P(OIEN,U,2),OIEN=$O(^VA(200,IEN,"NPISTATUS","C",CURRNPI,"A"),-1)
 . I '$D(ODATEVAL) S OLDNPI=2 ; can't find entry in multiple, delete entry at top
 . W !,"This provider already has an NPI value (",CURRNPI,") entered."
 . ;S DIR(0)="Y",DIR("A")="Do you want to ADD a new NPI value as the active one",DIR("B")="NO" D ^DIR S OLDNPI=Y Q:OLDNPI
 . ;K DIR S DIR(0)="Y",DIR("A")="Do you REALLY want to **DELETE** this NPI value",DIR("B")="NO" D ^DIR I Y S OLDNPI=2
 . S DIR(0)="S^D:Delete;R:Replace",DIR("A")="Do you want to (D)elete or (R)eplace this NPI value?",DIR("?")="Enter either D or R or ^ to quit with out editing"
 . S DIR("?",1)="If the value was entered for the incorrect individual, it should be Deleted.",DIR("?",2)="Otherwise it should be Replaced"
 . D ^DIR K DIR Q:"DR"'[Y  I Y="R" S OLDNPI=ADDNPI Q
 . S DIR(0)="S^V:VALID;E:ERROR",DIR("A",1)="Was the original NPI (V)alid for this provider",DIR("A")="or was it entered in (E)rror?",DIR("?")="Enter either V or E or ^ to quit with out editing"
 . S DIR("?",1)="If the NPI value was entered for the incorrect individual, respond E,",DIR("?",2)="otherwise enter V"
 . D ^DIR K DIR Q:"EV"'[Y  I Y="V" S Y=$$ADDNPI^XUSNPI("Individual_ID",IEN,CURRNPI,$$NOW^XLFDT(),0) D   S OLDNPI=NOOLDNPI Q
 . . W !,$S(Y>-1:"Entry has been marked inactive.",1:$P(Y,U,2)),! Q:+Y=-1
 . . N XUFDA S XUFDA(200,IEN_",",41.98)="@",XUFDA(200,IEN_",",41.99)="@" D FILE^DIE("","XUFDA") S Y=$$CHEKNPI^XUSNPIED(IEN)
 . . Q
 . S OLDNPI=DELETNPI
 . Q
 I $$CHEKNPI^XUSNPIED(IEN)="" W !,"Need for an NPI value isn't indicated - but you can enter an NPI",$C(7)
 I IEN'=DUZ W !,"Provider: ",PROVNAME,"   ","XXX-XX-"_$E($$GET1^DIQ(200,IEN_",",9),6,9),"   DOB: " S XX=$P($G(^VA(200,IEN,1)),U,3) S:XX'="" XX=$$DATE10^XUSNPIED(XX) W XX
 ;I IEN'=DUZ W !,"Status:   Active"
 S DONE=0 I OLDNPI'=DELETNPI F  R !,"Enter NPI (10 digits): ",NPIVAL1:DTIME Q:'$T  Q:NPIVAL1=""  Q:NPIVAL1=U  D  Q:DONE
 . I NPIVAL1'?10N D  Q
 . . W !,$C(7),"Enter a 10 digit National Provider Identifier which is obtained ",!,"from 'https://nppes.cms.hhs.gov/NPPES/Welcome.do'"
 . . Q:$$PROD^XUPROD()  W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to generate a test NPI value" D ^DIR Q:'Y
 . . R !,"Enter a nine (9) digit number as the base: ",Y:DTIME Q:Y'?9N
 . . W !,"The complete NPI value is: ",Y_$$CKDIGIT^XUSNPI(Y),!
 . . Q
 . S XUSQI=$$QI^XUSNPI(NPIVAL1) I +XUSQI=0,$P(XUSQI,U,2)="Invalid NPI" W !,"NPI values have a specific structure to validate them...",!,"The Checksum for this entry is not valid",! Q
 . I XUSQI'=0 N ZZ,DONE1 S DONE1=0 D GETLST^XPAR(.ZZ,"PKG.KERNEL","XUSNPI QUALIFIED IDENTIFIER") D  Q:DONE1
 . . S ZZ="" F  S ZZ=$O(ZZ(ZZ)) Q:ZZ'>0  I $P(ZZ(ZZ),U)=$P(XUSQI,U) W !,"That NPI value is already associated with "_$P(@("^"_$P(ZZ(ZZ),U,2)_$P(XUSQI,U,2)_",0)"),U) S DONE1=1 Q
 . . Q
 . R !,"Please re-enter NPI  : ",NPIVAL2:DTIME Q:'$T  I NPIVAL1'=NPIVAL2 W !,"Values do not match!" Q
 . S DONE=1
 . Q
 I OLDNPI=DELETNPI D
 . I $D(ODATEVAL) D  S Y=$$CHEKNPI^XUSNPIED(IEN) Q
 . . N DIR S DIR(0)="Y",DIR("A")="Confirm that you want to **DELETE** this incorrectly entered NPI",DIR("B")="NO" D ^DIR Q:'Y
 . . D DELETNPI^XUSNPIE2(IEN,OIEN,ODATEVAL)
 . . D CHKOLD1(IEN) ; check for earlier value, and activate if present
 . . W !,"Entry was DELETED..."
 . . Q
 . D DELETNPI^XUSNPIE2(IEN) ; clean up where no entry in multiple
 . W !,"Entry was DELETED..."
 . Q
 I 'DONE Q
 ;N DIR S DIR("A")="Enter the date the provider was issued this number from CMS: ",DIR(0)="D^:"_$$NOW^XLFDT() D ^DIR Q:Y'>0  S DATEVAL=+Y
 S DATEVAL=$$NOW^XLFDT()
 ; mark previous NPI value as inactive
 I OLDNPI=ADDNPI S DONE=$$ADDNPI^XUSNPI("Individual_ID",IEN,CURRNPI,DATEVAL,0) ; set status to INACTIVE
 S DONE=$$ADDNPI^XUSNPI("Individual_ID",IEN,NPIVAL1,DATEVAL) I +DONE=-1 W !,"Problem writing that value into the database! --  It was **NOT** recorded.",!,$P(DONE,U,2) Q
 W !!,"For provider ",PROVNAME," "_$S('$D(XUSNONED):"(who requires an NPI), ",1:"")_"the NPI ",NPIVAL1,!,"was saved to VistA successfully."
 Q
 ;
CHKOLD1(IEN) ;
 D CHKOLD1^XUSNPIE2(IEN)
 Q
 ;
CLERXMPT ;
 D CLERXMPT^XUSNPIE2
 Q
 ;
CHKDGT(XUSNPI,XUSDA,XUSQI) ; INPUT TRANSFORM
 N XUS S XUS=$$CHKDGT^XUSNPI(XUSNPI)
 I XUS'>0 Q 0
 N XUSQIK S XUSQIK=$$QI^XUSNPI(XUSNPI) I XUSQIK=0 Q 1
 I XUSQIK'=0,$P(XUSQIK,"^",2)'=XUSDA Q 0 ; return zero if the NPI found and not bellong to the current user
 N XUSQIK1 S XUSQIK1=$P(XUSQIK,"^")
 I XUSQI'=XUSQIK1 Q 0
 I $P($P(XUSQIK,"^",4),";")="Inactive" Q 0
 N XUSROOT S XUSROOT=$$GET^XPAR("PKG.KERNEL","XUSNPI QUALIFIED IDENTIFIER",XUSQIK1)
 I $E(XUSROOT)'="^" S XUSROOT="^"_XUSROOT
 N XUS1 S XUS1=XUSROOT_XUSDA_","_"""NPISTATUS"""_","_"""A"""_")"
 N XUS2 S XUS2=$O(@XUS1,-1) I XUS2'>0 Q 1
 S XUS1=XUSROOT_XUSDA_","_"""NPISTATUS"""_","_XUS2_","_0_")"
 S XUS2=$G(@XUS1) I $P(XUS2,"^",3)=XUSNPI Q 1
 Q 0
