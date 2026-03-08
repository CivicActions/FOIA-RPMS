APSPPAL5 ;IHS/MSC/PLS - Pickup Activity Log Support ;29-Aug-2024 14:07;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1035**;Sep 23, 2004;Build 39
 ;FID 99319
 ;Input: TYPE - (D)Dispense Type
 ;              (PT)Person Type
 ;              (PR)Person Relationship
 ;              (PJ)Person ID Jurisdiction
 ;              {PQ)Person ID Qualifier
 ;              (PS)Person State
 ;Output: DATA - Format IEN:Label
GLSTITMS(DATA,TYPE) ;-
 K DATA,D,LP,CTR
 Q:'$L($G(TYPE))
 S CTR=0
 I TYPE="D" D
 .D BLDARY(.DATA,.03)
 E  I TYPE="PT" D
 .D BLDARY(.DATA,.04)
 E  I TYPE="PR" D
 .D BLDARY(.DATA,.05)
 E  I TYPE="PJ" D
 .D BLDARY(.DATA,.06)
 E  I TYPE="PQ" D
 .D BLDARY(.DATA,.07)
 E  I TYPE="PS" D
 .;D BLDARY(.DATA,4.02)
 .S LP=0 F  S LP=$O(^DIC(5,LP)) Q:'LP  D
 ..Q:$L($P($G(^DIC(5,LP,9999999.01)),U))
 ..S D=^DIC(5,LP,0)
 ..S DATA($$CTR)=LP_U_$P(D,U)
 Q
GETPTR(FLD) ;-
 N D
 Q:'FLD ""
 D FIELD^DID(52.999999951,FLD,"","POINTER","D")
 Q $G(D("POINTER"))
BLDARY(DATA,FLD) ;-
 N V,S,D
 S V=$$GETPTR(FLD)
 Q:'$L($G(V))
 I V[";" D
 .F LP=1:1:$L(V,";") S S=$P(V,";",LP) Q:S=""  S DATA($$CTR)=$TR(S,":",U)
 E  D
 .S V=U_$P(V,"(")
 .S LP=0 F  S LP=$O(@V@(LP)) Q:'LP  D
 ..S D=@V@(LP,0)
 ..Q:$P(D,U,2)  ;Inactive
 ..S DATA($$CTR)=LP_U_$P(D,U)
 Q
CTR() ;-
 S CTR=$G(CTR)+1
 Q CTR
