ABMDBDIC ; IHS/SD/SDR - Bill Selection ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**33,36,37,38**;NOV 12, 2009;Build 756
 ;
 ;IHS/DSD/MRS 5/21/1999 NOIS QDA-599-130046 Patch 3 #1 Added check for missing insurer data
 ;
 ;IHS/PIMC/JLG 8/20/02 2.5*2 Modified so IQMG option would only look at one bill.  Thanks to Jim Gray for the code.
 ;IHS/SD/SDR 2.5*11 Adrian supplied the following changes
 ;IHS/SD/SDR 2.5*12 Added code to look up by UFMS invoice number using x-ref UINV
 ;
 ;IHS/SD/SDR 2.6*33 ADO60185 CR12178 Updated bill display to allow longer bill#
 ;IHS/SD/SDR 2.6*36 ADO74860 Updated so lookup can be done by 'G' xref for OTHER BILL IDENTIFIER
 ;IHS/SD/SDR 2.6*36 ADO76247 Update so ABMD MG ADD POS BILL won't see cancelled claims
 ;IHS/SD/SDR 2.6*37 ADO81491 Added PPN preferred name to display
 ;IHS/SD/SDR 2.6*38 ADO99134 Removed SSN from display; also fixed programming error when '??' is entered at prompt (i.e., REPR and then '??' at bill# prompt)
 ;
BILL ;EP - SELECT BILL
 K %P,DIC,ABMP("BDFN"),ABM
 S DIR("A")="Select BILL or PATIENT"
 S DIR("?")="Enter either the Bill Number or a Patient Identifier (Name, HRN, SSN, DOB)"
 W !
 S DIR(0)="FO" D ^DIR K DIR
 Q:$D(DIRUT)
 S ABM("INPUT")=Y
 I Y=" " D  Q
 .S DIC="^ABMDBILL(DUZ(2),",DIC(0)="EMQ",X=Y
 .I ($G(XQY0)["ABMD MG PHARM POS CLEANUP") S DIC("S")="I $P(^(0),U,7)=901" ;if using the BLRX option, only Visit Type 901 bills  ;abm*2.6*36 IHS/SD/SDR ADO74860
 .I ($G(XQY0)["ABMD MG ADD POS BILL") S DIC("S")="I ($P(^(0),U,4)'=""X"")!($P(^(0),U,10)=39)" ;if using the ADPS option, not cancelled bills and clinic must be pharmacy  ;abm*2.6*36 IHS/SD/SDR ADO76247
 .S DIC("W")="S Z=$P($G(^ABMDBILL(DUZ(2),+Y,0)),U,5) D DICW2^ABMDBDIC"  ;abm*2.6*37 IHS/SD/SDR ADO81491
 .D ^DIC Q:+Y<0
 .S ABMP("BDFN")=+Y
 ;I ($D(^ABMDBILL(DUZ(2),"B",Y))&(Y'=+Y))!($D(^ABMDBILL(DUZ(2),"UINV",Y))) D  ;abm*2.6*36 IHS/SD/SDR ADO74860
 I ($D(^ABMDBILL(DUZ(2),"B",Y))&(Y'=+Y))!($D(^ABMDBILL(DUZ(2),"UINV",Y)))!($D(^ABMDBILL(DUZ(2),"G",Y))) D  ;abm*2.6*36 IHS/SD/SDR ADO74860
 .S X=Y
 .;S DIC="^ABMDBILL(DUZ(2),",DIC(0)="EM" D ^DIC  ;abm*2.6*36 IHS/SD/SDR ADO74860
 .S DIC="^ABMDBILL(DUZ(2),",DIC(0)="EM"  ;abm*2.6*36 IHS/SD/SDR ADO74860
 .I ($G(XQY0)["ABMD MG PHARM POS CLEANUP") S DIC("S")="I $P(^(0),U,7)=901" ;if using the BLRX option, only Visit Type 901 bills  ;abm*2.6*36 IHS/SD/SDR ADO74860
 .I ($G(XQY0)["ABMD MG ADD POS BILL") S DIC("S")="I ($P(^(0),U,4)'=""X"")!($P(^(0),U,10)=39)" ;if using the ADPS option, not cancelled bills and clinic must be pharmacy  ;abm*2.6*36 IHS/SD/SDR ADO76247
 .S DIC("W")="S Z=$P($G(^ABMDBILL(DUZ(2),+Y,0)),U,5) D DICW2^ABMDBDIC"  ;abm*2.6*37 IHS/SD/SDR ADO81491
 .D ^DIC  ;abm*2.6*36 IHS/SD/SDR ADO74860
 .I +Y>0 S ABMP("BDFN")=+Y
 I $G(ABMP("BDFN")) K ABM Q
 I Y=+Y,$D(^ABMDBILL(DUZ(2),"B",Y)) D
 .S X=Y
 .S DIC("W")="S Z=$P($G(^ABMDBILL(DUZ(2),+Y,0)),U,5) D DICW2^ABMDBDIC"  ;abm*2.6*37 IHS/SD/SDR ADO81491
 .S DIC="^ABMDBILL(DUZ(2),",DIC(0)="EM" D ^DIC
 .I +Y>0 D
 ..S ABMP("BDFN")=+Y
 ..K DIR,DIE,DIC,X,Y,DA
 ..S DIR(0)="Y"
 ..S DIR("A")="Correct Bill",DIR("B")="YES" D ^DIR K DIR
 ..I Y'=1 K ABMP("BDFN")
 I $G(ABMP("BDFN")) K ABM Q
 S ABM("STATUS")=$P(^DD(9002274.4,.04,0),"^",3)
NUM ;NUMBER LOOKUP
 S Y=ABM("INPUT")
 I +Y D
 .S J=+Y_" "
 .S ABM("CNT")=0
 .F  S J=$O(^ABMDBILL(DUZ(2),"B",J)) Q:J'[+ABM("INPUT")!($G(ABMP("BDFN")))  D
 ..S I=$O(^ABMDBILL(DUZ(2),"B",J,0))
 ..S ABMP("PDFN")=$P(^ABMDBILL(DUZ(2),I,0),"^",5)
 ..D ID
 .D:(ABM("CNT")#5) SEL
 I $G(ABMP("BDFN")) K ABM Q
PAT ;PATIENT LOOKUP     
 S X=ABM("INPUT"),DIC="^AUPNPAT(",DIC(0)="EMQ",AUPNLK("ALL")=1
 D ^DIC
 I +Y<0 G BILL
 S ABMP("PDFN")=+Y,ABM("P0")=^DPT(ABMP("PDFN"),0)
 S $P(ABM("="),"=",80)=""
 D PAT^ABMDUTL(ABMP("PDFN"))
 S I="",ABM("CNT")=0 F  S I=$O(^ABMDBILL(DUZ(2),"D",ABMP("PDFN"),I),-1) Q:'I!($G(ABMP("BDFN")))!($D(DIRUT))  D ID
 D:(ABM("CNT")#5) SEL
 I '$G(ABMP("BDFN")) G BILL
 K ABM Q
ID ;BILL IDENTIFIERS
 I ($G(XQY0)["ABMD MG PHARM POS CLEANUP")&($P($G(^ABMDBILL(DUZ(2),I,0)),U,7)'=901) Q  ;if using the BLRX option, only display Visit Type 901 bills  ;abm*2.6*36 IHS/SD/SDR ADO74860
 I ($G(XQY0)["ABMD MG ADD POS BILL")&(($P($G(^ABMDBILL(DUZ(2),I,0)),U,4)="X")!($P($G(^ABMDBILL(DUZ(2),I,0)),U,10)'=39)) Q  ;if using the ADPS option, anything but cancelled bills,clinic=pharmacy  ;abm*2.6*36 IHS/SD/SDR ADO76247
 I '(ABM("CNT")#5) D PAT^ABMDUTL(ABMP("PDFN"))
 S ABM("CNT")=ABM("CNT")+1
 S ABM("CNT",ABM("CNT"))=I
 W !!,"(",ABM("CNT"),")"
 S ABM("ZERO")=^ABMDBILL(DUZ(2),I,0) N J F J=1:1:12 S ABM(J)=$P(ABM("ZERO"),"^",J)
 S ABM(7,1)=$P($G(^ABMDBILL(DUZ(2),I,7)),"^",1),ABM(2,1)=$P($G(^(2)),"^",1)
 S ABM(4)=$P(ABM("STATUS"),ABM(4)_":",2),ABM(4)=$P(ABM(4),";",1)
 W ?5,"Bill# ",ABM(1)
 ;start old abm*2.6*33 IHS/SD/SDR ADO60185
 ;W ?20,$$SDT^ABMDUTL(ABM(7,1))
 ;W ?32,$E($P($G(^ABMDVTYP(+ABM(7),0)),U),1,17)
 ;W ?51,$E($P($G(^DIC(40.7,+ABM(10),0)),U),1,13)
 ;W ?67,$P($G(^AUTTLOC(+ABM(3),0)),"^",2)
 ;end old start new abm*2.6*33 IHS/SD/SDR ADO60185
 W ?22,$$SDT^ABMDUTL(ABM(7,1))
 W ?34,$E($P($G(^ABMDVTYP(+ABM(7),0)),U),1,15)
 W ?52,$E($P($G(^DIC(40.7,+ABM(10),0)),U),1,12)
 W ?67,$E($P($G(^AUTTLOC(+ABM(3),0)),"^",2),1,13)
 ;end new abm*2.6*33 IHS/SD/SDR ADO60185
 ;
 W !,?6,$P($G(^ABMDEXP(+ABM(6),0)),"^",1)
 W ?22,$E(ABM(4),1,15)
 W ?37,$P($G(^AUTNINS(+ABM(8),0)),"^",1)
 W ?70,$J($FN(ABM(2,1),",",2),10)
 I '(ABM("CNT")#5) D SEL
 Q
SEL ;SELECT
 F  W ! Q:$Y+4>IOSL
 S DIR(0)="NAO^1:"_ABM("CNT"),DIR("A")="Select 1 to "_ABM("CNT")_": " D ^DIR K DIR
 I Y S ABMP("BDFN")=ABM("CNT",Y)
 I Y="",'$D(DTOUT) K DIRUT
 Q
 ;
BENT ;EP - for doing Bill File lookup with DIC variables
 K ABMP("BDFN")
 S AUPNLK("ALL")=1
 S DIC("W")="S ABM(0)=^(0),ABM(2)=+$G(^(2)),ABM(7)=$S(+$G(^(7)):^(7),1:+$G(^(6))) D DICW^ABMDBDIC"
 D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I X="?" W !!,"Enter either the Bill Number or a Patient Identifier (Name, HRN, SSN, DOB)"
 G BENT:+Y<1 S ABMP("BDFN")=+Y
 G XIT
 ;
DICW ;EP - for displaying bill identifiers
 I $G(DZ)["?",$P(ABM(0),U,5),$D(^DPT($P(ABM(0),U,5),0)) S ABMDPT=^(0) D
 .W ?12,$P(ABMDPT,U)
 .;W $S($$GETPREF^AUPNSOGI(+ABMP(0),"")'="":"-"_$$GETPREF^AUPNSOGI(+ABMP(0),"")_"*",1:"")  ;abm*2.6*37 IHS/SD/SDR ADO81491
 .;W $S($$GETPREF^AUPNSOGI(+ABMP(0),"I","")'="":"-"_$$GETPREF^AUPNSOGI(+ABMP(0),"I","")_"*",1:"")  ;abm*2.6*37 IHS/SD/SDR ADO81491  ;abm*2.6*38 IHS/SD/SDR ADO99134
 .W $S($$GETPREF^AUPNSOGI(ABMDPT,"I","")'="":"-"_$$GETPREF^AUPNSOGI(ABMDPT,"I","")_"*",1:"")  ;abm*2.6*37 IHS/SD/SDR ADO81491  ;abm*2.6*38 IHS/SD/SDR ADO99134
 .;W ?46,$P(ABMDPT,U,2)," "  ;abm*2.6*38 IHS/SD/SDR ADO99134
 .W ?46,$P(ABMDPT,U,2)," "  ;abm*2.6*38 IHS/SD/SDR ADO99134
 .W $$HDT^ABMDUTL($P(ABMDPT,U,3))
 .;W " ",$P(ABMDPT,U,9)  ;abm*2.6*38 IHS/SD/SDR ADO99134
 I  I $G(DUZ(2)),$D(^AUPNPAT($P(ABM(0),U,5),41,DUZ(2),0)) W ?68,$P($G(^AUTTLOC(DUZ(2),0)),U,7)," ",$P(^AUPNPAT($P(ABM(0),U,5),41,DUZ(2),0),U,2)
 I $G(X)'=$P(ABM(0),U,5)!($G(DZ)["?") W !
 W ?17,"Visit: ",$$HDT^ABMDUTL(ABM(7))," "
 I $P(ABM(0),U,7) W $E($P($G(^ABMDVTYP($P(ABM(0),U,7),0)),U),1,14)
 I $P(ABM(0),U,10),$P(ABM(0),U,3) W ?49,$E($P($G(^DIC(40.7,$P(ABM(0),U,10),0)),U),1,17),?68,$E($P($G(^AUTTLOC($P(ABM(0),U,3),0)),U,2),1,12)
 I $P(ABM(0),U,8) W !?20,"Bill: ",$P(^AUTNINS($P(ABM(0),U,8),0),U)
 ;I $P(ABM(0),U,6) W ?57,$P($G(^ABMDEXP($P(ABM(0),U,6),0)),U)  ;abm*2.6*38 IHS/SD/SDR ADO99134
 I $P(ABM(0),U,6) W ?52,$P($G(^ABMDEXP($P(ABM(0),U,6),0)),U)  ;abm*2.6*38 IHS/SD/SDR ADO99134
 W ?68,$J($FN(ABM(2),",",2),10)
 S DIW=1
 I $G(DZ)["?" W !
 K ABM(0),ABM(7)
 Q
 ;
XIT K ABM
 Q
 ;
MULT ;EP for Selecting Multiple Bills
 K DIC S ABM("C")=0,DIC="^ABMDBILL(DUZ(2),",DIC(0)="QEAM" W !
 F ABM=1:1 W ! D  Q:X=""!$D(DUOUT)!$D(DTOUT)
SELO .S ABM("E")=$E(ABM,$L(ABM)),DIC("A")="Select "_ABM_$S(ABM>3&(ABM<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" BILL: ",DIC(0)="QEAM" D ^DIC
 .Q:X=""!$D(DUOUT)!$D(DTOUT)
 .I +Y<1 G SELO
 .S ABMM(+Y)=""
 K DIC
 G XIT
 ;start new abm*2.6*37 IHS/SD/SDR ADO81491
DICW2 ;EP - for displaying claim identifiers
 W !?3,$P(^DPT(Z,0),U)
 W $S($$GETPREF^AUPNSOGI(Z,"I",1)'="":"-"_$$GETPREF^AUPNSOGI(Z,"I",1)_"*",1:"")
 ;W ?46,$P(^DPT(Z,0),U,2)," ",$$HDT^ABMDUTL($P(^(0),U,3))," ","***-**-"_$E($P(^(0),U,9),6,9)  ;abm*2.6*38 IHS/SD/SDR ADO99134
 W ?46,$P(^DPT(Z,0),U,2)," ",$$HDT^ABMDUTL($P(^(0),U,3))  ;abm*2.6*38 IHS/SD/SDR ADO99134
 I  I $G(DUZ(2)),$D(^AUPNPAT(Z,41,DUZ(2),0)) D
 .W ?70,$P($G(^AUTTLOC(DUZ(2),0)),U,7)," ",$P(^AUPNPAT(Z,41,DUZ(2),0),U,2)
 Q
 ;end new abm*2.6*37 IHS/SD/SDR ADO81491
