ABMDF36X ; IHS/SD/SDR - ADA-2019 FORM ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**30,31**;NOV 12, 2009;Build 615
 ;IHS/SD/SDR 2.6*30 CR11171 New Routine
 ;IHS/SD/SDR 2.6*31 CR10351 Expanded FL 50 to 12 chars (from 10) and 55 to 12 chars (from 10);
 ;  Fixed FLs 14 and 22 so 'M' and 'F' are moved one char left; the Xs were printing on the M/F not in the box
 ;************************************************************************************
 ;
MARG ;Set left and top margins
 S U="^",(ABM("LM"),ABM("TM"),ABM("LN"))=0
 I $D(^ABMDEXP(36,0)) S ABM("TM")=$P(^(0),U,3),ABM("LM")=$P(^(0),U,2)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 D:$G(ABMP("INS")) OVER
 ;
LOOP ;
 ;Loop thru line number array
 S ABM("LN")=$O(ABMF(ABM("LN"))) I +ABM("LN")=0!(ABM("LN")>63) G XIT
 ;
 ;Set to correct format line
 S ABM("FL")=ABM("LN")
 I ABM("LN")>25,ABM("LN")<36 S ABM("FL")=26 ;Lines 27 thru 36 are same
 I ABM("LN")>38,ABM("LN")<42 S ABM("FL")=39 ;Lines 39 thru 42 are same
  ;
 ;Set tab & format variables
 S ABM("TABS")=$P($T(@ABM("FL")),";;",2)
 S ABM("FMAT")=$P($T(@ABM("FL")),";;",3)
 ;
 ;added NE Medicaid code for W0047 to print first
 I ($G(ABMP("ITYP"))="D")!((+$G(ABMP("INS"))'=0)&(($P($G(^AUTNINS(+$G(ABMP("INS")),0)),U)="ARBOR HEALTH PLAN"))) D
 .F ABMLOOP=26:1:36 D
 ..Q:'$D(ABMF(ABMLOOP))
 ..S ABMCHK=$P(ABMF(ABMLOOP),U,6)
 ..I ABMCHK["T1015",ABMLOOP'=26 D
 ...S ABMF("TMP")=$G(ABMF(26))
 ...S ABMF(26)=$G(ABMF(ABMLOOP))
 ...S ABMF(ABMLOOP)=$G(ABMF("TMP"))
 K ABMLOOP,ABMCHK,ABMF("TMP")
 ;
 ;Skip to req'd line
 F  Q:$Y-ABM("TM")>(ABM("LN")+0)  W !
 ;
 ; Test Modes for setting Data Fields
 G LOOP2:'$D(ABMF("TEST"))
 F ABM("I")=1:1:$L(ABM("FMAT"),U) D
 .I $P(ABM("TABS"),U,ABM("I"))]"" D
 ..S ABM("FLD")=""
 ..S $P(ABM("FLD"),"X",$P(ABM("FMAT"),U,ABM("I"))+1)=""
 ..I ABM("FLD")]"" D
 ...W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM"))
 ...D FRMT
 G LOOP
 ;
LOOP2 ;
 ;Loop thru the pieces of the line array
 F ABM("I")=1:1:$L(ABMF(ABM("LN")),U) D
 .I $P(ABM("TABS"),U,ABM("I"))]"" D
 ..S ABM("FLD")=$P(ABMF(ABM("LN")),U,ABM("I"))
 ..I ABM("FLD")]"" D
 ...W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM"))
 ...D FRMT
 G LOOP
 ;
FRMT ;
 ;Write the field in the designated format
 S ABM("LTH")=$P(ABM("FMAT"),U,ABM("I"))
 I +ABM("LTH")=0 S ABM("LTH")=99
 ;
 I ABM("LTH")["$" D  Q
 .S ABM("LTH")=$P(ABM("LTH"),"$")
 .S ABM("FLD")=$FN(+ABM("FLD"),"",2)
 .S ABM("FLD")=$S($P($G(^ABMNINS(+$G(ABMP("LDFN")),+$G(ABMP("INS")),1,+$G(ABMP("VTYP")),1)),U,22)="Y":ABM("FLD"),1:$TR(ABM("FLD"),"."))
 .S ABM("RT")=ABM("LTH")-$L(ABM("FLD"))+1
 .I ABM("RT")>1 D
 ..S ABM("BLNK")=""
 ..S $P(ABM("BLNK")," ",ABM("RT"))=""
 ..S ABM("FLD")=ABM("BLNK")_ABM("FLD")
 .W $E(ABM("FLD"),1,ABM("LTH"))
 ;
 I ABM("LTH")["D" D  Q
 .S ABM("LTH")=$P(ABM("LTH"),"D")
 .W $E(ABM("FLD"),4,5),"/",$E(ABM("FLD"),6,7),"/",($E(ABM("FLD"),1,3)+1700)
 ;
 I ABM("LTH")["L" D
 .S ABM("LTH")=$P(ABM("LTH"),"L")
 .F  Q:$L(ABM("FLD"))=ABM("LTH")!($L(ABM("FLD"))>ABM("LTH"))  D
 ..S ABM("FLD")="0"_ABM("FLD")
 ;
 I ABM("LTH")["C" D
 .S ABM("LTH")=$P(ABM("LTH"),"C")
 .S ABM("FLD")=$J("",ABM("LTH")-$L(ABM("FLD"))\2)_ABM("FLD")
 ;
 I ABM("LTH")["R" D
 .S ABM("LTH")=$P(ABM("LTH"),"R")
 .S ABM("RT")=ABM("LTH")-$L(ABM("FLD"))+1
 .I ABM("RT")>1 D
 ..S ABM("BLNK")=""
 ..S $P(ABM("BLNK")," ",ABM("RT"))=""
 ..S ABM("FLD")=ABM("BLNK")_ABM("FLD")
 ;
 ;remove anything after decimal (meant for units specifically)
 I ABM("LTH")["N" D
 .S ABM("FLD")=$P(ABM("FLD"),".")
 ;
 W $E(ABM("FLD"),1,ABM("LTH"))
 Q
 ;
TEST ;
 S ABMF("TEST")=1
 F ABM=0:ABMF("TEST"):63 S ABMF(ABM)=""
 G MARG
OVER ;GET OVRRIDE VALUES FROM 3P INSURER FILE
 S ABMOLN=0
 F  S ABMOLN=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",36,ABMOLN)) Q:'ABMOLN  D
 .S ABMOPC=0
 .F  S ABMOPC=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",36,ABMOLN,ABMOPC)) Q:'ABMOPC  D
 ..K ABMOVTYP
 ..I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",36,ABMOLN,ABMOPC,0)) S ABMOVTYP=0
 ..I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",36,ABMOLN,ABMOPC,ABMP("VTYP"))) S ABMOVTYP=ABMP("VTYP")
 ..Q:'$D(ABMOVTYP)
 ..S ABMVALUE=^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",36,ABMOLN,ABMOPC,ABMOVTYP)
 ..S $P(ABMF(ABMOLN),"^",ABMOPC)=ABMVALUE
 K ABMOLN,ABMOPC,ABMVALUE,ABMOVTYP
 Q
 ;
XIT ;
 I '$D(ABM("MORE")) K ABMF,ABM
 E  K ABM("MORE")
 Q
TEXT ;;TABS;;FIELD LENGTH
 ;            FORMAT ($-$ FORMAT,L-LNGTH REQ'D,C-CENTER,R-RIGHT,D-DATE)
1 ;;1;;1
2 ;;1;;1
4 ;;1;;30
5 ;;42;;30
6 ;;42;;30
7 ;;5^42;;34^30
8 ;;5;;34
9 ;;5;;34
10 ;;42^55^57^59^64;;10D^1^1^1^15
 ;10 ;;42^56^58^59^64;;10D^1^1^1^15  ;abm*2.6*31 IHS/SD/SDR CR10351
12 ;;6^13^42^55;;1^1^12^20
14 ;;1;;30
15 ;;42^47^53^62^70^75;;1^1^1^1^1^1
16 ;;1^15^17^19^23;;10D^1^1^1^10
17 ;;42;;30
18 ;;1^15^20^26^33^42;;11^1^1^1^1^30
19 ;;42;;30
20 ;;1;;30
21 ;;1;;30
22 ;;1^42^55^57^59^63;;30^10D^1^1^1^16
 ;22 ;;1^42^56^58^59^63;;30^10D^1^1^1^16  ;abm*2.6*31 IHS/SD/SDR CR10351
26 ;;1^12^15^18^30^36^42^47^50^74;;10D^2^2^11^5^5^5^2N^23^6$
36 ;;47^74;;2^6$
37 ;;48^59;;8^8
38 ;;48^59^74;;8^8^6$
39 ;;5;;73
41 ;;1;;40
42 ;;49;;2
43 ;;70;;1
45 ;;1^28^42^51^65;;25^10D^1^1^10D
47 ;;47^51^54^65;;2^1^1^10D
49 ;;2^29^43^58^67;;25^10D^1^1^1
50 ;;56^77;;10D^2
54 ;;2^42^69;;30^25^10D
55 ;;2;;30
56 ;;2^48^68;;30^10^12
 ;56 ;;2^48^69;;30^10^10  ;original line abm*2.6*31 IHS/SD/SDR CR10351
57 ;;68;;10
58 ;;43;;30
59 ;;1^13^27^43;;10^12^11^30
 ;59 ;;1^14^27^43;;10^10^11^30  ;original line abm*2.6*31 IHS/SD/SDR CR10351
60 ;;6^28^46^68;;14^14^14^10
