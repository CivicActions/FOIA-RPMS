ABMPSAD4 ; IHS/SD/SDR - Add Pharmacy POS COB Bill Manually ;   
 ;;2.6;IHS Third Party Billing;**36,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/SD/SDR 2.6*36 ADO76247 New routine; create a manual COB bill for Pharmacy POS claims - Page A
 ;IHS/SD/SDR 2.6*37 ADO76009 Added code for the ADPS COB page to set the needed vars
 ;
COB ;
 K ABMSFLG,ABMTFLAG,ABMMFLG,ABMSPLFG
 K ABMP("EXP")
 S ABMP("CDFN")=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 S ABMP("ITYP")=ABMDATA("ITYP")
 S ABMP("INS")=ABMDATA("INS")
 S ABMP("EXP")=ABMDATA("EXP")
 S ABMP("EXP",ABMDATA("EXP"))=ABMDATA("BAMT")
 S ABMP("LDFN")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,3)
 S (ABMEMLT,ABMISV,ABMIMSV)=1  ;there will only be one insurer entry on the bill
 S ABMP("VTYP")=ABMDATA("VT")
 S:'+$G(ABMP("TOT")) ABMP("TOT")=0
 I "^21^22^23^31^32^33^"[("^"_ABMDATA("EXP")_"^") D
 .S ABMPM("TOT")=ABMP("TOT")
 .;I ABMDATA("BAMT"),'$G(ABMQUIET) S ABMTFLAG=1 D DISPCK^ABMPPAD1,GATHER^ABMPPADJ  ;abm*2.6*37 IHS/SD/SDR ADO76009
 .I ABMDATA("BAMT"),'$G(ABMQUIET) S ABMTFLAG=1 D DISPCK^ABMPPAD1,SETVAR2^ABMPSAD1,GATHER^ABMPPADJ  ;abm*2.6*37 IHS/SD/SDR ADO76009
 .I (+$G(ABMP("CBAMT"))<(.01)) W !!,"ERROR: BALANCE MUST BE GREATER THAN ZERO AND NOT NEGATIVE",! H 1 S ABMSFLG=1
 .Q:(+$G(ABMP("CBAMT"))=0)
 .;I $G(ABMSFLG)=1 W "ERROR: STANDARD ADJUSTMENT CODE NOT ENTERED FOR ADJUSTMENT",!
 .;I $G(ABMMFLG)=1 W "ERROR: STANDARD ADJUSTMENT REASON DOESN'T MATCH ADJUSTMENT CATEGORY/REASON",!
 ;I $G(ABMSFLG)=1!($G(ABMMFLG)=1) W ABMDASH,!,"**Use the EDIT option to populate the Standard Adjustment Reason Code**",!
 Q:($G(ABMSFLG)=1)
 I $G(ABMTFLAG)=1 S (ABMDATA("TOT"),ABMDATA("CBAMT"))=+$G(ABMP("CBAMT")) Q  ;don't do summary below if 2NDARY with one export mode
 S:+$G(ABMP("CBAMT")) ABMDATA("CBAMT")=ABMP("CBAMT")
 ;
 D ^XBFMK
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".24////0"  ;set REBILL WRITE-OFF to '1' for NO so write-off
 D ^DIE
 ;
 K ABMPM
 D PREV^ABMDFUTL
 ;
ADJMNT ;
 W $$EN^ABMVDF("IOF")
 Q:$G(ABMSPLFG)=1  ;flag that transactions are split (see ^ABMPPFLR)
 S EXP=""
 S ABMCNT=0
 F  D  Q:ABMFLAG=1
 .S ABMFLAG=0
 .W !!,"CURRENT ADJUSTMENTS:"
 .I $G(ABMP("WO")) D
 ..W !,"        Write-off: ",$J($FN($G(ABMP("WO")),",",2),8)
 .I $G(ABMP("DED")) D
 ..W !,"       Deductible: ",$J($FN($G(ABMP("DED")),",",2),8)
 .I $G(ABMP("NONC")) D
 ..W !,"      Non-covered: ",$J($FN($G(ABMP("NONC")),",",2),8)
 .I $G(ABMP("COI")) D
 ..W !,"     Co-insurance: ",$J($FN($G(ABMP("COI")),",",2),8)
 .I $G(ABMP("GRP")) D
 ..W !,"Grouper allowance: ",$J($FN($G(ABMP("GRP")),",",2),8)
 .I $G(ABMP("PENS")) D
 ..W !,"        Penalties: ",$J($FN($G(ABMP("PENS")),",",2),8)
 .I $G(ABMP("REF")) D
 ..W !,"           Refund: ",$J($FN($G(ABMP("REF")),",",2),8)
 .S DIR(0)="Y"
 .S DIR("A")="Include any adjustments in billed amount?"
 .S DIR("B")="Y"
 .K Y
 .D ^DIR K DIR
 .I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) S ABMFLAG=1 Q
 .I Y'=1 S ABMFLAG=1 Q
 .I Y=1 D
 ..S DIR(0)="N^::2"
 ..S DIR("A")="Write-off Amount to bill"
 ..S DIR("B")=$G(ABMP("WO"))
 ..K Y
 ..D ^DIR K DIR
 ..I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) S ABMFLAG=1 Q
 ..S ADJ=Y
 ..I ADJ>0 D
 ...S BILL=$G(ABMDATA("CBAMT"))
 ...W !!,"Ok, I will add $",ADJ," to $",BILL," for a total billed amount of $",ADJ+BILL
 ...S DIR(0)="Y"
 ...S DIR("A")="OK?"
 ...S DIR("B")="Y"
 ...K Y
 ...D ^DIR K DIR
 ...I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) Q
 ...I Y=1 S ABMDATA("CBAMT")=ABMDATA("CBAMT")+ADJ
 ...S ABMFLAG=1  ;this makes it not ask these prompts again, one and done
 Q
