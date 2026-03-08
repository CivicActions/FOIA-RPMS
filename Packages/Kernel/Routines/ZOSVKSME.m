%ZOSVKSE ;SF/KAK - Automatic %GE Routine (MSM) ;14 OCT 92 4:30 pm [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;8.0;KERNEL;**90,94**;Jul 21, 1998
 ;
 ; MSM Version
 ;
 Q   ; called by routine ^KMPSGE in VAH
START(KMPSTEMP) ;
 I $D(^%ZOSF("TRAP")) S X="ERROR^%ZOSVKSE",@^%ZOSF("TRAP")
 E  S $ZT="ERROR^%ZOSVKSE"
 ;W !,"Global Efficiency - Automated Version",!
 ;
 S KMPSSITE=$P(KMPSTEMP,"^"),NUM=$P(KMPSTEMP,"^",2),KMPSLOC=$P(KMPSTEMP,"^",3),KMPSDT=$P(KMPSTEMP,"^",4),KMPSPROD=$P(KMPSTEMP,"^",5)
 K KMPSTEMP,X S KMPSZU=$ZU(0),KMPSVOL=$P(KMPSZU,",",2)
 S ^[KMPSPROD,KMPSLOC]XTMP("KMPS","START",KMPSVOL,NUM)=""
GET ;
 O 63 D INT^%ZOSVKSS I '$D(%UTILITY($J)) G EXIT  ;W !,"No globals selected"
 S KMPSCC="" F KMPSI=1:0 S KMPSCC=$O(%UTILITY($J,KMPSCC)) Q:(KMPSCC="")!($D(^[KMPSPROD,KMPSLOC]XTMP("KMPS","STOP")))  S %BN=$ZBN(@("^["""_$ZU(0)_"""]"_KMPSCC)) D SP
 G EXIT
SP ;
 Q:%BN=0
SP2 ;
 ;W !!,"^",KMPSCC
 D INT1^%ZOSVKSS
 S ^[KMPSPROD,KMPSLOC]XTMP("KMPS",KMPSSITE,NUM,KMPSDT,KMPSCC,KMPSZU)=%LHB(1)
 F I=1:1:%L D DSP1
 ;W ?T(3),$J(%SPN,T(4)-T(3)-4)  ;blocks allocated
 ;W ?T(4),$J(%SPN*1012,T(5)-T(4)-2)  ;bytes allocated
 ;W ?T(5),$J(%SPU,T(6)-T(5)-2)  ;bytes used
 ;I %SPN W ?T(6),$J(%SPU*100/%SPN/1012,9,2)  ;percent efficiency
 Q
DSP1 ;
 I I=%L S ^[KMPSPROD,KMPSLOC]XTMP("KMPS",KMPSSITE,NUM,KMPSCC,KMPSZU,KMPSDT,"D")=%SPN(I)_"^"_$P(%SPU(I)*100/%SPN(I)/1012+.5,".")_"%^Data"
 E  S ^[KMPSPROD,KMPSLOC]XTMP("KMPS",KMPSSITE,NUM,KMPSCC,KMPSZU,KMPSDT,I)=%SPN(I)_"^"_$P(%SPU(I)*100/%SPN(I)/1012+.5,".")_"%^"_$S(I=(%L-1):"Bottom p",1:"P")_"ointer"
 ;W ?T(1),$J(I,T(2)-T(1)-3)  ;ptr number
 ;W ?T(2),$J(%LHB(I),T(3)-T(2)-5)  ;ptr block start
 ;W ?T(3),$J(%SPN(I),T(4)-T(3)-4)  ;blocks allocated
 ;W ?T(4),$J(%SPN(I)*1012,T(5)-T(4)-2)  ;bytes allocated
 ;W ?T(5),$J(%SPU(I),T(6)-T(5)-2)  ;bytes used
 ;I %SPN(I) W ?T(6),$J(%SPU(I)*100/%SPN(I)/1012,9,2)  ;percent efficiency
 ;W !
 Q
EXIT ;
 C 63
 K ^[KMPSPROD,KMPSLOC]XTMP("KMPS","START",KMPSVOL),KMPSFS,KMPSLOC,KMPSMGR,KMPSPROD,KMPSSITE,KMPSUCI,KMPSVOL,KMPSZU,NUM
 K I,T,X
 K %BN,KMPSCC,KMPSI,%L,%LHB,%SP,%SPN,%SPU
 Q
ERROR ;
 S ZUZR=$ZR I $D(^%ZOSF("TRAP")) S X="",@^%ZOSF("TRAP") D @^%ZOSF("ERRTN")
 E  S $ZT="" D ^%ET
 H
