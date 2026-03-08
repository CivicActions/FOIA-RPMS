ACHSTX ; IHS/ITSC/PMF - EXPORT DATA (1/9) ;JUL 10, 2008
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5,7,13,14,16,21,28,32**;JUN 11,2001;Build 39
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - Allow AlphaNumeric ACN.
 ;IHS/SET/JVK ACHS*3.1*7 11/6/03 - Do not allow export unless ESig Que is empty
 ;IHS/OIT/FCJ ACHS*3.1*13 7/16/07 Added test for UFMS export and record counts for export
 ;IHS/OIT/FCJ ACHS*3.1*14 11/5/07 Added RE-Export process for UFMS
 ;IHS/OIT/FCJ ACHS*3.1*28 10/11/19 Added time to export date
 ;IHS/OIT/FCJ ACHS*3.1*32 11.8.24 - FI Tribal sites no longer send Stat record;TEST FOR ACTIVE JOBS
 ;
 ;
 ;I $$PARM^ACHS(0,8)="Y" Q:$$STATCHK    ;ACHS*3.1*32
 S ACHSF638=$$PARM^ACHS(0,8)   ;ACHS*3.1*28 ADDED ACHSF638 VAR
 I ACHSF638="Y",$$PARM^ACHS(2,11)'="Y" Q:$$STATCHK  S ACHSTXTY="T" ;ACHS*3.1*32 TEST FOR TRIBAL AND NOT FI
 ;
MENU ;CHECK MENU OPTION FOR ACTIVE JOBS ;ACHS*3.1*32 NEW SECTION
 S T=0
 F I="ACHSAI","ACHSAS","ACHSAB","ACHSAC","ACHSAL","ACHSEDITREFMEDI","ACHSPA","ACHSEDITMEDICAL","ACHSOD","ACHSPAYADJUST","ACHSFEOBR","ACHSTX" D  Q:T
 . S T=$$OPT^ACHSJCHK(I) Q:'T
 . W !!!!,*7,$$C^XBFUNC("Data entry in Progress,  please try again after staff have logged off."),!
 . I $$DIR^XBDIR("E","Press RETURN to continue...")
 G:T KILL^ACHSTX8
 ;
 K DIR  ;ACHS*3.1*16 IHS.OIT.FCJ ADDED LINE BECAUSE OF VAR BEING SET IN PAT REG AND NOT KILLED
 I '$$LOCK^ACHS("^ACHSF(DUZ(2),""D"")","+") W *7,!! W:$$DIR^XBDIR("E","CHS DATA ENTRY IN PROGRESS -- JOB CANCELLED - <RETURN> TO CONTINUE") "" G KILL^ACHSTX8
 ;ITSC/SET/JVK ACHS*3.1*7 11/6/03
 I 'ACHSREEX,$D(^ACHSF("EQ",DUZ(2))) W *7,!! W:$$DIR^XBDIR("E","CHS DOCUMENTS REQUIRE E-SIG -- JOB CANCELLED - <RETURN> TO CONTINUE") "" G KILL^ACHSTX8
 ;ACHS*3.1*14 IHS/OIT/FCJ TEST OF RE-EXPORT; NEW FILE TYPE-ACHS*3.1*21
 ;I $D(^ACHSDATA(0)),$P(^ACHSDATA(0),U,3)=DT,$P(^ACHSDATA(0),U)=$P(^AUTTLOC(DUZ(2),0),U,10) W !!?5,"A RE-EXPORT HAS ALREADY BEEN RAN TODAY, YOU WILL WRITE OVER",!?5,"THE FILE IF YOU CONTINUE."
 ;S DIR(0)="E" D ^DIR G KILL^ACHSTX8:$D(DUOUT)!$D(DTOUT)
 ;
 D ^ACHSVAR
 S ACHSRCT=0,ACHSUSDT=$P(^ACHSF(DUZ(2),0),U,13) S:'ACHSREEX ACHSREXT="N" ;ACHS*3.1*28 ACHSREXT VAR AND MV'D UFMS ST DT
 ;ACHS*3.1*13 IHS/OIT/FCJ chg 7 to 8 in nxt line to set rec count for UFMS
 F ACHS=2:1:8 S ACHSRTYP(ACHS)=0
L2 ;
 W !!?10,"Export data Facility: ",$$LOC^ACHS
 S %H=$H D YX^%DTC S ACHSMDAT=X,ACHSDTX=X_$E(%,1,5) ;ACHS*3.1*28
 I $D(^ACHSTXST("C",ACHSDTX,DUZ(2))) S ACHSDTX=ACHSDTX+.0001  ;ACHS*3.1*28 
 W !!?10,"Export Date: ",$E(Y,1,18)    ;ACHS*3.1*28
 G END:'$$DIR^XBDIR("Y","Is this Correct (Y/N) ","YES","","Export data will be made for "_$$LOC^ACHS,"",2)
 G END:$D(DUOUT)!$D(DTOUT)
 ;ACHS*3.1*21 COMMENTED OUT NXT 3 LINES ;ACHS*3.1*21 removed 3 LINES FOR RETURN TO CONTINUE
 ;ACHS*3.1*28 No tests needed for tape copy comment out nxt 5 lines
 ;K DIC,X,Y
 ;S DIC="^ACHSTXST("_DUZ(2)_",1,",DIC(0)="Z",X=DT
 ;D ^DIC
 ;K DIC,X
 ;I Y>0,$P(Y(0),U,10)="N" G ^ACHSTXTT
 ;I 'ACHSREEX,$D(^ACHSTXST("C",DT,DUZ(2))) G TXFEF^ACHSTX8  ;ACHS*3.1*28 Multiple exports can be done in one day
 S ACHSARCO=$P(^ACHSF(DUZ(2),0),U,11)
 ;I +ACHSARCO<1!($L(ACHSARCO)'=3) U IO(0) W *7,!!,"MISSING AREA CONTRACTING NUMBER - JOB CANCELLED" G ERROR;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 I '(ACHSARCO?3UN) U IO(0) W *7,!!,"Area Contracting Number is not 3 Upper-case Alpha-Numerics",!,"JOB CANCELLED" G ERROR ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 U IO(0)
 S ACHSCRTN=""
L3 ;
 ;S ACHSMDAT=$$DTAO   ;ACHS*3.1*28
 ;G END:$D(DUOUT)!$D(DTOUT)  ;ACHS*3.1*28
 ;
 K %ZIS,ACHSPPC,ACHSPPO
 ;
 S %ZIS("A")="ENTER OUTPUT REPORT DEVICE # ",%ZIS="P"
 W !
 D ^%ZIS
 G END:POP
 I $D(IO("S")) D SLV^ACHSFU
 S ACHSIO=IO,ACHSION=ION
 D ^%ZISC,HOME^%ZIS
 ;
 ;ACHS*3.1*14 IHS/OIT/FCJ ADDED RE-EXPORT PROCESS FOR UFMS MV G AFTER TEST FOR ACHSREEX
 ;S ACHSTXTY=$S(ACHSUSDT="":"S",ACHSUSDT>DT:"S",1:"U") G:ACHSTXTY="U" ^ACHSTXF
 ;S ACHSTXTY=$S(ACHSUSDT="":"S",ACHSUSDT>DT:"S",1:"U")  ;ACHS*3.1*14;ACHS*3.1*32
 I $G(ACHSTXTY)="" S ACHSTXTY=$S(ACHSUSDT="":"S",ACHSUSDT>DT:"S",1:"U")  ;ACHS*3.1*32
 I ACHSREEX D ^ACHSTXAR Q                              ;ACHS*3.1*14
 G:ACHSTXTY="U" ^ACHSTXF
 D ^ACHSTX2
 Q
 ;
 ;
KILLGLBS ;EP - Kill unsubscripted work globals.
 ;ACHS*3.1*28 ADDED ACHSUFMS AND ACHSBCBS TO SUB
 ; ^ACHSDATA( - DHR (REC #2) All record types are set in this global to be sent to Area
 ; ^ACHSTXPT( - Holds Patients to be exported. (Rec # 3)
 ; ^ACHSTXVN( - Holds Vendor IENs to be exported. (Rec # 4)
 ; ^ACHSTXOB( - Holds Document/Transaction to be exported. (Rec # 5)
 ; ^ACHSTXPD( - Holds Paid Doc info to be exported to Area Office. (Rec # 6)
 ; ^ACHSTXPG( - Holds Docs with statistical info to be exported to Data Center. (Rec # 7)
 ; ^ACHSUFMS( - Holds UFMS records for finance
 ; ^ACHSBCBS( - Holds FI records 3,4 and 5
 ;
 N ACHS
 F ACHS="^ACHSDATA","^ACHSTXPT","^ACHSTXVN","^ACHSTXOB","^ACHSTXPD","^ACHSTXPG","^ACHSUFMS","^ACHSBCBS" D
 . W !,"Resetting ",ACHS,"(0)"
 . ;2/25/02  pmf  changes for cache
 . ;I $$KILLOK^ZIBGCHAR($P(ACHS,U,2)) W !,$$ERR^ZIBGCHAR($$KILLOK^ZIBGCHAR($P(ACHS,U,2)))
 . ;K @ACHS
 . S @(ACHS_"(0)")=""
 . S ACHSG=ACHS_"(0)" F  S ACHSG=$Q(@ACHSG) Q:ACHSG=""  K @ACHSG
 . Q
 S ACHSUFMS("COUNT")=0,ACHSUFMS("TOT")=0  ;ACHS*3.1*28
 S ACHSBCBS("COUNT")=0,ACHSBCBS("TOT")=0  ;ACHS*3.1*28
 K ACHSG
 Q
 ;
DTAO() ;EP - Prompt for date sent to Area Office.
 Q $$DIR^XBDIR("D^"_DT_":"_$$HTFM^XLFDT($H+5),"ENTER DATE SENT TO AREA OFFICE ","T")
 ;
ERROR ;EP.
 X:$D(ACHSPCC) ACHSPPC
 U IO(0)
 W !!,*7,*7,*7,"AN ERROR HAS OCCURRED DURING EXPORT PLEASE NOTIFY AREA OFFICE "
 D ^%ZISC
 G JOBABEND^ACHSTX8
 ;
END ;
 W !!?10,"JOB TERMINATED BY OPERATOR"
 G JOBABEND^ACHSTX8
 ;
STATCHK() ; Check 638 stat data prior to export.
 D HELP^ACHSTX7X
 I $$DIR^XBDIR("Y","Run pre-export data check first","YES","","","^D HELP^ACHSTX7X",2) D ^ACHSTX7X Q 1
 Q 0
 ;
EXFILE() ; Does export file exist?
 NEW X,Y,Z
 S Y=$$ASF^ACHS(DUZ(2))
 I $$OS^ACHS=2 S Y=$E(Y,3,6)
 S Y="ACHS"_Y_"."_$$JDT^ACHS(DT)
 I $$LIST^%ZISH($$EX^ACHS,Y,.X)
 S Z=""
 F  S Z=$O(X(Z)) Q:'Z  I X(Z)=Y Q
 Q $S('Z:0,1:1)
 ;
FILEHELP ;EP -  ?? help text, from ACHS via DIR.
 ;;
 ;;     ***   AN EXPORT FILE FOR TODAY ALREADY EXISTS   ***
 ;;
 ;;An export file already exists in your export directory for today.
 ;;You will overwrite the file if you continue.  If the file was
 ;;correctly generated, the data in the file will be lost.  If you
 ;;are certain that the data in the file was incorrectly generated,
 ;;then proceed, forewarned.
 ;;
 ;;###
