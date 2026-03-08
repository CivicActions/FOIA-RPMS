XMUT4C ;(WASH ISC)/CAP-INTEGRITY CHECKER ;06/14/99  16:40
 ;;7.1;MailMan;**10,22,50**;Jun 02, 1994
MESSAGE ;
 N XMZ,XMCNT,XMZREC,XMCRE8
 W !!,"Checking ^XMB(3.9, MESSAGE file",!
 S (XMZ,XMCNT)=0
 F  S XMZ=$O(^XMB(3.9,XMZ)) Q:XMZ'>0  D
 . S XMCNT=XMCNT+1
 . I '$D(ZTQUEUED),XMCNT#5000=0 W:$X>40 ! W XMCNT,"."
 . S XMZREC=$G(^XMB(3.9,XMZ,0))
 . I "^^^^^^^^"[XMZREC D
 . . D ERR(XMZ,201,"Msg has bad/no 0 node: not fixed")
 . E  D
 . . D SUBJ(XMZ,XMZREC)
 . . I $P(XMZREC,U,2)="" D
 . . . S $P(^XMB(3.9,XMZ,0),U,2)=$$EZBLD^DIALOG(34009)
 . . . D ERR(XMZ,206,"Msg has no sender: fixed")
 . . I $P(XMZREC,U,3)="" D
 . . . S $P(^XMB(3.9,XMZ,0),U,3)=DT
 . . . D ERR(XMZ,207,"Msg has no date/time: fixed")
 . D CRE8DT(XMZ,$P(XMZREC,U,3))
 . D RESP(XMZ,XMZREC)
 . D:$D(^XMB(3.9,XMZ,1)) RECIP(XMZ)
 W !!,XMCNT," Messages processed."
 I XMCNT=$P(^XMB(3.9,0),U,4) W "  Zero node is OK." Q
 L +^XMB(3.9,0)
 S $P(^XMB(3.9,0),U,4)=XMCNT
 L -^XMB(3.9,0)
 W "  I reset the zero node."
 Q
SUBJ(XMZ,XMZREC) ;
 N XMSUBJ
 S XMSUBJ=$P(XMZREC,U)
 I XMSUBJ="" D
 . S XMSUBJ=$$EZBLD^DIALOG(34012)
 . S $P(^XMB(3.9,XMZ,0),U,1)=XMSUBJ
 . S ^XMB(3.9,"B",XMSUBJ,XMZ)=""
 . D ERR(XMZ,202,"Msg has no subject: fixed")
 I $L(XMSUBJ)<3!($L(XMSUBJ)>65) D ERR(XMZ,203,"Msg subject <3 or >65: not fixed")
 I '$D(^XMB(3.9,"B",$E(XMSUBJ,1,30),XMZ)) D
 . I $L(XMSUBJ)>30,$D(^XMB(3.9,"B",XMSUBJ,XMZ)) D
 . . K ^XMB(3.9,"B",XMSUBJ,XMZ)
 . . D ERR(XMZ,205,"Subject B xref too long: xref shortened")
 . E  D ERR(XMZ,204,"Subject has no B xref: xref created")
 . S ^XMB(3.9,"B",$E(XMSUBJ,1,30),XMZ)=""
 Q
RESP(XMZ,XMZREC) ;
 N XMZO
 I $P(XMZREC,U,8) D  Q
 . S XMZO=$P(XMZREC,U,8)
 . I XMZO=XMZ D  Q
 . . D ERR(XMZ,211,"Message thinks it's a response to itself: fixed")
 . . S $P(^XMB(3.9,XMZ,0),U,8)=""
 . I '$D(^XMB(3.9,XMZO,0)) D  Q
 . . D ERR(XMZ,212,"No original message "_XMZO_" for this response: fixed")
 . . S $P(^XMB(3.9,XMZ,0),U,8)=""
 . I $$ATTACHED(XMZO,XMZ) Q
 . D ERR(XMZ,213,"Not in response chain of "_XMZO_": fixed")
 . S $P(^XMB(3.9,XMZ,0),U,8)=""
 N XMSUBJ
 S XMSUBJ=$P(XMZREC,U)
 Q:XMSUBJ'?1"R"1.N
 Q:$P(XMZREC,U,2)["@"
 S XMZO=+$E(XMSUBJ,2,99)
 I '$D(^XMB(3.9,XMZO,0)) D  Q
 . D ERR(XMZ,216,"No original message "_XMZO_" for this response: not fixed")
 I '$$ATTACHED(XMZO,XMZ) D  Q
 . D ERR(XMZ,217,"Not in response chain of "_XMZO_": not fixed")
 D ERR(XMZ,218,"Piece 8 didn't point to original message "_XMZO_": fixed")
 S $P(^XMB(3.9,XMZ,0),U,8)=XMZO
 Q
ATTACHED(XMZO,XMZ) ; Is XMZ in the response chain of XMZO?
 N I
 S I=0
 F  S I=$O(^XMB(3.9,XMZO,3,I)) Q:'I  Q:$P($G(^(I,0)),U)=XMZ
 Q +I
CRE8DT(XMZ,XMDATE) ;
 S XMCRE8=$P($G(^XMB(3.9,XMZ,.6)),U,1)
 I 'XMCRE8 D  Q
 . I $P(XMDATE,".",1)?7N S XMDATE=$P(XMDATE,".",1)
 . E  I XMDATE="" S XMDATE=DT
 . E  D
 . . S XMDATE=$$CONVERT^XMXUTIL1(XMDATE)
 . . S:XMDATE=-1 XMDATE=DT
 . S $P(^XMB(3.9,XMZ,.6),U,1)=XMDATE
 . S ^XMB(3.9,"C",XMDATE,XMZ)=""
 . D ERR(XMZ,208,"Msg has no local create date: fixed")
 I '$D(^XMB(3.9,"C",XMCRE8,XMZ)) D
 . S ^XMB(3.9,"C",XMCRE8,XMZ)=""
 . D ERR(XMZ,209,"Local create date C xref missing: fixed")
 Q
RECIP(XMZ) ; Check recipient multiple
 N I,XMVAL,XMXREF,XMRECIPS
 D CXREF(XMZ)
 S (I,XMRECIPS)=0
 F  S I=$O(^XMB(3.9,XMZ,1,I)) Q:'I  D
 . S XMRECIPS=XMRECIPS+1
 . S XMVAL=$P($G(^XMB(3.9,XMZ,1,I,0)),U)
 . I XMVAL="" D ERR(XMZ,221,"Recipient "_I_" null, no C xref: not fixed") Q
 . Q:$D(^XMB(3.9,XMZ,1,"C",$E(XMVAL,1,30),I))
 . I $L(XMVAL)>30,$D(^XMB(3.9,XMZ,1,"C",XMVAL,I)) D  Q
 . . ;K ^XMB(3.9,XMZ,1,"C",XMVAL,I)
 . . ;D ERR(XMZ,223,"Recipient "_I_" C xref too long: xref shortened")
 . . ;S ^XMB(3.9,XMZ,1,"C",$E(XMVAL,1,30),I)=""
 . D ERR(XMZ,222,"Recipient "_I_" no C xref: xref created")
 . S ^XMB(3.9,XMZ,1,"C",$E(XMVAL,1,30),I)=""
 I $D(^XMB(3.9,XMZ,1,0)) S:$P(^XMB(3.9,XMZ,1,0),U,4)'=XMRECIPS $P(^(0),U,4)=XMRECIPS Q
 S ^XMB(3.9,XMZ,1,0)="^3.91A^"_I_U_XMRECIPS
 Q
CXREF(XMZ) ; Check C xref for Recipient multiple
 N I,XMVAL,XMXREF
 S (I,XMXREF)=""
 F  S XMXREF=$O(^XMB(3.9,XMZ,1,"C",XMXREF)) Q:'XMXREF  D
 . F  S I=$O(^XMB(3.9,XMZ,1,"C",XMXREF,I)) Q:'I  D
 . . S XMVAL=$P($G(^XMB(3.9,XMZ,1,I,0)),U)
 . . Q:$E(XMVAL,1,30)=$E(XMXREF,1,30)
 . . I XMVAL="" D  Q
 . . . I +XMXREF=XMXREF D  Q
 . . . . S $P(^XMB(3.9,XMZ,1,I,0),U)=XMXREF
 . . . . D ERR(XMZ,231,"C xref, but recip "_I_" null: fixed using numeric xref")
 . . . D ERR(XMZ,232,"C xref, but recip "_I_" null: not fixed, xref not numeric")
 . . K ^XMB(3.9,XMZ,1,"C",XMXREF,I)
 . . D ERR(XMZ,233,"C xref for recip "_I_" doesn't match recip: xref killed")
 Q
ERR(XMZ,XMERRNUM,XMERRMSG) ;
 S XMERROR(XMERRNUM)=$G(XMERROR(XMERRNUM))+1
 W !,"Msg=",XMZ,", Err=",$J(XMERRNUM,3)," ",XMERRMSG
 Q
 ;
 ;#34009 = * No Name *
 ;#34012 = * No Subject *
