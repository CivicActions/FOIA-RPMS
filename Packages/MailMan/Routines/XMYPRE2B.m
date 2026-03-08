XMYPRE2B ;(ISC-SF)/GMB-PREINSTALLATION INIT ;05/27/99  12:35
 ;;7.1;MailMan;**50**;Jun 02, 1994
DELDATA ;
 N XMDUZ,XMK,XMZ,XMREC,XPDIDTOT,XMCNT
 D BMES^XPDUTL("Delete data from those fields...")
 D MES^XPDUTL("...from ^XMB(3.7, MAILBOX")
 S (XPDIDTOT,XMCNT)=0
 D UPDATE^XPDID(0)
 S XPDIDTOT=$P(^XMB(3.7,0),U,4)
 D BMES^XPDUTL("Processing "_XPDIDTOT_" users in ^XMB(3.7, MAILBOX file...")
 S XMDUZ=0
 F  S XMDUZ=$O(^XMB(3.7,XMDUZ)) Q:XMDUZ'>0  D
 . S XMCNT=XMCNT+1
 . I XMCNT#250=0 D UPDATE^XPDID(XMCNT)
 . I $P($G(^XMB(3.7,XMDUZ,0)),U)'=XMDUZ D
 . . S $P(^XMB(3.7,XMDUZ,0),U)=XMDUZ
 . . S ^XMB(3.7,"B",XMDUZ,XMDUZ)=""
 . S:$P(^XMB(3.7,XMDUZ,0),U,4)'="" $P(^(0),U,4)="" ; 3.7,4.6
 . I $D(^XMB(3.7,XMDUZ,3)) K ^XMB(3.7,XMDUZ,3) ; 3.7,4.7
 . I $D(^XMB(3.7,XMDUZ,10)) K ^XMB(3.7,XMDUZ,10) ; 3.7,10
 . I $D(^XMB(3.7,XMDUZ,.1)) K ^XMB(3.7,XMDUZ,.1) ; 3.7,20
 . I $D(^XMB(3.7,XMDUZ,.2)) K ^XMB(3.7,XMDUZ,.2) ; 3.7,21
 . S XMK=0
 . F  S XMK=$O(^XMB(3.7,XMDUZ,2,XMK)) Q:XMK'>0  D
 . . S ^(0)=$P($G(^XMB(3.7,XMDUZ,2,XMK,0)),U,1,2) ; 3.701,3 ,4 ,5
 . . S XMZ=0
 . . F  S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,XMZ)) Q:XMZ'>0  D
 . . . I $D(^XMB(3.7,XMDUZ,1,XMK,1,XMZ,1)) K ^XMB(3.7,XMDUZ,1,XMK,1,XMZ,1) ; 3.702,1
 . I $D(^XMB(3.7,XMDUZ,"T")) S $P(^XMB(3.7,XMDUZ,"T"),U,2)="" ; 3.7,6
 D UPDATE^XPDID(XPDIDTOT)
 D BMES^XPDUTL(XMCNT_" users in ^XMB(3.7, MAILBOX file.")
 I XMCNT'=$P(^XMB(3.7,0),U,4) D
 . D MES^XPDUTL("Changing the count in the zero node in ^XMB(3.7 from "_$P(^XMB(3.7,0),U,4)_" to "_XMCNT_".")
 . L +^XMB(3.7,0)
 . S $P(^XMB(3.7,0),U,4)=XMCNT
 . L -^XMB(3.7,0)
 D BMES^XPDUTL("Delete data from those fields...")
 D MES^XPDUTL("...from ^XMB(3.9, MESSAGE")
 K ^XM("C") ; 3.9,1   FROM (C xref - there shouldn't be any data)
 D MES^XPDUTL("...from ^XMB(1, MAILMAN SITE PARAMETERS")
 S $P(^XMB(1,1,0),U,7)=""
 S $P(^XMB(1,1,0),U,8)=""
 S $P(^XMB(1,1,0),U,10)=""
 S $P(^XMB(1,1,0),U,11)=""
 K ^XMB(1,1,2)
 K ^XMB(1,1,3)
 K ^XMB(1,1,4)
 K ^XMB(1,1,4.33)
 K ^XMB(1,1,5)
 K ^XMB(1,1,19)
 K ^XMB(1,1,19.1)
 K ^XMB(1,1,19.2)
 K ^XMB(1,1,19.3)
 K ^XMB(1,1,"ABOPT")
 K ^XMB(1,1,"ABPKG")
 K ^XMB(1,1,"INTRO")
 K ^XMB(1,1,"NPI")
 K ^XMB(1,1,"SPL")
 K ^XMB(1,1,"XUCP")
 I $D(^XMB(1,1,"XUS")) D
 . N XMINST
 . S XMINST=$P(^XMB(1,1,"XUS"),U,17)
 . S ^XMB(1,1,"XUS")=""
 . S $P(^XMB(1,1,"XUS"),U,17)=XMINST
 K ^XMB(1,"AT")
 K ^XMB(1,"ATM01")
 K ^XMB(1,"ATM1")
 K ^XMB(1,"ATM2")
 K ^XMB(1,"ATM7")
 K ^XMB(1,"ATM8")
 K ^XMB(1,"ATM9")
 K ^XMB(1,"ATM13")
 K ^XMB(1,"ATM14")
 K ^XMB(1,"ATM15")
 K ^XMB(1,"ATM16")
 K ^XMB(1,"ATM300")
 K ^XMB(1,"AZTH")
 K ^XMB(1,"AZTI")
 K ^XMB(1,"AZTJ")
 K ^XMB(1,"AZTM")
 K ^XMB(1,"AZTO")
 K ^XMB(1,"AZTP")
 K ^XMB(1,"AZTR")
 K ^XMB(1,"AZTS")
 K ^XMB(1,"AZTT")
 K ^XMB(1,"AZTV")
 Q
