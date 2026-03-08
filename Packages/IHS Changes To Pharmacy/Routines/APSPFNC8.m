APSPFNC8 ;IHS/MSC/MGH - EPCS Functions ;09-Jul-2018 09:24;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1023**;Sep 23, 2004;Build 121
 ;=================================================================
 ;Get array of data for storing in activity log
CSLOG(PSOCSP,PSONEW) ;Get data for activity log
 K PSOCSP
 S PSOCSP("NAME")=$G(PSODRUG("NAME"))
 M PSOCSP("DOSE")=PSONEW("DOSE"),PSOCSP("DOSE ORDERED")=PSONEW("DOSE ORDERED")
 S PSOCSP("# OF REFILLS")=PSONEW("# OF REFILLS") ;track original data for dig. orders
 S PSOCSP("ISSUE DATE")=$E($P(OR0,"^",6),1,7),PSOCSP("QTY")=PSONEW("QTY"),PSOCSP("DAYS SUPPLY")=PSONEW("DAYS SUPPLY")
 Q
