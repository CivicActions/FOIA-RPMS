BDGP21PS ;ihs/cmi/maw - PIMS Patch 1021 env checker
 ;;5.3;PIMS;**1021**;MAY 28, 2004;Build 5
 ;
ENV ;-- environment check
 I '$$INSTALLD("XU*8.0*1020") D SORRY(2)
 I '$$INSTALLD("DI*22.0*1020") D SORRY(2)
 I '$$INSTALLD("PIMS*5.3*1020") D SORRY(2)
 Q
 ;
POST ;post init entry point
 D ADTITM
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
ADTITM ;-- modify code in item
 N ITEM,CODE,FDA,FERR,FIENS
 S ITEM=$O(^BDGITM("B","SSN WITH DASHES",0))
 Q:'ITEM
 S CODE=$G(^BDGITM(ITEM,1))
 S CODE=";"_CODE
 S FIENS=ITEM_","
 S FDA(9009016.9,FIENS,1)=CODE
 D FILE^DIE("K","FDA","FERR(1)")
 Q
 ;
