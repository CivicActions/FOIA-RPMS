AUM2108M ;IHS/SET/GTH - ICD INACTIVE FLAG AND DATE ; [ 06/28/2002   5:53 PM ]
 ;;02.1;TABLE MAINTENANCE;**8**;SEP 28,2001
 ;
VAL(X,%,Y) ;EP - return background info.
 I X["AREA" Q $T(@%)
 S Y=0
 I X["SU" D  Q Y
 . NEW C,T
 . F C=1:1 S T=$P($T(SU+C),";",3) Q:T="END"  I $P(T,U,1,2)=($E(%,1,2)_U_$E(%,3,4)) S Y=1_";;"_T Q
 .Q
 I '(X["CTY") Q 0
 NEW C,T
 F C=1:1 S T=$P($T(COUNTY+C),";",3) Q:T="END"  I $P(T,U,1,2)=($E(%,1,2)_U_$E(%,3,4)) S Y=1_";;"_T Q
 Q Y
 ;
 ;
AREA ; CODE^NAME^PREFIX/REGION^CAN PREFIX
 ;;END
 ;
SU ; AREA^SU^NAME
 ;;END
 ;
COUNTY ; STATE^COUNTY^NAME
 ;;END
 ;
