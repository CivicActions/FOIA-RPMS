VENRPC ; GDIT/HS/BEE - Well Child RPC calls ;
 ;;2.6;PCC+;**8**;NOV 16, 2007;Build 13
 ;
 ;
AUDIT(DATA,DFN,TYPE) ;EP - VEN AUDIT EVENT
 ;
 ;This RPC creates a specified BUSA audit event for a patient
 ;
 ;Input parameter:
 ;  DFN   - Patient DFN
 ; TYPE   - The type of audit event to create
 ;          Permitted value:
 ;          ASQQ - User printed an Ages and Stages Questionnaire
 ;          ASQT - User entered or attempted to enter ASQ scores for today
 ;          ASQH - User entered or attempted to enter ASQ historical scores
 ;          PGCP - User printed Pediatric Growth Chart for patient
 ;
 ;Input checks
 I $G(DFN)="" S BMXSEC="Missing patient DFN value" G XAUDIT
 S TYPE=$G(TYPE)
 I TYPE'="ASQQ",TYPE'="ASQT",TYPE'="ASQH",TYPE'="PGCP" S BMXSEC="Invalid audit event type value" G XAUDIT
 ;
 NEW UID,VENDFN,STS,VENDESC,ACTION
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("VENRPC",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPCHK D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(0)="T00001SUCCESS"_$C(30)
 ;
 ;Set up the description
 S VENDESC=""
 I TYPE="ASQQ" S VENDESC="VEN: User printed an Ages and Stages Questionnaire"
 E  I TYPE="ASQT" S VENDESC="VEN: User entered or attempted to enter ASQ scores for today"
 E  I TYPE="ASQH" S VENDESC="VEN: User entered or attempted to enter ASQ historical scores"
 E  I TYPE="PGCP" S VENDESC="VEN: User printed Pediatric Growth Chart for patient"
 ;
 ;Define DFN for audit call
 S VENDFN(1)=DFN
 ;
 ;Define the action
 S ACTION=$S(TYPE="ASQQ":"P",TYPE="PGCP":"P",1:"A")
 ;
 ;Make the audit call
 S STS=$$LOG^BUSAAPI("A","P",ACTION,"VEN AUDIT EVENT",VENDESC,"VENDFN")
 ;
 ;Return 
 S @DATA@(1)="1"_$C(30)
 ;
XAUDIT S @DATA@(2)=$C(31)
 ;
 Q
