ABSPOS6E ; IHS/FCS/DRS - more overflow from ^ABSPOS1 ;
 ;;1.0;PHARMACY POINT OF SALE;**11,54,55**;JUN 01, 2001;Build 131
 ;-------------------------------------------------
 ;IHS/SD/lwj 06/10/04 patch 11 terminal emulation problems
 ; OnNetHost interrupts "#" to mean for the cursor to advance
 ; to the top of the next page.  "Other" emulations (including
 ; CRT and Tera Term) interrupt "#" to mean go to the top of
 ; the current screen and clear everything on this screen off.
 ; This was keeping the users at GIMC from being able to see 
 ; the entire receipt.  Logic adjusted to work at GIMC.
 ;IHS/SD/SDR 1.0*55 ADO115915 Changed U 0 back to U $P to fix displays (they were being cut off/incomplete)
 ;-------------------------------------------------
 Q
NAME(X) ;EP - from ABSPOS6D
 N % S %="DUR info" ; ="receipt"
 I '$G(X) Q %
 I X=3 ; S %=%_"s" ; plural
 I X=1 ; capitalize first letter
 I X=2 ; capitalize all
 Q %
RECEIPTS(RXIIEN,IO)   ;EP - from ABSPOS6D
 ; Given RXIIEN(*) array of RXIs for which to print receipts
 ; and IO = IO device, caller does open & close
 ; $P is current device when this finishes, but IO still open
 N PAT
 ;U 0 W "Printing ",$$NAME(3),"...",!   ;ABSP*1.0*54  ;absp*1.8*55 IHS/SD/SDR ADO115915
 U $P W "Printing ",$$NAME(3),"...",!   ;ABSP*1.0*54  ;absp*1.8*55 IHS/SD/SDR ADO115915
 ; Group by patient ; RXI(pat,rxi)=""
 N RXI S RXI="" F  S RXI=$O(RXIIEN(RXI)) Q:RXI=""  D
 . S PAT=$P(^ABSPT(RXI,0),U,6)
 . S RXI(PAT,RXI)=""
 ; Now print them
 S PAT="" F  S PAT=$O(RXI(PAT)) Q:PAT=""  D
 .;U $P W "... for ",$P(^DPT(PAT,0),U),"...",!
 .;U 0 W "... for ",$P(^DPT(PAT,0),U),$$PPN1^ABSPUTL(PAT),"...",!  ;IHS/GDIT/AEF 3240110 - ABSP*1.0*54 FID 77888  ;absp*1.8*55 IHS/SD/SDR ADO115915
 .U $P W "... for ",$P(^DPT(PAT,0),U),$$PPN1^ABSPUTL(PAT),"...",!  ;absp*1.8*55 IHS/SD/SDR ADO115915
 .S RXI="" F  S RXI=$O(RXI(PAT,RXI)) Q:RXI=""  D
 ..N REVERSAL S REVERSAL=$$REVERSAL(RXI)
 ..I REVERSAL U IO D RECEIPT(REVERSAL,1) U $P
 ..N CLAIM S CLAIM=$$CLAIM(RXI)
 ..I 'CLAIM W ?5,"Nothing to print for prescription `",RXI,! H 1 Q
 ..N POSITION S POSITION=$P(^ABSPT(RXI,0),"^",9)
 ..I 'POSITION W ?5,"This might not be the right ",$$NAME,".",! H 1
 ..U IO D RECEIPT(CLAIM,POSITION) U $P
 ;
 ;IHS/SD/lwj 6/10/04 patch 11 - nxt line rmkd out, following added
 ;U IO I $Y'=0 W #
 ;I IO'=$P U IO I $Y'=0 W #   ;IHS/SD/lwj 6/10/04 patch 11;ABSP*1.0*54
 ;I IO'=0 U IO I $Y'=0 W #   ;IHS/SD/lwj 6/10/04 patch 11;ABSP*1.0*54  ;absp*1.8*55 IHS/SD/SDR ADO115915
 I IO'=$P U IO I $Y'=0 W #   ;absp*1.0*55 IHS/SD/SDR ADO115915
 ;
 ;U $P W "Done",! H 1   ;ABSP*1.0*53
 ;U 0 W "Done",! H 1   ;ABSP*1.0*53
 U $P W "Done",! H 1   ;IHS/SD/SDR absp*1.0*55 FID115915
 Q
CLAIM(RXI)         ; $$ return claim #
 N CLAIM
 ;S CLAIM=$G(^ABSPT(RXI,4))
 I 0 ;I CLAIM S CLAIM=$P(CLAIM,U) ; do the reversal if applicable
 E  S CLAIM=$P(^ABSPT(RXI,0),U,4) ; else plain old claim
 Q CLAIM
REVERSAL(RXI)      Q $P($G(^ABSPT(RXI,4)),U)
RECEIPT(CLAIM,POSITION)    ; print a receipt for the given claim packet & pos
 N TMP D FILEMAN^ABSPECP1("TMP",CLAIM,,POSITION) ; sets TMP(*)
 N TAG S TAG=$P($G(^ABSP(9002313.99,1,"RECEIPT")),U) ; "ANMC" at ANMC
 I TAG="" S TAG="RECEIPT"
 D @(TAG_U_"ABSPECP3")
 Q
