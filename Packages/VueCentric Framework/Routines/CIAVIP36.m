CIAVIP36 ;MSC/IND/PLS - EHR v1.1p35 Inits;04-Oct-2023 16:10;PLS
 ;;1.1;VUECENTRIC FRAMEWORK;**36**;23-Oct-2006
 ;;Copyright 2000-2021, Medsphere Systems Corporation
 ;=================================================================
EC ;EP - Environment check
 D CHKINS^CIAOINIT("EHR*1.1*35",2)
 Q
PRE ;EP - Preinit
 Q
POST ;EP - Postinit
 N VER,FDA,PID,IEN,X,TYPE,OBJS,LP,OBJNM
 D BMES^XPDUTL("Updating version numbers...")
 F VER=0:1 S X=$P($T(VER+VER),";;",2) Q:'$L(X)  D
 .S PID=$$PRGID^CIAVMCFG($P(X,";"))
 .S:PID FDA(19930.2,PID_",",2)=$P(X,";",2),FDA(19930.2,PID_",",7)=$P(X,";",3)
 D:$D(FDA) FILE^DIE(,"FDA")
 W !!!
 ;Update help file references
 D UPDCHM
 S OBJNM="FILE:TABCTL32.OCX"
 ;Mark object entries as Disabled
 D DISABLE(OBJNM)
 ;Remove object from USES of other objects
 D OBJUSES(.OBJS,OBJNM)
 S LP=0 F  S LP=$O(OBJS(LP)) Q:'LP  D
 .D DELUSES(OBJS(LP),OBJNM)
 ;
 ;
 ;Prompt to enable logins
 I $L($$GETLOGIN^CIAVUTIL),$$ASK^CIAU("Do you want to enable EHR logins","Y") D
 .D SDABORT^CIAVUTIL(,1),BMES^XPDUTL("Application logins have been enabled.")
 ;Update RPC registration
 D REGRPC
 Q
 ;Register RPCs to context
REGRPC ;EP-
 Q
 ; Update the friendly name of an existing object
UPDOBJNM(OBJ,NAME) ;EP-
 N PID,FDA
 S PID=$$PRGID^CIAVMCFG(OBJ)
 Q:'PID
 S FDA(19930.2,PID_",",1)=NAME
 D FILE^DIE(,"FDA")
 Q
 ; Attach Event Protocols to Event Types
EVTPRTL(TYPE) ;
 N EVTNM,PRT,EVT,FDA
 S EVTNM="CIAV "_TYPE_" EVENT"
 S EVT=$$EVENTIEN^CIANBEVT(TYPE)
 Q:'EVT
 S PRT=$$FIND1^DIC(101,,,EVTNM)
 Q:'PRT
 S FDA(19941.21,EVT_",",7)=PRT
 D FILE^DIE(,"FDA")
 Q
 ; Add a USES Item
ADDUSES(PARENT,ITM) ;EP-
 N PID,ITMIEN,FDA,CID
 S PID=$$PRGID^CIAVMCFG(PARENT)
 S CID=$$PRGID^CIAVMCFG(ITM)
 I PID,CID D
 .S ITMIEN=$$FIND1^DIC(19930.221,","_PID_",","B",ITM)
 .I 'ITMIEN D
 ..S FDA(19930.221,"+1"_","_PID_",",.01)=CID
 ..D UPDATE^DIE(,"FDA","ERR")
 Q
 ; Delete a USES item
DELUSES(PARENT,ITM) ;EP-
 N PID,ITMIEN,FDA
 S PID=$$PRGID^CIAVMCFG(PARENT)
 I PID D
 .S ITMIEN=$$FIND1^DIC(19930.221,","_PID_",","B",ITM)
 .I ITMIEN D
 ..S FDA(19930.221,ITMIEN_","_PID_",",.01)="@"
 ..D FILE^DIE(,"FDA")
 Q
 ;
OBJUSES(LST,OBJ) ; Build list of objects referencing an object
 N LP,LP1,FND
 K LST
 N OBJIEN
 Q:'$L($G(OBJ))
 S OBJIEN=$$PRGID^CIAVMCFG(OBJ)
 S LP=0 F  S LP=$O(^CIAVOBJ(19930.2,LP)) Q:'LP  D
 .;S LP1=0 F  S LP1=$O(^CIAVOBJ(19930.2,LP,9,LP1)) Q:'LP1  D
 .S FND=$O(^CIAVOBJ(19930.2,LP,9,"B",OBJIEN,0))
 .S:FND LST(LP)=$P(^CIAVOBJ(19930.2,LP,0),U)
 Q
 ;
UPDCHM ;EP-
 N CHM,PID
 F CHM=0:1 S X=$P($T(CHM+CHM),";;",2) Q:'$L(X)  D
 .S PID=$$PRGID^CIAVMCFG($P(X,";"))
 .D AECHM(PID,$P(X,";",2,99))
 W !!
 Q
 ;
AECHM(PID,VAL) ;EP-
 N LN,FN,IDX,TXT,ARY,CNT,IENS
 S FN=$P(VAL,";"),CNT=0
 S LN=0 F  S LN=$O(^CIAVOBJ(19930.2,PID,6,LN)) Q:'LN  D  Q:$G(IDX)
 .S TXT=^CIAVOBJ(19930.2,PID,6,LN,0)
 .S ARY(LN,0)=TXT,CNT=CNT+1
 .I $$UP^XLFSTR(TXT)[$$UP^XLFSTR($P(VAL,";")) S IDX=LN
 I $G(IDX) D
 .S ^CIAVOBJ(19930.2,PID,6,IDX,0)=VAL
 E  D
 .S ARY($S('CNT:1,1:CNT+1),0)=VAL
 .S IENS=PID_","
 .S FDA(19930.2,IENS,10)="ARY"
 .D FILE^DIE(,"FDA")
 Q
 ; Rename .01 field of a File
RENM(FILE,OLD,NEW) ;
 N IEN,FDA
 S IEN=$$FIND1^DIC(FILE,,"X",OLD)
 Q:'IEN
 S FDA(FILE,IEN_",",.01)=NEW
 D FILE^DIE(,"FDA")
 Q
 ; Rename object in Vuecentric Layout Template
RNMTPL(OLD,NEW) ;
 N X,R
 S R=0
 F X=0:0 S X=$O(^CIAVTPL(X)) Q:'X  S R=R!$$RENTPL^CIAVINIT(X,OLD,NEW)
 Q
 ;Disable PROGID
DISABLE(PRGID) ;
 N PID,FDA
 S PID=$$PRGID^CIAVMCFG(PRGID)
 Q:'PID
 S FDA(19930.2,PID_",",13)=1
 D FILE^DIE(,"FDA")
 Q
 ;Add Alias values
ADDALIAS ;
 N IEN,FDA,ERR,ARY
 S IEN=$$GETIEN^CIAVMCFG(19930.2,"INDIANHEALTHSERVICE.BEH.IBH.SUICIDE.CTLSUICIDE_FORM")
 I IEN D
 .S ARY(1)="INDIANHEALTHSERVICE.BEH.IBH.SUICIDE.CONTROLS.CTLSUICIDE_FORM"
 .S FDA(19930.2,IEN_",",23)="ARY"
 .D FILE^DIE("","FDA","ERR")
 Q
VER ;;
 ;;
 ;;
CHM ;;
 ;;
