ACHSTXAR ; IHS/ITSC/PMF - REGENERATION OF EXPORT GLOBAL ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**13,14,21,26,28,29,32**;JUN 11, 2001;Build 39
 ;ACHS*3.1*13 6.26.2007 IHS/OIT/FCJ FIXED EXITING IF NO DOC SELECTED
 ;ACHS*3.1*14 11.5.2007 IHS/OIT/FCJ RE-EXPORT UFMS INSTEAD OF CORE RECORDS
 ;ACHS*3.1*26 2.26.2016 IHS/OIT/FCJ ADDED RANGE SELECTION OPTION
 ;ACHS*3.1*28 10.18.2019 IHS.OIT.FCJ ADDED CHANGE FOR RE-EXP OF SPECIFIC RECORD TYPE
 ;ACHS*3.1*29 7.1.2021 IHS.OIT.FCJ REMOVED OPT FOR FI TRIBAL SITES TO SELECT PAID DOC
 ;ACHS*3.1*32 11.14.2024 IHS.OIT.FCJ MOD TO EXPORT FI TRIBAL SITES BY TX STATUS FILE
 ;
 ;ACHS*3.1*28 NO LONGER NEEDED BECAUSE MORE THAN 1 EXPORT A DAY ALLOWED
 ;I 'ACHSREEX,$D(^ACHSTXST("C",DT,DUZ(2))) W !!,"EXPORT PROGRAM ALREADY RUN THIS DATE FOR THIS FACILITY",*7 H 2 G EXIT1
 ;TEST FOR TRIBE  ;ACHS*3.1*28
 ;S ACHSF638=$$PARM^ACHS(0,8) S ACHSREXT=$S($$PARM^ACHS(0,8)="Y":"F",1:"S")
 S ACHSF638=$$PARM^ACHS(0,8) S ACHSREXT=$S($$PARM^ACHS(2,11)="Y":"F",1:"T")
 I ACHSF638="N" D  G EXIT1:$D(DUOUT)!$D(DTOUT)
 .S ACHSREXT=$$DIR^XBDIR("S^B:Re-Export FI and UFMS Files;U:Re-Export UFMS File;F:Re-Export FI File","Which Re-export Type","B","","Select one of the re-export types or ""^""","^D HELP^ACHSTXAR(""H2"")","2")
 S Y=$$DIR^XBDIR("S^1:Re-Export a Batch;2:Select (up to) 101 PO Documents;3:Select range for Initial PO Documents only","Which Re-export option","1","","Select one of the re-export options or ""^""","^D HELP^ACHSTXAR(""H"")","2")
 G EXIT1:$D(DUOUT)!$D(DTOUT)
 ;ACHS*3.1*13 IHS/OIT/FCJ ADDED TEST FOR ^TMP IN NXT LINE TO EXIT IF NO DOCS SELECTED ACHS*3.1*14 CHANGE RTN FR ACHSTXA1 TO ACHSTXF1
 ;I Y=2 D SELDOC G EXIT1:$D(DUOUT)!$D(DTOUT)!'$D(^TMP("ACHSTXAR",$J)),^ACHSTXA1
 ;ACHS*3.1*28 TEST FOR BOTH UFMS,FI RECORDS
 I Y=2 D SELDOC G EXIT1:($D(DUOUT))!($D(DTOUT))!('$D(^TMP("ACHSTXAR",$J))) G ^ACHSTXF1:ACHSTXTY="U" G ^ACHSTXA1
 I Y=3 D SELRANG G EXIT1:($D(DUOUT))!($D(DTOUT))!('$D(^TMP("ACHSTXAR",$J))) G ^ACHSTXF1:ACHSTXTY="U" G ^ACHSTXA1
 D LINES^ACHSFU,HDR
 S ACHSCHSS=""
 D ^ACHSUF
 K ACHSCHSS
 S (J,ACHSEDT,ACHSBDT)=0,ACHSRR=""
 F I=2:1:7 S ACHSRTYP(I)=0
 W !?10,"FACILITY NAME: ",$$LOC^ACHS
L1 ;
 I '$D(^ACHSTXST(DUZ(2),1,0)) W !!,*7,"NO DATA ON FILE FOR THIS FACILITY, JOB CANCELLED" G EXIT1
 S ACHS("MAX")=+$P($G(^ACHSTXST(DUZ(2),1,0)),U,4),ACHS("NUM")=10
 S:ACHS("MAX")<10 ACHS("NUM")=ACHS("MAX")
 S Y=$$DIR^XBDIR("NO^1:"_ACHS("MAX"),"ENTER NUMBER OF EXPORT ENTRIES TO DISPLAY ",ACHS("NUM"),"","ENTER A NUMBER BETWEEN 1 AND "_ACHS("MAX"),"",2)
 G L2:(Y=""),EXIT1:$D(DUOUT)!$D(DTOUT)
 S ACHS("NUM")=+Y
L2 ;
 S (ACHSR,ACHSRR)=0,ACHSLCAT=0,ACHSDIEN=0  ;ACHS*3.1*32 ADDED ACHSDIEN
 D HDR1
L3 ;
 S ACHSR=$O(^ACHSTXST("AC",DUZ(2),ACHSR))
 G L4:ACHSR=""
 S ACHSRR=$O(^ACHSTXST("AC",DUZ(2),ACHSR,""))
 G L3:ACHSRR=""
 S ACHSLCAT=ACHSLCAT+1,X=^ACHSTXST(DUZ(2),1,ACHSRR,0),X1=$$FMTE^XLFDT($P(X,U)),X2=$$FMTE^XLFDT($P(X,U,2)),X3=$$FMTE^XLFDT($P(X,U,3)),ACHS(ACHSLCAT)=ACHSRR
 ;ACHS*3.1*32 COMMENT OUT NXT LINE AND ADDED NXT 3 LINES FOR TRIBAL EXPORTS
 ;S X4=$S($P(X,U,21)="B":"Re-export UFMS/FI",$P(X,U,21)="F":"Re-export FI",$P(X,U,21)="U":"Re-export UFMS",$P(X,U,21)="S":"Re-export Stat",1:"Export-Standard")  ;ACHS*3.1*28;ACHS*3.1*32
 S X4=$P(X,U,21)    ;ACHS*3.1*32
 I X4="N" S X4=$S($P(X,U,20)="U":"UFMS/FI",$P(X,U,20)="S":"FI",$P(X,U,20)="T":"STATISTICAL",1:"")  ;ACHS*3.1*32
 E  S X4=$S(X4="B":"Re-export UFMS/FI",X4="F":"Re-export FI",X4="U":"Re-export UFMS",X4="T":"Re-export Stat",1:"")  ;ACHS*3.1*32
 ;ACHS*3.1*32 ST OF CHANGE FOR REC CT
 S ACHSRCT=0
 I $D(^ACHSTXST(DUZ(2),1,ACHSRR,2)) D
 .S ACHSTXD=0 F  S ACHSTXD=$O(^ACHSTXST(DUZ(2),1,ACHSRR,2,ACHSTXD)) Q:ACHSTXD'?1N.N  D
 ..S ACHSDIEN=$P(^ACHSTXST(DUZ(2),1,ACHSRR,2,ACHSTXD,0),U) Q:'$D(^ACHSF(DUZ(2),"D",ACHSDIEN))
 ..S ACHSRCT=ACHSRCT+1
 E  S ACHSRCT=$P(X,U,5)
 ;W $J(ACHSLCAT,4),?6,X1,?26,X2,?40,X3,?55,$J($P(X,U,5),5),?63,X4,!   ;ACHS*3.1*28
 W $J(ACHSLCAT,4),?6,X1,?26,X2,?40,X3,?54,$J(ACHSRCT,5),?63,X4,!
 ;ACHS*3.1*32 END OF CHANGE FOR REC CT
 I ACHSLCAT+1>ACHS("NUM") G L4
 I '(ACHSLCAT#10) W:$$DIR^XBDIR("E","'^' TO STOP ") "" G:$D(DUOUT) L4 D HDR1
 G L3
 ;
L4 ;
 I 'ACHSLCAT G NORECDS^ACHSTX8
 S Y=$$DIR^XBDIR("N^1:"_ACHSLCAT,"ENTER ITEM # FOR EXPORT DATE","","","","",2)
 G NORECDS^ACHSTX8:$D(DUOUT)!$D(DTOUT)
 S ACHS("REXNUM")=ACHS(+Y)
 W *7,!!!?15,"*******************NOTICE******************",!?15,"The number of records in this re-export",!?15,"might differ from the number in the original.",!?15,"*******************************************",!!
 D KILLGLBS^ACHSTX
 ;I ACHSTXTY="U" G ^ACHSTXF1  ;ACHS*3.1*28 RE-EXP BY DOCS IN ACHSTXST NOT BY DATE; ONLY FOR UFMS FILES
 ;ACHS*3.1*32 NOW EXPORTING BY DOCS FOR TRIBAL FI SITES
 ;I (ACHSF638="N"),(ACHSTXTY="U")!(ACHSREXT?.1"B".1"F".1"U") G ^ACHSTXF1   ;ACHS*3.1*28 ;ACHS*3.1*32
 I $$PARM^ACHS(2,11)="Y",(ACHSREXT?.1"B".1"F".1"U") G ^ACHSTXF1   ;ACHS*3.1*28 ;ACHS*3.1*32
 S ACHSBDT=$P($G(^ACHSTXST(DUZ(2),1,ACHS("REXNUM"),0)),U,2)
 S ACHSBDT=ACHSBDT-1
 S ACHSEDT=$P($G(^ACHSTXST(DUZ(2),1,ACHS("REXNUM"),0)),U,3)
 K ACHS("MAX"),ACHS("NUM"),ACHSLCAT,ACHSR,ACHSRR,X1,X2,X3
 G S2^ACHSTX2
 ;
HDR1 ;
 ;W !!,"ITM #",?10,"EXPORT DATE",?25,"BEG DATE",?40,"END DATE",?55,"# RECORDS",!!      ;ACHS*3.1*28
 ;W !!,"ITM#",?6,"EXPORT DATE",?26,"BEG DATE",?40,"END DATE",?53,"# RECORDS",?64,"RE-EXPORT TYPE",!!  ;ACHS*3.1*28
 W !!,"ITM#",?6,"EXPORT DATE",?26,"BEG DATE",?40,"END DATE",?53,"PO-COUNT",?64,"RE-EXPORT TYPE",!!  ;ACHS*3.1*32
 Q
 ;
HDR ;
 U IO(0)
 W @IOF,!,ACHS("*"),!?22,"GENERATE PREVIOUS CHS TRANSMISSION DATA",!,ACHS("*"),!
 Q
 ;
EXIT1 ;
 U IO(0)
 W !!,"JOB CANCELLED BY OPERATOR"
 D KILL^ACHSTX8
 Q
 ;
SELDOC ; Select transactions from particular documents for export.     
 K ^TMP("ACHSTXAR",$J)
 N D,T
 F  D ^ACHSUD Q:$D(DUOUT)!$D(DTOUT)!'$D(ACHSDIEN)  D  Q:%>101
 . S T=$$SELTRANS(ACHSDIEN)
 . I $D(DUOUT)!$D(DTOUT)!'T S %=102 Q
 . I $P(T,U,2)="-" S T=$P(T,U,1) K ^TMP("ACHSTXAR",$J,$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0),U),ACHSDIEN,T)
 . E  S ^TMP("ACHSTXAR",$J,$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0),U),ACHSDIEN,T)=""
 . ;Sel Doc Index
 . S (%,ACHSSDI)=0
 . W !!,"The list now consists of the following transactions:"
 . F  S ACHSSDI=$O(^TMP("ACHSTXAR",$J,ACHSSDI)) Q:'ACHSSDI  S D=0 F  S D=$O(^TMP("ACHSTXAR",$J,ACHSSDI,D)) Q:'D  S T=0 F  S T=$O(^TMP("ACHSTXAR",$J,ACHSSDI,D,T)) Q:'T  D
 .. ;
 .. S %=%+1
 .. W !,$J(%,2),".  ",$P(^ACHSF(DUZ(2),"D",D,0),U,14),"-",$$FC^ACHS(DUZ(2)),"-",$P(^ACHSF(DUZ(2),"D",D,0),U,1)
 .. D DISTRANS(D,T)
 ..Q
 . I %=101 S %=102
 .Q
 K ACHSDIEN
 I $$DIR^XBDIR("E")
 Q
 ;
SELRANG ; Select Document range only Initial transactions.     
 K ^TMP("ACHSTXAR",$J)
 N D,T
 S SEL=1
BEGDOC ;
 W !!!,"ENTER THE BEGINNING DOCUMENT NUMBER"
 D ^ACHSUD Q:$D(DUOUT)!$D(DTOUT)!'$D(ACHSDIEN)
 S ACHSEDOC(SEL,"B")=ACHSDIEN_"^"_$E(X,1,2)_"-"_ACHSFC_"-"_$E(X,3,7)_"^"_X_"^"_$P(Y(0),U,27)_$E(X,3,7)
ENDDOC ;
 W !!!,"ENTER THE ENDING DOCUMENT NUMBER"
 D ^ACHSUD G:$D(DUOUT)!$D(DTOUT)!'$D(ACHSDIEN) BEGDOC
 I $P(Y(0),U,27)_$E(X,3,7)<$P(ACHSEDOC(SEL,"B"),U,4) W !!,"*****Document selected is not after beginning Document.*****" G ENDDOC
 S ACHSEDOC(SEL,"E")=ACHSDIEN_"^"_$E(X,1,2)_"-"_ACHSFC_"-"_$E(X,3,7)_"^"_X_"^"_$P(Y(0),U,27)_$E(X,3,7)
 ;ANOTHER DOC RANGE?
 S %=$$DIR^XBDIR("Y","Add additional Documents","N","","","",2)
 I Y S SEL=SEL+1 G BEGDOC
 Q:$D(DUOUT)
SETRTR ;SET TRANS FOR DOCUMENT RANGE
 F L=1:1:SEL D
 .S BEGDOC=$P(ACHSEDOC(L,"B"),U,3)-1,ENDDOC=$P(ACHSEDOC(L,"E"),U,3)
 .I $P(ACHSEDOC(L,"B"),U,3)>$P(ACHSEDOC(L,"E"),U,3) D
 ..F  S BEGDOC=$O(^ACHSF(DUZ(2),"D","B",BEGDOC)) Q:BEGDOC'?1N.N  D SETRTR1
 ..S BEGDOC=1000000 F  S BEGDOC=$O(^ACHSF(DUZ(2),"D","B",BEGDOC)) Q:(BEGDOC>ENDDOC)!(BEGDOC'?1N.N)  D SETRTR1
 .E  F  S BEGDOC=$O(^ACHSF(DUZ(2),"D","B",BEGDOC)) Q:(BEGDOC>ENDDOC)!(BEGDOC'?1N.N)  D SETRTR1
 ;DISPLAY Doc Index
 N ACHSQ S (%,ACHSSDI,ACHSQ)=0
 W !!,"The list now consists of the following transactions:"
 F  S ACHSSDI=$O(^TMP("ACHSTXAR",$J,ACHSSDI)) Q:'ACHSSDI  D  Q:ACHSQ
 .S D=0 F  S D=$O(^TMP("ACHSTXAR",$J,ACHSSDI,D)) Q:'D  S T=0 Q:ACHSQ  F  S T=$O(^TMP("ACHSTXAR",$J,ACHSSDI,D,T)) Q:'T  D  Q:ACHSQ
 .. S %=%+1
 .. W !,$J(%,2),".  ",$P(^ACHSF(DUZ(2),"D",D,0),U,14),"-",$$FC^ACHS(DUZ(2)),"-",$P(^ACHSF(DUZ(2),"D",D,0),U,1)
 .. D DISTRANS(D,T)
 .. I %#25=0 S:'$$DIR^XBDIR("E") ACHSQ=1
 K ACHSDIEN,BEGDOC,ENDDOC,ACHSEDOC,L,SEL
 W !!,"CONTINUE TO EXPORT RECORDS"
 I $$DIR^XBDIR("E")
 Q
SETRTR1 ;SET DOC TRANS IN TEMP
 S ACHSDIEN=0,ACHSDIEN=$O(^ACHSF(DUZ(2),"D","B",BEGDOC,ACHSDIEN))
 S ^TMP("ACHSTXAR",$J,$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",1,0),U),ACHSDIEN,1)=""
 Q
 ;
SELTRANS(D) ; Display trans of doc D, and allow selection.
 D HELP("H1")
 N C,T
 W !!?10,"----------------------------------------------------",!?10,"TRANS",?30,"TRANS",!?11,"NUM",?19,"D A T E",?30,"TYPE",?40,"AMOUNT",!?10,"----------------------------------------------------",!!
 S (C,T)=0
 ;
 ;ACHS*3.1*29 ST OF CHG
 ;F  S T=$O(^ACHSF(DUZ(2),"D",D,"T",T)) Q:+T=0  S Y=^(T,0),C=C+1,C(C)=T W !?10,$J(C,3) D DISTRANS(D,T)
 F  S T=$O(^ACHSF(DUZ(2),"D",D,"T",T)) Q:+T=0  D
 .S Y=^ACHSF(DUZ(2),"D",D,"T",T,0) I $P(^(0),U,2)="P",ACHSF638="Y",$$PARM^ACHS(2,11)="Y" Q
 .S C=C+1,C(C)=T W !?10,$J(C,3) D DISTRANS(D,T)
 ;ACHS*3.1*29 END OF CHG
 S Y=$$DIR^XBDIR("N^1:"_C,"Re-export which transaction","1","","Enter the number corresponding to the transaction you want re-exported","^D HELP^ACHSTXAR(""H1"")",2)
 Q:$D(DUOUT)!$D(DTOUT)!(Y=0) 0
 I Y<1 Q C(-1*Y)_"^-"
 Q C(Y)
 ;
DISTRANS(D,T) ; 
 S Y=^ACHSF(DUZ(2),"D",D,"T",T,0)
 W ?17,$$FMTE^XLFDT($P(Y,U,1)),?32,$P(Y,U,2),$P(Y,U,5),?35,$J($FN($P(Y,U,4),",",2),11),"   <",$$EXTSET^XBFUNC(9002080.02,1,$P(Y,U,2)),">"
 Q
 ;
HELP(L) ;EP - Display text at label L.
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"
 Q
 ;
H ;
 ;;Selection of individual documents is intended to allow the local
 ;;service unit to clear documents that are not processing at higher
 ;;levels.
 ;;
 ;;E.g., if an FI document is PEND'ing for no obligation (P259), the
 ;;S.U. may want to selectively re-export the initial obligation
 ;;transaction of the document.
 ;;
 ;;Re-export the pay transaction will not export
 ;;"ZA" and "IP" transactions. 
 ;;
 ;;Option 3 is used to select export of only INITIAL transactions,
 ;;using a document range.
 ;;
 ;;###
 ;
H1 ;
 ;;Enter a number corresponding to the transaction that you want to re-export.
 ;;Enter a "-" before the number to remove the transaction from the list.
 ;;###
 ;
H2 ;ACHS*3.1*28
 ;;Enter the corresponding Letter for type of Export.
 ;;
 ;;By Selecting "B" both UFMS and FI files will be created for export
 ;;By Selecting "U" only an UFMS file will be created for export
 ;;By Selecting "F" only a FI file will be created for export
 ;;###
 ;
