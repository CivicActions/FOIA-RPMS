BARVKL0 ; IHS/SD/LSL - KILL NAME SPACE VARIABLES (BAR) ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**37**;OCT 26, 2005;Build 210
 ;IHS/SD/SDR 1.8*37 ADO60825 Added logic to kill BARTMP that is keeping track of all sessions so they can't be closed
 ;  by the supervisor unless the user is logged out
 ;
 ;XQJMP=1 IF THE USER IS MENU JUMPING
 ;XQCH="HALT" if they typed halt
 I $G(XQJMP) D
 .Q:'$G(XQJP)
 .S JUMPTO=$P(XQJP,",",$L(XQJP,",")-1)
 .S JUMPTO=$P($G(^DIC(19,JUMPTO,0)),U)
 ;start new bar*1.8*37 IHS/SD/SDR ADO60825
 I (+$G(UFMSESID)'=0) D
 .;the next two lines quit because the three options noted run this routine as well, so it doubles the exits
 .Q:($P($G(XQSV),U,3)="BARMENU")
 .I (($P($G(XQSV),U,3)'="BAR POST PAYMENTS")&($P($G(XQSV),U,3)'="BAR POST ADJUSTMENTS")) Q
 .S ^BARTMP("UFMSPST",DUZ(2),DUZ,UFMSESID)=+$G(^BARTMP("UFMSPST",DUZ(2),DUZ,UFMSESID))-1
 I $G(UFMSESID),(+$G(^BARTMP("UFMSPST",DUZ(2),DUZ,UFMSESID))<1) K ^BARTMP("UFMSPST",DUZ(2),DUZ)
 ;end new bar*1.8*37 IHS/SD/SDR ADO60825
 I $G(UFMSESID),($G(XQCH)="HALT") D SIGNOUT^BARUFLOG Q
 I $G(UFMSESID),$G(XQJMP),($E($G(JUMPTO),1,3)'="BAR") D SIGNOUT^BARUFLOG Q
 I $G(UFMSESID),($P($G(XQSV),U,3)="BARMENU") D SIGNOUT^BARUFLOG Q
 I $G(UFMSESID),($G(XQUR)="Y") D SIGNOUT^BARUFLOG Q
 K DIR,DIC,DIQ
 D EN^XBVK("BAR")
 Q
