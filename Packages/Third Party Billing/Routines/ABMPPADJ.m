ABMPPADJ ; IHS/SD/SDR - Prior Payments/Adjustments page (CE); 
 ;;2.6;IHS 3P BILLING SYSTEM;**4,6,8,9,10,19,21,23,30,31,33,36,37,39,42**;NOV 12, 2009;Build 789
 ; split routine to ABMPPAD1 because of size
 ;IHS/SD/SDR 2.5*13 NO IM
 ;
 ;IHS/SD/SDR 2.6*6 5010 added export mode 32
 ;IHS/SD/SDR 2.6*19 HEAT168248 Added code to put each SAR only once w/total amt.  In split routine, ABMPPAD3
 ;IHS/SD/SDR 2.6*21 HEAT118718 Check for replacement insurer
 ;IHS/SD/SDR 2.6*23 CR9730 Added call for PRINT ORDER CHARGE SCREEN page
 ;IHS/SD/SDR 2.6*30 CR8901 Fixed COB page when pt has same insurer twice; was counting pymts/adjs twice, displaying twice, once for ea time insurer was on claim
 ;IHS/SD/SDR 2.6*31 CR11063 Made sure there is suffix and HRN before appending '-' and number; was ending up with just dash and not finding trans because bill number didn't match
 ;IHS/SD/SDR 2.6*33 ADO60189 Made correction to how amt was being retrieved from Transaction file; if amt was negative, that was
 ;   getting lost; Changed Current Charges so it would be total amt, not total-non-covered
 ;IHS/SD/SDR 2.6*36 ADO76247 Added flag so display won't happen at beginning of new ADPS option
 ;IHS/SD/SDR 2.6*37 ADO76009 Added check for PI multiple to separate out insurers better
 ;IHS/SD/SDR 2.6*39 ADO76227 Stop COB from displaying if insurer parameter is set (3P Insurer, #.15)
 ;IHS/SD/SDR 2.6*42 ADO107388 Stop <UNDEF>DISP+33^ABMPPADJ error
 ;
 ;ABMPL(Insurer priority, Insurer IEN)=
 ;  P1=13 multiple IEN
 ;  P2=Billing status
 ;ABMPP(Insurer IEN, PI multiple or '1', "P" or "A", Counter)=
 ;  P1=Amount
 ;  P2=Adj Category
 ;  P3=Trans. Type
 ;  P4=Std Adj. Reason
 ;  P5=billable?(Y/N)
 ;  P6=Payment multiple IEN
DISPCK ; chk if no complete insurer OR if 2 export modes on claim; don't do if either is true
 ;
 ;if mcd insurer type, UB-04 or 837I, itemized, and they chose to display print order screen
 I (ABMP("ITYP")="D")&("^28^31^"[("^"_ABMP("EXP")_"^"))&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),U,12)=1)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,24)="Y") D PRTORD^ABMDEOK1
 K ABMTFLAG,ABMSFLG,ABMMFLG
 K ABMPM
 N ABMPP
 K ABMPL,ABMEMLT,ABMILST,ABMLST  ;abm*2.6*37 IHS/SD/SDR ADO76009
 S ABMA=0
 K ABMAFLG,ABMMFLG
 F  S ABMA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMA)) Q:+ABMA=0  D
 .S ABMAI=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMA,0)),U)
 .Q:ABMAI=""
 .I $P($G(^ABMNINS(ABMP("LDFN"),ABMAI,0)),U,11)="Y",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMA,0)),U,3)="C") S ABMAFLG=1
 .I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMAI,".211","I"),1,"I")="R",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,8)=ABMAI) S ABMMFLG=1
 I $G(ABMAFLG)=1,($G(ABMMFLG)=1) Q  ;don't do COB page cuz there is tribal insurer and Medicare
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),0)),U,15)="N" S ABMAFLG=1,ABMMFLG=1 Q  ;abm*2.6*39 IHS/SD/SDR ADO76227
 K ABMAFLG,ABMMFLG
 D DISPCK^ABMPPAD1
GATHER Q:$G(ABMCHK)=1  ;quit if no complete insurer or 2 export modes on claim
 K ABMPM,ABMPP
 D SETVAR^ABMPPAD1
 ;S ABMPHRN=$P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,2)  ;abm*2.6*31 CR11063
 S ABMPHRN=$P($G(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)),U,2)  ;abm*2.6*31 CR11063
 S ABMBSUF=$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,4)
 ;
 D GATHER^ABMPPAD6  ;split routine abm*2.6*37 IHS/SD/SDR ADO76009
 S ABMTFLAG=1
DISP K ABMSFLG,ABMMFLG
 ;I +$G(ABMFLG("ABMPSADD"))'=0 Q  ;abm*2.6*36 IHS/SD/SDR ADO76247
 D SETVAR^ABMPPAD1
 S ABMDASH="",$P(ABMDASH,"-",80)=""
 S ABMZ("TITL")="PRIOR PAYMENTS/ADJUSTMENTS"
 S ABMP("SCRN")="A"
 S ABMZ("PG")="A"
 I '$D(ABMP("DDL")) D SUM^ABMDE1 I 1
 E  S ABMC("CONT")="" D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT
 ;
 S ABMINS=0
 F  S ABMINS=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINS)) Q:+ABMINS=0  D
 .S ABMIIEN=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINS,0)),U)
 .S ABMPRI=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINS,0)),U,2)
 .S ABMSTAT=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINS,0)),U,3)
 .S ABMEMLT=$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINS,0)),U,8)'=0:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINS,0)),U,8),1:1)  ;abm*2.6*37 IHS/SD/SDR ADO76009
 .Q:ABMSTAT'="I"&(ABMSTAT'="C")
 .;S ABMPL(ABMPRI,ABMIIEN)=ABMINS_"^"_ABMSTAT  ;abm*2.6*37 IHS/SD/SDR ADO76009
 .S ABMPL(ABMPRI,ABMIIEN,ABMEMLT)=ABMINS_"^"_ABMSTAT  ;abm*2.6*37 IHS/SD/SDR ADO76009
 ;
 ;S ABMPM("TOT")=ABMP("TOT")-(+$G(ABMP("NC")))  ;abm*2.6*33 CR60189
 S ABMPM("TOT")=ABMP("TOT")  ;abm*2.6*33 CR60189
 S ABMP("CBAMT")=0
 S ABMIPRI=0
 S ABMISV=0
 F  S ABMIPRI=$O(ABMPL(ABMIPRI)) Q:+ABMIPRI=0  D
 .S ABMIIEN=0
 .F  S ABMIIEN=$O(ABMPL(ABMIPRI,ABMIIEN)) Q:+ABMIIEN=0  D
 ..;I $P(ABMPL(ABMIPRI,ABMIIEN),U,2)="C" S ABMISV=ABMIIEN  ;abm*2.6*37 IHS/SD/SDR ADO76009
 ..;start new abm*2.6*37 IHS/SD/SDR ADO76009
 ..S ABMEMLT=0
 ..F  S ABMEMLT=$O(ABMPL(ABMIPRI,ABMIIEN,ABMEMLT)) Q:'ABMEMLT  D
 ...I $P(ABMPL(ABMIPRI,ABMIIEN,ABMEMLT),U,2)="C" S ABMISV=ABMIIEN,ABMIMSV=ABMEMLT
 ;S ABMEMLT=ABMIMSV  ;abm*2.6*42 IHS/SD/SDR ADO107388
 S ABMEMLT=+$G(ABMIMSV)  ;abm*2.6*42 IHS/SD/SDR ADO107388
 ;end new abm*2.6*37 IHS/SD/SDR ADO76009
 S ABMIIEN=ABMISV
 D SUM^ABMPPAD5  ;abm*2.6*37 IHS/SD/SDR ADO76009 split routine due to size
 ;
 ;D DISPLAY^ABMPPAD4  ;split routine abm*2.6*31 IHS/SD/SDR CR11063  ;abm*2.6*36 IHS/SD/SDR ADO76247
 I +$G(ABMFLG("ABMPSADD"))=0 D DISPLAY^ABMPPAD4  ;abm*2.6*36 IHS/SD/SDR ADO76247
 I ((ABMP("EXP")=21)!(ABMP("EXP")=22)!(ABMP("EXP")=23)!(ABMP("EXP")=31)!(ABMP("EXP")=32)!(ABMP("EXP")=33)) D
 .I $G(ABMSFLG)=1 W "ERROR: STANDARD ADJUSTMENT CODE NOT ENTERED FOR ADJUSTMENT",!
 .I $G(ABMMFLG)=1 W "ERROR: STANDARD ADJUSTMENT REASON DOESN'T MATCH ADJUSTMENT CATEGORY/REASON",!
 .I ABMP("CBAMT")<0 W "ERROR: NEGATIVE BALANCE ON BILL NOT ALLOWED",! S ABMSFLG=1
 .I $G(ABMSFLG)=1!($G(ABMMFLG)=1) W ABMDASH,!
 W "**Use the EDIT option to populate the Standard Adjustment Reason Code**",!
 E  K ABMSFLG,ABMMFLG  ;remove flag for other checks of this error
 ;
 S ABMP("OPT")="AEQ"
 S ABMP("DFLT")="Q"
 D SEL^ABMDEOPT
 I "AE"'[$E(Y) G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("DO")=$S($E(Y)="A":"ADD",$E(Y)="E":"EDIT",1:"XIT") D @ABM("DO") G DISP
XIT ;
 D XIT^ABMPPAD1
 Q
DOLAMT(AMT) ;
 Q $S(($E(AMT,1)="-"!($G(ABMNFLG)=1))&(AMT'=0):"("_$J($S($E(AMT)="-":$E(AMT,2,$L(AMT)),1:AMT),10,2)_")",1:$J(+$G(AMT),11,2))
ADD ;
 D ADD^ABMPPAD1
 Q:($G(ABMEFLG)=1)
 D EDIT2
 Q
EDIT ;
 D EDIT^ABMPPAD1
 Q:($G(ABMEFLG)=1)  ;tried to edit active insurer OR no trans selected
EDIT2 ;
 D EDIT2^ABMPPAD1
 D ^ABMPPFLR
 Q
