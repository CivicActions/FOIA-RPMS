DIOS1 ;SFISC/GFT-BUILD SORT LOGIC ;10/12/94  11:08 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
L S X=$P(DPP(DL),U,2) S:X=0 X=.001
 S W=+$P($P(DPP(DL),U,5),";L",2) I W D  G SL
 . I $P(DPP(DL),U,5)[";TXT" S W=W+1
 . S W=$S(W<DIOS:W,1:DIOS),DE(DL)=W,DE(DL,"SIC")=1 Q
 I '$D(^DD(DX,+X,0)) S W=+$P($P(DPP(DL),U,4),"""",2) I '$D(^DD(DX,W,0)) S W=30 G DJ:$P(DPP(DL),U,7)["D",LL
X S DN=$P(^(0),U,2),W=+$P(DN,"J",2) G LL:W>8,DJ:W I $P(DN,"P",2) G X:$D(^DD(+$P(DN,"P",2),.01,0)),LL
 I DN["C",DN'["J" S W=30 G LL
 I DN'["F" S DE=DE+5,W=13 S:$P(DPP(DL),U,5)[";TXT" W=14 G DJ
 S W=+$P(^(0),"$L(X)>",2) S:'W W=30 S:W>DIOS W=DIOS
LL I $P(DPP(DL),U,5)[";TXT" S W=W+1
 S:W>8 DE(DL)=W,D5=D5+1
SL S DE=DE+W-8
DJ I $O(DPP(DL,-1)) D  I X=.001 S DE=DE+W
 . N I,J S I=0
 . F J=0:0 S J=$O(DPP(DL,J)) Q:'J  S I=I+1
 . S DE=(I*4)+DE Q
 Q
