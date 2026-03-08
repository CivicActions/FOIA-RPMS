BCCD2E01 ;GDIT/HS/GCD-Pre-Install Environment Check; 26 Apr 2022  3:02 PM
 ;;2.0;CCDA;**1**;Aug 12, 2020;Build 106
 ;
 ; Run pre-install checks
 N BMWRV,BMWVER
 ;
 ; Verify that BMW classes exist and we have the correct version.
 S BMWRV="2022.3"  ; Required version
 S BMWVER=$G(^BMW("Version"))
 I BMWVER="" D BMES^XPDUTL("Cannot retrieve BMW version") S XPDQUIT=2 I 1
 E  I '$$VERCMP(BMWVER,BMWRV) D BMES^XPDUTL("BMW version "_BMWRV_" or higher required. Current version: "_BMWVER) S XPDQUIT=2
 ;
 I $$GET1^DIQ(9002318.1,$O(^BSTS(9002318.1,"B",32777,""))_",",.04,"I")<57 D  S XPDQUIT=2
 . D BMES^XPDUTL("The DTS content must be on at least Cycle 50")
 ;
 I '$$PATCH^XPDUTL("BEHO*1.1*004013") D BMES^XPDUTL("EHR patch 34 is required.") S XPDQUIT=2
 ;
Q ;
 Q
 ; Compare two version numbers. Return 1 if VER1 is equal to or higher than VER2.
VERCMP(VER1,VER2) ;
 I $G(VER1)=""!($G(VER2)="") Q ""
 ; Compare major version numbers
 I $P(VER1,".")<$P(VER2,".") Q 0
 I $P(VER1,".")>$P(VER2,".") Q 1
 ; Major version numbers are equal, so compare minor version numbers
 I $P(VER1,".",2)<$P(VER2,".",2) Q 0
 Q 1
