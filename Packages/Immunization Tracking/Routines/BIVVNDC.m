BIVVNDC ;IHS/CMI/MWR - UPLOAD NDC DATA; SEP 15, 2020
 ;;8.5;IMMUNIZATION;**1023**;OCT 24, 2011;Build 72
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
 ;D ^XBKVAR
 ;D READ
 ;D POPULAT
 D MERGE
 Q
 ;
MERGE ;EP
 ;---> Add entries from the CDC NDC upload in the BI TABLE NDC UPLOAD
 ;---> to the BI TABLE NDC CODES file.
 ;
 D ^XBKVAR
 N M,N,Y
 S M=0,N=0
 F  S N=$O(^BINDCUP(N)) Q:'N  S Y=$G(^(N,0)) D:Y]""
 .N BICVX,BIMANTX,BINDC,BIPROD,BITEXT
 .S BINDC=$P(Y,U)
 .Q:'$L(BINDC)
 .Q:$D(^BINDC("B",BINDC))
 .S BICVX=$P(Y,U,2)
 .Q:'$L(BICVX)
 .S BIMANTX=$P(Y,U,3)
 .Q:'$L(BIMANTX)
 .S BIPROD=$E($P(Y,U,4),1,100)
 .S BISNAM=$E($P(Y,U,5),1,50)
 .S BILUP=$P(Y,U,6)
 .N BIVIEN
 .S BIVIEN=$$HL7TX^BIUTL2(BICVX)
 .N BIMAN
 .S BIMAN=$$MAN(BIMANTX)
 .D FILE^BIFMAN(9002084.95,BINDC,"",".02////"_BIVIEN_";.03////"_BIMAN_";.04////"_$S(BISNAM]"":BISNAM,1:BIPROD))
 .S M=M+1
 .S BITEXT=BINDC_"  ",$E(BITEXT,18)=BICVX,$E(BITEXT,23)=BIMANTX,$E(BITEXT,28)=$S(BISNAM]"":BISNAM,1:BIPROD)
 .D MES^XPDUTL(BITEXT)
 ;
 D MES^XPDUTL(M_" entries added to the BI TABLE NDC CODES File.")
 Q
 ;
 ;
MAN(N) ;EP
 ;---> Try to find Manufacturer IEN based on Manufacturer name.
 ;---> Look for exact match or uppercase match.
 ;
 S N=$$UPPER^BIUTL5(N)
 S Y=$O(^AUTTIMAN("C",N,0))
 S:'Y Y=$O(^AUTTIMAN("B",N,0))
 Q Y
 ;=====
 ;
 ;
XMERGE ;EP
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
 ..W !,BINDC,"  ",BICVX,?22,BIMAN,?60,BIPROD
 ;
 ;********** PATCH 1001, v8.5, MAR 01,2021, IHS/CMI/MWR
 ;---> If zero new entries, do not report.
 W !
 I M>0 W !," ",M," entries added to the BI TABLE NDC CODES File.",!
 D DIRZ^BIUTL3()
 ;**********
 Q
 ;
 ;
XMAN(BIMANTX) ;EP
 ;---> Try to find Manufacturer IEN based on Manufacturer name.
 ;
 N BIMANTXU S BIMANTXU=$$UPPER^BIUTL5(BIMANTX)
 ;
 ;---> Look for exact match on .01 Name field or uppercase match.
 N N,Y S N="",Y=0
 F  S N=$O(^AUTTIMAN("B",N)) D  Q:Y  Q:(N="")
 .I (N=BIMANTX)!(N=BIMANTXU) S Y=$O(^AUTTIMAN("B",N,0)) Q
 Q:Y Y
 ;
 ;---> Look for exact match on .02 MVX Code field or uppercase match.
 N N,Y S N="",Y=0
 F  S N=$O(^AUTTIMAN("C",N)) D  Q:Y  Q:(N="")
 .I (N=BIMANTX)!(N=BIMANTXU) S Y=$O(^AUTTIMAN("C",N,0)) Q
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
