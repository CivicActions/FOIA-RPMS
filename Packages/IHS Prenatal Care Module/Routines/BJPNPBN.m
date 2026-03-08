BJPNPBN ;GDIT/HS/BEE-Prenatal Care Module - Brief Note Handling ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**11**;Feb 24, 2015;Build 7
 ;
 Q
 ;
ONOFF(DATA) ;EP - BJPN PRENATAL NOTE ENABLED
 ;
 NEW UID,II,ENABLE
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPBN",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPBN D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Set up Header
 S @DATA@(II)="I00010ENABLED"_$C(30)
 ;
 ;First look in XPAR parameter
 D GETPAR^CIAVMRPC(.RET,"BJPN PRENATAL NOTE ENABLED","",1,"I",DUZ)
 S ENABLE=0
 I (RET=1)!(RET="") S ENABLE=1
 ;
 S II=II+1,@DATA@(II)=ENABLE_$C(30)
 ;
XONOFF S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
MAKE(DATA,DFN,TITLE,VDT,VLOC,VSIT,TIUX,VSTR,SUPPRESS,NOASF) ;EP - BJPN TIU CREATE RECORD
 ;
 ;This RPC is a BJPN wrapper for the existing TIU CREATE RECORD RPC call. 
 ;It accepts the input parameters in the same format as the TIE CREATE 
 ;RECORD call except that the TIUX parameter is passed in as a string 
 ;instead of as an array (as variable BTIUX). This call formats the TIUX 
 ;parameter to match the format expected by the TIUX parameter in TIU 
 ;CREATE RECORD and then calls TIU CREATE RECORD.
 ;
 ;Input:  See MAKE^TIUSRVP for information on parameters other than BTIUX (TIUX).
 ;
 ;BTIUX - Format: 
 ;fld 1# *29 fld 1 val *28 fld 2# *29 fld 2 val *28 field 3# *29 fld 3 val... 
 ;
 NEW UID,II,RET,TIEN,TIUX,FLD,VAL,PC,PVAL
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPBN",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPBN D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Set up Header
 S @DATA@(II)="I00010TIUIEN^T01024ERROR_MESSAGE"_$C(30)
 ;
 ;Parse BTIUX into TIUX
 F PC=1:1:$L($G(BTIUX),$C(28)) S PVAL=$P(BTIUX,$C(28),PC) I PVAL]"" D
 . S FLD=$P(PVAL,$C(29)),VAL=$P(PVAL,$C(29),2) I FLD]"" S TIUX(FLD)=VAL
 ;
 ;Make the call
 D MAKE^TIUSRVP(.SUCCESS,$G(DFN),$G(TITLE),$G(VDT),$G(VLOC),$G(VSIT),.TIUX,$G(VSTR),$G(SUPPRESS),$G(NOASF))
 ;
 ;Format Output
 I +$G(SUCCESS) S II=II+1,@DATA@(II)=+SUCCESS_U_$C(30)
 E  S II=II+1,@DATA@(II)="0^"_$P(SUCCESS,U,2)
 ;
XMAKE S II=II+1,@DATA@(II)=$C(31)
 ;
 Q
 ;
GNOTE(DATA) ;EP - BJPN GET BRIEF NOTE IEN
 ;
 ;This RPC returns the IEN of the TIU note definition to be used as the prenatal brief note
 ;
 ;Input:  None (DUZ)
 ;
 NEW UID,II,RET,TIEN
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPBN",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPBN D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Set up Header
 S @DATA@(II)="I00010TIUIEN"_$C(30)
 ;
 ;First look in XPAR parameter
 D GETPAR^CIAVMRPC(.RET,"BJPN PRENATAL CARE NOTE","",1,"I",DUZ)
 S TIEN=$G(RET)
 ;
 ;If no custom set, look for default
 S TIEN=$O(^TIU(8925.1,"B","PRENATAL CARE NOTE-BRIEF",""))
 S:TIEN="" TIEN="-1"
 ;
 S II=II+1,@DATA@(II)=TIEN_$C(30)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HASNOTE(DATA,DOC,VIEN,PRV) ;EP - BJPN PROVIDER HAS NOTE
 ;
 ;This RPC returns IEN of a TIU note if the document type specified exists for
 ;the provider for the specified visit and returns 0 for no document.
 ;
 ;Input:
 ;  DOC - Document type IEN (pointer to 8925.1)
 ; VIEN - Visit IEN (pointer to 9000010)
 ;  PRV - Provider IEN (pointer to 200)
 ;
 ;Returns:
 ;  TIUIEN - Document IEN (Pointer to 8925)
 ;
 NEW UID,II,TIEN,IEN
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPBN",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0,TIEN=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPBN D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Set up Header
 S @DATA@(II)="I00010TIUIEN"_$C(30)
 ;
 I $G(VIEN)="" S TIEN="-1" G XHNOTE
 I $G(DOC)="" S TIEN="-1" G XHNOTE
 I $G(PRV)="" S TIEN="-1" G XHNOTE
 ;
 ;Loop through documents for visit
 S IEN="" F  S IEN=$O(^TIU(8925,"V",VIEN,IEN)) Q:IEN=""  D  Q:TIEN
 . NEW DTYP,DPRV
 . ;
 . ;Check for matching document type
 . S DTYP=$$GET1^DIQ(8925,IEN_",",.01,"I") I DOC'=DTYP Q
 . ;
 . ;Check for matching provider
 . S DPRV=$$GET1^DIQ(8925,IEN_",",1202,"I") I PRV'=DPRV Q
 . ;
 . ;Check for delete
 . I $$GET1^DIQ(8925,IEN_",",1611,"I")]"" Q
 . ;
 . ;Found a match
 . S TIEN=IEN
 ;
XHNOTE S II=II+1,@DATA@(II)=TIEN_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
