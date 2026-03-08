BEDDGET ;GDIT/HS/BEE-BEDD Utility Routine ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;**1,4**;Jun 04, 2014;Build 19
 ;
 ;GDIT/HS/BEE 01/15/19;BEDD*2.0*4;CR#8011 - Sync Chief Complaint
 ;
 Q
 ;
 ;GDIT/HS/BEE 01/15/19;BEDD*2.0*4;CR#8011 - Sync Chief Complaint
 ;Return chief complaint specified
GETCC(BEDDCC) ;EP - Return specified Chief Complaint
 ;
 I '$G(BEDDCC) Q ""
 ;
 NEW LN,CC,CMD,CBY
 ;
 ;Pull the entry
 I '$D(^AUPNVNT(BEDDCC,11,0)) Q ""
 S LN=0 F  S LN=$O(^AUPNVNT(BEDDCC,11,LN)) Q:'LN  D
 . S CC=$G(CC)_$S(LN>1:$C(13,10),$G(CC)="":"",1:$C(13,10))_$G(^AUPNVNT(BEDDCC,11,LN,0))
 ;
 ;Retrieve modified by and when
 S CBY=$$GET1^DIQ(9000010.34,BEDDCC_",",1219,"E") ;External Modified By
 S CMD=$$FMTE^BEDDUTIL($$GET1^DIQ(9000010.34,BEDDCC_",",1218,"I")) ;Last modified date/time
 ;
 Q CC_"^"_CBY_"^"_CMD
 ;
 ;GDIT/HS/BEE 01/15/19;BEDD*2.0*4;CR#8011 - Sync Chief Complaint
 ;Save chief complaint
SAVE(BEDDIEN,BEDDVIEN,BEDDCOMP) ;EP - Save the chief complaint into V NARRATIVE TEXT
 ;
 NEW RET,CC,I
 ;
 S (CC,RET)=""
 ;
 ;Tack on $c(13) which is needed by RPC call
 S BEDDCOMP=$TR(BEDDCOMP,$C(13))  ;Strip out any $c(13) that might be there
 S BEDDCOMP=$TR(BEDDCOMP,"^")
 F I=1:1:$L(BEDDCOMP,$C(10)) S CC=CC_$S((I>1):$C(13,10),CC]"":$C(13,10),1:"")_$P(BEDDCOMP,$C(10),I)
 ;
 ;Utilize the EHR RPC API to add/update the entry
 D SET^BGOCC(.RET,+BEDDVIEN_U_$G(BEDDIEN)_U_CC)
 ;
 Q RET
 ;
 ;GDIT/HS/BEE 01/15/19;BEDD*2.0*4;CR#8011 - Sync Chief Complaint
 ;Delete chief complaint
DEL(BEDDIEN) ;EP - Delete the chief complaint from V NARRATIVE TEXT
 ;
 NEW RET
 ;
 S RET=""
 ;
 ;Utilize the EHR RPC API to delete the entry
 D DEL^BGOCC(.RET,+BEDDIEN)
 ;
 Q RET
 ;
 ;GDIT/HS/BEE 01/15/19;BEDD*2.0*4;CR#8011 - Sync Chief Complaint
 ;Added DETAIL input parameter
GETCHIEF(BEDDIEN,BEDDCOMP,TYPE,CCLIST,LATEST,DETAIL) ;EP - Get V NARRATIVE TEXT
 ;
 ; Input:
 ; BEDDIEN - V NARRATIVE TEXT Entry IEN
 ; BEDDCOMP - BEDD.EDVISIT - Complaint field value
 ;     TYPE - Return type - P - Presenting, C - Chief, Null - All
 ; DETAIL - Return detailed chief complaint information
 ;
 ; Output:
 ; V NARRATIVE TEXT (1st) or Complaint value (2nd)
 ; CCLIST - Array of chief complaint entries
 ;
 ;Error Trap
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDGET D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S TYPE=$G(TYPE)
 S BEDDCOMP=$G(BEDDCOMP)
 S BEDDIEN=$G(BEDDIEN)
 S LATEST=$G(LATEST)
 S DETAIL=$G(DETAIL)
 ;
 ;Return only presenting complaint
 I BEDDCOMP="" D
 . NEW DFN
 . S DFN=$$GET1^DIQ(9000010,BEDDIEN_",",.05,"I") Q:DFN=""
 . S BEDDCOMP=$$GET1^DIQ(9009081,DFN_",",23,"E")
 I TYPE="P" Q BEDDCOMP
 ;
 ;Retrieve V NARRATIVE TEXT entries
 NEW BEDDCTXT
 S BEDDCTXT=""
 ;
 I $G(BEDDIEN)]"",$D(^AUPNVNT("AD",BEDDIEN)) D
 . NEW BEDDCC
 . S BEDDCC="" F  S BEDDCC=$O(^AUPNVNT("AD",BEDDIEN,BEDDCC),-1) Q:'BEDDCC  D  I $G(BEDDCTXT)]"",LATEST Q
 .. ;
 .. ;Pull the entry
 .. I $D(^AUPNVNT(BEDDCC,11,0)) D
 ... N LN
 ... S CCLIST=$G(CCLIST)+1
 ... S LN=0 F  S LN=$O(^AUPNVNT(BEDDCC,11,LN)) Q:'LN  D
 .... S BEDDCTXT=$G(BEDDCTXT)_$S(BEDDCTXT="":"",1:" ")_$G(^AUPNVNT(BEDDCC,11,LN,0))
 .... S CCLIST(CCLIST)=$G(CCLIST(CCLIST))_$S((DETAIL&(LN>1)):"<BR>",$G(CCLIST(CCLIST))="":"",DETAIL:"<BR>",1:"; ")_$G(^AUPNVNT(BEDDCC,11,LN,0))
 ... ;
 ... ;GDIT/HS/BEE 01/15/19;BEDD*2.0*4;CR#8011 - Sync Chief Complaint
 ... ;Add in detail
 ... I +DETAIL D
 .... S $P(CCLIST(CCLIST),U,2)=BEDDCC  ;IEN
 .... S $P(CCLIST(CCLIST),U,3)=$$GET1^DIQ(9000010.34,BEDDCC_",",1219,"I") ;Modified by DUZ
 .... S $P(CCLIST(CCLIST),U,4)=$$GET1^DIQ(9000010.34,BEDDCC_",",1219,"E") ;External Modified By
 .... S $P(CCLIST(CCLIST),U,5)=$$GET1^DIQ(9000010.34,BEDDCC_",",1218,"I") ;Last modified date/time
 .... S $P(CCLIST(CCLIST),U,6)=$$FMTE^BEDDUTIL($P(CCLIST(CCLIST),U,5)) ;Last modified - external
 ;
 ;If request for all, add the presenting complaint
 I TYPE="" D
 . I LATEST,BEDDCTXT]"" Q
 . S BEDDCTXT=BEDDCTXT_$S(BEDDCTXT="":"",1:"; ")_BEDDCOMP
 . S CCLIST=$G(CCLIST)+1
 . S CCLIST(CCLIST)=BEDDCOMP
 ;
 Q BEDDCTXT
 ;
 ;
ERR ;
 D ^%ZTER
 Q
