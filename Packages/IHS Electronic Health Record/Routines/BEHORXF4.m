BEHORXF4 ;MSC/IND/PLS - Support for EHR continued;12-Jun-2018 09:34;DU
 ;;1.1;BEH COMPONENTS;**009013,009014**;Sep 18, 2007;Build 1
 ;=================================================================
 ; RPC: BEHORXF4 ERXCANCP
 ; Returns boolean value (0/1) of the following condition
 ;    A true value will cause the RPMS EHR order cancel process to
 ;    confirm that the user wishes to cancel an eRX order.
 ;      Prescription has been transmitted and last activity is not
 ; Input: OIEN - Order IEN
ERXCANCP(DATA,OIEN) ;EP-
 N RXIEN
 S RXIEN=+$$GETPSIFN^BEHORXFN(OIEN)
 S DATA=$$CKRXACT^APSPFNC6(RXIEN,"X","T")&($$LASTACT^APSPFNC6(RXIEN,"X")'="F")
 Q
NOTIF(RET,LST) ;Send an unsigned order alert to the ordering provider
 N ORB,ORVP,ORNP,IEN,ORZREC8,ORZSIGDT,ORZSTS
 S IEN=0
 F  S IEN=$O(LST(IEN)) Q:IEN=""  D
 .S ORIFN=$G(LST(IEN))
 .I $D(^OR(100,+ORIFN,8,1,0)) D
 ..S ORZREC8=^OR(100,+ORIFN,8,1,0)
 ..S ORZSIGDT=$P(ORZREC8,U,6)
 ..Q:$L(ORZSIGDT)>0
 ..S ORZSTS=$P(ORZREC8,U,4)
 ..Q:ORZSTS'=2
 ..S ORVP=$$GET1^DIQ(100,+ORIFN,.02,"I")
 ..S ORNP=$$GET1^DIQ(100,+ORIFN,1,"I")
 ..S ORB=+ORVP_U_+ORIFN_U_ORNP_"^^^^^1"
 ..D EN^OCXOERR(ORB)
 S RET=1
 Q
 ;Returns value for maximum days supply allowed for orderable item
 ;Input: OIIEN - Orderable Item IEN
MAXDAYS(RET,OI) ;EP-
 I $$CHKSCH(OI,"2345") D
 .N C2,C3,C4,C5,PARAM
 .S PARAM="BEHORX MAX DAYS SUPPLY CS"
 .I $$CHKSCH(OI,"2") D GETPAR^CIAVMRPC(.RET,PARAM,,2)
 .I $$CHKSCH(OI,"3") D GETPAR^CIAVMRPC(.RET,PARAM,,3)
 .I $$CHKSCH(OI,"4") D GETPAR^CIAVMRPC(.RET,PARAM,,4)
 .I $$CHKSCH(OI,"5") D GETPAR^CIAVMRPC(.RET,PARAM,,5)
 .S:'RET RET=30
 E  D GETPAR^CIAVMRPC(.RET,"BEHORX MAX DAYS SUPPLY")
 Q
 ;
CHKSCH(OI,SCH) ;EP-
 N RET
 D DEAOICLS^APSPFNC6(.RET,OI,SCH)
 Q RET
