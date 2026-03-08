BUSAACVR ;GDIT/HS/BEE-IHS USER SECURITY AUDIT Access Program ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;**3,4**;Nov 05, 2013;Build 71
 ;
 Q
 ;
 ;GDIT/HS/BEE 01/15/2020;CR#11519 - BUSA*1.0*3 - Handle passed in application
 ;CHECKAV(BUSAAV) ;EP - Authenticate AC/VC and Return DUZ
CHECKAV(BUSAAV,BUSAAPP) ;EP - Authenticate AC/VC and Return DUZ
 ;
 ; Input: BUSAAV - ACCESS CODE_";"_VERIFY CODE
 ; Output: DUZ value
 ;
 N BUSADUZ,XUF
 ;
 ;GDIT/HS/BEE 01/15/2020;CR#11519 - BUSA*1.0*3 - Handle passed in application
 S BUSAAPP=$S($G(BUSAAPP)]"":BUSAAPP,1:"BUSA Zen Report")
 ;
 S:$G(U)="" U="^"
 S:$G(DT)="" DT=$$DT^XLFDT
 ;
 S XUF=0
 S BUSADUZ=$$CHECKAV^XUS(BUSAAV,BUSAAPP)
 I BUSADUZ=0 Q 0
 ;
 ;Return DUZ if user inactive
 I (+$P($G(^VA(200,BUSADUZ,0)),U,11)'>0)!(+$P($G(^VA(200,BUSADUZ,0)),U,11)'<DT) Q BUSADUZ
 Q 0
 ;
AUTH(BUSADUZ,BUSAAPP) ;EP - Authenticate User for BUSA REPORT Access
 ;
 ; Input: BUSADUZ - User's DUZ value
 ; Output: 0 - No Authorized/1 - Authorized
 ;
 N BUSAKEY,EXEC,GL,APP,CALL
 ;
 S:$G(U)="" U="^"
 ;
 S CALL=$S($P($G(BUSAAPP),U)]"":$P(BUSAAPP,U),1:"BUSA")
 S APP=$S($P($G(BUSAAPP),U,2)]"":$P(BUSAAPP,U,2),1:"")
 ;
 I $G(BUSADUZ)<1 Q 0
 S BUSAKEY=$O(^DIC(19.1,"B","BUSAZRPT","")) I BUSAKEY="" Q 0
 I '$D(^VA(200,"AB",BUSAKEY,BUSADUZ,BUSAKEY)) D  Q 0
 . ;
 . ;Audit the failed login
 . D LOG^BUSAUTL1(BUSADUZ,"S","",CALL,"XU: BUSA"_$S(APP]"":" "_APP,1:"")_" Report - Failed System Login Attempt - Missing Security Key"_"|TYPE~L|RSLT~F||||BUSA101","")
 ;
 ;Now check if user defined in Cache User Access class
 S EXEC="S GL=$NA(^BUSA.UsersI(""StatusUserIdx"",""A""))" X EXEC
 I '$D(@GL@(" "_BUSADUZ)) D  Q 0
 . ;
 . ;Audit the failed login
 . D LOG^BUSAUTL1(BUSADUZ,"S","",CALL,"XU: BUSA"_$S(APP]"":" "_APP,1:"")_" Report - Failed System Login Attempt - Unauthorized BUSA report user"_"|TYPE~L|RSLT~F||||BUSA101","")
 ;
 Q 1
 ;
RAUTH(BUSADUZ,BUSAAPP) ;EP - Authenticate User for BUSA Remediation Utility Access
 ;
 ; Input: BUSADUZ - User's DUZ value
 ; Output: 0 - No Authorized/1 - Authorized
 ;
 N BUSAKEY,EXEC,GL,APP,CALL
 ;
 S:$G(U)="" U="^"
 ;
 S CALL=$S($P($G(BUSAAPP),U)]"":$P(BUSAAPP,U),1:"BUSA")
 S APP=$S($P($G(BUSAAPP),U,2)]"":$P(BUSAAPP,U,2),1:"")
 ;
 I $G(BUSADUZ)<1 Q 0
 S BUSAKEY=$O(^DIC(19.1,"B","BUSAZREMEDIATION","")) I BUSAKEY="" Q 0
 I '$D(^VA(200,"AB",BUSAKEY,BUSADUZ,BUSAKEY)) D  Q 0
 . ;
 . ;Audit the failed login
 . D LOG^BUSAUTL1(BUSADUZ,"S","",CALL,"XU: BUSA"_$S(APP]"":" "_APP,1:"")_" Report - Failed System Login Attempt - Missing Security Key"_"|TYPE~L|RSLT~F||||BUSA103","")
 ;
 ;Now check if user defined in Cache User Access class
 S EXEC="S GL=$NA(^BUSA.Remediation.UsersI(""StatusUserIdx"",""A""))" X EXEC
 I '$D(@GL@(" "_BUSADUZ)) D  Q 0
 . ;
 . ;Audit the failed login
 . D LOG^BUSAUTL1(BUSADUZ,"S","",CALL,"XU: BUSA"_$S(APP]"":" "_APP,1:"")_" Report - Failed System Login Attempt - Unauthorized BUSA Remediation Utility user"_"|TYPE~L|RSLT~F||||BUSA104","")
 ;
 Q 1
