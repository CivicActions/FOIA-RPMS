XMAREAD ;(WASH ISC)/CAP - READ INPUT ;10/25/93  14:59
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ;Usage as an extrinsic function:
 ;S X=$$READ^XMAREAD(X,Y,Z,A,.H) - to ask prompt...(H is array of help)
 ;S X=$$CHECK^XMAREAD(Y,Z)  -- To check input
 ;
 ;  XMCHAN is internally used as a silent flag
 ;
READ(X,Y,Z,A,H) ;
 ;X=Prompt
 ;Y = "F"=Free text, "N"=Number, "U"=Abort PROMPT, "Y"=Yes or No
 ;Z=Default
 ;A=Do NOT Screen for invalid punctuation if $G(A)=1
 ;H=Array of help
 N %0 I $G(A) N XMREADNO S XMREADNO=1
 I Y="U",X="" S X="Enter return to continue, '^' to abort: "
 N % I $D(Z)#2'=1 S Z=""
R W !,X_" " I $L(Z) W Z_"// "
 R %:DTIME
CK G RQ:%["^" I Y'="N",%=" " G RQ
 I %="" G RQ:'$L(Z) S %=Z D @(Y_"C") G R:%="" G RQ
 I $G(XMCHAN) G @Y
 D @Y G RQ:$L(%),R
 ;
F ;Free Text
FC I '$D(XMREADNO),%["?" G:%["??" H:$D(H) I "??"[% S %0="Enter a free text string that is between 3 and 30 characters long." G CQ:$G(XMCHAN) W !,%0 S %="" Q
 I '$D(XMREADNO),$L(%)<3 S %0="  <<< Must be longer than 3 characters >>>" G CQ:$G(XMCHAN) W %0 S %="" Q
 I '$D(XMREADNO),$L(%)>30 S %0="   <<< Must be shorter than 30 characters >>>" G CQ:$G(XMCHAN) W %0 S %="" Q
 I '$D(XMREADNO),$L($TR(%,"@^!()#~_-=%$|[]\""><",""))'=$L(%) S %0="   <<< Input contains illegal (@^!#~_-=%$|[]\""><?) characters. >>>" G CQ:$G(XMCHAN) W !,%0 S %="" Q
 I %?.E1C.E S %0="   <<< Input contains control characters. >>>" G CQ:$G(XMCHAN) W !,%0 S %="" Q
 F  Q:$E(%)'=" "  S %=$E(%,2,999)
 F  Q:$E(%,$L(%))'=" "  S %=$E(%,1,$L(%)-1)
 G QQ
Y ;Yes or No question
YC I %["?" G:%["??" H:$D(H) I "??"[% S %0="Enter 'YES' or 'NO'" G CQ:$G(XMCHAN) W !!,%0,! S %="" Q
 S %=$TR(%,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 I $E("NO",1,$L(%))=% G QQ:$G(XMCHAN) W:'$L(Z) $E("NO",$L(%)+1,2) S %=0 Q
 I $E("YES",1,$L(%))=% G QQ:$G(XMCHAN) W:'$L(Z) $E("YES",$L(%)+1,3) S %=1 Q
 S %="" G QQ:'$G(XMCHAN) S %0="Enter 'YES' or 'NO' !" G CQ
 ;
N ;Numerical Answer
NC I %["?" G:%["??" H:$D(H) I "??"[% S %0="Enter an integer" G CQ:$G(XMCHAN) W !,%0 S %="" Q
 I %'?1.N,%'="" S %0=" ???"_$C(7) G CQ:$G(XMCHAN) W %0 S %="" Q
 Q
U ;Abort
UC I %["?" G:%["??" H:$D(H) W !,"No help available !" I "??"[% S %="" Q
 Q
H ;Display Long help
 Q:$D(XMREADNO)  W ! S %="" F  S %=$O(H(%)) Q:%=""  W !,H(%)
 W ! Q
 ;Quit if from Input Checker
QQ I '$G(XMCHAN) Q
 Q ""
RQ Q $S($G(XMCHAN):"",1:%)
CHECK(Y,Z) ;Check Input
 N %0,XMCHAN S XMCHAN=1 S %=Z
 G CK
CQ Q %0
