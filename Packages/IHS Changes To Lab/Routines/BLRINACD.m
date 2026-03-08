BLRINACD ; IHS/MSC/MKK - Set Test's INACTIVATION DATE in File 60 ; 27-Apr-2023 12:30 ; MKK
 ;;5.2;IHS LABORATORY;**1054**;NOV 01, 1997;Build 20
 ;
 ; MSC/MKK - LR*5.2*1054 - Item 96796 - Do not allow selection of tests with INACTIVATION DATE set
 ;
EEP ; EP - Ersatz EP
 D ^XBCLS
 W !,$C(7),$C(7),$C(7)
 W !!
 W ?9,$$SHOUTMSG^BLRGMENU("Must use Line Labels to access subroutines",60)
 W !!
 W !,$C(7),$C(7),$C(7),!
 Q
 ;
 ;
PEP ; EP 
INACTIDT ; EP - Inactive Specific Test
 I $$KCHK^XUSRB("LRSUPER",DUZ)<1 D BADSTUFF("Must have LRSUPER Security Key.")  Q
 ;
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 ;
 S HEADER(1)="LABORATORY TEST (#60) File"
 S HEADER(2)="INACTIVATION DATE"
 D HEADERDT^BLRGMENU
 ;
 D ^XBFMK
 S DIR(0)="PO^60:EMZ"
 D ^DIR
 I +$G(DIRUT)!(+Y<1) D BADSTUFF("Quit/No/Invalid Input.")  Q
 ;
 S F60IEN=+Y,F60DESC=$P(Y,U,2)
 S HEADER(3)=$$CJ^XLFSTR("Modify Test "_F60DESC_"  ["_F60IEN_"]",IOM)
 D HEADERDT^BLRGMENU
 ;
 S CURINCDT=$$GET1^DIQ(60,F60IEN,57,"I")
 ;
 D ^XBFMK
 S DIR(0)="DO^"_$$FMADD^XLFDT(DT,-365)_":"_DT
 S DIR("A")="INACTIVATION DATE"
 S:CURINCDT DIR("B")=$$FMTE^XLFDT(CURINCDT,"5DZ")
 D ^DIR
 I +$G(DIRUT)!(+Y<1) D BADSTUFF("Quit/No/Invalid Input.")  Q
 ;
 S INACTDT=Y
 ;
 I INACTDT=CURINCDT D BADSTUFF("Duplicate Date.  No Change to INACTIVATION DATE.")  Q
 ;
 K FDA,ERRS
 S FDA(60,F60IEN_",",57)=INACTDT
 D UPDATE^DIE("S","FDA",,"ERRS")
 I $D(ERRS) D  Q
 . W ?4,F60DESC," INACTIVATION DATE not changed.",!
 . W ?9,"ERROR:",$G(ERRS("DIERR",1,"TEXT",1)),!
 . D PRESSKEY^BLRGMENU(4)
 ;
 ; Now, update SITE NOTES
 K FDA,ERRS
 S FDA(60.0505,"+1,"_F60IEN_",",.01)=$$NOW^XLFDT
 D UPDATE^DIE("S","FDA","IEN","ERRS")
 I $D(ERRS)<1 D
 . ; Have to hard-set the SITE NOTES Text field.
 . ; FileMan WP^DIE does not see File 60.5051.
 . S SNTIEN=$G(IEN(1))
 . S ^LAB(60,F60IEN,11,SNTIEN,1,0)="^60.5051^1^1"
 . S ^LAB(60,F60IEN,11,SNTIEN,1,1,0)="INACTIVATION DATE "_$$FMTE^XLFDT(INACTDT,"5DZ")_" BY DUZ="_$G(DUZ)_"."
 ;
 W !!,?4,F60DESC," INACTIVATION DATE changed to ",$$GET1^DIQ(60,F60IEN,57),!
 ;
 ; If TYPE already = OUTPUT, just end here.
 I $$GET1^DIQ(60,F60IEN,3,"I")="O" D PRESSKEY^BLRGMENU(9)  Q
 ;
 ; Change TYPE.
 ;
 K FDA,ERRS
 S FDA(60,F60IEN_",",3)="O"
 D UPDATE^DIE("S","FDA",,"ERRS")
 I $D(ERRS) D  Q
 . W ?4,F60DESC," TYPE not changed.",!
 . W ?9,"ERROR:",$G(ERRS("DIERR",1,"TEXT",1)),!
 . D PRESSKEY^BLRGMENU(4)
 ;
 W !!,?4,"Test ",F60DESC," TYPE changed to ",$$GET1^DIQ(60,F60IEN,3),!
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
 ;
INACALLZ ; EP - Inactivate ALL ZZ Tests
 I $$KCHK^XUSRB("LRSUPER",DUZ)<1 D BADSTUFF("Must have LRSUPER Security Key.")  Q
 ;
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S HEADER(1)="LABORATORY TEST (#60) File"
 S HEADER(2)="INACTIVATE ALL ZZ Tests"
 ;
 ;     123456789012345678901234567890123456789012345678901234567890
 D HEADERDT^BLRGMENU
 W ?9,"This routine will hard-set the INACTIVATION DATE field in",!
 W ?9,"the LABORATORY TEST (#60) File for *ALL* Tests with names",!
 W ?9,"that begin with ""ZZ"" today's date ",$$HTE^XLFDT($H,"5DZ"),".",!
 ;
 Q:$$WARNINGS("Are you sure you want to do this",9)="Q"
 ;
 D HEADERDT^BLRGMENU
 Q:$$WARNINGS("Second Chance: Are you still sure you want to do this",9)="Q"
 ;
 D HEADERDT^BLRGMENU
 Q:$$WARNINGS("LAST CHANCE: Are you positive you want to do this",9)="Q"
 ;
 W !!,?4,"Very well.  Changes will be made."
 D PRESSKEY^BLRGMENU(9)
 Q:$G(QFLG)="Q"    ; Failsafe code in case user enters ^ at the prompt.
 ;
 D SETHEAD(.HDRONE)
 ;
 D SETBLRVS("INACALLZ")
 S INACTDT=$$DT^XLFDT
 S HEADER(3)=$$CJ^XLFSTR("Inactivation Date: "_$$FMTE^XLFDT(INACTDT,"5DZ"),IOM)
 ;
 S HEADER(4)=" "
 S $E(HEADER(5),5)="IEN"
 S $E(HEADER(5),15)="Name"
 ;
 S MAXLINES=IOSL,LINES=MAXLINES+10
 S (PG,CNT,CNTERRS,CNTF60,CNTIDC,CNTZZRTN)=0,QFLG="NO"
 ;
 S TESTNAME="ZZ"
 F  S TESTNAME=$O(^LAB(60,"B",TESTNAME))  Q:TESTNAME=""!($E(TESTNAME,1,2)'="ZZ")!(QFLG="Q")  D
 . S CNTZZRTN=CNTZZRTN+1
 . S F60IEN=0
 . F  S F60IEN=$O(^LAB(60,"B",TESTNAME,F60IEN))  Q:F60IEN<1!(QFLG="Q")  D
 .. S CNTF60=CNTF60+1
 .. K FDA,ERRS
 .. S FDA(60,F60IEN_",",57)=INACTDT
 .. D UPDATE^DIE("S","FDA",,"ERRS")
 .. I $D(ERRS) S CNTERRS=CNTERRS+1,CNTERRS(F60IEN)=$G(ERRS("DIERR",1,"TEXT",1))  Q
 .. S CNTIC=CNTIC+1     ; Inactivation Date Update Counter
 .. ;
 .. ; Now, update SITE NOTES
 .. K FDA,ERRS
 .. S FDA(60.0505,"+1,"_F60IEN_",",.01)=$$NOW^XLFDT
 .. D UPDATE^DIE("S","FDA","IEN","ERRS")
 .. I $D(ERRS)<1 D
 ... ; Have to hard-set the SITE NOTES Text field.
 ... ; FileMan WP^DIE does not see File 60.5051.
 ... S SNTIEN=$G(IEN(1))
 ... S ^LAB(60,F60IEN,11,SNTIEN,1,0)="^60.5051^1^1"
 ... S ^LAB(60,F60IEN,11,SNTIEN,1,1,0)="INACTIVATION DATE "_$$FMTE^XLFDT(INACTDT,"5DZ")_" BY DUZ="_$G(DUZ)_"."
 .. ;
 .. I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 .. ;
 .. W ?4,F60IEN
 .. W ?14,$$GET1^DIQ(60,F60IEN,"NAME")
 .. W !
 .. S LINES=LINES+1
 .. S CNT=CNT+1
 ;
 W !!,?4,CNTZZRTN," File 60 Entries with Names Beginning with  ""ZZ""."
 W !!,?9,CNTF60," File 60 Entries with Valid IENs."
 W !!,?9,CNT," File 60 Entries that now have an INACTIVATION DATE."
 D PRESSKEY^BLRGMENU(4)
 ;
 ; If Errors, display them.
 I CNTERRS D
 . W !,?4,"The following Routines had Errors when trying to Update"
 . W !,?4,"the INACTIVATION DATE field:",!!
 . ;
 . S F60IEN=0
 . F  S F60IEN=$O(CNTERRS(F60IEN))  Q:F60IEN<1  D
 .. W F60IEN
 .. W ?10,$E($$GET1^DIQ(60,F60IEN,"NAME"),1,18)
 .. D LINEWRAP^BLRGMENU(30,$G(CNTERRS(F60IEN)),50)
 .. W !
 . D PRESSKEY^BLRGMENU(9)
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
SETHEAD(HDRONE) ; EP - Set HDRONE variable
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HDRONE)
 D HEADERDT^BLRGMENU
 Q
 ;
BADSTUFF(MSG,TAB) ; EP - Simple Message
 S:+$G(TAB)<1 TAB=4
 W !!,?TAB,$$TRIM^XLFSTR(MSG,"LR"," "),"  Routine Ends."
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
 ;
WARNINGS(MSG,TAB) ; EP
 D HEADERDT^BLRGMENU
 W !,?9,$$SHOUTMSG^BLRGMENU("WARNING",60),!
 S TAB=$S(+$G(TAB):TAB,1:4)
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("A")=$J("",TAB)_MSG
 S DIR("B")="NO"
 D ^DIR
 Q:+$G(Y)<1!(+$D(DIRUT)) "Q"
 ;
 Q "OK"
