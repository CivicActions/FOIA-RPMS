BLRCANRP ; IHS/MSC/MKK - IHS CANcelled tests RePort ; 28-Oct-2022 O9:30 ; MKK
 ;;5.2;IHS LABORATORY;**1054**;NOV 01, 1997;Build 20
 ;
EEP ; EP -- Ersatz Entry Point
 W !!,$C(7),$C(7),$C(7)
 W ?9,$$SHOUTMSG^BLRGMENU("Must use Line Labels to access subroutines",60)
 W !!,$C(7),$C(7),$C(7)
 Q
 ;
 ;
PEP ; EP
REPORT ; EP - Report
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 S HEADER(1)="Accession (#68) File"
 S HEADER(2)="Not Performed Tests"
 ;
 D HEADERDT^BLRGMENU
 D B^LRU
 I $G(X)=U Q    ; Quit if FileMan exit
 I $G(LRSDT)<1!($G(LRLDT)<1) D BADSTUFF("Invalid Date Range Input.")  Q
 ;
 S HEADER(3)=$$CJ^XLFSTR("Date Range:"_$$FMTE^XLFDT(LRSDT,"2DZ")_" thru "_$$FMTE^XLFDT(LRLDT,"2DZ"),IOM)
 ;
 D HEADERDT^BLRGMENU
 W ?4,"Compiliation Begins"
 ;
 K ^TMP("BLRCANRP",$J)
 S LRAA=.9999999,(CNTLRAS,CNT)=0
 F  S LRAA=$O(^LRO(68,LRAA))  Q:LRAA<1  D
 . S LRSUB=$$GET1^DIQ(68,LRAA,"LR SUBSCRIPT","I")
 . ;
 . ; Set LRAD based on CLEAN UP field in file 68.
 . S CLEANUP=$$GET1^DIQ(68,LRAA,"CLEAN UP","I")
 . S:CLEANUP="D" LRAD=$$FMADD^XLFDT(LRSDT,-1)
 . S:CLEANUP="W" LRAD=$$FMADD^XLFDT(LRSDT,-7)
 . I CLEANUP="M" D
 .. I (+$E(LRSDT,4,5)-1)>0 S LRAD=$E(LRSDT,1,3)_$TR($J((+$E(LRSDT,4,5)-1),2)," ","0")_"00"
 .. I (+$E(LRSDT,4,5)-1)<1 S LRAD=($E(LRSDT,1,3)-1)_"1231"
 . S:CLEANUP="Q" LRAD=($E(LRSDT,1,3)-1)_"1231"
 . S:CLEANUP="Y" LRAD=($E(LRSDT,1,3)-1)_"1231"
 . ;
 . F  S LRAD=$O(^LRO(68,LRAA,1,LRAD))  Q:LRAD<1  D
 .. S LRAN=0
 .. F  S LRAN=$O(^LRO(68,LRAA,1,LRAD,1,LRAN))  Q:LRAN<1  D
 ... S CNTLRAS=CNTLRAS+1
 ... I (CNTLRAS#1000)=0 W "."  W:$X>68 ?69,$J($FN(CNTLRAS,","),11),!,?4
 ... ;
 ... S LRAAIEN=LRAN_","_LRAD_","_LRAA
 ... S ORDDATE=$$GET1^DIQ(68.02,LRAAIEN,"DATE ORDERED","I")
 ... I ORDDATE<LRSDT!(ORDDATE>LRLDT) Q
 ... ;
 ... S LRDFN=$$GET1^DIQ(68.02,LRAAIEN,"LRDFN","I")
 ... S LRIDT=$$GET1^DIQ(68.02,LRAAIEN,"INVERSE DATE","I")
 ... S LRUID=$$GET1^DIQ(68.02,LRAAIEN,"UID")
 ... ;
 ... D:LRSUB="CH" F63MSG(LRDFN,LRIDT,.F63MSG)
 ... ;
 ... S LRAT=0
 ... F  S LRAT=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRAT))  Q:LRAT<1  D
 .... S DISP=$$GET1^DIQ(68.04,LRAT_","_LRAAIEN,"DISPOSITION")
 .... S DATANAME=$$GET1^DIQ(60,LRAT,"DATA NAME","I")
 .... I DATANAME,$P($G(^LR(LRDFN,"CH",LRIDT,DATANAME)),U)["canc" D
 ..... S DATASTR=$G(^LR(LRDFN,"CH",LRIDT,DATANAME))
 ..... S DISP="*"_$$GET1^DIQ(60,LRAT,"NAME")_" Not Performed: "_$$FMTE^XLFDT($P(DATASTR,U,6),"5MPZ")_" by "_$P(DATASTR,U,4)_" *NP Reason: canc"
 .... Q:DISP'["*N"
 .... ;
 .... S TECH=$$GET1^DIQ(68.04,LRAT_","_LRAAIEN,"TECHNOLOGIST","I")
 .... S COMPDATE=$$GET1^DIQ(68.04,LRAT_","_LRAAIEN,"COMPLETE DATE","I")
 .... S ^TMP("BLRCANRP",$J,COMPDATE,LRUID,LRAT)=TECH_U_ORDDATE_U_$S($G(F63MSG)'="":F63MSG,1:DISP)
 .... S CNT=CNT+1
 ;
 I $X<70 W ?69,$J($FN(CNTLRAS,","),11),!,?4,"Compilation Complete.",!!
 E  W !,?4,"Compilation Complete."
 ;
 W !!,?9,CNTLRAS," Accessions analyzed."
 W !!,?14,$S(CNT:"",1:"No "),"NOT PERFORMED entr",$$PLURALI(CNT)," detected."
 D PRESSKEY^BLRGMENU(4)
 ;
 Q:CNT<1
 ;
 I $G(QFLG)="Q"  K ^TMP("BLRCANRP",$J)  Q
 ;
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HDRONE)
 D HEADERDT^BLRGMENU
 ;
 S HEADER(4)=" "
 S HEADER(5)="Complete"
 S $E(HEADER(5),23)=$$COLHEAD^BLRGMENU("File 200",20)
 S HEADER(6)="Date"
 S $E(HEADER(6),11)="UID"
 S $E(HEADER(6),23)="IEN"
 S $E(HEADER(6),30)="Name"
 S $E(HEADER(6),45)="Not Performed Message"
 ;
 D ^%ZIS
 I POP D BADSTUFF("Error Opening Device.")  Q
 ;
 U IO
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,PG)=0,QFLG="NO"
 ;
 S COMPDATE="A"
 F  S COMPDATE=$O(^TMP("BLRCANRP",$J,COMPDATE),-1)  Q:COMPDATE<1!(QFLG="Q")  D
 . S LRUID=0
 . F  S LRUID=$O(^TMP("BLRCANRP",$J,COMPDATE,LRUID))  Q:LRUID<1!(QFLG="Q")  D
 .. S LRAT=0
 .. F  S LRAT=$O(^TMP("BLRCANRP",$J,COMPDATE,LRUID,LRAT))  Q:LRAT<1!(QFLG="Q")  D
 ... S TECH=$P($G(^TMP("BLRCANRP",$J,COMPDATE,LRUID,LRAT)),U)
 ... S TECHNAME=$$GET1^DIQ(200,+$G(TECH),"NAME")
 ... S ORDDATE=$P($G(^TMP("BLRCANRP",$J,COMPDATE,LRUID,LRAT)),U,2)
 ... S DISP=$P($G(^TMP("BLRCANRP",$J,COMPDATE,LRUID,LRAT)),U,3)
 ... ;
 ... I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 ... ;
 ... W $$FMTE^XLFDT(COMPDATE,"2DZ")
 ... W ?10,LRUID
 ... W ?22,TECH
 ... W ?29,$E(TECHNAME,1,13)
 ... D LINEWRAP^BLRGMENU(44,DISP,36)
 ... W !
 ... S LINES=LINES+1
 ... S CNT=CNT+1
 ;
 W !!,?4,$S(CNT:CNT,1:"No")," Test",$$PLURAL(CNT)," with "_$S(CNT=1:"a ",1:"")_"Not Performed Message",$$PLURAL(CNT),"."
 ;
 D ^%ZISC
 ;
 D PRESSKEY^BLRGMENU(9)
 ;
 K ^TMP("BLRCANRP",$J)
 Q
 ;
 ;
F63MSG(LRDFN,LRIDT,F63MSG) ; EP - Get Message lines from File 63
 NEW LINE,STR,SUB
 ;
 S F63MSG="",LINE=0
 F  S LINE=$O(^LR(LRDFN,"CH",LRIDT,1,LINE))  Q:LINE<1  D
 . S STR=$G(^LR(LRDFN,"CH",LRIDT,1,LINE,0))
 . Q:$E(STR)="~"     ; Skip Order Comments
 . ;
 . S F63MSG=F63MSG_" "_STR
 ;
 Q:F63MSG=""
 ;
 S SUB("  ")=" "
 S F63MSG=$$REPLACE^XLFSTR(F63MSG,.SUB)  ; Get rid of any double blanks.
 Q
 ;
 ;
 ; ============================= UTILITIES =============================
 ;
NEWINIT ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 Q
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variable(s)
 K BLRVERN,BLRVERN2
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=$G(TWO)
 Q
 ;
BADSTUFF(MSG,TAB) ; EP - Generic Message display
 S TAB=$G(TAB,4)
 W !!,?TAB,MSG,"  Routine Ends."
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
 ;
PLURAL(CNT) ; EP - Return null if CNT=1, else return "s"
 Q $S(CNT=1:"",1:"s")
 ;
PLURALI(CNT) ; EP - Return "y" if CNT = 1, else return "ies"
 Q $S(CNT=1:"y",1:"ies")
