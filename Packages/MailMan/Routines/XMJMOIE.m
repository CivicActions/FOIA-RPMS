XMJMOIE ;ISC-SF/GMB-Edit msg that user has sent to self ;04/29/99  12:43
 ;;7.1;MailMan;**50**;Jun 02, 1994
EDIT(XMDUZ,XMK,XMZ,XMSUBJ,XMINSTR,XMRESTR) ;
 N XMABORT
 S XMABORT=0
 F  D  Q:XMABORT
 . N DIR,Y,X
 . D SENDSET(.XMINSTR,.DIR)
 . D ^DIR I $D(DIRUT) S XMABORT=$S($D(DTOUT):DTIME,1:1) Q
 . D @Y
 Q
SENDSET(XMINSTR,DIR) ;
 S DIR(0)=""
 I $G(XMINSTR("FLAGS"))["C" S DIR(0)=DIR(0)_";C:UnConfidential (surrogate may read)"
 E                          S DIR(0)=DIR(0)_";C:Confidential (surrogate can't read)"
 I $D(XMINSTR("RCPT BSKT")) S DIR(0)=DIR(0)_";D:Delivery basket remove"
 E                          S DIR(0)=DIR(0)_";D:Delivery basket set"
 I $G(XMINSTR("FLAGS"))["I" S DIR(0)=DIR(0)_";I:UnInformation only (recipients may respond)"
 E                          S DIR(0)=DIR(0)_";I:Information only (recipients may not respond)"
 I $G(XMINSTR("FLAGS"))["P" S DIR(0)=DIR(0)_";P:Normal delivery"
 E                          S DIR(0)=DIR(0)_";P:Priority delivery"
 I $G(XMINSTR("FLAGS"))["R" S DIR(0)=DIR(0)_";R:No Confirm receipt"
 E                          S DIR(0)=DIR(0)_";R:Confirm receipt"
 S DIR(0)=DIR(0)_";S:Edit Subject"
 S DIR(0)=DIR(0)_";T:Edit Text"
 I $D(XMINSTR("VAPOR"))     S DIR(0)=DIR(0)_";V:Vaporize date remove"
 E                          S DIR(0)=DIR(0)_";V:Vaporize date set"
 I $G(XMINSTR("FLAGS"))["X" S DIR(0)=DIR(0)_";X:UnClose message (forward allowed)"
 E                          S DIR(0)=DIR(0)_";X:Closed message (no forward allowed)"
 S DIR("A")="Select Edit option:  "
 S DIR(0)="SAMO^"_$E(DIR(0),2,999)
 Q
C ; Confidential msg
 N XMMSG
 D CONFID^XMXEDIT(XMZ,.XMINSTR,.XMMSG)
 I $D(XMERR) D SHOW^XMJERR Q
 W !,XMMSG
 Q
D ; Delivery basket
 N XMMSG
 I $D(XMINSTR("RCPT BSKT")) D  Q
 . D DELIVER^XMXEDIT(XMZ,"@",.XMINSTR,.XMMSG)
 . W !,XMMSG
 D D^XMJMSO
 Q:'$D(XMINSTR("RCPT BSKT"))
 D DELIVER^XMXEDIT(XMZ,XMINSTR("RCPT BSKT"),.XMINSTR,.XMMSG)
 Q
I ; Information only msg
 N XMMSG
 D INFO^XMXEDIT(XMZ,.XMINSTR,.XMMSG)
 W !,XMMSG
 Q
P ; Priority msg
 N XMMSG
 D PRIORITY^XMXEDIT(XMZ,.XMINSTR,.XMMSG)
 W !,XMMSG
 Q
R ; Confirm receipt of msg
 N XMMSG
 D CONFIRM^XMXEDIT(XMZ,.XMINSTR,.XMMSG)
 W !,XMMSG
 Q
S ; Edit Subject
 D ES^XMJMSO
 Q
T ; Edit Text
 I $G(XMPAKMAN) Q:$$NOPAKEDT^XMJMSO
 D BODY^XMJMS(XMDUZ,XMZ,XMSUBJ,.XMRESTR)
 Q
V ; Vaporize date
 N XMMSG
 I $G(XMINSTR("VAPOR")) D  Q
 . D VAPOR^XMXEDIT(XMZ,"@",.XMINSTR,.XMMSG)
 . W !,XMMSG
 D V^XMJMSO
 Q:'$D(XMINSTR("VAPOR"))
 D VAPOR^XMXEDIT(XMZ,XMINSTR("VAPOR"),.XMINSTR,.XMMSG)
 Q
X ; Closed msg
 N XMMSG
 D CLOSED^XMXEDIT(XMZ,.XMINSTR,.XMMSG)
 I $D(XMERR) D SHOW^XMJERR Q
 W !,XMMSG
 Q
