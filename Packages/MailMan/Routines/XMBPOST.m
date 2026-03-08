XMBPOST ;(WASH ISC)/THM/RWF/CAP-Create Task ;03/24/99  15:07
 ;;7.1;MailMan;**4,13,23,24,27,38,50**;Jun 02, 1994
 ;
 ;*******XXX/KCMO - MODIFIED AT TIM
 ;
 ;XMB("SCRIPT")=Zero node of Script last run
 ;XMB("SCRIPT",0)=Pointer to last script used
 ;
 ;Schedule a Task: 1=BASKET DROP,2=BULLETIN,3=MESSAGE TRANSMISSION
 ;
 ;Skip next logic if not network mail task
 G 0:'$D(XMINST),0:XMB("TYPE")'=3
 ;
 ;No new task for Network Transmission if one already scheduled
 S %=$P($G(^XMBS(4.2999,XMINST,0)),U,2) I % Q:$$CHK^XMS5(%,XMINST)
 D XMTCHECK(XMINST,.XMB)
 ;
ZTSK ;Entry if Requeue from Task
 ;No task if TCP Poll Flag set
 ; Q:$D(^DIC(4.2,"ATCP",1,XMINST))
 ;
 ;Transmission Script zero node
 S XMOKSCR("SMTP")="",XMOKSCR("NONE")=""
 S %=$G(XMB("SCRIPT",0))
 I %="" D
 . S %=$$SCR(XMINST,.XMOKSCR,"") Q:%=""
 . D XMB
 . S XMB("ITERATIONS")=0
 . S XMB("FIRST SCRIPT")=XMB("SCRIPT",0)
 E  I XMB("TRIES")'<$P($G(XMB("SCRIPT")),U,3) D
 . ; Use TRANSMISSION SCRIPT according to priority & number of attempts
 . S %=$$SCR(XMINST,.XMOKSCR,%) Q:%=""
 . D XMB
 . S XMB("TRIES",0,"$H")=$H
 . S:XMB("SCRIPT",0)=XMB("FIRST SCRIPT") XMB("ITERATIONS")=XMB("ITERATIONS")+1
 Q:%=""
 S %=$P(XMB("SCRIPT"),U,5),XMIO=$S($D(XMIO("DSERV")):XMIO("DSERV"),$L(%):%,1:$P(^DIC(4.2,XMINST,0),U,17)),XMB("TRIES")=XMB("TRIES")+1,$P(XMB("SCRIPT"),U,7)=$P(XMB("SCRIPT"),U,7)+1
 S $P(XMB("SCRIPT"),U,8)=$P(XMB("SCRIPT"),U,8)+1
 ;
 ;Set-up
0 I '$D(XMS5("RETURN_TASK#")) N ZTSK
 N I,X,Y,XMJ,XMP,ZTDTH,ZTPAR,ZTUCI,ZTSAVE,ZTIO,ZTDESC,ZTRTN
 ;
 ;Preserve X and Y coming in
 ;S:$D(X)#10 XMP=X S:$D(Y)#10 $P(XMP,U,2,3)=Y_U_"*"
 ;
 ;Device
 I '$D(XMIO),XMB("TYPE")=3 S Y=$P($G(^DIC(4.2,XMINST,0)),U,17),XMIO=$S($L(Y):Y,1:"")
 ;
TIM ;Time
 ;Pause if remote transmission
 I $G(XMB("TYPE"))=3 D
 . ; If we are about to start the cycle of scripts again, schedule the
 . ; task for 1 hour from now.
 . I XMB("ITERATIONS")>0,XMB("TRIES")=1,XMB("SCRIPT",0)=XMB("FIRST SCRIPT") S ZTDTH=$$HADD^XLFDT($H,"",1) Q
 . ; If we are about to retry, schedule the task for "tries" number of
 . ; minutes from now.
 . I $G(XMB("TRIES"))>1 S ZTDTH=$$HADD^XLFDT($H,"","",XMB("TRIES"))
 S:'$D(ZTDTH) ZTDTH=$H
 ;
 ;Which UCI
 X ^%ZOSF("UCI") S ZTUCI=Y
 ;
 ;Bulletin name
 I $D(XMB)#2 S XMB("A")=XMB
 ;
 ;Defaults
 D SW S X="MailMan",ZTRTN="ZTSK^XMB",ZTIO=$S($D(XMIO):XMIO,1:"")
 F I="XMB*","XMIO","ION","XMY*","XMYBLOB","XMDUZ" S ZTSAVE(I)=""
 I $D(^TMP("XMBTEXT",$J)) S ZTSAVE("^TMP(""XMBTEXT"",$J,")=""
 I XMB("TYPE")=2 S X="Bulletin: "_XMB
 I XMB("TYPE")=3 S X="Network Mail to "_XMB("XMSCRN"),ZTSAVE("DUZ")=.5
 E  F I="^TMP(""XMY"",$J,","^TMP(""XMY0"",$J," S ZTSAVE(I)=""
 S ZTDESC=X,ZTPAR=3
 ;
 ;Schedule Task
 D ^%ZTLOAD
 I $D(XMB("XMSCR")) S $P(^XMBS(4.2999,XMB("XMSCR"),3),U,7)=ZTSK,$P(^(0),U,2)=ZTSK
 ;
 ;Handle return for Device server (d.device_name addresses)
 ;I $D(XMP) S X=$P(XMP,U) I $P(XMP,U,3)="*" S Y=$P(XMP,U,2)
 ;
 ;Clean up and Quit
PK K XMIO,XMKK,XMTEXT,XMTSK,%DT,XMOKSCR Q
 ;
 ;Move Text array input to alternative array
SW Q:$G(XMTEXT)=""  K ^TMP("XMBTEXT",$J)
 S %X=XMTEXT,%Y="^TMP(""XMBTEXT"",$J," D %XY^%RCR
 Q
 ;Get Transmission Script Data
SCR(D,XMOKSCR,%) ;Parameter1=pointer to domain
 ;Parameter2=list of acceptable script types
 ;Parameter3=pointer to last script used
 ;RETURNS  ptr to script ^ 0 node of script
 ;If no transmission scripts are prioritized use old data/defaults
 N I,J,K,X,Y,XER,XMREC
 I $G(XM1Q) G PP
 S XER=$P($G(XMB("SCRIPT")),U,8)
 S J=0
 F  S J=$O(^DIC(4.2,D,1,J)) Q:J'=+J  D
 . S XMREC=$G(^DIC(4.2,D,1,J,0))
 . Q:$P(XMREC,U,7)  ; Out of service
 . S I=$P(XMREC,U,4)
 . S:I="" I="NONE"
 . Q:'$D(XMOKSCR(I))
 . S Y($S(+$P(^DIC(4.2,D,1,J,0),"^",2):+$P(^DIC(4.2,D,1,J,0),"^",2),1:9999),J)=J
 Q:'$D(Y) ""
PL I '$D(^DIC(4.2,D,1,+%,0)) S (%,XMB("SCRIPT",0))=0
 S REF="Y",REF=$Q(@REF) I +%<1 S XMB("SCRIPT",0)=@REF G PP
 S K=$S(+$P(^DIC(4.2,D,1,%,0),"^",2):+$P(^DIC(4.2,D,1,%,0),"^",2),1:9999)
 S REF2="Y(K,%)" F I=1:1:1 S REF2=$Q(@REF2) S XMB("SCRIPT",0)=$S(REF2'="":@REF2,1:@REF)
PP S %=+$G(^XMB(1,1,"NETWORK")),X=^DIC(4.2,D,0),I=XMB("SCRIPT",0)
 S X=I_U_$P(X,U)_"^0^"_$S(%:%,1:10)_"^SMTP^"_$P(X,U,17)_U_$P(X,U,12)_"^0^"_+$G(XER)
 ;Pickup data from selected script
GO S %=I_U_^DIC(4.2,D,1,I,0)
 ;
 ;Use defaults if no data in transmission script fields
 F I=2:1 Q:$P(X,U,I,999)=""  I $P(%,U,I)="" S $P(%,U,I)=$P(X,U,I)
 Q %
XMB ;Set up XMB array
 K XMB("TRIES")
 S XMB("TRIES")=0,XMB("SCRIPT",0)=+%,%=$P(%,U,2,$L(%,U)),XMB("SCRIPT")=%
 Q
 ;Set up for Requeing netmail delivery task
ZTSK0 S %=XMINST,XMB("TYPE")=3,(XMSCR,XMB("XMSCR"))=%,XMB("XMSCRN")=$S($D(XMB("XMSCRN")):XMB("XMSCRN"),$D(XMSITE):XMSITE,1:$P(^DIC(4.2,%,0),U)),XMQ(%)=""
 G ZTSK
DSERV ;Device Server comes in here
 S XMIO("DSERV")=XMIO G XMBPOST
XMTCHECK(XMINST,XMB) ;
 N XMTREC
 S XMTREC=$G(^XMBS(4.2999,XMINST,4))
 I $P(XMTREC,U,1),$P(XMTREC,U,2)="" D  ; Start time, but no finish time
 . ; Previous transmission attempt was aborted.
 . ; Pick up where we left off.
 . S XMB("SCRIPT",0)=$P(XMTREC,U,3)
 . S XMB("TRIES")=$P(XMTREC,U,4)
 . S XMB("LASTTRY")=$P(XMTREC,U,5)
 . S XMB("ITERATIONS")=$P(XMTREC,U,6)
 . S XMB("FIRST SCRIPT")=$P(XMTREC,U,7)
 . S XMB("SCRIPT")=$G(^XMBS(4.2999,XMINST,5))
 Q
XMTAUDIT(XMB) ;
 N XMTREC,XMFDA
 S XMTREC=$G(^XMBS(4.2999,XMB("XMSCR"),4),"XXX^XXX")
 S $P(XMTREC,U,5)=$$NOW^XLFDT    ; latest try date/time
 I $P($G(XMTREC),U,2)'="" D
 . S $P(XMTREC,U,1)=$P(XMTREC,U,5)    ; start time
 . S $P(XMTREC,U,2)=""                ; finish time
 . K ^XMBS(4.2999,XMB("XMSCR"),6)     ; Kill off the audit multiple
 S $P(XMTREC,U,3)=XMB("SCRIPT",0)     ; script ien
 S $P(XMTREC,U,4)=XMB("TRIES")        ; how many tries with this script
 S:'$D(XMB("ITERATIONS")) XMB("ITERATIONS")=0
 S $P(XMTREC,U,6)=XMB("ITERATIONS")   ; how many complete script cycles
 S:'$D(XMB("FIRST SCRIPT")) XMB("FIRST SCRIPT")=XMB("SCRIPT",0)
 S $P(XMTREC,U,7)=XMB("FIRST SCRIPT") ; ien of the first script used
 S $P(^XMBS(4.2999,XMB("XMSCR"),4),U,1,7)=XMTREC
 S ^XMBS(4.2999,XMB("XMSCR"),5)=XMB("SCRIPT")
 S XMFDA(4.29992,"+1,"_XMB("XMSCR")_",",.01)=$P(XMTREC,U,5) ; try time
 S XMFDA(4.29992,"+1,"_XMB("XMSCR")_",",1)=$P(XMB("SCRIPT"),U)  ; script name
 D UPDATE^DIE("","XMFDA")
 Q
