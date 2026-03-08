ACHSDYN ; IHS/ITSC/PMF - Build patient name xref for denials ; [ 02/11/2002  12:38 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**1,3**;JUN 11, 2001  
 ;;ACHS*3.1*1  this entire routine created.
 ;;ACHS*3.1*3  add D cross reference
 ;             ENTIRE ROUTINE NEW FOR PATCH 3
 ;
 ;build the patient name cross reference for denials
 ;
 ;
 I $G(^ACHSDEN("ACHSDYN")) Q
 ;
 W !!!,"Building a patient name cross reference for denials,"
 W !,"Including non registered patients..."
 W !!,"Please be patient...",!
 ;
 N COUNT,DAT,DEN,FAC
 S COUNT=0
 S FAC=0 F  S FAC=$O(^ACHSDEN(FAC)) Q:'+FAC  S DEN=0 D LOOP
 S ^ACHSDEN("ACHSDYN")=1
 Q
 ;
LOOP ;
 ;for each denial, see if the patient is registered.
 ;If so, then
 ;  get their name and put it into the C cross reference
 ;also, get their name from the non registered name place, if it's there
 ;  and xref by that name, too.
 F  S DEN=$O(^ACHSDEN(FAC,"D",DEN)) Q:'+DEN  D REG,NONREG
 Q
 ;
REG ;
 S COUNT=COUNT+1 I COUNT#1000=0 W !,?5,COUNT," denials examined so far"
 S DAT=$G(^ACHSDEN(FAC,"D",DEN,0))
 I DAT="" Q
 I $P(DAT,U,6)'="Y" Q
 S DAT=$P(DAT,U,7)
 I DAT="" Q
 S DAT=$P($G(^DPT(DAT,0)),U,1)
 I DAT="" Q
 S ^ACHSDEN(FAC,"D","C",DAT,DEN)=""
 Q
NONREG ;
 S DAT=$G(^ACHSDEN(FAC,"D",DEN,10))
 I DAT="" Q
 S DAT=$P(DAT,U,1)
 I DAT="" Q
 S ^ACHSDEN(FAC,"D","N",DAT,DEN)=""
 Q
