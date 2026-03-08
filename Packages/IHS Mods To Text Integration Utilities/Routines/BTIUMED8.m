BTIUMED8 ; SLC/JM - Active/Recent Med Objects Routine ;14-Mar-2013 16:15;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1010,1011,1029**;Jun 20, 1997;Build 34
 ;Patch 1011 changed to new pharmacy APIs
 Q
LIST(DFN,TARGET) ; EP
 ;
 ; Medication object for detailed meds for pharmacists
 ;
 ;
 ;Required Parameters:
 ;
 ;  DFN       Patient identifier
 ;
 ;  TARGET    Where the medication data will be stored
 ;
 N NEXTLINE,EMPTY,INDEX,NODE,ISINP,KEEPMED,STATUS,ASTATS,PSTATS,OK,RXNO,CHRONIC,ARRAY1,ARRAY2
 N STATIDX,OUTPTYPE,TYPE,MEDTYPE,CNT,DATA,DATA1,MED,IDATE,XSTR,LLEN,DAYS,AUTO
 N LASTMEDT,LASTSTS,COUNT,TOTAL,SPACE60,DASH73,TEMP,LINE,TAB,HEADER,RXNUM,IEN,RX
 N DRUGCLAS,DRUGIDX,LASTCLAS,OLDTAB,OLDHEADR,UNKNOWNS,INDIC,LSTINDIC,PHARM,HSTATS,CHK
 N %,%H,STOP,LSTFD,ALLMEDS,CLASS,DETAILED,DRUG,REASON,REFILLS,FILLS,NRXN,HIEN,VST
 N CLASSORT,CLININC,ACTVONLY,CNT1,CNT2,ONELIST,SUPPLIES,HOLDSTTS
 S (NEXTLINE,TAB,HEADER,UNKNOWNS)=0,LLEN=47
 S PHARM=1
 S HOLDSTTS=$$GET^XPAR("ALL","BEHORX LABEL HOLD STATUS",,"E")_"*"  ;changed by IHS/MSC/MIR for 106931
 S:HOLDSTTS="*" HOLDSTTS="Active*"
 K @TARGET,^TMP("PS",$J)
 ; Check for Pharmacy Package and required patches
 I '$$PATCHSOK^TIULMED3 G LISTX ;P213
 S ACTVONLY=0
 S ALLMEDS=3,DETAILED=1
 S ONELIST=0
 S CLASSORT=0
 S SUPPLIES=1
 S CLININC=0
 S (EMPTY,HEADER)=1
 S ASTATS="^ACTIVE^REFILL^HOLD^PROVIDER HOLD^ON CALL^ACTIVE (S)^"
 S PSTATS="^NON-VERIFIED^DRUG INTERACTIONS^INCOMPLETE^PENDING^"
 S HSTATS="^HOLD^"
 S ISINP=($G(^DPT(DFN,.1))'="") ; Is this an inpatient?
 I ISINP=1 S @TARGET@(1,0)="Patient is an inpatient" Q "~@"_$NA(@TARGET)
 D ADDTITLE^BTIUMED1(1)
 ;
 ; *** Scan medication data and skip unwanted meds ***
 ;
 D OCL^PSOORRL(DFN,$$FMADD^XLFDT(DT,-1),"")
 ;
 ;*** Get the visit to check on ***
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;
 ;Get array of visit items
 N VMIEN,NUM,NUM2
 S VMIEN="",CNT1=0,CNT2=0,ARRAY1="",ARRAY2=""
 F  S VMIEN=$O(^AUPNVMED("AD",VST,VMIEN)) Q:'+VMIEN  D
 .S NUM=$P($G(^AUPNVMED(VMIEN,11)),U,2)
 .I NUM'="" S ARRAY1(NUM)=""
 .S NUM2=$P($G(^AUPNVMED(VMIEN,11)),U,8)
 .I NUM2'="" S ARRAY2(NUM2)=""
 ;
 I $D(ARRAY1)<10,$D(ARRAY2)<10 S @TARGET@(1,0)="No Medications found for this visit" Q "~@"_$NA(@TARGET)
 S INDEX=0,INDIC=""
 F  S INDEX=$O(^TMP("PS",$J,INDEX))  Q:INDEX'>0  D
 .S AUTO=0
 .S NODE=$G(^TMP("PS",$J,INDEX,0))
 .S RXNO=+($P(NODE,U))         ;Prescription IEN
 .S TYPE=$P($P(NODE,U),";",2) Q:TYPE'="O"
 .S TYPE="OP",MED=$P(NODE,U,2)
 .;Check visit
 .S RX=$P($G(^PSRX(RXNO,0)),U) Q:RX=""
 .I '$D(ARRAY1(RX)),'$D(ARRAY2(RXNO)) Q
 .S AUTO=$P($G(^PSRX(RXNO,999999921)),U,3)
 .S CHRONIC=$P($G(^PSRX(RXNO,9999999)),U,2)
 .Q:'$L(MED)           ;Discard Blank Meds
 .S STATUS=$P(NODE,U,9)
 .I STATUS="SUSPENDED" S STATUS="ACTIVE (S)"
 .I STATUS="ACTIVE/SUSP" S STATUS="ACTIVE (S)"
 .I STATUS="PENDING" D
 ..S IEN=+($P(NODE,U))
 ..I IEN>0 S REFILLS=$P($G(^PS(52.41,IEN,0)),U,11)
 ..S $P(^TMP("PS",$J,INDEX,0),U,5)=REFILLS
 .I $F(ASTATS,"^"_STATUS_"^") S STATIDX=1
 .E  I $F(PSTATS,"^"_STATUS_"^") S STATIDX=2
 .E  S STATIDX=3
 .I $O(^TMP("PS",$J,INDEX,"A",0))>0 S TYPE="IV"
 .E  I $O(^TMP("PS",$J,INDEX,"B",0))>0 S TYPE="IV"
 .S MEDTYPE=1
 .S DRUGCLAS=" "
 .;
 .; *** Save wanted meds in "B" temp xref, removing duplicates ***
 .;
 .D ADDMED^BTIUMED1(1) ; Get XSTR to check for duplicates
 .S STATUS=$P(NODE,U,9)
 .S IDATE=$P(NODE,U,15)
 .I $P($P(NODE,U),";")["N" S IDATE=$$DT^XLFDT
 .I $P(NODE,U,9)="PENDING"!($P(NODE,U,9)="HOLD") S IDATE=$$DT^XLFDT
 .Q:$D(@TARGET@("B",MED,IDATE,XSTR))
 .S @TARGET@("B",MED,IDATE,XSTR)=IDATE_U_INDEX_U_MEDTYPE_U_STATIDX_U_TYPE_U_DRUGCLAS_U_CHRONIC_U_STATUS
 .S EMPTY=0
 .I DRUGCLAS=" " S UNKNOWNS=1
 ;
 ; *** Check for empty condition ***
 ;
 I EMPTY D  G LISTX
 .D ADD^BTIUMED1("No Medications Found")
 .D ADD^BTIUMED1(" ")
 ;
 ; *** Sort Meds in "C" temp xref - sort by Med Type, Status
 ;     Med Name, and reverse issue date, followed by a counter
 ;     to avoid erasing meds issued on the same day
 ;
 S MED="",CNT=1000000,OUTPTYPE=1
 F  S MED=$O(@TARGET@("B",MED)) Q:MED=""  D
 .S IDATE="" F  S IDATE=$O(@TARGET@("B",MED,IDATE)) Q:IDATE=""  D
 ..S XSTR="" F  S XSTR=$O(@TARGET@("B",MED,IDATE,XSTR)) Q:XSTR=""  D
 ...S NODE=@TARGET@("B",MED,IDATE,XSTR),STATUS=$S($P(NODE,U,8)["HOLD":"ACTIVE",1:$P(NODE,U,8))
 ...S DATA=MED_U_$P(NODE,U,3)_U_$P(NODE,U,6),CNT=CNT+1
 ...S @TARGET@("C",STATUS,DATA,(9999999-$P(NODE,U))_CNT)=$P(NODE,U,2)_U_$P(NODE,U,4)_U_$P(NODE,U,6)
 K @TARGET@("B")
 ;
 ; Read sorted data and save final version to TARGET
 ;
 S (DATA,LASTCLAS,LSTINDIC)="",(LASTMEDT,LASTSTS,COUNT,TOTAL)=0
 S $P(SPACE60," ",60)=" ",$P(DASH73,"=",73)="="
 D WARNING^BTIUMED1
 S STATUS=""
 F  S STATUS=$O(@TARGET@("C",STATUS)) Q:STATUS=""  D
 .F  S DATA=$O(@TARGET@("C",STATUS,DATA)) Q:DATA=""  D
 ..S DRUGCLAS=$P(DATA,U,2),MED=$P(DATA,U,3)
 ..S MEDTYPE=$E(DRUGCLAS),STATIDX=$E(DRUGCLAS,2)
 ..S CNT="" F  S CNT=$O(@TARGET@("C",STATUS,DATA,CNT)) Q:CNT=""  D
 ...S INDEX=@TARGET@("C",STATUS,DATA,CNT)
 ...S TYPE=$P(INDEX,U,2),CHRONIC=$P(INDEX,U,3),INDEX=+INDEX
 ...S NODE=^TMP("PS",$J,INDEX,0),HIEN=+$P(NODE,U)
 ...;If hold meds, find the reason and add it to the node data
 ...I $P(NODE,U,9)["HOLD" D
 ....S $P(NODE,U,18)=$$GET1^DIQ(52,HIEN,99,"E")
 ....S $P(NODE,U,9)=HOLDSTTS
 ...I $P($P(NODE,U),";",2)["N" S $P(NODE,U,2)=$P(NODE,U,2)_" (O)"
 ...I CHRONIC="Y" S $P(NODE,U,2)=$P(NODE,U,2)_" (C)"
 ...S RXNUM=$P($G(^PSRX(HIEN,0)),U)
 ...S $P(NODE,U,20)=RXNUM_" "
 ...S $P(NODE,U,21)=$P($G(^TMP("PS",$J,INDEX,"P",0)),U,2)
 ...S ^TMP("PS",$J,INDEX,0)=NODE
 ...D FILLS
 ...I MEDTYPE'=LASTMEDT D  ; Create Header
 ....I DRUGCLAS'=" " S LASTCLAS=DRUGCLAS
 ....I 'HEADER Q
 ....S LASTMEDT=MEDTYPE,LASTSTS=STATIDX,TAB=0
 ....I COUNT>0 D ADD^BTIUMED1(" ")
 ....S COUNT=0
 ....I MEDTYPE=OUTPTYPE D  I 1
 .....D ADD^BTIUMED1($E(SPACE60,1,3)_"RX No"_$E($E(SPACE60,1,38)_"Status"_SPACE60,1,52)_"Last Fill")
 ....S TEMP=""
 ....I 'ONELIST D
 .....S TEMP=TEMP_"Outpatient Medications"
 ....S TEMP=$E(TEMP_SPACE60,1,47)
 ....S TEMP=TEMP_"Refills"
 ....S TEMP=$E(TEMP_SPACE60,1,60)
 ....S TEMP=TEMP_"Expiration"
 ....D ADD^BTIUMED1(TEMP),ADD^BTIUMED1(DASH73)
 ...S COUNT=COUNT+1,TOTAL=TOTAL+1
 ...D ADDMED^BTIUMED1(0)
 I COUNT'=TOTAL D
 .S TAB=0
 .D ADD^BTIUMED1(" ")
 .D ADD^BTIUMED1(TOTAL_" Total Medications")
 D ADD^BTIUMED1(" ")
 D ADD^BTIUMED1("(*) behind the status of the medication indicates pharmacy may be contacted about available fills of this medication")
 K @TARGET@("C")
LISTX K ^TMP("PS",$J)
 Q "~@"_$NA(@TARGET)
 ;
GETCLASS ; Get Drug Class, filter out supplies
 D GETCLASS^TIULMED3
 Q
FILLS ;Create and add nodes for fills and past fills.
 ;$G(^TMP("PS",$J,INDEX,0))
 K FILL
 N RFS,RF,RX2,RFL,FILL,II,PSIII,X,Y,Z
 S RX2=$S($D(^PSRX(HIEN,2)):^PSRX(HIEN,2),1:"")
 S RFL=1
 D FILOOP(HIEN,RX2)
 S Y=""
 S PSIII=0 F  S PSIII=$O(FILL(PSIII)) Q:'PSIII  D
 .S X=$P($G(FILL(PSIII)),U) Q:X=0
 .S Z=$$FMTE^XLFDT(X)
 .S Y=Y_Z_" "
 I Y'="" D
 .S ^TMP("PS",$J,INDEX,"FILL",0)=1
 .S ^TMP("PS",$J,INDEX,"FILL",1,0)=Y
 I CNT>0 S ^TMP("PS",$J,INDEX,"FILL",0)=1
 I RFL<6 D
 .K FILL
 .S NRXN=$P($G(^PSRX(HIEN,"OR1")),U,3)
 .I NRXN'="" D
 ..S RX2=$S($D(^PSRX(NRXN,2)):^PSRX(NRXN,2),1:"")
 ..D FILOOP(NRXN,RX2)
 ..S Y=""
 ..F PSIII=0:0 S PSIII=$O(FILL(PSIII)) Q:'PSIII  D
 ...S X=$P($G(FILL(PSIII)),U) Q:X=0
 ...S Z=$$FMTE^XLFDT(X)
 ...S Y=Y_Z_" "
 ..I Y'="" D
 ...S ^TMP("PS",$J,INDEX,"FILLS",0)=1
 ...S ^TMP("PS",$J,INDEX,"FILLS",1,0)=Y
 Q
FILOOP(RX,RX2) ;
 S FILL(9999999-$P(RX2,"^",2))=+$P(RX2,"^",2)_"^"_$S($P(RX2,"^",15):"(R)",1:""),FILLS=+$P(HIEN,"^",9)
 S II=0 F  S II=$O(^PSRX(RX,1,II)) Q:'II  D
 .S FILL(9999999-^PSRX(RX,1,II,0))=+^PSRX(RX,1,II,0)_"^"_$S($P(^(0),"^",16):"(R)",1:"") S RFL=RFL+1
 Q
