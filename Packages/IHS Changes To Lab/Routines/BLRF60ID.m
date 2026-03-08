BLRF60ID ; IHS/MSC/MKK - IHS Lab File 60 entries with Inactivation Date ; 08-August-2023 13:15 ; MKK
 ;;5.2;IHS LABORATORY;**1054**;NOV 01, 1997;Build 20
 ;
 ; MSC/MKK - Modification - LR*5.2*1054 - Item 96796 - Inactivation Date
 ;
 ;
EEP ; Ersatz EP
 D ^XBCLS
 W !!!,$C(7),$C(7),$C(7)
 W !!
 W ?9,$$SHOUTMSG^BLRGMENU("Must use Line Labels to access subroutines",60)
 W !!
 W !,$C(7),$C(7),$C(7),!
 Q
 ;
 ;
EP ; Entry Point
PEP ; Another Entry Point
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 S HEADER(1)="LABORATORY TEST (#60) File"
 S HEADER(2)="Tests With Inactivation Date"
 D SETHEAD(.HDRONE)
 ;
 S HEADER(3)=" "
 S $E(HEADER(4),5)="IEN"
 S $E(HEADER(4),15)="NAME"
 S $E(HEADER(4),60)="PANEL"
 S $E(HEADER(4),70)="INACT DATE"
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNTF60,CNTID,PG)=0,QFLG="NO"
 ;
 S F60IEN=.9999999
 F  S F60IEN=$O(^LAB(60,F60IEN))  Q:F60IEN<1!(QFLG="Q")  D
 . S CNTF60=CNTF60+1
 . S INACTDT=$$GET1^DIQ(60,F60IEN,"INACTIVATION DATE","I")
 . Q:INACTDT=""
 . ;
 . S F60NAME=$$GET1^DIQ(60,F60IEN,"NAME")
 . ;
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 . ;
 . W ?4,F60IEN
 . W ?14,F60NAME
 . W ?59,$S($$ISPANEL^BLRPOC(F60IEN):"YES",1:"")
 . W:INACTDT ?69,$$FMTE^XLFDT(INACTDT,"5DZ")
 . W !
 . S CNTID=CNTID+1
 . S LINES=LINES+1
 ;
 W !!,?4,$FN(CNTF60,",")," LABORATORY TEST FILE entries analyzed."
 W !!,?9,$S(CNTID:CNTID,1:"No ")," LABORATORY TEST FILE entr",$$PLURALI(CNTID)," with Inactivation Date."
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
 ;
 ; ============================= UTILITIES =============================
 ;
JUSTNEW ; EP - Generic RPMS EXCLUSIVE NEW
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variable(s)
 K BLRVERN,BLRVERN2
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=$G(TWO)
 Q
 ;
BADSTUFF(STR) ; EP - Display "Bad" Message - procedure
 W !,?4,STR,"  Routine Ends."
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
PLURAL(CNT) ; EP - If CNT=1 return "" ELSE return "s"
 Q $S(CNT=1:"",1:"s")
 ;
PLURALI(CNT) ; EP - If CNT=1 return "y" ELSE return "ies"
 Q $S(CNT=1:"y",1:"ies")
 ;
SETHEAD(HDRONE) ; EP - Setup HDRONE variable
 D HEADERDT^BLRGMENU
 D HEADONE(.HDRONE)
 D HEADERDT^BLRGMENU
 Q
 ;
HEADONE(HD1) ; EP - Asks if user wants only 1 header line
 D ^XBFMK
 S DIR("A")="One Header Line ONLY"
 S DIR("B")="NO"
 S DIR(0)="YO"
 D ^DIR
 S HD1=$S(+$G(Y)=1:"YES",1:"NO")
 Q
 ;
