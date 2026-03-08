DIEZ2 ;SFISC/GFT-COMPILE INPUT TEMPLATE ;3/15/96  09:15 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**19**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S %X="^UTILITY($J,""AF"",",%Y="^DIE(""AF""," D %XY^%RCR
 K ^DIE(DIEZ,"AB") S %X="^UTILITY($J,""AB"",",%Y="^DIE(DIEZ,""AB""," D %XY^%RCR
 S ^DIE(DIEZ,"ROUOLD")=DNM,^("ROU")=U_DNM
K K ^DIBT(.402,1,DIEZ),^UTILITY($J)
 K DIE,DINC,DK,DL,DMAX,DNR,DP,DQ,DQFF,DRD,DS,DSN,DV,DW,DI,DH,%,%X,%Y,%H,X,Y
 K DIEZ,DIEZDUP,DIEZR,Q,DPP,DPR,DM,DR,DU,T,F,DRN,DOV,DIEZL,DIEZP,DIEZAB
 Q
 ;
XREF ;
 S X="C"_DQ_" G C"_DQ_"S:$D(DE("_DQ_"))[0 K DB"
 F %=0:0 S %=$O(^DD(DP,DI,1,%)) Q:%'>0  S DW=^(%,2),X=X_" S X=DE("_DQ_"),DIC=DIE" D SK
 I DV["a" S X=X_" S X=DE("_DQ_"),DIIX=2_U_DIFLD D AUDIT^DIET" D L
 S X="C"_DQ_"S S X="""" Q:DG(DQ)=X  K DB"
 F %=0:0 S %=$O(^DD(DP,DI,1,%)) Q:%'>0  S DW=^(%,1),X=X_" S X=DG(DQ),DIC=DIE" D SK
 I DV["a" S X=X_" Q:$D(DE("_DQ_"))[0&(^DD(DP,DIFLD,""AUDIT"")=""e"")  S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET" D L
 S X=" Q" G L
 ;
SK D L I "Q"[DW S X=" ;" G X
 I DW["Q",^DD(DP,DI,1,%,0)["MUMPS" S Q=DW,F=0 D QFF S X=" X "_Q G X
 S X=" "_DW
X D L S X="" Q
 ;
MUL ;
 S DNR=%,DW=$P(DW,";",1),X=$P(^DD(+DV,0),U,4)_U_DV_U_DW_U,%=^(.01,0),DV=+DV_$P(%,U,2)
 G 1:DV'["W" I DPR]"" S F=0,Q=DPR D QFF S X=" S DE(1,0)="_Q D L
 S X=" S Y="""_$S(DIEZP]"":DIEZP_U_$P(%,U,2,9),1:%)_""",DG="""_DW_""",DC=""^"_+DV_""" D DIEN^DIWE K DE(1) G A" D L S X=" ;" D L,AF
 S ^UTILITY($J,"AF",+DV,.01,DIEZ)="" D AB G NX^DIEZ0
 ;
1 S X=" S DIFLD="_DI_",DGO=""^"_DNM_DNR_""",DC="""_X_""",DV="""_DV_""",DW=""0;1"",DOW="""_$S(DIEZP]"":DIEZP,1:$P(^(0),U,1))_""",DLB=""Select ""_DOW S:D DC=DC_D",DPP=DV["M",DU=$P(^(0),U,3) D L,DU:DU]""
 S X=$P(" G RE:D",U,DPP)_" I $D(DSC("_+DV_"))#2,$P(DSC("_+DV_"),""I $D(^UTILITY("",1)="""" X DSC("_+DV_") S D=$O(^(0)) S:D="""" D=-1 G M"_DQ D L
 S:+DW'=DW DW=""""_DW_"""" S X=" S D=$S($D("_DIE_"DA,"_DW_",0)):$P(^(0),U,3,4),$O(^(0))'="""":$O(^(0)),1:-1)" D L
 S X="M"_DQ_" I D>0 S DC=DC_D I $D("_DIE_"DA,"_DW_",+D,0)) S DE("_DQ_")=$P(^(0),U,1)" D L
 D PR^DIEZ0 S X="R"_DQ_" D DE" D L
 S X=$S(DPP:" S D=$S($D("_DIE_"DA,"_DW_",0)):$P(^(0),U,3,4),1:1) G "_DQ_"+1",1:" G A") D L S X=" ;" D L,AF
 S DRN(DNR)=+DV_U_(DL+1)_DIE_"D"_DIEZL_","_DW_","_U_(DIEZL+1)_U_DQ_U_DRN G NX^DIEZ0
 ;
AF ;
 S ^UTILITY($J,"AF",DP,DI,DIEZ)=""
AB I '$D(^UTILITY($J,"AB",DIEZAB,DI)) S ^(DI)=DQ_U_DNM_DRN S:DPR?1"/".E ^(DI,"///")=""
 Q
 ;
DU S F=0,Q=DU D QFF S X=" S DU="_Q,DU=""
L S L=L+1,^UTILITY($J,0,L)=X,T=T+$L(X)+2 Q
 ;
O ;
 S F=0,Q=^(2) D QFF S DIEZOT=" S DQ("_DQ_",2)="_Q Q
 ;
PR ;
 F %=1,2,3 Q:$E(DPR,%)'="/"
 S X=$E(DPR,%,999),Q=X,F=0 D QFF I $A(X)-94 S X=" S Y="_Q
 E  S X=" "_$E(X,2,999) D L S X=" S Y=X"
 D L S X=" G Y" I %>1 S DPP=0,X=" S X=Y,DB(DQ)=1 G:X="""" N^DIE17:DV,A I $D(DE(DQ)),DV[""I""!(DV[""#"") D E^DIE0 G A:'$D(X)" D L S X=" G "_$S(%=3:"RD:X=""@"",Z",1:"RD")
 Q
QF ;
 S F=0,Q=DIE
QFF ;
 S F=$F(Q,"""",F) I F S Q=$E(Q,1,F-1)_$E(Q,F-1,999),F=F+1 G QFF
 S Q=""""_Q_""""
