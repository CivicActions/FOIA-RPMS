XUCMNT3A ;SFISC/JC - GENERATE MORNING SUMMARY ;07/10/96  09:30 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**17**;Apr 25, 1995
NODE ;
 S $P(LINE,"-",78)=""
 S ^TMP($J,"RPT",1)="System Performance Summary for 8am - 4:30pm, "_XUCMDTX
 S ^TMP($J,"RPT",2)="(Hourly collections of 15 minutes duration, 10 second sample intervals)"
 F C=3:1:5 S ^TMP($J,"RPT",C)=""
 S C=C+1,^TMP($J,"RPT",C)=LINE,C=C+1,^(C)="SYSTEM SUMMARY",C=C+1,^(C)=LINE
 S XUCMND=0 F  S XUCMND=$O(^TMP($J,"ND",XUCMND)) Q:XUCMND<1  D
 .S C=$G(C)+1,^TMP($J,"RPT",C)=""
 .S I=$G(^TMP($J,"ND",XUCMND,"PRC")) I I'="" S XUCMNODE=$P(I,U,3),XUCMTYPE=$P(I,U,4),XUCMMEM=$P(^XUCM(8986.3,XUCMND,0),U,3),C=$G(C)+1,^TMP($J,"RPT",C)="For Node: "_XUCMNODE_" / Type: "_XUCMTYPE_" / Memory: "_XUCMMEM_" Mbytes"
 .S C=$G(C)+1,^TMP($J,"RPT",C)=""
 .S C=$G(C)+1,^TMP($J,"RPT",C)=$J("Metric",28)_$J("Average",11)_"  "_$J("High(Low)",18)_$J("2sd Range",18)
 .F MET="RTM","RSP","PRC","IPRC","AZS" D
 ..S I=$G(^TMP($J,"ND",XUCMND,MET)) I I'="" D
 ...I $P(I,U,4)'="" S XUCMTYPE=$P(I,U,4)
 ...S EXT=$TR($G(XUCMR(XUCMND,MET)),"^"),RNG=$P($$RNG^XUCMPA2(MET,XUCMTYPE),U)_"-"_$P($$RNG^XUCMPA2(MET,XUCMTYPE),U,2)
 ...S MET1=$O(^XUCM(8986.4,"B",MET,0)),MET1=$J($P(^XUCM(8986.4,MET1,0),U,2),27)_": "
 ...S RES=$P(I,U,7),STAR="  "
 ...I EXT,RES>$P(RNG,"-",2) S STAR=" *"
 ...I EXT["(",RES<$P(RNG,"-") S STAR=" *"
 ...S C=$G(C)+1,^TMP($J,"RPT",C)=MET1_$J(RES,10,1)_STAR_$J(EXT,18)_$J(RNG,18)
 .S C=C+1,^TMP($J,"RPT",C)=""
 .S C=$G(C)+1,^TMP($J,"RPT",C)=$J("CPU MODES",27)
 .F MET="IDLE","USR","KRM","ISTK" D
 ..S I=$G(^TMP($J,"ND",XUCMND,MET)) I I'="" D
 ...S EXT=$TR($G(XUCMR(XUCMND,MET)),"^"),RNG=$P($$RNG^XUCMPA2(MET,XUCMTYPE),U)_"-"_$P($$RNG^XUCMPA2(MET,XUCMTYPE),U,2)
 ...S MET1=$O(^XUCM(8986.4,"B",MET,0)),MET1=$J($P(^XUCM(8986.4,MET1,0),U,2),27)_": "
 ...S RES=$P(I,U,7),STAR="  "
 ...I EXT,RES>$P(RNG,"-",2) S STAR=" *"
 ...I EXT["(",RES<$P(RNG,"-") S STAR=" *"
 ...S C=$G(C)+1,^TMP($J,"RPT",C)=MET1_$J(RES,10,1)_STAR_$J(EXT,18)_$J(RNG,18)
 .S C=C+1,^TMP($J,"RPT",C)=""
 .S C=$G(C)+1,^TMP($J,"RPT",C)=$J("COMPUTE QUEUES",27)
 .F MET="CUR","COM","COMO" D
 ..S I=$G(^TMP($J,"ND",XUCMND,MET)) I I'="" D
 ...S EXT=$TR($G(XUCMR(XUCMND,MET)),"^"),RNG=$P($$RNG^XUCMPA2(MET,XUCMTYPE),U)_"-"_$P($$RNG^XUCMPA2(MET,XUCMTYPE),U,2)
 ...S MET1=$O(^XUCM(8986.4,"B",MET,0)),MET1=$J($P(^XUCM(8986.4,MET1,0),U,2),27)_": "
 ...S RES=$P(I,U,7),STAR="  "
 ...I EXT,RES>$P(RNG,"-",2) S STAR=" *"
 ...I EXT["(",RES<$P(RNG,"-") S STAR=" *"
 ...S C=$G(C)+1,^TMP($J,"RPT",C)=MET1_$J(RES,10,1)_STAR_$J(EXT,18)_$J(RNG,18)
 .S C=C+1,^TMP($J,"RPT",C)=""
 .S C=$G(C)+1,^TMP($J,"RPT",C)=$J("MEMORY/IO",27)
 .F MET="FREL","MODL","PGFR","PGIO","DIO","BIO" D
 ..S I=$G(^TMP($J,"ND",XUCMND,MET)) I I'="" D
 ...S EXT=$TR($G(XUCMR(XUCMND,MET)),"^"),RNG=$P($$RNG^XUCMPA2(MET,XUCMTYPE),U)_"-"_$P($$RNG^XUCMPA2(MET,XUCMTYPE),U,2)
 ...S MET1=$O(^XUCM(8986.4,"B",MET,0)),MET1=$J($P(^XUCM(8986.4,MET1,0),U,2),27)_": "
 ...S RES=$P(I,U,7),STAR="  "
 ...I EXT,RES>$P(RNG,"-",2) S STAR=" *"
 ...I EXT["(",RES<$P(RNG,"-") S STAR=" *"
 ...S C=$G(C)+1,^TMP($J,"RPT",C)=MET1_$J(RES,10,1)_STAR_$J(EXT,18)_$J(RNG,18)
 .S C=C+1,^TMP($J,"RPT",C)=""
 .S C=$G(C)+1,^TMP($J,"RPT",C)=$J("LOCKS",27)
 .F MET="ENQL","ENQI","ENQO","ASTL","ASTI","ASTO","ENQF" D
 ..S I=$G(^TMP($J,"ND",XUCMND,MET)) I I'="" D
 ...S EXT=$TR($G(XUCMR(XUCMND,MET)),"^"),RNG=$P($$RNG^XUCMPA2(MET,XUCMTYPE),U)_"-"_$P($$RNG^XUCMPA2(MET,XUCMTYPE),U,2)
 ...S MET1=$O(^XUCM(8986.4,"B",MET,0)),MET1=$J($P(^XUCM(8986.4,MET1,0),U,2),27)_": "
 ...S RES=$P(I,U,7),STAR="  "
 ...I EXT,RES>$P(RNG,"-",2) S STAR=" *"
 ...I EXT["(",RES<$P(RNG,"-") S STAR=" *"
 ...S C=$G(C)+1,^TMP($J,"RPT",C)=MET1_$J(RES,10,1)_STAR_$J(EXT,18)_$J(RNG,18)
 .I $D(^TMP($J,"EVNT",XUCMND)) D  ;set by CHK^XUCMNIT1
 ..S C=$G(C)+1,^TMP($J,"RPT",C)=""
 ..S C=$G(C)+1,^TMP($J,"RPT",C)="ALL EVENTS OUTSIDE 3 STANDARD DEVIATIONS ON NODE "_$P($G(^XUCM(8986.3,XUCMND,0)),U)
 ..S DATE=0
 ..S C=$G(C)+1,^TMP($J,"RPT",C)=$J("Date",28)_$J("Metric",13)_$J("Value",17)_$J("3sd Limits",18)
 ..S X=$NA(^TMP($J,"EVNT",XUCMND)) F  S DATE=$O(@X@(DATE)) Q:DATE<1  S MET="" F  S MET=$O(@X@(DATE,MET)) Q:MET=""  D
 ...S Y=$J($$FMTE^XLFDT(DATE),28)_$J(MET,13)_$J(($P(^(MET),U)),17,1)_$J($J($P(^(MET),U,2),0,1)_"-"_$J($P(^(MET),U,3),0,1),18)
 ...S C=$G(C)+1,^TMP($J,"RPT",C)=Y
 S C=$G(C)+1,^TMP($J,"RPT",C)=""
 Q
