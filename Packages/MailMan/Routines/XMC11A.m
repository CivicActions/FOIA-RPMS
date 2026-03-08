XMC11A ;(WASH ISC)/THM- Ask Domain / Script  ;01/28/99  15:07
 ;;7.1;MailMan;**27,50**;Jun 02, 1994
INST(XMINST,XMINSTN,XMB,XMDIC,XMIO,XMABORT) ; Decide which Institution and Script to use
 N XMSCRDAT
 K XMB
 D ASKINST(.XMINST,.XMINSTN,.XMB,.XMABORT) I XMABORT S XMINST=-1 K XMB Q
 D GETSCR(XMINST,.XMB,.XMSCRDAT,.XMABORT) I XMABORT S XMINST=-1 K XMB Q
 D S(XMSCRDAT,.XMB,.XMIO)
 S XMDIC="^DIC(4.2,"_XMINST_",1,"_XMB("SCRIPT",0)_",1,"
 Q
ASKINST(XMINST,XMINSTN,XMB,XMABORT) ; Lookup domain with script
 N DIC,X,Y
 S DIC=4.2,DIC(0)="AEQMZ"
 I $D(XMTALKER) S DIC("S")="I $P(^(0),U,2)[""T"""
 D ^DIC I Y=-1 S XMABORT=1 Q
 S XMINST=+Y
 I '$O(^DIC(4.2,XMINST,1,0)) D  Q
 . W !!,"No Transmission Script !!!",*7,!!
 . S XMABORT=1
 S XMINSTN=Y(0,0)
 S XMB("ZERO")=Y(0)
 Q
GETSCR(XMINST,XMB,XMSCRDAT,XMABORT) ; Get Script info
 S (XMOKSCR("SMTP"),XMOKSCR("NONE"))=""
 S XMSCRDAT=$$SCR^XMBPOST(XMINST,.XMOKSCR,"") K XMOKSCR
 I XMSCRDAT="" W !,"No valid script for this domain!" S XMABORT=1 Q
 ;Default and do not ask if only one script on file
 I $O(^DIC(4.2,XMINST,1,0))=XMB("SCRIPT",0),+$O(^(XMB("SCRIPT",0)))=0 Q
 ;If TalkMan default to highest priority (or 1st) script
 I $D(XMTALKER) D TALKMAN(XMINST,.XMB,.XMSCRDAT,.XMABORT) Q
 D ASKSCR(XMINST,.XMB,.XMSCRDAT,.XMABORT)
 Q
TALKMAN(XMINST,XMB,XMSCRDAT,XMABORT) ;
 N XMPRI,XMIEN,XMREC
 S XMPRI=0
 F  S XMPRI=$O(^DIC(4.2,XMSCR,1,"AC",XMPRI)) Q:'XMPRI  D  Q:"^SMTP^TELNET^"[(U_$P(XMREC,U,4)_U)
 . ;Check for proper protocol type
 . S XMIEN=$O(^DIC(4.2,XMSCR,1,"AC",XMPRI,0))
 . S XMREC=^DIC(4.2,XMSCR,1,XMIEN,0)
 I 'XMPRI D  Q
 . S XMABORT=1
 . S XMMG="Domain doesn't have an appropriate connection method -- see your manager."
 S XMSCRDAT=XMIEN_U_XMREC
 Q
ASKSCR(XMINST,XMB,XMSCRDAT,XMABORT) ; Ask user to select the script.
 ; List valid entries.
 N I,XMREC
 W !!,"  #  Script Name",?30,"Type",?40,"Priority"
 S I=0
 F  S I=$O(^DIC(4.2,XMINST,1,I)) Q:'I  S XMREC=^(I,0) W !,$J(I,3),?5,$P(XMREC,U),?30,$P(XMREC,U,4),?40,$J($P(XMREC,U,2),2),?50,$S($P(XMREC,U,7):"Warning: Out of Service",1:"")
 W !
 N DIC,X,Y
 S DIC="^DIC(4.2,XMINST,1,"
 S DIC(0)="AEQMNZ"
 S DIC("A")="Select Script: "
 S DIC("B")=XMB("SCRIPT",0)
 S DIC("W")="W ?30,""Type="",$P(^(0),U,4),?45,""Priority="",$J($P(^(0),U,2),2),?60,$S($P(^(0),U,7):""* Out of Service *"",1:"""")"
 D ^DIC I Y=-1 S XMABORT=1 Q
 S XMSCRDAT=+Y_U_Y(0)
 Q
S(%,XMB,XMIO) ;
 D XMB^XMBPOST
 S XMIO=$P(XMB("SCRIPT"),U,5)
 S:XMIO="" XMIO=$P(XMB("ZERO"),U,17)
 S XMB("ITERATIONS")=0,XMB("FIRST SCRIPT")=XMB("SCRIPT",0)
 Q
