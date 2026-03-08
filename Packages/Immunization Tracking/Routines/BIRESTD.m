BIRESTD ;IHS/CMI/MWR - CHECK AND RESTANDARDIZE VACCINE TABLE.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**1006,1013,1016,1017,1020,1027,1028**;OCT 24, 2011;Build 84
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CHECK IMMUNIZATION (VACCINE) TABLE AGAINST HL7 STANDARD;
 ;;  RESTANDARDIZE IF NECESSARY.
 ;
 ;----------
CHKSTAND(BIERROR) ;EP
 ;---> Check the Vaccine Table (IMMUNIZATION File #9999999.14)
 ;---> against the HL7 Standard Table (BI IMMUNIZATION TABLE
 ;---> HL7 STANDARD File #9002084.94), each entry, piece by piece.
 ;---> If there is an error, return the Error Text and set ^BISITE(-1)
 ;---> to act as a flag for other calls.
 ;---> Parameters:
 ;     1 - BIERROR (ret) BIERROR=Text.
 ;
 S BIERROR=""
 ;
 ;---> If Vaccine globals do not exist, return Error Text and quit.
 I '$D(^AUTTIMM(0))!('$D(^BITN(0))) D  Q
 .D ERRCD^BIUTL2(505,.BIERROR) S ^BISITE(-1)=""
 ;
 ;---> If there are any non-standard entries in the Vaccine Table,
 ;---> return Error Text, set ^BISITE(-1), and quit.
 N N S N=0
 F  S N=$O(^AUTTIMM(N)) Q:'N  D  Q:BIERROR]""
 .I '$D(^BITN(N,0)) D ERRCD^BIUTL2(508,.BIERROR)
 I BIERROR]"" S ^BISITE(-1)="" Q
 ;---> NOTE: If ^AUTTIMM(0) does not exist, set it ="IMMUNIZATION^9999999.14I"
 ;--->       then restandardize.
 ;--->       Likewise, ^BITN(0)="BI IMMUNIZATION TABLE HL7 STANDARD^9002084.94"
 ;
 ;---> Now check every Standard piece of the Vaccine Table.
 ;---> If any Standard piece of data of a Vaccine is non-standard,
 ;---> return Error Text, set ^BISITE(-1), and quit.
 S N=0
 F  S N=$O(^BITN(N)) Q:'N  D  Q:BIERROR]""
 .I '$D(^AUTTIMM(N,0)) D ERRCD^BIUTL2(503,.BIERROR) Q
 .;---> The following fields are copied below in COPYNEW, but are not checked
 .;---> as part of the standard: 7-Active, 13-VIS Def, 16-Include in Forecast,
 .;---> 18-Def Volume.
 .N BIPC F BIPC=1,2,3,8,9,10,11,12,14,15,17,21:1:26 D
 ..I $P(^AUTTIMM(N,0),U,BIPC)'=$P(^BITN(N,0),U,BIPC) D
 ...D ERRCD^BIUTL2(503,.BIERROR)
 I BIERROR]"" S ^BISITE(-1)="" Q
 ;
 ;---> Clear Non-standard flag.
 K ^BISITE(-1)
 Q
 ;
 ;
 ;----------
RESTAND(BIERROR,BIPRMPT) ;EP
 ;---> Restandardize the Vaccine Table (IMMUNIZATION File #9999999.14)
 ;---> by copying from the HL7 Standard Table (BI IMMUNIZATION TABLE
 ;---> HL7 STANDARD File #9002084.94).
 ;---> Parameters:
 ;     1 - BIERROR (ret) BIERROR=Text (Translation Table is corrupt).
 ;     2 - BIPRMPT (opt) If BIPRMPT=1 report "Complete".
 ;
 S:'$G(BIPRMPT) BIPRMPT=""
 S BIERROR=""
 I '$D(^AUTTIMM(0))!('$D(^BITN(0))) D  Q
 .D ERRCD^BIUTL2(505,.BIERROR,1)
 ;
 ;---> First, rebuild ^BITN global.
 D ^BITN
 ;PATCH 1020
 ;FIX CPT CODE ON 168 IF IT ISN'T THE CORRECT ONE
 S X=0,G="" F  S X=$O(^ICPT("B",90653,X)) Q:X'=+X!(G)  D
 .I $P(^ICPT(X,0),U,2)="IIV ADJUVANT VACCINE IM" S G=X
 S $P(^AUTTIMM(272,0),U,11)=G
 S $P(^BITN(272,0),U,11)=G
 ;
 ;SPECIAL FOR LINES IN ROUTINE THAT WERE TOO LONG
 F X=108,148,149,217,229,236,242,243,248,253,254,255,257,259,260,264,265,270,272,275,289,290,298,301,303,304,305,306,338,356,367,369 D
 .S $P(^BITN(X,0),U,12)="15,16,88,111,123,125,126,127,128,135,140,141,144,149,150,151,153,155,158,161,166,168,171,185,186,197,200,201,202,205,231,320,331,333"
 F X=310,311,312,313,314,315,320,321,322,323,325,329,330,331,332,333,334,335,336,337,344,345,346,347,348,349,370 D
 .S $P(^BITN(X,0),U,12)="207,208,210,211,212,213,217,218,219,221,500,221,225,226,227,228,229,300,301,230,302,308,309,310,311,312,313,334"
 ;207,208,210,211,212,213,217,218,219,221,500,221,225,226,227,228,229,300,301,230,302,308,309,310,311,312,313
 ;---> Remove any non-standard entries in the Vaccine Table.
 N N S N=0
 F  S N=$O(^AUTTIMM(N)) Q:'N  D
 .I '$D(^BITN(N,0)) K ^AUTTIMM(N)
 ;
 ;---> Copy every HL7 Standard Table piece to the Vaccine Table.
 D COPYNEW(.BIERROR)
 ;
 ;---> Restandardize the Vaccine Manufacturer Table.
 Q:BIERROR
 W:BIPRMPT>0 !!?5,"Restandardization of Vaccine Table complete."
 D RESTDMAN(.BIERROR)
 Q:BIERROR  D:BIPRMPT>0
 .W !?5,"Restandardization of Manufacturer Table complete."
 .D DIRZ^BIUTL3()
 ;
 ;---> Clear Non-standard flag.
 K ^BISITE(-1)
 Q
 ;
 ;
 ;----------
COPYNEW(BIPOP) ;EP
 ;---> Copy New Standard to Vaccine Table (IMMUNIZATION File).
 ;---> Parameters:
 ;     1 - BIPOP (ret) BIPOP=1 if Translation Table is corrupt.
 ;
 S BIPOP=0
 I '$O(^BITN(0)) D ERRCD^BIUTL2(505,,1) S BIPOP=1 Q
 N BIN S BIN=0
 F  S BIN=$O(^BITN(BIN)) Q:'BIN  Q:BIPOP  D
 .I '$D(^BITN(BIN,0)) D ERRCD^BIUTL2(505,,1) S BIPOP=1 Q
 .;
 .;---> Copy HL7 Standard Table pieces to the Vaccine Table.
 .;---> Imm v8.3: Remove .07 field, "ACTIVE"; (leave local site setting).
 .;---> P1004 remove .13 VIS Default Date and .16 Include in Forecast.
 .;---> P1027 remove .18 default volume
 .N BIPC F BIPC=1,2,3,8,9,10,11,12,14,15,17,21:1:26 D
 ..S $P(^AUTTIMM(BIN,0),U,BIPC)=$P(^BITN(BIN,0),U,BIPC)
 .;
 .;---> Set Status, .07, if not already set (i.e., don't overwrite local settings).
 .I $P(^AUTTIMM(BIN,0),U,7)="" S $P(^AUTTIMM(BIN,0),U,7)=$P(^BITN(BIN,0),U,7)
 .;
 .;---> Update VIS Default Date only if the update is later than the local site date.
 .I $P(^BITN(BIN,0),U,13)>$P(^AUTTIMM(BIN,0),U,13) D
 ..S $P(^AUTTIMM(BIN,0),U,13)=$P(^BITN(BIN,0),U,13)
 .;
 .;---> Set Include in Forecast .16, if not already set.
 .I $P(^AUTTIMM(BIN,0),U,16)="" S $P(^AUTTIMM(BIN,0),U,16)=$P(^BITN(BIN,0),U,16)
 .;
 .;---> Set defalut volume (.18), if not already set (i.e., don't overwrite local settings).
 .I $P(^AUTTIMM(BIN,0),U,18)="" S $P(^AUTTIMM(BIN,0),U,18)=$P(^BITN(BIN,0),U,18)
 .;
 .;
 .Q:'$D(^BITN(BIN,1))
 .;---> Reset 1 node as well.  Include 1.15 - vvv83.
 .F BIPC=1:1:15 S $P(^AUTTIMM(BIN,1),U,BIPC)=$P(^BITN(BIN,1),U,BIPC)
 ;
 ;---> Now re-index all indices on the file.
 D REIND1
 Q
 ;
 ;
 ;----------
REIND1 ;EP
 ;---> Re-index IMMUNIZATION File, ^AUTTIMM(.
 ;---> First, remove all previous Vaccine Table indices.
 N BIN S BIN="A"
 F  S BIN=$O(^AUTTIMM(BIN)) Q:BIN=""  K @("^AUTTIMM("""_BIN_""")")
 ;
 ;---> Now re-index table.
 S BIN=0
 F  S BIN=$O(^AUTTIMM(BIN)) Q:'BIN  D
 .N DA,DIK S DA=BIN,DIK="^AUTTIMM("
 .D IX1^DIK
 Q
 ;
 ;
 ;----------
RESTDMAN(BIPOP) ;EP
 ;---> Standardardize 100+ Entries in Manufacturer Table, ^AUTTIMAN.
 ;---> Parameters:
 ;     1 - BIPOP (ret) BIPOP=1 Error.
 ;
 S ^AUTTIMAN(0)="IMM MANUFACTURER^9999999.04I"
 N N S N=99
 F  S N=$O(^BIMAN(N)) Q:'N  D
 .S ^AUTTIMAN(N,0)=^BIMAN(N,0)
 D REIND2
 ;
 Q
 ;
 ;
 ;----------
REIND2 ;EP
 ;---> Re-index IMM MANUFACTURER File, ^AUTTIMAN(.
 ;---> First, remove all previous indices.
 N BIN S BIN="A"
 F  S BIN=$O(^AUTTIMAN(BIN)) Q:BIN=""  K @("^AUTTIMAN("""_BIN_""")")
 ;
 ;---> Now re-index table.
 ;********** PATCH 1001, v8.5, MAR 01,2020, IHS/CMI/MWR
 ;---> Use IXALL so that zero "Bookkeeper" node is set.
 N DIK S DIK="^AUTTIMAN(" D IXALL^DIK
 ;
 ;S BIN=0
 ;F  S BIN=$O(^AUTTIMAN(BIN)) Q:'BIN  D
 ;.N DA,DIK S DA=BIN,DIK="^AUTTIMAN("
 ;.D IX1^DIK
 ;**********
 Q
