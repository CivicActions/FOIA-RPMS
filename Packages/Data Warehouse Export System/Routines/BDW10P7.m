BDW10P7 ;ihs/cmi/maw - BDW Patch 7
 ;;1.0;IHS DATA WAREHOUSE;**7**;JAN 23, 2006;Build 65
 ;
ENV ;-- environment check
 I '$$INSTALLD("GIS*3.01*16") D SORRY(2)
 I '$$INSTALLD("BDW*1.0*6") D SORRY(2)
 Q
 ;
INSTALLD(BDGSTAL) ;EP - Determine if patch BDGSTAL was installed, where
 ; BDGSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BDGY,DIC,X,Y
 S X=$P(BDGSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BDGSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 I $P(BDGSTAL,"*",3)="" D IMES Q 1
 S DIC=DIC_+Y_",""PAH"",",X=$P(BDGSTAL,"*",3)
 D ^DIC
 S BDGY=Y
 D IMES
 Q $S(BDGY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BDGSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" Present.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
PRE ;
 ;change option names to remove HOPE
 Q
 ;
POST ;post init
 D FIXMENU  ;ADD BDWCMENU to BDWMENU, add order to others
 D GIS
 Q
 ;
FIXMENU ;
 S X=$$ADD^XPDMENU("BDWMENU","BDWCOVMENU","COEX",98)
 Q
 ;
GIS ;-- run the importer
 D MPORT^BHLU
 K ^INXPORT
 Q
