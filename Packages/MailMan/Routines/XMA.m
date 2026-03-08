XMA ;(WASH ISC)/THM/CAP-MailMan READ/NEW OPTIONS ;05/28/99  09:04
 ;;7.1;MailMan;**4,18,50**;Jun 02, 1994
 ; Entry points (DBIA 1284):
 ; REC    Read Mail
 ;
REC ; Read (Manage) Mail
 ; All input variables ignored
 I '$G(DUZ) W "  User ID needed (DUZ) !!" Q
 D EN^XM,MANAGE^XMJBM
 Q
NNEW Q
