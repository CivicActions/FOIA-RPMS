BPXR2010 ; IHS/MSC/MGH - Version 2.0 Patch 2010 environment check routine ;27-Mar-2023 16:48
 ;;2.0;CLINICAL REMINDERS;**2010**;Feb 04, 2005;Build 33
 ;
ENV ;EP environment check
 N IN,INSTDA,STAT
 ;Check for the installation of Reminders 2.0
 S IN="CLINICAL REMINDERS 2.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install CLINICAL REMINDERS 2.0 before this patch" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"CLINICAL REMINDERS 2.0 must be completely installed before installing this patch." S XPDQUIT=2
 ;
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;Check for the installation of other patches
 I '$$INSTALLD("PXRM*2.0*1013") D MES^XPDUTL($$CJ^XLFSTR("Requires pxrm V2.0 patch 1013.  Not installed.",80)) D SORRY(2)
 I '$$INSTALLD("PXRM*2.0*2009") D MES^XPDUTL($$CJ^XLFSTR("Requires pxrm V2.0 patch 2009.  Not installed.",80)) D SORRY(2)
 I '$$INSTALLD("ACPT*2.23*1") D MES^XPDUTL($$CJ^XLFSTR("Requires acpt V2.23 patch 1.  Not installed.",80)) D SORRY(2)
 I '$$INSTALLD("BI*8.5*1014") D MES^XPDUTL($$CJ^XLFSTR("Requires bi V8.5 patch 1014.  Not installed.",80)) D SORRY(2)
 Q
INSTALLD(PXRMSTAL) ;EP - Determine if patch was installed, where
 ; PXRMSTAL is the name of the INSTALL.  E.g "PXRM*2.0*2004".
 ;
 NEW PXRMY,DIC,X,Y,D
 S X=$P(PXRMSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(PXRMSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(PXRMSTAL,"*",3)
 D ^DIC
 S PXRMY=Y
 D IMES
 Q $S(PXRMY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_PXRMSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numb
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;===============================================================
PRE ;EP pre-init
 N VIEN,VSTA,CPT
 F CPT="91309","0094A" D
 .S VIEN=$$VFND^ACPTVAC(CPT)       ; FIND VACCINE FOR CPT CODE
 .S VSTA=$$VSI^ACPTVAC(VIEN)       ; GET VACCINE STATUS
 .I 'VSTA D VTA^ACPTVAC(VIEN,1)    ; IF THE VACCINE IS NOT ACTIVE, TEMP ACTIVATE
 Q
 ;===============================================================
POST ;Post-install
 F CPT="91309","0094A" D
 .S VIEN=$$VFND^ACPTVAC(CPT)       ; FIND VACCINE FOR CPT CODE
 .S VSTA=$$VSI^ACPTVAC(VIEN)       ; GET VACCINE STATUS
 .I +VSTA=3 D VTR^ACPTVAC(VIEN,1)  ; IF THE VACCINE IS ACTIVE, DE-ACTIVATE IT
 Q
 ;
CVIMM ;Create cross-reference for V IMMUNIZATION.
 N MSG,RESULT,XREF
 D BMES^XPDUTL("Creating V Immunization cross-reference.")
 ;Set the XREF nodes
 S XREF("FILE")=9000010.11
 S XREF("ROOT FILE")=9000010.11
 S XREF("SET")="D SVFILE^PXPXRM(9000010.11,.X,.DA)"
 S XREF("KILL")="D KVFILE^PXPXRM(9000010.11,.X,.DA)"
 S XREF("WHOLE KILL")="K ^PXRMINDX(9000010.11)"
 D SXREFVF(.XREF,"immunization")
 D CREIXN^DDMOD(.XREF,"k",.RESULT,"","MSG")
 Q
SXREFVF(XREF,ITEM) ;Set XREF array nodes common for all V files.
 N UITEM
 S UITEM=$$UP^XLFSTR(ITEM)
 S XREF("TYPE")="MU"
 S XREF("NAME")="ACR"
 S XREF("SHORT DESCR")="Clinical Reminders index."
 S XREF("DESCR",1)="This cross-reference builds two indexes, one for finding"
 S XREF("DESCR",2)="all patients with a particular "_ITEM_" and one for finding all"
 S XREF("DESCR",3)="the "_ITEM_"s a patient has."
 S XREF("DESCR",4)="The indexes are stored in the Clinical Reminders index global as:"
 S XREF("DESCR",5)=" ^PXRMINDX("_XREF("FILE")_",""IP"","_UITEM_",DFN,VISIT DATE,DAS) and"
 S XREF("DESCR",6)=" ^PXRMINDX("_XREF("FILE")_",""PI"",DFN,"_UITEM_",VISIT DATE,DAS)"
 S XREF("DESCR",7)="respectively."
 S XREF("DESCR",8)="For all the details, see the Clinical Reminders Index Technical Guide/Programmer's Manual."
 S XREF("USE")="ACTION"
 S XREF("EXECUTION")="R"
 S XREF("ACTIVITY")="IR"
 S XREF("VAL",1)=.01
 S XREF("VAL",1,"SUBSCRIPT")=1
 S XREF("VAL",2)=.02
 S XREF("VAL",2,"SUBSCRIPT")=2
 S XREF("VAL",3)=.03
 S XREF("VAL",3,"SUBSCRIPT")=3
 Q
