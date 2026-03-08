%ZOSVKSS ;SF/KAK - Automatic %GE Routine (VAX-DSM) ;14 OCT 92 4:30 pm [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;8.0;KERNEL;**90,94,197**;May 4, 2001
 ;
 ; VAX-DSM Version
 ;
 ;-- code from routine %GSEL
 ;
 S %=$ZC(%UCI),%LOC="",%SUBTR=0
 I %]"" N %UCI,%SYS S %UCI=$P(%,","),%SYS=$P(%,",",4),%LOC="["""_%UCI_""","""_%SYS_"""]"
INIT K %UTILITY,%GD
START S X="ERR1^%ZOSVKSE",@^%ZOSF("TRAP"),$ZE=""
ASK ; prompt for name specifications and select names in %UTILITY
 S %X="*"
 D SELECT
 I $O(%UTILITY(""))="" S ^[KMPSPROD,KMPSLOC]XTMP("KMPS",KMPSSITE,NUM," NO GLOBALS ",KMPSZU)=""
 G END
 ;
SELECT ; Input: %X = one item
 S %ST="",(%CNT,%MI)=0
 S %FI="zzzzzzzz"
 ;
GET ; search directory and put names in %UTILITY
 ;   Input: %ST = start string
 ;          %FI = end string
 G GETRMS:$ZU("")="",GETGLS
 ;
GETRMS ; get RMS global names
 ;   Input: %ST = starting name
 ;          %FI = ending name
 S %W=%ST I %FI'["z" S %W=""
 I $E(%W,1)'="%" S %F="DSM$GLOBAL_DIR:"_%W_"*.GBL"
 E  S %F="DSM$GLOBAL_LIB:"_$E(%W,2,$L(%W))_"*.GBL"
 I $E(%ST,1)="^" S %ST=$E(%ST,2,$L(%ST))
 I $E(%FI,1)="^" S %FI=$E(%FI,2,$L(%FI))
 S %F=$ZSE(%F)
 F  Q:%F=""  S %N=$P($P(%F,"]",2),".") S:$E(%W)="%" %N="%"_%N Q:%N]%FI  D SELONE:%N=%ST!(%N]%ST) S %F=$ZSE("")
 Q
 ;
SELONE ; select one entire global
 ; delete all selected subtree(s)
 K %UTILITY(%N,"S")
 S %UTILITY(%N)="",%CNT=%CNT+1
 Q
 ;
GETGLS ; get DSM volume set global names
 ; create %GD array of all of them and choose right ones
 ; %GD utility create %GD array
 S %W=%ST I %FI'["z" S %W=""
 I $D(%GD)'=11 D %GDI(%UCI,%SYS,1,0)
 S %F=$O(%GD(""))
 F  Q:%F=""  S %N=%F Q:%F]%FI  D SELONE:%N=%ST!(%N]%ST) S %F=$O(%GD(%F))
 Q
 ;
END K %GD,%X,%ST,%FI,%MI,%W,%F,%,%N,%SUBTR,%LOC,%CNT
 K %ERR,%GNM,%L,%PSN,%QS,%QT,%RV,%SB,%ST,%V,%C
 ;-- end code from routine ^%GSEL
 ;
 G EGD
 ;
%GDI(%UCI,%SYS,%NP,%LIB) ;
 ;-- code from routine %GD
 ;
 ; enter with %UCI, %SYS, %NP and %LIB defined
 ; %NP = no printout is set to 1
 ;
 N %OPT
 S %OPT=0
 ; return the %GD array containing volume set globals
 I $ZU("")=""!(%UCI="")!(%SYS="") ZT "Error in SAGG utility"
 D %DSM
 G %EXIT
 ;
%DSM ; display the global directory of a volume set
 ; this may be different from selected UCI
 S %=$ZC(%UCI)
 ;
 ; construct volume set name
 S %VSET="S"_$P($ZU(%UCI,%SYS),",",2)
 ;
 ;-- code from line tag %DIR
 S %DIR=$S($ZU("")]"":%UCI_","_%SYS,1:$P($P($ZC(%GBLSHOW),",",1+%LIB),"]",1)_"]")
 ;
 ; compute value for priming $ZSORT
 S %C=0,%NAM="%"
 ;
 ; if priming value exists set it -- code from line tag %WRTGLO
 I $D(@("^[%UCI,%SYS]"_%NAM)) S %GD(%NAM)=""
 ;
 ; $ZS through global names -- code from line tag %WRTGLO
 F  D  Q:%NAM=""  I $E(%NAM)="%"!'%LIB S %GD(%NAM)=""
 .S %NAM=$ZS(@("^[%UCI,%SYS]"_%NAM))
 ;
 ; finish up
 Q
 ;
%EXIT K %DIR,%,%N,%C,%D,%UCI,%SYS,%LIB,%VSET
 K %NAM,%OPT,%NP
 Q
 ;-- end code from routine %GD
 ;
EGD ;-- code from %EGD
 ; extended global directory information
 ;
 S U="^",P=$ZU(0)
 Q:P=""
 S %UCI=$P(P,","),%SYS=$P(P,",",2)
 ;
 ; construct volume set name
 S VS="S"_$P($ZU(%UCI,%SYS),",",2)
 ;
 ; get global directory block
 S GD=$ZC(%UCIDIR,%UCI,%SYS)
 ;
 ; open a 1 block view buffer
 S P=$ZC(%VIEWBUFFER,1,1,1)
READ V GD:VS
 S P=0
NAME I $V(1022,0,2)'>P S GD=$V(1014,0,3) G READ:GD,EXIT
 S NAM="" F P=P:1 S A=$V(P,0,1),NAM=NAM_$C(A\2) I A#2=0 Q
 ; PROT = protection
 S P=P+1,PROT=$V(P+1,0,1)
 F I=1:1:4 S @("A"_I_"=$P(""N,R,RW,RWP"","","",PROT#4+1)"),PROT=PROT\4
 S B=P+2 D  S BL1=B,B=P+5 D  S BL2=B
 .S B=$V(B+2,0,1)*256+$V(B+1,0,1)*256+$V(B,0,1)
 ; COL = collate
 S COL=$V(P,0,2)#2+1
 S BITS=$V(P,0,2)\2#2+7
 ;
 ; %UTILITY(global name) = jrnl^collating^bits^growth area block
 ;                          ^protection:system^world^group^user
 ;                          ^blank^1st pointer block
 ; where collating:    N = Numeric
 ;                     S = String
 ;
 I $D(%UTILITY(NAM)) S %UTILITY(NAM)=$S($V(P,0,2)\4#2:"Y",1:"N")_U_$P("N,S",",",COL)_U_BITS_U_BL1_U_A4_U_A3_U_A2_U_A1_U_U_BL2
 ;
 S P=P+8 G NAME
EXIT ;
 K A,A1,A2,A3,A4,B,BL1,BL2,BITS,COL,GD,NAM,P,PROT,VS
 Q
 ;-- end code from routine %EGD
