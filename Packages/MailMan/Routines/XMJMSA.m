XMJMSA ;ISC-SF/GMB-Anonymous User Suggestion Message ;02/22/99  10:24
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces ^XMANON (ISC-WASH/CAP)
 ; Entry points used by MailMan options (not covered by DBIA):
 ; SEND    XMSUGGESTION
 ; This routine allows a user to send an anonymous message to the
 ; SUGGESTION BOX basket of SHARED,MAIL.  If this basket doesn't exist,
 ; it will be created.
 ;
 ; MailMan carefully fails to record the actual identity of the sender.
 ;
 ; To use it, put the XMSUGGESTION option onto the appropriate menu.
 ; To stop a particular person from using it, put a 'Reverse/negative
 ; Lock' onto the XMSUGGESTION option and assign that key to the
 ; person you do not want to be able to use it.
SEND ;
 N XMSUBJ,XMABORT,DIR,Y,X,XMFINISH
 S XMABORT=0
 ;D WARNING(.XMABORT) Q:XMABORT
 S XMSUBJ="Suggestion"
 D ES Q:XMABORT  ; Edit the subject
 K ^TMP("XM",$J)
 D ET Q:XMABORT  ; Edit the text
 S XMFINISH=0
 F  D  Q:XMFINISH!XMABORT
 . S DIR(0)="SAM^ES:Edit Subject;ET:Edit Text;T:Transmit now"
 . S DIR("A")="Select Message option:  "
 . S DIR("B")="Transmit now"
 . D ^DIR I $D(DIRUT) S XMABORT=1 Q
 . D @Y
 K ^TMP("XM",$J)
 Q
ES ;
 D SUBJ^XMJMS(.XMSUBJ,.XMABORT)
 Q
ET ; Edit text
 N DIC
 S DWPK=1,DWLW=75,DIC="^TMP(""XM"",$J,"
 S DIWESUB=XMSUBJ
 D EN^DIWE
 I '$O(^TMP("XM",$J,0)) S XMABORT=1 Q
 Q
T ; Transmit the message
 N XMDUZ,DUZ,XMINSTR,XMZ
 S XMFINISH=1,(XMDUZ,DUZ)=.6
 S XMINSTR("FROM")="Anonymous"
 S XMINSTR("SHARE DATE")="3991231"
 S XMINSTR("SHARE BSKT")="SUGGESTION BOX"
 D CRE8XMZ^XMXSEND(XMSUBJ,.XMZ,1) Q:XMZ<1
 W "  Sending [",XMZ,"]... "
 D MOVEBODY^XMXSEND(XMZ,"^TMP(""XM"",$J)")
 D ADDRNSND^XMXSEND(XMDUZ,XMZ,XMDUZ,.XMINSTR)
 W !,"  Sent"
 Q
WARNING(XMABORT) ;
 W @IOF
 W !,$$CJ^XLFSTR("* * * * *  ATTENTION  * * * * *",79)
 W !!,$$CJ^XLFSTR("Anonymous messages may or may not be totally anonymous.",79)
 W !!,$$CJ^XLFSTR("Please check with your local IRM",79)
 W !,$$CJ^XLFSTR("to find out if your facility has methods in place to identify you.",79),!!
 D PAGE^XMXUTIL(.XMABORT)
 Q
