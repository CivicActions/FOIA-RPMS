DDUCHK ;SFISC/RWF-CHECK DD ;8/12/94  9:01 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ; DDUCFI=home file, DDUCFE=home field, DDUCFIX=flag to fix DD
 ; DDUCRFI=referenced file, DDUCRFE=referenced field.
A W !!,"Check the Data Dictionary." S DDUC="" D DT^DICRW,L^DICRW1 G EXIT:X'>0 S DDUCFIS=+X-.000001,DDUCFIE=DIB(1)
 S DIR(0)="Y",DIR("A")="Remove erroneous nodes",DIR("B")="NO",DIR("?",1)="This routine will try to fix certain nodes that are erroneous and may set some nodes to a file referenced by the selected file."
 S DIR("?")="Say 'NO' here to leave the DD untouched.  It will only flag the ones it finds erroneous."
 D ^DIR G EXIT:$D(DIRUT) S DDUCFIX=+Y K DIR
ZIS S %ZIS="Q" D ^%ZIS G EXIT:POP
 I $D(IO("Q")) S ZTRTN="DQ^DDUCHK",ZTSAVE("DDUCFIX")="",ZTSAVE("DDUCFIS")="",ZTSAVE("DDUCFIE")="" D ^%ZTLOAD G EXIT
DQ U IO K DDUCSTK S DDUCSTK=0,DDUCFX=DDUCFIX
 F DDUCFILE=DDUCFIS:0:DDUCFIE S DDUCFILE=$O(^DIC(DDUCFILE)) Q:DDUCFILE'>0!(DDUCFILE>DDUCFIE)  D PAGE Q:$D(DIRUT)  W !!,"Checking file # ",DDUCFILE S (DDUCFI,DIFILE)=+DDUCFILE D DDAC,CHK
EXIT D ^%ZISC
 K DDUCFI,DDUCFIX,DDUCFILE,DDUCFIS,DDUCFIE,DDUCFE,DDUCX,DDUCX1,DDUCX2,DDUCX4,DDUCRFI
 K DDUCRFE,DDUCSTK,DDUCSTK,DDUCDNAM,DDUCNAME,DDUCXX,DDUCY,DDUCUP,DDUCXN
 K DDUCF,DDUCXREF,DDUCZ,DDUC5,DDUCYY,DDUCYY1,DDUCOK,DDUCYYX,DIB,DDUC,DDUCFX,DIAC,DIFILE
 Q
PAGE I $Y+3>IOSL S DIR(0)="E" D:IOST["C-" ^DIR W @IOF
 Q
 ;
DDAC I DUZ(0)'="@" S DIAC="DD" D ^DIAC S DDUCFIX=DDUCFX I 'DIAC,DDUCFX W !,"You don't have DD access to this file.  No fixing will be done on this file." S DDUCFIX=0 Q
 Q
CHK I $G(^DIC(DDUCFI,0))]"",'$P(^(0),U,2) S:DDUCFIX $P(^(0),U,2)=DDUCFI
 I $D(^DD(DDUCFI,0))[0 S DDUCRFI=DDUCFI D WFI W "is missing zero node of DD."
 I $D(^DD(DDUCFI,0,"ID")) W !?5,"Checking 'ID' nodes for 'Q'." D ID^DDUCHK1
 I $D(^DD(DDUCFI,0,"IX")) W !?5,"Checking 'IX' nodes." D IX^DDUCHK1
 I $D(^DD(DDUCFI,0,"PT")) W !?5,"Checking 'PT' nodes." D PT^DDUCHK1
 S DDUCNAME=$O(^DD(DDUCFI,0,"NM","")),DDUCDNAM=$O(^(DDUCNAME)),DDUCRFI=DDUCFI I DDUCDNAM]"" D WFI W "has duplicate 'NM' nodes." I DDUCFIX D NM^DDUCHK1
 I $D(^DD("ACOMP",DDUCFI)) D AC^DDUCHK1
 G ^DDUCHK2
WFI W !?8,"File: ",DDUCRFI," " Q
 ;
EN ;
 Q:'$D(DDUCFI)!'$D(DDUCFIX)  S U="^"
 I DDUCFI Q:'$D(^DIC(DDUCFI,0,"GL"))  G EN1
 Q:'$D(@(DDUCFI_"0)"))  S DDUCFI=+$P(^(0),U,2)
EN1 S DDUCFIS=+DDUCFI-.000001,DDUCFIE=+DDUCFI
 G ZIS
