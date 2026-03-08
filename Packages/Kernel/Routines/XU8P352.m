XU8P352 ;BP-SF/BDT UPDATED FILE 200 [7/8/04 8:37am]
 ;;8.0;KERNEL;**352**;Jul 10, 1995
 ;Delete field number 1 from file #200.0351
EN1 N DIK,DA
 S DIK="^DD(200.0351,",DA=1,DA(1)=200.0351 D ^DIK
 ;-------------------------------------
 ;Delete field number 2 from file #200.0351
EN2 N DIK,DA
 S DIK="^DD(200.0351,",DA=2,DA(1)=200.0351 D ^DIK
 Q
