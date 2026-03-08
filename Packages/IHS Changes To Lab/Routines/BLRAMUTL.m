BLRAMUTL ; IHS/CMI/LAB - MAIN DRIVER FOR AM EXPORT ; 14-Dec-2023 12:55 ; MKK
 ;;5.2;LABORATORY;**1054**;NOV 01, 1997;Build 20
 ;
LOINCFSN(%) ;EP - called from computed field V MICRO .121
 I $G(%)="" Q ""
 S %=$P(%,"-")
 I '$D(^LAB(95.3,%,0)) Q ""
 Q $$VAL^XBDIQ1(95.3,%,81)
 ;
