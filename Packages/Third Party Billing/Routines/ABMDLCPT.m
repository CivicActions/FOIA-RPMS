ABMDLCPT ; IHS/SD/SDR - REPORT OF CPT codes ; 
 ;;2.6;IHS Third Party Billing;**1,10,21,29,31**;NOV 12, 2009;Build 615
 ;IHS/SD/SDR 2.6*29 CR10669 Fixed DIR lookup so it can look up a CPT even if it's in the CPT file multiple times;
 ;  before p29 if you tried a CPT that was in the CPT file multiple times it would act like an invalid CPT was entered
 ;  and prompt the user again.  Made the display print all CPTs and their IENs since it's a listing from CPT file.
 ;  Also fixed so it will print HCPCS and Category III codes correctly.  Prior to p29 you could select a HCPCS range
 ;  but it didn't print anything because it was expecting numeric answers only to the prompts.
 ;IHS/SD/SDR 2.6*31 CR11226 Fixed so if they hit <spacebar><return> and it's not a valid response it will go back and have
 ;  them answer the prompt again.  It was accepting <spacebar><return> and putting -1 in the header instead of a CPT code.
 ;  Also fixed INACTIVE? field so it populates.  It prints every entry so it looks weird when the CPT is in the file twice
 ;  and it looks like both are active.
 ;
 S U="^"
SEL ;
 ;start old abm*2.6*29 IHS/SD/SDR CR10669
 ;K DIR,DIC,DIE,X,Y,DA,DR
 ;S DIR(0)="PO^81"
 ;S DIR("A")="START WITH CPT CODE"
 ;D ^DIR K DIR
 ;Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;I X="" S Y=0
 ;S ABMFROM=+Y
 ;I ABMFROM'=0 D
 ;.K DIR,DIC,DIE,X,Y,DA,DR
 ;.S DIR(0)="PO^81"
 ;.S DIR("A")="FINISH WITH CPT CODE"
 ;.D ^DIR K DIR
 ;.Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;.S ABMTO=+Y
 ;I +$G(ABMTO)<1 S ABMTO=$O(^ICPT(9999999999),-1)
 ;end old start new abm*2.6*29 IHS/SD/SDR CR10669
 D ^XBFMK
 S (X,Y)=0
 K ^TMP($J,"ABM","CPT")
 S X=0 F  S X=$O(^ICPT(X)) Q:'X  S ^TMP($J,"ABM","CPT",$P(^ICPT(X,0),U))=$P(^ICPT(X,0),U,2)
 S TGBL="^TMP($J,"_""""_"ABM"_""""_","_""""_"CPT"_""""_",X)"
 S DIR(0)="F^^I '$D(@TGBL) S Y=-1 W "" ??"""
 S DIR("A")="START WITH CPT CODE"
 D ^DIR
 K DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) K ^TMP($J,"ABM","CPT") Q
 I Y<0 G SEL  ;abm*2.6*31 IHS/SD/SDR CR11226
 S ABMFROM=Y
 ;
SELFIN ;  added linetag abm*2.6*31 IHS/SD/SDR CR11226
 I ABMFROM'=0 D
 .D ^XBFMK
 .S DIR(0)="FO^^I '$D(@TGBL) S Y=-1 W "" ??"""
 .S DIR("A")="FINISH WITH CPT CODE"
 .D ^DIR
 .K DIR
 .S ABMTO=Y
 I ABMTO<0 K ABMTO G SELFIN  ;abm*2.6*31 IHS/SD/SDR CR11226
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;I +$G(ABMTO)<1 S ABMTO=$O(^ICPT(9999999999),-1)  ;abm*2.6*29 IHS/SD/SDR CR10669
 ;I ABMFROM>ABMTO W !!,*7,"INPUT ERROR: Low CPT Code is Greater than than the High, TRY AGAIN!",!! G SEL  ;abm*2.6*29 IHS/SD/SDR CR10669
 ;start new abm*2.6*29 IHS/SD/SDR CR10669
 I $G(ABMTO)="" S ABMTO=$O(^ICPT("B",""),-1)
 S ABMCFR="",ABMCTO=""
 F A=1:1:5 S ABMCFR=$G(ABMCFR)_$A(ABMFROM,A)
 F A=1:1:5 S ABMCTO=$G(ABMCTO)_$A(ABMTO,A)
 K ^TMP($J,"ABM","CPT")
 I ABMCFR>ABMCTO W !!,*7,"INPUT ERROR: Low CPT Code is Greater than than the High, TRY AGAIN!",!! G SEL
 ;end new abm*2.6*29 IHS/SD/SDR CR10669
 ;
W1 W !!!
 S %ZIS="NQ",%ZIS("B")=""
 D ^%ZIS G:'$D(IO)!$G(POP) XIT
 S ABM("ION")=ION G:$D(IO("Q")) QUE
 I IO'=IO(0),$E(IOST)'="C",'$D(IO("S")),$P($G(^ABMDPARM(DUZ(2),1,0)),U,13)="Y" W !!,"As specified in the 3P Site Parameters File FORCED QUEUEING is in effect!",! G QUE
PRQUE ;EP - Entry Point for Taskman
 S ABM("PG")=0
 S ABM("HD",0)="CPT FILE LISTING"
 ;I ABMFROM'=0 S ABM("HD",1)="SELECTED RANGE: "_$P($G(^ICPT(ABMFROM,0)),U)_" TO "_$P($G(^ICPT(ABMTO,0)),U)  ;abm*2.6*29 IHS/SD/SDR CR10669
 I ABMFROM'=0 S ABM("HD",1)="SELECTED RANGE: "_ABMFROM_" TO "_ABMTO  ;abm*2.6*29 IHS/SD/SDR CR10669
 D HDB
 D SET
 W !!,$$EN^ABMVDF("HIN"),"E N D   O F   R E P O R T",$$EN^ABMVDF("HIF"),!
XIT ;
 D ^%ZISC
 K ABM
 Q
 ;
QUE K IO("Q")
 S ZTRTN="PRQUE^ABMDLCPT"
 S ZTDESC="REPORT OF CPT CODES"
 ;F ABM="ABM(" S ZTSAVE(ABM)=""  ;abm*2.6*10
 S ZTSAVE("ABM*")=""  ;abm*2.6*10
 D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED!",! G XIT
 ;
SET ;
 ;start old abm*2.6*29 IHS/SD/SDR CR10669
 ;S:ABMFROM>0 ABMFROM=ABMFROM-.1
 ;F  S ABMFROM=$O(^ICPT(ABMFROM)) Q:(+ABMFROM=0!(+$G(ABMTO)'=0&(ABMFROM>ABMTO)))  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 ;.K ABMZ
 ;.;.01=CPT CODE
 ;.;2=SHORT DESC
 ;.;5=INACTIVE FLAG
 ;.;9999999.1=coor. dx (CSV)
 ;.;4=coor. dx (pre-CSV)
 ;.;I $$VERSION^XPDUTL("BCSV")>0 D GETS^DIQ(81,ABMFROM,".01;2;5;81.04*","EZ","ABMZ")  ;abm*2.6*10 ICD10 021
 ;.I $$VERSION^XPDUTL("BCSV")>0 D GETS^DIQ(81,ABMFROM,".01;2;5","EZ","ABMZ")  ;abm*2.6*10 ICD10 021
 ;.;I $$VERSION^XPDUTL("BCSV")<1 D GETS^DIQ(81,ABMFROM,".01;2;5;4*","EZ","ABMZ")  ;abm*2.6*10 ICD10 021
 ;.I $$VERSION^XPDUTL("BCSV")<1 D GETS^DIQ(81,ABMFROM,".01;2;5","EZ","ABMZ")  ;abm*2.6*10 ICD10 021
 ;.S ABMIEN=ABMFROM_","
 ;.W !?2,ABMZ(81,ABMIEN,".01","E")  ;cpt code
 ;.W ?10,ABMZ(81,ABMIEN,"2","E")  ;short description
 ;.W ?55,$S($G(ABMZ(81,ABMIEN,"5","E"))=1:"INACTIVE",1:"")  ;inactive flag
 ;.;start old code abm*2.6*10 ICD10 021
 ;.;S ABMCD=""
 ;.;F  S ABMCD=$O(ABMZ(81.04,ABMCD)) Q:ABMCD=""  D
 ;.;.W ?65,$G(ABMZ(81.04,ABMCD,.01,"E"))
 ;.;.I $O(ABMZ(81.04,ABMCD))'="" W !
 ;.;end old code 021
 ;.I $Y>(IOSL-5) D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)  D HDB Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont)" Q
 ;end old start new abm*2.6*29 IHS/SD/SDR CR10669
 ;
 I ABMFROM>0 S ABMFROM=ABMFROM-.1
 I ((+ABMFROM=0)&($G(ABMFROM)'="")) S ABMFROM=$O(^ICPT("B",ABMFROM),-1)
 S ABMCFLG=0
 F  S ABMFROM=$O(^ICPT("B",ABMFROM)) Q:(ABMFROM=""!(ABMCFLG=1))  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 .S ABMCFR=""
 .F A=1:1:5 S ABMCFR=$G(ABMCFR)_$A(ABMFROM,A)
 .I ABMCFR>ABMCTO S ABMCFLG=1 Q
 .S ABMCIEN=0
 .F  S ABMCIEN=$O(^ICPT("B",ABMFROM,ABMCIEN)) Q:'ABMCIEN  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 ..K ABMZ
 ..;.01=CPT CODE
 ..;2=SHORT DESC
 ..;5=INACTIVE FLAG
 ..;9999999.1=coor. dx (CSV)
 ..;4=coor. dx (pre-CSV)
 ..I $$VERSION^XPDUTL("BCSV")>0 D GETS^DIQ(81,ABMCIEN,".01;2;5","EZ","ABMZ")
 ..I $$VERSION^XPDUTL("BCSV")<1 D GETS^DIQ(81,ABMCIEN,".01;2;5","EZ","ABMZ")
 ..S ABMIEN=ABMCIEN_","  ;IEN w/comma so it will match what's in ABMZ array of data
 ..W !?2,ABMZ(81,ABMIEN,".01","E")  ;cpt code
 ..W " ("_+ABMCIEN_")"  ;CPT IEN; added for clarity since there are duplicates in the CPT file at this time
 ..W ?30,ABMZ(81,ABMIEN,"2","E")  ;short description
 ..;W ?65,$S($G(ABMZ(81,ABMIEN,"5","E"))=1:"INACTIVE",1:"")  ;inactive flag  ;abm*2.6*31 IHS/SD/SDR CR11226
 ..W ?65,$S($G(ABMZ(81,ABMIEN,"5","E"))["INACTIVE":"INACTIVE",1:"")  ;inactive flag  ;abm*2.6*31 IHS/SD/SDR CR11226
 ..I $Y>(IOSL-5) D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)  D HDB Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont)" Q
 ;end new abm*2.6*29 IHS/SD/SDR CR10669
 Q
HDB ;
 S ABM("PG")=+$G(ABM("PG"))+1
 D WHD^ABMDRHD
 ;W !,"CPT CODE",?10,"SHORT DESCRIPTION",?55,"INACTIVE FLAG",?65,"COOR. DX"  ;abm*2.6*10 ICD10 021
 ;W !,"CPT CODE",?10,"SHORT DESCRIPTION",?55,"INACTIVE FLAG"  ;abm*2.6*10 ICD10 021  ;abm*2.6*29 IHS/SD/SDR CR10669
 W !,"CPT CODE (IEN)",?30,"SHORT DESCRIPTION",?65,"INACTIVE?"  ;abm*2.6*10 ICD10 021  ;abm*2.6*29 IHS/SD/SDR CR10669
 Q
