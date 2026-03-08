XMA03 ;(WASH ISC)/CAP/THM-Resequence messages ;05/06/99  15:23
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Entry points (DBIA 1150):
 ; $$REN  Resequence messages in a user's basket
 ;
REN(XMDUZ,XMK) ;API entry for Renumbering Mail Basket
 ; XMDUZ  User's DUZ
 ; XMK    Basket number
 N XMMSG
 D RSEQBSKT^XMXAPIB(XMDUZ,XMK,.XMMSG)
 Q $G(XMMSG)
