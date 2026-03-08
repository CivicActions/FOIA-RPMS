ACHSJCHK ; IHS/ITSC/PMF - CHECK FOR ACTIVE CHS OPTIONS ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**32**;JUN 11, 2001;Build 39
 ;ACHS*3.1*32 11.19.24 IHS.OIT.FCJ ADD OPTION TO CHECK CURRENT MENU OPTION FOR ACTIVE JOBS
 ;
 ;  Return Y=1 if compiled menu has ACHS option.
 ;  J = JOB subscript
 ;  N = Namespace to check
 ;  O = Option
E(N) ;EP - Are other CHS options in the compiled menu?
 N J,O
 S J=""
JOBS ;
 S J=$O(^XUTL("XQ",J))
 I 'J Q 0
 I '(J=$J),$D(^XUTL("XQ",J,"IO")),'(^("IO")=$G(I0)),$$PASS(J) Q 1
 G JOBS
PASS(J) ;
 S O=0
P1 ;
 S O=$O(^XUTL("XQ",J,O))
 I 'O Q 0
 I $P(^XUTL("XQ",J,O),U,2)[N Q 1
 G P1
 ;
 Q
OPT(OPT) ;EP - CHECK FOR ACTIVE CHS OPTIONS-ACHS*3.1*32 NEW SECTION
 N J,T,O,X,UCI
 S J=0,T=0
 ;check for Jobs
 X ^%ZOSF("UCI") S UCI=$P(Y,U,1)
 F  S J=$O(^XUTL("XQ",J)) Q:J'?1N.N  D  Q:T=1
 .Q:'$D(^XUTL("XQ",J,0))
 .S X=J X ^%ZOSF("JOBPARAM") Q:Y=""   ;TEST FOR ACTIVE JOBS
 .Q:UCI'=$P(Y,U,1)                    ;TEST FOR THE CORRECT UCI
 .I '(J=$J),$D(^XUTL("XQ",J,"IO")),'(^("IO")=$G(I0)) D ACT
EXT ;EXIT
 Q T
 ;
ACT ;
 Q:'$D(^XUTL("XQ",J,"T"))
 S O=^XUTL("XQ",J,"T")
 I $P($G(^XUTL("XQ",J,O)),U,2)=OPT S T=1
 Q
 ;
MENU() ;EP;CHECK MENU OPTION FOR ACTIVE JOBS
 N TOPT,MOPT
 S TOPT=0
 F MOPT="ACHSFEOBR","ACHSTX" D  Q:TOPT
 . S TOPT=$$OPT(MOPT) Q:'TOPT
 . W:MOPT="ACHSFEOBR" !!!!,*7,$$C^XBFUNC("CHS EOBRS ARE BEING PROCESSED -- try again later."),!
 . W:MOPT="ACHSTX" !!!!,*7,$$C^XBFUNC("CHS EXPORT PROCESS IN PROGRESS -- try again later."),!
 . I $$DIR^XBDIR("E","Press RETURN to continue...")
 Q TOPT
 ;ACHS*3.1*32 END OF CHANGES
