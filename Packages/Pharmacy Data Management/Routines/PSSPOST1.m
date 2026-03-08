PSSPOST1 ;BIR/RTR-Post init for patch 34 ;04/03/00
 ;;1.0;PHARMACY DATA MANAGEMENT;**34**;9/30/97
 ;
 ;Populate new Dosage Form file data
 D BMES^XPDUTL("Updating Dosage Form file with data...")
 N DA S DA=0 F  S DA=$O(@XPDGREF@("DUPD",DA)) Q:'DA  M ^PS(50.606,DA,"DUPD")=@XPDGREF@("DUPD",DA)
 S DA=0 F  S DA=$O(@XPDGREF@("UNIT",DA)) Q:'DA  M ^PS(50.606,DA,"UNIT")=@XPDGREF@("UNIT",DA)
 M ^PS(50.606,"ACONI")=@XPDGREF@("ACONI")
 M ^PS(50.606,"ACONO")=@XPDGREF@("ACONO")
 M ^PS(50.606,"ADUPI")=@XPDGREF@("ADUPI")
 M ^PS(50.606,"ADUPO")=@XPDGREF@("ADUPO")
 ;Initialize data if this is the first install
 I $$PATCH^XPDUTL("PSS*1.0*34") G END
 D BMES^XPDUTL("Initializing new data fields...")
 N PSSIN,PSSINI
 S PSSIN=$O(^PS(59.7,0))
 I PSSIN F PSSINI=3,4,5,6 S $P(^PS(59.7,PSSIN,80),"^",PSSINI)=""
 F PSSIN=0:0 S PSSIN=$O(^PS(51.2,PSSIN)) Q:'PSSIN  S $P(^PS(51.2,PSSIN,0),"^",6)=""
 F PSSIN=0:0 S PSSIN=$O(^PS(51,PSSIN)) Q:'PSSIN  S $P(^PS(51,PSSIN,0),"^",8)=""
 D BMES^XPDUTL("Updating current Dosage Form fields...")
 F PSSIN=0:0 S PSSIN=$O(^PS(50.606,PSSIN)) Q:'PSSIN  F PSSINI=0:0 S PSSINI=$O(^PS(50.606,PSSIN,"NOUN",PSSINI)) Q:'PSSINI  I $P($G(^(PSSINI,0)),"^")'="" D
 .S $P(^PS(50.606,PSSIN,"NOUN",PSSINI,0),"^",2)="IO",$P(^(0),"^",3)=1
END ;
 Q
