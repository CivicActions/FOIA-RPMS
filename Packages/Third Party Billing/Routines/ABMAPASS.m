ABMAPASS ; IHS/ASDST/DMJ - PASS INFO TO A/R ;    
 ;;2.6;IHS 3P BILLING SYSTEM;**3,4,6,8,10,11,13,21,31,33,34**;NOV 12, 2009;Build 645
 ;Original;DMJ
 ;abm*2.6*33 routine ABMPASSD was split from this routine; it contains list of fields; documentation routine only
 ;
 ;IHS/DSD/MRS-4/1/1999 Modify to check for missing root of insurer array
 ;IHS/DSD/MRS 6/23/1999 NOIS PYA-0499-90061 Patch 3 #2
 ;  Code assumed ICPT ien was equal to .01, not true for type II & III HCPCS. Modified to retrieve numerical ien from "B" cross-reference
 ;IHS/ASDS/LSL 05/18/2001 2.4*6 Modified to accomodate Pharmacy POS posting.  Allow RX to pass to A/R Bill file as 
 ;     Other Bill Identifier.
 ;
 ;IHS/SD/SDR 2.5*8 added code to pass ambulance charges
 ;IHS/SD/SDR 2.5*9 IM16864 Correction to bill suffix when rolling over for satellites
 ;IHS/SD/SDR 2.5*10 IM20395 Split out lines bundled by rev code
 ;
 ;IHS/SD/SDR 2.6 CSV
 ;IHS/SD/SDR 2.6*3 modified to pass POS Rejection info if it exists for bill
 ;IHS/SD/SDR 2.6*3 modified to pass Re-export dates if any exist on bill
 ;IHS/SD/SDR 2.6*4 POS rejection change was causing 3P CREDIT A/R transactions to create.
 ;  Modified to only pass the codes not the whole ABMPOS array.
 ;IHS/SD/SDR 2.6*6 NOHEAT Added code to put a partial bill number as other identifier
 ;IHS/SD/SDR 2.6*13 NOHEAT1 Made change to default date/time approved if there is no export date.
 ;IHS/SD/SDR 2.6*21 HEAT118656 Made changes for total credit for Upload option in A/R
 ;IHS/SD/SDR 2.6*31 CR11218 Fixed so description that goes to A/R is for active CPT entry, not the first CPT entry it finds in the 'B' x-ref
 ;IHS/SD/SDR 2.6*33 ADO60197 CR12174 Updated what fields are being passed to A/R so it's more inclusive
 ;IHS/SD/SDR 2.6*34 ADO60694 CR7384 Added DRG
 ; *********************************************************************
 ;This routine is called each time the Bill Status is changed in the 3P BILL file.  It is called as part of
 ;a cross-reference on the Bill Status (.04) field.  It will send the ABMA array to A/R.
 ;The ABMA array is stored in ^TMP($J,"ABMAPASS") and it is this global that is passed to A/R.  The array
 ;can be defined as follows (Field numbers are as they relate to the 3P BILL file):
 ;This rtn has been modified so it will work with either A/R 1.1 or 1.0
 ;
 ;REFER TO ROUTINE ABMPASSD for list of fields
 ;
 ;******************************
 ;
START ;START HERE
 ;X = Bill status in 3P BILL file
 ;
 Q:X=""
 Q:"ABTX"'[X  ; q:bill not approved, billed, transferred, or cancelled
 S ABMP("ARVERS")=$$CV^XBFUNC("BAR")
 Q:ABMP("ARVERS")<0   ;Q if A/R not loaded
 D BLD        ;Build ABMA Array
 D PASS       ;Pass ABMA Array to A/R
 K ABMA,ABM,ABMR,^TMP($J,"ABMPASS")
 Q
 ; ********************************
BLD ; PEP
 ;BUILD ABMA ARRAY (STORED IN TMP for ver 1.1)
 ;NEEDS X AND DA IF CALLED FROM HERE
 ;X  = Bill status in 3P BILL
 ;DA = IEN to 3P BILL
 ;
 K ABMA,^TMP($J,"ABMPASS")
 S (ABMA("BLDA"),ABMP("BDFN"))=DA
 S ABMA="^TMP($J,""ABMPASS"")"
 S ABMA("ACTION")=X
 ;The line below translate cancelled status to 99 for A/R
 S:X="X" ABMA("ACTION")=$S(ABMP("ARVERS")'<1.1:99,1:"C")
 N I
 F I=1:1 S ABMA("LINE")=$T(TXT+I) Q:ABMA("LINE")["END"  D
 .S ABMA("DR")=$P(ABMA("LINE"),";;",2)
 .S ABMA($P(ABMA("LINE"),";;",3))=$$VALI^XBDIQ1("^ABMDBILL(DUZ(2),",DA,ABMA("DR"))
 .I ABMA("DR")=.17,ABMA("DTBILL") S ABMA("DTBILL")=$$VALI^XBDIQ1(^DIC(9002274.6,0,"GL"),ABMA("DTBILL"),.01)
 ;I ABMA("ACTION")="B",ABMA("DTBILL")="" S ABMA("DTBILL")=DT  ;abm*2.6*13 NOHEAT1
 I ABMA("ACTION")="B",ABMA("DTBILL")="" S ABMA("DTBILL")=ABMA("DTAP")  ;abm*2.6*13 NOHEAT1
 D BLNM    ;Calculate complete bill name
 N I,DA,K
 S K=0
 ; Loop through each type of bill service and find ITEM ARRAY data
 S ABMP("VDT")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)  ;fix for CSV; needed for CSV API call
 ;start new ABM*2.6*11 HEAT90370
 S:'+$G(ABMP("INS")) ABMP("INS")=+$G(ABMA("INS"))
 S:'+$G(ABMP("LDFN")) ABMP("LDFN")=+$G(ABMA("VSLC"))
 ;end new HEAT90370
 D VST^ABMAPAS2  ;abm*2.6*33 IHS/SD/SDR ADO60197
 D INSMLT^ABMAPAS2  ;abm*2.6*33 IHS/SD/SDR ADO60197
 D DXMLT^ABMAPAS2  ;abm*2.6*33 IHS/SD/SDR ADO60197
 D PXMLT^ABMAPAS2  ;abm*2.6*33 IHS/SD/SDR ADO60197
 D PRVMLT^ABMAPAS2  ;abm*2.6*33 IHS/SD/SDR ADO60197
 D BLDMLT^ABMAPAS2  ;split routine due to size abm*2.6*33 ADO60197
 K ABMRV
 D ORV^ABMERGRV   ;Find other items (Revenue codes)
 N I
 S I=.97
 D CONV^ABMAPAS2  ;split routine due to size abm*2.6*33 ADO60197
 N ABME
 ; Get insurer data
 ;S ABMP("ITYPE")=$P($G(^AUTNINS(+ABMA("INS"),2)),"^",1)  ;abm*2.6*10 HEAT73780
 S ABMP("ITYPE")=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMA("INS"),".211","I"),1,"I")  ;abm*2.6*10 HEAT73780
 D ISET^ABMERUTL   ;Set insurer priorities based on 3P BILL
 D CONV2^ABMAPAS2     ;Convert insurer to ABMA array ;split routine due to size abm*2.6*33 ADO60197
 K ABMP("SET")
 S ABMP("PDFN")=ABMA("PTNM")
 S ABME("INS")=ABMA("INS")
 ;The following line has been added to Klamath falls ***
 I '$G(ABME("INSIEN")),'($D(ABMP("INS"))#2) S ABMP("INS")=""
 ; Get policy data of active insurer
 D EN^XBNEW("ISET^ABMERINS","ABME,ABMP,ABMR")
 S ABMA("POLH")=$G(ABME("PHNM"))
 S ABMA("POLN")=$G(ABMR(30,70))
 ;
 D PROV    ;Get Attending provider
 ;S ABMA("CREDIT")=$$TCR^ABMERUTL(ABMP("BDFN"))  ;Total Credit  ;abm*2.6*21 IHS/SD/SDR HEAT118656
 D TCR^ABMAPAS2  ;Total Credit abm*2.6*21 IHS/SD/SDR HEAT118656  ;split routine abm*2.6*33 IHS/SD/SDR ADO60197
 S ABMA("OTHIDENT")=$G(ABMPOS("OTHIDENT"))
 I ($G(ABMA("OTHIDENT"))=""),($L(ABMA("BLNM")>14)) S ABMA("OTHIDENT")=$E(ABMA("BLNM"),1,14)  ;abm*2.6*6 NOHEAT
 K ABMA("LINE"),ABMA("DR"),ABMA("DA")
 I $P($G(^AUTNINS(ABMA("INS"),2)),"^",1)="N" S ABMA("INS")=""
 ;I ABMP("ARVERS")'<1.1 M @ABMA=ABMA  ;abm*2.6*3
 ;
 ;I $D(ABMPOS) M ABMA=ABMPOS  ;abm*2.6*3 POS Rejections  ;abm*2.6*4
 I $D(ABMPOS) M ABMA(73)=ABMPOS(73)  ;abm*2.6*4
 ;start new abm*2.6*3 re-export dates
 I $G(ABMREX("BDFN")),$D(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74)) D
 .S ABMMIEN=0
 .F  S ABMMIEN=$O(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN)) Q:(+$G(ABMMIEN)=0)  D
 ..S ABMA(74,ABMMIEN,"DT")=$P($G(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U),0)),U)
 ..S ABMA(74,ABMMIEN,"STAT")=$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U,2)
 ..S ABMA(74,ABMMIEN,"GCN")=$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U,3)
 ..;S ABMTXIEN=$O(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U),3,"B",ABMA(74,ABMMIEN,"DT"),0))  ;abm*2.6*33 IHS/SD/SDR ADO60197
 ..S ABMTXIEN=ABMMIEN  ;abm*2.6*33 IHS/SD/SDR ADO60197
 ..I ABMTXIEN'="" D
 ...S ABMA(74,ABMMIEN,"USR")=$P($G(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U),3,ABMTXIEN,0)),U,4)
 ...S ABMA(74,ABMMIEN,"RSN")=$P($G(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U),3,ABMTXIEN,0)),U,5)
 I $G(ABMREX("BDFN")),+$G(ABMP("XMIT"))'=0 D
 .I $D(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,"B",ABMP("XMIT"))) Q  ;already has this transmission
 .S ABMMIEN=($O(ABMA(74,99999),-1)+1)
 .S ABMTXIEN=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,"B",$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U),0))
 .I ABMTXIEN'="" D
 ..S ABMA(74,ABMMIEN,"DT")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMTXIEN,0)),U)
 ..S ABMA(74,ABMMIEN,"GCN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMTXIEN,0)),U,2)
 ..S ABMSTAT="O"
 ..I $G(ABMREX("BILLSELECT"))'="" S ABMSTAT="F"
 ..I $G(ABMREX("BATCHSELECT"))'="" S ABMSTAT="S"
 ..I $G(ABMREX("RECREATE"))'="" S ABMSTAT="C"
 ..S ABMA(74,ABMMIEN,"STAT")=ABMSTAT
 ..S ABMA(74,ABMMIEN,"USR")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMTXIEN,0)),U,4)
 ..S ABMA(74,ABMMIEN,"RSN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMTXIEN,0)),U,5)
 ;end new abm*2.6*3 re-export dates
 ;
 I ABMP("ARVERS")'<1.1 M @ABMA=ABMA  ;abm*2.6*3
 Q
 ;
PASS ;
 ;PASS TO A/R
 I ABMP("ARVERS")'<1.1 D
 . D TPB^BARUP(ABMA)
 E  D TPB^BARUP(.ABMA)
 S $P(^ABMDBILL(DUZ(2),DA,2),U,6)=$G(^TMP($J,"ABMPASS","ARLOC"))
 Q
 ;
 ; ***************************
BLNM ;EP - get full bill name
 I $P($G(^ABMDPARM(ABMA("VSLC"),1,2)),"^",4)]"" S ABMA("BLNM")=ABMA("BLNM")_"-"_$P(^(2),"^",4)
 I $P($G(^ABMDPARM(ABMA("VSLC"),1,3)),"^",3)=1 D
 .S ABM("HRN")=$P($G(^AUPNPAT(ABMA("PTNM"),41,ABMA("VSLC"),0)),"^",2)
 .S:ABM("HRN")]"" ABMA("BLNM")=ABMA("BLNM")_"-"_ABM("HRN")
 Q
 ;
 ; *************************
PROV ;
 ;GET ATTENDING PROVIDER
 S ABMA("PROV")=""
 N I
 S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 N J
 S J=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,+I,0)),"^",1)
 S ABMA("PROV")=J
 Q
 ;
 ; **********************
TXT ;FIELDS
 ;;.01;;BLNM
 ;;.02;;BTYP
 ;;.03;;VSLC
 ;;.05;;PTNM
 ;;.06;;EXP
 ;;.07;;VSTP
 ;;.08;;INS
 ;;.09;;PROCD
 ;;.022;;MNSPLT
 ;;.1;;CLNC
 ;;.114;;MTAXID
 ;;.1212;;TPRTTYP
 ;;.1213;;TRPTTF
 ;;.1214;;POPMOD
 ;;.1215;;MNECIND
 ;;.1216;;DESTMOD
 ;;.122;;POPORG
 ;;.123;;POPADDR
 ;;.124;;POPCTY
 ;;.125;;POPST
 ;;.126;;POPZIP
 ;;.127;;DEST
 ;;.128;;COVMI
 ;;.129;;NCOVMI
 ;;.14;;APPR
 ;;.15;;DTAP
 ;;.17;;DTBILL
 ;;.21;;BLAMT
 ;;.27;;OBLAMT
 ;;.28;;FRATE
 ;;.29;;LICN
 ;;.31;;FRCPT
 ;;.32;;FRREV
 ;;.33;;FRREVD
 ;;.43;;XRAYS
 ;;.44;;ORTHOR
 ;;.45;;ORTHPDT
 ;;.46;;PROINC
 ;;.47;;PRIPDT
 ;;.48;;CASE#
 ;;.49;;RESUB#
 ;;.51;;ADMTYP
 ;;.511;;REF#
 ;;.512;;PRIAUTH
 ;;.513;;DRG
 ;;.52;;ADMSRC
 ;;.525;;NWBNDYS
 ;;.53;;DSCHST
 ;;.54;;PSRO
 ;;.59;;ADMTDX
 ;;.61;;ADT
 ;;.62;;AHR
 ;;.63;;DDT
 ;;.64;;DHR
 ;;.66;;NCDAYS
 ;;.71;;DOSB
 ;;.711;;ROIDT
 ;;.712;;AOBDT
 ;;.713;;PROCN
 ;;.714;;HVRXDT
 ;;.715;;DISASDT
 ;;.716;;DISAEDT
 ;;.717;;LWRKDT
 ;;.718;;RWRKDT
 ;;.719;;ASCRDT
 ;;.72;;DOSE
 ;;.721;;RELCRDT
 ;;.722;;PROCCONDT
 ;;.723;;PTPDAMT
 ;;.724;;SMANCONC
 ;;.725;;PROCPID
 ;;.726;;PROCPN
 ;;.727;;ACTMDT
 ;;.73;;CDAYS
 ;;.74;;ROI
 ;;.75;;AOB
 ;;.816;;ACCDST
 ;;.82;;INJDT
 ;;.825;;FL17PTYP
 ;;.83;;ACCDTYP
 ;;.84;;ACCDHR
 ;;.857;;ECD
 ;;.858;;ECD2
 ;;.859;;ECD3
 ;;.86;;1SYMPDT
 ;;.87;;1CONDT
 ;;.88;;RPRV
 ;;.884;;RPRVIDQ
 ;;.885;;RPRVID#
 ;;.886;;RPRVPRSNC
 ;;.887;;RPRVPRVC
 ;;.888;;RPRVTAX
 ;;.889;;RPRVNPI
 ;;.89;;SSYMPDT
 ;;.91;;EMPREL
 ;;.911;;LSEEDT
 ;;.912;;SPRV
 ;;.916;;DRCD
 ;;.922;;INHCLIA
 ;;.923;;REFLCLIA
 ;;.99;;PREPYAMT
 ;;10;;1500L19
 ;;END
 ;abm*2.6*8 added .29 field above
 ;
 ; ********************************
EXT ;EP 
 ;EXTERNAL CALL (NEEDS DA DEFINED)
 S DIC="^ABMDBILL(DUZ(2),"
 S X="A"
 D START
 K ABM,ABMP,ABMA,ABME
 Q
