%ZOSVKSS ;SF/KAK - Automatic %GSEL Routine (MSM) ;14 OCT 92 4:30 pm [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;8.0;KERNEL;**90,94**;Jul 21, 1998
 ;
 ; MSM Version
 ;
INT ; Internal entry point
GS4 ;
 K %UTILITY($J) S KMPSGN="*"
STR S KMPSGN=$P(KMPSGN,"*"),KMPSR1=KMPSGN,KMPSR2=KMPSR1_$S($ZB($V($V(44),-3,2),128,1):$C(#7E7E),1:$C(#FF))
NOREF S KMPSGN=KMPSR1
 F KMPSI=0:0 S KMPSGN=$O(@("^"_KMPSGN)) Q:KMPSGN=""!(KMPSGN]KMPSR2)  S %UTILITY($J,KMPSGN)=""
 I '$D(%UTILITY($J)) S ^[KMPSPROD,KMPSLOC]XTMP("KMPS",KMPSSITE,NUM," NO GLOBALS ",KMPSZU)=""
EXIT K KMPSGN,KMPSI,KMPSR1,KMPSR2
 Q
 ;
INT1 ; Automatic %GE1 routine
 O 63 N (%BN,%SPN,%SPU,%L,%LHB) V %BN S T=$V(1020,0,1),%L=0
 G GDIR:T=1,GPTR:T=2,GDATA:T=3,GXDATA:T=4,RDIR:T=5,RTNHDR:T=6,RTNDATA:T=7,MAPBLK:T=8,JRNL:T=9,SBP:T=10
 Q   ;W !!,*7,"** Unknown block type, block#=,%BN,", type=",T,*7,! Q
 ;
GDIR ; global directory block
GPTR ; pointer block
RDIR ; routine directory
 S %L=%L+1,%SPN=1,%LHB(%L)=%BN,%SPU=$V(1022,0,2)
 S BP=$V(1021,0,1),%BN=$V(2+$V(1,0,1),0,3) ;down link
 F I=1:1 S %BNX=$V(1012,0,4) Q:'%BNX  V %BNX S %SPN=%SPN+1,%SPU=%SPU+$V(1022,0,2)
 S %SPN(%L)=%SPN,%SPU(%L)=%SPU
 I BP<128 V %BN G GDIR
 G:T'=2 SUMUP V %BN
GDATA ; Global data
 S %L=%L+1,%SPN=1,%LHB(%L)=%BN,%SPU=$V(1022,0,2)
 F I=1:1 S %BN=$V(1012,0,4) Q:'%BN  V %BN S %SPN=%SPN+1,%SPU=%SPU+$V(1022,0,2)
 S %SPN(%L)=%SPN,%SPU(%L)=%SPU
 G SUMUP
GXDATA ;global extended data
RTNHDR ;routine header block
RTNDATA ;routine continuation block
JRNL ;journal block
SBP ;sequential block processor block
 S %L=%L+1,%SPN=1,%LHB(%L)=%BN,%SPU=1022
 F I=1:1 S %BN=$V(1012,0,4) Q:'%BN  V %BN S %SPN=%SPN+1,%SPU=%SPU+$V(1022,0,2)
 S %SPN(%L)=%SPN,%SPU(%L)=%SPU
 G SUMUP
MAPBLK ;map block
 S %L=%L+1,%SPN=1,%LHB(%L)=%BN,%SPU=1022 Q
SUMUP ;
 S (%SPN,%SPU)=0 F I=1:1:%L S %SPN=%SPN+%SPN(I),%SPU=%SPU+%SPU(I)
 K (%SPN,%SPU,%L,%LHB) C 63 Q
