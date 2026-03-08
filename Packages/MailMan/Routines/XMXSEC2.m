XMXSEC2 ;ISC-SF/GMB-Message security and restrictions ;04/16/99  10:31
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; All entry points covered by DBIA 2733.
EDIT(XMDUZ,XMZ,XMZREC) ; May the user edit the message? (1=may, 0=may not)
 I '$$ORIGIN8R^XMXSEC(XMDUZ,.XMZREC) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="You can't edit this message, because you didn't send it."
 E  I $P($G(^XMB(3.9,XMZ,1,0)),U,4)>1!($P(XMZREC,U,2)'=$O(^XMB(3.9,XMZ,1,"C",0))) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="You can't edit this message, because you have already sent it to someone else."
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",2)="You may toggle the 'information only' switch, if you wish."
 Q 1
OPTEDIT(XMINSTR,XMOPT) ; We know the user may edit the message.
 ; Now, what, exactly, may be edited?
 S XMOPT("C")=$S(XMINSTR("FLAGS")["C":"UnConfidential (surrogate may read)",1:"Confidential (surrogate can't read)")
 S XMOPT("D")=$S($D(XMINSTR("RCPT BSKT")):"Delivery basket remove",1:"Delivery basket set")
 S XMOPT("P")=$S($G(XMINSTR("FLAGS"))["P":"Normal delivery",1:"Priority delivery")
 S XMOPT("R")=$S($G(XMINSTR("FLAGS"))["R":"No Confirm receipt",1:"Confirm receipt")
 S XMOPT("S")="Edit Subject"
 S XMOPT("T")="Edit Text"
 S XMOPT("V")=$S($G(XMINSTR("VAPOR")):"Vaporize date remove",1:"Vaporize date set")
 S XMOPT("X")=$S(XMINSTR("FLAGS")["X":"UnClose (forward allowed)",1:"Closed (no forward allowed)")
 I $D(^TMP("XMY",$J,.6)) D
 . S XMOPT("X","?")="Messages addressed to SHARED,MAIL may not be 'Closed'."
 . S XMOPT("C","?")="Messages addressed to SHARED,MAIL may not be 'Confidential'."
 Q
OPTMSG(XMDUZ,XMK,XMZ,XMIM,XMINSTR,XMIU,XMOPT) ; The user has access to the message.  Now what may the user do with it?
 ; in:
 ; XMDUZ  = the user
 ; XMK    = basket IEN if message is in a basket
 ;        = 0 otherwise
 ; XMZ    = the message IEN
 ; The following are set by INMSG1 and INMSG2^XMXUTIL2
 ; XMIM("FROM")  = piece 2 of the message's zero node
 ; XMINSTR       = special instructions
 ; XMIU("ORIGN8")=
 ; XMIU("IEN")   = the user's IEN in the message's recipient multiple
 ; out:
 ; XMOPT(<opt>) Possible options
 ; '$D(XMOPT(<opt>,"?")) User may do these things.
 ;  $D(XMOPT(<opt>,"?")) User may NOT do these things.
 N XMSECPAK ;,XMK
 ;S XMK=+$O(^XMB(3.7,"M",XMZ,XMDUZ,0))
 I $D(^XMB(3.9,XMZ,"K")),XMINSTR("TYPE")["X"!(XMINSTR("TYPE")["K") S XMSECPAK=1 ; secure packman
 E  S XMSECPAK=0
 K XMOPT
 S XMOPT("A")="Answer"
 S XMOPT("AA")="Access Attachments"
 S XMOPT("B")="Backup"
 S XMOPT("C")="Copy"
 S XMOPT("D")="Delete"
 S XMOPT("E")="Edit"
 S XMOPT("F")="Forward"
 S XMOPT("I")="Ignore"
 S XMOPT("IN")=$S($G(XMINSTR("FLAGS"))["I":"Un Info only",1:"Info only")
 S XMOPT("H")="Headerless Print"
 S XMOPT("K")=$S($G(XMINSTR("FLAGS"))["K":"Un Priority replies",1:"Priority replies")
 S XMOPT("L")="Later"
 S XMOPT("N")=$S($G(XMINSTR("FLAGS"))["N":"Un New",1:"New")
 S XMOPT("P")="Print"
 S XMOPT("Q")="Query"
 S XMOPT("QR")="Query Recipients"
 S XMOPT("QD")="Query Detailed"
 S XMOPT("QN")="Query Network"
 S XMOPT("R")="Reply"
 S XMOPT("S")="Save"
 S XMOPT("T")="Terminate"
 S XMOPT("V")="Vaporize date edit"
 S XMOPT("W")="Write"
 S XMOPT("X")=$S($G(XMINSTR("TYPE"))["K":"Xtract KIDS",$G(XMINSTR("TYPE"))["X":"Xtract PackMan",1:"Xtract")
 I XMDUZ=DUZ!($G(XMV("PRIV"))["W") D
 . D OPTW(XMDUZ,XMZ,XMIM("FROM"),XMIU("ORIGN8"),XMSECPAK,.XMINSTR)
 E  D
 . D OPTWNO(XMIU("ORIGN8"))
 D OPTR(XMDUZ,XMK,XMZ,.XMIU,XMSECPAK,.XMINSTR)
 I XMDUZ=.6 D DOSHARE(XMDUZ,XMK,XMIU("ORIGN8"),.XMINSTR) Q
 I XMDUZ=.5,XMK>999 D DOPOST
 Q
OPTW(XMDUZ,XMZ,XMFROM,XMORIGN8,XMSECPAK,XMINSTR) ; User must be self or have 'write' privilege as surrogate.
 I XMINSTR("FLAGS")["X",'XMORIGN8 S XMOPT("C","?")="You may not Copy a closed message unless you sent it."
 I $D(^XMB(3.9,XMZ,"K")) D
 . I XMSECPAK S XMOPT("C","?")="You may not Copy a secure KIDS or PackMan message."
 . E  D
 . . S XMOPT("A","?")="You may not Answer a scrambled message.  Use Reply."
 . . S XMOPT("C","?")="You may not Copy a scrambled message."
 I XMINSTR("TYPE")["X"!(XMINSTR("TYPE")["K") S XMOPT("A","?")="You may not Answer a KIDS or PackMan message."
 I "^^"[$G(^XMB(3.7,XMDUZ,"NS1")) D
 . S XMOPT("A","?",1)="You must have a NETWORK SIGNATURE to Answer messages."
 . S XMOPT("A","?")="Create a NETWORK SIGNATURE under 'Personal Preferences|User Options Edit'."
 I 'XMORIGN8 D
 . S XMOPT("IN","?")="Only the sender may toggle 'Information only'."
 . S XMOPT("E","?")="You can't edit this message, because you didn't send it."
 E  I $P($G(^XMB(3.9,XMZ,1,0)),U,4)>1!(XMFROM'=$O(^XMB(3.9,XMZ,1,"C",0))) D
 . S XMOPT("E","?",1)="You can't edit this message, because you have already sent it to someone else."
 . S XMOPT("E","?")="You may toggle the 'information only' switch, if you wish."
 Q
OPTWNO(XMORIGN8) ; Surrogate does not have 'write' privilege.
 S XMOPT("A","?")="You need 'write' privilege to Answer a message."
 S XMOPT("C","?")="You need 'write' privilege to Copy a message."
 S XMOPT("E","?")="You need 'write' privilege to Edit a message."
 I XMORIGN8 S XMOPT("IN","?")="You need 'write' privilege to toggle 'Information only'."
 E  S XMOPT("IN","?")="Only the sender may toggle 'Information only'."
 S XMOPT("W","?")="You need 'write' privilege to Write (send) a message."
 Q
OPTR(XMDUZ,XMK,XMZ,XMIU,XMSECPAK,XMINSTR) ; User must be self or have 'read' privilege as surrogate.
 S:'$O(^XMB(3.9,XMZ,2005,0)) XMOPT("AA","?")="This message has no Attachments."
 I 'XMK D
 . S XMOPT("D","?")="This message has already been deleted.  It's not in a basket."
 . S XMOPT("V","?")="This message has already vaporized.  It's not in a basket."
 I XMINSTR("FLAGS")'["P" S XMOPT("K","?")="The message must be 'priority' in order to toggle 'Priority replies'."
 I XMINSTR("FLAGS")["X",'XMIU("ORIGN8") S XMOPT("F","?")="Only the sender may forward a 'closed' message."
 I XMSECPAK D
 . S XMOPT("P","?")="You may not Print a secure KIDS or PackMan message."
 . S XMOPT("H","?")=XMOPT("P","?")
 . S XMOPT("R","?")="You may not Reply to a secure KIDS or PackMan message."
 E  I 'XMIU("ORIGN8"),XMINSTR("FLAGS")["I" S XMOPT("R","?")="Only the sender may Reply to an 'Information only' message."
 E  I 'XMIU("ORIGN8"),$P($G(^XMB(3.9,XMZ,1,XMIU("IEN"),"T")),U,1)="I" D
 . S XMOPT("R","?",1)=$S(XMDUZ=DUZ:"You are",1:XMV("NAME")_" is")_" an 'information only' recipient"
 . S XMOPT("R","?")="of this message, and may not Reply."
 I XMINSTR("TYPE")["X"!(XMINSTR("TYPE")["K") D
 . S:'$D(^XUSEC("XUPROGMODE",DUZ)) XMOPT("X","?")="You must have the XUPROGMODE key to extract KIDS or PackMan messages."
 E  S XMOPT("X","?")="This message is neither KIDS nor PackMan."
 Q
DOSHARE(XMDUZ,XMK,XMORIGN8,XMINSTR) ;
 S XMOPT("A","?")="SHARED,MAIL may not Answer a message."
 S XMOPT("AA","?")="SHARED,MAIL may not Access Attachments."
 S XMOPT("C","?")="SHARED,MAIL may not Copy a message."
 I XMK,$S(XMORIGN8:0,$D(^XUSEC("XMMGR",DUZ)):0,$D(^XMB(3.7,"AB",DUZ,.5)):0,1:1) D
 . S XMOPT("D","?",1)="You must be the sender, hold the XMMGR key, or be a POSTMASTER surrogate"
 . S XMOPT("D","?")="to Delete a message in SHARED,MAIL."
 . S XMOPT("S","?",1)=XMOPT("D","?",1)
 . S XMOPT("S","?")="to Save a message in SHARED,MAIL."
 . S XMOPT("T","?",1)=XMOPT("D","?",1)
 . S XMOPT("T","?")="to Terminate a message in SHARED,MAIL."
 . S XMOPT("V","?",1)=XMOPT("D","?",1)
 . S XMOPT("V","?")="to edit a message's Vaporize date in SHARED,MAIL."
 S XMOPT("E","?")="SHARED,MAIL may not Edit a message."
 S:'XMORIGN8 XMOPT("F","?")="Only the sender may forward a message from SHARED,MAIL."
 S XMOPT("IN","?")="SHARED,MAIL may not toggle 'Information only'."
 S XMOPT("K","?")="SHARED,MAIL may not toggle 'Priority replies'."
 S XMOPT("L","?")="SHARED,MAIL may not 'Later' a message."
 S XMOPT("N","?")="SHARED,MAIL may not 'New' a message."
 S XMOPT("W","?")="SHARED,MAIL may not Write (send) a new message."
 S XMOPT("X","?")="SHARED,MAIL may not extract KIDS or PackMan messages."
 Q
DOPOST ;
 S XMOPT("A","?")="You may not do this with messages in the transmit queues."
 S XMOPT("AA","?")=XMOPT("A","?")
 S XMOPT("B","?")=XMOPT("A","?")
 S XMOPT("C","?")=XMOPT("A","?")
 S XMOPT("E","?")=XMOPT("A","?")
 S XMOPT("F","?")=XMOPT("A","?")
 S XMOPT("IN","?")=XMOPT("A","?")
 S XMOPT("H","?")=XMOPT("A","?")
 S XMOPT("K","?")=XMOPT("A","?")
 S XMOPT("L","?")=XMOPT("A","?")
 S XMOPT("N","?")=XMOPT("A","?")
 S XMOPT("P","?")=XMOPT("A","?")
 S XMOPT("R","?")=XMOPT("A","?")
 S XMOPT("S","?")=XMOPT("A","?")
 S XMOPT("T","?")=XMOPT("A","?")
 S XMOPT("V","?")=XMOPT("A","?")
 S XMOPT("W","?")=XMOPT("A","?")
 S XMOPT("X","?")=XMOPT("A","?")
 Q
