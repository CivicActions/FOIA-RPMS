BTIUP25 ; IHS/MSC/MGH - ENV CHECK FOR PATCH 1025;01-Dec-2021 14:11;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1025**;SEPT 04, 2005;Build 8
 ;
ENV ;EP environment check
 N PATCH,IN,STAT,INSTDA
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="TIU*1.0*1024"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 ;S IN="EHR*1.1*33",INSTDA=""
 ;I '$D(^XPD(9.7,"B",IN)) D  Q
 ;.W !,"You must first install the EHR patch 33 before installing patch TIU 1025"
 ;S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 ;S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 ;I STAT'=3 D  Q
 ;.W !,"EHR patch 33 must be completely installed before installing TIU patch 1025"
 ;S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
PRE ;EP; beginning of pret install code
 Q
POST ;EP; beginning of post install code
 Q
