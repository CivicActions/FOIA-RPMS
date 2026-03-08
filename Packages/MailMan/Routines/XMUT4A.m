XMUT4A ;ISC-SF/GMB- Integrity Checker ;06/29/99  15:17
 ;;7.1;MailMan;**34,55,50**;Jun 02, 1994
ADDITC(XMDUZ,XMK,XMZ,XMKZ) ; "C" xref, but msg not in bskt.  Fix it.
 S ^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)=XMZ_U_XMKZ_U_$S($D(^XMB(3.7,XMDUZ,"N0",XMK,XMZ)):"1",$D(^XMB(3.7,XMDUZ,"N",XMK,XMZ)):"1",1:"")
 S:'$D(^XMB(3.7,"M",XMZ,XMDUZ,XMK)) ^XMB(3.7,"M",XMZ,XMDUZ,XMK)=""
 Q
ADDITM(XMDUZ,XMK,XMZ,XMKZ) ; "M" xref, but msg not in bskt.  Fix it.
 ; out: XMKZ
 S XMKZ=$$GETXMKZ(XMDUZ,XMK,XMZ)
 D ADDITC(XMDUZ,XMK,XMZ,XMKZ)
 Q
ADDITN(XMDUZ,XMTYPE,XMK,XMZ) ; "N" or "N0" xref, but msg not in bskt.  Fix it.
 N XMKZ
 S XMKZ=$$GETXMKZ(XMDUZ,XMK,XMZ)
 S ^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)=XMZ_U_XMKZ_"^1"
 S:'$D(^XMB(3.7,"M",XMZ,XMDUZ,XMK)) ^XMB(3.7,"M",XMZ,XMDUZ,XMK)=""
 Q
GETXMKZ(XMDUZ,XMK,XMZ) ; Find or create the message's basket sequence number.
 N XMKZ
 S XMKZ=0
 F  S XMKZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ)) Q:'XMKZ  Q:$D(^(XMKZ,XMZ))
 Q:XMKZ XMKZ
 L +^XMB(3.7,XMDUZ,2,XMK)
 S XMKZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",""),-1)+1
 S ^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ,XMZ)=""
 L -^XMB(3.7,XMDUZ,2,XMK)
 Q XMKZ
