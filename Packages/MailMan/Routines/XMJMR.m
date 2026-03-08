XMJMR ;ISC-SF/GMB-Interactive Reply ;06/14/99  14:14
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces REPLY^XMA11,^XMA2,^XMA20,^XMAH1 (ISC-WASH/CAP/THM)
REPLY(XMDUZ,XMK,XMKN,XMZO,XMZOSUBJ,XMZOFROM,XMINSTR,XMPTR,XMRESPSO,XMINCL,XMRESP) ;
 N XMABORT,XMZ,XMID,XMWHICH
 S XMABORT=0
 D INIT(XMDUZ,.XMK,.XMKN,XMZO,XMZOSUBJ,XMZOFROM,.XMINSTR,XMINCL,.XMWHICH,.XMABORT) Q:XMABORT
 D CRE8XMZ^XMXSEND("R"_XMZO,.XMZ,1) I XMZ<1 S XMABORT=1 Q
 S XMID=$S(XMDUZ=.6:DUZ,1:XMDUZ)
 D EDITON^XMJMS(XMID,XMZ,XMZO)
 D PROCESS(XMID,XMK,XMKN,XMZO,XMZOSUBJ,XMZOFROM,XMZ,.XMINSTR,XMPTR,XMRESPSO,.XMRESP,.XMWHICH,.XMABORT)
 I XMABORT=DTIME D HALT^XMJMS("replying to")
 D EDITOFF^XMJMS(XMID)
 D:XMABORT KILLMSG^XMXUTIL(XMZ)
 Q
INIT(XMDUZ,XMK,XMKN,XMZO,XMZOSUBJ,XMZOFROM,XMINSTR,XMINCL,XMWHICH,XMABORT) ;
 N DIR,Y,DIRUT,XMFINISH,XMRESPS
 I XMDUZ=.6,DUZ=.6 D  Q
 . S XMABORT=1
 . W !,"You may not reply to a message as SHARED,MAIL."
 . G H^XUS
 D CHKLOCK^XMJMS(XMDUZ,.XMABORT) Q:XMABORT
 I XMINSTR("FLAGS")["P" D  Q:XMABORT
 . W *7,!!,"Responses to priority messages are not always delivered as priority mail."
 . W !,"If your response needs priority delivery, use the 'write' command to send"
 . W !,"a new priority message.",!
 . D PAGE^XMXUTIL(.XMABORT)
 I XMZOFROM["POSTMASTER@" D  Q:XMABORT
 . W *7,!!,"Because this message is from a remote POSTMASTER,"
 . W !,"your reply will remain local; it will not be sent over the network.",!
 . D PAGE^XMXUTIL(.XMABORT)
 I +XMK<1 D
 . W !
 . D SAVEMSG^XMJMOI(XMDUZ,.XMK,.XMKN,XMZO,XMZOSUBJ,XMZOFROM,$G(XMINSTR("RCPT BSKT")))
 S XMRESPS=+$P($G(^XMB(3.9,XMZO,3,0)),U,4)
 ; XMINCL =0 Do not include previous responses.  Just reply.
 ;        =1 Include previous response(s) in reply.
 ;        =? Ask user if previous responses should be included in reply.
 Q:XMINCL=0
 I XMINCL=1 D WHICH^XMJMC(XMZO,"include",.XMWHICH,.XMABORT) Q
 S XMFINISH=0
 F  D  Q:XMABORT!XMFINISH
 . S DIR(0)="S^R:Reply;S:Show recipients;I:Include "_$S(XMRESPS:"selected responses",1:"the original message")_" in my reply"
 . S DIR("?")="^D HELPINIT^XMJMR"
 . S DIR("A")="Select response action"
 . S DIR("B")="Reply"
 . D ^DIR I $D(DIRUT) S XMABORT=1 Q
 . I Y="R" S XMFINISH=1 Q
 . I Y="I" D  Q
 . . D WHICH^XMJMC(XMZO,"include",.XMWHICH,.XMABORT)
 . . S XMFINISH=1
 . D SHOWRECP(XMZO,.XMABORT)
 Q
HELPINIT ;
 W !,"Enter 'R' to reply to the message."
 W !!,"Enter 'S' if you want to see who else is on the message."
 W !!,"Enter 'I' if you want to include previous responses in your reply."
 D HELPCOPY
 Q
SHOWRECP(XMZO,XMABORT) ;
 N I,XMNAME,XMCNT,XMPOS,XMMULT,XMMSTR,DIR,Y,XMNOMORE
 S XMNOMORE=0
 I $O(^XMB(3.9,XMZO,6,0))="" D
 . S XMMULT=1
 . S XMMSTR="^XMB(3.9,"_XMZO_",1,""C"","
 E  D
 . S XMMULT=6
 . S XMMSTR="^XMB(3.9,"_XMZO_",6,""B"","
 W !
 S XMPOS=-20,XMCNT=0,I=""
 F  S I=$O(@(XMMSTR_"I)")) Q:I=""  D  Q:XMNOMORE
 . S XMCNT=XMCNT+1,XMPOS=XMPOS+20
 . I +I=I S XMNAME=$$NAME^XMXUTIL(I)
 . E  I $L(I)<30 S XMNAME=I
 . E  S XMNAME=$P($G(^XMB(3.9,XMZO,XMMULT,$O(@(XMMSTR_"I,0)")),0)),U,1)
 . F  Q:($X+2<XMPOS&(XMPOS+$L(XMNAME)<IOM))!(XMPOS=0)  D  Q:XMNOMORE
 . . S XMPOS=XMPOS+20
 . . Q:XMPOS<IOM
 . . I XMCNT#24=0 D
 . . . N DIR S DIR(0)="Y",DIR("A")="More",DIR("B")="No"
 . . . D ^DIR
 . . . S XMNOMORE='Y
 . . . I $D(DIRUT) S XMABORT=1 Q
 . . S XMPOS=0
 . Q:XMNOMORE
 . I XMPOS=0 W !,XMNAME
 . E  W ?XMPOS,XMNAME
 Q:XMABORT
 W !,"That's all the recipients."
 D PAGE^XMXUTIL(.XMABORT)
 Q
HELPCOPY ;
 W !,"You might choose to include previous responses if, for example,"
 W !,"- those responses contained questions which you intend to answer."
 W !,"- those responses contained assertions with which you agree or disagree."
 W !,"You could copy those responses, then edit out everything except"
 W !,"the questions or assertions, and then insert your answers or comments."
 Q
COPYTEXT(XMZO,XMZ,XMWHICH) ;
 N I,XMRESP,XMRANGE,XMC
 W !,"Copying..."
 S XMC=+$O(^XMB(3.9,XMZ,2,""),-1)
 F I=1:1:$L(XMWHICH,",") D
 . S XMRANGE=$P(XMWHICH,",",I)
 . Q:XMRANGE=""  ; (XMWHICH can end with a ",", giving us a null piece.)
 . F XMRESP=$P(XMRANGE,"-",1):1:$S(XMRANGE["-":$P(XMRANGE,"-",2),1:XMRANGE) D
 . . I XMRESP=0 D COPYRESP(XMRESP,XMZO,XMZ,.XMC) Q
 . . D COPYRESP(XMRESP,+$G(^XMB(3.9,XMZO,3,XMRESP,0)),XMZ,.XMC)
 S ^XMB(3.9,XMZ,2,0)="^3.92A^"_XMC_U_XMC_U_DT
 Q
COPYRESP(XMRESP,XMZR,XMZ,XMC) ;
 N XMF,XMFROM,XMDT,XMZREC
 S XMC=XMC+1
 S ^XMB(3.9,XMZ,2,XMC,0)=""
 S XMZREC=$G(^XMB(3.9,XMZR,0))
 S XMFROM=$$NAME^XMXUTIL($P(XMZREC,U,2))
 S XMDT=$P(XMZREC,U,3)
 S XMC=XMC+1
 S ^XMB(3.9,XMZ,2,XMC,0)="On "_$$MMDT^XMXUTIL1(XMDT)_$S(XMRESP:" (Response #"_XMRESP_") ",1:" (Original message) ")_XMFROM_" wrote:"
 S XMF=.999999
 F  S XMF=$O(^XMB(3.9,XMZR,2,XMF)) Q:XMF=""  D
 . S XMC=XMC+1
 . W:XMC#50=0 "."
 . S ^XMB(3.9,XMZ,2,XMC,0)=$E(">"_^XMB(3.9,XMZR,2,XMF,0),1,254)
 Q
PROCESS(XMDUZ,XMK,XMKN,XMZO,XMZOSUBJ,XMZOFROM,XMZ,XMINSTR,XMPTR,XMRESPSO,XMRESP,XMWHICH,XMABORT) ;
 N XMRESTR
 D:$D(XMWHICH) COPYTEXT(XMZO,XMZ,XMWHICH)
 D BODY^XMJMS(XMDUZ,XMZ,XMZOSUBJ,.XMRESTR,.XMABORT) Q:XMABORT
 D REPLYMSG^XMJMRO(XMDUZ,XMK,XMKN,XMZO,XMZ,XMZOSUBJ,.XMRESTR,XMPTR,XMRESPSO,.XMRESP,.XMABORT) Q:XMABORT
 I XMZOFROM["@",$$UP^XLFSTR(XMZOFROM)'["POSTMASTER" D REMOTE(XMDUZ,XMZO,XMZOSUBJ,XMZ,.XMINSTR)
 Q
REMOTE(XMDUZ,XMZO,XMZOSUBJ,XMZ,XMINSTR) ;
 N DIR,Y,XMSUBJ,XMTO,XMABORT,XMRESTR
 S XMABORT=0
 S DIR("A")="Do you wish to send this reply across the network"
 S DIR(0)="Y",DIR("B")="No"
 S DIR("?",1)="Enter 'yes' if you wish to send this message across the network;"
 S DIR("?")="Enter 'no' if you wish your response to remain local."
 S DIR("??")="^D RHELP^XMJMR"
 D ^DIR Q:$D(DIRUT)
 Q:Y=0
 S XMSUBJ=$S($$UP^XLFSTR($E(XMZOSUBJ,1,4))="RE: ":XMZOSUBJ,1:$E("Re: "_XMZOSUBJ,1,65))
 D SUBJ^XMJMS(.XMSUBJ,.XMABORT) Q:XMABORT
 D REPLYTO(XMZO,.XMTO,.XMABORT) Q:XMABORT
 W !,"Addressing the reply to: ",XMTO
 D INIT^XMXADDR
 S XMRESTR("FLAGS")="O" ; match on exact domain name, if possible
 D ADDR^XMXADDR(XMDUZ,XMTO,.XMINSTR,.XMRESTR)
 ;S:XMTO[".VA.GOV" XMTO=$TR($P(XMTO,"@"),"._+",", .")_"@"_$P(XMTO,"@",2)
 I $D(^TMP("XMY",$J)) D
 . W !,"  Sending network reply..."
 . D NETREPLY^XMXREPLY(XMDUZ,XMZO,XMZ,XMSUBJ,.XMINSTR)
 . W "  Sent"
 D CLEANUP^XMXADDR
 Q
RHELP ;
 W !,"A network response will go to all message recipients on the mail system"
 W !,"of the sender."
 W !!,"For example, if the sender's address ends '@FORUM.VA.GOV', and the message"
 W !,"had 500 recipients on FORUM, then a response sent across the network would be"
 W !,"delivered to 500 recipients."
 W !!,"If you prefer to send a response only to the sender, you may create"
 W !,"a new message by choosing to 'answer' or 'write', instead of 'reply'."
 Q
REPLYTO(XMZ,XMFROM,XMABORT) ;
 N XMREPLTO,XMF,XMR
 D REPLYTO^XMXREPLY(XMZ,.XMFROM,.XMREPLTO)
 S XMF=XMFROM
 S XMFROM=$$REMADDR^XMXADDR1(XMFROM)
 Q:$G(XMREPLTO)=""
 S XMR=XMREPLTO
 S XMREPLTO=$$REMADDR^XMXADDR1(XMREPLTO)
 Q:$$UP^XLFSTR(XMREPLTO)=$$UP^XLFSTR(XMFROM)
 N DIR,Y
 S DIR(0)="S^"
 S DIR(0)=DIR(0)_"F:'FROM'     "_XMF
 S DIR(0)=DIR(0)_";R:'REPLY-TO' "_XMR
 S DIR("B")="R"
 S DIR("A",1)="This message has a 'reply-to' address which differs from the 'from' address."
 S DIR("A")="Select the address to use"
 S DIR("?",1)="Generally, we recommend that you use the 'reply-to' address."
 S DIR("?",2)="The choice, however, is up to you."
 S DIR("?")="Select F to use the 'from' address; R the 'reply-to'."
 D ^DIR I $D(DIRUT) S XMABORT=1 Q
 S:Y="R" XMFROM=XMREPLTO
 Q
RECOVER(XMDUZ,XMZ,XMZO) ;
 N DIR,Y
 W *7,!!,"You have an unsent response remaining in your buffer."
 W !,"You may continue to reply or delete the remaining text."
 S DIR(0)="Y"
 S DIR("A")="Do you want to delete the unsent response"
 S DIR("B")="No"
 S DIR("?",1)="Enter 'Yes' to delete the unsent response."
 S DIR("?",2)="Enter 'No' to continue with the response."
 S DIR("?",3)=""
 S DIR("?",4)="If in doubt, just press return.  You will be able to edit"
 S DIR("?")="the response and delete it if you wish."
 D ^DIR
 I $D(DTOUT) D HALT^XMJMS("recovering")
 I Y=1!$D(DUOUT) D  Q
 . D EDITOFF^XMJMS(XMDUZ)
 . D KILLMSG^XMXUTIL(XMZ)
 N XMK,XMKN,XMZOSUBJ,XMZOFROM,XMINSTR,XMABORT,XMSECURE,XMPAKMAN,XMWHICH,XMPTR,XMRESPSO,XMRESP
 S XMABORT=0
 D RECINIT(XMDUZ,XMZO,.XMK,.XMKN,.XMZOSUBJ,.XMZOFROM,.XMINSTR,.XMPTR,.XMRESPSO,.XMRESP)
 D INIT(XMDUZ,.XMK,.XMKN,XMZO,XMZOSUBJ,XMZOFROM,.XMINSTR,0,.XMWHICH,.XMABORT)
 I XMABORT D HALT^XMJMS("recovering")
 D PROCESS(XMDUZ,XMK,XMKN,XMZO,XMZOSUBJ,XMZOFROM,XMZ,.XMINSTR,XMPTR,XMRESPSO,.XMRESP,.XMWHICH,.XMABORT)
 I XMABORT=DTIME D HALT^XMJMS("replying to")
 D EDITOFF^XMJMS(XMDUZ)
 D:XMABORT KILLMSG^XMXUTIL(XMZ)
 Q
RECINIT(XMDUZ,XMZO,XMK,XMKN,XMZOSUBJ,XMZOFROM,XMINSTR,XMPTR,XMRESPSO,XMRESP) ;
 N XMSECBAD,XMIM,XMIU
 S XMK=+$O(^XMB(3.7,"M",XMZO,XMDUZ,""))
 S XMKN=$P($G(^XMB(3.7,XMDUZ,2,XMK,0)),U,1)
 D DISPMSG^XMJMP(XMDUZ,XMK,XMKN,XMZO,.XMSECBAD)
 I $G(XMSECBAD) D HALT^XMJMS("recovering")
 D INMSG^XMXUTIL2(XMDUZ,0,XMZO,"","I",.XMIM,.XMINSTR,.XMIU)
 S XMZOSUBJ=XMIM("SUBJ")
 S XMZOFROM=XMIM("FROM")
 S XMRESPSO=XMIM("RESPS")
 S XMPTR=XMIU("IEN")
 S XMRESP=XMIU("RESP")
 Q
