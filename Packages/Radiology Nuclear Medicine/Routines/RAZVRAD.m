RAZVRAD ; IHS/OHPRD/EDE - FIX V RADIOLOGY PROVIDER POINTERS  [ 10/29/1999  5:19 PM ]
 ;;4.0;RADIOLOGY;**2**;FEB 25, 1998
 ;
 ; his routine converts V RADIOLOGY field 1202 from file 200
 ; pointers to file 6 pointers.  The pointers are converted
 ; for VISITs added after the installation of Radiology v4.0
 ; or after a date specified by the user.
 ;
 ; This logic is based on the assumption that there is a DINUM
 ; relationship between file 200 and file 3 and both files
 ; have a file 16 pointer in the 16th piece of the 0th node.
 ; It is further assumed that the .01 field value of file 200
 ; and file 16 should be exactly the same.
 ;
 ; The file 6 pointer is taken from the 16th piece of the 0th
 ; node of file 200.  If there is no 16th piece an entry is
 ; made in ^RAZVRAD(9000010.22, so someone can attempt to
 ; resolve these later.
 ;
 ; File 3 and file 200 entries that do not have a pointer in
 ; the 16th piece or where the .01 field of file 16 and 200
 ; do not match are indentified and stored in ^RAZVRAD(file#,
 ; so these problems can be addressed.
 ;
START ;
 D MAIN
 D EOJ
 Q
 ;
MAIN ;
 D INIT
 Q:RAZQ
 D CONVERT
 Q
 ;
INIT ; INITIALIZATION
 D CHKPRIOR ;                    chk for prior run
 Q:RAZQ
 D INTRO ;                       display intro message
 Q:RAZQ
 D CHKFILES ;                    chk file 3 and 200 for pointers
 Q:RAZQ
 D GETDATE ;                     get beginning visit date
 Q:RAZQ
 Q
 ;
CHKPRIOR ; CHECK FOR PRIOR RUN
 S RAZQ=0
 I $D(^RAZVRAD(9000010.22,"RUN DATE")) S Y=^("RUN DATE") D
 .  X ^DD("DD")
 .  W !!,"This routine was run on "_Y,!
 .  I $G(^RAZVRAD(9000010.22,"CNVRT")) W "There were "_^("CNVRT")_" V Radiology entries convert so this routine cannot be run again!",!! S RAZQ=1 Q
 .  W "There were no V Radiology entries converted so this routine can be run again."
 .  Q
 Q
 ;
INTRO ; DISPLAY INTRO MESSAGE
 W !!,"This routine will convert V Radiology provider pointers from",!
 W "file 200 pointers to file 6 pointers.  The conversion will be",!
 W "done beginning on the date Radiology v4.0 was installed or by",!
 W "a date you specify when asked.  The default date you will see is",!
 W "the v4.0 installation date.  Consider that if you installed v4.0",!
 W "at 10:00pm you would not want to convert visits added that day.",!
 W !,"Errors will be stored in ^RAZVRAD(file#, so you can look at",!
 W "them using ^%GL.",!
 W !,"Before you do the conversion save ^AUPNVRAD to a host file so",!
 W "it can be restored if needed.  It would be wise to look at a",!
 W "few V Radiology entries before and after the conversion to make",!
 W "sure they were converted correctly.",!
 W !,"You can run this routine in test mode so that everything will",!
 W "happen except the actual modification of the V Radiology pointer.",!
 S RAZQ=1
 S DIR(0)="E",DIR("A")="Press any key to continue" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 S DIR(0)="S^1:TEST;2:CANCEL;3:CONVERT",DIR("A")="Select",DIR("B")="1" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 S RAZSTAT=Y
 S:RAZSTAT'=2 RAZQ=0
 Q
 ;
GETDATE ; GET BEGINNING VISIT DATE
 S RAZQ=0
 D GETV4DT
 I RAZV4DT="" D  Q:RAZQ
 .  S RAZQ=1
 .  W !!,"I cannot find an entry for Radiology v4.0 in the Package file."
 .  S DIR(0)="Y",DIR("A")="Do you want to convert V Radiology entries anyway",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 .  Q:$D(DIRUT)
 .  S:Y RAZQ=0
 .  Q
 D GETBGDT
 Q:RAZQ
 Q
 ;
GETV4DT ; GET V4.0 DATE
 S RAZV4DT=""
 S Y=$O(^DIC(9.4,"C","RA",0))
 Q:'Y
 S Z=$O(^DIC(9.4,Y,22,"B","4.0T8",0))
 I 'Z S Z=$O(^DIC(9.4,Y,22,"B","4.0",0))
 Q:'Z
 S X=$P($G(^DIC(9.4,Y,22,Z,0)),U,3)
 Q:X=""
 S RAZV4DT=X
 Q
 ;
GETBGDT ; GET BEGINNING DATE FOR CONVERSION
 S RAZQ=1
 S RAZBGDT=""
 W !
 S Y=RAZV4DT X ^DD("DD")
 S DIR(0)="D^::EP",DIR("A")="Enter beginning visit date",DIR("B")=Y KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 S RAZBGDT=Y
 S RAZQ=0
 Q
 ;
CHKFILES ; CHECK FILE 3 AND 200 FOR APPROPRIATE POINTERS
 S RAZQ=0
 D CHKF200 ;                     chk file 200
 D CHKF3 ;                       chk file 3
 I $D(^RAZVRAD) D ASKUSR ;       see if user wants to run with errors
 Q
 ;
CHKF200 ; CHECK FILE 200 FOR FILE 16 POINTER
 W !!,"I am now going to check a few things in your New Person file"
 I $D(^RAZVRAD(200)) D  I RAZQ S RAZQ=0 Q
 .  S RAZQ=1
 .  W !!,"Errors exist from a previous run"
 .  S DIR(0)="Y",DIR("A")="Do you want me to check this file again",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 .  Q:$D(DIRUT)
 .  S:Y RAZQ=0
 .  Q
 NEW C,X,Y,Z
 S RAZFILE=200
 K ^RAZVRAD(RAZFILE)
 S Y=0 F C=1:1 S Y=$O(^VA(200,Y)) Q:'Y  I $D(^(Y,0)) D
 .  W:'(C#10) "."
 .  I '$D(^DIC(3,Y)) S RAZEMSG="No User file entry" D EMSG
 .  S Z=$P($G(^VA(200,Y,0)),U,16)
 .  I 'Z S RAZEMSG="No file 16 pointer" D EMSG Q
 .  I '$D(^DIC(16,Z)) S RAZEMSG="No file 16 entry "_Z D EMSG Q
 .  S X=$P($G(^DIC(16,Z,0)),U)
 .  I $P(^VA(200,Y,0),U)'=X S RAZEMSG="File 200 and file 16 Name fields are different" D EMSG Q
 .  Q
 Q
 ;
CHKF3 ; CHECK FILE 3 FOR FILE 16 POINTER
 W !!,"I am now going to check a few things in your User file"
 I $D(^RAZVRAD(3)) D  I RAZQ S RAZQ=0 Q
 .  S RAZQ=1
 .  W !!,"Errors exist from a previous run"
 .  S DIR(0)="Y",DIR("A")="Do you want me to check this file again",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 .  Q:$D(DIRUT)
 .  S:Y RAZQ=0
 .  Q
 NEW C,X,Y,Z
 S RAZFILE=3
 K ^RAZVRAD(RAZFILE)
 S Y=0 F C=1:1 S Y=$O(^DIC(3,Y)) Q:'Y  I $D(^(Y,0)) D
 .  W:'(C#10) "."
 .  I '$D(^VA(200,Y)) S RAZEMSG="File 200 entry missing" D EMSG
 .  S Z=$P($G(^DIC(3,Y,0)),U,16)
 .  I 'Z S RAZEMSG="No file 16 pointer" D EMSG Q
 .  I '$D(^DIC(16,Z)) S RAZEMSG="No file 16 entry "_Z D EMSG Q
 .  S X=$P($G(^DIC(16,Z,0)),U)
 .  Q:'$D(^VA(200,Y,0))
 .  I $P(^VA(200,Y,0),U)'=X S RAZEMSG="File 200 and file 16 Name fields are different" D EMSG Q
 .  Q
 Q
 ;
EMSG ; SAVE ERROR MESSAGE
 S (RAZEC,^("EC"))=$G(^RAZVRAD(RAZFILE,"EC"))+1
 S ^RAZVRAD(RAZFILE,RAZEC)="File "_RAZFILE_" IEN "_Y_"="_RAZEMSG
 Q
 ;
ASKUSR ; SEE IF USER WANTS TO RUN WITH FILE 3, 200 ERRORS
 S RAZQ=1
 W !
 I $G(^RAZVRAD(3,"EC")) W !,"There are "_^("EC")_" file 3 errors"
 I $G(^RAZVRAD(200,"EC")) W !,"There are "_^("EC")_" file 200 errors"
 S DIR(0)="Y",DIR("A")="Do you want to run anyway",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 S:Y RAZQ=0
 Q
 ;
CONVERT ; CONVERT V RADIOLOGY POINTERS
 S RAZFILE=9000010.22
 K ^RAZVRAD(RAZFILE) ;          eliminate residue from old run
 I RAZSTAT=1 W !!,"Running in test mode"
 E  S ^RAZVRAD(RAZFILE,"RUN DATE")=DT
 W !!,"Now converting V Radiology pointers"
 S RAZVRAD=0,C=0
 F  S RAZVRAD=$O(^AUPNVRAD(RAZVRAD)) Q:'RAZVRAD  I $D(^(RAZVRAD,0)) S X=^(0) D
 .  S C=C+1
 .  W:'(C#50) "."
 .  S Y=$P(X,U,3) ;                get visit pointer
 .  Q:'Y  ;                        not a good sign
 .  S X=$P($G(^AUPNVSIT(Y,0)),U,2) ;get posting date
 .  Q:X=""  ;                      bad visit entry
 .  Q:X<RAZBGDT  ;             quit if visit posted before v4 installed
 .  S W=$P($G(^AUPNVRAD(RAZVRAD,12)),U,2) ;get file 200 pointer
 .  Q:'W  ;                        quit if no file 200 pointer
 .  S Z=$P($G(^VA(200,W,0)),U,16) ;get file 16/6 pointer
 .  I 'Z S Z=$P($G(^DIC(3,W,0)),U,16) ;try file 3
 .  I 'Z S Y=RAZVRAD,RAZEMSG="No file 16 pointer for file 200 IEN "_W D EMSG
 .  S ^RAZVRAD(9000010.22,"LAST IEN")=RAZVRAD
 .  S:'$D(^RAZVRAD(9000010.22,"FIRST IEN")) ^RAZVRAD(9000010.22,"FIRST IEN")=RAZVRAD
 . ;set field #1202 to file 6 pointer or null, count conversions
 .  I RAZSTAT=3 S $P(^AUPNVRAD(RAZVRAD,12),U,2)=Z,^("CNVRT")=$G(^RAZVRAD(RAZFILE,"CNVRT"))+1
 .  I RAZSTAT=1 S ^("TEST")=$G(^RAZVRAD(RAZFILE,"TEST"))+1
 .  Q
 I RAZSTAT=1 D
 .  I $D(^RAZVRAD(RAZFILE,"TEST")) W !!,"There would have been "_^("TEST")_" pointers converted."
 .  E  W !!,"There would have been no pointers converted."
 .  Q
 I RAZSTAT=3 D
 .  I $D(^RAZVRAD(RAZFILE,"CNVRT")) W !!,"There were "_^("CNVRT")_" pointers converted."
 .  E  W !!,"There were no pointers converted."
 .  Q
 I $D(^RAZVRAD(RAZFILE,"FIRST IEN")),$D(^RAZVRAD(RAZFILE,"LAST IEN")) W !!,"Range of ^AUPNVRAD IENs modified is "_^RAZVRAD(RAZFILE,"FIRST IEN")_"-"_^RAZVRAD(RAZFILE,"LAST IEN")
 I $D(^RAZVRAD(RAZFILE,"EC")) W !!,"There were "_^("EC")_" errors encountered and stored in ^RAZVRAD(9000010.22,.",!,"You may view them using ^%GL.",!
 E  W !!,"There were no errors encountered.",!
 Q
 ;
EOJ ;
 K %,%H
 K C,W,X,Y,Z
 K DIRUT
 D EN^XBVK("RAZ")
 Q
