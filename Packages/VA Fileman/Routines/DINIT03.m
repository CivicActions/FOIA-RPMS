DINIT03 ;SFISC/DPC-FORM FOR FOREIGN FORMATS ;2/24/93  13:18 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(ENTRY+I) G:X="" ^DINIT04 S Y=$E($T(ENTRY+I+1),5,999),X=$E(X,4,999),@X=Y
 Q
ENTRY ;
 ;;^DIST(.403,.441,0)
 ;;=DDXP FF FORM1^^^^2920925^2921112.085213^^.44
 ;;^DIST(.403,.441,20)
 ;;=D FORMVAL^DDXP1
 ;;^DIST(.403,.441,40,0)
 ;;=^.4031I^3^3
 ;;^DIST(.403,.441,40,1,0)
 ;;=1^^1,1^2^2^0
 ;;^DIST(.403,.441,40,1,1)
 ;;=PAGE 1
 ;;^DIST(.403,.441,40,1,15,0)
 ;;=^^1^1^2920925^^
 ;;^DIST(.403,.441,40,1,15,1,0)
 ;;=First page for Foreign Format definition.  It contains block DDXP FF BLK1.
 ;;^DIST(.403,.441,40,1,40,0)
 ;;=^.4032PI^.441^1
 ;;^DIST(.403,.441,40,1,40,.441,0)
 ;;=.441^1^1,1^e
 ;;^DIST(.403,.441,40,1,40,"AC",1,.441)
 ;;=
 ;;^DIST(.403,.441,40,1,40,"B",.441,.441)
 ;;=
 ;;^DIST(.403,.441,40,2,0)
 ;;=2^^1,1^1^1^0
 ;;^DIST(.403,.441,40,2,1)
 ;;=PAGE 2
 ;;^DIST(.403,.441,40,2,15,0)
 ;;=^^2^2^2920925^
 ;;^DIST(.403,.441,40,2,15,1,0)
 ;;=Page 2 of the form used to define a Foreign Format.  It contains block
 ;;^DIST(.403,.441,40,2,15,2,0)
 ;;=DDXP FF BLK2 and subpage containing DDXP FF BLK3.
 ;;^DIST(.403,.441,40,2,40,0)
 ;;=^.4032PI^.442^1
 ;;^DIST(.403,.441,40,2,40,.442,0)
 ;;=.442^1^1,1^e
 ;;^DIST(.403,.441,40,2,40,"AC",1,.442)
 ;;=
 ;;^DIST(.403,.441,40,2,40,"B",.442,.442)
 ;;=
 ;;^DIST(.403,.441,40,3,0)
 ;;=3^^12,23^^^1^16,59
 ;;^DIST(.403,.441,40,3,1)
 ;;=POP-UP PAGE 1
 ;;^DIST(.403,.441,40,3,15,0)
 ;;=^^2^2^2920925^^
 ;;^DIST(.403,.441,40,3,15,1,0)
 ;;=This pop-up page is called from page 2 of DDXP FF FORM1.  It contains
 ;;^DIST(.403,.441,40,3,15,2,0)
 ;;=block DDXP FF BLK3, which has the OTHER NAME FOR FORMAT multiple.
 ;;^DIST(.403,.441,40,3,40,0)
 ;;=^.4032PI^.443^1
 ;;^DIST(.403,.441,40,3,40,.443,0)
 ;;=.443^1^1,1^e
 ;;^DIST(.403,.441,40,3,40,"AC",1,.443)
 ;;=
 ;;^DIST(.403,.441,40,3,40,"B",.443,.443)
 ;;=
 ;;^DIST(.403,.441,40,"B",1,1)
 ;;=
 ;;^DIST(.403,.441,40,"B",2,2)
 ;;=
 ;;^DIST(.403,.441,40,"B",3,3)
 ;;=
 ;;^DIST(.403,.441,40,"C","PAGE 1",1)
 ;;=
 ;;^DIST(.403,.441,40,"C","PAGE 2",2)
 ;;=
 ;;^DIST(.403,.441,40,"C","POP-UP PAGE 1",3)
 ;;=
