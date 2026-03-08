XMXSEC1 ;ISC-SF/GMB-Message security and restrictions (cont'd) ;06/07/99  10:05
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; All entry points covered by DBIA 2732.
GETRESTR(XMDUZ,XMZ,XMZREC,XMINSTR,XMRESTR) ;
 ; If a message is closed, it may not be forwarded to SHARED,MAIL, even by the sender
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 S:"^Y^y^"[(U_$P(XMZREC,U,9)_U) XMRESTR("FLAGS")=$G(XMRESTR("FLAGS"))_"X"
 ; If a message is confidential, it may not be forwarded to SHARED,MAIL
 S:"^Y^y^"[(U_$P(XMZREC,U,11)_U) XMRESTR("FLAGS")=$G(XMRESTR("FLAGS"))_"C"
 Q:$G(XMINSTR("ADDR FLAGS"))["R"
 ; If a message is priority, it may not be forwarded to groups unless
 ; the user is the originator or possesses the proper security key.
 I $P(XMZREC,U,7)["P",'$$ORIGIN8R^XMXSEC(XMDUZ,XMZREC),'$D(^XUSEC("XM GROUP PRIORITY",XMDUZ)) S XMRESTR("NOFPG")=""
 ; If a message is more lines than the limit, then it may not be sent/forwarded to a remote site
 D CHKLINES(XMDUZ,XMZ,.XMRESTR)
 Q
CHKLINES(XMDUZ,XMZ,XMRESTR) ; Replaces NO^XMA21A
 N XMLIMIT
 Q:$D(^XUSEC("XMMGR",XMDUZ))
 S XMLIMIT=$P($G(^XMB(1,1,"NETWORK-LIMIT")),U)
 I XMLIMIT,$P($G(^XMB(3.9,XMZ,2,0)),U,4)>XMLIMIT S XMRESTR("NONET")=XMLIMIT
 Q
CHKMSG(XMDUZ,XMK,XMKZ,XMZ,XMZREC) ; Is the message where the calling routine says it is,
 ; and is the user authorized to access it?
 I $G(XMK) D  Q
 . S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ,""))
 . I 'XMZ S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Message "_XMKZ_" not found in basket "_XMK_"." Q
 . S XMZREC=$G(^XMB(3.9,XMZ,0))
 . I XMZREC="" S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Message "_XMZ_" not found (message "_XMKZ_" in basket "_XMK_")."
 S XMZ=XMKZ
 S XMZREC=$G(^XMB(3.9,XMZ,0))
 I XMZREC="" S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Message "_XMZ_" not found." Q
 Q:'$$ACCESS^XMXSEC(XMDUZ,XMZ,XMZREC)
 S XMK=+$O(^XMB(3.7,"M",XMZ,XMDUZ,""))
 Q:'XMK
 S XMKZ=$P($G(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)),U,2)
 I 'XMKZ S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="The 'M' xref says message "_XMZ_" is in basket "_XMK_", but it isn't." Q
 Q
PAKMAN(XMZ,XMZREC) ; Returns 1 if this is a packman msg; 0 if not.
 ; Unfortunately, there isn't always an "X" in piece 7 of the zero node,
 ; so we must go check out the first line of text.
 N XMTYPE
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 S XMTYPE=$P(XMZREC,U,7)
 I "P"[XMTYPE D  Q XMTYPE  ; "P" means priority, and it exists along with
 . ; message type in piece 7 in all MailMan versions thru 7.*
 . N XMREC,XMI
 . S XMTYPE=0
 . S XMI=$O(^XMB(3.9,XMZ,2,.999999)) I 'XMI Q
 . S XMREC=^XMB(3.9,XMZ,2,XMI,0)
 . Q:$E(XMREC,1)'="$"
 . I XMREC?1"$TXT Created by".E1" at ".E1" on ".E S XMTYPE=1 Q  ; Unsecured PackMan
 . I XMREC?1"$TXT PACKMAN BACKUP".E S XMTYPE=1 Q  ; PackMan Backup
 . I XMREC?1"$TXT ^Created by".E1" at ".E1" on ".E S XMTYPE=1 Q  ; Secured PackMan
 Q:XMTYPE="K"!(XMTYPE="X") 1  ; PackMan message (KIDS or regular)
 Q 0
OPTGRP(XMDUZ,XMK,XMOPT) ; What may the user do at the basket/message group level?
 I XMK D
 . I XMDUZ=.5,XMK>999 D OPTPOST(.XMOPT) Q
 . D OPTUSER1(XMDUZ,.XMOPT)
 . D OPTUSER2(XMK,.XMOPT)
 E  D
 . D OPTUSER1(XMDUZ,.XMOPT)
 Q
OPTUSER1(XMDUZ,XMOPT) ;
 S XMOPT("D")="Delete messages"
 S XMOPT("F")="Forward messages"
 S XMOPT("FI")="Filter messages"
 S XMOPT("H")="Headerless Print messages"
 S XMOPT("L")="Later messages"
 S XMOPT("P")="Print messages"
 S XMOPT("S")="Save messages to another basket"
 S XMOPT("T")="Terminate messages"
 S:'$D(^XMB(3.7,XMDUZ,15,"AF")) XMOPT("FI","?")=$S(XMDUZ=DUZ:"You have",1:XMV("NAME")_" has")_" no message filters defined."
 Q:XMDUZ'=.6!$$ZPOSTPRV^XMXSEC()
 S XMOPT("D","?",1)="You must hold the XMMGR key or be a POSTMASTER surrogate"
 S XMOPT("D","?")="to Delete groups of messages in SHARED,MAIL."
 S XMOPT("F","?",1)=XMOPT("D","?",1)
 S XMOPT("F","?")="to Forward groups of messages in SHARED,MAIL."
 S XMOPT("FI","?",1)=XMOPT("D","?",1)
 S XMOPT("FI","?")="to Filter groups of messages in SHARED,MAIL."
 S XMOPT("L","?",1)=XMOPT("D","?",1)
 S XMOPT("L","?")="to Later groups of messages in SHARED,MAIL."
 S XMOPT("S","?",1)=XMOPT("D","?",1)
 S XMOPT("S","?")="to Save groups of messages to another basket in SHARED,MAIL."
 S XMOPT("T","?",1)=XMOPT("D","?",1)
 S XMOPT("T","?")="to Terminate groups of messages in SHARED,MAIL."
 Q
OPTUSER2(XMK,XMOPT) ;
 S XMOPT("C")="Change the name of this basket"
 S XMOPT("N")="New message list"
 S XMOPT("Q")="Query (search for) messages in this basket"
 S XMOPT("R")="Resequence messages"
 S:XMK'>1 XMOPT("C","?")="The name of "_$S(XMK=1:"the IN",XMK=.5:"the WASTE",1:"this")_" basket may not be changed."
 Q:XMDUZ'=.6!$$ZPOSTPRV^XMXSEC()
 S XMOPT("C","?",1)="You must hold the XMMGR key or be a POSTMASTER surrogate"
 S XMOPT("C","?")="to Change the name of a basket in SHARED,MAIL."
 Q
OPTPOST(XMOPT) ;
 S XMOPT("D")="Delete messages"
 S XMOPT("R")="Resequence messages"
 S XMOPT("X")="Xmit Priority toggle"
 Q
COPYAMT(XMZ,XMWHICH) ; Checks total number of lines to be copied and total number of responses to be copied.
 ; Function returns 1 if OK; 0 if not OK.
 ; XMWHICH string of which responses to copy (0=original msg).
 ;         Default = original msg and all responses.
 N XMLIMIT,XMRESPS,XMABORT
 S XMABORT=0
 S XMLIMIT=$$COPYLIMS
 S XMRESPS=+$P($G(^XMB(3.9,XMZ,3,0)),U,4)
 I XMRESPS=0 D TOOMANY(+$P($G(^XMB(3.9,XMZ,2,0)),U,4),$P(XMLIMIT,U,3),"lines",.XMABORT) Q 'XMABORT
 N I,J,XMRANGE,XMLINES
 S:'$D(XMWHICH) XMWHICH="0-"_XMRESPS
 S (XMRESPS,XMLINES)=0
 F I=1:1:$L(XMWHICH,",")-1 D
 . S XMRANGE=$P(XMWHICH,",",I)
 . F J=$P(XMRANGE,"-",1):1:$S(XMRANGE["-":$P(XMRANGE,"-",2),1:XMRANGE) D
 . . S XMRESPS=XMRESPS+1
 . . I J=0 S XMLINES=XMLINES+$P($G(^XMB(3.9,XMZ,2,0)),U,4) Q
 . . S XMLINES=XMLINES+$P($G(^XMB(3.9,+$G(^XMB(3.9,XMZ,3,J,0)),2,0)),U,4)
 D TOOMANY(XMLINES,$P(XMLIMIT,U,3),"lines",.XMABORT) Q:XMABORT 0
 D TOOMANY(XMRESPS,$P(XMLIMIT,U,2),"responses",.XMABORT) Q:XMABORT 0
 Q 1
TOOMANY(HOWMANY,XMLIMIT,XMNOUN,XMABORT) ;
 Q:HOWMANY'>XMLIMIT
 S XMABORT=1
 S XMERR=$G(XMERR)+1
 S ^TMP("XMERR",$J,XMERR,"TEXT",1)="You may not copy more than the site limit of "_XMLIMIT_" "_XMNOUN_"."
 Q
COPYLIMS() ; Function returns copy limits string.
 ; limits:  # recipients^# responses^# lines
 N I
 S XMLIMIT=$G(^XMB(1,1,.11))
 F I=1:1:3 I '$P(XMLIMIT,U,I) S $P(XMLIMIT,U,I)=$P("2999^99^3999",U,I)
 Q XMLIMIT
COPYRECP(XMZ) ; Checks total number of recipients to see if it's OK to list them in the copy text and send the copy to them, too.
 ; Function returns 1 if OK; 0 if not OK.
 N XMLIMIT
 S XMLIMIT=$$COPYLIMS
 Q:$P($G(^XMB(3.9,XMZ,1,0)),U,4)'>$P(XMLIMIT,U,1) 1
 S XMERR=$G(XMERR)+1
 S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Because this message has more than the site limit of "_$P(XMLIMIT,U,1)_" recipients,"
 S ^TMP("XMERR",$J,XMERR,"TEXT",2)="we will neither list them in the text of the copy,"
 S ^TMP("XMERR",$J,XMERR,"TEXT",3)="nor will we deliver the copy to them."
 Q 0
