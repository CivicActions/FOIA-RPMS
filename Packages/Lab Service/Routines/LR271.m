LR271 ;DALOI/JMC - LR*5.2*271 PATCH ENVIRONMENT CHECK ROUTINE ;01/31/2001
 ;;5.2;LAB SERVICE;**271**;Sep 27, 1994
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
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))
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
PRE ; KIDS Pre install for LR*5.2*271
 ;
 N XQA,XQAMSG
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** No action required ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 ;
 Q
 ;
 ;
POST ; KIDS Post install for LR*5.2*271
 ;
 N LR6207,LRAA,LRBAD,LRGOOD,LRFIX,LRX,LRY,X,XQA,XQAMSG,Y
 ;
 S LRFIX=0
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Checking EXECUTE CODE (#62.07) and ACCESSION (#68) files ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** for incorrect QUARTERLY transform code ***",80))
 ;
 ; Check for bad quarterly execute code
 S LRBAD="S %DT="""",X=""T"" D ^%DT S LRAD=$E(Y,1,3)_(($E(Y,4,5)-1)\3)_""00"" S LRAN=1+$S($D(^LRO(68,LRWLC,1,LRAD,1,0)):$P(^(0),""^"",4),1:0) Q"
 ;
 ; Replace it with the correct execute code.
 S LRGOOD="S %DT="""",X=""T"" D ^%DT S LRAD=$E(Y,1,3)_""0000""+(($E(Y,4,5)-1)\3*300+100) S LRAN=1+$S($D(^LRO(68,LRWLC,1,LRAD,1,0)):$P(^(0),""^"",4),1:0) Q"
 ;
 ; Check EXECUTE CODE file (#62.07) for bad QUARTERLY execute code entry.
 S LR6207=$O(^LAB(62.07,"B","QUARTERLY",0))
 I LR6207 D
 . S X=$G(^LAB(62.07,LR6207,.1))
 . I X=LRBAD S ^LAB(62.07,LR6207,.1)=LRGOOD,LRFIX=1,LRFIX(62.07,LR6207)=""
 ;
 ; Check ACCCESSION file (#68) for bad QUARTERLY execute code entry.
 S LRAA=0
 F  S LRAA=$O(^LRO(68,LRAA)) Q:'LRAA  D
 . I $P($G(^LRO(68,LRAA,0)),"^",3)'="Q" Q
 . S X=$G(^LRO(68,LRAA,.1))
 . I X=LRBAD S ^LRO(68,LRAA,.1)=LRGOOD,LRFIX=1,LRFIX(68,LRAA)=""
 ;
 I LRFIX D
 . S LRY=0
 . F  S LRY=$O(LRFIX(62.07,LRY)) Q:'LRY  D
 . . S LRX="Corrected entry #"_LRY_" - "_$P($G(^LAB(62.07,LRY,0)),"^")_" in EXECUTE CODE file (#62.07)"
 . . D BMES^XPDUTL(LRX)
 . S LRY=0
 . F  S LRY=$O(LRFIX(68,LRY)) Q:'LRY  D
 . . S LRX="Corrected entry #"_LRY_" - "_$P($G(^LRO(68,LRY,0)),"^")_" in ACCESSION file (#68)"
 . . D BMES^XPDUTL(LRX)
 ;
 I 'LRFIX D BMES^XPDUTL($$CJ^XLFSTR("*** No action required ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 S XQAMSG="LIM: Review description for "_$G(XPDNM,"Unknown patch")_" use KIDS:Utilities:Build File Print"
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 Q
