XMYPOST9 ;SFISC/GMB - Post-patch stuff ;06/14/99  16:41
 ;;7.1;MailMan;**50**;Jun 02, 1994
ENTER ;
 D XREFS
 D AIXREF^XMYPRE2
 D:$D(^XMBPOST("POST")) POST^XMYPRE2
 D MEDSYN^XMYPOSTA
 Q:$D(^XMB(1,1,.17))
 D SITE1
 D MESSAGE
 D SITE2
 Q
XREFS ;
 D BMES^XPDUTL("Fire xrefs on 'timezone' field of the MailMan site parms file.")
 N DIK,DA
 S DIK="^XMB(1,"
 S DA=1
 S DIK(1)=1
 D EN1^DIK
 Q
MESSAGE ;
 N XMZ,XMCNT,XMZREC,XMCRE8,XMPREV,XPDIDTOT,XMNOSUBJ
 S XPDIDTOT=0
 D UPDATE^XPDID(0)
 S XPDIDTOT=$P(^XMB(3.9,0),U,4)
 D BMES^XPDUTL("Check "_XPDIDTOT_" messages in ^XMB(3.9, MESSAGE file...")
 D MES^XPDUTL("and set local create date and xref for each message...")
 S XMNOSUBJ=$$EZBLD^DIALOG(34012)
 S XMPREV=DT
 S (XMZ,XMCNT)=0
 F  S XMZ=$O(^XMB(3.9,XMZ)) Q:XMZ'>0  D
 . S XMCNT=XMCNT+1
 . I XMCNT#1000=0 D UPDATE^XPDID(XMCNT)
 . S XMZREC=$G(^XMB(3.9,XMZ,0))
 . D RESP(XMZ,XMZREC,XMNOSUBJ)
 . D CRE8DT(XMZ,$P(XMZREC,U,3),.XMPREV)
 D UPDATE^XPDID(XMCNT)
 D BMES^XPDUTL(XMCNT_" messages in ^XMB(3.9, MESSAGE file.")
 I XMCNT=$P(^XMB(3.9,0),U,4) Q
 D MES^XPDUTL("Changing the count in the zero node in ^XMB(3.9 from "_$P(^XMB(3.9,0),U,4)_" to "_XMCNT_".")
 L +^XMB(3.9,0)
 S $P(^XMB(3.9,0),U,4)=XMCNT
 L -^XMB(3.9,0)
 Q
RESP(XMZ,XMZREC,XMNOSUBJ) ;
 N XMZO
 I $P(XMZREC,U,8) D  Q
 . S XMZO=$P(XMZREC,U,8)
 . I XMZO=XMZ D  Q
 . . ;D ERR(XMZ,"Message thinks it's a response to itself: fixed")
 . . S $P(^XMB(3.9,XMZ,0),U,8)=""
 . I '$D(^XMB(3.9,XMZO,0)) D  Q
 . . ;D ERR(XMZ,"No original message "_XMZO_" for this response: fixed")
 . . S $P(^XMB(3.9,XMZ,0),U,8)=""
 . I $$ATTACHED(XMZO,XMZ) Q
 . ;D ERR(XMZ,"Not in response chain of "_XMZO_": fixed")
 . S $P(^XMB(3.9,XMZ,0),U,8)=""
 N XMSUBJ
 S XMSUBJ=$P(XMZREC,U)
 I XMSUBJ="" D  Q
 . S $P(^XMB(3.9,XMZ,0),U,1)=XMNOSUBJ
 . S ^XMB(3.9,"B",XMNOSUBJ,XMZ)=""
 Q:XMSUBJ'?1"R"1.N
 Q:$P(XMZREC,U,2)["@"
 S XMZO=+$E(XMSUBJ,2,99)
 I '$D(^XMB(3.9,XMZO,0)) D  Q
 . ;D ERR(XMZ,"No original message "_XMZO_" for this response: not fixed")
 I '$$ATTACHED(XMZO,XMZ) D  Q
 . ;D ERR(XMZ,"Not in response chain of "_XMZO_": not fixed")
 ;D ERR(XMZ,"Piece 8 didn't point to original message "_XMZO_": fixed")
 S $P(^XMB(3.9,XMZ,0),U,8)=XMZO
 Q
ATTACHED(XMZO,XMZ) ; Is XMZ in the response chain of XMZO?
 N I
 S I=0
 F  S I=$O(^XMB(3.9,XMZO,3,I)) Q:'I  Q:$P($G(^(I,0)),U)=XMZ
 Q +I
CRE8DT(XMZ,XMDATE,XMPREV) ;
 S XMCRE8=$P($G(^XMB(3.9,XMZ,.6)),U,1)
 I 'XMCRE8 D  Q
 . I $P(XMDATE,".",1)?7N S XMDATE=$P(XMDATE,".",1)
 . E  I XMDATE="" S XMDATE=XMPREV
 . E  D
 . . S XMDATE=$$CONVERT^XMXUTIL1(XMDATE)
 . . S:XMDATE=-1 XMDATE=XMPREV
 . S ^XMB(3.9,XMZ,.6)=XMDATE
 . S ^XMB(3.9,"C",XMDATE,XMZ)=""
 . S XMPREV=XMDATE
 . ;D ERR(XMZ,"Msg has no local create date: fixed")
 S XMPREV=XMDATE
 I '$D(^XMB(3.9,"C",XMCRE8,XMZ)) D
 . S ^XMB(3.9,"C",XMCRE8,XMZ)=""
 . ;D ERR(XMZ,"Local create date C xref missing: fixed")
 Q
ERR(XMZ,XMERRMSG) ;
 D MES^XPDUTL("Msg="_XMZ_" "_XMERRMSG)
 Q
SITE1 ;
 Q:$D(^XMB(1,1,.17))
 D BMES^XPDUTL("Change message number references to date references in 4.3, MM Site Parms.")
 ; file 4.3, field 4.301
 I $P($G(^XMB(1,1,.14)),U,1) S $P(^XMB(1,1,.14),U,1)=""
 ; file 4.3, field 4.304
 N XMMSGS
 S XMMSGS=+$P($G(^XMB(1,1,"NOTOPURGE")),U)
 I XMMSGS D
 . N XMZ,XMCRE8,XMDAYS
 . S XMZ=$O(^XMB(3.9,$O(^XMB(3.9,":"),-1)-XMMSGS))
 . F  Q:$P($G(^XMB(3.9,XMZ,0)),U,3)?7N.E  S XMZ=$O(^XMB(3.9,XMZ)) Q:'XMZ
 . S XMCRE8=$$CONVERT^XMXUTIL1($E($P(^XMB(3.9,XMZ,0),U,3),1,7))
 . S XMDAYS=$$FMDIFF^XLFDT(DT,XMCRE8)
 . I XMDAYS>999 S XMDAYS=999
 . I XMDAYS<30 S XMDAYS=30
 . S $P(^XMB(1,1,"NOTOPURGE"),U)=XMDAYS
 ; file 4.3, field 17.1
 N XMDIGS
 S XMDIGS=$L($O(^XMB(3.9,":"),-1))
 I XMDIGS>14 S XMDIGS=14
 I XMDIGS<7 S XMDIGS=7
 S ^XMB(1,1,.17)=XMDIGS
 Q
SITE2 ;
 D BMES^XPDUTL("Change message number references to date references in 3.7, Mailbox file.")
 ; file 3.7, field 1.2
 N XMDUZ,XMZ,XMMIN,XMCRE8
 S XMMIN=$O(^XMB(3.9,0))
 S XMDUZ=0
 F  S XMDUZ=$O(^XMB(3.7,XMDUZ)) Q:'XMDUZ  D
 . S XMZ=$P($G(^XMB(3.7,XMDUZ,0)),U,7)
 . Q:'XMZ
 . I XMZ<XMMIN S $P(^XMB(3.7,XMDUZ,0),U,7)="" Q
 . I '$D(^XMB(3.9,XMZ)) S XMZ=$O(^XMB(3.9,XMZ))
 . S XMCRE8=$P($G(^XMB(3.9,XMZ,.6)),U,1)
 . S $P(^XMB(3.7,XMDUZ,0),U,7)=XMCRE8
 Q
 ;
 ;#34012 = * No Subject *
