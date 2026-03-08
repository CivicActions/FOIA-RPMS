APSPESUT ;IHS/MSC/MGH - Security Hash utilities ;11-Sep-2019 16:32;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1024**;Sep 23, 2004;Build 68
 ;
GENHASH(STR) ;-
 N X
 X "S X=##class(%SYSTEM.Encryption).SHAHash(256,STR)"
 X "S X=$System.Encryption.Base64Encode(X)"
 Q X
 ;
FNDHASH(STR) ;-
 Q:'$L($G(STR)) 0
 N HSHVAL
 S HSHVAL=$$GENHASH(STR)
 Q +$O(^PSDRUG("ALNGNM",HSHVAL,0))
