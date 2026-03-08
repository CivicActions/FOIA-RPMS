BPXRM216 ; IHS/MSC/MIR - Version 2.0 Patch 1016 post routine. ;10-Apr-2025 10:14
 ;;2.0;CLINICAL REMINDERS;**1016**;Feb 04, 2005;Build 32
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
 I '$$INSTALLD("PXRM*2.0*1015") D MES^XPDUTL($$CJ^XLFSTR("Requires pxrm V2.0 patch 1015.  Not installed.",80)) D SORRY(2)
 S IN="EHR*1.1*39",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the EHR patch 39 before installing patch PXRM 2014"
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"EHR patch 35 must be completely installed before installing PXRM patch 2014"
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 D MES^XPDUTL($$CJ^XLFSTR("EHR Patch 39 is installed.",IOM))
 Q
INSTALLD(PXRMSTAL) ;EP - Determine if patch was installed, where
 ; PXRMSTAL is the name of the INSTALL.  E.g "PXRM*2.0*1008".
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
 I $D(^ICPT("B",90653,90653)) K ^ICPT("B",90653,90653) ; just in case
 Q
 ;===============================================================
POST ;Post-install
 Q
