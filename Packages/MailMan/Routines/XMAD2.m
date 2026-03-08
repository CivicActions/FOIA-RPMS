XMAD2 ;(WASH ISC)/CAP-Basket lookup/create ;05/06/99  15:40
 ;;7.1;MailMan;**31,50**;Jun 02, 1994
 ; Entry points (DBIA 1147):
 ; BSKT   Lookup/create a basket, return its number
 ;
BSKT(XMKN,XMDUZ) ; Find or Create a basket / return its internal number
 ; Needs:
 ; XMKN    Basket-name
 ; XMDUZ   User's DUZ
 N XMK,XMER
 S XMK=$$FIND1^DIC(3.701,","_XMDUZ_",","X",XMKN)
 Q:XMK XMK
 D CRE8BSKT^XMXAPIB(XMDUZ,XMKN,.XMK)
 Q:'$D(XMERR) XMK
 S XMER=^TMP("XMERR",$J,1,"TEXT",1)
 K XMERR,^TMP("XMERR",$J)
 Q XMER
