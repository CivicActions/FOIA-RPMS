BCCDMON ;GDIT/HS/GCD-Application Monitor; 16 Jun 2016  4:31 PM
 ;;1.0;CCDA;**6**;Feb 21, 2014;Build 46
 Q
 ;
EN ; TaskMan Entry Point
 N CENABLED,CSTATUS,OBJ,ISOBJ,AGE
 ; Check whether the CCDA background job is running
 I $G(^BCCDMON("IGNOREJOB")) G PROD
 S CENABLED=($P($G(^BCCDS(90310.01,1,0)),U,4)="Y")
 S CSTATUS=($$LOCK^BCCDPAT("^BCCDTSK")'=0)
 ; Job is not running
 I 'CSTATUS D
 . I 'CENABLED D NOTIF("CCDA processing task is not running") Q
 . D NOTIF("CCDA processing task is supposed to be running but it is not running") Q
 I CSTATUS&&('CENABLED) D NOTIF("CCDA processing task is supposed to be stopped but it is running")
 ;
PROD ; Check whether the production status is current
 I $G(^BCCDMON("IGNOREPROD")) G SKIPPROD
 X "S OBJ=##class(BCCD.Audit.ProductionStatus).%OpenId(1) S ISOBJ=$IsObject(OBJ)"
 I 'ISOBJ D NOTIF("Unable to obtain CCDA production status") G SKIPPROD
 I OBJ.UpdateTimestamp=""||(OBJ.Status="") D NOTIF("Unable to obtain CCDA production status") G SKIPPROD
 S AGE=$$AGE(OBJ.UpdateTimestamp)
 I AGE="" D NOTIF("Unable to obtain CCDA production status") G SKIPPROD
 I AGE["day" D NOTIF("CCDA production status has not been updated in "_AGE) G SKIPPROD
 ;
 ; Check whether the production is running
 ; 0 = Unknown
 ; 1 = Running
 ; 2 = Stopped
 ; 3 = Suspended
 ; 4 = Troubled
 ; 5 = Network stopped
 I OBJ.Status=0 D NOTIF("Ensemble cannot determine CCDA production status")
 I OBJ.Status=2 D NOTIF("CCDA production is stopped")
 I OBJ.Status=3 D NOTIF("CCDA production is suspended")
 I OBJ.Status=4 D NOTIF("CCDA production is troubled")
 I OBJ.Status=5 D NOTIF("CCDA production is stopped (network stopped)")
SKIPPROD ;
 Q
 ;
 ; Calculate age in minutes (if less than two hours), hours (if less than two days), or days
AGE(TS) ;
 N TSH,NOW,DIFF
 ; Validate timestamp parameter
 S TSH=$ZDTH(TS,3,1,,,,,,,"")
 I TSH="" Q ""
 ; Make sure the timestamp is in the past
 S NOW=$H
 I TSH>NOW Q ""
 I +TSH=+NOW&&($P(TSH,",",2)>$P(NOW,",",2)) Q ""
 ; If difference is less than two hours, return age in minutes
 X "S DIFF=$SYSTEM.SQL.DATEDIFF(""minute"",TS,NOW)"
 I DIFF<121 Q DIFF_" minute"_$S(DIFF=1:"",1:"s")
 ; If difference is less than two days, return age in hours
 X "S DIFF=$SYSTEM.SQL.DATEDIFF(""hour"",TS,NOW)"
 I DIFF<48 Q DIFF_" hour"_$S(DIFF=1:"",1:"s")
 ; Otherwise, return age in days
 X "S DIFF=$SYSTEM.SQL.DATEDIFF(""day"",TS,NOW)"
 Q DIFF_" day"_$S(DIFF=1:"",1:"s")
 ;
 ; Send notification
NOTIF(MSG) ; EP
 N XQA,XQAMSG
 I $G(MSG)="" Q
 S XQAMSG=$G(MSG)
 S XQA("G.BCCD CCDA")=""
 D SETUP^XQALERT
 Q
