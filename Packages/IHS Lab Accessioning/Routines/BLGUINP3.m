BLGUINP3 ;IHS/MSC/PLS - BLGU Patch 3 Support;06-Jul-2022 10:06;PLS
 ;;1.0;LAB ACCESSIONING;;
ENV ;Display list of templates containing object and if present prevent installation
 I $$OBJINTPL() D
 .S XPDQUIT=2  ;prevent install but leave build in transport global
 .D MES^XPDUTL("")
 .D MES^XPDUTL("References to the Lab Accessioning component must be removed from")
 .D MES^XPDUTL("the above layout template(s) before this patch will install.")
 .D MES^XPDUTL("Use RPMS EHR in Design Mode to remove the component.")
 I $G(XPDENV)=1 D
 .N X
 .F X="XPZ1","XPZ2","XPI1","XPO1" S XPDDIQ(X)=0
 Q
POST ;Find IEN for obj
 N IEN
 S IEN=$$PRGID^CIAVMCFG("BLGULABACCESSION.LABACCESSION")
 I IEN D
 .N RES
 .S RES=$$ENTRY^CIAUDIC(19930.2,"@"_IEN)
 .D MES^XPDUTL($S('RES:"Component has been removed",1:"Unable to remove component"))
 E  D
 .D MES^XPDUTL("Component was not found on system.")
 Q
OBJINTPL() ;
 N X,OBJNM,TPLLST,LP
 S OBJNM="BLGULABACCESSION.LABACCESSION"
 S LP=0 F  S LP=$O(^CIAVTPL(LP)) Q:'LP  D:$$FIND(LP,OBJNM)
 .S TPLLST(^CIAVTPL(LP,0))=""
 .D MES^XPDUTL("The following template(s) contain references to the Lab Accessioning component:")
 .D MES^XPDUTL("")
 .N X S X="" F  S X=$O(TPLLST(X)) Q:X=""  D MES^XPDUTL(X)
 Q $D(TPLLST)
 ;
FIND(TPL,OBJNM) ;EP
 N X,Z,FOUND
 S (X,FOUND)=0
 F  S X=$O(^CIAVTPL(TPL,1,X)) Q:'X  S Z=$$UP^XLFSTR($G(^(X,0))) D
 .S:$F(Z,OBJNM)>0 FOUND=1
 Q FOUND
