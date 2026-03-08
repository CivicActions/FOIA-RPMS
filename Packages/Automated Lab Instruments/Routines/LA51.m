LA51 ;DALOI/JMC - LA*5.2*51 PATCH ENVIRONMENT CHECK ROUTINE ;1/11/2000
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**51**;Sep 27, 1994
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 I '$G(XPDENV) D  Q
 . N XQA,XQAMSG
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H)
 . S XQA("G.LMI")=""
 . D SETUP^XQALERT
 . D BMES^XPDUTL($$CJ^XLFSTR("Sending transport global loaded alert to mail group G.LMI",80))
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
 I '$D(^VA(200,$G(DUZ),0))#2 D  Q
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
PRE ; KIDS Pre install for LA*5.2*51
 N XQA,XQAMSG
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("--- No actions required for pre install ---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 Q
 ;
POST ; KIDS Post install for LA*5.2*51
 N LA7CNT,LA7I,LA7J,LA7ROOT,LA7UPD,LA7X,XQA,XQAMSG
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Checking PROTOCOL file #101 ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("***  for incorrectly named protocols LA7V Order from XXX. ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Changing these to LA7V Order to XXX when appropriate. ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Also deleting unused LA7V protocols. ***",80))
 ;
 S (LA7CNT,LA7UPD)=0
 S LA7ROOT="^ORD(101,""B"",""LA7V"")"
 F  S LA7ROOT=$Q(@LA7ROOT) Q:$E($QS(LA7ROOT,3),1,4)'="LA7V"  D
 . N FDA,LA7DIE
 . S LA7X=$QS(LA7ROOT,3)
 . S LA7I=$QS(LA7ROOT,4)
 . ; Delete currently unused protocols
 . I $E(LA7X,1,22)="LA7V Query Response to" D DIK(101,.LA7I) Q
 . I $E(LA7X,1,27)="LA7V Query for Results from" D DIK(101,.LA7I) Q
 . I $E(LA7X,1,23)="LA7V Receive Query from" D DIK(101,.LA7I) Q
 . I $E(LA7X,1,18)="LA7V Send Query to" D DIK(101,.LA7I) Q
 . I $E(LA7X,1,21)="LA7V Send Response to" D DIK(101,.LA7I) Q
 . I $E(LA7X,1,22)="LA7V Order Response to" D DIK(101,.LA7I) Q
 . ; Correct name of this protocol
 . I $E(LA7X,1,15)="LA7V Order from" D
 . . S FDA(1,101,LA7I_",",.01)="LA7V Order to "_$P(LA7X," ",4)
 . . D FILE^DIE("","FDA(1)","LA7DIE(1)")
 . . S LA7CNT=LA7CNT+1
 . ; Remove item multiple from entries - info moved to subscriber multiple by patch HL*1.6*57
 . S LA7J=0
 . F  S LA7J=$O(^ORD(101,LA7I,10,LA7J)) Q:'LA7J  S LA7J(1)=LA7I D DIK(101.01,.LA7J)
 ;
 I 'LA7CNT D BMES^XPDUTL($$CJ^XLFSTR("--- No entries required updating ---",80))
 I LA7CNT D
 . S LA7UPD=1
 . D BMES^XPDUTL($$CJ^XLFSTR("--- Updated "_LA7CNT_" entries in PROTOCOL file #101 ---",80))
 ;
 ; Clean up HL LOWER LEVEL PROTOCOL PARAMETER - Remove LA7V* entries.
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Checking HL LOWER LEVEL PROTOCOL PARAMETER file #869.2 ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("***  for LA7V* entries that are no longer used. ***",80))
 ;
 S LA7CNT=0
 S LA7ROOT="^HLCS(869.2,""B"",""LA7V"")"
 F  S LA7ROOT=$Q(@LA7ROOT) Q:$E($QS(LA7ROOT,3),1,4)'="LA7V"  D
 . S LA7I=$QS(LA7ROOT,4)
 . D DIK(869.2,LA7I)
 I 'LA7CNT D BMES^XPDUTL($$CJ^XLFSTR("--- No entries required deleting ---",80))
 I LA7CNT D
 . S LA7UPD=1
 . D BMES^XPDUTL($$CJ^XLFSTR("--- Deleted "_LA7CNT_" entries in HL LOWER LEVEL PROTOCOL PARAMETER file #869.2 ---",80))
 ;
 ; Convert and update existing LA7V* protocols
 D BMES^XPDUTL($$CJ^XLFSTR("*** Converting and updating existing LA7V* protocols ***",80))
 S LA7CNT=0
 D CONV101
 I 'LA7CNT D BMES^XPDUTL($$CJ^XLFSTR("--- No entries required converting and updating ---",80))
 I LA7CNT D
 . S LA7UPD=1
 . D BMES^XPDUTL($$CJ^XLFSTR("--- Converted and updated "_LA7CNT_" LA7V* entries in PROTOCOL file #101 ---",80))
 ;
 I 'LA7UPD D BMES^XPDUTL($$CJ^XLFSTR("--- No actions required for post install ---",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 ;
 D SETUP^XQALERT
 ;
 Q
 ;
 ;
DIK(FILE,DA) ; Delete entry in selected file.
 ; Call with FILE = file number
 ;             DA = array pass by reference - entry ien in file #101
 ;
 N DIK
 ;
 I $G(DA)<1 Q
 ;
 I FILE=101 S DIK="^ORD(101,"
 I FILE=101.01 S DIK="^ORD(101,"_DA(1)_",10,"
 I FILE=869.2 S DIK="^HLCS(869.2,"
 I $G(DIK)="" Q
 ;
 D ^DIK
 ;
 S LA7CNT=LA7CNT+1
 ;
 Q
 ;
CONV101 ; Convert and update LA7V* protocols to new format.
 ;
 N LA7PROT,LA7QUIET
 ;
 S LA7QUIET=1 ; suppress writes in SETPRO^LA7VSTP call
 S LA7PROT="LA7V"
 F  S LA7PROT=$O(^ORD(101,"B",LA7PROT)) Q:LA7PROT=""!($E(LA7PROT,1,4)'="LA7V")  D
 . I $E(LA7PROT,1,26)="LA7V Receive Results from " D  Q
 . . D SETPRO^LA7VSTP(LA7PROT,"4////E;770.3///ORU;770.4///R01","","")
 . . D BMES^XPDUTL("  Updating/converting protocol "_LA7PROT)
 . . S LA7CNT=LA7CNT+1
 . ;
 . I $E(LA7PROT,1,26)="LA7V Process Results from " D  Q
 . . D SETPRO^LA7VSTP(LA7PROT,"4////S;770.3///@;770.4///R01;770.11///ACK;773.1////1;773.2////1;773.4////1","D ORU^LA7VHL","")
 . . D BMES^XPDUTL("  Updating/converting protocol "_LA7PROT)
 . . S LA7CNT=LA7CNT+1
 . ;
 . I $E(LA7PROT,1,14)="LA7V Order to " D  Q
 . . D SETPRO^LA7VSTP(LA7PROT,"4////E;770.2///@;770.3///ORM;770.4///O01;770.8////AL;770.9////AL;770.11///@","","D ORR^LA7VHL")
 . . D BMES^XPDUTL("  Updating/converting protocol "_LA7PROT)
 . . S LA7CNT=LA7CNT+1
 . ;
 . I $E(LA7PROT,1,19)="LA7V Send Order to " D  Q
 . . D SETPRO^LA7VSTP(LA7PROT,"4////S;770.1///@;770.3///@;770.4///O01;770.11///ORR;773.1////1;773.2////1;773.4////1","","")
 . . D BMES^XPDUTL("  Updating/converting protocol "_LA7PROT)
 . . S LA7CNT=LA7CNT+1
 . ;
 . I $E(LA7PROT,1,26)="LA7V Results Reporting to " D  Q
 . . D SETPRO^LA7VSTP(LA7PROT,"4////E;770.3///ORU;770.4///R01;770.8////AL;770.9////AL","","D ACK^LA7VMSG")
 . . D BMES^XPDUTL("  Updating/converting protocol "_LA7PROT)
 . . S LA7CNT=LA7CNT+1
 . ;
 . I $E(LA7PROT,1,21)="LA7V Send Results to " D  Q
 . . D SETPRO^LA7VSTP(LA7PROT,"4////S;770.3///@;770.4///R01;770.11///ACK;773.1///1;773.2///1;773.4////1","","")
 . . D BMES^XPDUTL("  Updating/converting protocol "_LA7PROT)
 . . S LA7CNT=LA7CNT+1
 . ;
 . I $E(LA7PROT,1,24)="LA7V Receive Order from " D  Q
 . . D SETPRO^LA7VSTP(LA7PROT,"4////E;770.2///@;770.3///ORM;770.4///O01;770.11///@","","")
 . . D BMES^XPDUTL("  Updating/converting protocol "_LA7PROT)
 . . S LA7CNT=LA7CNT+1
 . ;
 . I $E(LA7PROT,1,24)="LA7V Process Order from " D  Q
 . . D SETPRO^LA7VSTP(LA7PROT,"4////S;770.1///@;770.3///@;770.4///O01;770.11///ORR;773.1////1;773.2////1;773.4////1","D IN^LA7VORM","")
 . . D BMES^XPDUTL("  Updating/converting protocol "_LA7PROT)
 . . S LA7CNT=LA7CNT+1
 ;
 Q
