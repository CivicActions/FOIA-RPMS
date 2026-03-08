XMJERR ;ISC-SF/GMB- Error handling ;07/09/98  13:30
 ;;7.1;MailMan;**50**;Jun 02, 1994
ZSHOW ;
 N I,J,XMZ
 F I=1:1:XMERR D
 . W !
 . S XMZ=$G(^TMP("XMERR",$J,I,"XMZ"))
 . W:XMZ !,*7,"Message [",XMZ,"] Subject: ",$P($G(^XMB(3.9,XMZ,0)),U)
 . S J=0
 . F  S J=$O(^TMP("XMERR",$J,I,"TEXT",J)) Q:'J  W !,^(J)
 W !
 K XMERR,^TMP("XMERR",$J)
 Q
SHOW ;
 N I,J,XMZ
 W *7
 F I=1:1:XMERR D
 . S J=0
 . F  S J=$O(^TMP("XMERR",$J,I,"TEXT",J)) Q:'J  W !,^(J)
 K XMERR,^TMP("XMERR",$J)
 Q
