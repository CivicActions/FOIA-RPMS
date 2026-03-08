LR7OFB0 ; IHS/DIR/AAB - Process Blood Component orders ; [ 05/15/2003  12:29 PM ]
 ;;5.2;LR;**1018**;Nov 18, 2004
 ;;5.2;LAB SERVICE;**121**;Sep 27, 1994
 ;Processing of BB orders from OE/RR use the standard LR7OF0 routines
BB(BP,DATE,LRDFN,REQ,QUANT) ;Setup Component requests in file 63
 ;BP= ptr to component in file 66
 ;DATE= date of request
 ;REQ=Requestor (free text)
 ;QUANT=Quantity ordered
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018 IHS TESTING CHANGE
 Q:$G(BP)=""
 ;----- END IHS MODIFICATIONS
 N LAST
 Q:'$D(^LR(LRDFN))  S:'$D(^LR(LRDFN,1.8,0)) ^(0)="^63.084IPA^^"
 S LAST=$P(^LR(LRDFN,1.8,0),"^",3,4)
 Q:$D(^LR(LRDFN,1.8,BP,0))  S ^(0)=BP_"^^"_DATE_"^"_QUANT_"^^^^"_DUZ_"^"_REQ,$P(^LR(LRDFN,1.8,0),"^",3,4)=BP_"^"_($P(LAST,"^",2)+1)
 Q
