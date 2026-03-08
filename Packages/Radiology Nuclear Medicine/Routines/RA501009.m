RA501009 ;ihs/cmi/maw - Radiology 5.0 Patch 1008 Environment Check
 ;;5.0;Radiology/Nuclear Medicine;**1009**;Mar 16, 1998;Build 21
 ;
 ;
ENV ;-- environment checkl
 D ENVC("XU","8.0","1018")
 Q:$G(XPDABORT)
 D ENVC("DI","22.0","1018")
 Q:$G(XPDABORT)
 D ENVC("RA","5.0","1008")
 Q:$G(XPDABORT)
 I '$D(^DD(75.2,5,0)),$$PATCH^XPDUTL("RA*5.0*1009") S RA51009I=1
 W !,"Environment OK!"
 Q
 ;
ENVC(MODULE,VERSION,PATCH) ;-- check to make sure 1008 is installed
 ;N MODULE,VERSION,PATCH
 ;S MODULE="RA"
 ;S VERSION="5.0"
 ;S PATCH=1008
 W !,"Checking for "_MODULE_" Version: "_VERSION_" Patch: "_PATCH
 S SYSPATCH=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 I 'SYSPATCH W !,"Patch "_PATCH_" is required before this can be installed." S XPDABORT=1
 Q
 ;
POST ;-- post init
 ;ADD MODULE PCC LINK ENTRY FOR RADIOLOGY SO VISIT MERGE WILL CHANGE VISIT PTS
 I '$G(RA51009I) D  ;indicates build not installed yet
 . D MODPCC
 . D DELOPT("RA EXAMSTATUS MASS OVERRIDE","RA SUPERVISOR")
 . D DELOPT("RA PROC CPTWRVU","RA SPECRPTS")
 . D DELOPT("RA WKLIPHY SWRVU ITYPE","RA WKL")
 . D DELOPT("RA WKLIPHY SWRVU CPT","RA WKL")
 . D ADDOPT("BRA MARK ORDERS AS DISC","RA MAINTENANCE","ODSC")
 . D ADDOPT("RA ORDERREASON UPDATE","RA ORDER","UHR")
 . D PAH
 . D VA  ;run va patch post inits
 . D REASON
 I $G(RA51009I) D REASON
 Q
MODPCC ;
 D BMES^XPDUTL("Adding Radiology to PCC Visit Merge Utility . . .")
 Q:$D(^APCDLINK("B","RADIOLOGY"))  ;already exists
 NEW DD,DO,DIC,DLAYGO,X,Y
 S DIC="^APCDLINK(",DIC(0)="LE",DLAYGO=9001002
 S DIC("DR")="1///I $L($T(MRG^BRAPCC1)) D MRG^BRAPCC1"
 S DIC("DR")=DIC("DR")_";.02///RADIOLOGY/NUCLEAR MEDICINE"
 S X="RADIOLOGY" D FILE^DICN
 Q
 ;
DELOPT(OPT,MEN) ;-- delete an option from a menu
 S X=$$DELETE^XPDMENU(MEN,OPT)
 Q
 ;
ADDOPT(OPT,MEN,SYN) ;-- add option to a menu
 S X=$$ADD^XPDMENU(MEN,OPT,SYN)
 Q
 ;
VA ;-- run VA Post Inits
 W !,"Running Post Init for VA Patches..."
 W !,"VA Patch 119..."
 D ^RAIPS119
 W !,"VA Patch 124..."
 D ^RAIPS124
 W !,"VA Patch 135..."
 D ^RAIPS135
 W !,"VA Patch 144..."
 D ^RAIPS144
 W !,"VA Patch 148..."
 D ^RA148PST
 W !,"VA Patch 160..."
 D ^RAIPS160
 W !,"VA Patch 162..."
 D ^RAIPS162
 W !,"VA Patch 165..."
 D ^RAIPS165
 W !,"VA Patch 169..."
 D ^RAIPS169
 Q
 ;
REASON ;-- update the RAD/NUC MED REASON file
 W !!,"Updating RAD/NUC MED REASON FILE..."
 W !,"VA Patch 133..."
 D ^RAI133PO  ;reason
 W !,"VA Patch 158..."
 D ^RAIPS158  ;reason
 W !,"VA Patch 163..."
 D ^RAIPS163  ;reason
 W !,"VA Patch 167..."
 D ^RAIPS167  ;reason
 W !,"VA Patch 168..."
 D ^RAIPS168  ;reason
 W !,"VA Patch 171..."
 D ^RAIPS171  ;reason
 W !,"VA Patch 172..."
 D ^RAIPS172  ;reason
 Q
 ;
PAH ;-- update the Patch Application History
 N BDA,BRADATA,BRADG,BRADGS,BRA,BRA50,STRI,LINE,TAG
 S BRA=$O(^DIC(9.4,"C","RA",0))
 Q:'BRA
 S BRA50=$O(^DIC(9.4,BRA,22,"B","5.0",0))
 Q:'BRA50
 D NOW^%DTC
 S BRANOW=$S(%:%,1:DT)
 W !,"Updating the RA Package file entry for Patch Application History"
 S TAG="PTCHLST"
 F LINE=1:1  S STRI=$T(@TAG+LINE) Q:STRI["$$END"  D
 . S BRADATA=$P(STRI,";",3)
 . S BRADGS=$P(BRADATA,U)
 . S BRADG=$P(BRADATA,U,2)
 . Q:$$PATCH^XPDUTL("RA*5.0*"_BRADG)  ;patch already there
 . W "."
 . D RAUP(BRA,BRA50,BRADG,BRADGS)
 K BRANOW
 Q
 ;
RAUP(RA,RA50,RADG,RADGS) ;--update RA PAH node
 N CDA,MATCH,STR
 S MATCH=0
 S CDA=0 F  S CDA=$O(^DIC(9,4,RA,22,RA50,"PAH",CDA)) Q:'CDA  D
 . I $P(CDA," ")=RADG S MATCH=1
 Q:$G(MATCH)
 N DDA,DIENS,DERR
 S DIENS(2)=RA
 S DIENS(1)=RA50
 S DIENS="+3,"_RA50_","_RA_","
 S STR=RADG  ;_" SEQ #"_RADGS  ;only put patch in there
 S DDA(9.4901,DIENS,.01)=STR
 S DDA(9.4901,DIENS,.02)=BRANOW
 S DDA(9.4901,DIENS,.03)=DUZ
 D UPDATE^DIE("","DDA","DIENS","DERR(1)")
 Q
 ;
PTCHLST ;-- patch listing
 ;;111^126
 ;;112^125
 ;;113^131
 ;;114^129
 ;;115^127
 ;;116^134
 ;;117^133
 ;;118^130
 ;;120^140
 ;;121^138
 ;;122^119
 ;;123^136
 ;;124^141
 ;;125^137
 ;;126^132
 ;;127^135
 ;;128^143
 ;;129^147
 ;;130^145
 ;;131^144
 ;;132^149
 ;;133^151
 ;;134^124
 ;;135^150
 ;;136^148
 ;;137^153
 ;;138^154
 ;;139^156
 ;;140^159
 ;;141^155
 ;;142^158
 ;;143^157
 ;;144^163
 ;;145^162
 ;;146^161
 ;;147^167
 ;;148^168
 ;;149^166
 ;;150^171
 ;;151^165
 ;;152^172
 ;;153^169
 ;;154^160
 ;;155^173
 ;;$$END
 Q
 ;
