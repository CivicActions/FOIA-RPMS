BSTSXREF ;GDHS/HS/ALA-Concept ID Cross-references ; 16 Dec 2015  1:35 PM
 ;;2.0;IHS STANDARD TERMINOLOGY;**7**;Dec 01, 2016;Build 8
 ;
 Q
 ;
 NEW CDN,CDS,CID,X,DA
 ;
VSX ;EP - Variable set xref
 I $G(DA(2)) D
 . D VR
 S ^BSTS(9002318.4,"J",CDS,CID,X,DA(2),DA(1),DA)=""
 Q
 ;
VKX ;EP - Variable kill xref
 I $G(DA(2)) D
 . D VR
 K ^BSTS(9002318.4,"J",CDS,CID,X,DA(2),DA(1),DA)
 Q
 ;
VR ;EP - Set up variables
 S CDN=$P($G(^BSTS(9002318.4,DA(2),0)),U,7),CDS=$P($G(^BSTS(9002318.1,CDN,0)),"^",1)
 S CID=$P($G(^BSTS(9002318.4,DA(2),0)),U,2)
 Q
 ;
SSUBT ;Create TSUB XREF
 ;
 NEW SNAME,INAM
 ;
 I '$G(DA(1)) Q
 I '$G(DA) Q
 I $G(X)="" Q
 ;
 ;Get subset name
 S SNAME=$P($G(^BSTS(9002318.4,DA(1),4,DA,0)),U) Q:SNAME=""
 ;
 ;Get internal namespace
 S INAM=$P($G(^BSTS(9002318.4,DA(1),0)),U,7) Q:INAM=""
 ;
 ;Define cross reference
 S ^BSTS(9002318.4,"TSUB",INAM,X,SNAME,DA(1),DA)=""
 ;
 Q
 ;
KSUBT ;Kill TSUB XREF
 ;
 ;
 NEW SNAME,INAM
 ;
 I '$G(DA(1)) Q
 I '$G(DA) Q
 I $G(X)="" Q
 ;
 ;Get subset name
 S SNAME=$P($G(^BSTS(9002318.4,DA(1),4,DA,0)),U) Q:SNAME=""
 ;
 ;Get internal namespace
 S INAM=$P($G(^BSTS(9002318.4,DA(1),0)),U,7) Q:INAM=""
 ;
 ;Define cross reference
 K ^BSTS(9002318.4,"TSUB",INAM,X,SNAME,DA(1),DA)
 ;
 Q
 ;
SSUBI ;Create ISUB XREF
 ;
 NEW SNAME,INAM
 ;
 I '$G(DA(1)) Q
 I '$G(DA) Q
 I $G(X)="" Q
 ;
 ;Get subset name
 S SNAME=$P($G(^BSTS(9002318.4,DA(1),4,DA,0)),U) Q:SNAME=""
 ;
 ;Get internal namespace
 S INAM=$P($G(^BSTS(9002318.4,DA(1),0)),U,7) Q:INAM=""
 ;
 ;Define cross reference
 S ^BSTS(9002318.4,"ISUB",INAM,SNAME,X,DA(1),DA)=""
 ;
 Q
 ;
KSUBI ;Kill ISUB XREF
 ;
 ;
 NEW SNAME,INAM
 ;
 I '$G(DA(1)) Q
 I '$G(DA) Q
 I $G(X)="" Q
 ;
 ;Get subset name
 S SNAME=$P($G(^BSTS(9002318.4,DA(1),4,DA,0)),U) Q:SNAME=""
 ;
 ;Get internal namespace
 S INAM=$P($G(^BSTS(9002318.4,DA(1),0)),U,7) Q:INAM=""
 ;
 ;Define cross reference
 K ^BSTS(9002318.4,"ISUB",INAM,SNAME,X,DA(1),DA)
 ;
 Q
