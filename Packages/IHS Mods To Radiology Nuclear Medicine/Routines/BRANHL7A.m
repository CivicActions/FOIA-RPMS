BRANHL7A ;IHS/OIT/NST - HL7 Unitlity ; 23 Jul 2025 10:24 AM
 ;;5.0;Radiology/Nuclear Medicine;**1013**;Mar 16, 1998;Build 1
 ;;
 Q
 ;
EN ;  Create entries for Radiology vendor
 N BRAFDA,BRAERR,BRAQ,BRARC,BRAIEN,BRAHL7,CNT,DATA,DIR,FIELD,FILE,FILTER,FOUND,IENS,DEF,II,X,Y,VNAME,NAME,DSCR,VERSION
 ;
 S BRAQ=0
 S BRAIEN=0
 S CNT=0
 ; File | Field name  | Promt | Default Value | Help | Filter | SCREEN
 S CNT=CNT+1,FIELD(CNT)="771|NAME|Vendor Name||Answer must be 3-7 alphanumeric characters in length|K:$L(X)<0!($L(X)>7)!'(X'?1P.E) X"
 ;
 S CNT=CNT+1,FIELD(CNT)="870|TCP/IP ADDRESS|IP Address for Order Destination||Enter the IP address for the destination where ORM messages will be sent"
 S CNT=CNT+1,FIELD(CNT)="870|TCP/IP PORT|Port number for Order Destination||Enter the port for the destination where ORM messages will be sent"
 S CNT=CNT+1,FIELD(CNT)="870|PERSISTENT|Persistent|NO"
 ;
 S CNT=CNT+1,FIELD(CNT)="870|TCP/IP PORT|Port in RPMS that will listen for results (ORU messages)||Enter the port that RPMS will listen on to receive ORU result messages"
 ;
 S FILTER="N HLX S HLX=+$O(^HL(771.2,""B"",""ORU"","""")) K:'$D(^HL(771.2,HLX,""V"",""B"",+$O(^HL(771.5,""B"",X,0)))) X"
 S FILTER=FILTER_"|N HLX S HLX=+$O(^HL(771.2,""B"",""ORU"","""")) I $S('$O(^HL(771.2,HLX,""V"",0)):0,1:$D(^HL(771.2,HLX,""V"",""B"",+$O(^HL(771.5,""B"",X,0)))))"
 S CNT=CNT+1,FIELD(CNT)="771.5||HL7 Version|||"_FILTER
 ;
 S BRAQ=$$READ(.BRAFDA,.FIELD,.DATA)  ; Get user input
 Q:'BRAQ
 ;
 S VNAME=$$UP^XLFSTR($P(DATA(1),"^",3)) ; Upper case Vendor name
 S BRAHL7(771,"RA NAME TCP")="RA-"_VNAME_"-TCP"
 S BRAHL7(870,"RA NAME")="RA-"_VNAME
 S BRAHL7(870,"NAME RA")=VNAME_"-RA"
 S BRAHL7(101,"RA NAME ORM")="RA "_VNAME_" ORM"
 S BRAHL7(101,"RA NAME ORU")="RA "_VNAME_" ORU"
 S BRAHL7(101,"RA NAME TCP REPORT")="RA "_VNAME_" TCP REPORT"
 S BRAHL7(101,"RA NAME TCP SERVER RPT")="RA "_VNAME_" TCP SERVER RPT"
 ;
 ; Create HL7 APPLICATION PARAMETER file (#771) record
 S BRAQ=$$UPD771(BRAHL7(771,"RA NAME TCP"),.DATA)
 Q:BRAQ
 ;
 ; Create HL LOGICAL LINK file (#870) records
 S BRAQ=$$UPD8701(BRAHL7(870,"RA NAME"),.DATA)
 Q:BRAQ
 ;
 S BRAQ=$$UPD8702(BRAHL7(870,"NAME RA"),.DATA)
 Q:BRAQ
 ;
1011 ; Create Protocols
 ;
 S FILE=101
 ; ---- RA NAME ORM
 K DEF
 S DEF("ITEM TEXT")="TCP Client"
 S DEF("TYPE")="subscriber"
 S DEF("CREATOR")="`"_DUZ
 S DEF("PACKAGE")="RADIOLOGY/NUCLEAR MEDICINE"
 S DEF("EXIT ACTION")="Q"
 S DEF("ENTRY ACTION")="Q"
 S DEF("CLIENT (SUBSCRIBER)")=BRAHL7(771,"RA NAME TCP")
 S DEF("EVENT TYPE")="O01"
 S DEF("LOGICAL LINK")=BRAHL7(870,"RA NAME")
 S DEF("MESSAGE TYPE GENERATED")="ACK"
 S DEF("MESSAGE TYPE RECEIVED")="ORM"
 S DEF("GENERATE/PROCESS ROUTINE")="Q"
 S DEF("SENDING FACILITY REQUIRED?")="NO"
 S DEF("RECEIVING FACILITY REQUIRED?")="NO"
 S DEF("SECURITY REQUIRED?")="NO"
 S DEF("DATE/TIME OF MESSAGE REQUIRED?")="YES"
 ; 
 K DSCR
 S DSCR(1)="This protocol is used in conjunction with the RA REG, RA EXAMINED, and "
 S DSCR(2)="RA CANCEL event protocols.  It is used by the VISTA HL7 package to send ORM "
 S DSCR(3)="messages to TCP/IP recipients.  This protocol should be entered in the "
 S DSCR(4)="SUBSCRIBERS multiple field of those event point protocols if this type of "
 S DSCR(5)="messaging scenario is used at a facility. This is part of the file set-up "
 S DSCR(6)="to enable HL7 message flow when exams are registered, cancelled "
 S DSCR(7)="and when they reach the status flagged as 'examined' by the site."
 ;
 W !
 S BRAQ=$$ADD101(BRAHL7(FILE,"RA NAME ORM"),.DEF,.DATA,.DSCR,"")
 Q:BRAQ
 ;
 ; ---- RA NAME ORU
 K DEF
 S DEF("ITEM TEXT")="TCP Client"
 S DEF("TYPE")="subscriber"
 S DEF("CREATOR")="`"_DUZ
 S DEF("PACKAGE")="RADIOLOGY/NUCLEAR MEDICINE"
 S DEF("EXIT ACTION")="Q"
 S DEF("ENTRY ACTION")="Q"
 S DEF("CLIENT (SUBSCRIBER)")=BRAHL7(771,"RA NAME TCP")
 S DEF("EVENT TYPE")="R01"
 S DEF("LOGICAL LINK")=BRAHL7(870,"RA NAME")
 S DEF("MESSAGE TYPE GENERATED")="ACK"
 S DEF("GENERATE/PROCESS ROUTINE")="Q"
 S DEF("SENDING FACILITY REQUIRED?")="NO"
 S DEF("RECEIVING FACILITY REQUIRED?")="NO"
 S DEF("SECURITY REQUIRED?")="NO"
 S DEF("DATE/TIME OF MESSAGE REQUIRED?")="YES"
 ;
 K DSCR
 S DSCR(1)="This protocol is used in conjunction with the RA RPT event"
 S DSCR(2)=" protocol.  The HL7 package uses this protocol to send rad/nuc med report (ORU)"
 S DSCR(3)=" messages to TCP/IP recipients.  This protocol should be entered in the"
 S DSCR(4)=" SUBSCRIBERS multiple field of the RA RPT protocol if this messaging"
 S DSCR(5)=" scenario is used in a facility.  This is part of the file set-up to enable"
 S DSCR(6)=" message flow when a rad/nuc med report is verified."
 ;
 S BRAQ=$$ADD101(BRAHL7(FILE,"RA NAME ORU"),.DEF,.DATA,.DSCR,"")
 Q:BRAQ
 ;
 ; ---- RA NAME TCP REPORT
 ;
 K DEF
 S DEF("ITEM TEXT")="Client for "_VNAME_" TCP report"
 S DEF("TYPE")="subscriber"
 S DEF("CREATOR")="`"_DUZ
 S DEF("PACKAGE")="RADIOLOGY/NUCLEAR MEDICINE"
 S DEF("EXIT ACTION")="Q"
 S DEF("ENTRY ACTION")="Q"
 S DEF("CLIENT (SUBSCRIBER)")="RA-VOICE-SERVER"
 S DEF("EVENT TYPE")="R01"
 S DEF("LOGICAL LINK")=BRAHL7(870,"NAME RA")
 S DEF("MESSAGE TYPE GENERATED")="ACK"
 S DEF("GENERATE/PROCESS ROUTINE")="D ^RAHLTCPB"
 S DEF("SENDING FACILITY REQUIRED?")="NO"
 S DEF("RECEIVING FACILITY REQUIRED?")="NO"
 S DEF("SECURITY REQUIRED?")="NO"
 S DEF("DATE/TIME OF MESSAGE REQUIRED?")="YES"
 ;
 K DSCR
 S DSCR(1)="Subscriber protocol for sending report to VISTA"
 S DSCR(2)="Radiology/Nuclear Medicine.  This protocol is used by the HL7 package to"
 S DSCR(3)="process messages sent to VISTA from a COTS voice recognition unit using TCP/IP"
 S DSCR(4)="for message flow.  This protocol should be entered in the SUBSCRIBERS multiple"
 S DSCR(5)="of the RA PSCRIBE TCP SERVER RPT protocol."
 ;
 S BRAQ=$$ADD101(BRAHL7(FILE,"RA NAME TCP REPORT"),.DEF,.DATA,.DSCR,"")
 Q:BRAQ
 ; 
 ; ---- RA NAME TCP SERVER RPT
 K DEF
 S DEF("ITEM TEXT")=VNAME_" sends TCP report to RPMS"
 S DEF("TYPE")="event driver"
 S DEF("CREATOR")="`"_DUZ
 S DEF("PACKAGE")="RADIOLOGY/NUCLEAR MEDICINE"
 S DEF("SERVER APPLICATION")=BRAHL7(771,"RA NAME TCP")
 S DEF("MESSAGE TYPE RECEIVED")="ORU"
 S DEF("EVENT TYPE")="R01"
 S DEF("GENERATE/PROCESS ACK ROUTINE")="Q"
 ;
 K DSCR
 S DSCR(1)="Driver protocol for sending report to VISTA Radiology/Nuclear"
 S DSCR(2)="Medicine.  This protocol is used by the HL7 package to process"
 S DSCR(3)="radiology/nuclear med reports coming into VISTA from commercial voice"
 S DSCR(4)="recognition units using TCP/IP for message flow."
 ;
 S BRAQ=$$ADD101(BRAHL7(FILE,"RA NAME TCP SERVER RPT"),.DEF,.DATA,.DSCR,BRAHL7(FILE,"RA NAME TCP REPORT"))
 Q:BRAQ
 ;
 S VERSION=$P(DATA(6),"^",3)
 W !!,"Subcribe newly created protocols to RA protocols? If not"
 W !,"you will need to manually subsrcibe them at a later time"
 W !,BRAHL7(101,"RA NAME ORM")," to RA CANCEL "_VERSION,", RA EXAMINED "_VERSION,",  RA REG "_VERSION," and"
 W !,BRAHL7(101,"RA NAME ORU")," to RA RPT "_VERSION
 ;
 W !
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Subscribe now"
 S DIR("B")="NO"
 D ^DIR
 Q:'$G(Y)
 ;
 ; Subscribe to Protocols
 D SUBSCR(VNAME,$P(DATA(6),"^",3))  ; Subscribe to protocols
 Q
 ;
READ(BRAFDA,FIELD,DATA) ; Get User input for
 N DIR,FILE,FIELDNM,II,EXIT,X,Y,SCREEN
 S EXIT=0
 ; File | Field name  | Promt | Default Value | Help | Filter
 W !
 F II=1:1:$O(FIELD(""),-1) D  Q:EXIT
 . S FILE=$P(FIELD(II),"|")
 . S FIELDNM=$P(FIELD(II),"|",2)
 . S FIELD=""
 . S:FIELDNM'="" FIELD=$$FLDNUM^DILFD(FILE,FIELDNM)
 . S DIR(0)=$S(FIELDNM'="":FILE_","_FIELD,1:"P^"_FILE)
 . S DIR("A")=$P(FIELD(II),"|",3)
 . S DIR("B")=$P(FIELD(II),"|",4)
 . S DIR("?")=$P(FIELD(II),"|",5)
 . S $P(DIR(0),"^",3)=$P(FIELD(II),"|",6)
 . S DIR("S")=$P(FIELD(II),"|",7)
 . F  D ^DIR Q:X'=""
 . I X="^" S EXIT=1 Q
 . S DATA(II)=FILE_"^"_FIELD_"^"_X_"^"_$P(Y,"^")
 . Q
 Q:EXIT 0
 ;
 W !!,"You Entered:",!
 F II=1:1:$O(FIELD(""),-1) W !,"  ",$P(FIELD(II),"|",3),": ",$P(DATA(II),"^",3)
 W !
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Create new vendor setup"
 S DIR("B")="NO"
 D ^DIR
 Q $G(Y)=1
 ;
ADD101(NAME,DEF,DATA,DSCR,SUBSCR)  ; Add a record to PROTOCOL file (#101)
 N BRAFDA,BRAIEN,BRAERR,BRAIEN,BRAQ,FILE,FIELD,IENS,II
 ;
 S BRAQ=0
 S BRAIEN=0
 S FILE=101
 S FOUND=$$FIND1^DIC(FILE,"","BX",NAME,"","","BRAERR")
 I FOUND D  Q 0
 . W !!,NAME," found in ",$$GET1^DID(FILE,"","","NAME")_" file (#"_FILE,")"
 . Q
 ;
 S IENS="+1,"
 S BRAFDA(FILE,IENS,.01)=NAME
 ;  
 ; Set default values
 S II=""
 F  S II=$O(DEF(II)) Q:II=""  D
 . S FIELD=$$FLDNUM^DILFD(FILE,II)
 . S BRAFDA(FILE,IENS,FIELD)=DEF(II)
 . Q
 ;
 D UPDATE^DIE("E","BRAFDA","BRAIEN","BRAERR")
 ;
 I '$D(BRAERR("DIERR","E")) D  ; Update Version
 . K BRAFDA
 . S BRAFDA(FILE,BRAIEN(1)_",",770.95)=$P(DATA(6),"^",4) ; HL7 Version
 . D UPDATE^DIE("","BRAFDA","","BRAERR")
 . Q
 ;
 I '$D(BRAERR("DIERR","E")) D  ; Add description
 . S BRAIEN=BRAIEN(1)
 . S FIELD=$$FLDNUM^DILFD(FILE,"DESCRIPTION")
 . S IENS=BRAIEN_","
 . D WP^DIE(FILE,IENS,FIELD,"A","DSCR","BRAERR")
 . Q
 ;
 I (SUBSCR'=""),'$D(BRAERR("DIERR","E")) D  ; Add subscriber
 . K BRAFDA
 . S BRAFDA(101.0775,"?+1,"_BRAIEN_",",.01)=SUBSCR
 . D UPDATE^DIE("E","BRAFDA","BRAIEN","BRAERR")
 . Q
 ;
 I $D(BRAERR("DIERR","E")) D
 . S BRAQ=1
 . F II=1:1 Q:'$D(BRAERR("DIERR",1,"TEXT",II))  D
 . . W !,BRAERR("DIERR",1,"TEXT",II)
 . . Q
 . Q
 E  W !,NAME," has been created in ",$$GET1^DID(FILE,"","","NAME")_" file (#"_FILE,")"
ADD101E  ; the end 
 Q BRAQ
 ;
SUBSCR(VNAME,VERSION)  ; Subscribe protocols
 N BRAFDA,SUBSCR,BRAIEN,II,J,NAMEORM,NAMEORU,PROTOCOL
 ;
 W !
 S NAMEORM="RA "_VNAME_" ORM"
 S NAMEORU="RA "_VNAME_" ORU"
 S SUBSCR("RA REG")=NAMEORM
 S SUBSCR("RA EXAMINED")=NAMEORM
 S SUBSCR("RA CANCEL")=NAMEORM
 S SUBSCR("RA RPT")=NAMEORU
 ;
 S II=""
 F  S II=$O(SUBSCR(II)) Q:II=""  D
 . S PROTOCOL=II_" "_VERSION
 . S BRAIEN=$$FIND1^DIC(101,"","BX",PROTOCOL)
 . I 'BRAIEN W !,"Protocol "_PROTOCOL_" is not found" Q
 . K BRAFDA
 . S BRAFDA(101.0775,"?+1,"_BRAIEN_",",.01)=SUBSCR(II)
 . D UPDATE^DIE("E","BRAFDA","BRAIEN","BRAERR")
 . I $D(BRAERR("DIERR","E")) D
 . . F J=1:1 Q:'$D(BRAERR("DIERR",1,"TEXT",J))  D
 . . . W !,BRAERR("DIERR",1,"TEXT",J)
 . . . Q
 . . Q
 . E  W !,SUBSCR(II)," has been subscribed to protocol ",PROTOCOL
 . Q
 Q
 ;
UPD771(NAME,DATA) ; ; Create HL7 APPLICATION PARAMETER file (#771) record 
 N FILE,FIELD,FOUND,BRAFDA,BRAERR,BRAIEN,BRAQ,DEF,IENS,II
 ;  
 S BRAQ=0
 S FILE=771
 S FOUND=$$FIND1^DIC(FILE,"","BX",NAME,"","","BRAERR")
 I FOUND D  Q BRAQ
 . W !!,NAME," found in ",$$GET1^DID(FILE,"","","NAME")_" file (#"_FILE,")"
 . Q
 ;
 ; Default values 
 S DEF("ACTIVE/INACTIVE")="A"
 S DEF("COUNTRY CODE")="USA"
 S DEF("HL7 FIELD SEPARATOR")="|"
 ;
 S IENS="+1,"
 S BRAFDA(FILE,IENS,.01)=NAME
 ;
 S II=""
 F  S II=$O(DEF(II)) Q:II=""  D
 . S FIELD=$$FLDNUM^DILFD(FILE,II)
 . S BRAFDA(FILE,IENS,FIELD)=DEF(II)
 . Q
 ;
 D UPDATE^DIE("E","BRAFDA","BRAIEN","BRAERR")
 I '$D(BRAERR("DIERR","E")) D  ; Special handling of 101 field. UPDATE^DIE doesn't accept ^
 . S BRAIEN=BRAIEN(1)
 . K BRAFDA
 . S BRAFDA(771,BRAIEN_",",101)="~^\&"
 . D FILE^DIE("E","BRAFDA","BRAERR")
 . Q
 I $D(BRAERR("DIERR","E")) D
 . S BRAQ=1
 . S BRAIEN=-1
 . F II=1:1 Q:'$D(BRAERR("DIERR",1,"TEXT",II))  D
 . . W !,BRAERR("DIERR",1,"TEXT",II)
 . . Q
 . Q
 E   W !!,NAME," has been created in ",$$GET1^DID(FILE,"","","NAME")_" file (#"_FILE,")"
 Q BRAQ
 ;
UPD8701(NAME,DATA) ; RA to Vendor orders link
 N FILE,FIELD,FOUND,BRAFDA,BRAERR,BRAIEN,BRAQ,DEF,IENS,II
 ;
 S BRAQ=0
 S FILE=870
 S FOUND=$$FIND1^DIC(FILE,"","BX",NAME,"","","BRAERR")
 I FOUND D  Q BRAQ
 . W !!,NAME," found in ",$$GET1^DID(FILE,"","","NAME")_" file (#"_FILE,")"
 . Q
 ;
 ; Default values
 S DEF("ACK TIMEOUT")=300
 S DEF("LLP TYPE")="TCP"
 S DEF("DEVICE TYPE")="Non-Persistent Client"
 S DEF("AUTOSTART")="Enabled"
 S DEF("ACK TIMEOUT")=300
 S DEF("TCP/IP SERVICE TYPE")="CLIENT (SENDER)"
 ;
 S IENS="+1,"
 S BRAFDA(FILE,IENS,.01)=NAME
 ;
 F II=2,3,4 S BRAFDA(FILE,IENS,$P(DATA(II),"^",2))=$P(DATA(II),"^",3)
 ;  
 S II=""
 F  S II=$O(DEF(II)) Q:II=""  D
 . S FIELD=$$FLDNUM^DILFD(FILE,II)
 . S BRAFDA(FILE,IENS,FIELD)=DEF(II)
 . Q
 ;
 D UPDATE^DIE("E","BRAFDA","","BRAERR")
 I $D(BRAERR("DIERR","E")) D
 . S BRAQ=1
 . F II=1:1 Q:'$D(BRAERR("DIERR",1,"TEXT",II))  D
 . . W !,BRAERR("DIERR",1,"TEXT",II)
 . . Q
 . Q
 E   W !!,NAME," has been created in ",$$GET1^DID(FILE,"","","NAME")_" file (#"_FILE,")"
 Q BRAQ
 ;
UPD8702(NAME,DATA) ; RA to Vendor results link
 N FILE,FIELD,FOUND,BRAFDA,BRAERR,BRAIEN,BRAQ,DEF,IENS,II
 ;
 S BRAQ=0
 S FILE=870
 S FOUND=$$FIND1^DIC(FILE,"","BX",NAME,"","","BRAERR")
 I FOUND D  Q BRAQ
 . W !!,NAME," found in ",$$GET1^DID(FILE,"","","NAME")_" file (#"_FILE,")"
 . Q
 ;
 ; Default values
 S DEF("LLP TYPE")="TCP"
 S DEF("DEVICE TYPE")="Single-threaded Server"
 S DEF("AUTOSTART")="Enabled"
 S DEF("TCP/IP SERVICE TYPE")="SINGLE LISTENER"
 ;
 S IENS="+1,"
 S BRAFDA(FILE,IENS,.01)=NAME
 ;
 F II=5 S BRAFDA(FILE,IENS,$P(DATA(II),"^",2))=$P(DATA(II),"^",3)
 ;  
 S II=""
 F  S II=$O(DEF(II)) Q:II=""  D
 . S FIELD=$$FLDNUM^DILFD(FILE,II)
 . S BRAFDA(FILE,IENS,FIELD)=DEF(II)
 . Q
 ;
 D UPDATE^DIE("E","BRAFDA","","BRAERR")
 I $D(BRAERR("DIERR","E")) D
 . S BRAQ=1
 . F II=1:1 Q:'$D(BRAERR("DIERR",1,"TEXT",II))  D
 . . W !,BRAERR("DIERR",1,"TEXT",II)
 . . Q
 . Q
 E   W !,NAME," has been created in ",$$GET1^DID(FILE,"","","NAME")_" file (#"_FILE,")"
 Q BRAQ
