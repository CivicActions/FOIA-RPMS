BRAODSC ;IHS/CMI/MAW - Mark Orders as Discontinued 7/21/2021 11:45:43 AM
 ;;5.0;Radiology/Nuclear Medicine;**1009**;Mar 16, 1998;Build 21
 Q
 ;
MAIN ;-- this is the main routine driver
 N ENDDT
 S ENDDT=""
 S ENDDT=$$ASK()
 I $G(ENDDT)<0 D EOJ Q
 W !,"Now marking pending orders as discontinued"
 F I=3,5,8 D LOOP(ENDDT,I)  ;20211214 maw patch 1009
 D EOJ
 Q
 ;
ASK() ;-- ask date
 N BD
 S X1=DT,X2=-730
 D C^%DTC
 S BD=X
 S %DT="AEP",%DT("A")="Mark Pending Orders as Discontinued before which date?: ",%DT("B")=$$FMTE^XLFDT(BD)
 D ^%DT
 Q Y
 ;
DAYS(DV) ;-- return days to go back
 Q $S($P($G(^RA(79,DV,9999999)),U,8):$P($G(^RA(79,DV,9999999)),U,8),1:90)
 ;
LOOP(EDT,ST) ;-- loop the rad nuc med order file and mark pending to discontinued
 N RDA,RIEN,ROEN,RS,RORD
 ;maw 20211214 TODO need to change this to pending, hold, scheduled
 S RDA=0 F  S RDA=$O(^RAO(75.1,"AS",RDA)) Q:'RDA  D
 . S RIEN=0 F  S RIEN=$O(^RAO(75.1,"AS",RDA,ST,RIEN)) Q:'RIEN  D
 .. S RDT=$P($G(^RAO(75.1,RIEN,0)),U,21)
 .. Q:RDT>EDT
 .. W "."
 .. S DIE="^RAO(75.1,",DA=RIEN,DR="5///1" D ^DIE  ;mark as discontinued
 .. K DIE,DR,DA
 .. S RORD=$P($G(^RAO(75.1,RIEN,0)),U,7)
 .. Q:'$G(RORD)
 .. D UPORD(RORD)
 Q
 ;
UPORD(ORD) ;-- update file 100 as well
 N DSC
 S DSC=$O(^ORD(100.01,"B","DISCONTINUED",0))
 Q:'DSC
 S DIE="^OR(100,",DA=ORD,DR="5////"_DSC
 D ^DIE
 K DA,DIE,DR
 Q
 ;
EOJ ;-- end of job
 D EN^XBVK("RA")
 D EN^XBVK("BRA")
 D ^XBKVAR
 Q
 ;
