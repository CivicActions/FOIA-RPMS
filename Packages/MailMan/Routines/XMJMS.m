XMJMS ;ISC-SF/GMB-Interactive Send ;06/15/99  06:41
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces ^XMA2,^XMA20 (ISC-WASH/CAP/THM)
 ; Entry points used by MailMan options (not covered by DBIA):
 ; PAKMAN  XMPACK - Load PackMan message
 ; SEND    XMSEND - Send a message
 ; *** BLOB^XMA2B (Imaging package) calls entry BLOB
SEND ;
 N XMSUBJ,XMZ,XMABORT
 S XMABORT=0
 D INIT(XMDUZ,.XMABORT) Q:XMABORT
 D SUBJ(.XMSUBJ,.XMABORT) Q:XMABORT
 D CRE8XMZ^XMXSEND(XMSUBJ,.XMZ,1) I XMZ<1 S XMABORT=1 Q
 D:'$G(XMPAKMAN) EDITON(XMDUZ,XMZ,"",.XMBLOB)
 D PROCESS(XMDUZ,XMZ,XMSUBJ,.XMABORT)
 D:XMABORT=DTIME HALT("sending")
 D:'$G(XMPAKMAN) EDITOFF(XMDUZ)
 D:XMABORT KILLMSG^XMXUTIL(XMZ)
 Q
PAKMAN ;
 N XMPAKMAN,XMLOAD,X,XMR
 S (XMPAKMAN,XMLOAD)=1
 D SEND
 Q
BLOB ;
 N XMBLOB,XMOUT
 S XMBLOB=1
 D SEND
 Q
INIT(XMDUZ,XMABORT) ; Clean up and initialize for Sending a message
 D CHECK^XMVVITAE
 I XMDUZ'=DUZ,'$$WPRIV^XMXSEC D  Q  ; Replaces SUR^XMA22
 . S XMABORT=1
 . D SHOW^XMJERR
 D CHKLOCK(XMDUZ,.XMABORT)
 Q
CHKLOCK(XMDUZ,XMABORT) ;
 I 'XMV("NOSEND") D
 . ; We need to do this because the menu system releases all locks upon
 . ; exit from an option.
 . L +^XMB(3.7,"AD",XMDUZ):0 E  S XMV("NOSEND")=1
 I XMV("NOSEND") D  Q  ; Replaces TWO^XMA1E
 . W !,"This session is concurrent with another.  You may not do this."
 . S XMABORT=1
 Q
PROCESS(XMDUZ,XMZ,XMSUBJ,XMABORT) ;
 N XMINSTR,XMRESTR
 I '$G(XMPAKMAN) D BODY(XMDUZ,XMZ,XMSUBJ,.XMRESTR,.XMABORT) Q:XMABORT
 I $G(XMBLOB) D ADD^XMA2B K XMBLOB I $D(XMOUT) S XMABORT=1 Q
 I $G(XMPAKMAN) D ^XMP
 D INIT^XMXADDR
 D TOWHOM^XMJMT(XMDUZ,"Send",.XMINSTR,.XMRESTR,.XMABORT)
 I $G(XMPAKMAN) D PSECURE^XMPSEC(XMZ,.XMABORT)
 D:'XMABORT SENDMSG^XMJMSO(XMDUZ,XMZ,XMSUBJ,.XMINSTR,.XMRESTR,.XMABORT)
 D CLEANUP^XMXADDR
 Q
SUBJ(XMSUBJ,XMABORT) ; ask subject
 N DIR,X,Y
 S DIR("A")=$$EZBLD^DIALOG(34002)
 S DIR(0)="FOU^3:65"
 S:$D(XMSUBJ) DIR("B")=XMSUBJ
 S DIR("?")="Answer must be 3-65 characters in length."
 S DIR("??")="^D QSUBJ^XMJMS"
 F  D  Q:Y'=""!XMABORT
 . D ^DIR
 . I $D(DTOUT)!$D(DUOUT) S XMABORT=1 Q
 . S Y=$$STRIP^XMXUTIL1(Y)
 . S Y=$$MAXBLANK^XMXUTIL1(Y)
 . I Y="" S Y=$$EZBLD^DIALOG(34012)
 . I $L(Y)'<3,$L(Y)'>65 Q
 . W !,"Answer must be 3-65 characters in length."
 . S Y=""
 Q:XMABORT
 S XMSUBJ=Y
 S:XMSUBJ[U XMSUBJ=$$ENCODEUP^XMXUTIL1(XMSUBJ)
 Q
QSUBJ ;
 W !,"This is the subject of the message, shown whenever the message is displayed."
 W !,"Leading and trailing blanks are deleted."
 W !,"Any sequence of 3 or more blanks is reduced to 2 blanks."
 Q:$D(XMSUBJ)
 W !!,"If you want to send a message with no subject, just press RETURN."
 Q
BODY(XMDUZ,XMZ,DIWESUB,XMRESTR,XMABORT) ; Replaces ENT1^XMA2
 N DIC
 ;W !,"You may ",$S($D(^XMB(3.9,XMZ,2,0)):"edit",1:"enter")," the ",$S($G(XMPAKMAN):"description of the PackMan",1:"text of the")," message..."
 W !,"You may ",$S($D(^XMB(3.9,XMZ,2,0)):"edit",1:"enter")," the text of the message..."
 S DWPK=1,DWLW=75,DIC="^XMB(3.9,"_XMZ_",2,"
 D EN^DIWE
 I '$O(^XMB(3.9,XMZ,2,0)) S XMABORT=1 Q
 D CHKLINES^XMXSEC1(XMDUZ,XMZ,.XMRESTR)
 Q
EDITON(XMDUZ,XMZ,XMZR,XMBLOB) ; Note that msg is being edited.  Replaces D^XMA0A
 N XMFDA,XMIENS
 S XMIENS=XMDUZ_","
 S XMFDA(3.7,XMIENS,5)=XMZ          ; current message/response
 S XMFDA(3.7,XMIENS,7)=$G(XMZR)     ; original message for response
 S XMFDA(3.7,XMIENS,7.5)=$G(XMBLOB) ; 0/1=BLOB yes/no
 D FILE^DIE("","XMFDA")
 Q
EDITOFF(XMDUZ) ; Note that msg is no longer being edited.
 N XMFDA,XMIENS
 S XMIENS=XMDUZ_","
 S XMFDA(3.7,XMIENS,5)="@"
 S XMFDA(3.7,XMIENS,7)="@"
 S XMFDA(3.7,XMIENS,7.5)="@"
 D FILE^DIE("","XMFDA")
 Q
HALT(XMACTION) ;
 W *7,!!,"You have timed out while ",XMACTION," a message."
 W !,"You can resume when you log back on and re-enter MailMan."
 W !,"Do it today, or your text may be purged this evening."
 G H^XUS
RECOVER(XMDUZ,XMZ,XMBLOB) ;
 N XMSUBJ,XMABORT
 S XMSUBJ=$P(^XMB(3.9,XMZ,0),U,1)
 S:XMSUBJ["~U~" XMSUBJ=$$DECODEUP^XMXUTIL1(XMSUBJ)
 W *7,!!,"You have an unsent message in your buffer."
 W !,"Subj: ",XMSUBJ
 W !,"You may have lost some of the text."
 W !,"You must re-enter recipients and any special handling instructions."
 S XMABORT=0
 D INIT(XMDUZ,.XMABORT)
 I XMABORT D HALT("recovering")
 D PROCESS(XMDUZ,XMZ,XMSUBJ,.XMABORT)
 I XMABORT=DTIME D HALT("sending")
 D EDITOFF(XMDUZ)
 D:XMABORT KILLMSG^XMXUTIL(XMZ)
 Q
 ;
 ;#34002 = Subject
 ;#34012 = * No Subject *
