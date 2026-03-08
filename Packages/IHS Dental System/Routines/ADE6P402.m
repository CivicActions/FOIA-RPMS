ADE6P402 ;IHS/OIT/GAB - ADE V6.0 PATCH 40 [ 11/05/2023 8:37 AM ]
 ;;6.0;ADE IHS DENTAL;**40**;March 25, 1999;Build 10
 ;IHS/OIT/GAB 11/2023 Patch 40 ADA-CDT code updates for 2024
 ;Modification of ADA-CDT Codes - Update the .02 field (Nomenclature) and 1101 (Descriptor/Use)
 ;
MODCDT40 ;EP
 D UPDATE^ADEUPD40(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P402","SETX^ADE6P402")
 Q
 ;
SETX ;EP
 I $G(ADERPEAT) D  Q:ADERPEAT
 .S:ADERPEAT=1 ADECURX=ADEX,ADERPEAT=2
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEX=ADECURX,ADEN="" Q
 .S ADEX=ADESVX,$P(ADEX,U)=ADEN,ADERPEAT=2
 Q:ADEDONE
 I $P(ADEX,U)["-" D  Q:'ADERPEAT
 .S ADERPEAT=1,ADESVX=ADEX,ADESTART=$P($P($P(ADEX,U),"-"),"D",2),ADEEND=$P($P($P(ADEX,U),"-",2),"D",2),ADEN=$O(^AUTTADA("B",ADESTART),-1)
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEN="" Q
 .S $P(ADEX,U)=ADEN
 I 'ADERPEAT S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN
 S $P(ADEX,U,3)=$TR($P(ADEX,U,3),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S:ADERPEAT ADESVX=ADEX
 Q
 ;
MODADA ;  Code^^Nomenclature    /   Descriptor on next line
 ;;D2335^^Resin composite - 4+ surfaces, anterior
 ;;Tooth-colored filling of a cavity of four or more surfaces of a front tooth, typically caused by tooth decay
 ;;D5876^^Add metal substruct full denture (per arch)
 ;;Use of metal substructure in removable complete dentures without a framework
 ;;***END***
