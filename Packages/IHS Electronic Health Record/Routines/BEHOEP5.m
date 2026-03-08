BEHOEP5 ; IHS/MSC/MGH - EPCS hash check;18-Sep-2018 17:03;PLS
 ;;1.1;BEH COMPONENTS;**070001**;Mar 20, 2007;Build 8
 ;
 ;Returns: 0 if not tampered with
 ;         1 if tampered
VRFYPHSH(RET,ORNP) ;EP- Add check for hash of provider profile
 N ATIME,ID,SUB,XTR,MSG,GROUP,NAME,RET2,DATA,RCP
 Q:'+ORNP
 S NAME=$$GET1^DIQ(200,+ORNP,.01)
 D VRFYPHSH^BEHOEP3(.RET2,ORNP)
 S RET='RET2
 I RET=1 D
 .S ATIME=$$NOW^XLFDT
 .S ID="BEHOXQ"
 .S SUB="Provider CS Profile Tampering"
 .S XTR="PRI=1"
 .S MSG(1,0)="The provider profile of "_NAME_" has been tampered.  Please investigate immediately!!"
 .S GROUP="BEHO EPCS INCIDENT RESPONSE"
 .S RCP=$O(^XMB(3.8,"B",GROUP,""))
 .S RCP=-RCP
 .D SCHALR^BEHOXQ(.DATA,ATIME,ID,SUB,XTR,.MSG,RCP)
 Q
 ;
ADDCHK(RET,DFN,PRV,FLG) ;Check addresses for providers/patients
 ;Returns 1 for a match, 0 for not matching
 N CITY,STREET,STATE,ZIP,ORINST,VAPA,VAIP
 S RET=1,FLG=+$G(FLG)
 I FLG=0!(FLG=1) D       ;Patient check
 .Q:'+DFN
 .D ADD^VADPT
 .S STREET=$$TRIM^XLFSTR(VAPA(1))
 .S CITY=$$TRIM^XLFSTR(VAPA(4))
 .S STATE=$$TRIM^XLFSTR(VAPA(5))
 .S ZIP=$$TRIM^XLFSTR(VAPA(6))
 .I $G(STREET)=""!($G(CITY)="")!($G(STATE)="")!($G(ZIP)="") S RET="0^Patient"
 Q:FLG=1!($P(RET,U,1)=0)
 I FLG=0!(FLG=2) D       ;Provider check
 .Q:'+PRV
 .D GETS^DIQ(4,DUZ(2),".01;.02;1.01;1.02;1.03;1.04","E","ORINST")
 .I $L(ORINST(4,DUZ(2)_",",1.01,"E"))=0 S RET="0^Provider"
 .I $L(ORINST(4,DUZ(2)_",",1.03,"E"))=0 S RET="0^Provider"
 .I $L(ORINST(4,DUZ(2)_",",.02,"E"))=0  S RET="0^Provider"
 .I $L(ORINST(4,DUZ(2)_",",1.04,"E"))=0 S RET="0^Provider"
 Q
 ;
MAIL(CHK) ;Send message in mailman
 N XMDUZ,XMY,XMSUM,XMTEXT
 K ^TMP($J,"EPCD FAIL")
 S XMTEXT="^TMP("_$J_",""EPCS FAIL"","
 S XMDUZ="EPCS,SYSTEM"
 S XMY("G.BEHO EPCS INCIDENT RESPONSE")=""
 S XMSUB="EPCS SYSTEM FAILURE ON SIGNING"
 S ^TMP($J,"EPCS FAIL",1,0)="Time of incident: "_$$NOW^XLFDT
 S ^TMP($J,"EPCS FAIL",2,0)=CHK
 D ^XMD Q
