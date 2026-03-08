BEHOIMP1 ;IHS/MSC/PLS - SUPPORT FOR IMPLANTABLE DEVICES ;22-Nov-2022 16:54;PLS
 ;;1.1;BEH COMPONENTS;**073001,073003**;March 20,2007
 ;
 Q
 ;Return device count for patient
GETCNT(DATA,DFN) ;-
 N CNT,LP
 S (CNT,LP)=0 F  S LP=$O(^AUPNPDEV("C",DFN,LP)) Q:'LP  S CNT=CNT+1
 S DATA=CNT
 Q
 ;Return list of devices associated with patient
PTDEVLST(DATA,DFN) ;-
 N CNT,LP,ID
 S CNT=0
 S DATA=$$TMPGBL("IMPDEVICES")
 D XMLHDR
 D ADD($$TAG("ImplantEntries",0))
 D ADDEXTR
 S LP=0 F  S LP=$O(^AUPNPDEV("AC",DFN,LP)) Q:LP=""  D
 .D IMPDEV(LP)
 D ADD($$TAG("ImplantEntries",1))
 Q
ADDEXTR ;-
 D ADD($$TAG("ExtractInfo",0))
 D ADD($$TAG("PatientName",2,$$GET1^DIQ(2,DFN,.01)))
 D ADD($$TAG("PatientHRN",2,$$HRN^AUPNPAT(DFN,$G(DUZ(2)))))
 D ADD($$TAG("Requestor",2,$$GET1^DIQ(200,DUZ,.01)))
 D ADD($$TAG("RequestLocation",2,$$GET1^DIQ(4,+$G(DUZ(2)),.01)))
 D ADD($$TAG("RequestDate",2,$TR($$FMTE^XLFDT($$NOW^XLFDT(),"5Z0"),"@"," ")))
 D ADD($$TAG("ExtractInfo",1))
 Q
IMPDEV(IEN) ;-
 N CALCDT
 N N0,VAL,BSITE,BSTS
 S N0=^AUPNPDEV(IEN,0)
 D ADD($$TAG("ImplantEntry"))
 D ADD($$TAG("IEN",2,IEN))
 D ADD($$TAG("Category"))
 D ADD($$TAG("IEN",2,$$GD(N0,1)))
 D ADD($$TAG("Name",2,$$GET1^DIQ(9999999.106,$$GD(N0,1),.01)))
 D ADD($$TAG("Category",1))
 D ADD($$TAG("Patient"))
 D ADD($$TAG("DFN",2,$$GD(N0,2)))
 D ADD($$TAG("Name",2,$$GET1^DIQ(2,$$GD(N0,2),.01)))
 D ADD($$TAG("Patient",1))
 ;I $$GD(N0,3) D
 D ADD($$TAG("Visit"))
 D ADD($$TAG("IEN",2,+$$GD(N0,3)))
 D ADD($$TAG("FMDate",2,$$GET1^DIQ(9000010,$$GD(N0,3),.01,"I")))
 D ADD($$TAG("External",2,$$FMTE^XLFDT($$GET1^DIQ(9000010,$$GD(N0,3),.01),"5Z0")))
 D ADD($$TAG("Visit",1))
 D ADD($$TAG("EnteredBy"))
 D ADD($$TAG("IEN",2,+$$GD(N0,4)))
 D ADD($$TAG("Name",2,$$GET1^DIQ(200,$$GD(N0,4),.01)))
 D ADD($$TAG("EnteredBy",1))
 D ADD($$TAG("EnteredDate"))
 D ADD($$TAG("FMDate",2,$$GD(N0,5)))
 D ADD($$TAG("External",2,$$FMTE^XLFDT($$GD(N0,5),"5Z0")))
 D ADD($$TAG("EnteredDate",1))
 D ADD($$TAG("ImplantDate"))
 D ADD($$TAG("FMDate",2,$$GD(N0,6)))
 D ADD($$TAG("External",2,$$FMTE^XLFDT($$GD(N0,6),"5Z0")))
 D ADD($$TAG("ImplantDate",1))
 D ADD($$TAG("RemovedDate"))
 D ADD($$TAG("FMDate",2,$$GD(N0,7)))
 D ADD($$TAG("External",2,$$FMTE^XLFDT($$GD(N0,7),"5Z0")))
 D ADD($$TAG("RemovedDate",1))
 D ADD($$TAG("EffectiveUntilDate"))
 D ADD($$TAG("FMDate",2,$$GD(N0,13)))
 D ADD($$TAG("External",2,$$FMTE^XLFDT($$GD(N0,13),"5Z0")))
 D ADD($$TAG("EffectiveUntilDate",1))
 D ADD($$TAG("ImplantedBy"))
 D ADD($$TAG("IEN",2,+$$GET1^DIQ(9000091,IEN,6.01,"I")))
 D ADD($$TAG("Name",2,$$GET1^DIQ(9000091,IEN,6.01)))
 D ADD($$TAG("ImplantedBy",1))
 D ADD($$TAG("Status",2,$$TITLE^XLFSTR($$GET1^DIQ(9000091,IEN,3.1))))
 ;D ADD($$TAG("Procedure",2,$$GD(N0,9)))
 D ADD($$TAG("Procedure"))
 D ADD($$TAG("Code",2,$$GET1^DIQ(9000091,IEN,.092)))
 D ADD($$TAG("Desc",2,$$GET1^DIQ(9000091,IEN,.093)))
 D ADD($$TAG("CodeSet",2,$$GET1^DIQ(9000091,IEN,.091)))
 D ADD($$TAG("Procedure",1))
 D ADD($$TAG("AssocProblem"))
 D ADD($$TAG("IEN",2,+$$GD(N0,8)))
 S VAL=$$GET1^DIQ(9000091,IEN,".08:.05")
 S:'$L($P(VAL,"| ",2)) VAL=$P(VAL,"| ")
 D ADD($$TAG("Name",2,VAL))
 D ADD($$TAG("AssocProblem",1))
 ;D ADD($$TAG("BodySite",2,$$GD(N0,10)))
 S BSITE=$$GET1^DIQ(9000091,IEN,.1,"I")
 S BSTS=$$DESC^BSTSAPI(BSITE)
 D ADD($$TAG("BodySite"))
 D ADD($$TAG("SCTCode",2,BSITE))
 D ADD($$TAG("DTCode",2,$$GD(BSTS,1)))
 D ADD($$TAG("DescText",2,$$GD(BSTS,2)))
 D ADD($$TAG("EasyText",2,$$GD(BSTS,2)))
 D ADD($$TAG("BodySite",1))
 D ADD($$TAG("EntryMethod",2,$$GD(N0,11)))
 D ADD($$TAG("Facility"))
 D ADD($$TAG("IEN",2,+$$GET1^DIQ(9000091,IEN,1.01,"I")))
 D ADD($$TAG("Name",2,$$GET1^DIQ(9000091,IEN,1.09)))
 D ADD($$TAG("Address1",2,$$GET1^DIQ(9000091,IEN,1.03)))
 D ADD($$TAG("Address2",2,$$GET1^DIQ(9000091,IEN,1.04)))
 D ADD($$TAG("City",2,$$GET1^DIQ(9000091,IEN,1.05)))
 D ADD($$TAG("State",2,$$GET1^DIQ(9000091,IEN,1.06)))
 D ADD($$TAG("Zip",2,$$GET1^DIQ(9000091,IEN,1.07)))
 D ADD($$TAG("Facility",1))
 D ADD($$TAG("Description",2,$$GET1^DIQ(9000091,IEN,2)))
 D ADD($$TAG("OriginalSearchValue",2,$$GET1^DIQ(9000091,IEN,2.1)))
 D ADD($$TAG("PrimarySNOMEDDesc",2,$$GPRMSNM(IEN)))
 D ADD($$TAG("PrimaryGMDNName",2,$$GPRMGMDN(IEN)))
 D INACTIVE
 D COMMENTS
 D DEVICES(IEN)
 D ADD($$TAG("ImplantEntry",1))
 Q
 ;Build Comments
COMMENTS ;
 N CDT,LP,LP1,EDT,EUSR,COM,N0,X
 D ADD($$TAG("Comments"))
 S CDT=9999999 F  S CDT=$O(^AUPNPDEV(IEN,5,"B",CDT),-1) Q:'CDT  D
 .S LP=0 F  S LP=$O(^AUPNPDEV(IEN,5,"B",CDT,LP)) Q:'LP  D
 ..K COM S COM=""
 ..S N0=^AUPNPDEV(IEN,5,LP,0)
 ..S X=$$GET1^DIQ(9000091.5,LP_","_IEN_",",1,"","COM")
 ..S COM=$$COMDT($P(N0,U))_" - "_$$GET1^DIQ(200,$P(N0,U,2),.01)_" - "
 ..S LP1=0 F  S LP1=$O(COM(LP1)) Q:'LP1  D
 ...S COM=COM_$S(($E(COM,$L(COM))'=" ")&($E(COM(LP1),1)'=" "):" ",1:"")_COM(LP1)
 ..D:$L(COM) ADD($$TAG("Comment",2,COM))
 D ADD($$TAG("Comments",1))
DEVICES(TIEN) ;-
 N SIEN,N0,IENS
 D ADD($$TAG("Devices"))
 S SIEN=0 F  S SIEN=$O(^AUPNPDEV(TIEN,4,SIEN)) Q:'SIEN  D
 .D ADD($$TAG("Device"))
 .S IENS=SIEN_","_TIEN_","
 .S N0=^AUPNPDEV(TIEN,4,SIEN,0)
 .D ADD($$TAG("IEN",2,SIEN))
 .D ADD($$TAG("Name",2,$$GET1^DIQ(9000091.4,IENS,10.01)))
 .D ADD($$TAG("ID",2,$$GD(N0,1)))
 .D ADD($$TAG("ID_Issuing_Agency",2,$$GET1^DIQ(9000091.4,IENS,8.01,"I")))
 .D ADD($$TAG("UDI",2,$$GET1^DIQ(9000091.4,IENS,9.01)))
 .D ADD($$TAG("ImplantedBy"))  ;,2,$$GET1^DIQ(9000091.4,IENS,.02,"I")))
 .D ADD($$TAG("IEN",2,+$$GD(N0,2)))
 .D ADD($$TAG("Name",2,$$GET1^DIQ(9000091.4,IENS,.02)))
 .D ADD($$TAG("ImplantedBy",1))
 .D ADD($$TAG("SerialNumber",2,$$GD(N0,3)))
 .D ADD($$TAG("Lot_Batch",2,$$GD(N0,4)))
 .D ADD($$TAG("ManufacturedDate"))
 .D ADD($$TAG("FMDate",2,$$GD(N0,5)))
 .D ADD($$TAG("External",2,$$FMTE^XLFDT($$GD(N0,5),"5Z0")))
 .D ADD($$TAG("ManufacturedDate",1))
 .D ADD($$TAG("ExpirationDate"))
 .D ADD($$TAG("FMDate",2,$$GD(N0,6)))
 .D ADD($$TAG("External",2,$$FMTE^XLFDT($$GD(N0,6),"5Z0")))
 .D ADD($$TAG("ExpirationDate",1))
 .D ADD($$TAG("HCTP",2,+$$GD(N0,7)))
 .D ADD($$TAG("GMDN_PT_Name",2,$$GET1^DIQ(9000091.4,IENS,1.01)))
 .D ADD($$TAG("SNOMED_CT_ID",2,$$GET1^DIQ(9000091.4,IENS,1.02)))
 .D ADD($$TAG("SNOMED_CT_DESC",2,$$GET1^DIQ(9000091.4,IENS,11.01)))  ;;$P($$CONC^BSTSAPI($$GET1^DIQ(9000091.4,IENS,1.02)),U,2)))
 .D ADD($$TAG("BrandName",2,$$GET1^DIQ(9000091.4,IENS,2.01)))
 .D ADD($$TAG("Version_Model",2,$$GET1^DIQ(9000091.4,IENS,2.02)))
 .D ADD($$TAG("CompanyName",2,$$GET1^DIQ(9000091.4,IENS,3.01)))
 .D ADD($$TAG("LatexWarning",2,+$$GET1^DIQ(9000091.4,IENS,3.02,"I")))
 .D ADD($$TAG("Description",2,$$GETWP(9000091.4,IENS,4)))
 .D ADD($$TAG("MRI_Safety_Info",2,$$GETWP(9000091.4,IENS,5)))
 .D ADD($$TAG("OriginalSearchValue",2,$$GET1^DIQ(9000091.4,IENS,7.01)))
 .D ADD($$TAG("Device",1))
 D ADD($$TAG("Devices",1))
 Q
 ;
INACTIVE ;-
 N LP,DAT,QFLG
 S QFLG=0
 S LP=$O(^AUPNPDEV(IEN,3,$C(1)),-1) Q:'LP!QFLG  D
 .S DAT=^AUPNPDEV(IEN,3,LP,0)
 .Q:$P(DAT,U,2)'="I"
 .S QFLG=1
 .D ADD($$TAG("InactiveInfo",2,$P(DAT,U)_U_$$GET1^DIQ(9000091.3,LP_","_IEN_",",.04)_U_$P(DAT,U,4)_U_$$GET1^DIQ(9000091.3,LP_","_IEN_",",.03)))
 Q
 ; Add XML Header to return array
XMLHDR ;-
 D ADD("<?xml version=""1.0"" ?>")
 Q
 ; Returns formatted tag
 ; Input: TAG - Name of Tag
 ;        TYPE - (-1) = empty 0 =start <tag>   1 =end </tag>  2 = start -VAL - end
 ;        VAL - data value
TAG(TAG,TYPE,VAL) ;EP -
 S TYPE=$G(TYPE,0)
 S:$L($G(VAL)) VAL=$$SYMENC^MXMLUTL(VAL)
 I TYPE<0 Q "<"_TAG_"/>"  ;empty
 E  I TYPE=1 Q "</"_TAG_">"
 E  I TYPE=2 Q "<"_TAG_">"_$G(VAL)_"</"_TAG_">"
 Q "<"_TAG_">"
 ; Add data to array
ADD(VAL) ;EP-
 S CNT=CNT+1
 S @DATA@(CNT)=VAL
 Q
 ;
 ; Return temp global reference
TMPGBL(TYPE) N GBL
 S GBL=$$TMPGBL^CIAVMRPC("_"_$G(TYPE))
 K @GBL
 Q GBL
 ; Return piece of data
GD(DAT,P,D) ;-
 S D=$G(D,U)
 Q $P(DAT,D,P)
 ;Format Date for Comment
COMDT(CDT) ;-
 N DTSTR
 S DTSTR=$$FMTE^XLFDT(CDT,"5Z0")
 S D=$P(DTSTR,"@"),D1=$P(DTSTR,"@",2),D2="("_$P(D1,":",1,2)_")"
 Q D_" "_D2
 ; Return string of WP data
GETWP(FILE,IENS,FLD) ;-
 N ARY,ARY1,LP,RES
 S RES=""
 D GETS^DIQ(FILE,IENS,FLD,"","ARY")
 S ARY1=$NA(ARY(FILE,IENS,FLD))
 S LP=0 F  S LP=$O(@ARY1@(LP)) Q:'LP  D
 .S RES=RES_$S($L(RES)&($E(RES,$L(RES))'=" ")&($E(@ARY1@(LP),1)'=" "):" ",1:"")_@ARY1@(LP)
 Q RES
 ;Get list of categories
GETCATGY(DATA) ;-
 N LP,CNT
 S CNT=0
 S DATA=$$TMPGBL("CATEGORIES")
 S LP=0 F  S LP=$O(^AUTTIMDC(LP)) Q:'LP  D
 .S CNT=CNT+1
 .S @DATA@(CNT)=LP_U_$P(^AUTTIMDC(LP,0),U)_U_$P(^AUTTIMDC(LP,0),U,4)
 Q
 ;Update status
UPTSTS(DATA,IEN,STS,RSN) ;-
 N ERR,FN,FDA,IENS
 S FN=9000091.3
 S IENS="+1,"_IEN_","
 S FDA(FN,IENS,.01)=$$DT^XLFDT()
 S FDA(FN,IENS,.02)=STS
 S FDA(FN,IENS,.03)=DUZ
 S FDA(FN,IENS,.04)=$G(RSN)
 D UPDATE^DIE("","FDA",,"ERR")
 S DATA=$S($G(ERR("DIERR",1)):-ERR("DIERR",1)_U_ERR("DIERR",1,"TEXT",1),1:1)
 Q
 ;Get list of body locations for an Implant Category from DTS
GETBLOCS(DATA,IMPCAT) ;-
 N LP,CNT,DTS,VAL
 S CNT=0
 S DATA=$$TMPGBL("BODYLOC")
 S DTS=$P($G(^AUTTIMDC(IMPCAT,0)),U,4)
 S VAL=$$SUBLST^BSTSAPI(.DATA,DTS_"^^^^1")
 Q
GPRMSNM(IEN) ;-
 N RET,SIEN,DAT
 S RET=""
 S SIEN=$O(^AUPNPDEV(IEN,4,0))
 S RET=$S(SIEN:$P($$CONC^BSTSAPI($$GET1^DIQ(9000091.4,SIEN_","_IEN_",",1.02)),U,2),1:"")
 ;S SIEN=0 F  S SIEN=$O(^AUPNPDEV(IEN,4,SIEN)) Q:'SIEN  D
 ;.;$P($$CONC^BSTSAPI($$GET1^DIQ(9000091.4,IENS,1.02)),U,2)
 ;
 Q RET
GPRMGMDN(IEN) ;-
 N RET,SIEN,DAT
 S RET=""
 S SIEN=$O(^AUPNPDEV(IEN,4,0))
 S RET=$S(SIEN:$$GET1^DIQ(9000091.4,SIEN_","_IEN_",",1.01),1:"")
 Q RET
