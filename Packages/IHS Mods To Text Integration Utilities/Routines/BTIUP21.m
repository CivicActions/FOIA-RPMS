BTIUP21 ; IHS/CIA/MGH - SETUP FOR PATCH 1021;15-May-2019 14:52;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1021**;SEPT 04, 2005;Build 11
 ;
ENV ;EP environment check
 N PATCH,IN,STAT,INSTDA
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="TIU*1.0*1020"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 S PATCH="USR*1.0*1005"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
PRE ;EP; beginning of pre install code
 Q
POST ;EP; beginning of post install code
 N DTOUT,DUOUT,TIU,TIUFPRIV,TIUIEN,TIUIEN2,TIUMSG,TIUPRNT,TIUTMP S TIUFPRIV=1
 ;Add progress note
 I $$LOOKUP(8930,"CLINICAL COORDINATOR","X")<0 W !!,"Installation Error:  CLASS OWNER cannot be defined." S XPDABORT=1 G EXIT
 S TIUIEN(1)=$$LOOKUP(8925.1,"PRENATAL CARE NOTE-BRIEF","X")
 I TIUIEN(1)>0 W !!,"PRENATAL CARE NOTE-BRIEF already exists." G EXIT
 F  D  Q:TIUPRNT>0!($D(XPDABORT))
 . W ! S TIUPRNT=$$LOOKUP(8925.1,,"AEQ","I $P(^(0),U,4)=""DC""","Select TIU DOCUMENT CLASS name for the new title PRENATAL CARE NOTE-BRIEF:  ")
 . I $D(DTOUT) W !!,"Installation Aborted due to TIMEOUT." S XPDABORT=1 Q
 . I $D(DUOUT) W !!,"Installation Aborted by USER." S XPDABORT=1 Q
 . I TIUPRNT<0 W !!,"Installation Error:  Invalid Selection",!
 . I  W !,"A DOCUMENT CLASS must be entered or '^' to abort." Q
 . W ! I '$$READ^TIUU("Y","Is this correct","YES") S TIUPRNT=0
 I +$G(TIUPRNT)'>0 G EXIT
 N DIC,DLAYGO,X,Y
 S DIC="^TIU(8925.1,"
 S DLAYGO=8925.1,DIC("P")=DLAYGO,DIC(0)="LOX"
 S X="PRENATAL CARE NOTE-BRIEF"
 K DO,DD D FILE^DICN
 I +Y>0 D
 .S TIUIEN(1)=+Y
 .S AIEN=+Y_","
 .;S TIU(8925.1,AIEN,.01)="PRENATAL CARE NOTE-BRIEF"
 .S TIU(8925.1,AIEN,.02)=""
 .S TIU(8925.1,AIEN,.03)="PRENATAL CARE NOTE-BRIEF"
 .S TIU(8925.1,AIEN,.04)="DOC"
 .S TIU(8925.1,AIEN,.05)=""
 .S TIU(8925.1,AIEN,.06)=$$LOOKUP(8930,"CLINICAL COORDINATOR")
 .S TIU(8925.1,AIEN,.07)=13
 .S TIU(8925.1,AIEN,3.02)=1
 .S TIU(8925.1,AIEN,99)=$H
 .W !!,"Creating PRENATAL CARE NOTE-BRIEF title..."
 .K TIUMSG
 .D FILE^DIE("","TIU","TIUMSG")
 .I $D(TIUMSG) D  S XPDABORT=1 G EXIT
 .. W !!,"The following error message was returned:",!
 .. S TIUMSG="" F  S TIUMSG=$O(TIUMSG("DIERR",1,"TEXT",TIUMSG)) Q:TIUMSG=""  W !,TIUMSG("DIERR",1,"TEXT",TIUMSG)
 .W "DONE."
 .S TIU(8925.14,"+1,"_TIUPRNT_",",.01)=TIUIEN(1)
 .S TIU(8925.14,"+1,"_TIUPRNT_",",4)="Prenatal Care Note-Brief"
 .W !!,"Adding "_$P(^TIU(8925.1,TIUPRNT,0),U)_" as parent..."
 .D UPDATE^DIE("","TIU","TIUIEN2","TIUMSG")
 .I $D(TIUMSG) D  S XPDABORT=1 G EXIT
 .. W !!,"The following error message was returned:",!
 .. S TIUMSG="" F  S TIUMSG=$O(TIUMSG("DIERR",1,"TEXT",TIUMSG)) Q:TIUMSG=""  W !,TIUMSG("DIERR",1,"TEXT",TIUMSG)
 .W "DONE.",!
 .S TIUIEN(TIUIEN(1))=TIUIEN(1)
 .S TIU(8925.1,TIUIEN(1)_",",3)="TIUTMP"
 .I $D(TIUMSG) D  S XPDABORT=1 G EXIT
 .. W !!,"The following error message was returned:",!
 .. S TIUMSG="" F  S TIUMSG=$O(TIUMSG("DIERR",1,"TEXT",TIUMSG)) Q:TIUMSG=""  W !,TIUMSG("DIERR",1,"TEXT",TIUMSG)
 .W "DONE.",!
 .W !,"*** The PRENATAL CARE NOTE-BRIEF***"
 .W !,"*** title must be activated before use.     ***"
EXIT I +TIUIEN(1)>0 D
 .D LOADBOIL(+TIUIEN(1))
 W !,"*** Boilerplate data loaded ***"
 ;D
 ;.N DIR,X,Y S DIR(0)="E" W ! D ^DIR
 Q
REM ;
 N TIUTMP
 S TIUTMP=$$LOOKUP(8925.1,"PRENATAL CARE NOTE-BRIEF")
 I TIUTMP>0 S $P(^TIU(8925.1,TIUTMP,0),U,13)=0
 Q
LOOKUP(FILE,NAME,TYPE,SCREEN,PROMPT) ;
 ; file = file # to perform lookup on
 ; [name]   = for instance lookups - required if type is missing
 ; [type]   = for inquiries to file (eg: "AEQ") - required if name is missing
 ; [screen] = screen for lookup/inquiries
 ; [prompt] = replace default prompt
 ;
 N DIC,X,Y S DIC=$G(FILE),DIC("S")=$G(SCREEN),X=$G(NAME)
 I $D(TYPE) S DIC(0)=TYPE
 I $D(PROMPT) S DIC("A")=PROMPT
 D ^DIC
 Q +Y
 Q
 ;
LOADBOIL(TIEN) ;Load the boilerplate text
 N TIUI,TIUJ
 K ^TMP("TIUBOIL",$J)
 S ^TMP("TIUBOIL",$J,1)="|PATIENT NAME| is a |PATIENT AGE| year old here for:"
 S ^TMP("TIUBOIL",$J,2)="|V CHIEF COMPLAINT|"
 S ^TMP("TIUBOIL",$J,3)="--- See also OB notes in A/P section below ---"
 S ^TMP("TIUBOIL",$J,4)=""
 S ^TMP("TIUBOIL",$J,5)="EDC: |EDC-EXPANDED|"
 S ^TMP("TIUBOIL",$J,6)="___________________________________________________________"
 S ^TMP("TIUBOIL",$J,7)="Allergies"
 S ^TMP("TIUBOIL",$J,8)="|ALLERGIES/ADR|"
 S ^TMP("TIUBOIL",$J,9)=""
 S ^TMP("TIUBOIL",$J,10)="Medications reviewed and updated. Refer to medication tab."
 S ^TMP("TIUBOIL",$J,11)=""
 S ^TMP("TIUBOIL",$J,12)="Problem and pregnancy issue lists reviewed and updated."
 S ^TMP("TIUBOIL",$J,13)=""
 S ^TMP("TIUBOIL",$J,14)="Prenatal health summary reviewed."
 S ^TMP("TIUBOIL",$J,15)="____________________________________________________________"
 S ^TMP("TIUBOIL",$J,16)="OBJECTIVE --- See also OB notes in A/P section below ---"
 S ^TMP("TIUBOIL",$J,17)="|V MEASUREMENT|"
 S ^TMP("TIUBOIL",$J,18)=""
 S ^TMP("TIUBOIL",$J,19)="Lab Review:"
 S ^TMP("TIUBOIL",$J,20)="|V ABNORMAL LABS|"
 S ^TMP("TIUBOIL",$J,21)=""
 S ^TMP("TIUBOIL",$J,22)="A/P --- See also Pregnancy Issues and Problem list for comprehensive"
 S ^TMP("TIUBOIL",$J,23)="goals and care plans"
 S ^TMP("TIUBOIL",$J,24)=""
 S ^TMP("TIUBOIL",$J,25)="|V PROB W/TODAYS OB NOTE&CARE PLANS|"
 S ^TMP("TIUBOIL",$J,26)="______________"
 S ^TMP("TIUBOIL",$J,27)="CPT codes/procedures for today"
 S ^TMP("TIUBOIL",$J,28)="|V CPT|"
 S ^TMP("TIUBOIL",$J,29)=""
 S ^TMP("TIUBOIL",$J,30)="Today's Orders"
 S ^TMP("TIUBOIL",$J,31)="|V ORDERS|"
 S ^TMP("TIUBOIL",$J,29)=""
 S ^TMP("TIUBOIL",$J,30)="Today's Education"
 S ^TMP("TIUBOIL",$J,31)="|V EDUCATION TOPICS|"
 S TIUI=0 F  S TIUI=$O(^TMP("TIUBOIL",$J,TIUI)) Q:+TIUI'>0  D
 .S TIUJ=+$G(TIUJ)+1
 .S ^TIU(8925.1,TIEN,"DFLT",TIUI,0)=$G(^TMP("TIUBOIL",$J,TIUI))
 S ^TIU(8925.1,TIEN,"DFLT",0)="^^"_TIUJ_"^"_TIUJ_"^"_DT_"^^"
 K ^TMP("TIUBOIL",$J)
 Q
