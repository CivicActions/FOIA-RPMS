ATXBAN ; IHS/OHPRD/TMJ -  TAX BANNER ;  
 ;;5.1;TAXONOMY;**25,61**;FEB 04, 1997;Build 133
 ;
 ; -- BANNER ROUTINE FOR TAXONOMY PACKAGE
 ;
 ;
W1 W:$D(IOF) @IOF
L3 W !!?26,"Indian Health Service - RPMS",!
 S Y="",Y=$O(^DIC(9.4,"C","ATX",Y)),VERSION=^DIC(9.4,Y,"VERSION")
 W $$CTR("Taxonomy System Version "_VERSION,80)
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT
 W !?80-$L($P(^DIC(4,DUZ(2),0),"^"))\2,$P(^(0),"^")
XIT W ! K I,ATXVDT,VERSION Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
