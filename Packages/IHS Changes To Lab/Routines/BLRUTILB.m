BLRUTILB ;IHS/MSC/MKK - MISC IHS LAB UTILITIES (Cont) ; 14-Oct-2022 11:50 ; MKK
 ;;5.2;IHS LABORATORY;**1052**;NOV 01, 1997;Build 17
 ;
 ; MSC/MKK - LR*5.2*1052 - Item 74980 - Count Accessioned Tests Menu Options
 ;
EEP ; EP - Ersatz EP
 W !!,"Must use LineLabels to access subroutines.",!!
 Q
 ;
 ;
PEP ; EP
EP ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 S HEADER(1)="Count accessioned tests"
 ;
 D ADDTMENU^BLRGMENU("TSTTYPMN^BLRUTILC","Test Counts By Type ...")
 D ADDTMENU^BLRGMENU("CHTSONLY^BLRUTILB","Chemistry Test Counts")
 D ADDTMENU^BLRGMENU("CHLOCTST^BLRUTILB","Chemistry Location Counts")
 D ADDTMENU^BLRGMENU("MITSONLY^BLRUTILB","Microbiology Test Counts")
 D ADDTMENU^BLRGMENU("MILOCTST^BLRUTILB","Microbiology Location Counts")
 ;
 D MENUDRFM^BLRGMENU("Count Tests","Locations/Tests")
 Q
 ;
 ;
CHTSONLY ; EP - CHemistry - TestS ONLY Counts
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 S HEADER(1)="Test Counts"
 D HEADERDT^BLRGMENU
 D B^LRU
 I $G(LRSDT)<1!($G(LRLDT)<1) D BADSTUFF("Invalid/Quit/No Input.  Routine Ends.")  Q
 ;
 S HEADER(2)="Date Range: "_$$FMTE^XLFDT(LRSDT)_" thru "_$$FMTE^XLFDT(LRLDT)
 ;
 Q:$$CCHTSTLO(.CNTPATS)="Q"  ; Chemistry Compilation
 ;
 D ^%ZIS
 I POP D BADSTUFF("Could not open device.")  Q
 ;
 S HEADER(3)=" "
 S $E(HEADER(4),5)=$$COLHEAD^BLRGMENU("LABORATORY TEST (#60) FILE",60)
 S $E(HEADER(5),5)="IEN"
 S $E(HEADER(5),15)="Description"
 S $E(HEADER(5),70)="TEST COUNT"
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,PG)=0,QFLG="NO"
 ;
 U IO
 S F60IEN=0
 F  S F60IEN=$O(^TMP($J,"TESTLOC",F60IEN))  Q:F60IEN<1!(QFLG="Q")  D
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG)  Q:QFLG="Q"
 . W ?4,F60IEN
 . W ?14,$E($$GET1^DIQ(60,F60IEN,"NAME"),1,40)
 . W ?69,$J($FN($G(^TMP($J,"TESTLOC",F60IEN)),","),10)
 . W !
 . S LINES=LINES+1
 . S CNT=CNT+1
 ;
 I CNT D
 . W ?69,$TR($J("",10)," ","-"),!
 . W ?51,"All Tests Total"
 . W ?69,$J($FN($G(^TMP($J,"TESTLOC")),","),10),!
 ;
 I CNT<1 D
 . W !
 . F I=3:1:5  K HEADER(I)
 . D HEADERDT^BLRGMENU
 . W !,?9,"All Tests Total: ",$FN($G(^TMP($J,"TESTLOC")),","),!
 ;
 W !!
 W ?4,"Total # of Patients analyzed: ",CNTPATS,!
 ;
 D ^%ZISC
 ;
 D PRESSKEY^BLRGMENU(4)
 K ^TMP($J)
 Q
 ;
 ;
CCHTSTLO(CNTPATS) ; EP - Compilation of CH Data into ^TMP($J) global
 D HEADERDT^BLRGMENU
 W ?4,"Compiling"
 ;
 K ^TMP($J),CNTPATS
 S LRDFN=.9999999,(CNT,CNTPATS)=0
 F  S LRDFN=$O(^LR(LRDFN))  Q:LRDFN<1  D
 . S LRIDT=0
 . F  S LRIDT=$O(^LR(LRDFN,"CH",LRIDT))  Q:LRIDT<1  D
 .. S CNT=CNT+1
 .. I (CNT#1000)=0 W "."  I $X>68 W ?69,$J($FN(CNT,","),11),!,?4
 .. ;
 .. S DRAWDATE=$P($P($G(^LR(LRDFN,"CH",LRIDT,0)),U),".")
 .. Q:DRAWDATE<LRSDT!(DRAWDATE>LRLDT)
 .. ;
 .. Q:$$CHVERIFY(LRDFN,LRIDT)="Q"
 .. ;
 .. S:$D(CNTPATS(LRDFN))<1 CNTPATS=CNTPATS+1,CNTPATS(LRDFN)=""
 .. ;
 .. S ^TMP($J,"DRAWDATE",DRAWDATE)=1+$G(^TMP($J,"DRAWDATE"))
 .. ;
 .. ; Get Location
 .. S F44IEN=$P($P($G(^LR(LRDFN,"CH",LRIDT,0)),U,13),";")
 .. S:F44IEN="" F44IEN="<NULL>"
 .. S DATANAME=1
 .. F  S DATANAME=$O(^LR(LRDFN,"CH",LRIDT,DATANAME))  Q:DATANAME<1  D
 ... S F60IEN=$O(^LAB(60,"C","CH;"_DATANAME_";1",0))
 ... I F60IEN D
 .... S ^TMP($J,"LOCTEST",F44IEN,F60IEN)=1+$G(^TMP($J,"LOCTEST",F44IEN,F60IEN))
 .... S ^TMP($J,"LOCTEST",F44IEN)=1+$G(^TMP($J,"LOCTEST",F44IEN))
 .... S ^TMP($J,"LOCTEST")=1+$G(^TMP($J,"LOCTEST"))
 .... ;
 .... S ^TMP($J,"TESTLOC",F60IEN,F44IEN)=1+$G(^TMP($J,"TESTLOC",F60IEN,F44IEN))
 .... S ^TMP($J,"TESTLOC",F60IEN)=1+$G(^TMP($J,"TESTLOC",F60IEN))
 .... S ^TMP($J,"TESTLOC")=1+$G(^TMP($J,"TESTLOC"))
 .... ;
 ... I F60IEN<1 D
 .... S ^TMP($J,"LOCDATANAME",F44IEN,DATANAME)=1+$G(^TMP($J,"LOCDATANAME",F44IEN,DATANAME))
 .... S ^TMP($J,"LOCDATANAME",F44IEN)=1+$G(^TMP($J,"LOCDATANAME",F44IEN))
 .... S ^TMP($J,"DATANAMELOC",DATANAME,F44IEN)=1+$G(^TMP($J,"DATANAMELOC",DATANAME,F44IEN))
 .... S ^TMP($J,"DATANAMELOC",DATANAME)=1+$G(^TMP($J,"DATANAMELOC",DATANAME))
 ;
 W:$X>59 !
 W " Compilation Complete.",!!
 ;
 D PRESSKEY^BLRGMENU(4)
 ;
 I $G(QFLG)="Q"  Q "Q"
 ;
 Q "OK"
 ;
CHVERIFY(LRDFN,LRIDT) ; EP - Chemistry - Verfiy Accession
 Q:$P($G(^LR(LRDFN,"CH",LRIDT,0)),U,3) "OK"   ; DATE REPORT COMPLETED
 ;
 ; If ANY test is resulted, treat the accession as verified.
 NEW DATANAME,OKAY
 S DATANAME=1,OKAY=0
 F  S DATANAME=$O(^LR(LRDFN,"CH",LRIDT,DATANAME))  Q:DATANAME<1!(OKAY)  D
 . S:$L($P($G(^LR(LRDFN,"CH",LRIDT,DATANAME)),U)) OKAY=OKAY+1
 ;
 Q $S(OKAY=1:"OK",1:"Q")
 ;
 ;
CHLOCTST ; EP - Chemistry - Locations Tests Report
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 S HEADER(1)="Location Tests Counts"
 D HEADERDT^BLRGMENU
 D B^LRU
 I $G(LRSDT)<1!($G(LRLDT)<1) D BADSTUFF("Invalid/Quit/No Input.  Routine Ends.")  Q
 ;
 S HEADER(2)="Date Range: "_$$FMTE^XLFDT(LRSDT)_" thru "_$$FMTE^XLFDT(LRLDT)
 ;
 Q:$$CCHTSTLO(.CNTPATS)="Q"  ; Compilation
 ;
 D ^%ZIS
 I POP D BADSTUFF("Could not open device.")  Q
 ;
 S HEADER(3)=" "
 S HEADER(4)=$$COLHEAD^BLRGMENU("HOSP LOC (#44) FILE",32)
 S $E(HEADER(4),35)=$$COLHEAD^BLRGMENU("LABORATORY TEST (#60) FILE",33)
 S HEADER(5)="Description"
 S $E(HEADER(5),35)="IEN"
 S $E(HEADER(5),45)="Description"
 S $E(HEADER(5),71)="Loc Count"
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,CNTLOC,PG)=0,QFLG="NO"
 ;
 U IO
 S F44IEN=0
 F  S F44IEN=$O(^TMP($J,"LOCTEST",F44IEN))  Q:F44IEN<1!(QFLG="Q")  D
 . S CNTLOC=CNTLOC+1
 . S F60IEN=0
 . F  S F60IEN=$O(^TMP($J,"LOCTEST",F44IEN,F60IEN))  Q:F60IEN<1!(QFLG="Q")  D
 .. I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG)  Q:QFLG="Q"
 .. W $E($$GET1^DIQ(44,F44IEN,"NAME"),1,32)
 .. W ?34,F60IEN,?44,$E($$GET1^DIQ(60,F60IEN,"NAME"),1,22)
 .. W ?69,$J($G(^TMP($J,"LOCTEST",F44IEN,F60IEN)),10)
 .. W !
 .. S LINES=LINES+1
 . W ?69,$TR($J("",10)," ","-"),!
 . W ?52,"Location Total"
 . W ?69,$J($FN($G(^TMP($J,"LOCTEST",F44IEN)),","),10),!
 . W !
 . S LINES=LINES+3
 ;
 I CNTLOC>1 D
 . W !,?69,$TR($J("",10)," ","-"),!
 . W ?48,"All Locations Total"
 . W ?69,$J($FN($G(^TMP($J,"LOCTEST")),","),10),!
 ;
 W !!,?4,"Total # of Patients analyzed:",CNTPATS,!
 ;
 D ^%ZISC
 ;
 D PRESSKEY^BLRGMENU(4)
 K ^TMP($J)
 Q
 ;
 ;
MITSONLY ; EP - MIcrobiology - TestS ONLY Counts
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 S HEADER(1)="Microbiology Test Counts"
 D HEADERDT^BLRGMENU
 D B^LRU
 I $G(LRSDT)<1!($G(LRLDT)<1) D BADSTUFF("Invalid/Quit/No Input.  Routine Ends.")  Q
 ;
 S HEADER(2)="Date Range: "_$$FMTE^XLFDT(LRSDT)_" thru "_$$FMTE^XLFDT(LRLDT)
 ;
 Q:$$CMITSTLO(.CNTPATS)="Q"  ; MI Compilation
 ;
 D ^%ZIS
 I POP D BADSTUFF("Could not open device.")  Q
 ;
 S HEADER(3)=" "
 S $E(HEADER(4),5)=$$COLHEAD^BLRGMENU("LABORATORY TEST (#60) FILE",60)
 S $E(HEADER(5),5)="IEN"
 S $E(HEADER(5),15)="Description"
 S $E(HEADER(5),70)="TEST COUNT"
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,PG)=0,QFLG="NO"
 ;
 U IO
 S F60IEN=0
 F  S F60IEN=$O(^TMP($J,"TESTLOC",F60IEN))  Q:F60IEN<1!(QFLG="Q")  D
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG)  Q:QFLG="Q"
 . W ?4,F60IEN
 . W ?14,$E($$GET1^DIQ(60,F60IEN,"NAME"),1,54)
 . W ?69,$J($FN($G(^TMP($J,"TESTLOC",F60IEN)),","),10)
 . W !
 . S LINES=LINES+1
 ;
 W ?69,$TR($J("",10)," ","-"),!
 W ?51,"All Tests Total"
 W ?69,$J($FN($G(^TMP($J,"TESTLOC")),","),10),!
 W !!
 W ?4,"Total # of Patients analyzed:",CNTPATS,!
 ;
 ;
 D ^%ZISC
 ;
 D PRESSKEY^BLRGMENU(4)
 K ^TMP($J)
 Q
 ;
 ;
MILOCTST ; EP - Microbiology - Locations Tests Counts
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 S HEADER(1)="Microbiology Locations Tests Counts"
 D HEADERDT^BLRGMENU
 D B^LRU
 I $G(LRSDT)<1!($G(LRLDT)<1) D BADSTUFF("Invalid/Quit/No Input.  Routine Ends.")  Q
 ;
 S HEADER(2)="Date Range: "_$$FMTE^XLFDT(LRSDT)_" thru "_$$FMTE^XLFDT(LRLDT)
 ;
 Q:$$CMITSTLO(.CNTPATS)="Q"  ; MI Compilation
 ;
 D ^%ZIS
 I POP D BADSTUFF("Could not open device.")  Q
 ;
 S HEADER(3)=" "
 S HEADER(4)=$$COLHEAD^BLRGMENU("HOSP LOC (#44) FILE",32)
 S $E(HEADER(4),35)=$$COLHEAD^BLRGMENU("LABORATORY TEST (#60) FILE",33)
 S HEADER(5)="Description"
 S $E(HEADER(5),35)="IEN"
 S $E(HEADER(5),45)="Description"
 S $E(HEADER(5),70)="TEST COUNT"
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,CNTLOC,PG)=0,QFLG="NO"
 ;
 U IO
 S F44IEN=0
 F  S F44IEN=$O(^TMP($J,"LOCTEST",F44IEN))  Q:F44IEN<1!(QFLG="Q")  D
 . S CNTLOC=CNTLOC+1
 . S F60IEN=0
 . F  S F60IEN=$O(^TMP($J,"LOCTEST",F44IEN,F60IEN))  Q:F60IEN<1!(QFLG="Q")  D
 .. I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG)  Q:QFLG="Q"
 .. W $E($$GET1^DIQ(44,F44IEN,"NAME"),1,32)
 .. W ?34,F60IEN
 .. W ?44,$E($$GET1^DIQ(60,F60IEN,"NAME"),1,24)
 .. W ?69,$J($G(^TMP($J,"LOCTEST",F44IEN,F60IEN)),10)
 .. W !
 .. S LINES=LINES+1
 . W ?69,$TR($J("",10)," ","-"),!
 . W ?52,"Location Total"
 . W ?69,$J($FN($G(^TMP($J,"LOCTEST",F44IEN)),","),10),!
 . W !
 . S LINES=LINES+3
 ;
 I CNTLOC>1 D
 . W !
 . W ?69,$TR($J("",10)," ","-"),!
 . W ?47,"All Locations Total"
 . W ?69,$J($FN($G(^TMP($J,"LOCTEST")),","),10),!
 ;
 W !!
 W ?4,"Total # of Patients analyzed:",CNTPATS,!
 ;
 ;
 D ^%ZISC
 ;
 D PRESSKEY^BLRGMENU(4)
 K ^TMP($J)
 Q
 ;
 ;
CMITSTLO(CNTPATS) ; EP - Compilation of Microbiology Data into ^TMP($J) global
 D HEADERDT^BLRGMENU
 W ?4,"Compiling"
 ;
 K ^TMP($J)
 S LRDFN=.9999999,(CNT,CNTPATS)=0
 F  S LRDFN=$O(^LR(LRDFN))  Q:LRDFN<1  D
 . S LRIDT=0
 . F  S LRIDT=$O(^LR(LRDFN,"MI",LRIDT))  Q:LRIDT<1  D
 .. S CNT=CNT+1
 .. I (CNT#1000)=0 W "."  I $X>68 W ?69,$J($FN(CNT,","),11),!,?4
 .. ;
 .. S DRAWDATE=$P($P($G(^LR(LRDFN,"MI",LRIDT,0)),U),".")
 .. Q:DRAWDATE<LRSDT!(DRAWDATE>LRLDT)
 .. ;
 .. Q:$$MIVERIFY(LRDFN,LRIDT)="Q"
 .. ;
 .. S:$D(CNTPATS(LRDFN))<1 CNTPATS=CNTPATS+1,CNTPATS(LRDFN)=""
 .. ;
 .. S ^TMP($J,"DRAWDATE",DRAWDATE)=1+$G(^TMP($J,"DRAWDATE"))
 .. ;
 .. S LRUID=$P($G(^LR(LRDFN,"MI",LRIDT,"ORU")),U)
 .. Q:$L(LRUID)<1
 .. ;
 .. S UIDSTR=$$CHECKUID^LRWU4(LRUID)
 .. Q:UIDSTR<1
 .. ;
 .. S LRAA=$P(UIDSTR,U,2),LRAD=$P(UIDSTR,U,3),LRAN=$P(UIDSTR,U,4)
 .. ;
 .. ; Get Location
 .. S F44IEN=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),U,13)
 .. S:F44IEN="" F44IEN="<NULL>"
 .. ;
 .. S LRAT=0
 .. F  S LRAT=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRAT))  Q:LRAT<1  D
 ... S F60IEN=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRAT,0)),U)
 ... I F60IEN D
 .... S ^TMP($J,"LOCTEST",F44IEN,F60IEN)=1+$G(^TMP($J,"LOCTEST",F44IEN,F60IEN))
 .... S ^TMP($J,"LOCTEST",F44IEN)=1+$G(^TMP($J,"LOCTEST",F44IEN))
 .... S ^TMP($J,"LOCTEST")=1+$G(^TMP($J,"LOCTEST"))
 .... ;
 .... S ^TMP($J,"TESTLOC",F60IEN,F44IEN)=1+$G(^TMP($J,"TESTLOC",F60IEN,F44IEN))
 .... S ^TMP($J,"TESTLOC",F60IEN)=1+$G(^TMP($J,"TESTLOC",F60IEN))
 .... S ^TMP($J,"TESTLOC")=1+$G(^TMP($J,"TESTLOC"))
 .... S CNT=CNT+1
 ;
 W:$X>59 !
 W " Compilation Complete.",!!
 ;
 D PRESSKEY^BLRGMENU(4)
 ;
 I $G(QFLG)="Q"  Q "Q"
 ;
 Q "OK"
 ;
MIVERIFY(LRDFN,LRIDT) ; EP - Microbiology - Verfiy Accession
 Q:$P($G(^LR(LRDFN,"MI",LRIDT,0)),U,3) "OK"   ; DATE REPORT COMPLETED
 Q:$P($G(^LR(LRDFN,"MI",LRIDT,1)),U) "OK"     ; BACT RPT DATE APPROVED
 Q "Q"
 ;
 ;
 ; =================== Utilities follow ===================
UTILTIES ; EP - Makes this easier to find
 Q
 ;
BADSTUFF(MSG,TAB) ; EP
 S TAB=$G(TAB,4)
 W !,?TAB,MSG
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variable(s)
 K BLRVERN,BLRVERN2
 S BLRVERN=$P($P($T(+1),";")," ")
 S:+$L($G(TWO)) BLRVERN2=TWO
 Q
 ;
