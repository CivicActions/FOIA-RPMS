BARDUTL0 ; IHS/SD/SDR - DATE UTILITIES FOR A/R PACKAGE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;
 ;IHS/SD/SDR 1.8*35 ADO77760 Added calculated field logic for A/R Collection Batch/IHS file, field 31 BATCH LOCKDOWN DATE
 ;
BLDRDT(Y) ; A/R Collection Batch/IHS field, #31 BATCH LOCKDOWN DATE
 ;Note: had MUMPS CODE:S X=$$FMADD^XLFDT($P($P(^BARCOL(DUZ(2),D0,0),"^",4),"."),180) in field but they wanted it to be exactly
 ; six months, not 180 days; just noting here in case we have to go back for some reason
 N LDT,LYR,LMTH,LDAY,BARLDT
 I +$G(Y)'=0 S LDT=$P($P($G(^BARCOL(DUZ(2),Y,0)),"^",25),".")
 E  S LDT=DT
 I LDT="" Q LDT
 S LYR=$E(LDT,1,3)
 S LMTH=$E(LDT,4,5)
 S LDAY=$E(LDT,6,7)
 I LMTH="01" S LMTH="07" G SET
 I LMTH="02" S LMTH="08" G SET
 I LMTH="03" S LMTH="09" G SET
 I LMTH="04" S LMTH="10" G SET
 I LMTH="05" S LMTH="11" G SET
 I LMTH="06" S LMTH="12" G SET
 I LMTH="07" S LMTH="01" G SET
 I LMTH="08" S LMTH="02" G SET
 I LMTH="09" S LMTH="03" G SET
 I LMTH="10" S LMTH="04" G SET
 I LMTH="11" S LMTH="05" G SET
 I LMTH="12" S LMTH="06"
SET ;
 I LMTH<6 S LYR=LYR+1
 S BARLDT=LYR_LMTH_LDAY
 Q $S(+$G(Y)=0:BARLDT,1:$$SDT^BARDUTL(BARLDT))
UNFRMDT(X) ;
 N Y
 S Y=($P(X,"/",3)-1700)_$P(X,"/",1)_$P(X,"/",2)
 Q Y
