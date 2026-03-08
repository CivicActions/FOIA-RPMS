LA61 ;DALOI/JMC - LA*5.2*61 PATCH ENVIRONMENT CHECK ROUTINE ;3/5/2002
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**61**;Sep 27, 1994
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
 I '$G(XPDENV) D  Q
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H)
 . S XQA("G.LMI")=""
 . D SETUP^XQALERT
 . S XQAMSG="LIM: Review patch "_$G(XPDNM,"Unknown patch")_" post installation instructions"
 . S XQA("G.LMI")=""
 . D SETUP^XQALERT
 . D BMES^XPDUTL($$CJ^XLFSTR("Sending transport global loaded alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
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
 ;
PRE ; KIDS Pre install for LA*5.2*61
 ;
 N DA,DIK
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 ;
 ; Remove existing fields from DD to insure clean install of fields from patch.
 D BMES^XPDUTL($$CJ^XLFSTR("*** Removing COLLECTING FACILITY (#.02), HOST FACILITY (#.03), ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** and LAB MESSAGING LINK (#.07) fields ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** from LAB SHIPPING CONFIGURATION file (#62.9) ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** These fields will be reinstalled by this patch ***",80))
 F DA=.02,.03,.07 S DIK="^DD(62.9,",DA(1)=62.9 D ^DIK
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Removing STATUS (#2) field from LA7 MESSAGE QUEUE file (#62.49) ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** This field will be reinstalled by this patch ***",80))
 K DA,DIK
 S DA=2 S DIK="^DD(62.49,",DA(1)=62.49 D ^DIK
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 ;
 Q
 ;
 ;
POST ; KIDS Post install for LA*5.2*61
 N DA,DIK,XQA,XQAMSG
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Deleting ""ASC"" cross-reference on LAB SHIPPING CONFIGURATION file (#62.9) ***",80))
 K ^LAHM(62.9,"ASC")
 ;
 ; Kill off existing "CH" index on file #62.9 and re-index.
 D BMES^XPDUTL($$CJ^XLFSTR("*** Deleting ""CH"" cross-reference on LAB SHIPPING CONFIGURATION file (#62.9) ***",80))
 K ^LAHM(62.9,"CH")
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Building ""CH"" cross-reference on LAB SHIPPING CONFIGURATION file (#62.9) ***",80))
 S DIK="^LAHM(62.9,"
 S DIK(1)=".02^CH"
 D ENALL^DIK
 D BMES^XPDUTL($$CJ^XLFSTR("*** Completed reindexing ***",80))
 ;
 ; Kill off existing "ORU" index on file #62.49 and build new "AC" index.
 D BMES^XPDUTL($$CJ^XLFSTR("*** Deleting ""ORU"" cross-reference on LA7 MESSAGE QUEUE file (#62.49) ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Building ""AC"" cross-reference on LA7 MESSAGE QUEUE file (#62.49) ***",80))
 M ^LAHM(62.49,"AC","ORU")=^LAHM(62.49,"ORU")
 K ^LAHM(62.49,"ORU")
 M ^LAHM(62.49,"AC","ORR")=^LAHM(62.49,"ORR")
 K ^LAHM(62.49,"ORR")
 D BMES^XPDUTL($$CJ^XLFSTR("*** Completed reindexing ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 ;
 S XQAMSG="LIM: Review patch "_$G(XPDNM,"Unknown patch")_" post installation instructions"
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 Q
