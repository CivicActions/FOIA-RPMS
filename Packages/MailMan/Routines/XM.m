XM ;ISC-SF/GMB-MailMan Main Driver ;06/25/99  08:00
 ;;7.1;MailMan;**17,35,50**;Jun 02, 1994
 ; Replaces ^XM,EN^XMA01,INTRO^XMA6,REC^XMA22,MULTI^XM0,^XMAK (ISC-WASH/CAP/THM)
 ; Entry points (DBIA 10064):
 ; ^XM       Programmer entry into MailMan
 ; CHECKIN   Meant to be included in option ENTRY ACTION
 ; CHECKOUT  Meant to be included in option EXIT ACTION
 ; EN        Option entry point into MailMan
 ; HEADER    Displays user intro when entering MailMan
 ; KILL      Kill MailMan variables
 ; N1        Create a mailbox
 ; NEW       Create a mailbox
 ; $$NU      Tell user how many new messages he has
 ; 
 ; Entry points used by MailMan options (not covered by DBIA):
 ; NEWMBOX   XMMGR-NEW-MAIL-BOX - Create a mailbox
 ; KILL      XMQDISP exit action
 N XMXUSEC,XMABORT
 D KILL^XUSCLEAN
 I '$D(IOF) S IOP="HOME" D HOME^%ZIS
 D EN
 Q:'$D(XMDUZ)
 D:'$D(^DOPT("XM")) OPTIONS
 S XMABORT=0
 F  D  Q:XMABORT  ; Programmer option choices
 . N DIC,X,Y
 . S XMXUSEC=$S($G(DUZ(0))="@":1,$D(^XUSEC("XUPROG",XMDUZ)):1,$D(^XUSEC("XUPROGMODE",XMDUZ)):1,1:0)
 . S DIC="^DOPT(""XM"","
 . S DIC(0)="AEQMZ"
 . S DIC("S")="Q:XMXUSEC  I ^(0)'[""LOAD"""
 . W !!
 . D ^DIC I Y<0 S XMABORT=1 Q
 . K DIC,X
 . X $P(Y(0),U,2,999)
 D CLEANUP
 Q
EN ;Initialize
 ;N XMDUZ,XMDISPI,XMDUN,XMNOSEND,XMV
 Q:$D(DUZ("SAV"))  ; Set by option XUTESTUSER
 D SETUP
 D HEADER
 Q
SETUP ;
 I $G(IO)'=$G(IO(0))!'$D(IO(0)) D HOME^%ZIS U IO
 D CHECK^XMKPL ; Make sure background filers are running.
 I '$D(IOF)!'$D(IOM)!'$D(IOSL) S IOP="" D ^%ZIS K IOP
 S XMDUZ=DUZ
 D INIT^XMVVITAE
 K XMERR,^TMP("XMERR",$J)
 Q
HEADER ;
 N XMPERSON
 I $D(XMV("SYSERR")) D SYSERR(.XMV) S:$D(XMMENU) XQUIT="" Q  ; Fatal Errors
 I $D(XMV("ERROR")) D ERROR(.XMV) S:$D(XMMENU) XQUIT="" Q  ; Fatal Errors
 I $D(XMV("WARNING")) D WARNING(XMDUZ,.XMV)
 W !!,XMV("VERSION")," service for ",XMV("NETNAME")
 I XMDUZ'=DUZ W !," (Surrogate: ",XMV("DUZ NAME"),")"
 I XMDUZ'=.6 D
 . W !,$S(XMDUZ=DUZ:"You",1:XMV("NAME"))," last used MailMan: ",XMV("LAST USE")
 . I $D(XMV("BANNER")) W !,$S(XMDUZ=DUZ:"Your",1:XMV("NAME")_"'s")," current banner: ",XMV("BANNER")
 . ;E  W !,$S(XMDUZ=DUZ:"You have",1:XMV("NAME")_" has")," no banner."
 W !,$S(XMDUZ=DUZ:"You have ",1:XMV("NAME")_" has "),$S(XMV("NEW MSGS")=0:"no",1:XMV("NEW MSGS"))," new message",$S(XMV("NEW MSGS")=1:".",1:"s.")
 I XMV("NEW MSGS")<0!(XMV("NEW MSGS")&'$D(^XMB(3.7,XMDUZ,"N0")))!('XMV("NEW MSGS")&$D(^XMB(3.7,XMDUZ,"N0"))) D
 . W !,"There's a discrepancy in the 'new message' count.  Checking the mailbox..."
 . D USER^XMUT4(XMDUZ)
 Q
SYSERR(XMV) ;
 N I
 S I=0
 F  S I=$O(XMV("SYSERR",I)) Q:I=""  W !,*7,XMV("SYSERR",I)
 K XMDUZ
 Q
ERROR(XMV) ;
 N I
 S I=0
 F  S I=$O(XMV("ERROR",I)) Q:I=""  W !,*7,XMV("ERROR",I)
 K XMDUZ
 Q
WARNING(XMDUZ,XMV) ;
 D:$D(XMV("WARNING",5)) POST(XMV("WARNING",5))
 D:$D(XMV("WARNING",4)) MULTI
 D:$D(XMV("WARNING",3)) INTRO(XMDUZ)
 D:$D(XMV("WARNING",2)) UNSENT(XMDUZ)
 D:$D(XMV("WARNING",1)) LISTPRI^XMJML(XMDUZ)
 ;D:$D(XMV("WARNING",1)) PRIO^XMJML(XMDUZ)
 K XMV("WARNING")
 Q
POST(XMMSG) ;
 W !!,XMMSG   ; "POSTMASTER has X baskets."
 W !,"The POSTMASTER may not have a basket with an internal number >999"
 W !,"without having problems.  Problems with network mail delivery will"
 W !,"soon occur if you do not take corrective action!"
 W !!,"Contact your ISC for help.",!!,*7
 Q
MULTI ;
 W *7,!!,"It appears someone is signed on as you already."
 W !!,"YOU MAY NOT SEND MAIL OR RESPOND TO MAIL IN THIS SESSION !!!"
 W !,"(Only the 1st of multiple MailMan sessions may send or respond to mail.)"
 Q
INTRO(XMDUZ) ;
 W !!,"You have not yet introduced yourself to the group."
 W !,"Please enter a short introduction, so that others may use"
 W !,"the HELP option to find out more about you.",!!
 W !,"You may change your INTRODUCTION later"
 W !,"under 'Personal Preferences|User Options Edit.",!!
 N DIR S DIR(0)="E" D ^DIR Q:$D(DIRUT)
 N DWPK,DIC
 S DWPK=1,DIC="^XMB(3.7,XMDUZ,1,"
 D EN^DIWE
 Q
UNSENT(XMDUZ) ;
 N XMREC,XMZ
 S XMREC=^XMB(3.7,XMDUZ,"T")
 S XMZ=$P(XMREC,U) Q:'XMZ
 I $P(XMREC,U,3) D RECOVER^XMJMR(XMDUZ,XMZ,$P(XMREC,U,3)) Q  ; Reply
 D RECOVER^XMJMS(XMDUZ,XMZ,$P(XMREC,U,4))  ; Original Message (w/BLOB)
 Q
CHECKIN ;
 Q:$D(XMMENU(0))   ; Set by option XMUSER or other options using MailMan
 Q:$D(DUZ("SAV"))  ; Set by option XUTESTUSER
 D SETUP
 I $D(XMV("WARNING")) D WARNING(XMDUZ,.XMV)
 Q
CHECKOUT ;
 K XMERR,^TMP("XMERR",$J)
 Q:$D(XMMENU(0))
 K XMDISPI,XMDUN,XMDUZ,XMNOSEND,XMPRIV,XMV
 L -^XMB(3.7,"AD",DUZ)
 Q
LOCK ;
 S Y=1
 Q:'$D(XMMENU(0))
 L +^XMB(3.7,"AD",DUZ):0 E  D MULTI S Y=-1
 Q
UNLOCK ;
 Q:'$D(XMMENU(0))
 L -^XMB(3.7,"AD",DUZ)
 Q
CHK ;
 K ^TMP("XMY",$J),^TMP("XMY0",$J)
 S XMDUZ=$G(XMDUZ,DUZ)
 Q:XMDUZ=.6
 D NUS(0)
 Q
NU(XMFORCE) ;API for new message display
 ; XMFORCE  (in) 1=force new display; 0=display only if recent receipt
 N XMNEW
 D NUS(XMFORCE,.XMNEW)
 Q XMNEW
NUS(XMFORCE,XMNEW) ; new message display
 ; XMFORCE  (in) 1=force new display; 0=display only if recent receipt
 ; XMNEW    (out) number of new messages
 ; XMLAST   last message arrival date (FM format)
 N XMREC,XMNEW2U,XMLAST
 S XMDUZ=$G(XMDUZ,DUZ)
 S XMREC=$$NEWS^XMXUTIL(XMDUZ,$D(DUZ("SAV")))
 Q:XMREC=-1
 S XMNEW=$P(XMREC,U,1)
 I 'XMFORCE,'XMNEW Q
 S XMLAST=$P(XMREC,U,4)
 S XMNEW2U=$P(XMREC,U,5)
 I XMNEW2U!XMFORCE D
 . W $S(XMDUZ=DUZ:"You have ",1:$$NAME^XMXUTIL(XMDUZ)_" has "),$S('XMNEW:"no",1:XMNEW)," new message",$S(XMNEW=1:"",1:"s"),"."
 . Q:'XMNEW
 . W "  (Last arrival: ",$$MMDT^XMXUTIL1(XMLAST),")"
 D:$P(XMREC,U,2) NOTEPRIO
 Q
NOTEPRIO ;
 D ZIS
 W *7,!!,$G(IORVON),"There is PRIORITY Mail!",!!,$G(IORVOFF)
 Q
ZIS ;
 Q:$D(IORVON)
 N X
 S X="IORVON;IORVOFF;IOBON;IOBOFF"
 D ENDR^%ZISS
 Q
NEWMBOX ; Create a mailbox for a user
 N DIC,XMZ
 W !,"Ready to create a mailbox for a user."
 W !,"You will only be able to select a user who does not already have a mailbox."
 S DIC="^VA(200,"
 S DIC(0)="AEQM"
 S DIC("S")="I '$D(^XMB(3.7,Y,0))"
 D ^DIC Q:Y=-1
 S Y=+Y
 D NEW
 W !,"Mailbox created."
 Q
N1 S Y=XMDUZ
NEW ; CREATE MAILBOX 4 NEW USER
N L +^XMB(3.7,0):0 E  H 1 G N
 I $D(XMZ) D
 . D CRE8MBOX^XMXMBOX(Y,DT)
 E  D
 . D CRE8MBOX^XMXMBOX(Y)
 L -^XMB(3.7,0)
 D:$D(XMERR) SHOW^XMJERR
 Q
KILL ; EXIT execute for MailMan options
CLEANUP ;
 K XMV,XMDISPI,XMDUNO,XMDUN,XMDUZ,XMPRIV,XMERR
 K:$D(^TMP("XMERR",$J)) ^TMP("XMERR",$J)
 D KILLALL
 D UNLOCK
 Q
KILLALL ;All variables except XMDISPI,XMDUZ,XMDUN and XMPRIV are killed here on
 ;exit from the MailMan package or by calls to this code.
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Z,%,%0,%1,%2,%3,%4
 K XM,XMA0,XMA21A,XMAPBLOB,XMB0,XMC0,XMD0,XMDUNO,XME0,XMF0,XMG0,XMP,XMQF,XMQUE
 K XMKEY,XMA,XMB,XMBEG,XMC,XMCL,XMCNT,XMD,XMDI,XMDX,XME,XMF,XMG,XMI,XMJ
 K XMK,XMKO,XMKS,XML,XMR,XMRC,XMRES,XMS,XMSUB,XMT,XMU,XMY,XMY0,XMZ,XMZ1,XMZ2,XMKM
 K XMCH,XMCI,XMDN,XMMA,XMZO,XMCT,XMRW,XMLOAD,XMCOPY,XMMG,XMOUT
 K XMDT,XMKK,XMKN,XMLOC,XMLOCK,XMM,XMN,XMRL,XMAN,XMANSP,XMXD,XMDATE,XMPG,XMSEC,XMSEN,XMTYPE,XMKEYTRY
 Q
DSP ;
 D INIT^XMVVITAE
 Q
OPTIONS ; Set up options
 N DIK,I,X
 K ^DOPT("XM")
 S DIK="^DOPT(""XM"","
 S ^DOPT("XM",0)="MailMan Option^1N^"
 F I=1:1 S X=$T(T+I) Q:X=" ;;"  S ^DOPT("XM",I,0)=$E(X,4,255)
 D IXALL^DIK
 Q
T ;;TABLE
 ;;SEND A MESSAGE^D SEND^XMJMS
 ;;READ/MANAGE MESSAGES^D MANAGE^XMJBM
 ;;NEW MESSAGES AND RESPONSES^D NEW^XMJBN
 ;;LOAD PACKMAN MESSAGE^D PAKMAN^XMJMS
 ;;EDIT USER OPTIONS^D EDIT^XMVVITA
 ;;PERSONAL MAIL GROUP EDIT^D PERSONAL^XMVGROUP
 ;;JOIN MAIL GROUP^D ENROLL^XMVGROUP
 ;;MAILBOX CONTENTS LIST^D LISTMBOX^XMJBL
 ;;LOG-IN TO ANOTHER SYSTEM (TalkMan)^D TALK^XMC
 ;;QUERY/SEARCH FOR MESSAGES^D FIND^XMJMF
 ;;BLOB SEND^D BLOB^XMA2B
 ;;
 ;;**OBSOLETE**
 ;;
