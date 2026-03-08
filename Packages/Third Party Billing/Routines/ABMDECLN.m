ABMDECLN ; IHS/SD/DMJ - Clean line itms claim file ;
 ;;2.6;IHS 3P BILLING SYSTEM;**33,34,35,36,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/SD/SDR 2.5*8 task 6 Added code to rebuild new ambulance page 8K
 ;IHS/SD/SDR 2.5*10 IM19901 Modified to make it leave completed insurers instead of rebuilding them, making them active again
 ;
 ;IHS/SD/SDR 2.6*33 ADO60185 CR11502 Added preferred name to display
 ;IHS/SD/SDR 2.6*34 ADO60694 Updated to remove DRG if rebuilding the 17 multiple of the claim so it starts fresh from the visit
 ;IHS/SD/SDR 2.6*35 ADO60700 Added API calls for claim generator report
 ;IHS/SD/SDR 2.6*36 ADO76210 Changed RBCL to only rebuild the selected sections, not run the whole claim generator for the patient
 ;IHS/SD/SDR 2.6*37 ADO81491 Updated preferred name PPN to use XPAR site parameter
 ;
 ;Ask user for claim number
 ;N ABMCLM,ABMVDFN  ;abm*2.6*36 IHS/SD/SDR ADO76210
 K ABMCLM,ABMP("VDFN")  ;abm*2.6*36 IHS/SD/SDR ADO76210
 W !
 W !,"WARNING this option deletes the data from selected pages (subfiles) of the"
 W !,"claim file.  Then it looks to see if the data can be rebuilt from PCC."
 W !,"For some pages there is no data in PCC.  For some the data may be missing."
 W !,"The data will only be rebuilt if the information exists in PCC.",!
 S DIC="^ABMDCLM(DUZ(2),"
 S DIC(0)="AEMNQ"
 S DIC("W")="S Z=$P($G(^ABMDCLM(DUZ(2),+Y,0)),""^"") D DICW^ABMDECLN"
 D ^DIC
 Q:Y=-1
 S ABMCLM=+Y
 ;start new abm*2.6*33 IHS/SD/SDR ADO60185
 S ABMP("PDFN")=$P($G(^ABMDCLM(DUZ(2),+Y,0)),U)
 ;I $$GETPREF^AUPNSOGI(ABMP("PDFN"),"")'="" D ;abm*2.6*37 IHS/SD/SDR ADO81491
 ;.W !?5,"Preferred Name: ",$$EN^ABMVDF("RVN"),$$GETPREF^AUPNSOGI(ABMP("PDFN"),""),$$EN^ABMVDF("RVF") ;abm*2.6*37 IHS/SD/SDR ADO81491
 W !?5,"Date of Service: ",$$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),+Y,7)),U))
 ;end new abm*2.6*33 IHS/SD/SDR ADO60185
 K ABM,DTOUT,DUOUT,DIRUT,DIROUT
 S Y=$P($G(^ABMDPARM(DUZ(2),1,0)),U,16)
 I Y D  Q:'Y
 .S X1=DT
 .S X2=-Y*30.417
 .D C^%DTC
 .Q:X<$P(^ABMDCLM(DUZ(2),ABMCLM,0),U,2)
 .W !,"The date of this claim is prior to the backbilling limit.  As a result items"
 .W !,"will not be rebuilt from PCC.  If you continue, you can only delete items.",!
 .S DIR(0)="Y"
 .S DIR("A")="Do you wish to continue"
 .S DIR("B")="No"
 .D ^DIR
 K ABM,DTOUT,DUOUT,DIRUT,DIROUT
 I '$D(^ABMDCLM(DUZ(2),ABMCLM,11,+$O(^ABMDCLM(DUZ(2),ABMCLM,11,0)),0)) D  Q:'Y
 .W !,"There are no PCC visits corresponding to this claim.  As a result there is no"
 .W !,"PCC data to rebuild from.  If you continue, you can only delete items.",!
 .S DIR(0)="Y"
 .S DIR("A")="Do you wish to continue"
 .S DIR("B")="No"
 .D ^DIR
 ;
 ;start new abm*2.6*36 IHS/SD/SDR ADO76210
 S ABMP("VDFN")=0,ABMCCNT=0,ABMMLTC=0
 K ABMCLST
 F  S ABMP("VDFN")=$O(^ABMDCLM(DUZ(2),ABMCLM,11,ABMP("VDFN"))) Q:'ABMP("VDFN")  D
 .S ABMI=0
 .F  S ABMI=$O(^ABMDCLM(DUZ(2),"AV",ABMP("VDFN"),ABMI)) Q:'ABMI  D
 ..I '$G(ABMCLST(ABMI)) S ABMCLST(ABMI)=1,ABMCCNT=+$G(ABMCCNT)+1
 I (ABMCCNT>1) D  Q:$D(DIRUT)
 .W !!!,"There are multiple claims associated with the visit(s) for the selected claim:"
 .W !!?13,"Visit"
 .W !?3,"Claim#",?14,"Type",?20,"Clinic"
 .S ABMI=0
 .F  S ABMI=$O(ABMCLST(ABMI)) Q:'ABMI  D
 ..W !?3,ABMI,?14,$P($G(^ABMDCLM(DUZ(2),ABMI,0)),U,7),?20,$P($G(^DIC(40.7,$P($G(^ABMDCLM(DUZ(2),ABMI,0)),U,6),0)),U)
 .W !!?2,"Either the SCMG, SCIN, or STIN option was used to split this claim."
 .W !?2,"We don't know which data was split so all data will be put back on"
 .W !?2,"the claim you select and will need to be reviewed carefully, assuming"
 .W !?2,"you continue with the rebuild.",!
 .S DIR(0)="Y"
 .S DIR("A")="Are you sure you want to continue"
 .S DIR("B")="No"
 .D ^DIR
 .Q:'Y
 Q:$D(DIRUT)!'Y
 ;end new abm*2.6*36 IHS/SD/SDR ADO76210
 ;
 ;E  D  Q:$D(DIRUT)  ;abm*2.6*36 IHS/SD/SDR ADO76210
 I $D(^ABMDCLM(DUZ(2),ABMCLM,11,+$O(^ABMDCLM(DUZ(2),ABMCLM,11,0)),0)) D  Q:$D(DIRUT)  ;abm*2.6*36 IHS/SD/SDR ADO76210
 .S DIR(0)="Y"
 .S DIR("A")="Do you wish to view PCC visit information before continuing"
 .S DIR("B")="No"
 .D ^DIR
 .Q:'Y
 .S ABMI=0
 .F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMCLM,11,ABMI)) Q:'ABMI  D
 ..S APCDVDSP=ABMI
 ..D ^APCDVDSP
 .K ABMI,DIR
 ;
 ;Get list of subfiles and display to user.
 S DIC="^DD(9002274.3,"
 S DR=".01;.2;.4"
 S DIQ="ABM"     ;DIQ1 puts value into ABM array
 S DIQ(0)="I"
 F DA=13:2:47 D EN^DIQ1
 N PG
 F I=0:1:14 D
 .S Y=$T(PAGE+I)
 .S PG($P(Y,U,2))=$P($P(Y,U),";",3)
 W !!
 S I=0
 F  S I=$O(ABM(0,I)) Q:'I  D
 .Q:(I=15)  ;skip APC Visit; it's not used anymore  ;abm*2.6*36 IHS/SD/SDR ADO76210
 .Q:ABM(0,I,.2,"I")'["P"
 .I $X>35 W !
 .E  W ?40
 .;W I,"  ",ABM(0,I,.01,"I") W:$D(PG(I)) "  (P-",PG(I),")"  ;abm*2.6*36 IHS/SD/SDR ADO76210
 .W I,"  ",ABM(0,I,.01,"I") W:$D(PG(I)) " "_$S(I=45:"Transcodes",1:" (P-"_PG(I)_")")  ;abm*2.6*36 IHS/SD/SDR ADO76210
 ;Ask user for list of subfiles to clean out
 W !
 K DIR
 S DIR("A")="Enter subfile number or list of subfiles to clean out"
 ;S DIR(0)="LC^13:47:0^K:'$D(ABM(0,+X)) X"  ;abm*2.6*36 IHS/SD/SDR ADO76210
 S DIR(0)="LC^13:47:0^K:'$D(ABM(0,+X))!(X=15) X"  ;abm*2.6*36 IHS/SD/SDR ADO76210
 S DIR("?")="Enter one number from the above list or a list or a range."
 S DIR("??")="^D HELP^ABMDECLN"
 D ^DIR
 I $D(DIRUT) G Q
 ;Clean out the list of selected subfiles
 W !!,"Rebuilding your selection...give me just a minute"  ;abm*2.6*36 IHS/SD/SDR ADO76210
 S ABMCGIEN=$$EN^ABMCGAPI("","RBCL")  ;abm*2.6*35 IHS/SD/SDR ADO60700
 S ABMY=Y
 S (ABMPGS,ABMPSV)=ABMY  ;abm*2.6*36 IHS/SD/SDR ADO76210
 S DA(1)=ABMCLM
 F  D  Q:'ABMY
 .S X=$P(ABMY,",",1)
 .S ABMY=$P(ABMY,",",2,45)
 .I X["-" D
 ..S ABM1=+X
 ..S ABM2=$P(X,"-",2)
 ..F ABM=ABM1:2:ABM2 D:$D(ABM(0,ABM)) CLEANIT(ABM,1)
 .E  D:$D(ABM(0,X)) CLEANIT(X,1)
 ;S DA=0  ;abm*2.6*36 IHS/SD/SDR ADO76210
 ;F  S DA=$O(^ABMDCLM(DUZ(2),DA(1),11,DA)) Q:'DA  D  ;abm*2.6*36 IHS/SD/SDR ADO76210
 S ABMT=0  ;abm*2.6*36 IHS/SD/SDR ADO76210
 F  S ABMT=$O(^ABMDCLM(DUZ(2),DA(1),11,ABMT)) Q:'ABMT  D  ;abm*2.6*36 IHS/SD/SDR ADO76210
 .;S ABMVDFN=+^ABMDCLM(DUZ(2),DA(1),11,DA,0)  ;abm*2.6*36 IHS/SD/SDR ADO76210
 .S ABMP("VDFN")=+^ABMDCLM(DUZ(2),DA(1),11,ABMT,0)  ;abm*2.6*36 IHS/SD/SDR ADO76210
 .D VISIT^ABMCGAPI(ABMP("VDFN"),ABMCGIEN)  ;abm*2.6*35 IHS/SD/SDR ADO60700
 .;S ^AUPNVSIT("ABILL",$P(^AUPNVSIT(ABMVDFN,0),U,2),ABMVDFN)=""  ;abm*2.6*36 IHS/SD/SDR ADO76210
 .S (X,ABMPGS)=ABMPSV  ;abm*2.6*36 IHS/SD/SDR ADO76210
 .I ABMPGS D REBUILD  ;abm*2.6*36 IHS/SD/SDR ADO76210
 ;S Y=+^ABMDCLM(DUZ(2),DA(1),0)  ;abm*2.6*36 IHS/SD/SDR ADO76210
 ;I Y D QUEUE^ABMDVPAT  ;abm*2.6*36 IHS/SD/SDR ADO76210
 I ABMPGS D REBUILD  ;abm*2.6*36 IHS/SD/SDR ADO76210
 W "...Ok, done"  ;abm*2.6*36 IHS/SD/SDR ADO76210
Q ;KILL OFF VARS
 D PAZ^ABMDRUTL  ;pause before exiting option  ;abm*2.6*36 IHS/SD/SDR ADO76210
 K DIR,DIRUT,DTOUT,DUOUT,DIQ,DIC,DA,ABM,ABMY,ABM1,ABM2,DR
 Q
 ;start new abm*2.6*37 IHS/SD/SDR ADO81491
DICW ;
 W $S($$GETPREF^AUPNSOGI(Z,"I",1)'="":"-"_$$GETPREF^AUPNSOGI(Z,"I",1)_"*",1:"")
 W ?45,+Y
 W ?56,$$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),+Y,7)),U))
 I +$P($G(^ABMDCLM(DUZ(2),+Y,0)),U,3)'=0 W ?68,$P($G(^AUTTLOC($P($G(^ABMDCLM(DUZ(2),+Y,0)),U,3),0)),U,2)
 Q
 ;end new abm*2.6*37 IHS/SD/SDR ADO81491
 ;
CLEAN(CLM,SECT,DFN)    ;EP to allow cleaning all items from multiple
 ;CLM  = Claim #
 ;SECT = The multiple to clean out
 ;Y    = Patient DFN
 N DA
 S DA(1)=CLM
 D CLEANIT(SECT,1)
 ;I $G(DFN)>0 S Y=DFN D QUEUE^ABMDVPAT  ;abm*2.6*36 IHS/SD/SDR ADO76210
 I $G(DFN)>0 S Y=DFN D REBUILD  ;abm*2.6*36 IHS/SD/SDR ADO76210
 Q
 ;
HELP ;EP
 W !,"Enter the subfile to clean out for claim # ",ABMCLM,"."
 W !,"You may enter a list of subfiles like this: 17,19,23."
 W !,"Or a range like this: 23-33, or a combination like this:"
 W !,"13,19,23-33.  To delete all line items from all mutiples enter"
 W !,"13-47"
 Q
CLEANIT(ABMSUB,ABMALL) ;EP - Clean out old values from ABMSUB node
 N ABMJ,ABMFDA,FILE,IENS
 S ABMALL=$G(ABMALL)
 ;start new abm*2.6*34 IHS/SD/SDR ADO60694
 I ABMSUB=17 D  ;remove DRG when rebuilding DXs
 .N DA
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMCLM
 .S DR=".513////@"
 .D ^DIE
 ;end new abm*2.6*34 IHS/SD/SDR ADO60694
 S:'$D(DA) DA(1)=ABMP("CDFN")
 I $G(ABMCHV0)=$G(ABMP("V0")),$D(^ABMDCLM(DUZ(2),DA(1),ABMSUB))>1 D
 .S ABMJ=0
 .F  S ABMJ=$O(^ABMDCLM(DUZ(2),DA(1),ABMSUB,ABMJ)) Q:'ABMJ  D
 ..Q:'$D(^ABMDCLM(DUZ(2),DA(1),ABMSUB,ABMJ,0))
 ..S Y=^ABMDCLM(DUZ(2),DA(1),ABMSUB,ABMJ,0)
 ..;I 'ABMALL,($P(Y,U,17)="M") Q  ;removed this line; it should rebuild the whole multiple  ;abm*2.6*36 IHS/SD/SDR ADO76210
 ..I ABMSUB=13,$P(Y,U,3)="C" Q  ;quit if complete insurer
 ..I ABMSUB=13 S $P(^ABMDCLM(DUZ(2),ABMCLM,0),U,8)="",ABMP("INS")=""  ;abm*2.6*36 IHS/SD/SDR ADO76210
 ..S IENS=ABMJ_","_DA(1)_","
 ..S FILE=9002274.30+(ABMSUB/10000)
 ..S ABMFDA(FILE,IENS,.01)="@"
 ..D FILE^DIE("KE","ABMFDA")
 ..K ABMFDA(FILE)
 ..Q:'ABMALL
 ..S ABMSRC=""
 ..F  S ABMSRC=$O(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC)) Q:ABMSRC=""  D
 ...Q:'$D(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC,ABMJ))
 ...K ^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC,ABMJ,ABMSUB)
 Q
 ;start new abm*2.6*36 IHS/SD/SDR ADO76210
REBUILD ;EP
 I ((ABMPGS'["-")&($L(ABMPGS,",")=2)) D RBLD(+ABMPGS) Q  ;they only selected one multiple to rebuild
 I ABMPGS["-" D
 .I (+ABMPGS=13)&($P(ABMPGS,"-",2)=47) D  Q
 ..D V2^ABMDVCK
 ;
 I $L(ABMPGS,",")>2  D  Q
 .F ABMPCE=1:1:($L(ABMPGS,",")-1) D
 ..F ABMMLT=$P(ABMPGS,",",ABMPCE)
 ..Q:ABMMLT=15  ;skip 15 APC Visit; it isn't used anymore
 ..I $D(ABM(0,ABMMLT)) D RBLD(ABMMLT)
 ;
 ;below code is for range of multiples to rebuild
 F  D  Q:'ABMPGS
 .S X=$P(ABMPGS,",",1)
 .S ABMPGS=$P(ABMPGS,",",2,45)
 .I X["-" D
 ..S ABM1=+X
 ..S ABM2=$P(X,"-",2)
 ..F ABMMLT=ABM1:2:ABM2 D
 ...Q:ABMMLT=15  ;skip 15 APC Visit; it isn't used anymore
 ...I $D(ABM(0,ABMMLT)) D RBLD(ABMMLT)
 Q
RBLD(ABMSUB) ;EP
 S ABMIDONE=0
 S ABMP("CDFN")=ABMCLM
 S (ABMP("V0"),ABMCHV0)=$G(^AUPNVSIT(ABMP("VDFN"),0))
 S SERVCAT=$P(ABMCHV0,U,7)  ;service category
 S (ABMP("VDT"),ABMCHVDT)=$P($P($G(^AUPNVSIT(ABMP("VDFN"),0)),U),".")  ;visit date
 S ABMP("PDFN")=$P($G(^ABMDCLM(DUZ(2),ABMCLM,0)),U)
 S ABMP("VTYP")=$P($G(^ABMDCLM(DUZ(2),ABMCLM,0)),U,7)
 D ^ABMDEVAR
 S ABML="" D ELG^ABMDLCK(ABMP("VDFN"),.ABML,ABMP("PDFN"),ABMP("VDT"))
 S ABMP("PRI")=$O(ABML(0))
 S ABMP("INS")=$O(ABML(ABMP("PRI"),0))
 S ABMP("LDFN")=$P($G(^ABMDCLM(DUZ(2),ABMCLM,0)),U,3)
 S ABMP("FEE")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),U,5)
 I '$G(ABMP("FEE")) S ABMP("FEE")=$S($P(^ABMDPARM(DUZ(2),1,0),U,9)]"":$P(^(0),U,9),1:1)
 S ABMVDFN=ABMP("VDFN")
 I ABMSUB=13 D ENT^ABMDE2E Q  ;insurers p2
 ;
 I ((SERVCAT="H")&(ABMSUB=25)) D HOSP^ABMDVST4  ;Hospitalization visit - pg 8c
 ;
 I ABMSUB=41 D ^ABMDVST2  ;providers p4
 I ABMSUB=17 D ^ABMDVST1  ;diagnoses p5a
 I ABMSUB=19 D ^ABMDVST3  ;icd procedures p5b
 I ABMSUB=33 D ^ABMDVST6  ;dental p6
 I ABMSUB=23 K ABMP("RXDONE") D ^ABMDVST5  ;pharmacy p8d
 I ABMSUB=37 D ^ABMDVS11   ;lab p8e
 I ABMSUB=21 D ^ABMDVS13   ;surgical p8b
 I ABMSUB=45 I $T(^BCMDVS01)]"",$O(^BCMTCA(0)) D ^BCMDVS01   ;charge master
 I "^27^35^37^39^43^47^"[("^"_ABMSUB_"^") D CPT^AUPNCPT(ABMP("VDFN"))  ;pgs 8a,8f,8g,8h,8k
 S ABMI=0
 F  S ABMI=$O(AUPNCPT(ABMI)) Q:'ABMI  D
 .S N=ABMI
 .S ABMCPT=$P($G(AUPNCPT(ABMI)),U)
 .;start old abm*2.6*36 IHS/SD/SDR ADO76171
 .;S ABMMOD1=$P(AUPNCPT(ABMI),U,6)
 .;S ABMMOD2=$P(AUPNCPT(ABMI),U,7)
 .;end old start new abm*2.6*36 IHS/SD/SDR ADO76171
 .S ABMMOD1=$$GET1^DIQ(81.3,$P(AUPNCPT(ABMI),U,6),".01","E")
 .S ABMMOD2=$$GET1^DIQ(81.3,$P(AUPNCPT(ABMI),U,7),".01","E")
 .I $P(AUPNCPT(N),U,4)["18" D
 ..S ABMMOD3=$$GET1^DIQ(9000010.18,$P(AUPNCPT(N),U,5),".1","E")
 .;end new abm*2.6*36 IHS/SD/SDR ADO76171
 .S ABMSDT=ABMP("VDT")
 .S ABMDA=$P(AUPNCPT(ABMI),U,5)
 .S ABMSRC=$P($P($G(AUPNCPT(ABMI)),U,4),".",2)_"|"_ABMDA_"|CPT"
 .I ((ABMCPT<100)!(ABMCPT?.5N1.6A.5N)!($L(ABMCPT)=6))&(ABMSUB=43) D HCPCS^ABMFCPT Q
 .I ((+ABMCPT'=0)&(+ABMCPT<10000)),(ABMSUB=39) D ANES^ABMFCPT Q
 .I ((+ABMCPT>9999)&(+ABMCPT<70000)),(ABMSUB=21) D SURG^ABMFCPT Q
 .I ((+ABMCPT>69999)&(+ABMCPT<80000)),(ABMSUB=35) D RAD^ABMFCPT Q
 .I ((+ABMCPT>79999)&(+ABMCPT<90000)),(ABMSUB=37) D LAB^ABMFCPT Q
 .I ((+ABMCPT'=0)&(+ABMCPT>90000)),(ABMSUB=27) D MED^ABMFCPT
 K ABMCPT,ABMSRC,ABMRVN,DIC,DIE,DR,X,Y,ABMUNIT
 Q
 ;end new abm*2.6*36 IHS/SD/SDR ADO76210
 ;
PAGE ;;2^13
 ;;4^41
 ;;5A^17
 ;;5B^19
 ;;6^33
 ;;8A^27
 ;;8B^21
 ;;8C^25
 ;;8D^23
 ;;8E^37
 ;;8F^35
 ;;8G^39
 ;;8H^43
 ;;8J^45
 ;;8K^47
