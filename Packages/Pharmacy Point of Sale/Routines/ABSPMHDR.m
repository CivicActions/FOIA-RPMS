ABSPMHDR ; IHS/FCS/DRS - MENUS HEADERS ; 
 ;;1.0;PHARMACY POINT OF SALE;**18,22,23,52**;JUN 01, 2001;Build 131
 ;
 ;****** Send this routine with each new patch with **n** in piece
 ;****** 3 so the patch level can be displayed as part of the
 ;****** menu header.
 ;IHS/SD/RLT - 8/24/06 - Patch 18
 ;             New code to display patch number in header.
 ;IHS/SD/RLT - 09/20/07 - Patch 22
 ;             Added splash screent for held 3PB claims.
 ;IHS/OIT/SCR - 9/16/08 - Patch 28
 ;            Removed Patch 22 splash screen for held 3PB claims
 ;IHS/OIT/RAM - 28 FEB 2020 - Patch 52
 ;              new code to add Taskman & POS processing status
INIT ;EP -
 I $G(XQY0)'="",$G(ABSPTOP)="" S ABSPTOP=XQY0
 S ABSPY="",ABSPY=$O(^DIC(9.4,"C","ABSP",ABSPY))
 S ABSPVER=^DIC(9.4,ABSPY,"VERSION"),ABSPVER="V"_ABSPVER K ABSPY
 ;RLT - Patch 18
 ;S X=$T(+2),X=$P(X,";;",2),X=$P(X,";",3),X=$P(X,"**",2),X=$P(X,",",$L(X,","))
 S X=$P($$LAST^XPDUTL("PHARMACY POINT OF SALE"),U)
 ;RLT - Patch 18
 S:X]"" ABSPVER=ABSPVER_" P"_X
 S ABSPPNM="PHARMACY POINT OF SALE"
 I '$D(DUZ(2)) W !!,"Your SITE NAME is not set for the KERNEL.",!,"Please contact your System Support person.",!! S ABSPQUIT=1 Q
 I '$D(DUZ(0)) W !!,"You do not have the DUZ(0) variable.",!,"Please contact your System Support person.",!! S ABSPQUIT=1 Q
 I DUZ(0)'["M",DUZ(0)'["P",DUZ(0)'["p",DUZ(0)'["@" W !!,"You do not have the appropriate FileMan access.",!,"Please contact your System Support person.",!! S ABSPQUIT=1 Q
 ;IHS/OIT/SCR - 09/16/08 - Patch 28 - START changes to Remove Patch 22 splash screen for held 3PB claims
 ;IHS/SD/RLT - 09/20/07 - Patch 22
 ; I $P(XQY0,U)="ABSPMENU" D
 ;.N HOLDCHK
 ;.S HOLDCHK=$O(^ABSPHOLD(0))
 ;.I HOLDCHK D HOLDSCR^ABSPOSBH
 ;IHS/OIT/SCR - 09/16/08 - Patch 28 - END changes Remove Patch 22 splash screen for held 3PB claims
 S ABSPSITE=$P(^DIC(4,DUZ(2),0),"^")
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 I $G(IO) S Y=$O(^%ZIS(1,"C",IO,0)) I Y S Y=$P($G(^%ZIS(1,Y,"SUBTYPE")),U) I Y S X=$G(^%ZIS(2,Y,5)),ABSPRVON=$P(X,U,4),ABSPRVOF=$P(X,U,5)
 I $G(ABSPRVON)="" S ABSPRVON="""""",ABSPRVOF=""""""
 Q
 ;
HDR ;EP - Screen header.
 Q:$G(XQY0)=""
 I $G(ABSPTOP)="" D INIT Q:$G(ABSPQUIT)
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P(XQY0,U,2),ABSPMT=$S($P(XQY0,U)="ABSPMENU":"Main Menu",1:X)
 S ABSPPNV=ABSPPNM_" "_ABSPVER
 NEW A,D,F,I,L,N,R,V,PRESTAT,STAT,ABSPLEN,WIDTH
 S (F,ABSPLEN)=0,PRESTAT=""
 S WIDTH=$S($G(IOM)>0:IOM,1:80) ; FIND WIDTH OF TERMINAL SESSION, DEFAULT TO 80 CHARACTERS IF UNDEFINED.
 S STAT=$$WARNHDR
 S:STAT'="" PRESTAT="Attention! Please contact System Support due to:"
 S:$L(ABSPPNV)>ABSPLEN ABSPLEN=$L(ABSPPNV) ; Find longest string to calculate 'star' window
 S:$L(ABSPMT)>ABSPLEN ABSPLEN=$L(ABSPMT)
 S:$L(PRESTAT)>ABSPLEN ABSPLEN=$L(PRESTAT)
 S:$L(STAT)>ABSPLEN ABSPLEN=$L(STAT) ; should have longest string now.
 W !
 S A=$X W IORVON,IORVOFF S D=$X S:D>A F=D-A ;compute length of revvideo
 S ABSPLEN=ABSPLEN+3 ; BUFFER ONE SPACE EACH END;
 ; S L=18,R=61,D=R-L+1,N=R-L-1 ; OLD HARDCODED 80-CHAR-WIDTH MAKES FOR ODD MENU ON WIDER TERMINALS...
 S L=(WIDTH-ABSPLEN)\2,R=L+ABSPLEN,D=R-L+1,N=R-L-1
 ; S:(L#2) L=L-1,D=D+1
 ; W @IOF,!,$$CTR($$REPEAT^XLFSTR("*",D)),!  ;;; old version
 W @IOF,!,?L,"*",$$REPEAT^XLFSTR("*",N),?R,"*",!
 W ?L,"*",$$CTR(ABSPPNV,N),?R,"*",!
 W ?L,"*",$$CTR($$LOC(),N),?R,"*",!
 ; W ?L,"*",?(L+(((R-L)-$L(ABSPMT))\2)+.5),IORVON,ABSPMT,IORVOFF,?R+F,"*",! ;; TESTING CODE FOR CENTERING.
 W ?L,"*",$$RVCTR(ABSPMT,N),?R+F,"*",! ;; TESTING CODE FOR CENTERING.
 ; W ?L,"*",$$CTR(ABSPLEN_","_L_","_N_","_D_","_R,N),?R,"*",!
 W ?L,"*",$$REPEAT^XLFSTR("*",N),?R,"*",! ; CLOSE BOX BEFORE WARNING BOX BELOW; PER GAIL TOWNSEND.
 ;
 I STAT'="" D
 . W ?L,"!",$$CTR(PRESTAT,N),?R,"!",!
 . ; W ?L,"*",?(L+(((R-L)-$L(STAT))/2)+.5),IORVON,STAT,IORVOFF,?R+F,"*",!
 . W ?L,"!",$$RVCTR(STAT,N),?R,"!",!
 . ; W $$CTR($$REPEAT^XLFSTR("*",D)),!
 . W ?L,"!",$$REPEAT^XLFSTR("!",N),?R,"!",!
 K ABSPMT,ABSPPNV
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
RVCTR(X,Y) ;EP - Center X in a field Y wide, Reverse Video.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_IORVON_X_IORVOFF
 ;----------
LJRF(X,Y,Z) ;EP - left justify X in a field Y wide, right filling with Z.
 NEW L,M
 I $L(X)'<Y Q $E(X,1,Y-1)_Z
 S L=Y-$L(X)
 S $P(M,Z,L)=Z
 Q X_M
 ; ----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ; ----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;
GETQUEUE(ARRAY) ; Get info from ABSP TRANSACTION file, status of incomplete claims.
 ; /IHS/OIT/RAM ; P52 ; ENTIRE ROUTINE IS NEW.
 N I,I2,I3,J,J2,J3,K,K2,K3,X,Y,%H,%T,%Y
 N NUMCLAIMS,TIER,OLDEST
 S NUMCLAIMS=0,OLDEST=99999999999
 ; LET'S GRAB ALL OF THE TRANSACTIONS WHERE THE STATUS IS LESS THAN COMPLETE (I.E. <99)
 S I=-1 F  S I=$O(^ABSPT("AD",I)) Q:(+I<0)!(+I>98)  D
 . S J=0 F  S J=$O(^ABSPT("AD",I,J)) Q:+J=0  D
 . . S @ARRAY@("TOTAL")=+$G(@ARRAY@("TOTAL"))+1 ; INCREMENT TOTAL COUNT OF INCOMPLETE TRANSACTIONS
 . . S TIER=I\10                  ; ROUND DOWN STATUS TO NEAREST "TENS" TIER.
 . . S @ARRAY@(TIER)=+$G(@ARRAY@(TIER))+1  ; AND INCREMENT COUNT OF JUST THAT TIER.
 . . S K2=+$$GET1^DIQ(9002313.59,J_",",7,"I") ; GET LAST UPDATE FOR THIS RECORD.
 . . ; W "K2: ",K2,!
 . . S:(K2>0)&(K2<OLDEST) OLDEST=K2 ; AND UPDATE THE 'OLDEST' POINTER IF THIS RECORD IS OLDER THAN ALL OTHERS.
 . . S K=$$GET1^DIQ(9002313.59,J_",",1.06,"I") ; GET INSURER POINTER FOR THIS RECORD.
 . . Q:+K=0 ; AND SKIP THIS ONE IF THERE'S NO INSURER.
 . . S @ARRAY@("INSURER",K)=$G(@ARRAY@("INSURER",K))+1 ; INCREMENT COUNT OF 'PER INSURER'
 ;
 I OLDEST=99999999999 S OLDEST=0
 ; GET A COUNT OF ALL INSURERS, NOW THAT ALL THE DATA IS COLLECTED.
 S J=0 F  S J=$O(@ARRAY@("INSURER",J)) Q:+J=0  S @ARRAY@("INSURER")=$G(@ARRAY@("INSURER"))+1
 S X=OLDEST D H^%DTC S @ARRAY@("H")=%H_","_%T
 S @ARRAY@("SECS")=$P(%H,",")*86400+%T
 S @ARRAY@("OLDEST")=OLDEST
 ; W !,"SECS: ",@ARRAY@("SECS"),*9,"OLDEST: ",OLDEST,!
 ;
 Q
 ;
TASKMAN() ;Entry Point: extrinsic variable returns string with Taskman Status.
 N I,I2,I3,ZTH S ZTH=$H,(I2,I3)=0
 N X,Y,%H,MSG,STAT,WAIT,RUN,STOP,UPDATE,SHORT,LONG S (STAT,WAIT,RUN,STOP,UPDATE,SHORT,LONG,%H)=""
 S I=$O(^%ZTSCH("STATUS",0),1) S:I'="" STAT=^%ZTSCH("STATUS",I),SHORT=$P(STAT,"^",2),LONG=$P(STAT,"^",4)
 S I=$O(^%ZTSCH("WAIT",0),1) S:I'="" WAIT=^%ZTSCH("WAIT",I)
 S I=$O(^%ZTSCH("STOP","MGR",0),1) S:I'="" STOP=^%ZTSCH("STOP","MGR",I)
 S I=$O(^%ZTSCH("UPDATE",0),1) S:I'="" UPDATE=^%ZTSCH("UPDATE",I)
 S:$D(^%ZTSCH("RUN")) RUN=^%ZTSCH("RUN")
 ; W $G(RUN),!
 S:RUN=""&(UPDATE'="") RUN=UPDATE
 S MSG="TaskMan Is "
 S:SHORT="WAIT" MSG=MSG_"Waiting ",I3=1,%H=WAIT
 S:SHORT="PAUSE" MSG=MSG_"Paused ",I3=1,%H=UPDATE
 S:SHORT="" MSG=MSG_"Stopped ",I3=1,%H=STOP
 S:SHORT="RUN"&(ZTH-RUN*86400+$P(ZTH,",",2)-$P(RUN,",",2)>120) MSG=MSG_"Stalled ",I3=1,%H=RUN
 S MSG=MSG_"since: "
 D YX^%DTC S I2=Y
 S MSG=MSG_$S(+X>3000000:$$SHORTEN(Y),1:"Unknown.")
 Q $S(I3:MSG,1:"")
 ;
WARNHDR() ; /IHS/OIT/RAM/ ; P52 ; FUNCTION CALL TO RETURN WARNING HEADER.
 NEW TMSTATUS,POSTATUS,MSG,POSMSG,POSINPUT,CLAIMMSG,CLAIMNUM,XMITMSG,XMITNUM
 NEW CLAIMMAX,XMITMAX,QUESTATS,INSMSG,INSURER,I,I2,I3,X,Y,%H,ZTH,SECS,DIFF
 ;
 ; /IHS/OIT/RAM ; Taskman 2+ minutes late, attempt to find when it stopped & send message back.
 S MSG=$$TASKMAN Q:MSG'="" MSG
 ;
 ; W "PAST TASKMAN",!
 S POSINPUT=$$GET1^DIQ(9002313.99,"1,",943,"I"),POSTATUS=$$STATUS^ABSPOSR1
 ; /IHS/OIT/RAM ; POS Background task supposed to run but isn't. Find out last run time & send message back.
 I (POSINPUT=2)&(POSTATUS'="RUNNING") D  Q MSG
 . S MSG="POS Background Task Not Running as of: "
 . S I2=$$BACKLAST
 . I +I2>50000 S %H=I2 D YX^%DTC S I2=Y
 . S MSG=MSG_$S(+X>3000000:$$SHORTEN(Y),1:"Unknown.")
 ;
 ; W "PAST POS BACKGROUND",!
 S INSURER="MULTIPLE INSURERS" ; if the queue is down, let's default to multiple insurers, updated farther down.
 S QUESTATS="QUESTATS"
 D GETQUEUE(QUESTATS)
 S ZTH=$H,SECS=+ZTH*86400+$P(ZTH,",",2)  ; Get $H in seconds,
 S DIFF=SECS-$FN(@QUESTATS@("SECS"),"-")   ; and the oldest unresolved claim, also in seconds.
 ; W *9,$H,*9,DIFF,*9,SECS,*9,@QUESTATS@("SECS"),!
 I DIFF<300 Q ""  ; Is the claim older/newer than 300 seconds (5 Minutes)? No? Not a warning condition yet.
 ;
 ; W "PAST DIFF",!
 I $G(@QUESTATS@("INSURER"))=1 D  Q MSG   ; if only one insurer, retrieve their name & replace the default.
 . S I=$O(@QUESTATS@("INSURER",0)),CLAIMNUM=@QUESTATS@("INSURER",I)
 . S MSG=CLAIMNUM_$S(CLAIMNUM>1:" Claims",1:" Claim")
 . S INSURER=$$GET1^DIQ(9999999.18,I_",",.01)
 . S MSG=MSG_" from "_$E(INSURER,1,16)_" Not Processed since: "
 . S %H=$G(@QUESTATS@("H")) D YX^%DTC S I2=Y
 . S MSG=MSG_$S(+X>3000000:$$SHORTEN(Y),1:"Unknown.")
 ;
 ; W "PAST SINGLE INSURER",!
 I $G(@QUESTATS@("INSURER"))>1 D  Q MSG   ; if more than one insurer, default to "Multiple Insurers"
 . S CLAIMNUM=@QUESTATS@("TOTAL"),MSG=CLAIMNUM_$S(CLAIMNUM>1:" Claims",1:" Claim")
 . S MSG=MSG_" from "_INSURER_" Not Processed since: "
 . S X=$G(@QUESTATS@("OLDEST")) D H^%DTC S %H=%H_","_%T D YX^%DTC S I2=Y
 . S MSG=MSG_$S(+X>3000000:$$SHORTEN(Y),1:"Unknown.")
 ;
 ; W "PAST MULTIPLE INSURERS",!
 ; /IHS/OIT/RAM/ ; P52 ; Set up new header warning messages
 S CLAIMMSG="Claims Waiting to Start! Check POS Queue!"
 S XMITMSG="Claims Waiting to Transmit! Check POS Queue!"
 S INSMSG="Claim$ for ^ not processed! Check POS Queue!"
 ; /IHS/OIT/RAM/ ; P52 ; Get threshhold for "Waiting to start" count.
 S CLAIMMAX=+$$GET1^DIQ(9002313.99,"1,",2.03) S:CLAIMMAX=0 CLAIMMAX=3
 ; /IHS/OIT/RAM/ ; P52 ; Get threshhold for "Waiting to transmit" count.
 S XMITMAX=+$$GET1^DIQ(9002313.99,"1,",2.04) S:XMITMAX=0 XMITMAX=3
 ;
 Q ""
 ;
SHORTEN(LONGTIME) ; /IHS/OIT/RAM/ ; P52 ; SHORTEN DATE/TIME TO DECREASE LINE LENGTH REQUIREMENTS
 N I,I2,I3,%H,%T,%Y,Y,X
 S Y=LONGTIME
 I $L(Y,":")>2 S Y=$E(Y,1,$L(Y)-3)
 S Y=$E(Y,1,6)_" '"_$E(Y,11,$L(Y))
 Q Y
 ;
BACKLAST() ; ROUTINE TO FIND THE LAST TIME THAT THE BACKGROUND JOB RAN.
 ; 
 N I,I2,I3,J,J2,J3,ENTRY,ROUTINE
 S I2=0
 S I=99999999 F  S I=$O(^%ZTSK(I),-1) Q:+I<1  D
 . S ENTRY=$P($G(^%ZTSK(I,0)),"^",1)
 . S ROUTINE=$P($G(^%ZTSK(I,0)),"^",2)
 . Q:$E(ROUTINE,1,4)'="ABSP"
 . Q:ENTRY'="BACKGR"
 . ; W I,*9,ENTRY,"^",ROUTINE,!
 . S I2=$P($G(^%ZTSK(I,0)),"^",6),I=1
 Q I2
 ;
