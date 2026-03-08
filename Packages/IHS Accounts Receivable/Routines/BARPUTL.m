BARPUTL ; IHS/SD/LSL - POSTING UTILITIES ; 07/08/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,19,31,32,35**;OCT 26, 2005;Build 187
 ;
 ;IHS/SD/TMM 1.8*19 06/18/10 Add Prepayment functionality.
 ;IHS.OIT.FCJ 1.8*31 11.4.2020 CR#6156 MODIFIED TO SORT/DISPLAY BY CLINIC OR VISIT
 ;IHS/SD/SDR 1.8*32 ADO76300 Fixed so lookup will only be done on bill# and other bill identifier xrefs
 ;IHS/SD/SDR 1.8*35 ADO60910 Added preferred name to display PPN
 ;****************************************
 Q
 ;
SELBILL ; EP
 ; select bill
 ;IM24235 BAR*1.8*1
 I '$D(^BARBL(DUZ(2))) D  Q
 .W !!,$P(^DIC(4,DUZ(2),0),U)," DOES NOT HAVE ANY BILLS TO LIST!"
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 ;END IM24235
 K DIC
 S DIC=90050.01
 S DIC(0)="AEMQZ"
 ; IHS/SD/PKD 10/21/10
 S DIC("W")="D DISP^BARPUTL"
 ;D ^DIC ;bar*1.8*32 IHS/SD/SDR ADO76300
 S D="B^G"  ;bar*1.8*32 IHS/SD/SDR ADO76300
 D MIX^DIC1 ;bar*1.8*32 IHS/SD/SDR ADO76300
 Q:+Y<0
 S BARPAT=$P(^BARBL(DUZ(2),+Y,1),"^",1)
 S BARSTART=$P(^BARBL(DUZ(2),+Y,1),"^",2)
 S BAREND=$P(^BARBL(DUZ(2),+Y,1),"^",3)
 S:BAREND="" BAREND=BARSTART
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ;****************************************
 ;
 ; IHS/SD/PKD 1.8*19 10/21/10
DISP  ; New Tag Pt Lookup Display
 ; Naked reference - called from Fileman Display
 N DOS,STAT,CURRAMT
 ;BAR*1.8*31 11.4.2020 IHS.OIT.FCJ FIXED NAKED REF FOR SQA ST OF CHG
 ;Q:'$D(^(1))  ; No data,quit
 Q:+Y<1  ; No data,quit
 ;S DOS=$$SHDT^BARDUTL($P(^(1),U,2))
 S DOS=$$SHDT^BARDUTL($P(^BARBL(DUZ(2),+Y,1),U,2))
 ;S CURRAMT=$P(^(0),U,15)  ;I CURRAMT=0 S CURRAMT="0.00"
 S CURRAMT=$P(^BARBL(DUZ(2),+Y,0),U,15)  ;I CURRAMT=0 S CURRAMT="0.00"
 ;Extra spaces after tabs on purpose.  keep fields apart.
 ;S STAT=$S($D(^BARTBL(+$P(^(0),U,16),0))#2:$P(^(0),U,1),1:"")
 S STAT=$S($D(^BARTBL($P(^BARBL(DUZ(2),+Y,0),U,16),0))#2:$P(^(0),U,1),1:"")
 ;BAR*1.8*31 11.4.2020 IHS.OIT.FCJ FIXED NAKED REF FOR SQA END OF CHG
 W ?38," ",$J($FN(CURRAMT,"p",2),9),"  ",?48,STAT,?55," ",DOS,?63," ",$P(^BARBL(DUZ(2),Y,1),U,16)
 I $$GETPREF^AUPNSOGI($P(^BARBL(DUZ(2),Y,1),U),"I",1)'="" W " - "_$$GETPREF^AUPNSOGI($P(^BARBL(DUZ(2),Y,1),U),"I",1)_"*"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 Q
GETBIL ;EP
 W !
 S DIC="^BARBL(DUZ(2),"
 S DIC(0)="AEQZ"
 S DIC("A")="Select Bill DOS: "
 S D="E"
 D IX^DIC
 K DIC
 Q:+Y<0
 S BARPAT=$P(^BARBL(DUZ(2),+Y,1),"^",1)
 S BARSTART=$P(^BARBL(DUZ(2),+Y,1),"^",2)
 S BAREND=$P(^BARBL(DUZ(2),+Y,1),"^",3)
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",2)
 W "  ",BARPAT(0)
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ;****************************************
 ;
ASKPAT ;EP - select patient
 K DIC,BARZ
 S DIC="^AUPNPAT("
 S DIC(0)="IAEMQZ"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 ;S DIC("S")="Select Patient: "  ;commented out because 'S' is a screen, not the prompt  ;bar*1.8*35 IHS/SD/SDR ADO60910
 S DIC("S")="I $D(^BARBL(DUZ(2),""ABC"",Y))"
 S DIC("W")="D DICWPAT^BARUTL0(1)"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 D ^DIC
 K DIC
 Q:+Y<0
 S BARPAT=+Y
 S BARPAT(0)=Y(0)
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 D GETDOS
 I '$G(BAROK) K BARPAT Q
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 ;D:$D(BARSRT1) SORT  ;BAR*1.8*31 10.29.2020 IHS.OIT.FCJ CR#6156 SET IN BARNP AND BARPRF
 D:$D(BARSRT1) SORT I $D(DUOUT) S BARQ=0 K BARZ F I=1:1 D  Q:BARQ
 .D GETDOS
 .I $G(BAROK) D  Q
 ..D SORT
 ..I $D(DUOUT) K BAROUT,BAROK Q
 ..E  S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND,BARQ=1
 .E  S BARQ=1 K DUOUT Q
 ;BAR*1.8*31 11.4.2020 IHS.OIT.FCJ CR#6156 END CHANGES 
 Q
 ;****************************************
 ;
GETDOS ; EP
 ; dates of service
 K BARSTART,BAREND,BAROK
 W !
 S BARSTART=$$DATE^BARDUTL(1)
 Q:BARSTART<0
 S %DT("B")=$$MDT2^BARDUTL(BARSTART)
 S BAREND=$$DATE^BARDUTL(2)
 Q:BAREND<0
 I BAREND<BARSTART D  G GETDOS
 .W *7
 .D EOP^BARUTL(2)
 .W !,"The END date must not be before the START date.",!
 S BAROK=1
 Q
 ;
ASKPATB(DICB) ;EP - select patient
 ; IHS/SD/TMM 1.8*19 7/6/10
 ; Copied from ASKPAT; allows user to pass default value for DIC("B"))
 K DIC,BARZ
 S DIC("B")=DICB
 S DIC="^AUPNPAT("
 S DIC(0)="IAEMQZ"
 ;S DIC("S")="Select Patient: "  ;commented out because 'S' is a screen, not the prompt  ;bar*1.8*35 IHS/SD/SDR ADO60910
 S DIC("S")="I $D(^BARBL(DUZ(2),""ABC"",Y))"
 S DIC("W")="D DICWPAT^BARUTL0(1)"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 D ^DIC
 K DIC
 Q:+Y<0
 S BARPAT=+Y
 S BARPAT(0)=Y(0)
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 D GETDOS
 I '$G(BAROK) K BARPAT Q
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ;
SELBILLB(DICB2) ; EP
 ; IHS/SD/TMM 1.8*19 7/11/10
 ; Copied from SELBILL: allows user to pass default value for DIC("B"))
 ; select bill
 I '$D(^BARBL(DUZ(2))) D  Q
 .W !!,$P(^DIC(4,DUZ(2),0),U)," DOES NOT HAVE ANY BILLS TO LIST!"
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 K DIC
 S DIC("B")=DICB2
 S DIC=90050.01
 S DIC(0)="AEMQZ"
 D ^DIC
 Q:+Y<0
 S BARPAT=$P(^BARBL(DUZ(2),+Y,1),"^",1)
 S BARSTART=$P(^BARBL(DUZ(2),+Y,1),"^",2)
 S BAREND=$P(^BARBL(DUZ(2),+Y,1),"^",3)
 S:BAREND="" BAREND=BARSTART
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ;****************************************
 ;
GETBILB(DICB3) ;EP
 ; IHS/SD/TMM 1.8*19 7/11/10
 ; Copied from GETBIL: allows user to pass default value for DIC("B"))
 W !
 S DIC="^BARBL(DUZ(2),"
 S DIC(0)="AEQZ"
 S DIC("A")="Select Bill DOS: "
 S D="E"
 D IX^DIC
 K DIC
 Q:+Y<0
 S BARPAT=$P(^BARBL(DUZ(2),+Y,1),"^",1)
 S BARSTART=$P(^BARBL(DUZ(2),+Y,1),"^",2)
 S BAREND=$P(^BARBL(DUZ(2),+Y,1),"^",3)
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",2)
 W "  ",BARPAT(0)
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ;****************************************
 ;BAR*1.8*31 10.29.2020 IHS.OIT.FCJ CR#6156 start of change
SORT ;EP BARPNP,BARPRF,BARBAD;IF PAT SELECTED PROMPT FOR SORTING BY CLINIC OR VISIT TYPE
 K BARSRTA
 S DIR(0)="SA^V:Visit Type;C:Clinic Type;N:No - do not filter by Clinic or Visit Type"
 S DIR("B")="N"
 S DIR("A")="Do you wish to display by Clinic(C) or Visit(V) Type? "
 D ^DIR
 Q:$D(DUOUT)!$D(DTOUT)!(Y?1."N")
 S BARSRT=Y
 D:BARSRT?1"C" CLNIC
 D:BARSRT?1"V" VIST
 I $D(DUOUT) K BARSRT G SORT
 Q
 ;
CLNIC ;SORT PATIENT BILLS BY CLINIC
 K DIR
 S DIR(0)="FA"
 S DIR("B")="All"
 S DIR("A")="Select Clinic Types? "
 D ^DIR
 Q:$D(DUOUT)!$D(DTOUT)
 I Y="All" D CLNALL Q
 S DIC="^DIC(40.7,",DIC(0)="EMQZ"
 D ^DIC
 Q:Y<0
 Q:$D(DUOUT)!$D(DTOUT)
 S BARSRT("C",$P(Y,U,2))=Y(0)
 S DIC(0)="AEMQZ",DIC("A")="Select Another Clinic: "
 F I=1:1 D  Q:+Y<1
 .D ^DIC
 .I $D(DUOUT) K BARSRT("C") Q
 .Q:+Y<1
 .S BARSRT("C",$P(Y,U,2))=Y(0)
 Q
CLNALL ;
 S I=0 F  S I=$O(^DIC(40.7,I)) Q:I'?1N.N  D
 .S BARSRT("C",$P(^DIC(40.7,I,0),U))=^DIC(40.7,I,0)
 S BARSRTA=1
 Q
 ;
VIST ;SORT PATIENT BILLS BY VISIT
 K DIR
 S DIR(0)="FA"
 S DIR("B")="All"
 S DIR("A")="Select Visit Types? "
 D ^DIR
 Q:$D(DUOUT)!$D(DTOUT)
 I Y="All" D VSTALL Q
 S DIC="^ABMDVTYP(",DIC(0)="EMQZ"
 D ^DIC
 Q:Y<0
 Q:$D(DUOUT)!$D(DTOUT)
 S BARSRT("V",$P(Y,U,2))=$P(Y,U,2)_U_$P(Y,U)
 S DIC(0)="AEMQZ",DIC("A")="Select Another Visit Type: "
 F I=1:1 D  Q:+Y<1
 .D ^DIC
 .I $D(DUOUT) K BARSRT("V") Q
 .Q:+Y<1
 .S BARSRT("V",$P(Y,U,2))=$P(Y,U,2)_U_$P(Y,U)
 Q
VSTALL ;
 S I=0 F  S I=$O(^ABMDVTYP(I)) Q:I'?1N.N  D
 .S BARSRT("V",$P(^ABMDVTYP(I,0),U))=$P(^ABMDVTYP(I,0),U)_U_I
 S BARSRTA=1
 Q
 ;BAR*1.8*31 10.29.2020 IHS.OIT.FCJ CR#6156 end of change
