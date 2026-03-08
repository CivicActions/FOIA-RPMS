BIUTL12 ;IHS/CMI/MWR - UTIL: PATIENT INFO; AUG 10,2010
 ;;8.5;IMMUNIZATION;**26**;OCT 24,2011;Build 33
 ;
BRKSP(X,X1,X2,X3,X4) ;EP Break a line at space.
 ;---> First line cut off at 27 chars, 2nd, 3rd, & 4th at 36 chars.
 I X="" S (X1,X2,X3,X4)="" Q
 I $L(X)<27 S X1=X,(X2,X3,X4)="" Q
 ;
 I X'[" " S X1=$E(X,1,27),(X2,X3,X4)="" Q
 ;
 N I,L,Z S I=27,L=$L(X),(X1,X2,X3,X4)=""
 F  S I=I-1 Q:($E(X,I)=" ")
 S X1=$E(X,1,I),X2=$E(X,I+1,L)
 ;
 Q:($L(X2)<35)
 S Z=X2,I=36,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S X2=$E(Z,1,I),X3=$E(Z,I+1,L)
 ;
 Q:($L(X3)<35)
 S Z=X3,I=36,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S X3=$E(Z,1,I),X4=$E(Z,I+1,L)
 Q
 ;
BRKSPS(S,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12) ;EP Break a line at space.
 ;---> First line cut off at 78 chars, 2nd, 3rd, & 4th at 78 chars.
 I S="" S (S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12)="" Q
 I $L(S)<78 S S1=S,(S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12)="" Q
 ;
 I S'[" " S S1=$E(S,1,27),(S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12)="" Q
 ;
 N I,L,Z S I=78,L=$L(S),(S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12)=""
 F  S I=I-1 Q:($E(S,I)=" ")
 S S1=$E(S,1,I),S2=$E(S,I+1,L)
 ;
 Q:($L(S2)<78)
 S Z=S2,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S2=$E(Z,1,I),S3=$E(Z,I+1,L)
 ;
 Q:($L(S3)<78)
 S Z=S3,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S3=$E(Z,1,I),S4=$E(Z,I+1,L)
 ; 
 Q:($L(S4)<78)
 S Z=S4,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S4=$E(Z,1,I),S5=$E(Z,I+1,L)
 ;
 Q:($L(S5)<78)
 S Z=S5,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S5=$E(Z,1,I),S6=$E(Z,I+1,L)
 ;
 Q:($L(S6)<78)
 S Z=S6,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S6=$E(Z,1,I),S7=$E(Z,I+1,L)
 ;
 Q:($L(S7)<78)
 S Z=S7,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S7=$E(Z,1,I),S8=$E(Z,I+1,L)
 ;
 Q:($L(S8)<78)
 S Z=S8,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S8=$E(Z,1,I),S9=$E(Z,I+1,L)
 ;
 Q:($L(S9)<78)
 S Z=S9,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S9=$E(Z,1,I),S10=$E(Z,I+1,L)
 Q
 Q:($L(S10)<78)
 S Z=S10,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S10=$E(Z,1,I),S11=$E(Z,I+1,L)
 ;
 Q:($L(S11)<78)
 S Z=S11,I=78,L=$L(Z)
 I Z[" " F  S I=I-1 Q:($E(Z,I)=" ")
 S S11=$E(Z,1,I),S12=$E(Z,I+1,L)
 Q
 ;
