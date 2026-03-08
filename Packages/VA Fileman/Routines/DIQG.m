DIQG ;SFISC/DCL-DATA RETRIEVAL PRIMITIVE ;3/5/96  13:48 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**22**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
GET(DIQGR,DA,DR,DIQGPARM,DIQGETA,DIQGERRA,DIQGIPAR) ; file,rec,fld,parm,targetarray,errarray,int
DDENTRY I $G(U)'="^" N U S U="^"
 N DIQGDD,DIQGWPB,DIQGWPO S DIQGPARM=$G(DIQGPARM),DIQGIPAR=$G(DIQGIPAR),DIQGDD=DIQGPARM["D",DIQGWPB=DIQGPARM["B"
 S DIQGWPO=1
 ;I DIQGIPAR'["A" K DIERR,^TMP("DIERR",$J)
 N DIQGEY S DIQGEY("FILE")=$G(DIQGR),DIQGEY("RECORD")=$G(DA),DIQGEY("FIELD")=$G(DR)
 I '$D(DIQGR) N X S X(1)="FILE" Q $$F(.X,1)
 I 'DIQGR,'DIQGIPAR N X S X(1)="FILE" Q $$F(.X,12)
 I '$D(DA) N X S X(1)="RECORD" Q $$F(.X,2)
 D:$G(DA)["," IEN(DA,.DA)
 I '$D(DR) N X S X(1)="FIELD" Q $$F(.X,10)
 I 'DIQGIPAR,'DIQGDD Q:$$N9^DIQGU(DIQGR,.DA) $$F(.DIQGEY,16) I '$D(^DD(DIQGR)) N X S X(1)="FILE" Q $$F(.X,18)
 S DIQGETA=$G(DIQGETA) I DIQGETA["("&(DIQGETA'[")") N X S X(1)="TARGET ARRAY" Q $$F(.X,14)
 S:DIQGR DIQGR=$S(DIQGDD:$$DDROOT(DIQGR),1:$$ROOT^DIQGU(DIQGR,.DA)) I DIQGR="" N X S X(1)="FILE and/or IEN" Q $$F(.X,4)
 N DIQGSI S DIQGSI=$$CREF(DIQGR)
 Q:'$D(@DIQGSI@(DA)) $$F(.DIQGEY,19)
 I $D(DT)#2-1 N DT S DT=$$DT^DIQGU($H)
 I DR[":" S DIQGEY(1)=$P(DR,":") N X S X=$$GET(DIQGR,DA,$P(DR,":"),"I","","","1A") Q:X'>0 $$F(.DIQGEY,9) Q $$GET("^"_$P(^(0),"^",3),X,$P(DR,":",2,99),DIQGPARM,"","","1A")
 N DIQGPI,DIQGZN S DIQGPI=DIQGPARM["I",DIQGZN=DIQGPARM["Z"
 I DR']"" N X S X(1)="FIELD" Q $$F(.X,5)
 N %,%H,%T,I,J,N,X
 S X=0,N="D0" F  S X=$O(DA(X)) Q:X'>0  S I=X,N=N_",D"_X
 N @N
 S @("D"_+$G(I)_"=DA") I $G(I) F J=I-1:-1:0 S @("D"_J_"=DA(I-J)")
 N C,P,Y,DIQGDN,DIQGD4,DIQGDRN
 S (X,Y)="",DIQGDRN=DR
 S:$D(@DIQGSI@(0)) DIQGDN="^DD("_+$P(^(0),"^",2)_")" I '$D(DIQGDN) N X S X("FILE")=DIQGSI Q $$F(.X,6)
 I DR'?.N,$D(@DIQGDN@("B",DR)) S DIQGDRN=$O(^(DR,"")) I $O(^(DIQGDRN)) N X S X("FILE")=DIQGDN,X(1)=DR Q $$F(.X,15)
 I DIQGDD,DIQGDRN'>0 D  I $E(DIQGDRN,1,6)="$$$ NO" N X S X(1)="ATTRIBUTE" Q $$F(.X,17)
 .S DIQGDRN=$$DDN^DIQGU0(DR) Q:$E(DIQGDRN,1,6)="$$$ NO"
 .S DIQGDN="^DD("_$P(DIQGDRN,"^")_")",DIQGDRN=$P(DIQGDRN,"^",2)
 I DIQGDRN>0,$D(@DIQGDN@(DIQGDRN,0)) S DIQGD4=$P(^(0),"^",4),C=$P(^(0),"^",2),P=$P(DIQGD4,";") G:$P(DIQGD4,";",2)'>0 DIQ S Y=$P($G(@DIQGSI@(DA,P)),"^",$P(DIQGD4,";",2)) G DIQ
 Q $$F(.DIQGEY,7)
DIQ I DIQGDRN=.001 S Y=DA
 I C G BMW
 I C["Cm" N X S X(1)="MULTILINE COMPUTED" Q $$F(.X,3)
 I C["C",DIQGPI Q ""
 I C["C",DIQGDN="^DD(1.005)",DIQGDRN=1 S X=@DIQGSI@(DA,0)
 I C["C",$D(@DIQGDN@(DIQGDRN,0)) N DCC,DFF,DIQGH S DIQGH=$G(DIERR),DCC=DIQGR,DFF=+$P(DCC,"(",2) X $P(^(0),"^",5,999) D:DIQGH'=$G(DIERR)  Q $S(C["D":$$FMTE^DILIBF($G(X),"1U"),1:$G(X))
 .N X
 .D BLD^DIALOG(120,"FIELD")
 .Q
 I 'DIQGPI&(C["O"!(C["S")!(C["P")!(C["V")!(C["D"))&($D(@DIQGDN@(DIQGDRN,0))) S C=$P(^(0),"^",2) Q $$EXTERNAL^DIDU(+$P(DIQGDN,"(",2),DIQGDRN,"",Y)
 I C["K" Q $E($G(@DIQGSI@(DA,P)),$E($P($P(DIQGD4,";",2),","),2,99),$P($P(DIQGD4,";",2),",",2))
 I C["C" Q $G(Y)
 I $E($P(DIQGD4,";",2))="E" Q $E($G(@DIQGSI@(DA,P)),$E($P($P(DIQGD4,";",2),","),2,99),$P($P(DIQGD4,";",2),",",2))
 Q $G(Y)
BMW I C,$P(^DD(+C,.01,0),"^",2)["W" Q:DIQGWPB "$CREF$"_DIQGR_DA_","_$$Q^DIQGU(P)_")" D  G:X="" FE Q:DIQGWPO $NA(@DIQGETA) Q:DIQGIPAR "$WP$" Q ""
 .I DIQGETA']"" K X S X(1)="TARGET ARRAY" D BLD^DIALOG(202,.X) S X="" Q
 .S X=DIQGR_DA_","_$$Q^DIQGU(P)_")"
 .I '$P($G(@X@(0)),"^",3) S X="" Q
 .I DIQGZN M @DIQGETA=@X K @DIQGETA@(0) Q
 .S Y=0 F  S Y=$O(@X@(Y)) Q:Y'>0  I $D(^(Y,0)) S @DIQGETA@(Y)=^(0)
 .Q
 I C,$P(^DD(+C,.01,0),"^",2)["M" Q $$F(.DIQGEY,11)
 I DIQGPI!(DIQGDD) Q $G(Y)
 Q $$F(.DIQGEY,8)
CREF(X) N L,X1,X2,X3 S X1=$P(X,"("),X2=$P(X,"(",2,99),L=$L(X2),X3=$TR($E(X2,L),",)"),X2=$E(X2,1,(L-1))_X3 Q X1_$S(X2]"":"("_X2_")",1:"")
WP(DIQGSA,DIQGTA,DIQGZN,DIQGP) N DIQG S DIQG=0 F  S DIQG=$O(@DIQGSA@(DIQG)) Q:DIQG'>0  I $D(^(DIQG,0)) S @$S(DIQGZN:"@DIQGTA@(DIQG,0)",1:"@DIQGTA@(DIQG)")=^(0)
 Q:DIQGP "$WP$" Q ""
DY(Y) Q $$FMTE^DILIBF(Y,"1U")
IEN(IEN,DA) S DA=$P(IEN,",") N I F I=2:1 Q:$P(IEN,",",I)=""  S DA(I-1)=$P(IEN,",",I)
 Q
DDROOT(X) Q:'$D(^DD(X)) "" Q "^DD("_X_","
 ;
F(DIQGEY,X) D BLD^DIALOG($P($T(TXT+X),";",4),.DIQGEY)
FE I $G(DIQGERRA)]"" D CALLOUT^DIEFU(DIQGERRA)
 Q ""
TXT ;;
 ;;file root/ref invalid;202;1
 ;;record invalid;202;2
 ;;multiline computed;520;3
 ;;file ref invalid;202;4
 ;;field name/number invalid;202;5
 ;;DD ref for file/field invalid;401;6
 ;;unable to find field name;200;7
 ;;unable to identify type of data in DD;510;8
 ;;unable to resolve extended ref;501;9
 ;;field ref missing;202;10
 ;;multiple field - invalid parameters;309;11
 ;;file number not passed or invalid;202;12
 ;;;;13
 ;;invalid target array;202;14
 ;;ambiguous field name;505;15
 ;;record unavailable;602;16
 ;;invalid attribute;202;17
 ;;file not found;202;18
 ;;record entry does not exist;601;19
 ;;;;20
