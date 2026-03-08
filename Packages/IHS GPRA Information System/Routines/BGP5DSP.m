BGP5DSP ; IHS/CMI/LAB - IHS summary page ; 
 ;;5.0;IHS CLINICAL REPORTING;**1**;OCT 15, 2004
 ;
START ;
 I BGPRTYPE'=1 Q
 I $G(BGPNPL) Q
 S BGPQUIT="",BGPGPG=0
 D HEADER
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(IOSL-3) D HEADER Q:BGPQUIT
 .W !
 .I BGPC=1 W !,"DIABETES GROUP"
 .I BGPC=2 W !,"DENTAL GROUP"
 .I BGPC=3 W !,"IMMUNIZATIONS"
 .I BGPC=4 W !,"CANCER-RELATED"
 .I BGPC=5 W !,"BEHAVIORAL HEALTH"
 .I BGPC=6 W !,"CARDIOVASCULAR DISEASE-RELATED"
 .;I BGPC>6 W !
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY",BGPC,BGPO,0))
 ..I $P(^BGPINDVC(BGPPC,0),U,4)["014."!($P(^BGPINDVC(BGPPC,0),U,4)["023.") D
 ...W !,$P(^BGPINDVC(BGPPC,14),U,4)
 ...I $P(^BGPINDVC(BGPPC,14),U,7)]"" W !,$P(^BGPINDVC(BGPPC,14),U,7)
 ...W ?27,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,0)
 ...W ?37,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,0)
 ...W ?48,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,0)
 ...W ?60,$P(^BGPINDVC(BGPPC,14),U,2),?71,$P(^BGPINDVC(BGPPC,14),U,3)
 ..E  D
 ...W !,$P(^BGPINDVC(BGPPC,14),U,4)
 ...I $P(^BGPINDVC(BGPPC,14),U,7)]"" W !,$P(^BGPINDVC(BGPPC,14),U,7)
 ...W ?27,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,1),"%"
 ...W ?37,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,1),"%"
 ...W ?48,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,1),"%"
 ...W ?60,$P(^BGPINDVC(BGPPC,14),U,2),?71,$P(^BGPINDVC(BGPPC,14),U,3)
 W !,"(* = Not GPRA indicator for FY 2005)",!
 D ^BGP5SDP
 Q
 ;
HEADER ;EP
 D HEADER^BGP5DPH
 D H1
 Q
H1 ;
 S X="CLINICAL PERFORMANCE SUMMARY PAGE" W !,$$CTR(X,80)
 I $G(BGPAREAA) W !?27," Area",?37," Area",?48," Area",?60,"National",?71,"2010"
 I '$G(BGPAREAA) W !?27," Site",?37," Site",?48," Site",?60,"National",?71,"2010"
 W !?27,"Current",?37,"Previous",?48,"Baseline",?60,"2004",?71,"Goal"
 W !,$TR($J("",80)," ","-")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
