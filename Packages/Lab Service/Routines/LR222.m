LR222 ;DALOI/JMC - LR*5.2*222 PATCH ENVIRONMENT CHECK ROUTINE ;10/21/98
 ;;5.2;LAB SERVICE;**222**;Sep 27, 1994
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
 I '$G(XPDENV) D  Q
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H)
 . S XQA("G.LMI")=""
 . D SETUP^XQALERT
 . D BMES^XPDUTL($$CJ^XLFSTR("Sending transport global loaded alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))
 ;
 D CHECK
 D EXIT
 Q
 ;
CHECK ; Perform environment check
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Terminal Device is not defined",80))
 . S XPDQUIT=2
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Please log in to set local DUZ... variables",80))
 . S XPDQUIT=2
 I $P($$ACTIVE^XUSER(DUZ),"^")'=1 D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("You are not a valid user on this system",80))
 . S XPDQUIT=2
 S XPDIQ("XPZ1","B")="NO"
 Q
 ;
EXIT ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 Q
 ;
PRE ; KIDS Pre install for LR*5.2*222
 N LRACT
 S LRACT=0 ; flag if pre did anything
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 ;
 I $$VFIELD^DILFD(67,3) D
 . N DA,DIK
 . D BMES^XPDUTL($$CJ^XLFSTR("*** Deleting field Patient Name (#3) from file REFERRAL PATIENT (#67) ***",80))
 . D BMES^XPDUTL($$CJ^XLFSTR("*** Will be re-installed by this patch ***",80))
 . S LRACT=1,DIK="^DD(67,",DA=3,DA(1)=67
 . D ^DIK
 ;
 ; Convert data for field #11.1 in file #69.6 if old location
 I $$VFIELD^DILFD(69.6,11.1) D
 . N LRDA,LRI,LRX,LRY,XPDIDTOT
 . D FIELD^DID(69.6,11.1,"","GLOBAL SUBSCRIPT LOCATION","LRX")
 . I LRX("GLOBAL SUBSCRIPT LOCATION")="1;9" Q
 . D BMES^XPDUTL($$CJ^XLFSTR("*** Checking field COLLECTION END DATE/TIME (#11.1) ***",80))
 . D BMES^XPDUTL($$CJ^XLFSTR("*** in file LAB PENDING ORDERS ENTRY (#69.6) ***",80))
 . S (LRDA,LRY)=0,XPDIDTOT=$P($G(^LRO(69.6,0)),"^",3)
 . D UPDATE^XPDID(0)
 . F LRI=1:1 S LRDA=$O(^LRO(69.6,LRDA)) Q:'LRDA  D
 . . S LRDA(0)=$G(^LRO(69.6,LRDA,0))
 . . I '(LRI#100) D UPDATE^XPDID(LRI)
 . . I '$P(LRDA(0),"^",15) Q
 . . S $P(^LRO(69.6,LRDA,1),"^",9)=$P(LRDA(0),"^",15)
 . . S $P(^LRO(69.6,LRDA,0),"^",15)="",LRY=LRY+1
 . . I LRY'=1 Q
 . . D BMES^XPDUTL($$CJ^XLFSTR("*** Moving data in field COLLECTION END DATE/TIME (#11.1) ***",80))
 . . S LRACT=1
 ;
 I 'LRACT D BMES^XPDUTL($$CJ^XLFSTR("--- No actions required for pre install ---",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 Q
 ;
POST ; KIDS Post install for LR*5.2*222
 N LRACT,XQA,XQAMSG
 S LRACT=0 ; flag if post did anything
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 ;
 ; Check DD for file PATIENT REFERRAL (#67), field NHE FILE REF (#2.2)
 ; Delete if found.
 ; Frank Stalling wants to keep the data for now - JMC 7/19/99
 ;I $$VFIELD^DILFD(67,2.2) D
 ;. N DA,DIK,LRDA
 ;. D BMES^XPDUTL($$CJ^XLFSTR("*** Deleting field NHE FILE REF (#2.2) from file REFERRAL PATIENT (#67) ***",80))
 ;. S LRACT=1,LRDA=0
 ;. S DIK="^DD(67,",DA=2.2,DA(1)=67
 ;. D ^DIK
 ;. F  S LRDA=$O(^LRT(67,LRDA)) Q:'LRDA  D
 ;. . I $D(^LRT(67,LRDA,"NHE")) S LRACT=2 K ^LRT(67,LRDA,"NHE")
 ;. D BMES^XPDUTL($$CJ^XLFSTR("*** Deleted field NHE FILE REF (#2.2) from file REFERRAL PATIENT (#67) ***",80))
 ;. I LRACT=2 D BMES^XPDUTL($$CJ^XLFSTR("*** and data associated with this field ***",80))
 ;
 I 'LRACT D BMES^XPDUTL($$CJ^XLFSTR("--- No actions required for post install ---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 Q
