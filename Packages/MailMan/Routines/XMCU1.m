XMCU1 ;(WASH ISC)/CMW-DECODE/ENCODE STRING TRANSPARENTLY ;12/4/93  11:24
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ; DECODE STRING FOR TRANSPARENT RECEIVING
 ;
 ;Extrinsic Function to decode control characters
 ;Input=STRING
 ;Output=STRING
 ;
RTRAN(XXX) ; New all variables that are used in this function call
 ;
 N XMESC,X,Y,X1,I
 S XMESC="~"
 Q:XXX'[XMESC
 S Y="",X1=XXX
R1 S I=$F(X1,XMESC) I I=0 S X=Y_X1 G SET
 S Y=Y_$E(X1,1,I-2)_$C($A($E(X1,I))-64#128),X1=$E(X1,I+1,999) G R1
SET S %=X
 Q %
 ; ENCODE STRING FOR TRANSPARENT RECEIVING
 ;
 ;Extrinsic Function to encode control characters
 ;Input=STRING
 ;Output=STRING
 ;
STRAN(XXX) ; New all variables that are used in this function call
 ;
 N XMESC,Y,X1,I
 S XMESC="~"
 S Y="" F I=1:1:$L(XXX) S X1=$E(XXX,I) S Y=Y_$S(X1=XMESC:XMESC_$C(62),X1?1C:XMESC_$C($A(X1)+64#128),1:X1)
 S %=Y
 Q %
ENCODEUP(XXX) ; Extrinsic Function to encode "^" into "~U~"
 ; Input=STRING
 ; Output=STRING
 F  Q:XXX'[U  S XXX=$P(XXX,U)_"~U~"_$P(XXX,U,2,999)
 Q XXX
DECODEUP(XXX) ; Extrinsic Function to decode "~U~" to "^"
 ; Input=STRING
 ; Output=STRING
 F  Q:XXX'["~U~"  S XXX=$P(XXX,"~U~")_"^"_$P(XXX,"~U~",2,999)
 Q XXX
