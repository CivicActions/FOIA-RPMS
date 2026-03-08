AGSETPRT ;IHS/ITSC/EG - SET FILE PROTECTIONS  [ 06/17/2003  10:47 AM ]
 ;;7.0;IHS PATIENT REGISTRATION;**2**;MAR 28, 2003
LP ;EP - loop through file entries
 F I=1:1 D  Q:AGTXT["end"
 .S AGTXT=$T(TXT+I)
 .Q:AGTXT["end"
 .F J=2:1:4 S AG(J)=$P(AGTXT,";;",J)
 .S AG(3)=""""_AG(3)_""""
 .S AGREF="^DIC("_AG(2)_",0,"_AG(3)_")"
 .S @AGREF=AG(4)
 Q
TXT ;file entries start here
 ;;9000039;;AUDIT;;@
 ;;9000039;;DD;;@
 ;;9000039;;DEL;;M
 ;;9000039;;LAYGO;;M
 ;;9000039;;RD;;M
 ;;9000039;;WR;;M
 ;;end
 Q
