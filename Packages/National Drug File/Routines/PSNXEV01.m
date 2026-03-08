PSNXEV01 ;IHS/MSC/PLS - Environment Check routine for IHS PSN 1001;10-Mar-2006 10:18;PLS
 ;;4.0;NATIONAL DRUG FILE;**1001*; January 23, 2006
 ;;
ENV ; Must have PSN*4.0*77 Installed
 I '$$PATCH^XPDUTL("PSN*4.0*77") D  Q
 .D BMES^XPDUTL("Patch PSN*4.0*77 must be installed prior to installing this patch.")
 .S XPDABORT=1
 I $$PATCH("PSN*4.0*1001") D
 .D BMES^XPDUTL("Patch PSN*4.0*1001 has already been installed.")
 .S XPDABORT=1
 Q
PATCH(X) ;Return status of patch
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.6N 0
 N %,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S %=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+%)
 ;
