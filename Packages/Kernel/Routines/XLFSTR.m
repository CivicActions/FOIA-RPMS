XLFSTR ;ISC-SF/STAFF - String Functions ;06/17/99  16:52 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**112,120**;Jul 10, 1995
UP(X) Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
LOW(X) Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
STRIP(X,Y) Q $TR(X,$G(Y),"")
REPEAT(X,Y) ;
 N % Q:'$D(X) "" I $L(X)*$G(Y)>245 Q ""
 S %="",$P(%,X,$G(Y)+1)="" Q %
INVERT(X) ;
 N %,%1 S %="" F %1=$L(X):-1:1 S %=%_$E(X,%1)
 Q %
REPLACE(IN,SPEC) ;See $$REPLACE in MDC minutes.
 Q:'$D(IN) "" Q:$D(SPEC)'>9 IN N %1,%2,%3,%4,%5,%6,%7,%8
 S %1=$L(IN),%7=$J("",%1),%3="",%6=9999 F  S %3=$O(SPEC(%3)) Q:%3=""  S %6(%6)=%3,%6=%6-1
 F %6=0:0 S %6=$O(%6(%6)) Q:%6'>0  S %3=%6(%6) D:$D(SPEC(%3))#2 RE1
 S %8="" F %2=1:1:%1 D RE3
 Q %8
RE1 S %4=$L(%3),%5=0 F  S %5=$F(IN,%3,%5) Q:%5<1  D RE2
 Q
RE2 Q:$E(%7,%5-%4,%5-1)["X"  S %8(%5-%4)=SPEC(%3)
 F %2=%5-%4:1:%5-1 S %7=$E(%7,1,%2-1)_"X"_$E(%7,%2+1,%1)
 Q
RE3 I $E(%7,%2)=" " S %8=%8_$E(IN,%2) Q
 S:$D(%8(%2)) %8=%8_%8(%2)
 Q
RJ(%,%1,%2) ;Right justify
 N %3
 S:%1["T" %1=+%1,%=$E(%,1,%1)
 S %3=$J("",%1-$L(%)) S:$D(%2) %3=$TR(%3," ",%2) Q %3_%
LJ(%,%1,%2) ;Left justify
 N %3
 S:%1["T" %1=+%1,%=$E(%,1,%1)
 S %3=$J("",%1-$L(%)) S:$G(%2)]"" %3=$TR(%3," ",%2) Q %_%3
CJ(%,%1,%2) ;Center Justify
 N %3,%4
 S:%1["T" %1=+%1,%=$E(%,1,%1) S %3=%1-$L(%) Q:%3<1 %
 S %3=%3\2,%4=$J("",%3+1) I $G(%2)]"" S %4=$TR(%4," ",%2)
 Q $E(%4,1,%3)_%_$E(%4,1,%1-%3-$L(%))
QUOTE(%) ;Add quotes to value for concatenation 
 S %(%)=0,%=$Q(%) Q $P($E(%,1,$L(%)-1),"(",2,999)
 ;
TRIM(%X,%F,%V) ;Trim spaces\char from front(left)/back(right) of string
 N %R,%L S %F=$$UP($G(%F,"LR")),%L=1,%R=$L(%X),%V=$G(%V," ")
 I %F["R" F %R=$L(%X):-1:1 Q:$E(%X,%R)'=%V
 I %F["L" F %L=1:1:$L(%X) Q:$E(%X,%L)'=%V
 Q $E(%X,%L,%R)
