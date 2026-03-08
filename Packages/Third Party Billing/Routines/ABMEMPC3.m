ABMEMPC3 ; IHS/SD/SDR - Report Utility to Check Parms ;  
 ;;2.6;IHS Third Party Billing;**32**;NOV 12, 2009;Build 621
 ;Original;SDR
 ;IHS/SD/SDR 2.6*32 CR11501 New routine for new employee productivity report
 ; 
DX ;EP
 I (+$G(ABMY("DXANS"))'=10)&($G(ABMY("DX",1))=""!($G(ABMY("DX",2))="")) G DX2
 S ABM("DX")=0
 S ABM("DX","HIT")=0
 S ABM("LP")=$S($D(ABMY("DX","ALL"))!$D(ABMY("DX10","ALL")):10,1:1)
 ;
 I ABMV="BILL" F ABM("II")=1:1:ABM("LP") S ABM("DX")=$O(^ABMDBILL(DUZ(2),ABM,17,"C",ABM("DX"))) Q:'ABM("DX")  D  Q:ABM("DX","HIT")
 .S ABM("DX")=$O(^ABMDBILL(DUZ(2),ABM,17,"C",ABM("DX"),""))
 .Q:'$D(^ABMDBILL(DUZ(2),ABM,17,ABM("DX"),0))
 .S ABM("DX",0)=$P(^(0),U)
 .S ABMDXTYP=+$P($G(^ABMDBILL(DUZ(2),ABM,17,ABM("DX"),0)),U,6)
 .D DX3
 ;
 I ABMV="CLM" F ABM("II")=1:1:ABM("LP") S ABM("DX")=$O(^ABMDCLM(DUZ(2),ABM,17,"C",ABM("DX"))) Q:'ABM("DX")  D  Q:ABM("DX","HIT")
 .S ABM("DX")=$O(^ABMDCLM(DUZ(2),ABM,17,"C",ABM("DX"),""))
 .Q:'$D(^ABMDCLM(DUZ(2),ABM,17,ABM("DX"),0))
 .S ABM("DX",0)=$P(^(0),U)
 .S ABMDXTYP=+$P($G(^ABMDCLM(DUZ(2),ABM,17,ABM("DX"),0)),U,6)
 .D DX3
 ;
 I ABMV="CANCEL" F ABM("II")=1:1:ABM("LP") S ABM("DX")=$O(^ABMCCLMS(DUZ(2),ABM,17,"C",ABM("DX"))) Q:'ABM("DX")  D  Q:ABM("DX","HIT")
 .S ABM("DX")=$O(^ABMCCLMS(DUZ(2),ABM,17,"C",ABM("DX"),""))
 .Q:'$D(^ABMCCLMS(DUZ(2),ABM,17,ABM("DX"),0))
 .S ABM("DX",0)=$P(^(0),U)
 .S ABMDXTYP=+$P($G(^ABMCCLMS(DUZ(2),ABM,17,ABM("DX"),0)),U,6)
 .D DX3
 Q
 ;
DX2 ;EP
 Q
 ;
DX3 ;EP
 S ABM("DX",0)=$$NUM^ABMCVAPI($P($$DX^ABMCVAPI(+ABM("DX"),ABM("D")),U,2))
 I ABMDXTYP=1,$G(ABMY("DXANS"))=9 Q
 I ABMDXTYP=0,$G(ABMY("DXANS"))=10 Q
 I (ABMDXTYP=0) D
 .I (ABM("DX",0)'>ABMY("DX",2)),(ABM("DX",0)'<ABMY("DX",1)) S ABM("DX","HIT")=1
 I (ABMDXTYP=1) D
 .I '$D(ABMY("DX",3)) Q  ;stop here if no data at ABMY("DX",3)
 .I (ABM("DX",0)'>ABMY("DX",4)),(ABM("DX",0)'<ABMY("DX",3)) S ABM("DX","HIT")=1
 Q
 ;
PX ;
 I '+ABMY("CPX",1)!'+ABMY("CPX",2) Q
 I ABMV="BILL" D  Q:ABM("PX","HIT")
 .;
 .I +$P($G(^ABMDBILL(DUZ(2),ABM,2)),U,8)'=0 D  Q:ABM("PX","HIT")
 ..S:$P($G(^ABMNINS(ABM("L"),ABM("I"),1,ABM("V"),0)),U,16) ABM("CPT")=$P($G(^ICPT($P($G(^ABMNINS(ABM("L"),ABM("I"),1,ABM("V"),0)),U,16),0)),U)
 ..Q:+$G(ABM("CPT"))=0
 ..S ABM("CCPT")=$$NUM^ABMCVAPI(ABM("CPT"))
 ..Q:ABM("CCPT")>+ABMY("CPX",2)
 ..Q:ABM("CCPT")<+ABMY("CPX",1)
 ..S ABM("PX","HIT")=1
 .;
 .S ABM("PX","HIT")=0 N I F I=21,23,25,27,33,35,37,39,43,47 D  Q:ABM("PX","HIT")
 ..N J S J=0 F  S J=$O(^ABMDBILL(DUZ(2),ABM,I,J)) Q:'J  D  Q:ABM("PX","HIT")
 ...S ABM("CPT")=$P($G(^ICPT($P(^ABMDBILL(DUZ(2),ABM,I,J,0),U),0)),U)
 ...I I=23 S:+$P($G(^ABMDBILL(DUZ(2),ABM,I,J,0)),U,29) ABM("CPT")=$P($G(^ICPT($P(^ABMDBILL(DUZ(2),ABM,I,J,0),U,29),0)),U)
 ...I I=25 S:+$P($G(^ABMDBILL(DUZ(2),ABM,I,J,0)),U,7) ABM("CPT")=$P($G(^ICPT($P(^ABMDBILL(DUZ(2),ABM,I,J,0),U,7),0)),U)
 ...I I=33 S:+$P($G(^ABMDBILL(DUZ(2),ABM,I,J,0)),U,3) ABM("CPT")=$P($G(^ICPT($P(^ABMDBILL(DUZ(2),ABM,I,J,0),U,3),0)),U)
 ...Q:$G(ABM("CPT"))=""
 ...S ABM("CCPT")=$$NUM^ABMCVAPI(ABM("CPT"))
 ...Q:ABM("CCPT")>+ABMY("CPX",2)
 ...Q:ABM("CCPT")<+ABMY("CPX",1)
 ...S ABM("PX","HIT")=1
 ;
 I ABMV="CLM" S ABM("PX","HIT")=0 N I F I=21,23,25,27,33,35,37,39,43,47 D  Q:ABM("PX","HIT")
 .N J S J=0 F  S J=$O(^ABMDCLM(DUZ(2),ABM,I,J)) Q:'J  D  Q:ABM("PX","HIT")
 ..S ABM("CPT")=$P($G(^ICPT($P(^ABMDCLM(DUZ(2),ABM,I,J,0),U),0)),U)
 ..I I=23 S:+$P($G(^ABMDCLM(DUZ(2),ABM,I,J,0)),U,29) ABM("CPT")=$P($G(^ICPT($P(^ABMDCLM(DUZ(2),ABM,I,J,0),U,29),0)),U)
 ..I I=25 S:+$P($G(^ABMDCLM(DUZ(2),ABM,I,J,0)),U,7) ABM("CPT")=$P($G(^ICPT($P(^ABMDCLM(DUZ(2),ABM,I,J,0),U,7),0)),U)
 ..I I=33 S:+$P($G(^ABMDCLM(DUZ(2),ABM,I,J,0)),U,3) ABM("CPT")=$P($G(^ICPT($P(^ABMDCLM(DUZ(2),ABM,I,J,0),U,3),0)),U)
 ..Q:$G(ABM("CPT"))=""
 ..S ABM("CCPT")=$$NUM^ABMCVAPI(ABM("CPT"))
 ..Q:+ABM("CCPT")>ABMY("CPX",2)
 ..Q:+ABM("CCPT")<ABMY("CPX",1)
 ..S ABM("PX","HIT")=1
 ;
 I ABMV="CANCEL" S ABM("PX","HIT")=0 N I F I=21,23,25,27,33,35,37,39,43,47 D  Q:ABM("PX","HIT")
 .N J S J=0 F  S J=$O(^ABMCCLMS(DUZ(2),ABM,I,J)) Q:'J  D  Q:ABM("PX","HIT")
 ..S ABM("CPT")=$P($G(^ICPT($P(^ABMCCLMS(DUZ(2),ABM,I,J,0),U),0)),U)
 ..I I=23 S:+$P($G(^ABMCCLMS(DUZ(2),ABM,I,J,0)),U,29) ABM("CPT")=$P($G(^ICPT($P(^ABMCCLMS(DUZ(2),ABM,I,J,0),U,29),0)),U)
 ..I I=25 S:+$P($G(^ABMCCLMS(DUZ(2),ABM,I,J,0)),U,7) ABM("CPT")=$P($G(^ICPT($P(^ABMCCLMS(DUZ(2),ABM,I,J,0),U,7),0)),U)
 ..I I=33 S:+$P($G(^ABMCCLMS(DUZ(2),ABM,I,J,0)),U,3) ABM("CPT")=$P($G(^ICPT($P(^ABMCCLMS(DUZ(2),ABM,I,J,0),U,3),0)),U)
 ..Q:$G(ABM("CPT"))=""
 ..S ABM("CCPT")=$$NUM^ABMCVAPI(ABM("CPT"))
 ..Q:+ABM("CCPT")>ABMY("CPX",2)
 ..Q:+ABM("CCPT")<ABMY("CPX",1)
 ..S ABM("PX","HIT")=1
 Q
