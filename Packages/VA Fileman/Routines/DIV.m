DIV ;SFISC/GFT-VERIFY FLDS ;8/22/95  07:14 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**8**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 N DIUTIL S DIUTIL="VERIFY FIELDS"
 K J
 S Q="""",S=";",V=0,P=0,I(0)=DIU,@("(A,J(0))=+$P("_DIU_"0),U,2)")
 I $O(^(0))'>0 W $C(7),"  NO ENTRIES ON FILE!" Q
DIC S DIC="^DD(A,",DIC(0)="EZ",DIC("W")="W:$P(^(0),U,2) ""  (multiple)"""
 S DIC("S")="S %=$P(^(0),U,2) I %'[""C"",$S('%:1,1:$P(^DD(+%,.01,0),U,2)'[""W"")"
 W !,"VERIFY WHICH "_$P(^DD(A,0),U)_": " R X:DTIME Q:U[X
 I X="ALL" D ALL G Q:$D(DIRUT) I Y D FLDS G Q^DIVR:DQI'>0
 D ^DIC K DQI,^UTILITY("DIVR",$J)
 I Y<0 W:X?1."?" !?3,"You may enter ALL to verify every field at this level of the file.",! G DIC
 S DR=$P(Y(0),U,2) I DR S J(V)=A,P=+Y,V=V+1,A=+DR,I(V)=$P($P(Y(0),U,4),S,1) S:+I(V)'=I(V) I(V)=Q_I(V)_Q G DIC
1 F T="N","D","P","S","V","F" Q:DR[T
 F W="FREE TEXT","SET OF CODES","DATE","NUMERIC","POINTER","VARIABLE POINTER","K" I T[$E(W) S:W="K" W="MUMPS" W "   ",W Q
 K DA S DIVZ=$P(Y(0),U,3),DDC=$P(Y(0),U,5,99),(DIFLD,DA)=+Y
 G ^DIVR
 ;
Q K DIR,DIRUT,N,P,Q,S,V,C
 Q
 ;
ALL S DIR(0)="Y",DIR("??")="^D H^DIV"
 S DIR("A")="DO YOU MEAN ALL THE FIELDS IN THE FILE"
 D ^DIR K DIR S X="ALL"
 Q
 ;
FLDS S DQI=0 F  S DQI=$O(^DD(A,DQI)) Q:DQI'>0  S Y=DQI,Y(0)=^(Y,0),DR=$P(Y(0),U,2) D
 .I DR,$P(^DD(+DR,.01,0),U,2)["W" Q
 .I DR D NEXTLVL Q
 .I DR'["C" W !!!,"--",$P(Y(0),U),"--" D 1 Q
 Q
NEXTLVL ;
 N A,P,DE,DA,DQI,I,J,V S DQI=0
 S A=+DR,P=+Y N Y,DR D IJ^DIVU(A)
 D FLDS
 Q
H W !!?5,"YES means that every field at this level in the file will"
 W !?5,"be checked to see if it conforms to the input transform."
 W !!?5,"NO means that ALL will be used to lookup a field in the"
 W !?5,"file which begins with the letters ALL, e.g., ALLERGIES."
 Q
VER(DIVRFILE,DIVRREC,DIVRDR,DIVROUT) ;
 ;DIVRFILE = (sub)file number
 ;DIVRREC = template, or ien-string of records to be verified
 ;DIVRDR = list of fields to be verified (defaults to ALL)
 ;DIVROUT = output array listing the records that had problems
 G ^DIVR1
DIVROUT I $G(DIVROUT)="" D X Q
 I $E(DIVROUT)="[" D  Q
 . N Y,COUNT,Z
 . D DIBT^DIVU(DIVROUT,.Y,DIVRFI0) Q:Y'>0
 . K ^DIBT(+Y,1)
 . S (COUNT,Z)=0
 . F  S Z=$O(^TMP("DIVR1",$J,Z)) Q:Z=""  S COUNT=COUNT+1,^DIBT(+Y,1,Z)=""
 . I COUNT S ^DIBT(+Y,"QR")=DT_U_COUNT
 . D X
 M @DIVROUT@(1)=^TMP("DIVR1",$J)
X K ^TMP("DIVR1",$J)
 Q
