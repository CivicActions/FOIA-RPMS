BJPN2P11 ;GDIT/HS/BEE-Prenatal Care Module 2.0 Patch 11 Post Install ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**11**;Feb 24, 2015;Build 7
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT,EIEN,VRSN
 ;
 ;Check for BJPN*2.0*10
 I '$$INSTALLD("BJPN*2.0*10") D BMES^XPDUTL("Version 2.0 Patch 10 of BJPN is required!") S XPDQUIT=2 Q
 ;
 ;Check for TIU*1.0*1021
 I '$$INSTALLD("TIU*1.0*1021") D BMES^XPDUTL("Version 1.0 Patch 1021 of TIU is required!") S XPDQUIT=2 Q
 ;
 ;Check for EHRp24 with hot fix
 S EIEN=$O(^CIAVOBJ(19930.2,"B","BEHIPL.IPL",""))
 ;
 ;Get the version number, pad it and look for the minimum
 ;
 S VRSN=$$GET1^DIQ(19930.2,EIEN_",",2,"I")
 ;
 ;Pad the pieces
 F I=1:1:4 S PC=$P(VRSN,".",I) S PC=$E(PC_"0000",1,4),$P(VRSN,".",I)=PC
 ;
 ;Strip out "."
 S VRSN=$TR(VRSN,".")
 I VRSN'>"1000100023004399" D BMES^XPDUTL("Version 1.1 Patch 24 AND Patch 24 HotFix of EHR are required!") S XPDQUIT=2 Q
 Q
 ;
PST ;EP - Prenatal 2.0 Patch 11 Post Installation Code
 ;
 ;Tie BJPNRPC to BSTSRPC
 ;
 ;Set BSTSRPC into BJPNRPC
 NEW IEN,DA,X,DIC,BI,TEXT,PIEN,Y
 ;
 K DO,DD
 S DA(1)=$$FIND1^DIC(19,"","B","BJPNRPC","","","ERROR"),DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMNZ"
 I $G(^DIC(19,DA(1),10,0))="" S ^DIC(19,DA(1),10,0)="^19.01IP^^"
 S X="BSTSRPC"
 D ^DIC I +Y<1 K DO,DD D FILE^DICN
 ;
 ; UPDATE THE VUECENTRIC REGISTERED OBJECTS FILE
 W !,"Registering the Vucentric Objects..."
 ;
 NEW BI,TEXT
 ;
 F BI=1:1 S TEXT=$P($T(OBJ+BI),";",3,99) Q:($P(TEXT,";")="END")  D
 .W !,$P(TEXT,";")
 . ;
 . NEW DIC,X,Y,OBJUPD,ERROR,WP8,WP9,WP10,OIEN
 . ;
 . ;PROGID (#.01)
 . S DIC="^CIAVOBJ(19930.2,",DIC(0)="LOX",X=$P(TEXT,";")
 . D ^DIC I +Y<0 Q
 . S OIEN=+Y
 . ;
 . ;NAME (#1)
 . S OBJUPD(19930.2,OIEN_",",1)=$P(TEXT,";",2)
 . ;
 . ;VERSION (#2)
 . S OBJUPD(19930.2,OIEN_",",2)=$P(TEXT,";",3)
 . ;
 . ;SOURCE (#3)
 . S OBJUPD(19930.2,OIEN_",",3)=$P(TEXT,";",4)
 . ;
 . ;SERIALIZABLE (#8)
 . S WP8(1)=$P(TEXT,";",5)
 . D WP^DIE(19930.2,OIEN_",",8,"","WP8")
 . ;
 . ;INITIALIZATION (#9)
 . S WP9(1)=$P(TEXT,";",6)
 . D WP^DIE(19930.2,OIEN_",",9,"","WP9")
 . ;
 . ;REQUIRED (#10)
 . S WP10(1)=$P(TEXT,";",7)
 . D WP^DIE(19930.2,OIEN_",",10,"","WP10")
 . ;
 . ;PROPEDIT (#11)
 . S OBJUPD(19930.2,OIEN_",",11)=$P(TEXT,";",8)
 . ;
 . ;MULTIPLE (#12)
 . S OBJUPD(19930.2,OIEN_",",12)=$P(TEXT,";",9)
 . ;
 . ;DISABLED (#13)
 . S OBJUPD(19930.2,OIEN_",",13)=$P(TEXT,";",10)
 . ;
 . ;ALLKEYS (#14)
 . S OBJUPD(19930.2,OIEN_",",14)=$P(TEXT,";",11)
 . ;
 . ;HIDDEN (#15)
 . S OBJUPD(19930.2,OIEN_",",15)=$P(TEXT,";",12)
 . ;
 . ;SIDEBYSIDE (#16)
 . S OBJUPD(19930.2,OIEN_",",16)=$P(TEXT,";",13)
 . ;
 . ;SERVICE (#17)
 . S OBJUPD(19930.2,OIEN_",",17)=$P(TEXT,";",14)
 . ;
 . ;REGRESS (#18)
 . S OBJUPD(19930.2,OIEN_",",18)=$P(TEXT,";",15)
 . ;
 . ;NOREGISTER (#19)
 . S OBJUPD(19930.2,OIEN_",",19)=$P(TEXT,";",16)
 . ;
 . ;DOTNET (#22)
 . S OBJUPD(19930.2,OIEN_",",22)=$P(TEXT,";",17)
 . ;
 . ;ALIAS (#23)
 . S OBJUPD(19930.2,OIEN_",",23)=$P(TEXT,";",18)
 . ;
 . ;TECHNICAL DESCRIPTION (#98)
 . S OBJUPD(19930.2,OIEN_",",98)=$P(TEXT,";",19)
 . ;
 . ;DESCRIPTION (#99)
 . S OBJUPD(19930.2,OIEN_",",99)=$P(TEXT,";",20)
 . ;
 . ;CLSID (#.5)
 . S OBJUPD(19930.2,OIEN_",",.5)=$P(TEXT,";",21)
 . ;
 . ;HEIGHT (#4)
 . S OBJUPD(19930.2,OIEN_",",4)=$P(TEXT,";",22)
 . ;
 . ;WIDTH (#5)
 . S OBJUPD(19930.2,OIEN_",",5)=$P(TEXT,";",23)
 . ;
 . ;MD5 CHECKSUM
 . I $P(TEXT,";")["IHS.PN.EHR.PRENATALPROBLEMLIST.PIPCOMPONENT" S OBJUPD(19930.2,OIEN_",",7)="A714B1ED0C7666F33B8971CF62BF555C"
 . I $P(TEXT,";")["FILE:BEHPOVCVG.DLL" S OBJUPD(19930.2,OIEN_",",7)="911222CD72C63E357C09F4FA5F6D04DF"
 . ;
 . ;Update entry
 .D FILE^DIE("","OBJUPD","ERROR")
 ;
XPST Q
 ;
 ;;File 19930.2 Field listing
 ;;PROGID;NAME;VRSN;SRC;SER;INI;REQ;PROP;MULT;DIS;ALLK;HIDD;SBYS;SERV;REG;NORG;DOTN;ALIA;TDES;DES;CLSID;HEIGHT;WIDTH;MD5 CHECKSUM
 ;;.01;1;2;3;8;9;10;11;12;13;14;15;16;17;18;19;22;23;98;99.5;4;5
OBJ ;;
 ;;FILE:BEHPOVCVG.DLL;BEHPovCvg;1.1.0.4;BEHPovCvg.dll;;;;0;1;0;0;1;0;0;0;;0;;;;;;
 ;;IHS.PN.EHR.PRENATALPROBLEMLIST.PIPCOMPONENT;Pregnancy Issues and Problems List;2.0.11.2;IHS.PN.EHR.PrenatalProblemList.dll;;;IHS.PN.EHR.PrenatalProblemList.chm;0;1;0;0;0;0;0;0;;1;;;;{B5416178-ECD8-4515-A700-2980BCAA6CAA};300;640;
 ;;END;
 ;;
 ;
INSTALLD(BJPNSTAL) ;EP - Determine if patch BJPNSTAL was installed, where
 ;BJPNSTAL is the name of the INSTALL.  E.g "BJPN*2.0*10".
 ;
 NEW DIC,X,Y,D
 S X=$P(BJPNSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(BJPNSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BJPNSTAL,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
