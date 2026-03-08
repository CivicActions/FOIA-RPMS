BEHOEP3 ; GDIT/IHS/FS - Common - BUSA API, Reports Common, Hash API ;29-Jun-2018 09:46;PLS
 ;;1.1;BEH COMPONENTS;**070001**;Mar 20, 2007;Build 10
 ;
 ;
LOGBUSA(AUDTYPE,AUDCAT,AUDACT,AUDCALL,LOGMSG,STATUS,TYPE,EVENT,LOGID,P8) ;EP - BUSA Logs for different actions on Credentialing GUI
 ;Test Call: D LOGBUSA^BEHOEP3(.R,"E^EPCS Credentaling^Description Text^S or F") ZW R
 ;Input Parameters:
 ;TYPE - (Optional) - The type of entry to log (R:RPC Call;W:Web Service
 ;                       Call;A:API Call;O:Other)
 ;                       (Default - A)
 ;CAT - (Required) - The category of the event to log (S:System Event;
 ;                       P:Patient Related;D:Definition Change;
 ;                       O:Other Event)
 ;ACTION - (Required for CAT="P") - The action of the event to log
 ;                       (A:Additions;D:Deletions;Q:Queries;P:Print;
 ;                       E:Changes;C:Copy)
 ;CALL - (Required) - Free text entry describing the call which
 ;                       originated the audit request (Maximum length
 ;                       200 characters)
 ;                       Examples could be an RPC value or calling
 ;                       routine
 ;DESC - (Required) - Free text entry describing the call action
 ;                       (Maximum length 250 characters)
 ;                       Examples could be 'Patient demographic update',
 ;                       'Copied iCare panel to clipboard' or 'POV Entry'
 ;DETAIL - Array of patient/visit records to log. Required for patient
 ;          related events. Optional for other event types
 ;Format: DETAIL(#)=DFN^VIEN^EVENT DESCRIPTION^NEW VALUE^ORIGINAL VALUE
 N DESC
 I $G(AUDTYPE)="",$G(AUDCAT)="",$G(AUDACT)="",$G(AUDCALL)="",$G(LOGMSG)="" Q "-1^Incomplete BUSA Call Parameters."
 I $G(STATUS)="",$G(TYPE)="",$G(EVENT)="" Q -1
 S DESC=$G(LOGMSG)_"|TYPE~"_$G(TYPE)_"|RSLT~"_$G(STATUS)_"|||EP~"_$G(EVENT)_"|"_$G(LOGID)_"|"_$G(P8)_"|"
 I $G(DUZ)>0 D
 .S RSLT=$$LOG^XUSBUSA($G(AUDTYPE),$G(AUDCAT),$G(AUDACT),$G(AUDCALL),$G(DESC))
 I $G(RSLT)'="" Q $G(RSLT)
 Q 1
 ;
VRFYPHSH(RSLT,PROVIEN) ;EP - Return current status of Hash
 ;Verify Profile Hash
 ;INPUT: Provider IEN, RETURN: 0/1
 ;Test Call: D VRFYPHSH^BEHOEP3(.R,"2976") W R
 I $G(PROVIEN)'>0 S RSLT="0^Provider IEN is Mandatory!" Q
 I $$GET1^DIQ(200,PROVIEN_",",9999999.19)="" S RSLT=1 Q
 N PROFHASH
 S PROFHASH=$$GET1^DIQ(200,PROVIEN_",",9999999.19)
 S RSLT=$$HASHNP^BEHOEP2(PROVIEN)=PROFHASH
 Q
 ;
PROVNAME(PROVARRY) ; EP - Select providers by name
 N X,Y
 S Y=1 F  Q:Y<1  D
 .S X="Select "_$S($O(PROVARRY(0)):"Another ",1:"")_"User Name"
 .S Y=$$READ("PO^200:EMQZ",X,"","","I $D(^XUSEC(""PROVIDER"",+Y))")
 .I $G(Y)="^" S PROVARRY="^" Q
 .I +Y>0 S PROVARRY(+Y)=$P(Y,U,2)
 Q
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP - calls reader, returns response
 N DIR,Y,DIRUT,DLAYGO
 S DIR(0)=TYPE
 I $E(TYPE,1)="P",$P(TYPE,":",2)["L" S DLAYGO=+$P(TYPE,U,2)
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
 ;
DTRANGE(STARTDT,ENDDT,EXIT) ;EP - Select Date Range for the report
 S EXIT=0
STARTDT ;EP - Start Date
 N %DT,Y,X
 W ! S %DT="AEXP",%DT(0)=-DT S %DT("A")="Start DATE: " D ^%DT
 W !
 I (Y=-1)&((X=U)!(X="")) S EXIT=1 Q
 G:Y<0 STARTDT
 S STARTDT=Y-.1
ENDDATE ;EP - End Date
 N %DT,Y,X
 W ! S %DT="AEXP",%DT(0)=STARTDT S %DT("A")="End DATE: " D ^%DT
 W !
 I (Y=-1)&((X=U)!(X="")) S EXIT=1 Q
 G:Y<0 ENDDATE
 S ENDDT=Y_.9
 Q
 ;
DISPRMPT() ;EP - PROMPT THE USER TO INCLUDE DISUSERED AND TERMINATED USERS
 ;RETURNS: ^ IF USER QUIT OR TIMED OUT
 ;         OTHERWISE, THE VALUE OF VARIABLE Y
 N DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 S DIR(0)="Y"_U,DIR("A",1)="Do you want to include DISUSERed and TERMINATED users"
 S DIR("A")="in the output",DIR("B")="NO"
 D ^DIR
 Q:$D(DIRUT) U
 Q Y
 ;
CONTINUE() ;EP - PROMPT THE USER
 ;RETURNS: ^ IF USER QUIT OR TIMED OUT
 ;         OTHERWISE, THE VALUE OF VARIABLE Y
 N DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 S DIR(0)="Y"_U
 S DIR("A")="Press RETURN to continue or '^' to exit: ",DIR("B")="YES"
 D ^DIR
 Q:$D(DIRUT) U
 Q Y
 ;
HEADER(TITLE,PAGE,HEADER,HEADER2) ;EP - OUTPUT THE REPORT'S HEADER
 ;PARAMETERS: TITLE  => THE TITLE OF THE REPORT
 ;            PAGE   => (REFERENCE) PAGE NUMBER
 ;            HEADER => (REFERENCE) COLUMN NAMES, FORMATTED AS:
 ;                      COLUMN(LINE_NUMBER)=TEXT
 ;                      NOTE: LINE_NUMBER STARTS AT ONE
 ;RETURNS: 0 => USER WANTS TO CONTINUE PRINTING
 ;         1 => USER DOES NOT WANT TO CONTINUE PRINTING
 I $D(ZTQUEUED),($$S^%ZTLOAD) D  Q 1
 .S ZTSTOP=$$S^%ZTLOAD("Received stop request"),ZTSTOP=1
 N X,END
 S PAGE=+$G(PAGE)+1
 I PAGE>1 D  Q:$G(END) 1
 .I $E(IOST,1,2)="C-" S X=$$CONTINUE,END='$T!(X="^") Q:$G(END)
 .W @IOF
 N NOW,INDEX
 S NOW=$$UP^XLFSTR($$HTE^XLFDT($H)),NOW=$P(NOW,"@",1)_"  "_$P($P(NOW,"@",2),":",1,2)
 W $$LJ^XLFSTR($E(TITLE,1,46),47," ")_NOW_"   PAGE "_PAGE,!
 I $G(PAGE)'=1 S INDEX=0 F  S INDEX=$O(HEADER(INDEX)) Q:'INDEX  W HEADER(INDEX),!
 I $G(PAGE)=1 S INDEX=0 F  S INDEX=$O(HEADER2(INDEX)) Q:'INDEX  W HEADER2(INDEX),!
 W $$REPEAT^XLFSTR("-",(IOM-1)),!
 Q 0
 ;
SENSTIV2(COVERCOL,RPT,DSPLYSD,DSPLYED) ;EP - Display Senstive Label Info in Reports
 N I
 S I=0,I=I+1,COVERCOL(I)="Data Sensitivity Label"
 S I=I+1,COVERCOL(I)="Sensitivity Level:                     "_"Sensitive"
 S I=I+1,COVERCOL(I)="Type of data contained on this media:  "_"CUI:PRVCY"
 S I=I+1,COVERCOL(I)="Date of creation:                      "_$P($$UP^XLFSTR($$HTE^XLFDT($H)),"@",1)
 S:$G(RPT)="PAR" I=I+1,COVERCOL(I)="Date coverage contained on the media:  "_$G(DSPLYSD)_" and "_$G(DSPLYED)
 S:$G(RPT)="" I=I+1,COVERCOL(I)="Date coverage contained on the media:  "_$P($$UP^XLFSTR($$HTE^XLFDT($H)),"@",1)
 S I=I+1,COVERCOL(I)="Data Owner:                            "_$$GET1^DIQ(200,DUZ_",",.01)
 S I=I+1,COVERCOL(I)=""
 Q I
 ;
SENSTIV1(COL,RPT,DSPLYSD,DSPLYED) ;EP - Display Senstive Label Info in Reports
 N I
 S I=0,I=I+1,COL(I)="                           **SENSITIVE INFORMATION**                       "
 S:$G(RPT)="PAR" I=I+1,COL(I)="EPCS Credentialing Audit Events Between:  "_$G(DSPLYSD)_" and "_$G(DSPLYED)
 Q I
 ;
AUDTEVTS(RSLT,DATA) ;EP - Audit Log Events
 ;Loads Audit Log Configuration and perform actions as in configurations.
 ;D AUDTEVTS^BEHOEP3(.R,"Q","EPCS Credentialing","EPCS01","DevEPCSSign") ZW R
 N LOGID,P1,P2,P3
 I $G(DATA)="" S RSLT=0 Q
 S LOGID=$P(DATA,"^",1),P1=$P(DATA,"^",2),P2=$P(DATA,"^",3),P3=$P(DATA,"^",4)
 I $G(LOGID)="" S RSLT=0 Q
 S RSLT=$$AUDCONF(LOGID,P1,P2,P3)
 I RSLT'=1 S RSLT=0 Q
 S RSLT=1
 Q
 ;
AUDCONF(LOGID,P1,P2,P3) ;EP - Audit Configuration
 ; Test Call: W $$AUDCONF^BEHOEP3("EPCS31","2523","EPCS,PROVIDER EDSCIV-V")
 ; Piece 8 is not a part of the EHR technical document. (Optional)
 ; We are saving information in these formats "IEN or IEN~<Activated or Revoked>"
 N LOGIEN,LOGMSG,STATUS,TYPE,EVENT,ACTION,GROUP,AUDACT,AUDCALL,AUDTYPE,AUDCAT,STR,MSGDESC
 S LOGIEN=$O(^BEHOEP(90460.14,"B",$G(LOGID),""))
 I +$G(LOGIEN)'>0 Q 0
 I +$G(LOGIEN)>0 S LOGMSG=$$GET1^DIQ(90460.14,$G(LOGIEN),1) ;AUDIT MESSAGE
 E  Q 0
 I $G(P1)'="" S LOGMSG=$$REPLACE($G(LOGMSG),"<INFO1>",$P(P1,"~",1)) ;Piece 8 for the DESC parameter of the BUSA log API.
 I $G(P2)'="" S LOGMSG=$$REPLACE($G(LOGMSG),"<INFO2>",P2)
 I $G(P3)'="" S LOGMSG=$$REPLACE($G(LOGMSG),"<INFO3>",P3)
 I LOGMSG["<INFO3>" S LOGMSG=$$REPLACE($G(LOGMSG),"<INFO3>","")
 S STATUS=$$GET1^DIQ(90460.14,$G(LOGIEN),2,"I"),TYPE=$$GET1^DIQ(90460.14,$G(LOGIEN),4,"I"),EVENT=$$GET1^DIQ(90460.14,$G(LOGIEN),5,"I")
 S ACTION=$$GET1^DIQ(90460.14,$G(LOGIEN),3,"I"),GROUP=$$GET1^DIQ(90460.14,$G(LOGIEN),6),AUDTYPE=$$GET1^DIQ(90460.14,$G(LOGIEN),7)
 S AUDACT=$$GET1^DIQ(90460.14,$G(LOGIEN),9),AUDCALL=$$GET1^DIQ(90460.14,$G(LOGIEN),10),AUDCAT=$$GET1^DIQ(90460.14,$G(LOGIEN),8)
 S MSGDESC=$$GET1^DIQ(90460.14,$G(LOGIEN),11)
 I $G(MSGDESC)="" S MSGDESC=$G(LOGMSG)
 I $G(MSGDESC)="",$G(LOGMSG)="",$G(GROUP)="",$G(ACTION)="" Q 0
 I (($G(ACTION)="M")!($G(ACTION)="B")),$G(GROUP)'="" D MAILMAN^BEHOEP7(.STR,MSGDESC,LOGMSG,GROUP)
 I $G(ACTION)="M" Q 1
 I $G(STATUS)="",$G(TYPE)="",$G(EVENT)="",$G(AUDTYPE)="",$G(AUDCAT)="",$G(AUDACT)="",$G(AUDCALL)="" Q 0
 I ($G(ACTION)="A")!($G(ACTION)="B") S STR=$$LOGBUSA^BEHOEP3(AUDTYPE,AUDCAT,AUDACT,AUDCALL,LOGMSG,STATUS,TYPE,EVENT,LOGID,$G(P1)) ;Piece 8 - Additional Information
 I (($G(ACTION)="A")!($G(ACTION)="B")),+$G(STR)'>0 Q STR
 Q 1
 ;
 ;GDIT/IHS/BEE - Added REPLACE
REPLACE(STRING,FROM,TO) ;Replace FROM string with TO string in STRING
 ;
 I $G(STRING)="" Q ""
 I $G(FROM)="" Q STRING
 S TO=$G(TO)
 ;
 NEW RPLC
 ;
 S RPLC(FROM)=TO
 Q $$REPLACE^XLFSTR(STRING,.RPLC)
 ;
