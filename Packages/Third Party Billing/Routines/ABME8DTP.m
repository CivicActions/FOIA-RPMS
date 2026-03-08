ABME8DTP ; IHS/ASDST/DMJ - 837 DTP Segment [ 02/04/2003  11:07 AM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**1,8**;APR 05, 2002
 ;Transaction Set Header
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM15020/IM15201
 ;    Added code to account for time <1200
 ;
EP(X,Y,Z,ZZ) ;EP
 ; x=entity identifier
 ;y=format
 ;z=fileman date
 ;zz=fileman date to
 S ABMEIC=X
 S ABMFMT=Y
 S ABMFDT=$G(Z)
 S ABMTDT=$G(ZZ)
 K ABMREC("DTP"),ABMR("DTP")
 S ABME("RTYPE")="DTP"
 D LOOP
 K ABME,ABM,ABMEIC
 Q
LOOP ;LOOP HERE
 F I=10:10:40 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("DTP"))'="" S ABMREC("DTP")=ABMREC("DTP")_"*"
 .S ABMREC("DTP")=$G(ABMREC("DTP"))_ABMR("DTP",I)
 Q
10 ;segment
 S ABMR("DTP",10)="DTP"
 Q
20 ;DTP01 - Transaction Set Identifier Code
 S ABMR("DTP",20)=ABMEIC
 Q
30 ;DTP02 - Date Time Period Format Qualifier
 S ABMR("DTP",30)=ABMFMT
 Q
40 ;DTP03 - Date Time Period
 I ABMFMT="D8" D
 .S ABMR("DTP",40)=$$Y2KD2^ABMDUTL(ABMFDT)
 I ABMFMT="RD8" D
 .S ABMR("DTP",40)=$$Y2KD2^ABMDUTL(ABMFDT)_"-"_$$Y2KD2^ABMDUTL(ABMTDT)
 I ABMFMT="DT" D
 .; start code change IM15020
 .;S ABMR("DTP",40)=$$Y2KD2^ABMDUTL(ABMFDT)_$E($P(ABMFDT,".",2),1,4)
 .S ABMTM=$E($P(ABMFDT,".",2),1,4)
 .I $L(ABMTM)<2 S ABMTM="0"_ABMTM
 .S ABMR("DTP",40)=$$Y2KD2^ABMDUTL(ABMFDT)_ABMTM
 .; end code change IM15020
 .S ABMR("DTP",40)=$$FMT^ABMERUTL(ABMR("DTP",40),"12N")
 I ABMFMT="TM" D
 .I $L(ABMFDT,".")=2 S ABMFDT=$P(ABMFDT,".",2)
 .S ABMR("DTP",40)=$$FMT^ABMERUTL(ABMFDT,"4N")
 Q
