BSDP22PS ;ihs/cmi/maw - PIMS Patch 1022 Post Init and Environment
 ;;5.3;PIMS;**1022**;MAY 28, 2004;Build 18
 ;
 ;
ENV ;-- environment check
 I '$$INSTALLD("XU*8.0*1018") D SORRY(2)
 I '$$INSTALLD("DI*22.0*1018") D SORRY(2)
 I '$$INSTALLD("AUPN*99.1*29") D SORRY(2)
 I '$$INSTALLD("PIMS*5.3*1021") D SORRY(2)
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
 ;
POST ;-- post init
 D SETEMB
 Q
 ;
SETEMB ;-- 97821 p1022 set the embossed card name to look at PPN
 N NM
 S NM=$O(^DIC(39.2,"B","NAME",0))
 Q:'NM
 S ^DIC(39.2,NM,1)="S Y="""" S Y=$$GETPREF^AUPNSOGI(DFN,""E"",1)"
 Q
 ;
