BINDCUP ;IHS/CMI/MWR - UPLOAD NDC DATA; SEP 15, 2020
 ;;8.5;IMMUNIZATION;**19**;SEP 01,2020;Build 13
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CODE TO UPLOAD NDC DATA AND MOVE IT TO BI TABLE NDC UPLOAD #9002084.96,
 ;;  THEN CONVERT AND ADD DATA TO BI TABLE NDC CODES File #9002084.95.
 ;;
 ;;
 ;;  * * *
 ;;
 ;;  NOTE!!! SUBROUTINES & INTRUCTIONS FOR "D READ" AND "D POPULAT" ARE IN ROUTINE BIZNDCUP.
 ;;
 ;;  * * *
 ;;
 ;
 D ^XBKVAR
 ;D READ
 ;D POPULAT
 D MERGE
 Q
 ;
 ;
MERGE ;EP
 ;---> Merge entries in upload file with BI TABLE NDC CODES File.
 ;
 N M,N S M=0,N=0
 F  S N=$O(^BINDCUP(N)) Q:'N  D
 .N BICVX,BIMANTX,BINDC,BIPROD,Y
 .S Y=^BINDCUP(N,0)
 .S BINDC=$P(Y,U,1),BICVX=$P(Y,U,2),BIMANTX=$P(Y,U,3),BIPROD=$E($P(Y,U,4),1,50)
 .I '$D(^BINDC("B",BINDC)) D
 ..N BIVIEN S BIVIEN=$$HL7TX^BIUTL2(BICVX)
 ..N BIMAN S BIMAN=$$MAN(BIMANTX)
 ..;W !,BIMANTX,?50,"BIMAN: ",BIMAN," ",$$MNAME^BIUTL2(BIMAN)
 ..D FILE^BIFMAN(9002084.95,BINDC,"",".02////"_BIVIEN_";.03////"_BIMAN_";.04////"_BIPROD)
 ..S M=M+1
 ..;W !,BINDC,"  ",BICVX,?22,BIMAN,?60,BIPROD
 ;
 W !!," ",M," entries added to the BI TABLE NDC CODES File.",!
 Q
 ;
 ;
MAN(BIMANTX) ;EP
 ;---> Try to find Manufacturer IEN based on Manufacturer name.
 ;
 N BIMANTXU S BIMANTXU=$$UPPER^BIUTL5(BIMANTX)
 N N,Y S N="",Y=0
 ;---> Look for exact match or uppercase match.
 F  S N=$O(^AUTTIMAN("B",N)) D  Q:Y  Q:(N="")
 .I (N=BIMANTX)!(N=BIMANTXU) S Y=$O(^AUTTIMAN("B",N,0)) Q
 Q:Y Y
 ;
 ;---> Take 1st piece of uploaded file by space, then by comma.
 S N="",BIMANTX=$P(BIMANTX," "),BIMANTXU=$P(BIMANTXU," ")
 S N="",BIMANTX=$P(BIMANTX,","),BIMANTXU=$P(BIMANTXU,",")
 F  S N=$O(^AUTTIMAN("B",N)) D  Q:Y  Q:(N="")
 .;---> Take 1st piece of existing file by space, then by comma.
 .N Z S Z=$P(N," "),Z=$P(Z,",")
 .I Z=BIMANTX!(Z=BIMANTXU) S Y=$O(^AUTTIMAN("B",N,0)) Q
 .;W !,Z," + ",BIMANTX," + ",BIMANTXU R ZZZ
 ;
 Q Y
