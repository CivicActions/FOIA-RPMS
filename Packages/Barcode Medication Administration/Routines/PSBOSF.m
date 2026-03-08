PSBOSF ;BIRMINGHAM/EFC-UNABLE TO SCAN DETAIL REPORT ;26-Apr-2023 14:17;DU
 ;;3.0;BAR CODE MED ADMIN;**28,1015,1033**;Mar 2004;Build 34
 ;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
 ;
 ; Reference/IA
 ; ^NURSF(211.4/1409
 ;
 ; Modified - IHS/MSC/PLS - 02/26/13 - Line BLDRPT+17
 ;                        - 01/03/23 - References to CHKDIV
 ;            IHS/MSC/MIR - 03/01/23 - Lines LISTWD+6:+11
 ;
EN ; UTS Report Entry Point - Report OPTION used by PSB UNABLE TO SCAN (UTS) key holders.
 N PSBX1,PSBX2,PSBX3,PSBIEN,PSBMRGST,PSBHDR,PSBTOT,PSBDSCN
 N PSBCMNT0,PSBCMNTX,PSBCMTLN,PSBCRLF,PSBI,PSBINDAT,PSBNDENT,PSBMRG,PSBX,I,J
 K PSBSRTBY,PSBSTWD
 ; Set Wards based on selection and user's Division - DUZ(2).
 S PSBSTWD=$P(PSBRPT(.1),U,3) I $G(PSBSTWD)'="" K PSBWARD D LISTWD
 K PSBWDDV D WARDDIV^PSBOST(.PSBWDDV,DUZ(2))
 ; Set Start and End dates/times.
 S PSBDTST=+$P(PSBRPT(.1),U,6)_$P(PSBRPT(.1),U,7)
 S PSBDTSP=+$P(PSBRPT(.1),U,8)_$P(PSBRPT(.1),U,9)
 ; Set the sort options internal values. If no sort option
 ; selected, default to ascending date/time.
 S PSBSRTBY=$G(PSBRPT(.52)) S:$G(PSBSRTBY)="" PSBSRTBY="2,,"
 D NOW^%DTC S Y=% D DD^%DT S PSBDTTM=Y
 ; Kill the scratch sort file.
 K ^XTMP("PSBO",$J,"PSBLIST"),PSBLIST
 S (PSBLNTOT,PSBTOT,PSBX1)="",PSBPGNUM=0
 S PSBX1=$$FMADD^XLFDT(PSBDTST,,,,-.1)
 ; Get the records from the MSF UTS log by date (PSBX1) and IEN (PSBX2).
 F  S PSBX1=$O(^PSB(53.77,"ASFDT",PSBX1)) Q:(PSBX1>PSBDTSP)!(+PSBX1=0)  D
 .S PSBX2="" F  S PSBX2=$O(^PSB(53.77,"ASFDT",PSBX1,PSBX2)) Q:PSBX2=""  D
 ..; Don't report successful scans.
 ..N PSBSCTYP S PSBSCTYP=$P(^PSB(53.77,PSBX2,0),U,5)
 ..; Don't list successful scans.
 ..I "WSCN,WKEY,MSCN,MKEY,MMME"[PSBSCTYP Q
 ..I '$D(^PSB(53.77,PSBX2,0))!($D(PSBLIST(PSBX2))) Q
 ..S PSBWRD=$P($P($G(^PSB(53.77,PSBX2,0)),U,3),"$",1)_"$"
 ..; Filter data by institution.
 ..I $$LOCCHK(PSBSTWD,PSBWRD) D
 ...L +^PSB(53.77,PSBX2):3 I  L -^PSB(53.77,PSBX2) S PSBLIST(PSBX2)=""
 S Y=PSBDTST D DD^%DT S Y1=Y S Y=PSBDTSP D DD^%DT S Y2=Y
 ; Create the Sort Option Header text.
 F X=1:1:3 D
 .S PSBHDR=$G(PSBHDR)_$S($P(PSBSRTBY,",",X)=1:"PATIENT'S NAME; ",$P(PSBSRTBY,",",X)=2:"DATE/TIME of UTS (ascending); ",$P(PSBSRTBY,",",X)=3:"LOCATION WARD/RmBd; ",1:"")
 .S PSBHDR=$G(PSBHDR)_$S($P(PSBSRTBY,",",X)=4:"TYPE; ",$P(PSBSRTBY,",",X)=5:"DRUG; ",$P(PSBSRTBY,",",X)=6:"USER'S NAME; ",1:"")
 .S PSBHDR=$G(PSBHDR)_$S($P(PSBSRTBY,",",X)=7:"REASON UNABLE TO SCAN; ",$P(PSBSRTBY,",",X)=-2:"DATE/TIME of UTS (descending); ",1:"")
 .Q
 S PSBHDR=$E(PSBHDR,1,($L(PSBHDR)-2))
 ; Add the record to the scratch sort file.
 D BLDRPT^PSBOSF1
 I PSBTOT=0 S PSBOUTP(0,14)="W !!,""<<<< NO DOCUMENTED BCMA UNABLE TO SCAN EVENTS FOR THIS DATE RANGE >>>>"",!!"
 ;
 ; Send the report.
 D WRTRPT
 K %,O,PSBBLANK,PSBDTSP,PSBDTST,PSBDTTM
 K PSBFLD,PSBLNO,PSBLNTOT,PSBMORE
 K PSBPG,PSBPGNUM,PSBPGRM,PSBRPT,PSBSFCMT,PSBSFHD2,PSBSRTBY,PSBSRTNM
 K PSBSTWD,PSBCMNT0,PSBTAB0,PSBTAB4,PSBTAB7,PSBTOT1,PSBTOTX,PSBVAL
 K PSBVAL1,PSBVAL2,PSBVAL3,PSBWARD,PSBWRD,PSBXORX,XX,Y1,Y2,YY,ZZ
 Q
 ;
WRTRPT ; Write the report.
 I $O(PSBOUTP(""),-1)<1 D  Q
 .S PSBOUTP(0,14)="W !!,""<<<< NO DOCUMENTED BCMA UNABLE TO SCAN EVENTS FOR THIS DATE RANGE >>>>"",!!"
 .D HDR
 .X PSBOUTP($O(PSBOUTP(""),-1),14)
 .D FTR
 S PSBPGNUM=1
 D HDR
 S PSBX1="" F  S PSBX1=$O(PSBOUTP(PSBX1)) Q:PSBX1=""  D
 .I PSBPGNUM'=PSBX1 D FTR S PSBPGNUM=PSBX1 D HDR
 .S PSBX2="" F  S PSBX2=$O(PSBOUTP(PSBX1,PSBX2)) Q:PSBX2=""  D
 ..X PSBOUTP(PSBX1,PSBX2)
 D FTR
 K ^XTMP("PSBO",$J,"PSBLIST"),PSBOUTP
 Q
 ;
HDR ; Write the report header.
 I '$D(PSBHDR) S PSBHDR=""
 W:$Y>1 @IOF W:$X>1 !
 S PSBPG="Page: "_PSBPGNUM_" of "_$S($O(PSBOUTP(""),-1)=0:1,1:$O(PSBOUTP(""),-1))
 S PSBPGRM=PSBTAB7-($L(PSBPG))
 I $P(PSBRPT(0),U,4)="" S $P(PSBRPT(0),U,4)=DUZ(2)
 D CREATHDR
 W !!,"BCMA UNABLE TO SCAN (Detailed)" W ?PSBPGRM,PSBPG
 W !!,"Date/Time: "_PSBDTTM,!,"Report Date Range:  Start Date: "_Y1_"   Stop Date: "_Y2
 W !,"Type of Scanning Failure: ",$S(+$P($G(PSBRPT(3)),",",1)=0:"All",+$P($G(PSBRPT(3)),",",1)=1:"Medication",1:"Wristband")
 W !,"Reason: " D
 .I $P($G(PSBRPT(3)),",",2)=0 W "All Reasons" Q
 .I $P($G(PSBRPT(3)),",",2)=1 W "Damaged Medication Label" Q
 .I $P($G(PSBRPT(3)),",",2)=2 W "Damaged Wristband" Q
 .I $P($G(PSBRPT(3)),",",2)=3 W "No Bar Code" Q
 .I $P($G(PSBRPT(3)),",",2)=4 W "Scanning Equipment Failure" Q
 .I $P($G(PSBRPT(3)),",",2)=5 W "Unable to Determine" Q
 .I $P($G(PSBRPT(3)),",",2)=6 W "Dose Discrepancy" Q
 W !,"Division: ",$P($G(^DIC(4,DUZ("2"),0)),U,1)
 W "    Nurse Location: " D
 .I $G(PSBSTWD)]"" W $$NURLOC(PSBSTWD) Q
 .W "All"
 W !,"Sorted By: "_PSBHDR,?(PSBTAB7-($L("Total BCMA Unable to Scan events: "_+PSBTOT))),"Total BCMA Unable to Scan events: "_+PSBTOT
 W !!,$$WRAP^PSBO(5,PSBTAB7-5,"This is a report of documented BCMA ""Unable to Scan"" events within the given date range.")
 W !!,$TR($J("",PSBTAB7)," ","_")
 I $D(PSBSFHD1) W !,PSBSFHD1
 I $D(PSBSFHD2) W !,PSBSFHD2
 W !,$TR($J("",PSBTAB7)," ","="),!
 Q
 ;
FTR ; Write the report footer.
 I IOSL<100 F  Q:$Y>(IOSL-12)  W !
 W !,$TR($J("",PSBTAB7)," ","=")
 W $$WRAP^PSBO(5,PSBTAB7-5,"Note: IV orders will display the orderable item associated with that IV Order in the Drug column."),!
 W !,PSBDTTM,!,"BCMA UNABLE TO SCAN (Detailed)"
 W ?PSBPGRM,PSBPG,!
 Q
 ;
PGTOT(X) ; Track PAGE Number.
 S:'$D(X) PSBLNTOT=PSBLNTOT+1 S:$D(X) PSBLNTOT=PSBLNTOT+X
 I PSBPGNUM=1,(PSBLNTOT=1) S PSBLNTOT=15 S PSBMORE=PSBLNTOT+7 Q PSBPGNUM
 I PSBLNTOT'<PSBMORE D
 .S PSBMORE=PSBLNTOT+7
 .I PSBMORE>(IOSL-9) S PSBPGNUM=PSBPGNUM+1,PSBLNTOT=15 S PSBMORE=PSBLNTOT+7
 Q PSBPGNUM
 ;
CREATHDR ; Create report header.
 K PSBSFHD1
 I IOM'<122 S PSBSFHD1=$P($T(SFHD132A),";",3),PSBSFHD2=$P($T(SFHD132B),";",3),PSBBLANK=$P($T(SF132BLK),";",3)
 I (IOM'>90),(IOM'<75) S PSBSFHD1=$P($T(SFHD80A),";",3),PSBSFHD2=$P($T(SFHD80B),";",3),PSBBLANK=$P($T(SF80BLK),";",3)
 I '$D(PSBSFHD1) S PSBTAB7=80 Q
 ; reset tabs
 S PSBTAB0=1 F PSBI=0:1:($L(PSBSFHD1,"|")-2) S:PSBI>0 @("PSBTAB"_PSBI)=($F(PSBSFHD1,"|",@("PSBTAB"_(PSBI-1))+1))-1
 Q
 ;
SFHD132A ;;| PATIENT'S NAME  | DATE/TIME |      LOCATION     |       |           DRUG            |                     |   REASON   |
 Q
SFHD132B ;;|     (PID)       |   of UTS  |      WARD/RmBd    | TYPE  |           (ID#)           |      USER'S NAME    |    UTS     |
 Q
SF132BLK ;;                 |           |                   |       |                           |                     |            |
 Q
SF80BLK ;;           |         |          |       |            |            |        |
 Q
SFHD80A ;;|PATIENT'S |DATE/TIME| LOCATION |       |   DRUG     |   USER'S   | REASON |
 Q
SFHD80B ;;|NAME (PID)|  of UTS | WARD/RmBd|  TYPE |   (ID#)    |   NAME     |  UTS   |
 Q
 ;
LISTWD ; List wards & nursing locations.
 K PSBWARD I $G(PSBSTWD)']"" Q
 N PSBLOOP S PSBLOOP=0
 F  S PSBLOOP=$O(^NURSF(211.4,PSBSTWD,3,PSBLOOP)) Q:PSBLOOP=""  D
 .S PSBWARD(PSBSTWD,$P($G(^NURSF(211.4,PSBSTWD,3,PSBLOOP,0)),U,1))=$P($G(^DIC(42,$P($G(^NURSF(211.4,PSBSTWD,3,PSBLOOP,0)),U,1),0)),U,1)_"$"
 .S PSBWARD(PSBSTWD,$P($G(^DIC(42,$P($G(^NURSF(211.4,PSBSTWD,3,PSBLOOP,0)),U,1),0)),U,1)_"$")=$P($G(^NURSF(211.4,PSBSTWD,3,PSBLOOP,0)),U,1)
 ; - IHS/OCA/JTC - 2022.05.17 - HOSPITAL LOCATION -
 I $G(PSBSTWD)>9000000 D
 .S BZO44=PSBSTWD-9000000
 .S PSBWARD(PSBSTWD,$$GET1^DIQ(44,BZO44,.01)_"$")=BZO44
 .K BZO44
 ; - END -
 Q
 ;
LOCNM(LOC) ;-
 N RES
 S RES="$"
 S RES=$$GET1^DIQ(44,$S(LOC>9000000:LOC-9000000,1:LOC),.01)_RES
 Q RES
 ;
NURLOC(X) ; Nursing Location Name.
 N PSBNULC
 S PSBNULC=$G(^NURSF(211.4,X,0))
 I PSBNULC="",X>9000000 S PSBNULC=$P($$LOCNM(X),"$")
 E  S PSBNULC=$P($G(^SC(PSBNULC,0)),U,1)
 Q PSBNULC
 ;
CHKDIV(PARA) ; Checks HOSPTIAL LOCATION, added 2019.7.15 jtc
 N LOCIEN,WRDDIV,TMPWRD
 S TMPWRD=$G(PARA) I TMPWRD="" S TMPWRD=$G(PSBWRD) ; USE PSBWRD if no PARAMETER is passed 2019.7.16 jtc
 I $P($G(TMPWRD),"$")="" K LOCIEN,WRDDIV Q 0
 I DUZ(2)="" K LOCIEN,WRDDIV Q 0
 S LOCIEN=$O(^SC("B",$P(TMPWRD,"$"),"")) ; REMOVE "$" FROM PSBWRD before lookup
 I LOCIEN="" K LOCIEN,WRDDIV,TMPWRD Q 0 ; No Location IEN found, return FALSE
 S WRDDIV=$$GET1^DIQ(44,LOCIEN,3,"I")
 I WRDDIV="" K LOCIEN,WRDDIV,TMPWRD Q 0 ; No division listed for this hospital location
 I WRDDIV=DUZ(2) K LOCIEN,WRDDIV,TMPWRD Q 1 ; We have a match, return TRUE
 K LOCIEN,WRDDIV,TMPWRD
 Q 0 ; No Match, return FALSE
 ;
 ; Input : USRLOC - Parameter passed from user
 ;         LOC - File entry location
LOCCHK(USRLOC,LOC) ;-
 N RES
 S RES=1
 Q:'$$CHKDIV(LOC) 0 ; doesn't match user division
 I $L($G(USRLOC)) Q:$$LOCNM(USRLOC)'=PSBWRD 0
 Q RES
