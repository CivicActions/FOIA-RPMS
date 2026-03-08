BSTSUTL0 ;GDIT/HS/BEE-Standard Terminology Utility Program 1 ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**3,6**;Dec 01, 2016;Build 5
 ;
 Q
 ;
TIME(X) ;Input transform - return valid time
 ;
 NEW HH,MM
 ;
 ;Input check
 I X["AM" D
 . S X=$TR(X," ")
 . S X=$TR(X,"AM")
 . S:X?3N X="0"_X
 . S HH=$E(X,1,2)
 . I X>12 S X=""
 ;
 I X["PM" D
 . S X=$TR(X," ")
 . S X=$TR(X,"PM")
 . S:X?3N X="0"_X
 . S HH=$E(X,1,2)+12
 . S $E(X,1,2)=HH
 ;
 S X=$TR($G(X),":") I X="" Q -1
 S:X?3N X="0"_X
 I X'?4N Q -1
 ;
 ;Hour check
 S HH=+$E(X,1,2) I (HH<0)!(HH>23) Q -1
 ;
 ;Minute check
 S MM=+$E(X,3,4) I (MM<0)!(MM>59) Q -1
 ;
 S X=$E(X,1,2)_":"_$E(X,3,4)
 ;
 Q X
 ;
JBTIME(TOM) ;Calculate job time
 ;
 NEW STS,BSTSARY,%,TIME,PSTRT,PSRV
 ;
 ;TOM - (1) If after process scheduled runtime already schedule for tomorrow
 S TOM=$G(TOM)
 S PSTRT=""
 ;
 ;Get server list
 S STS=$$WSERVER^BSTSWSV(.BSTSARY,"")
 S PSRV=$O(BSTSARY(""))
 I PSRV]"" S PSTRT=$G(BSTSARY(PSRV,"PSTRT"))
 S:PSTRT="" PSTRT="18:02"
 S PSTRT=$TR(PSTRT,":")
 ;
 D NOW^%DTC
 ;
 ;After runtime
 I +$E($P(%,".",2)_"000000",1,4)'<PSTRT D  Q TIME
 . I 'TOM S TIME=$$FMADD^XLFDT($$NOW^XLFDT(),,,1) Q
 . NEW X1,X2,X
 . S X1=$P(%,"."),X2=1 D C^%DTC
 . S TIME=X_"."_PSTRT_"00"
 ;
 ;Return schedule time
 Q DT_"."_PSTRT_"00"
 ;
DEQUE(TAG,RTN) ;De-Queue a definition task
 ;
 I $G(RTN)="" Q
 S TAG=$G(TAG)
 ;
 NEW ZT1,ZTS
 ;
 ;Get Taskman Processes
 S ZT1=$$H3^%ZTM($H) F  S ZT1=$O(^%ZTSCH(ZT1)) Q:'ZT1  D
 . S ZTS=0 F  S ZTS=$O(^%ZTSCH(ZT1,ZTS)) Q:'ZTS  D
 .. ;
 .. NEW TASKND,DPIEN
 .. ;
 .. ;Get the task
 .. S TASKND=$G(^%ZTSK(ZTS,0)) Q:TASKND=""
 .. I $P(TASKND,U,2)'=RTN Q
 .. I TAG]"",$P(TASKND,U)'=TAG Q
 .. ;
 .. ;De-Queue the task
 .. S ZTSK=ZTS D KILL^%ZTLOAD
 ;
 Q
 ;
DTSON() ;Return if DTS link if set to local
 ;
 NEW PIEN,IEN,BSTSWS
 ;
 ;Get the IEN of the priority 1 entry multiple
 S PIEN=$O(^BSTS(9002318,1,1,"C",1,"")) I PIEN="" Q 1
 ;
 ;Get the IEN to BSTS WEB SERVICE
 S IEN=$P($G(^BSTS(9002318,1,1,PIEN,0)),U) I 'IEN Q 1
 ;
 S BSTSWS("IEN")=IEN
 S BSTSWS("TBYPASS")=0
 ;
 ;Get the status
 S STS=$$CKDTS^BSTSWSV1(.BSTSWS)
 ;
 Q $P(STS,U)
 ;
 ;
ESC(X) ; Escape string for REST call
 N Y,I,PAIR,FROM,TO,ASC,FILTER
 ;
 ;Remove disallowed characters
 S FILTER="'{"
 F ASC=0:1:31 S FILTER=FILTER_$C(ASC)
 S X=$TR(X,FILTER)
 S Y=X
 Q Y
 ;
 ;
UCODE(C) ; Return \u00nn representation of decimal character value
 N H S H="0000"_$$CNV^XLFUTL(C,16)
 Q "\u"_$E(H,$L(H)-3,$L(H))
