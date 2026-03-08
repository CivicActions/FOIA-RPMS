HLPAT57 ;SFCIOFO/JIC  Post Install for HL7 patch 57 ;08/30/99  09:00 [ 04/02/2003   8:38 AM ]
 ;;1.6;HEALTH LEVEL SEVEN;**1004**;APR 1, 2003
 ;;1.6;HEALTH LEVEL SEVEN;**57**;JUL 17, 1995
 ;     
 N X
 S X=$$NEWCP^XPDUTL("ORD","ORD^HLPAT57")
 S X=$$NEWCP^XPDUTL("HLCS","HLCS^HLPAT57")
 S X=$$NEWCP^XPDUTL("XREF","XREF^HLPAT57")
 Q
ORD ;move Item multiple to Subscriber multiple in file 101
 N DA,DIC,DIK,HL,HL0
 S HL=0,DIK(1)=".01^2"
 ;loop thru file, find only event driver protocols
 F  S HL=$O(^ORD(101,HL)) Q:'HL  S HL0=$G(^(HL,0)) D:$P(HL0,U,4)="E"
 . ;quit if there is no items in multiple or already moved
 . Q:'$D(^ORD(101,HL,10))!$O(^(775,0))
 . M ^ORD(101,HL,775)=^ORD(101,HL,10)
 . S $P(^ORD(101,HL,775,0),U,2)="101.0775PA",DIK="^ORD(101,"_HL_",775,",DA(1)=HL
 . ;re-index file level x-ref, "AB"
 . D ENALL^DIK
 Q
 ;
HLCS ;Reset field 2 pointers from LLP param to LLP Type, then merge data    
 N HLL,HLLPP,HLLPT,HLSAVE,HLLPTN,X
 S HLL=0
 ;check all LL, merge only if there is data after node 2
 F  S HLL=$O(^HLCS(870,HLL)) Q:HLL<1  D:'$O(^(HLL,2))
 .S HLLPP=$P(^HLCS(870,HLL,0),U,3) Q:HLLPP<1   ;IHS/OIRM/DSD/AEF 11/25/02 FIXED TYPO, REPLACED Q:HLPP<1 WITH Q:HLLPP<1
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
XREF ;re-crossref protocol file, 101
 ; kill the "AHL1" and then index "AHL1" and "AHL21"
 N DIK,DA
 K ^ORD(101,"AHL1")
 S DIK="^ORD(101,"
 S DIK(1)="770.95"
 D ENALL^DIK
 Q
