HLPAT60 ;SFCIOFO/JIC Repair corrupted LR NCH-LAB logical link ;02/16/2000  12:40
 ;;1.6;HEALTH LEVEL SEVEN;60;JUL 17, 1995
HLCS ;Reset field 2 pointers from LLP param to LLP Type, then merge data 
 N HLL,HLLPP,HLLPT,HLSAVE,HLLPTN,X
 S HLL=0
 ;check all LL, merge only if there is data after node 2
 ;kill node 11, these were old Lab messages
 F  S HLL=$O(^HLCS(870,HLL)) Q:HLL<1  K ^(HLL,11) D:'$O(^(2))
 .S HLLPP=$P(^HLCS(870,HLL,0),U,3) Q:HLLPP<1
 .I '$D(^HLCS(869.2,HLLPP)) S $P(^HLCS(870,HLL,0),U,3)="" K ^HLCS(870,"ALLP",HLLPP,HLL) Q
 .S HLLPT=$P(^HLCS(869.2,HLLPP,0),U,2) Q:HLLPT<1
 .S HLSAVE(HLLPP)=^HLCS(869.2,HLLPP,0)
 .K ^HLCS(870,"ALLP",HLLPP,HLL)
 .S $P(^HLCS(870,HLL,0),U,3)=HLLPT
 .S ^HLCS(870,"ALLP",HLLPT,HLL)=""
 .D MRG
 Q
MRG ;Merge file 869.2 and 870
 Q:'$D(HLSAVE(HLLPP))
 K ^HLCS(869.2,HLLPP,0)
 M ^HLCS(870,HLL)=^HLCS(869.2,HLLPP)
 S ^HLCS(869.2,HLLPP,0)=HLSAVE(HLLPP)
 K HLSAVE
 Q
