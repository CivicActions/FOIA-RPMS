LA46 ;DALOI/JMC - LA*5.2*46 PATCH ENVIRONMENT CHECK ROUTINE ;8/21/98
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46**;Sep 27, 1994
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
PRE ; KIDS Pre install for LA*5.2*46
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 ;
 ; Check and save auto download process status
 S LA7ADLST=$G(^LA("ADL","STOP"))
 I $P(LA7ADLST,"^")=0 D
 . D SETSTOP^LA7ADL1(2,DUZ)
 . D BMES^XPDUTL($$CJ^XLFSTR("Shutting down Lab Universal Interface Auto Download Job",80))
 ;
 I $P(LA7ADLST,"^")'=0 D BMES^XPDUTL($$CJ^XLFSTR("--- No action required ---",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 Q
 ;
POST ; KIDS Post install for LA*5.2*46
 N I,LA7CNT,LA7I,LA7J,LA7UPD,XQA,XQAMSG
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Checking LAB SHIPPING MANIFEST file #62.8 ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** for missing data in field SHIP VIA #.04 ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** updating with information from file LAB SHIPPING CONFIGURATION #62.9 ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** when appropriate. ***",80))
 D BMES^XPDUTL("*** Checking data: ")
 ;
 S (LA7CNT,LA7I,LA7UPD)=0
 S XPDIDTOT=$P($G(^LAHM(62.8,0)),"^",3)
 D UPDATE^XPDID(0)
 F LA7J=1:1 S LA7I=$O(^LAHM(62.8,LA7I)) Q:'LA7I  D
 . I '(LA7J#10) D UPDATE^XPDID(LA7J)
 . N FDA,LA7DIE
 . S LA7I(0)=$G(^LAHM(62.8,LA7I,0))
 . I $P(LA7I(0),"^",4) Q  ; already updated
 . I '$P(LA7I(0),"^",2) Q  ; no pointer to #62.9
 . I $P($G(^LAHM(62.9,$P(LA7I(0),"^",2),0)),"^",8) D
 . . S FDA(1,62.8,LA7I_",",.04)=$P($G(^LAHM(62.9,$P(LA7I(0),"^",2),0)),"^",8)
 . . D FILE^DIE("","FDA(1)","LA7DIE(1)")
 . . S LA7CNT=LA7CNT+1
 I 'LA7CNT D BMES^XPDUTL($$CJ^XLFSTR("--- No entries required updating ---",80))
 I LA7CNT D
 . S LA7UPD=1
 . D BMES^XPDUTL($$CJ^XLFSTR("--- Updated "_LA7CNT_" entries in LAB SHIPPING MANIFEST file #62.8  ---",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Checking LA7 MESSAGE PARAMETER file #62.48 ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Updating processing routine as needed ***",80))
 ;
 S (LA7CNT,LA7I)=0
 F  S LA7I=$O(^LAHM(62.48,LA7I)) Q:'LA7I  D
 . N FDA,LA7DIE
 . F I=0,1 S LA7I(I)=$G(^LAHM(62.48,LA7I,I))
 . I $E($P(LA7I(0),"^"),1,4)'="LA7V" Q
 . I LA7I(1)="D QUE^LA7VIN" Q  ; already updated
 . S FDA(1,62.48,LA7I_",",5)="D QUE^LA7VIN"
 . D FILE^DIE("","FDA(1)","LA7DIE(1)")
 . D BMES^XPDUTL("Updating entry "_$P(LA7I(0),"^"))
 . S LA7CNT=LA7CNT+1
 ;
 I 'LA7CNT D BMES^XPDUTL($$CJ^XLFSTR("--- No entries required updating ---",80))
 I LA7CNT S LA7UPD=1
 ;
 I $P(LA7ADLST,"^")=0 D
 . D ZTSK^LA7ADL
 . D SETSTOP^LA7ADL1(1,DUZ)
 . D BMES^XPDUTL($$CJ^XLFSTR("Restarting Lab Universal Interface Auto Download Job",80))
 . S LA7UPD=1
 ;
 I $L($G(XPDNM)) D
 . D PRD^DILFD(62.9,XPDNM)
 . D BMES^XPDUTL($$CJ^XLFSTR("Updating package revision data for file #62.9",80))
 ;
 I 'LA7UPD D BMES^XPDUTL($$CJ^XLFSTR("--- No actions required for post install ---",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 ;
 S XQAMSG="LIM: Review LEDI II Install Guide and User Manual"
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 ;
CLEANUP ;
 K LA7ADLST
 ;
 Q
