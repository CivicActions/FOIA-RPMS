AMHESIG ; IHS/CMI/LAB - ADD NEW MHSS ACTIVITY RECORDS ; 13 Aug 2007  4:21 PM
 ;;3.0;IHS BEHAVIORAL HEALTH;**10**;JAN 27, 2003
 ;
 ;
ESIG(R) ;EP - called for esig
 NEW X1,DA,DR,DIE
 Q:'$$ESIGREQ(R)  ;not required
 Q:$P($G(^AMHREC(R,11)),U,10)  ;no EHR visits
 I DUZ'=$$PPINT^AMHUTIL(R) D  Q
 .W !!,"Only the primary provider is permitted to sign the encounter."
 .W !,"The encounter will be saved as 'unsigned'."  ;user is not primary provider
 .D PAUSE^AMHLEA
 Q:$P($G(^AMHREC(R,11)),U,12)]""  ;already signed
 D SIG^XUSESIG
 I X1="" Q
 S DIE="^AMHREC(",DA=R,DR="1112///NOW;1113///"_$P($G(^VA(200,DUZ,20)),U,2) D ^DIE K DA,DIE,DR
 I $D(Y) W !!,"Error updating electronic signature...see your supervisor for programmer help."
 K X1
 Q
 ; 
ESIGREQ(R,D) ;EP - is esig required on this visit?
 Q 0  ;NOT TILL VERSION 4
 NEW SD,G
 S R=$G(R)
 S D=$G(D)
 I '$P($G(^AMHSITE(DUZ(2),18)),U,6) Q 0
 S SD=$P($G(^AMHSITE(DUZ(2),18)),U,7)
 I SD="" Q 0  ;no start date
 ;
 S G=0
 I D]"" D  Q G
 .I D<SD S G=0 Q
 .S G=1
 S D=$P($P(^AMHREC(R,0),U),".")
 I D<SD Q 0
 Q 1
 ; 
DATE() ;EP - Determine DATE patch 10 was installed
 ;
 NEW P,M,A,D
 S D=""
 S P=$O(^DIC(9.4,"C","AMH",0))
 I P="" Q ""
 S M=$O(^DIC(9.4,P,22,"B","3.0",0))
 I M="" Q ""
 S A=$O(^DIC(9.4,P,22,M,"PAH","B",8,0))
 I A="" Q ""
 S D=$P($G(^DIC(9.4,P,22,M,"PAH",A,0)),U,2)
 Q D
 ;
HELPESIG ;EP - called from help prompt
 W !!,"Enter a date to start prompting for the electronic signature.  "
 W !,"Any visit with a visit date on or after this date will require an electronic"
 W !,"signature.  The date must be equal to greater than ",$$FMTE^XLFDT($$DATE)
 W !," which is the date patch 10 was installed.",!
 Q
