DICOMPX ;SFISC/GFT-EVALUATE COMPUTED FLD EXPR ;10:22 AM  9 Oct 1996 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**24**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S K(K+1)=X,I=$E(I,M+1,999) I "PREVIOUSNEXT"[DICF S M=0,(%X,D,T)=DLV0,X=I(DLV0) D REF,SV S V=X G S
 F M=2:1 I ":)"[$E(I,M) S X=$E(I,1,M-1) Q
 D MULARG
S G ^DICOMPY
 ;
MULARG I DICF="COUNT" S DIC("S")="I $P(^(0),U,2)" G MM
M ;
 S DIC("S")="I $P(^(0),U,2),$P(^DD(+$P(^(0),U,2),.01,0),U,2)'[""W"""
MM S DICN=X,T=DLV S:X?1"#".NP X=$E(X,2,9)
TRY S DIC="^DD("_J(T)_",",DG=$O(^DD(J(T),0,"NM",0))_" " S:DG=" " DG="-1 " D DICS^DICOMPY,^DIC G R:Y<0
 F D=M:1:$L(I)+1 Q:$F(X,$E(I,1,D))-1-D  S W=$E(I,D+1)
 I DICOMP["?",$P(Y,U,2)'=DICN W !?3,"By '"_DICN_"', do you mean the '"_$P(Y,U,2)_"' Subfield" S %=1 D YN^DICN I %-1 G R:%+1 K X Q
 S M=D,Y=+$P(Y(0),U,2),X=$P($P(Y(0),U,4),";",1) I +X'=X S X=Q_X_Q
 S (DLV,D)=DLV0+100 F %=T\100*100:1 Q:%>T  S J(DLV)=J(%),I(DLV)=I(%),DLV=DLV+1
 S I(DLV)=X,X=I(D),J(DLV)=Y D QQ,REF S DLV0=DLV0+100 F DLV=D:1:DLV D SN
 Q
 ;
REF F Y=D+1:1:DLV S V=Y#100-1,DICN=I(Y) S:DICN[Q DICN=Q_DICN_Q S X=X_$S(T<DLV0:"I("_(T\100*100+V)_",0)",1:"D"_V)_","_DICN_","
Q Q
 ;
R I X]"",$P(X,DG,1)="",X=DICN S X=$P(X,DG,2,9) G TRY
 S T=T-1 I T'<0 G TRY:$D(J(T)) F T=T-99:1 G TRY:'$D(J(T+1))
 S X=DICN,DIC=1 D DRW,^DIC I Y<0 K X Q
 S X=^(0,"GL") D QQ
Y S DLV0=DLV0+100,I(DLV0)=^DIC(+Y,0,"GL"),J(DLV0)=+Y F DLV=DLV+100:-1:DLV0 D SN
 Q
 ;
SN S %X=DLV0-100 D SV S DG(DLV0)=DLV Q
 ;
SV S (T,DG(%X))=DG(%X)+1,%=DLV#100,K(K+2,1)=DLV0,DG(%X,T)=%,M(%,%X+%)=T Q
 ;
QQ F %=0:0 S %=$F(X,Q,%) G Q:%<1 S X=$E(X,1,%-1)_$E(X,%-1,999),%=%+1
 ;
DRW ;
 S D=$S(DICOMP["W":"""WR""",1:"""RD""")
 S DIC("S")="S DIAC="_D_",DIFILE=+Y D ^DIAC I %"
 Q
 ;
P ;
 S DLV0=DLV0+100,I(DLV0)=%Y,J(DLV0)=DICN F DLV=DLV+100:-1:DLV0 D SN
 S X=" S D0="_X_" S:'$D("_%Y_"+D0,0)) D0=-1"
 I $D(DICOMPX(0)) S X=X_" S "_DICOMPX(0)_"0)=D0",DICOMPX(0,DICN)=""
 I DG S M=M+1,W="",%=$E(I,M,999) S:+%=% I=$E(I,1,M-1)_"#"_% Q
 S I="#.01"_$E(I,M,999),M=0,W=""
