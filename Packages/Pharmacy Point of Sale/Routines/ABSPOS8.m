ABSPOS8 ;IHS/GDIT/AEF - more overflow from ^ABSPOS1 [ 09/05/2000  8:42 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**54**;JUN 01, 2001;Build 131
 Q
NAME(X) N % S %="DUR info" ; ="receipt"
 I '$G(X) Q %
 I X=3 ; S %=%_"s" ; plural
 I X=1 ; capitalize first letter
 I X=2 ; capitalize all
 Q %
RECEIPTS(RXIIEN,IO)   ;
 ; Given RXIIEN(*) array of RXIs for which to print receipts
 ; and IO = IO device, caller does open & close
 ; $P is current device when this finishes, but IO still open
 N PAT
 U 0 W "Printing ",$$NAME(3),"...",!   ;ABSP*1.0*54
 ; Group by patient ; RXI(pat,rxi)=""
 N RXI S RXI="" F  S RXI=$O(RXIIEN(RXI)) Q:RXI=""  D
 . S PAT=$P(^ABSPEC(9002335.59,RXI,0),U,6)
 . S RXI(PAT,RXI)=""
 ; Now print them
 S PAT="" F  S PAT=$O(RXI(PAT)) Q:PAT=""  D
 . ;U $P W "... for ",$P(^DPT(PAT,0),U),"...",!
 . U 0 W "... for ",$P(^DPT(PAT,0),U)_$$PPN1^ABSPUTL(PAT),"...",!   ;IHS/GDIT/AEF 3240110 - ABSP*1.0*54 FID 77888
 . S RXI="" F  S RXI=$O(RXI(PAT,RXI)) Q:RXI=""  D
 . . N REVERSAL S REVERSAL=$$REVERSAL(RXI)
 . . I REVERSAL U IO D RECEIPT(REVERSAL,1) U $P
 . . N CLAIM S CLAIM=$$CLAIM(RXI)
 . . I 'CLAIM W ?5,"Nothing to print for prescription `",RXI,! H 1 Q
 . . N POSITION S POSITION=$P(^ABSPEC(9002335.59,RXI,0),"^",9)
 . . I 'POSITION W ?5,"This might not be the right ",$$NAME,".",! H 1
 . . U IO D RECEIPT(CLAIM,POSITION) U $P
 U IO I $Y'=0 W #
 U 0 W "Done",! H 1   ;ABSP*1.0*54
 Q
CLAIM(RXI)         ; $$ return claim #
 N CLAIM
 ;S CLAIM=$G(^ABSPEC(9002335.59,RXI,4))
 I 0 ;I CLAIM S CLAIM=$P(CLAIM,U) ; do the reversal if applicable
 E  S CLAIM=$P(^ABSPEC(9002335.59,RXI,0),U,4) ; else plain old claim
 Q CLAIM
REVERSAL(RXI)      Q $P($G(^ABSPEC(9002335.59,RXI,4)),U)
RECEIPT(CLAIM,POSITION)    ; print a receipt for the given claim packet & pos
 N TMP D FILEMAN^ABSPECP1("TMP",CLAIM,,POSITION)
 N TAG S TAG=$P($G(^ABSPEC(9002335.99,1,"RECEIPT")),U) ; "ANMC" at ANMC
 I TAG="" S TAG="RECEIPT"
 D @(TAG_U_"ABSPECP3")
 Q
