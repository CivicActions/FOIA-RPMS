AUMUCLR ;IHS/ITSC/DMJ - CLEAR OLD AUM DATA FILE [ 08/19/2004  2:25 PM ]
 ;;04.1;AUM - SCB UPDATE;**4,5,6**;
 D CLR
 Q
CLR ;clear out old aumdata file
 S I=0
 F  S I=$O(^AUMDATA(I)) Q:'I  D
 .K ^AUMDATA(I)
 F I=3,4 D
 .S $P(^AUMDATA(0),"^",I)=0
 Q
