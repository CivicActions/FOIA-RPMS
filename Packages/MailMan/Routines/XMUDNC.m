XMUDNC ;SFISC/GMB - Domain Name Change ;02/03/99  08:33
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; A domain name change happens in two steps, in two patches:
 ; 1. The first patch adds the new name as a synonym to the site's
 ;    DOMAIN file entry at all sites.  (Entry SYNONYM)
 ; 2. When all sites have added the synonym, the second patch switches
 ;    the names in the DOMAIN file at all sites.  The synonym becomes
 ;    the domain name, and old domain name becomes the synonym.
 ;    The domain name is changed in each TCP/IP script, too.
 ;    The site's name is changed in file 4.3 MAILMAN SITE PARAMETERS.
 ;    (Entry CHANGE)
SYNONYM ;
 D BMES^XPDUTL("Add <new site name> as synonym for <current site name> in DOMAIN file.")
 N XMB,XMI,XMDOM,XMSUBDOM,XMSYN
 ;D INIT(XMLINE)
 S (XMB,XMI)=""
 F  S XMB=$O(^DIC(4.2,"B",XMB)) Q:XMB=""  D
 . F  S XMI=$O(^DIC(4.2,"B",XMB,XMI)) Q:XMI=""  D
 . . N DIC,X,Y
 . . S (X,XMDOM)=$P(^DIC(4.2,XMI,0),U,1)
 . . S XMSUBDOM=""
 . . S DIC="^DOPT(""XMSYN"",$J,"
 . . S DIC(0)="XZ"
 . . F  D ^DIC Q:Y>0!($L(X,".")<4)  D
 . . . S XMSUBDOM=XMSUBDOM_$P(X,".")_"."
 . . . S X=$P(X,".",2,99)
 . . Q:Y<0  ; Quit if (sub) domain is not in the table
 . . D BMES^XPDUTL("Domain: "_XMDOM)
 . . S XMSYN=$P(Y(0),U,2)
 . . I XMSYN="" S XMSYN=$P(XMDOM,".",1,$L(XMDOM,".")-2)_".MED.VA.GOV"
 . . E  S XMSYN=XMSUBDOM_XMSYN
 . . D CHKSYN(XMI,XMSYN)
 K ^DOPT("XMSYN",$J)
 Q
INIT(XMENTRY) ; Load table into global
 ; XMENTRY="T+I^XMYPOSTA"
 N DIK,I,X
 K ^DOPT("XMSYN",$J)
 S DIK="^DOPT(""XMSYN"",$J,"
 S ^DOPT("XMSYN",$J,0)="Domain Synonyms^1N^"
 F I=1:1 S X=$T(@XMENTRY) Q:X=" ;;"  S ^DOPT("XMSYN",$J,I,0)=$E(X,4,255)
 D IXALL^DIK
 Q
CHKSYN(XMDIEN,XMSYN) ;
 N XMSIEN
 D MES^XPDUTL("Lookup Synonym: "_XMSYN)
 S XMSIEN=$$FIND1^DIC(4.2,"","MQX",XMSYN,"B^C")
 I $D(DIERR) D  Q
 . N XMI
 . D MES^XPDUTL("*** Error on look up!")
 . D MES^XPDUTL("*** Usually means more than one occurence.")
 . I $D(^DIC(4.2,"B",XMSYN)) D MES^XPDUTL("*** Synonym is also a domain!")
 . S XMI=0
 . F  S XMI=$O(^DIC(4.2,"C",XMSYN,XMI)) Q:'XMI  D
 . . D MES^XPDUTL("*** Synonym is for domain IEN "_XMI_", name "_$P(^DIC(4.2,XMI,0),U,1))
 . D MES^XPDUTL("*** No action taken.  Please investigate and fix.")
 I XMSIEN=XMDIEN D MES^XPDUTL("Already there.") Q
 I XMSIEN D  Q
 . I $D(^DIC(4.2,"B",XMSYN)) D MES^XPDUTL("*** Synonym is also a domain!")
 . E  D MES^XPDUTL("*** Synonym is for domain IEN "_XMSIEN_", name "_$P(^DIC(4.2,XMSIEN,0),U,1))
 . D MES^XPDUTL("*** No action taken.  Please investigate and fix.")
 D MES^XPDUTL("Not found.  Adding it.")
 S XMFDA(4.23,"+1,"_XMDIEN_",",.01)=XMSYN
 D UPDATE^DIE("","XMFDA")
 I $D(DIERR) D MES^XPDUTL("*** Error adding it!")
 Q
T ;;site.va.gov^site.med.va.gov
 ;;ISC-SF.VA.GOV^ISC-SF.MED.VA.GOV
 ;;
