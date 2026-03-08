BYIMCOVD ;IHS/CIM/THL - IMMUNIZATION DATA EXCHANGE; [ 03/13/2021  11:10 PM ]
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**1,2**;MAR 15, 2021;Build 493
 ;
 ;----
EN ;EP;TO CREATE COVID ADDITIONAL 'STATE' FOR EXPORT OF COVID VACCINES
 D ENV^BYIMIMM
 S BYIMDUZ=$$DUZ^BYIMIMM()
 I $P($G(^BYIMPARA(BYIMDUZ,0)),U,7)]"",$P($G(^(6)),U,12)="" D
 .S $P(^BYIMPARA(BYIMDUZ,6),U,12)=$P($G(^BYIMPARA(BYIMDUZ,0)),U,7)
 I $P($G(^BYIMPARA(BYIMDUZ,0)),U,8)="" D
 .S $P(^BYIMPARA(BYIMDUZ,0),U,8)="dat"
 I $P($G(^BYIMPARA(BYIMDUZ,0)),U,10)="" D
 .S $P(^BYIMPARA(BYIMDUZ,0),U,10)=0
 I $P($G(^BYIMPARA(BYIMDUZ,0)),U,16)="" D
 .S $P(^BYIMPARA(BYIMDUZ,0),U,16)=0
 I $P($G(^BYIMPARA(BYIMDUZ,0)),U,17)="" D
 .S $P(^BYIMPARA(BYIMDUZ,0),U,17)=3
 I $P($G(^BYIMPARA(BYIMDUZ,6)),U,6)="" D
 .S $P(^BYIMPARA(BYIMDUZ,6),U,6)=3180101
 I $P($G(^BYIMPARA(BYIMDUZ,6)),U,7)="" D
 .S $P(^BYIMPARA(BYIMDUZ,6),U,7)=1
 I $P($G(^BYIMPARA(BYIMDUZ,9)),U,3)="" D
 .S $P(^BYIMPARA(BYIMDUZ,9),U,3)=0
 I $P($G(^BYIMPARA(BYIMDUZ,9)),U,4)="" D
 .S $P(^BYIMPARA(BYIMDUZ,9),U,4)=2
 I $P($G(^BYIMPARA(BYIMDUZ,10)),U,5)="" D
 .S $P(^BYIMPARA(BYIMDUZ,10),U,5)=1
 I '$O(^BYIMPARA(BYIMDUZ,"LAST EXPORT",9999999999),-1) D
 .D NOW^%DTC
 .S ^BYIMPARA(BYIMDUZ,"LAST EXPORT",3201020)=%_U_%
 N STATE
 S STATE=$O(^DIC(5,"B","UNKNOWN",0))
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 S DA(1)=BYIMDUZ
 S DIC="^BYIMPARA("_DA(1)_",3,"
 S DIC("DR")=".06////2;.07////"_$P($G(^AUTTLOC(+$$DUZ^BYIMIMM(),1)),U,3)_";.08////dat;.1////0;.11////4;.14////"_STATE_";.16////0;.17////0;1.03////RPMS;1.08////COVID;6.03////COVID;6.07////1;9.03////0;10.05////1"
 S DIC("DR")=DIC("DR")_";6.12////COVID;9.09////RPMS;9.1////XX;9.11///COVID"
 S DIC(0)="L"
 S (ASNAM,X)="COVID"
 S DA=$O(^BYIMPARA(BYIMDUZ,3,"B","COVID",0))
 I DA S Y=DA
 I 'DA D FILE^DICN
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 S CVDDA=+Y
 D MENU^BYIMIMM6
 S DIE="^BYIMPARA("_BYIMDUZ_",3,"
 S DA(1)=BYIMDUZ
 S DA=CVDDA
 W !!,"The current BYIM Immunization Data Exchange status is displayed above."
 ;D PAUSE^BYIMIMM6
 W !!,"The following process will set up the COVID export for national COVID tracking."
 W !!,"Enter the 'root' directory for the COVID export, e.g.:"
 W !!?10,"/usr2/covid/"
 W !?10,"g:\covid\"
 S DIR(0)="F^1:60"
 S DIR("A")="COVID export 'root' directory"
 S CDIR=$P($$CDIR(),U)
 I CDIR]"" D
 .S SLASH=$S(CDIR["/":"/",1:"\")
 .S SL=$L(CDIR,SLASH)
 .S DIR("B")=$P(CDIR,SLASH,1,SL-2)_SLASH
 W !
 D ^DIR
 ;I X="^" Q
 K DIR
 S ROOT=X
 S SLASH=$S(ROOT["/":"/",1:"\")
 I ROOT]"" S $P(^BYIMPARA(BYIMDUZ,3,CVDDA,0),U,2)=ROOT_$S($E(ROOT,$L(ROOT))'=SLASH:SLASH,1:"")_"export"_SLASH,$P(^(0),U,3)=ROOT_$S($E(ROOT,$L(ROOT))'=SLASH:SLASH,1:"")_"import"_SLASH
 N EXP
 S EXP=+$O(^DIC(19,"B","BYIM IZ AUTO EXPORT",0))
 S EXPDA=+$O(^DIC(19.2,"B",EXP,0))
 S EXPDT=$P($G(^DIC(19.2,EXPDA,0)),U,2)
 I EXPDT="",$P($G(^BYIMPARA(BYIMDUZ,3,CVDDA,0)),U,2)]"" D
 .I EXPDA,'EXPDT D
 ..S DA=0
 ..F  S DA=$O(^DIC(19.2,"B",EXP,DA)) Q:'DA  D
 ...S DIK="^DIC(19.2,"
 ...D ^DIK
 .W !!,"The option 'BYIM IZ AUTO EXPORT' is not currently scheduled to run daily."
 .W !!,"The BYIM auto export is required for COVID reporting."
 .W !,"This setup will start the auto export in OPTION SCHEDULING."
 .K DIR,QUIT
 .S DIR(0)="NO^1:24"
 .S DIR("A",1)="Enter the hour you want the auto export to run"
 .S DIR("A")="Enter a number"
 .W !
 .D ^DIR
 .K DIR,QUIT
 .I Y D
 ..S X1=DT,X2=1
 ..D C^%DTC
 ..N NOW
 ..S NOW=X_"."_$S($L(Y)=1:"0",1:"")_Y_"00"
 ..S X=+$O(^DIC(19,"B","BYIM IZ AUTO EXPORT",0))
 ..S DIC="^DIC(19.2,"
 ..S DIC(0)="L"
 ..S DIC("DR")="2////"_NOW_";6////1D;9////P"
 ..D FILE^DICN
 D RXA114
 K QUIT
 S CDIR=$P($$CDIR(),U)
 D BCOM^BYIMCOV1(CDIR)
 D PAUSE^BYIMIMM6
 S DA=CVDDA
 K DIR
 F  D ASE2^BYIMIMM4 Q:$G(QUIT)
 Q
 ;=====
 ;
XX ;EP;ENVIRONMENT CHECK
 S DA(1)=$$DUZ^BYIMIMM()
 S DA=$O(^BYIMPARA(DA(1),3,"B","COVID",0))
 D:DA
 .S DIK="^BYIMPARA("_DA(1)_",3,"
 .D ^DIK
 S DA=+$O(^DIC(19,"B","BYIM IZ AUTO EXPORT",0))
 S DA=+$O(^DIC(19.2,"B",DA,0))
 D:DA
 .S DIK="^DIC(19.2,"
 .D ^DIK
 ;D EN
 Q
 ;=====
 ;
RUN S ON=$G(^%ZIS(1,+$G(IO("HOME")),"SUBTYPE"))
 S:ON ON=$G(^%ZIS(2,ON,5))
 S RVON=$P(ON,U,4)
 S RVOFF=$P(ON,U,5)
 S BON=$P(ON,U,8)
 S BOFF=$P(ON,U,9)
 W !?2,"OUTPUT CONTROLLER: "
 I '$$VER^INHB(1) W:RVON]"" @RVON W:BON]"" @BON
 W $S($$VER^INHB(1):"RUNNING",1:"NOT RUNNING-Contact IT support")
 W @RVOFF
 W @BOFF
 W !?2,"FORMAT CONTROLLER: "
 I '$$VER^INHB(2) W:RVON]"" @RVON W:BON]"" @BON
 W $S($$VER^INHB(2):"RUNNING",1:"NOT RUNNING-Contact IT support")
 W @BOFF
 W @RVOFF
 Q
 ;=====
 ;
CDIR() ;PEP;RETURNS THE COVID OUTBOUND AND INBOUND DIRECTORIES
 N CDIR,XX
 S CDIR=""
 S BYIMDUZ=+$$DUZ^BYIMIMM()
 S XX="COVI"
 F  S XX=$O(^BYIMPARA(BYIMDUZ,3,"B",XX)) Q:XX=""  I XX["COVID" S CDIR=+$O(^BYIMPARA(BYIMDUZ,3,"B",XX,0)),CDIR=$P($G(^BYIMPARA(BYIMDUZ,3,CDIR,0)),U,2)_U_$P($G(^BYIMPARA(BYIMDUZ,3,CDIR,0)),U,3)
 Q CDIR
 ;=====
 ;
RXA114 ;FIND ALL LOC. OF ENCOUNTER FACILITIES AT WHICH IMMUNIZATIONS ARE
 ;ADMINISTERED
 S BYIMDUZ=$$DUZ^BYIMIMM()
 S CVDDA=$$CVDDA()
 Q:'$G(CVDDA)
 I '$D(ZTQUEUED) W !!?10,"Please standby as immunization Facilities are found..."
 N X,XX,YY,ASUFAC
 ;PATCH 2 CR-12282 FIND LOC. OF ENCOUNTER AND ASUFAC FOR ALL VISITS
 S $P(^BYIMPARA(BYIMDUZ,3,CVDDA,5,0),U,2)="90480.35P"
 N V0,CAT,FAC
 S J=0
 S XX=0
 F  S XX=$O(^AUPNVSIT(XX)) Q:'XX  S V0=$G(^(XX,0)) D:$D(^AUPNVIMM("AD",XX))
 .S J=J+1
 .W:'(J#10000) "/"
 .S CAT=$P(V0,U,7)
 .S FAC=$P(V0,U,6)
 .Q:CAT=""!'FAC
 .Q:"AHOISR"'[CAT
 .S XX(FAC)=""
 S CNT=0
 S XX=0
 F  S XX=$O(XX(XX)) Q:'XX  S L0=$G(^AUTTLOC(XX,0)) D:L0]""
 .Q:$P(L0,U,21)
 .Q:$D(^BYIMPARA(BYIMDUZ,3,CVDDA,5,XX,0))
 .S ^BYIMTMP("SEND","LOC",XX)=""
 .S CNT=CNT+1
 .S ^BYIMPARA(BYIMDUZ,3,CVDDA,5,XX,0)=XX
 .S ^BYIMPARA(BYIMDUZ,3,CVDDA,5,"B",XX,XX)=""
 I '$D(ZTQUEUED) D
 .I 'CNT D  Q
 ..W !!?10,"No additional facilities found for vaccine accountability reporting."
 .W !!?10,"There were ",CNT," facilities found that were not already"
 .W !?10,"referenced for the COVID vaccine accountability list."
 .W !!?10,"These facilities were added for the COVID exports."
 .D PAUSE^BYIMIMM6
 ;PATCH 2 CR-12282 END
 Q
 ;=====
 ;
SSN ;SET PRIMARY AND ADDITIONAL EXPORT STATES SSN PARAMETER TO '0'
 S $P(^BYIMPARA(BYIMDUZ,6),U,7)=0
 N X
 S X=0
 F  S X=$O(^BYIMPARA(BYIMDUZ,3,X)) Q:'X  D
 .S $P(^BYIMPARA(BYIMDUZ,3,X,6),U,7)=0
 Q
 ;=====
 ;
CVDDA() ;EP;TO FIND THE COVID 'STATE'
 N X,Y,Z
 S CVDDA=0
 S X=0
 F  S X=$O(^BYIMPARA(+$$DUZ^BYIMIMM(),3,X)) Q:'X  I $G(^(X,0))["COVID" S CVDDA=X
 Q CVDDA
 ;=====
 ;
