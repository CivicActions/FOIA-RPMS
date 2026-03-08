ACPT21XL ;IHS/SD/RNB - ACPT 2.11 ; 10 Nov 2010 08:47 AM
 ;;2.11;CPT FILES;**1**;JAN 03, 2011
 ;
 N ACPTIEN,ACPTCNT,INACT
 S ACPTIEN=0,ACPTCNT=0
 F  S ACPTIEN=$O(^ICPT(ACPTIEN)) Q:(ACPTIEN'?1N.N)  D DELETE
 Q
DELETE ;
 S ACPTCNT=ACPTCNT+1
 I '(ACPTCNT#100) W "."
 I $$VERSION^XPDUTL("BCSV")<1 D DELETE1  ;(non-CSV) Inactivate all codes
 I $$VERSION^XPDUTL("BCSV")>0 D DELETE2  ;(CSV) Inactivate all codes
 Q
DELETE1 ;
 ;
 S ACPTDESC="Couldn't find code to inactivate"
 S:$P($G(^ICPT(ACPTIEN,0)),U,2)'="" ACPTDESC=$P(^ICPT(ACPTIEN,0),U,2),INACT=$P(^ICPT(ACPTIEN,0),U,4),ACPTCODE=$P(^ICPT(ACPTIEN,0),U,1)
 I $E(ACPTCODE)?1U Q
 I $E(ACPTCODE,1,3)="000" Q
 I INACT=1 Q
 S $P(^ICPT(ACPTIEN,0),U,7)=ACPTYR  ; Date Deleted (8)
 ;
 K DIC,DIE,DIR,X,Y,DA,DR
 S DA(1)=ACPTIEN  ; parent record, i.e., the CPT code
 S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 S DIC(0)="L"  ; allow LAYGO (Learn As You Go, i.e., add if not found)
 S DIC("P")=$P(^DD(81,60,0),"^",2)  ; subfile # & specifier codes
 S X="01/01/2011"  ; value to lookup in the subfile
 D ^DIC  ; Fileman Lookup call
 S DA=+Y  ; save IEN of found/added record for next call below
 ;
 K DIR,DIE,DIC,X,Y,DR
 S DA(1)=ACPTIEN
 S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 S DR=".02////0"  ; set Status field to INACTIVE
 D ^DIE  ; Fileman Data Edit call
 Q
DELETE2 ;
 ;
 S ACPTSHRT="Couldn't find code to inactivate"
 S:$P($G(^ICPT(ACPTIEN,0)),U,2)'="" ACPTSHRT=$P(^ICPT(ACPTIEN,0),U,2),INACT=$P(^ICPT(ACPTIEN,0),U,4),ACPTCODE=$P(^ICPT(ACPTIEN,0),U,1)
 I $E(ACPTCODE)?1U Q
 I $E(ACPTCODE,1,3)="000" Q
 I INACT=1 Q
 ;
 K DIC,DIE,DIR,X,Y,DA,DR
 S DA(1)=ACPTIEN  ; parent record, i.e., the CPT code
 S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 S DIC(0)="L"  ; allow LAYGO (Learn As You Go, i.e., add if not found)
 S DIC("P")=$P(^DD(81,60,0),"^",2)  ; subfile # & specifier codes
 S X="01/01/2011"  ; value to lookup in the subfile
 N DLAYGO,Y,DTOUT,DUOUT  ; other parameters for DIC
 D ^DIC  ; Fileman Lookup call
 S DA=+Y  ; save IEN of found/added record for next call below
 ;
 K DIR,DIE,DIC,X,Y,DR
 S DA(1)=ACPTIEN
 S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 S DR=".02////0"  ; set Status field to INACTIVE
 N DIDEL,DTOUT  ; other parameters for DIE
 D ^DIE  ; Fileman Data Edit call
 ;
 K DIC,DIE,DIR,X,Y,DA,DR
 S DIE="^ICPT("
 S DA=ACPTIEN
 S DR="7////3101231;9999999.07////3101231"
 D ^DIE
 Q
