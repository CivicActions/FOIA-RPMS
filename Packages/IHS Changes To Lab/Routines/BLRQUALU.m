BLRQUALU ; IHS/MSC/MKK - RPMS LAB QUALitative Utilities ; 13-Oct-2017 14:04 ;  MKK
 ;;5.2;LAB SERVICE;**1041,1047**;NOV 01, 1997;Build 21
 ;
 ;
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
QUALCHEK() ; EP -- CR06260 - Qualitative critical alert
 NEW ARRAY,OLDX,OLDY,QIEN,QVAL,SUBJECT,TAB
 NEW QUALFLAG,ABNFLAG     ; LR*5.2*1047
 ;
 ; LRDL = Result
 ; LRSB = DataName
 ; LRSPEC = Site/Specimen
 ; LRTS = File 60 IEN
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1047
 Q:$D(^LAB(60,LRTS,1,LRSPEC,999999))<1 0    ; Skip if no Qualitative value
 Q:$D(LRDL)<1 0                             ; Skip if no result
 Q:$D(LRSB)<1 0                             ; Skip if no DataName
 Q:$D(LRSPEC)<1 0                           ; Skip if no Site/Specimen
 Q:$D(LRTS)<1 0                             ; Skip if no File 60 IEN
 ; ----- END IHS/MSC/MKK - LR*5.2*1047
 ;
 M OLDX=X,OLDY=Y
 ;
 ; S QIEN=0
 ; F  S QIEN=$O(^LAB(60,LRTS,1,LRSPEC,999999,QIEN))  Q:QIEN<1!($G(LRFLG)="A*")  D
 ; . S:LRDL=$$GET1^DIQ(60.1999999,QIEN_","_LRSPEC_","_LRTS,.01) LRFLG="A*"
 ;
 ; I $$GET^XPAR("PKG","BLR QUALITATIVE ALERT",1,"Q")'=1!($G(LRFLG)'="A*") D  Q $S($G(LRFLG)="A*":1,1:0)
 ; . M:$D(OLDX) X=OLDX
 ; . M:$D(OLDY) Y=OLDY
 ;
 ; Q:$G(LRACC)="" $S($G(LRFLG)="A*":1,1:0)    ; During Point-Of-Care Tests, there is no accession initially.
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1047
 S QIEN=0,LRFLG=""
 F  S QIEN=$O(^LAB(60,LRTS,1,LRSPEC,999999,QIEN))  Q:QIEN<1!($L(LRFLG))  D
 . S QUALFLAG=$$GET1^DIQ(60.1999999,QIEN_","_LRSPEC_","_LRTS,.01)
 . S ABNFLAG=$P(QUALFLAG,"~",2)
 . S:LRDL=$P(QUALFLAG,"~") LRFLG=$S($L(ABNFLAG):ABNFLAG,1:"A*")
 ;
 I $$GET^XPAR("PKG","BLR QUALITATIVE ALERT",1,"Q")'=1!($E($G(LRFLG))'="A") D  Q $S($E($G(LRFLG))="A":1,1:0)
 . M:$D(OLDX) X=OLDX
 . M:$D(OLDY) Y=OLDY
 ;
 Q:$G(LRACC)="" $S($E($G(LRFLG))="A":1,1:0)    ; During Point-Of-Care Tests, there is no accession initially.
 ;
 ; ----- END IHS/MSC/MKK - LR*5.2*1047
 ;
 S TAB=$J("",5)
 S SUBJECT="Accession "_LRACC_" Qualitative Alert"
 S ARRAY(1)="Accession "_LRACC_" has a result that has triggered a Qualitative Alert."
 S ARRAY(2)=" "
 S ARRAY(3)=TAB_"Patient: "_$$GET1^DIQ(2,DFN,.01)
 S ARRAY(4)=" "
 S ARRAY(5)=TAB_"Test: "_$$GET1^DIQ(60,LRTS,.01)_" ["_LRTS_"]"
 S ARRAY(6)=" "
 S ARRAY(7)=TAB_TAB_"Result:"_LRDL
 ; S ARRAY(8)=" "
 ; S ARRAY(9)=TAB_"DATE/TIME:"_$$UP^XLFSTR($$HTE^XLFDT($H,"5MPZ"))
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1047
 S ARRAY(8)=TAB_TAB_"Qualitative Alert:"_LRFLG
 S ARRAY(9)=" "
 S ARRAY(10)=TAB_"DATE/TIME:"_$$UP^XLFSTR($$HTE^XLFDT($H,"5MPZ"))
 ; ----- END IHS/MSC/MKK - LR*5.2*1047
 ;
 D MAILALMI^BLRUTIL8(SUBJECT,.ARRAY,"LRVER4",,"LAB QUALITATIVE ALERT")
 ;
 M:$D(OLDX) X=OLDX
 M:$D(OLDY) Y=OLDY
 ;
 Q $S($G(LRFLG)="A*":1,1:0)
 ;
TESTQA ; EP - Test the Qualitative Alert
 NEW ARRAY,OLDX,OLDY,SUBJECT,TAB
 NEW DFN,LRACC,LRTS,LRDL
 ;
 S LRFLG="A*"
 ;
 Q:$$GET^XPAR("PKG","BLR QUALITATIVE ALERT",1,"Q")'=1
 ;
 S DFN=132602
 S LRACC="REF 16 24"
 S LRTS=123478
 S LRDL="POSITIVE"
 ;
 S OLDX=$G(X),OLDY=$G(Y)
 ;
 S TAB=$J("",5)
 S SUBJECT="Accession "_LRACC_" Qualitative Alert"
 S ARRAY(1)="Accession "_LRACC_" has a result that has triggered a Qualitative Alert."
 S ARRAY(2)=" "
 S ARRAY(3)=TAB_"Patient: "_$$GET1^DIQ(2,DFN,.01)
 S ARRAY(4)=" "
 S ARRAY(5)=TAB_"Test: "_$$GET1^DIQ(60,LRTS,.01)_" ["_LRTS_"]"
 S ARRAY(6)=" "
 S ARRAY(7)=TAB_TAB_"Result:"_LRDL
 S ARRAY(8)=" "
 S ARRAY(9)=TAB_"DATE/TIME:"_$$UP^XLFSTR($$HTE^XLFDT($H,"5MPZ"))
 ;
 D MAILALMI^BLRUTIL8(SUBJECT,.ARRAY,"LRVER4 - TESTQA",0,"LAB QUALITATIVE ALERT")
 ;
 S:$L(OLDX) X=OLDX
 S:$L(OLDY) Y=OLDY
 Q
