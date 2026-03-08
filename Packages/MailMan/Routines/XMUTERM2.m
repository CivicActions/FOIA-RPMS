XMUTERM2 ;ISC-SF/GMB-Delete Mailbox (cont.) ;04/17/2002  12:09 [ 06/25/2004  11:52 AM ]
 ;;7.1;MailMan;**1004**;Jun 28, 2002
 ;
 ; The following are called from TERMINAT^XMUTERM1
 ;
GROUP(XMDUZ) ; Remove user from mail groups
 N XMI,XMJ,DIK,DA
 ; Remove user as member from all mail groups
 S XMI=0
 F  S XMI=$O(^XMB(3.8,"AB",XMDUZ,XMI)) Q:XMI'>0  D
 . S DA(1)=XMI,DIK="^XMB(3.8,XMI,1,",XMJ=0
 . F  S XMJ=$O(^XMB(3.8,"AB",XMDUZ,XMI,XMJ)) Q:XMJ'>0  S DA=XMJ D ^DIK
 K ^XMB(3.8,"AB",XMDUZ)
 ; Remove user as coordinator from all mail groups
 S XMI=0
 F  S XMI=$O(^XMB(3.8,"AC",XMDUZ,XMI)) Q:XMI'>0  D
 . S XMFDA(3.8,XMI_",",5.1)=.5 ; (change coord to postmaster)
 . D FILE^DIE("","XMFDA")
 K ^XMB(3.8,"AC",XMDUZ)
 ; Remove user's personal mail groups, and
 ; remove user as organizer or authorized sender from all mail groups.
 S XMI=0
 F  S XMI=$O(^XMB(3.8,XMI)) Q:XMI'>0  D
 . I +$G(^XMB(3.8,XMI,3))=XMDUZ D  ; user is organizer
 . . I $P(^XMB(3.8,XMI,0),U,6)=1 S DA=XMI,DIK="^XMB(3.8," D ^DIK Q  ; delete personal group
 . . S XMFDA(3.8,XMI_",",5)=.5 ; (change organizer to postmaster)
 . . D FILE^DIE("","XMFDA")
 . ; Remove user as authorized sender from all mail groups
 . Q:'$D(^XMB(3.8,XMI,4,"B",XMDUZ))
 . S DA=$O(^XMB(3.8,XMI,4,"B",XMDUZ,0))
 . I '$D(^XMB(3.8,XMI,4,DA,0)) K ^XMB(3.8,XMI,4,"B",XMDUZ) Q
 . S DA(1)=XMI,DIK="^XMB(3.8,XMI,4," D ^DIK
 Q
SURROGAT(XMDUZ) ; Remove as mail surrogate
 N XMI,DA,DIK
 S XMI=0,DIK="^XMB(3.7,XMI,9,"
 F  S XMI=$O(^XMB(3.7,"AB",XMDUZ,XMI)) Q:XMI'>0  D
 . S DA=$O(^XMB(3.7,"AB",XMDUZ,XMI,0))
 . I '$D(^XMB(3.7,XMI,9,DA,0)) K ^XMB(3.7,"AB",XMDUZ,XMI) Q
 . S DA(1)=XMI D ^DIK
 K ^XMB(3.7,"AB",XMDUZ)
 Q
MAILBOX(XMDUZ) ; Remove user's mailbox
 Q:'$D(^XMB(3.7,XMDUZ))
 N DIK,DA
 S DIK="^XMB(3.7,",DA=XMDUZ D ^DIK
 K:$D(^XMB(3.7,XMDUZ)) ^XMB(3.7,XMDUZ) ; just in case!
 K:$D(^XMB(3.7,"B",XMDUZ)) ^XMB(3.7,"B",XMDUZ)
 Q
LATERNEW(XMDUZ) ; Remove the scheduling of any messages slated to become new for this user
 N DIK,DA
 S DIK="^XMB(3.73,"
 S DA=""
 F  S DA=$O(^XMB(3.73,"C",XMDUZ,DA)) Q:'DA  D ^DIK
 Q
LATERSND(XMDUZ) ; Remove the scheduling of any messages slated to be sent by this user.
 N XMZ,DIK,DA
 S XMZ=0
 F  S XMZ=$O(^XMB(3.9,"AW",XMDUZ,XMZ)) Q:'XMZ  D
 . S DA(1)=XMZ
 . S DIK="^XMB(3.9,"_DA(1)_",7,"
 . S DA=0
 . F  S DA=$O(^XMB(3.9,"AW",XMDUZ,XMZ,DA)) Q:'DA  D ^DIK
 Q
