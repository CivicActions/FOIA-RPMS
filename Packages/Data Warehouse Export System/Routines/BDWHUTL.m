BDWHUTL ; IHS/CMI/LAB - DW UTILITIES ;
 ;;1.0;IHS DATA WAREHOUSE;**6,9,10**;JAN 24, 2006;Build 9
 ;
 ;
PC(P) ;EP - provider class code
 I '$G(P) Q ""
 NEW I
 S I=$$VALI^XBDIQ1(200,P,53.5)
 I I Q $$VAL^XBDIQ1(7,I,9999999.01)
 Q ""
NPI(P) ;EP
 ;P - IEN of provider in file 200
 I '$G(P) Q ""
 Q $$VAL^XBDIQ1(200,P,41.99)
 ;
DETOXMID(P) ;EP
 ;P - IEN of provider in file 200
 I '$G(P) Q ""
 Q $$VAL^XBDIQ1(200,P,53.11)
 ;
DEA(P) ;EP
 ;P - IEN of provider in file 200
 I '$G(P) Q ""
 Q $$VAL^XBDIQ1(200,P,53.2)
 ;
AFFIL(P) ;EP
 ;P - IEN of provider in file 200
 I '$G(P) Q ""
 Q $$VAL^XBDIQ1(200,P,9999999.01)
 ;
RXPROV(R) ;EP
 ;R - IEN OF PRESCRIPTION ENTRY IN FILE 52
 I '$G(R) Q ""
 Q $$VAL^XBDIQ1(52,R,4)
 ;
DAYS(R,RF) ;EP
 ;R - IEN OF PRESCRIPTION ENTRY IN FILE 52
 I '$G(R) Q ""
 I '$G(RF) Q $$VAL^XBDIQ1(52,R,8)  ;days supply
 Q $P($G(^PSRX(R,1,RF,0)),U,10)  ;refill days supply
 ;
DEAVA(R) ;EP
 ;R - IEN OF PRESCRIPTION ENTRY IN FILE 52
 I '$G(R) Q ""
 Q $$VAL^XBDIQ1(52,R,9999999.37)
 ;
RXDETOXN(R) ;EP
 ;R - IEN OF PRESCRIPTION ENTRY IN FILE 52
 I '$G(R) Q ""
 Q $$VAL^XBDIQ1(52,R,9999999.41)
 ;
 ;
VANUM(R) ;EP
 ;R - IEN OF PRESCRIPTION ENTRY IN FILE 52
 I '$G(R) Q ""
 Q $$VAL^XBDIQ1(200,R,53.3)
 ;
 ;
DATE(D) ;EP - return YYYYMMDD from internal fm format
 I $G(D)="" Q ""
 Q ($E(D,1,3)+1700)_$E(D,4,7)
RZERO(V,L) ;ep right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLK(V,L) ;EP right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
 ;
DEMO(P,T) ;EP - called to exclude demo patients
 I $G(P)="" Q 0
 I $G(T)="" S T="I"
 I T="I" Q 0
 NEW R
 S R=""
 I T="E" D  Q R
 .I $P($G(^DPT(P,0)),U)["DEMO,PATIENT" S R=1 Q
 .NEW %
 .S %=$O(^DIBT("B","RPMS DEMO PATIENT NAMES",0))
 .I '% S R=0 Q
 .I $D(^DIBT(%,1,P)) S R=1 Q
 I T="O" D  Q R
 .I $P($G(^DPT(P,0)),U)["DEMO,PATIENT" S R=0 Q
 .NEW %
 .S %=$O(^DIBT("B","RPMS DEMO PATIENT NAMES",0))
 .I '% S R=1 Q
 .I $D(^DIBT(%,1,P)) S R=0 Q
 .S R=1 Q
 Q 0
NDC(R) ;
 NEW D,C,N
 S D=$$VALI^XBDIQ1(52,R,6)   ;DRUG IEN FROM FILE 50
 S N=$P($G(^PSRX(R,2)),U,7)
 I N="" S N=$$VAL^XBDIQ1(50,D,31)
 Q N
VADC(R) ;
 NEW D,C
 S D=$$VALI^XBDIQ1(52,R,6)   ;DRUG IEN FROM FILE 50
 I D="" Q ""
 Q $$VAL^XBDIQ1(50,D,2)
DRUGNAME(R) ;
 NEW D,C
 Q $$VAL^XBDIQ1(52,R,6)   ;DRUG IEN FROM FILE 50
MEDQTY(R) ;
 Q $$VAL^XBDIQ1(52,R,7)
 ;
RXNORM(R) ;EP
 NEW D,C
 S D=$$VALI^XBDIQ1(52,R,6)   ;DRUG IEN FROM FILE 50
 I D="" Q ""
 Q $$VAL^XBDIQ1(50,D,9999999.27)
 ;
ASFPF(R) ;
 NEW D,C
 ;GET OUTPATIENT SITE
 S D=$$VALI^XBDIQ1(52,R,20)
 I D="" Q ""
 S D=$$VALI^XBDIQ1(59,D,100)  ;related institution
 I D="" Q ""
 Q $$VAL^XBDIQ1(9999999.06,D,.12)
DS(R) ;EP
 NEW D,C
 S D=$$VALI^XBDIQ1(52,R,6)   ;DRUG IEN FROM FILE 50
 I D="" Q ""
 Q $$VAL^XBDIQ1(50,D,3)
 ;
PCC(P,D) ;EP - RETURN CLASS^SPEC^TYPE for provider P on date D
 I $G(P)="" Q ""
 I $G(D)="" Q ""
 I '$D(^VA(200,P,0)) Q ""
 I '$O(^VA(200,P,"USC1",0)) Q ""
 NEW X,Y,Z
 S (X,Z)=0 F  S X=$O(^VA(200,P,"USC1",X)) Q:X'=+X!(Z)  D
 .S Y=$G(^VA(200,P,"USC1",X,0))
 .I $P(Y,U,2)]"",$P(Y,U,3)]"",D'<$P(Y,U,2),D'>$P(Y,U,3) S Z=X Q  ;both dates and a match
 .I $P(Y,U,2)]"",$P(Y,U,3)="",D'<$P(Y,U,2) S Z=X Q  ;beg date, no expire visit after beg
 .Q
 I 'Z S Z=$O(^VA(200,P,"USC1",0))
 S Z=$P(^VA(200,P,"USC1",Z,0),U)
 I 'Z Q ""
 I '$D(^USC(8932.1,Z,0)) Q ""
 S Y=$P(^USC(8932.1,Z,0),U,7)
 Q $$VAL^XBDIQ1(8932.1,Z,.01)_"^"_$E(Y,3,4)_"^"_$E(Y,5,9)_"^"_$E(Y,1,2)
 ;
RTSCHK(BDWHR,BDWHRF,BDWHPFI,BDWHD) ;
 N OK
 S OK=0
 S BDWHACT=""
 ;BDWHR=RX IEN, BDWHRF=REFILL IEN probably don't need BDWHPFI which is partial
 ;S D=$$RTSD(BDWHR,BDWHRF,BDWHPFI)
 S D=""
 S G=""
 ;cmi/maw may need to remove until next comment line
 I D="",$G(BDWHRF),'$D(^PSRX(BDWHR,1,BDWHRF)) D  ;cmi/maw 20211029 patch 5 check activity log
 . S G="" S X=0 F  S X=$O(^PSRX(BDWHR,"A",X)) Q:X'=+X!(G)  D
 ..;20220228 patch 6 11950
 ..S OK=0  ;20220831 maw reset OK every time
 ..S D=$P(^PSRX(BDWHR,"A",X,0),U,1)  ;20220831 maw move this above the status check
 ..I $P(^PSRX(BDWHR,"A",X,0),U,4)'=BDWHRF Q  ;20220831 maw move this above the status check
 ..I D,D<BDWHD Q  ;20220831 maw move this above the status check
 ..I $P(^PSRX(BDWHR,"A",X,0),U,2)="I" S OK=1
 ..Q:'OK
 ..S BDWHACT=X
 ..;end of mods
 ..S G=1
 I D="",$G(BDWHRF),$D(^PSRX(BDWHR,1,BDWHRF)) D  ;cmi/maw 20211029 patch 5 check activity log
 . S G="" S X=0 F  S X=$O(^PSRX(BDWHR,"A",X)) Q:X'=+X!(G)  D
 ..;20220228 patch 6 11950
 ..S OK=0  ;20220831 maw reset OK every time
 ..S D=$P(^PSRX(BDWHR,"A",X,0),U,1)
 ..I $P(^PSRX(BDWHR,"A",X,0),U,4)'=BDWHRF Q
 ..I D,D<BDWHD Q
 ..I $P(^PSRX(BDWHR,"A",X,0),U,2)="I" S OK=1
 ..Q:'OK
 ..S BDWHACT=X
 ..S G=1
 ;cmi/maw end of mods for RTS activity log
 I D="",'$G(BDWHRF) D  ;check activity log
 . S G="" S X=0 F  S X=$O(^PSRX(BDWHR,"A",X)) Q:X'=+X!(G)  D
 ..S OK=0  ;20220831 maw reset OK every time
 ..S D=$P(^PSRX(BDWHR,"A",X,0),U,1)
 ..I $P(^PSRX(BDWHR,"A",X,0),U,4)'=0 Q
 ..I D,D<BDWHD Q
 ..I $P(^PSRX(BDWHR,"A",X,0),U,2)="I" S OK=1
 ..Q:'OK
 ..S BDWHACT=X
 ..S G=1
 ..S BDWHRELY=""
 Q $G(G)
 ;
REICHK(BDWHR,BDWHRF,BDWHD,BDWACTL) ;check for reissue
 N OK
 S OK=0
 S BDWHACTD=$P(^PSRX(BDWHR,"A",BDWACTL,0),U)
 ;BDWHR=RX IEN, BDWHRF=REFILL IEN probably don't need BDWHPFI which is partial
 ;cmi/maw may need to remove until next comment line
 S G="" S X=0 F  S X=$O(^PSRX(BDWHR,"A",X)) Q:X'=+X!(G)  D
 .;20220228 patch 6 11950
 .S OK=0  ;20220831 maw reset OK every time
 .S D=$P(^PSRX(BDWHR,"A",X,0),U,1)  ;20220831 maw move this above the status check
 .I $P(^PSRX(BDWHR,"A",X,0),U,4)'=BDWHRF Q  ;20220831 maw move this above the status check
 .I D<BDWHD Q  ;20220831 maw move this above the status check
 .I D<BDWHACTD Q  ;quit if reissue is before RTS
 .I $P(^PSRX(BDWHR,"A",X,0),U,2)="Z" S OK=1
 .Q:'OK
 .S G=1
 Q $G(G)
 ;
RTSD(P,R,F) ;
 NEW T
 S T=""
 I $G(R) D  Q T  ;refill
 .S T=$P($G(^PSRX(P,1,R,0)),U,16)
 I $G(F) D  Q T
 .S T=$P($G(^PSRX(P,"P",F,0)),U,16)
 S T=$P($G(^PSRX(P,2)),U,15)
 Q T
 ;
