ACHSDYNF ; IHS/ITSC/PMF - Build patient name xref for deferrals ; [ 04/12/2002  12:42 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**4**;JUN 11, 2001  
 ;;ACHS*3.1*4  this entire routine created.
 ;
 ;build the patient name cross reference for deferrals
 ;
 ;I $G(^ACHSDEF("ACHSDYNF")) Q
 ;
 W !!!,"Building a patient name cross reference for deferrals,"
 W !,"Including non registered patients..."
 W !!,"Please be patient...",!
 ;
 N COUNT,DAT,DEF,FAC
 S COUNT=0
 S FAC=0 F  S FAC=$O(^ACHSDEF(FAC)) Q:'+FAC  S DEF=0 D LOOP
 S ^ACHSDEF("ACHSDYNF")=1
 Q
 ;
LOOP ;
 ;for each deferral, see if the patient is registered.
 ;If so, then
 ;  get their name and put it into the C cross reference
 ;also, get their name from the non registered name place, if it's there
 ;  and xref by that name, too.
 F  S DEF=$O(^ACHSDEF(FAC,"D",DEF)) Q:'+DEF  D REG,NONREG
 Q
 ;
REG ;
 S COUNT=COUNT+1 I COUNT#1000=0 W !,?5,COUNT," denials examined so far"
 S DAT=$G(^ACHSDEF(FAC,"D",DEF,0))
 I DAT="" Q
 I $P(DAT,U,5)'="Y" Q
 S DAT=$P(DAT,U,6)
 I DAT="" Q
 S DAT=$P($G(^DPT(DAT,0)),U,1)
 I DAT="" Q
 S ^ACHSDEF(FAC,"D","C",DAT,DEF)=""
 Q
NONREG ;
 S DAT=$G(^ACHSDEF(FAC,"D",DEF,0))
 I DAT="" Q
 S DAT=$P(DAT,U,7)
 I DAT="" Q
 S ^ACHSDEF(FAC,"D","N",DAT,DEF)=""
 Q
