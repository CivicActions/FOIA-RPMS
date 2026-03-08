BIVVPOST ;IHS/CMI/MWR - POST-INIT ROUTINE; NOV 18, 2020
 ;;8.5;IMMUNIZATION;**1028**;OCT 24, 2011;Build 84
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PATCH 1000+: Vaccine Table update.
 ;
 ;
 ;-----------
START ;EP
 ;---> Update software after KIDS installation.
 ;
 D SETVARS^BIUTL5 S BIPOP=0
 ;
 ;PATCH 1024 - INACTIVATE MANUFACTURER VBI Vaccines, Inc
 ;NEW DA,DIE,DR
 ;S DA=$O(^AUTTIMAN("B","VBI Vaccines, Inc",0))
 ;I DA S DIE="^AUTTIMAN(",DR=".03///0" D ^DIE K DIE,DA,DR
 ;S DA=$O(^BIMAN("B","VBI Vaccines, Inc",0))
 ;I DA S DIE="^BIMAN(",DR=".03///0" D ^DIE K DIE,DR,DA
 ;
 ;PATCH 1027 - UPDATE NDC CODES
 D ^BIVVNDC
 ;
 ;PATCH 1027 ADD DENQUE GROUP
 ;S ^BISERT(28,0)="Denque^93^^^1^1^^^^366^330"
 ;S ^BISERT("B","Denque",28)=""
 ;*****PATCH 1022 ADD 875 AS VACCINE GROUP CODE TO RSV
 ;NEW DA,DIE,DR
 ;S DA=$O(^BISERT("B","RSV",0))
 ;I DA S DIE="^BISERT(",DR=".09///875" D ^DIE K DA,DIE,DR
 ;********PATCH 1020 ADD H5 GROUP AND REORDER
 ;
 ;S $P(^BISERT(11,0),U,2)=13
 ;S ^BISERT(27,0)="H5^12^H5^^1^1^^^^359^323"
 ;S ^BISERT("B","H5",27)=""
 ;******* PATCH 1019 ADD ANTRHAX GROUP, REORDER CHIKA
 ;S ^BISERT(26,0)="Anthrax^90^Anthr^^1^1^^0^^153^24"
 ;S ^BISERT("B","Anthrax",26)=""
 ;S $P(^BISERT(25,0),U,2)=91
 ;
 ;******* PATCH 1018 ADD ChikA GROUP
 ;S ^BISERT(25,0)="CHIKA^90^ChikA^^1^1^^^^353^317"
 ;S ^BISERT("B","CHIKA",25)=""
 ;RESET OTHER ORDER
 ;S $P(^BISERT(25,0),U,2)=91
 ;
 ;******* PATCH 1015 ADD RSV GROUP
 ;S ^BISERT(24,0)="RSV^72^RSV^^1^1^^0^^339^304"
 ;S ^BISERT("B","RSV",24)=""
 ;RESET ROTAVIRUS ORDER
 ;S $P(^BISERT(15,0),U,2)=70
 ;
 ;********** PATCH 1010, v8.5, 
 ;---> Update Vaccine Group Table.
 ;---> Add ORTHOPOX Vaccine Group.
 ;S ^BISERT(23,0)="ORTHOPOX^89^MPX^^1^1^^^860^101"
 ;S ^BISERT("B","ORTHOPOX",23)=""
 ;S ^BISERT("VMR",860,23)=""
 ;
 ;
 ;********** PATCH 1007, v8.5, 
 ;---> Update Vaccine Group Table.
 ;---> Add TBE Vaccine Group.
 ;S ^BISERT(22,0)="TBE^86^TBE^^0^0^^0^^326^222"
 ;S ^BISERT("B","TBE",22)=""
 ;********** PATCH 1001, v8.5, MAR 01,2021, IHS/CMI/MWR
 ;---> Add COVID VMR xref.
 ;S ^BISERT("B","COVID",21)="",^BISERT("VMR",850,21)=""
 ;
 ;********** PATCH 1000, v8.5, DEC 01,2020, IHS/CMI/MWR
 ;---> Update Vaccine Group Table.
 ;---> Add COVID Vaccine Group.
 ;S ^BISERT(21,0)="COVID^88^COV^^1^1^^0^850^312^213"
 ;********** PATCH 1001, v8.5, MAR 01,2021, IHS/CMI/MWR
 ;---> Add COVID VMR xref.
 ;S ^BISERT("B","COVID",21)="",^BISERT("VMR",850,21)=""
 ;---> Change NOS Equivalent of DTORP Vaccine Group to Td,NOS CVX 139.
 ;S ^BISERT(1,0)="DTORP^1^DTP^4^1^1^^1^200^245^139"
 ;
 ;
 ;********** PATCH 1001, v8.5, MAR 01,2021, IHS/CMI/MWR
 ;---> Update Manufacturer Table.
 ;S ^BIMAN(173,0)="Dispensing Solutions^DSI^1^Dispensing Solutions"
 ;S ^BIMAN(174,0)="Rebel Distributors^REB^1^Rebel Distributors"
 ;S ^BIMAN(175,0)="Vetter Pharma Fertigung^VET^1^Vetter Pharma Fertigung GmbH & Co. KG"
 ;S ^BIMAN(176,0)="Dynavax, Inc.^DVX^1^Dynavax, Inc."
 ;S ^BIMAN(177,0)="TEVA PHARMACEUTICALS USA^TVA^1^TEVA Pharmaceuticals USA^TEVA"
 ;S ^BIMAN(178,0)="MODERNA US^MOD^1^Moderna US, Inc.^Moderna"
 ;S ^BIMAN(160,0)="PFIZER, INC^PFR^1^Pfizer, Inc.^Pfizer"
 ;S ^BIMAN(178,0)="MODERNA US^MOD^1^Moderna US, Inc.^Moderna"
 ;S ^BIMAN(179,0)="JANSSEN^JSN^1^Janssen (J&J)^Janssen"
 ;S ^BIMAN(180,0)="ASTRAZENECA^ASZ^1^AstraZeneca"
 ;********** PATCH 1002, v8.5, MAY 28,2021, IHS/CMI/MWR
 ;S ^BIMAN(181,0)="NOVAVAX, INC^NVX^1^Novavax, Inc."
 ;K ^BIMAN(181),^AUTTIMAN(181)
 ;S ^BIMAN(150,0)="NOVAVAX, INC^NVX^1^Novavax, Inc."
 ;
 ;********** PATCH 1004, v8.5, DEC 30,2021, IHS/CMI/MWR
 ;S ^BIMAN(182,0)="Bharat Biotech International^BBI^0^Bharat Biotech International Limited"
 ;
 ;********** PATCH 1005, v8.5, FEB 15,2022, ihs/cmi/maw
 ;S ^BIMAN(183,0)="VBI Vaccines, Inc^VBI^1^VBI Vaccines, Inc"
 ;
 ;********** PATCH 1006, v8.5, Aug 19, 2022, added new manufacturer
 ;S ^BIMAN(184,0)="Bavarian Nordic A/S^BN^1^Bavarian Nordic A/S^BAVARIAN NORDIC A/S"
 ;
 ;********** PATCH 1017, v8.5, October 2023, added new manufacturer
 ;S ^BIMAN(185,0)="MSP Vaccine Company^MSP^1^MSP Vaccine Company^MSP"
 ;PATCH 1018
 ;S ^BIMAN(127,0)="Emergent Biosolutions^MIP^1^Emergent Biosolutions^Emergent Biosolutions"
 ;
 ;---> Re-index BI TABLE MANUFACTURERS File, ^BIMAN(.
 ;---> First, remove all previous indices.
 ;N BIN S BIN="A"
 ;F  S BIN=$O(^BIMAN(BIN)) Q:BIN=""  K @("^BIMAN("""_BIN_""")")
 ;
 ;---> Now re-index table.
 ;---> Use IXALL so that zero "Bookkeeper" node is set (SET only, no KILL).
 ;N DIK S DIK="^BIMAN(" D IXALL^DIK
 ;
 ;---> Reindex ALL indices for ALL entries, SET only, no KILL.
 ;N DIK S DIK="^BIERR(" D IXALL^DIK
 ;
 ;
 ;
 ;---> Re-Standardize the Vaccine Table and Manufacture Table using BITN* routines.
 D RESTAND^BIRESTD()
 ;
 ;
 ;
 ;********** PATCH 1001, v8.5, MAR 01,2021, IHS/CMI/MWR
 ;---> Force vaccines Active or Inactive by CVX Code.
 ;---> Insert CVX Codes into For loop below.
 ;
 ;---> Make these CVX's ACTIVE:
 ;N BICVX F BICVX=207,208,212 D
 ;.;
 ;.N N S N=$$HL7TX^BIUTL2(BICVX)
 ;.;---> Quit if CVX is Unknown.
 ;.Q:(N=137)
 ;.;---> 0=ACTIVE.
 ;.S $P(^AUTTIMM(N,0),U,7)=0
 ;.S $P(^BITN(N,0),U,7)=0
 ;
 ;
 ;---> Make these CVX's INACTIVE:
 ;N BICVX F BICVX=140,144,166 D
 ;.N N S N=$$HL7TX^BIUTL2(BICVX)
 ;.;---> Quit if CVX is Unknown.
 ;.Q:(N=137)
 ;.;---> 1=INACTIVE.
 ;.S $P(^AUTTIMM(N,0),U,7)=1
 ;.S $P(^BITN(N,0),U,7)=1
 ;
 ;;********** PATCH 1003, v8.5, NOV 30,2021, IHS/CMI/MWR
 ;---> Update Taxonomies.
 ;D ^BITX
 ;
 ;
 ;---> Reset Display Order of Vaccine Groups in BI TABLE VACCINE GROUP File #9002084.93.
 ;S $P(^BISERT(1,0),"^",2)=1
 ;S $P(^BISERT(2,0),"^",2)=3
 ;S $P(^BISERT(3,0),"^",2)=4
 ;S $P(^BISERT(4,0),"^",2)=6
 ;S $P(^BISERT(5,0),"^",2)=5
 ;S $P(^BISERT(6,0),"^",2)=7
 ;S $P(^BISERT(7,0),"^",2)=8
 ;S $P(^BISERT(8,0),"^",2)=2
 ;S $P(^BISERT(9,0),"^",2)=9
 ;S $P(^BISERT(10,0),"^",2)=10
 ;S $P(^BISERT(11,0),"^",2)=12
 ;S $P(^BISERT(12,0),"^",2)=90
 ;S $P(^BISERT(13,0),"^",2)=99
 ;S $P(^BISERT(14,0),"^",2)=95
 ;S $P(^BISERT(15,0),"^",2)=85
 ;S $P(^BISERT(16,0),"^",2)=15
 ;S $P(^BISERT(17,0),"^",2)=18
 ;S $P(^BISERT(18,0),"^",2)=11
 ;S $P(^BISERT(19,0),"^",2)=16
 ;S $P(^BISERT(20,0),"^",2)=87
 ;---> New (COVID):
 ;S $P(^BISERT(21,0),"^",2)=88
 ;
 ;
 ;---> Turn off H1N1forecasting.
 ;S $P(^BISERT(18,0),"^",5)=0
 ;
 ;
 ;---> Add new NDC's.
 ;---> Either transport Upload Table in KIDS file or do sets below.
 ;
 ;---> Load new NDC's to be distributed into the Upload File.
 ;N BIN S BIN=0
 ;F  S BIN=$O(^BINDCUP(BIN)) Q:BIN=""  K ^BINDCUP(BIN)
 ;
 ;S ^BINDCUP(0)="BI TABLE NDC UPLOAD^9002084.96"
 ;S ^BINDCUP(1,0)="75052-0001-01^220^VBI^PREHEVBRIO Hepatitis B Vaccine"
 ;S ^BINDCUP(2,0)="75052-0001-10^220^VBI^PREHEVBRIO Hepatitis B Vaccine"
 ;S ^BINDCUP("B","75052-0001-01",1)=""
 ;S ^BINDCUP("B","75052-0001-10",2)=""
 ;
 ;---> Now add these to the local BI TABLE NDC CODES File.
 ;D ^BIVVNDC
 ;
 ;
 ;---> Update "Last Vaccine Table Update" Field in BI SITE PARAMETER File.
 N BIVTP
 S BIVTP=$P($P($T(+2),";",5),"**",2)
 ;
 N N S N=0 F  S N=$O(^BISITE(N)) Q:'N  D
 .S $P(^BISITE(N,0),"^",26)=BIVTP   ;IHS/CMI/LAB = REMOVE THIS IN NEXT PATCH
 ;
 ;---> Congratulations Screen displaying version & patch level from line 2 above.
 D TEXT1
 W " p"_BIVTP_"."
 D TEXT2,DIRZ^BIUTL3()
 ;
 D EXIT
 Q
 ;
 ;
 ;----------
EXIT ;EP
 D KILLALL^BIUTL8(1)
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;        - This concludes the BI Vaccine Table Update program. -
 ;;
 ;;                       * CONGRATULATIONS! *
 ;;
 ;;      You have successfully updated the Vaccine Table to
 ;W @IOF
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 ;---> Print text at specified line label.
 ;
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;
 ;----------
REINDEX ;EP
 ;---> Not called.  Programmer to use if KIDS fails to index these files.
 ;
 N DIK
 ;S DIK="^BISERT(" D IXALL^DIK
 F DIK="^BINFO(","^BILETS(","^BIVT100(","^BIERR(","^BINFO(","^BIEXPDD(","^BISERT(","^BICONT(" D
 .D IXALL^DIK
 Q
