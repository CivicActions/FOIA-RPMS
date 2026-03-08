XMR0B ;(WASH ISC)/THM/CAP-SMTP (HELO/MAIL) [ARPANET RFC 821] ;06/14/99  16:39
 ;;7.1;MailMan;**4,6,13,34,42,62,50**;Jun 02, 1994
HELO ;HELLO COMMAND
 N X,Y,XMDOMREC
 I XMP="" S XMSG="501 Missing domain specification" X XMSEN Q
 I '$D(^XMB("NETNAME")) S XMSG="550 Unchristened local domain" X XMSEN Q
 S XMSTATE="^HELO^QUIT^"
 S X=$P(XMP,"<")
 I $E(X,$L(X))="." S XMSG="Invalid Domain Name" X XMSEN Q
 S Y=$$FACILITY^XMR1A(X)
 I Y>0 D
 . S XMINST=+Y
 . S (XMSITE,XMHELO("XMP"))=$P(Y,U,2)
 E  D
 . S XMHELO("XMP")=X
 . S Y=$$DOMAIN(X)
 . S XMINST=+Y
 . S XMSITE=$P(Y,U,2)
 S:'$G(XMRDOM) XMRDOM=XMINST
 D:'$D(^XMBS(4.2999,XMINST,0)) STAT^XMC1(XMINST)
 I XMBT D  Q
 . ; batch processing
 . S XMSTATE="^MAIL^",XMCONT=XMCONT_"TURN^MESS^"
 S XMDOMREC=^DIC(4.2,XMINST,0)
 I $P(XMDOMREC,U,15) D VALPROC(XMINST,XMDOMREC,XMP,.XMRVAL) Q:'$D(XMRVAL)
 S XMSG="250 OK "_^XMB("NETNAME")_$S($D(XMRVAL):" <"_XMRVAL_">",1:"")_" ["_$P($T(XMR0B+1),";",3)_",DUP,SER,FTP]" X XMSEN
 S XMSTATE="^MAIL^",XMCONT=XMCONT_"TURN^MESS^"
 Q
VALPROC(XMINST,XMDOMREC,XMP,XMRVAL) ; Check validation number
 L +^DIC(4.2,XMINST,0):0 E  S XMSG="550 Domain file locked, try later" X XMSEN Q
 S XMRVAL=$P($P(XMP,"<",2),">")
 D VALCHK(.XMDOMREC,XMRVAL)
 I '$D(XMRVAL) L -^DIC(4.2,XMINST,0) Q
 S XMRVAL=$R(8000000)+1000000 ; generate new validation number
 ;set val. num in return message, set new Val. num field
 S $P(XMDOMREC,U,18)=XMRVAL
 S ^DIC(4.2,XMINST,0)=XMDOMREC
 Q
VALCHK(XMDOMREC,XMRVAL) ; Check the validation number
 Q:XMRVAL=$P(XMDOMREC,U,15)  ; 15=current number; 18=new number
 I XMRVAL=$P(XMDOMREC,U,18) S $P(XMDOMREC,U,15)=$P(XMDOMREC,U,18) Q
 K XMRVAL
 N XMPARM,XMINSTR
 S XMINSTR("FROM")=.5
 S XMPARM(1)=XMHELO("XMP")
 D TASKBULL^XMXBULL(.5,"XMVALBAD",.XMPARM,"","",.XMINSTR)
 S XMSG="550 Bad validation number" X XMSEN
 Q
DOMAIN(XMDOMAIN) ;Domain name of sender acceptable ?
 N DIC,X,Y
 S X=XMDOMAIN,DIC="^DIC(4.2,",DIC(0)="FMOZ"
 F  D ^DIC Q:Y>0!(X'[".")  S X=$P(X,".",2,99)
 Q:Y>0 Y
 ;Add new Domain
 N A,XMINSTR
 S X=$$UP^XLFSTR(X)  ; X is the last '.' piece of XMDOMAIN
 I '$O(^DIC(4.2996,"B",X,0)) D
 . K DA,DD,DO
 . S DIC="^DIC(4.2996,"
 . S DIC("DR")="1///AUTOMATIC-XMR0B"
 . D FILE^DICN
 K DA,DD,DO
 S DIC="^DIC(4.2,"
 S DIC("DR")="1///C"_$S(^XMB("NETNAME")="FORUM.VA.GOV":"",1:";2///FORUM.VA.GOV")
 D FILE^DICN
 S ^DIC(4.2,+Y,1,0)="^4.21^1^1"
 S ^DIC(4.2,+Y,1,1,0)="AUTO^^^OTHER",^(1,0)="^^1^1^"_DT,^(1,0)="X Q"
 S ^DIC(4.2,+Y,1,"NOTES",0)="^^1^1^"_DT,^(1,0)="Auto-Created-XMR0B"
 S XMINSTR("FROM")=.5
 S A(1)="An incoming transmission from this previously undefined"
 S A(2)="domain ("_XMDOMAIN_") caused this new domain"
 S A(3)="("_$P(Y,U,2)_") to be created"
 S A(4)="",A(5)="to limit the number of entries that are created."
 S A(5)="The Internet Suffix is used for this purpose."
 S A(6)="Statistics are then collected for that level of activity."
 D SENDMSG^XMXSEND(.5,"New Domain created: "_$P(Y,U,2),"A","G.POSTMASTER",.XMINSTR)
 Q $P(Y,U,1,2)
VALSET(XMINST,XMRVAL) ;check validation number
 ;if new val. num. exist, then set val. num. to it and set to null
 Q:'$G(XMRVAL)
 N XMDOMREC
 S XMDOMREC=$G(^DIC(4.2,XMINST,0))
 S $P(XMDOMREC,U,15)=XMRVAL
 S $P(XMDOMREC,U,18)=""
 S ^DIC(4.2,XMINST,0)=XMDOMREC
 L -^DIC(4.2,XMINST,0)
 K XMRVAL
 Q
MAIL ;START
 N XMD
 S XMP=$P(XMP,":",2,999)
 S XMP=$$SCRUB^XMR1(XMP)
 I $E(XMP,1)'="<"!($E(XMP,$L(XMP))'=">") S XMSG="501 Invalid reverse-path specification" X XMSEN Q
 I $$REJ(XMP) S XMSG="502 No message receipt authorization." X XMSEN Q
 K XMNVFROM,XMINSTR,XMREMID,XMRXMZ,XMZ,XMZFDA,XMZIENS,^TMP("XMY",$J),^TMP("XMY0",$J)
 S XMINSTR("FWD BY")=""   ; We're not sure who sent/forwarded it
 S XMINSTR("ADDR FLAGS")="R"
 K:$D(XMERR) XMERR K:$D(^TMP("XMERR",$J)) ^TMP("XMERR",$J)
 D CRE8XMZ^XMXSEND($$EZBLD^DIALOG(34012),.XMZ)
 I $D(XMERR) D  Q
 . S XMSG="555 "_^TMP("XMERR",$J,1,"TEXT",1)
 . K XMERR,^TMP("XMERR",$J)
 . X XMSEN
 S XMZIENS=XMZ_","
 S (XMNVFROM,XMZFDA(3.9,XMZIENS,1),XMZFDA(3.9,XMZIENS,41))=XMP  ; mail from
 S XMSTATE="^RCPT^DATA"
 S (XMD,XMZFDA(3.9,XMZIENS,1.4))=$$NOW^XLFDT() ; Message date default
 S $P(^XMB(3.9,XMZ,0),U,3)=XMD
 D PUTMSG^XMXMSGS2(.5,.95,"ARRIVING",XMZ)
 S XMSG="250 OK Message-ID:"_XMZ_"@"_^XMB("NETNAME") X XMSEN Q:ER
 S XMD=$$INDT^XMXUTIL1(XMD)
 I $G(XMCHAN)="" S XMCHAN="Turn Around"
 S X=XMCHAN,X=$S(X'?.N:X,$D(^DIC(3.4,X,0)):$P(^(0),U),1:"")
 ;DON'T CHANGE ORDER OF .001 & .002 LINES !
 S ^XMB(3.9,XMZ,2,.001,0)="Received: "_$S($L($G(XMHELO("XMP"))):"from "_XMHELO("XMP")_" by "_^XMB("NETNAME")_" (MailMan/"_$P($T(XMR0B+1),";",3)_" "_X_")",1:"(BATCH)")_" id "_XMZ_" ; "_XMD
 Q
REJ(XMNVFROM) ; Check Senders rejected list
 Q:'$O(^XMBX(4.501,0)) 0
 N XMNO,XMREJECT,XMIEN,XMREC
 S XMNVFROM=$$UP^XLFSTR(XMNVFROM)
 S XMNO="",XMREJECT=0
 F  S XMNO=$O(^XMBX(4.501,"B",XMNO)) Q:XMNO=""  D  Q:XMREJECT
 . Q:XMNVFROM'[$$UP^XLFSTR(XMNO)
 . S XMIEN=$O(^XMBX(4.501,"B",XMNO,0)) Q:'XMIEN
 . S XMREC=$G(^XMBX(4.501,XMIEN,0)) Q:XMREC=""
 . I XMNVFROM[$$UP^XLFSTR($P(XMREC,U,1)),'$P(XMREC,U,2) S XMREJECT=1
 Q XMREJECT
 ;
 ;#34012 = * No Subject *
