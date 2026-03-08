BDMFTAX3 ;IHS/CIM/THL - DMS TAXONOMY MANAGEMENT UTILITY;  [ 03/07/05  11:44 AM ]
 ;;1.0;DIABETES MANAGEMENT SYSTEM;**4,6**;OCT 01, 2000
 ;UTILITY PROGRAM TO MANAGE TAXONOMY CREATION AND EDITING
 ;
 ;THIS ROUTINE WAS DISTRIBUTED WITH PATCH #4 BUT NOT
 ;MARKED AS PATCH #4
 ;IT IS NOW INCLUDED WITH PATCH #5 THOUGH DOES NOT APPEAR
 ;TO BE CALLED FROM ANY OTHER ROUTINE OR DICTIONARY OR
 ;MENU OPTION
 ;
TAX ;CREATE TAXONOMIES
 ;K ^TMP("TAXONOMIES")
 ;S BDMJ=0
 ;S Y="S BDMJ=BDMJ+1 S ^TMP(""TAXONOMIES"",BDMJ)=XX W ""."""
 ; F A="DM AUDIT","SURVEILLANCE" D
 ;.S AA=A
 ;.F  S A=$O(^ATXAX("B",A)) Q:A'[AA  D
 ;..S B=0
 ;..F  S B=$O(^ATXAX("B",A,B)) Q:'B  D
 ;...S XX=" ;;0;;AX;;"_^ATXAX(B,0)
 ;...X Y
 ;...S C=0
 ;...F  S C=$O(^ATXAX(B,11,C)) Q:'C  D
 ;....S XX=" ;;11;;AX;;"_C_";;"_^ATXAX(B,11,C,0)
 ;....X Y
 ;...S C=0
 ;...;F  S C=$O(^ATXAX(B,21,C)) Q:'C  D
 ;....S (YY,YYY)=+$P(^ATXAX(B,0),U,15)
 ;....S XX=" ;;21;;AX;;"_C_";;"_^ATXAX(B,21,C,0),ZZ=$P(^(0),U)
 ;....I YY,"^9999999.31^80^80.1^"'[(U_YY_U) D
 ;.....S YY=$G(^DIC(YY,0,"GL"))
 ;.....Q:YY=""
 ;.....S YY=$P($G(@(YY_+ZZ_",0)")),U)
 ;.....S:YY]"" XX=XX_";;"_YY
 ;....I YYY=50,$P($G(^PSDRUG(ZZ,2)),U,4)["-" S $P(XX,";;",10)=$P(^(2),U,4)
 ;....X Y
 ;S (A,AA)="DM AUDIT"
 ;F  S A=$O(^ATXLAB("B",A)) Q:A'[AA  D
 ;.S B=0
 ;.F  S B=$O(^ATXLAB("B",A,B)) Q:'B  D
 ;..S XX=" ;;0;;LAB;;"_^ATXLAB(B,0)
 ;..X Y
 ;..S C=0
 ;..F  S C=$O(^ATXLAB(B,11,C)) Q:'C  D
 ;...S XX=" ;;11;;LAB;;"_C_";;"_^ATXLAB(B,11,C,0)
 ;...X Y
 ;..S C=0
 ;..;F  S C=$O(^ATXLAB(B,21,C)) Q:'C  D
 ;...S XX=" ;;21;;LAB;;"_C_";;"_^ATXLAB(B,21,C,0),ZZ=$P(^(0),U)
 ;...S YY=$P($G(^LAB(60,+ZZ,0)),U)
 ;...S XX=XX_";;"_$P($G(^LAB(60,+ZZ,0)),U)_";;"_$P($G(^(0)),U,12)
 ;...X Y
 ;...S D=0
 ;...F  S D=$O(^ATXLAB(B,21,C,11,D)) Q:'D  D
 ;....S YY=$P(^ATXLAB(B,0),U,9)
 ;....S XX=" ;;21;;LAB;;"_C_";;"_D_";;SOURCE;;"_^ATXLAB(B,21,C,11,D,0)
 ;....X Y
 Q
ZIS W !!,"This process will update Taxonomies required by the"
 W !,"DIABETES MANAGEMENT SYSTEM."
 W !!,"Select the device on which to record taxonomies updated."
 W !!,"Enter the name of a device for the report or"
 W !,"enter '^' to exit the update process then press <ENTER>."
 S DIR(0)="YO"
 S DIR("A")="Do you want to proceed"
 S DIR("B")="YES"
 W !
 D DIR^BDMFDIC
 Q:Y'=1
 S (ZTRTN,BDMRTN)="TAXSET^BDMFTAX3"
 S ZTDESC="UPDATE DIABETES SYSTEM TAXONOMIES"
 D ^BDMFZIS
 Q
TAXSET ;EP;TO UPDATE DIABETES SYSTEM STANDARD TAXONOMIES
 D T1
 K ^TMP("TAXONOMIES")
 Q
T1 K BDMDA,BDMQUIT ;IHS/CIM/TMJ Patch #5 missing nested do
 ;F J=1:1 S Z=$T(EN+J^BDMFTAX4) Q:Z=""  D
 ;.S BDMJ=0
 ;.F  S BDMJ=$O(^TMP("TAXONOMIES",BDMJ)) Q:'BDMJ  S Z=^TMP("TAXONOMIES",BDMJ) D
 ;.I $P(Z,";;",2)=0 D  Q
 ;..S X=$P($P(Z,";;",4),U)
 ;..S BDMFILE=$P($P(Z,";;",4),U,$S($P(Z,";;",3)="AX":15,1:9))
 ;..S (BDMDIC,DIC)=$S($P(Z,";;",3)="AX":"^ATXAX(",1:"^ATXLAB(")
 ;..I $D(@(DIC_"""B"","""_X_""")")) S BDMDA=$O(^(X,0)) Q
 ;..I '$D(ZTQUEUED) U IO W !,"FILE NEW TAXONOMY: ",X
 ;..S DIC(0)="L"
 ;..D FILE^BDMFDIC
 ;..S BDMDA=+Y
 ;..S @(BDMDIC_BDMDA_",0)")=$P(Z,";;",4,99),$P(^(0),U,5)=DUZ
 ;..S DA=BDMDA
 ;..S DIK=BDMDIC
 ;..D IX1^BDMFDIC
 ;.Q:'$G(BDMDA)
 ;.I $P(Z,";;",3)'="LAB" D DX
 ;.I $P(Z,";;",3)="LAB" D LAB
 ;Q
DX I $P(Z,";;",2)=11 D
 .I '$D(^ATXAX(BDMDA,11,$P(Z,";;",4),0)) D
 ..S ^ATXAX(BDMDA,11,$P(Z,";;",4),0)=$P(Z,";;",5)
 ..S ^ATXAX(BDMDA,11,0)="^^"_$P(Z,";;",4)_"^"_$P(Z,";;",4)_"^"_DT
 ..I '$D(ZTQUEUED) U IO W !,"FILE DX DESCRIPTION: ",Z
 I $P(Z,";;",2)=21 D
 .S X=$P(Z,";;",6)
 .S:X="" X=$P(Z,";;",5)
 .Q:X=""
 .S YY=$P(X,U),ZZ=$P(X,U,2)
 .I YY]"","^9999999.31^80^80.1^"'[(U_BDMFILE_U) D  Q:'YY
 ..S YYY=$G(^DIC(BDMFILE,0,"GL"))
 ..Q:YYY=""
 ..I BDMFILE=50,$P(Z,";;",10)]"" S YY=$P(Z,";;",10),YY=$TR(YY,"-",""),YY=$O(^PSDRUG("ZNDC",YY,0)) Q:$D(^PSDRUG(+YY,0))
 ..S YY=$P(X,U)
 ..S YY=$O(@(YYY_"""B"","""_YY_""",0)"))
 ..I ZZ]"" S ZZ=$O(@(YYY_"""B"","""_ZZ_""",0)"))
 .S:ZZ="" ZZ=YY
 .Q:$D(^ATXAX(BDMDA,21,"B",YY))
 .I '$D(ZTQUEUED) U IO W !?10,"FILE DX ITEM: ",X," ",YY," ",ZZ
 .S X=YY
 .S DA=BDMDA
 .S DA(1)=BDMDA
 .S DIC="^ATXAX("_DA_",21,"
 .I $G(ZZ)]"" S DIC("DR")=".02////"_ZZ K ZZ
 .S:'$D(^ATXAX(DA,21,0)) ^ATXAX(DA,21,0)="^9002226.02101A"
 .S DIC(0)="L"
 .D FILE^BDMFDIC
 Q
LAB I $P(Z,";;",2)=11 D  Q
 .I '$D(^ATXLAB(BDMDA,11,$P(Z,";;",4),0)) D
 ..S ^ATXLAB(BDMDA,11,$P(Z,";;",4),0)=$P(Z,";;",5)
 ..S ^ATXLAB(BDMDA,11,0)="^^"_$P(Z,";;",4)_"^"_$P(Z,";;",4)_"^"_DT
 ..I '$D(ZTQUEUED) U IO W !,"FILE LAB DESCRIPTION: ",Z
 I $P(Z,";;",2)=21,$P(Z,";;",6)'="SOURCE" D
 .S YY=$P(Z,";;",5)
 .I $P($G(^LAB(60,YY,0)),U,12)=$P(Z,";;",7)
 .E  D
 ..S YY=$P(Z,";;",6)
 ..Q:YY=""
 ..S YY=$O(^LAB(60,"B",YY,0))
 ..I 'YY,$D(^LAB(60,+$P(Z,";;",5),0)),$E($P(^(0),U),1,5)=$E($P(Z,";;",6),1,5) S YY=$P(Z,";;",5)
 .Q:'YY
 .Q:'$D(^LAB(60,YY,0))
 .S BDMDA(1)=BDMDA
 .Q:$D(^ATXLAB(BDMDA,21,"B",YY))
 .I '$D(ZTQUEUED) U IO W !?10,"FILE LAB ITEM: ",YY
 .S X=YY
 .S DA=BDMDA
 .S DA(1)=BDMDA
 .S DIC="^ATXLAB("_DA_",21,"
 .S DIC(0)="L"
 .S:'$D(^ATXLAB(DA,21,0)) ^ATXLAB(DA,21,0)="^9002228.02101PA"
 .D FILE^BDMFDIC
 .S BDMDA(1)=+Y
 I $G(BDMDA),$G(BDMDA(1)),$P(Z,";;",2)=21,$P(Z,";;",6)="SOURCE" D
 .I $D(^ATXLAB(BDMDA,21,BDMDA(1))),'$D(^ATXLAB(BDMDA,21,BDMDA(1),11,$P(Z,";;",5),0)) D
 ..S ^ATXLAB(BDMDA,21,BDMDA(1),11,$P(Z,";;",5),0)=$P(Z,";;",7)
 ..I '$D(ZTQUEUED) U IO W !?10,"FILE LAB ITEM SOURCE: ",Z
 Q
