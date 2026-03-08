AUM21042 ;IHS/ASDST/DMJ,SDR,GTH - ICD 9 E CODES FOR FY 2002 ; [ 01/29/2002   4:01 PM ]
 ;;02.1;TABLE MAINTENANCE;**4**;SEP 28,2001
 ;
START ;EP
 ;
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS^AUM21041),";",3))
 ;
 D RSLT("Beginning FY 2002 ICD 9 E-Codes Update.")
 D DASH,ICD9NEW,DASH
 D RSLT("End FY 2002 ICD 9 E-Codes Update.")
 Q
 ; -----------------------------------------------------
ADDOK D RSLT($J("",5)_"Added : "_L)
 Q
ADDFAIL D RSLT($J("",5)_$$M(0)_"ADD FAILED => "_L)
 Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("")
 Q
DIE NEW @($P($T(SVARS^AUM21041),";",3))
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_$$M(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) KILL DA,DIE,DR
 Q
E(L) Q $P($P($T(@L^AUM2104B),";",3),":",1)
DIK NEW @($P($T(SVARS^AUM21041),";",3)) D ^DIK KILL DIK
 Q
FILE NEW @($P($T(SVARS^AUM21041),";",3)) K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC
 Q
M(%) Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
MODOK D RSLT($J("",5)_"Changed : "_L)
 Q
RSLT(%) S ^(0)=$G(^TMP("AUM2104",$J,0))+1,^(^(0))=% D MES(%)
 Q
MES(%) NEW @($P($T(SVARS^AUM21041),";",3)) D MES^XPDUTL(%)
 Q
IXDIC(DIC,DIC0,D,X,DLAYGO) NEW @($P($T(SVARS^AUM21041),";",3))
 S DIC(0)=DIC0
 KILL DIC0
 I '$G(DLAYGO) KILL DLAYGO
 D IX^DIC
 Q Y
 ; -----------------------------------------------------
ICD9NEW ;
 D RSLT($$E("ICD9NEW"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9NEW+AUMI^AUM2104B),";;",2) Q:AUMLN="END"  D 
 . S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 . S DA=+Y,DR="3///"_$S($L($P(AUMLN,U,3)):$P(AUMLN,U,3),1:$P(AUMLN,U,2))_";10///"_$P(AUMLN,U,2)_";100///@;102///@;9999999.04///3011000",DIE="^ICD9(",AUMDA=DA
 . D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
 ; -----------------------------------------------------
ICD9INAC ;
 D RSLT($$E("ICD9INAC"))
 D RSLT($J("",8)_"CODE     DESCRIPTION")
 D RSLT($J("",8)_"----     -----------")
 NEW AUMI,DA,DIE,DR,X
 F AUMI=1:1 S X=$P($T(ICD9INAC+AUMI^AUM2104B),";;",2) Q:X="END"  D
 . S Y=$$IXDIC("^ICD9(","ILX","AB",X)
 . I Y=-1 D RSLT(" CODE '"_X_"' not found (that's OK).") Q
 . S DA=+Y,DIE="^ICD9(",DR="102///3011001"
 . D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of INACTIVE DATE field for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(^ICD9(DA,0),U,1)_$J("",4)_$E($P(^ICD9(DA,0),U,3),1,30))
 .Q
 Q
 ; -----------------------------------------------------
ICD9MOD ;
 D RSLT($$E("ICD9MOD"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9MOD+AUMI^AUM2104B),";;",2) Q:AUMLN="END"  D
 . S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 . S DA=+Y,DR="3///"_$E($P(AUMLN,U,3),1,30)_";10///"_$E($P(AUMLN,U,2),1,245)_";100///@;102///@;2100000///"_DT,DIE="^ICD9(",AUMDA=DA
 . D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
 ; -----------------------------------------------------
 ;
