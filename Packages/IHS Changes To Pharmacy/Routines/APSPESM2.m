APSPESM2 ;IHS/MSC/PLS - Surescripts Mailbox - Reports;21-Oct-2020 16:05;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1024,1026,1027**;Sep 23, 2004;Build 31
 Q
 ; Utilization Report
 ; Inputs:
 ; PRV = New Person File IEN
 ; OPT = Options
 ;  Dn = Detail level to n (default=1)
 ;  F  = Display Footer
 ;  P  = Included Prescriber Agent
 ; SDT = Earliest date
 ; EDT = Most recent date
 ;
UTLZ(PRV,OPT,SDT,EDT) ;-
 N ESPID,PRV,INCPA,DTL,OLP,OLP1,RTM
 S RTM=$H
 S PRV=$G(PRV,DUZ)
 S OPT=$G(OPT,"FPD1")
 S INCPA=+OPT["P"
 S DTL=+$P(OPT,"D",2)
 ;F OLP="D" D:OPT[OLP
 ;.S OLP1=+$P(OPT,OLP,2)
 ;.I OLP="D" S DTL=OLP1
 S ESPID="UTL"_$J
 ;S SDT=$$FMADD^XLFDT(DT,-365)
 ;S EDT=DT
 ;D TST
 ;Q
 D UTLFIND(SDT,EDT,PRV)
 S ^TMP(ESPID,"LBL","G")="Generic Substitution"
 S ^TMP(ESPID,"LBL","P")="Prior Authorization"
 S ^TMP(ESPID,"LBL","T")="Therapeutic Substitution"
 S ^TMP(ESPID,"LBL","D")="Drug Evaluation"
 S ^TMP(ESPID,"LBL","S")="Script Clarification"
 S ^TMP(ESPID,"LBL","U")="Precriber Authorization"
 S ^TMP(ESPID,"LBL","O")="Out Of Stock"
 I '$D(^TMP(ESPID,"RES")) D  Q
 .W "<TITLE>No Results</TITLE><H3>Your UTILIZATION query produced no results.<P>Try adjusting your search criteria.</H3>",!
 .K ^TMP(ESPID)
 D UTLOUT
 K ^TMP(ESPID)
 Q
 ; Find entries
UTLFIND(SDT,EDT,PRV) ;-
 N CNT,IEN,FDTLP,LP,N0,N1,ORID,OI
 S FDTLP=SDT-.01
 S CNT=0
 K ^TMP(ESPID)
 F  S FDTLP=$O(^PS(52.51,"AC1",FDTLP)) Q:'FDTLP!(FDTLP>(EDT+.99))  D
 .S IEN=0 F  S IEN=$O(^PS(52.51,"AC1",FDTLP,IEN)) Q:'IEN  D
 ..S N0=^PS(52.51,IEN,0)
 ..Q:$P(N0,U,4)'=PRV  ;Not an order for provider
 ..S ORID=$$GET1^DIQ(52,$P(N0,U),39.3,"I")  ;Get Orderable Item
 ..S OI=+$$VALUE^ORCSAVE2(ORID,"ORDERABLE")
 ..D SET("ORD",IEN,N0,+$P(N0,U,2),OI)
 S FDTLP=SDT-.01 F  S FDTLP=$O(^APSPRREQ("D",FDTLP)) Q:'FDTLP!(FDTLP>(EDT+.99))  D
 .S IEN=0 F  S IEN=$O(^APSPRREQ("D",FDTLP,IEN)) Q:'IEN  D
 ..S N0=^APSPRREQ(IEN,0),N1=^APSPRREQ(IEN,1)
 ..Q:INCPA&($P(N1,U,13)'=PRV&($P(N1,U,3)'=PRV))
 ..;I $P(N1,U,13)'=PRV&($P(N1,U,3)'=PRV) Q  ;Provider was not prescriber or agent
 ..Q:$P(N1,U,3)'=PRV  ;Not a request for provider
 ..D SET("REQ",IEN,N0_"~"_N1,+$P(N1,U,2),+$P(N1,U,1))
 Q
 ;
UTLOUT() ;-
 N ORDCNT,RENCNT,CHGCNT,LBL
 W "<TITLE>","Surescripts Utilization Report","</TITLE>"
 W "<H3>","Surescripts Utilization Report","</H3>"
 W "<H5>","User: ",$$GET1^DIQ(200,PRV,.01),"</H5></P><PRE>"
 W "<H5>","Inclusive Dates: "_$$FMTE^XLFDT(SDT,"5Z")_" to "_$$FMTE^XLFDT(EDT,"5Z"),"</H5>"
 W:OPT["P" "<H5>","Includes Prescriber Agent activity","</H5>"
 W "<H5>","Detail Level: ",DTL,"</H5>"
 ;
 S LBL="D"_DTL
 I $L($T(@LBL)) D
 .D @LBL
 E  W !,"Detail level not yet available.",!
 D:OPT["F" FTRSUM
 Q
 ;
D1 ; Level 1
 W !
 D HDR1
 W !,$$HI^APSPESM1(),"Totals:",$$NOHI^APSPESM1(),?20,$J($$TOTALS("O"),6),?30,$J($$TOTALS("R"),7),?43,$J($$TOTALS("C"),6),?53,$J($$TOTALS("D"),7),!
 Q
 ;
D2 ; Level 2
 N CTYP,LP,LP1
 W !
 D HDR2
 W !,?2,"Orders",?29,$J($$TOTALS("O"),6)
 W !,?2,"Renewals",?29,$J($$TOTALS("R"),6)
 W !,?2,"Changes",?29,$J($$TOTALS("C"),6)
 S CTYP=$$TOTALS("CN")
 F LP="D","G","0","P","S","T","U" D:CTYP[LP
 .S LP1=+$P(CTYP,LP,2)
 .W:$D(^TMP(ESPID,"LBL",LP)) !,?4,^(LP),?34,LP1
 W !,?2,"Denials",?29,$J($$TOTALS("D"),6)
 Q
D3 ; Level 3 - Counts by Patient
 N LP,PAT
 W !
 D HDR3
 S LP="" F  S LP=$O(^TMP(ESPID,"PATNM",LP)) Q:LP=""  D
 .S PAT=+^TMP(ESPID,"PATNM",LP)
 .W !,$$HI^APSPESM1(),LP,$$NOHI^APSPESM1(),?34,$J($$TOTALS("O",PAT),6),?46,$J($$TOTALS("R",PAT),6),?56,$J($$TOTALS("C",PAT),6),?66,$J($$TOTALS("D",PAT),6)
 Q
D4 ; Level 4 - Counts by Orderable Item
 N LP,OI
 W !
 D HDR4
 S LP="" F  S LP=$O(^TMP(ESPID,"OINM",LP)) Q:LP=""  D
 .S OI=+^TMP(ESPID,"OINM",LP)
 .W !,$$HI^APSPESM1(),LP,$$NOHI^APSPESM1(),?34,$J($$TOTALS("O",,OI),6),?46,$J($$TOTALS("R",,OI),6),?56,$J($$TOTALS("C",,OI),6),?66,$J($$TOTALS("D",,OI),6)
 Q
D5 ; Level 5 - Breakout by Patient and Medication
 N LP,LP1,OI,PAT
 W !
 D HDR5P
 S LP="" F  S LP=$O(^TMP(ESPID,"PATNM",LP)) Q:LP=""  D
 .S PAT=+^TMP(ESPID,"PATNM",LP)
 .W !,$$HI^APSPESM1(),LP,$$NOHI^APSPESM1()
 .S LP1="" F  S LP1=$O(^TMP(ESPID,"OINM",LP1)) Q:LP1=""  D
 ..S OI=+^TMP(ESPID,"OINM",LP1)
 ..Q:'$G(^TMP(ESPID,"PAT",PAT,"OI",OI))
 ..W !,?2,LP1,?34,$J($$TOTALS("O",PAT,OI),6),?46,$J($$TOTALS("R",PAT,OI),6),?56,$J($$TOTALS("C",PAT,OI),6),?66,$J($$TOTALS("D",PAT,OI),6)
 W !!
 D HDR5M
 S LP="" F  S LP=$O(^TMP(ESPID,"OINM",LP)) Q:LP=""  D
 .S OI=+^TMP(ESPID,"OINM",LP)
 .W !,$$HI^APSPESM1(),LP,$$NOHI^APSPESM1()
 .S LP1="" F  S LP1=$O(^TMP(ESPID,"PATNM",LP1)) Q:LP1=""  D
 ..S PAT=+^TMP(ESPID,"PATNM",LP1)
 ..Q:'$G(^TMP(ESPID,"PAT",PAT,"OI",OI))
 ..W !,?2,LP1,?34,$J($$TOTALS("O",PAT,OI),6),?46,$J($$TOTALS("R",PAT,OI),6),?56,$J($$TOTALS("C",PAT,OI),6),?66,$J($$TOTALS("D",PAT,OI),6)
 W !!
 Q
D6 ; Level 6 - Order/Request details
 N LP,LP1,ORID,PAT,DAT,JUNK,DFLG
 S DFLG=0
 S LP="" F  S LP=$O(^TMP(ESPID,"PATNM",LP)) Q:LP=""  D
 .S PAT=+^TMP(ESPID,"PATNM",LP)
 .W !,$$HI^APSPESM1(),LP,$$NOHI^APSPESM1()
 .D HDR6O
 .S LP1=0 F  S LP1=$O(^TMP(ESPID,"PAT","ORD",PAT,LP1)) Q:'LP1  D
 ..S DAT=^TMP(ESPID,"DATA",^TMP(ESPID,"PAT","ORD",PAT,LP1))
 ..S ORID=$$GET1^DIQ(52,$P(DAT,U),39.3)
 ..S DFLG=1
 ..D
 ...N LST,WLP
 ...W !,"Transmitted Orders..."
 ...W !,ORID,?12,$TR($$FMTE^XLFDT($P(DAT,U,3),"5MZ"),"@"," ")
 ...D TEXT^ORQ12(.LST,ORID,45)
 ...S WLP="" F  S WLP=$O(LST(WLP)) Q:WLP=""  D
 ....W ?34,LST(WLP),!
 .W:'DFLG !,?5,"No order details found."
 .D HDR6R
 .S DFLG=0
 .S LP1=0 F  S LP1=$O(^TMP(ESPID,"PAT","REQ",PAT,LP1)) Q:'LP1  D
 ..S DAT=^TMP(ESPID,"DATA",^TMP(ESPID,"PAT","REQ",PAT,LP1))
 ..S DFLG=1
 ..D
 ...N LST,WLP,LF
 ...W !,"Requests Received"
 ...W !,$P(DAT,U)," (",LP1,")",?22,$TR($$FMTE^XLFDT($P(DAT,U,4),"5MZ"),"@"," "),?40,$$GET1^DIQ(9009033.91,LP1,.12),$S($P($P(DAT,"~",1),U,12)="C":" ("_$$GET1^DIQ(9009033.91,LP1,7.4)_")",1:""),?52,$$GET1^DIQ(9009033.91,LP1,.03)
 ...W:"35"[$P(DAT,U,3) !,"Denial Reason: ",$$GET1^DIQ(9009033.91,LP1,4)
 ...W:$P($P(DAT,"~",2),U,13) !,"Prescriber Agent: ",$$GET1^DIQ(9009033.91,LP1,1.13)
 ...W !,"Pharmacy: ",$$GET1^DIQ(9009033.91,LP1,1.7)
 ...S ORID=$$GET1^DIQ(9009033.91,LP1,.02)
 ...I ORID D
 ....D TEXT^ORQ12(.LST,ORID,45)
 ....S WLP="" F  S WLP=$O(LST(WLP)) Q:WLP=""  D
 .....W ?34,LST(WLP),!
 ...W !
 .W:'DFLG !,?5,"No request details found.",!
 ;
 Q
 ; Loops through list of orders and requests and displays details for each
D9 ; Level 9
 N LP,ORID,PAT,DAT,JUNK,DFLG
 S DFLG=0
 W !,$$STRON^APSPESM1(),"ORDER DETAILS",$$STROFF^APSPESM1()
 S LP=0 F  S LP=$O(^TMP(ESPID,"RES","ORD",LP)) Q:'LP  D
 .S DAT=^TMP(ESPID,"DATA",^TMP(ESPID,"RES","ORD",LP))
 .S PAT=$P(DAT,U,2)
 .S ORID=$$GET1^DIQ(52,$P(DAT,U),39.3)
 .S DFLG=1
 .D
 ..N LST,WLP
 ..S LST=""
 ..W !,?2,$$UND^APSPESM1(),"Patient: "_$$HI^APSPESM1(),$$GET1^DIQ(2,PAT,.01),$$NOHI^APSPESM1(),$$NOUND^APSPESM1(),?40,$$UND^APSPESM1(),"Order Number: "_ORID,$$NOUND^APSPESM1(),!
 ..D DETAIL^ORWOR(.LST,ORID,PAT)
 ..I $L(LST) S WLP="" F  S WLP=$O(@LST@(WLP)) Q:'WLP  D
 ...W !,@LST@(WLP)
 .W !
 W:'DFLG !,?5,"No order details found."
 ;
 S DFLG=0
 W !!,$$STRON^APSPESM1(),"REQUESTS DETAILS",$$STROFF^APSPESM1()
 S LP=0 F  S LP=$O(^TMP(ESPID,"RES","REQ",LP)) Q:'LP  D
 .S DFLG=1
 .W !,?2,$$UND^APSPESM1(),"Message ID: "_$P($P(^TMP(ESPID,"DATA",^TMP(ESPID,"RES","REQ",LP)),U),";"),$$NOUND^APSPESM1()
 .D DETAIL^APSPESG1("JUNK",LP,1)
 W:'$G(DFLG) !,?5,"No request details found."
 Q
 ; Loops through list of orders and requests and displays details for each by patient
D10 ; Level 10
 N LP,LP1,ORID,PAT,DAT,JUNK,DFLG
 S DFLG=0
 S LP="" F  S LP=$O(^TMP(ESPID,"PATNM",LP)) Q:LP=""  D
 .S PAT=+^TMP(ESPID,"PATNM",LP)
 .W !,$$HI^APSPESM1(),LP,$$NOHI^APSPESM1()
 .W !,$$STRON^APSPESM1(),"ORDER DETAILS",$$STROFF^APSPESM1()
 .S LP1=0 F  S LP1=$O(^TMP(ESPID,"PAT","ORD",PAT,LP1)) Q:'LP1  D
 ..S DAT=^TMP(ESPID,"DATA",^TMP(ESPID,"PAT","ORD",PAT,LP1))
 ..S ORID=$$GET1^DIQ(52,$P(DAT,U),39.3)
 ..S DFLG=1
 ..D
 ...N LST,WLP
 ...S LST=""
 ...W !,?2,$$UND^APSPESM1(),"Order Number: "_ORID,$$NOUND^APSPESM1(),!
 ...D DETAIL^ORWOR(.LST,ORID,PAT)
 ...I $L(LST) S WLP="" F  S WLP=$O(@LST@(WLP)) Q:'WLP  D
 ....W !,@LST@(WLP)
 ..W !
 .W:'DFLG !,?5,"No order details found."
 .S DFLG=0
 .W !!,$$STRON^APSPESM1(),"REQUESTS DETAILS",$$STROFF^APSPESM1()
 .S LP1=0 F  S LP1=$O(^TMP(ESPID,"PAT","REQ",PAT,LP1)) Q:'LP1  D
 ..S DAT=^TMP(ESPID,"DATA",^TMP(ESPID,"PAT","REQ",PAT,LP1))
 ..S DFLG=1
 ..W !,?2,$$UND^APSPESM1(),"Message ID: "_$P($P(DAT,U),";"),$$NOUND^APSPESM1()
 ..D DETAIL^APSPESG1("JUNK",LP1,1)
 .W:'$G(DFLG) !,?5,"No request details found."
 .W !
 Q
 ;
TOTALS(TYPE,PAT,OI) ;-
 N LP,CNT,VAL,ST,DAT,NODE
 S CNT=0
 I TYPE="O" D
 .S LP=0 F  S LP=$O(^TMP(ESPID,"RES","ORD",LP)) Q:'LP  D
 ..S NODE=^TMP(ESPID,"RES","ORD",LP)
 ..S DAT=^TMP(ESPID,"DATA",NODE)
 ..S VAL=$P(DAT,U) ; Prescription IEN
 ..Q:$D(^APSPRREQ("H",VAL))  ; Do not count request orders as NewRx orders
 ..I $G(PAT),PAT'=$P(DAT,U,2) Q
 ..I $G(OI),NODE'=$G(^TMP(ESPID,"OI","ORD",OI,LP)) Q
 ..S CNT=CNT+1
 E  I TYPE="R" D  ;RENEWALS
 .S LP=0 F  S LP=$O(^TMP(ESPID,"RES","REQ",LP)) Q:'LP  D
 ..S NODE=^TMP(ESPID,"RES","REQ",LP)
 ..S DAT=^TMP(ESPID,"DATA",NODE)
 ..S VAL=$P($P(DAT,"~",1),U,12)  ;Type
 ..I $G(PAT),PAT'=$P($P(DAT,"~",2),U,2) Q
 ..I $G(OI),NODE'=$G(^TMP(ESPID,"OI","REQ",OI,LP)) Q
 ..S:VAL=""!(VAL="R") CNT=CNT+1
 E  I TYPE="C" D  ;CHANGES
 .S LP=0 F  S LP=$O(^TMP(ESPID,"RES","REQ",LP)) Q:'LP  D
 ..S NODE=^TMP(ESPID,"RES","REQ",LP)
 ..S DAT=^TMP(ESPID,"DATA",NODE)
 ..S VAL=$P($P(DAT,"~",1),U,12)  ;Type
 ..I $G(PAT),PAT'=$P($P(DAT,"~",2),U,2) Q
 ..I $G(OI),NODE'=$G(^TMP(ESPID,"OI","REQ",OI,LP)) Q
 ..S:VAL="C" CNT=CNT+1
 E  I TYPE="D" D  ;DENIALS
 .S LP=0 F  S LP=$O(^TMP(ESPID,"RES","REQ",LP)) Q:'LP  D
 ..S NODE=^TMP(ESPID,"RES","REQ",LP)
 ..S DAT=^TMP(ESPID,"DATA",NODE)
 ..S VAL=$P($P(DAT,"~",1),U,12)
 ..I $G(PAT),PAT'=$P($P(DAT,"~",2),U,2) Q
 ..I $G(OI),NODE'=$G(^TMP(ESPID,"OI","REQ",OI,LP)) Q
 ..S:"35"[$P(DAT,U,3) CNT=CNT+1
 E  I TYPE="CN" D  ;CHANGES enumerated by subtype
 .S LP=0 F  S LP=$O(^TMP(ESPID,"RES","REQ",LP)) Q:'LP  D
 ..S DAT=^TMP(ESPID,"DATA",^TMP(ESPID,"RES","REQ",LP))
 ..S VAL=$P($P(DAT,"~",1),U,12)
 ..I $G(PAT),PAT'=$P($P(DAT,"~",2),U,2) Q
 ..I VAL="C" D
 ...S ST=$P($G(^APSPRREQ(LP,7)),U,4)
 ...Q:ST=""
 ...S CNT(ST)=$G(CNT(ST))+1
 .S (CNT,LP)="" F  S LP=$O(CNT(LP)) Q:LP=""  D
 ..S CNT=CNT_LP_CNT(LP)
 Q CNT
 ;
HDR1() ;-
 W !,"Surescripts Totals",!
 D DASH
 W !,?20,"Orders",?30,"Renewals",?42,"Changes",?53,"Denials",$$NOHI^APSPESM1(),!
 D DASH
 Q
HDR2 ;-
 W !,"Surescripts Transaction counts",!
 D DASH
 W !,?5,"Type",?30,"Count",!
 D DASH
 Q
HDR3 ;-
 W !,"Surescripts Counts by Patient",!
 D DASH
 W !,?2,"Patient",?34,"Orders",?44,"Renewals",?55,"Changes",?65,"Denials",!
 D DASH
 Q
HDR4 ;-
 W !,"Surescripts Counts by Medication",!
 D DASH
 W !,?2,"Medication",?34,"Orders",?44,"Renewals",?55,"Changes",?65,"Denials",!
 D DASH
 Q
HDR5P ;-
 W !,"Surescripts Counts by Patient/Medication",!
 D DASH
 W !,"Patient"
 W !,?2,"Medication",?34,"Orders",?44,"Renewals",?55,"Changes",?65,"Denials",!
 D DASH
 Q
HDR5M ;-
 W !,"Surescripts Counts by Medication/Patient",!
 D DASH
 W !,"Medication"
 W !,?2,"Patient",?34,"Orders",?44,"Renewals",?55,"Changes",?65,"Denials",!
 D DASH
 Q
HDR6O ;-
 W !,"Surescripts Order Descriptions",!
 D DASH
 W !,"Order #",?12,"Tx Date",?34,"Details",!
 D DASH
 Q
HDR6R ;-
 W !,"Surescripts Request Descriptions",!
 D DASH
 W !,"Request #",?22,"Date",?40,"Type",?52,"Status",!
 D DASH
 Q
FTRSUM() ;-
 W !!!,$$STRON^APSPESM1()
 W "<Details><summary>Copyright "_$P($$FMTE^XLFDT($$DT^XLFDT())," ",3)_"</summary><p> - Generated by RPMS on "
 W $P($$SITE^VASITE(),U,2)_" at "_$$FMTE^XLFDT($$NOW^XLFDT())_" in "_-$$HDIFF^XLFDT(RTM,$H,2)_" seconds.</p></details>",$$STROFF^APSPESM1(),!
 Q
 ; Set data into ^TMP global
SET(TYPE,IEN,DATA,PAT,OI) ;-
 N NXT,PNM,OINM
 S NXT=+$O(^TMP(ESPID,"DATA",$C(1)),-1)
 S NXT=NXT+1
 S ^TMP(ESPID,"DATA",NXT)=DATA
 S ^TMP(ESPID,"RES",TYPE,IEN)=NXT
 S ^TMP(ESPID,"PAT",TYPE,PAT,IEN)=NXT
 S ^TMP(ESPID,"OI",TYPE,OI,IEN)=NXT
 I $G(PAT) D
 .S PNM=$$GET1^DIQ(2,PAT,.01)
 .S:PNM="" PNM="UNKNOWN"
 .S:$L(PNM) ^TMP(ESPID,"PATNM",PNM)=PAT
 I $G(OI) D
 .S OINM=$$GET1^DIQ(101.43,OI,.01)
 .S:OINM="" OINM="UNKNOWN"
 .S:$L(OINM) ^TMP(ESPID,"OINM",OINM)=OI
 I $G(PAT),$G(OI) D
 .S ^TMP(ESPID,"PAT",PAT,"OI",OI)=NXT
 Q
 ; Output HTML tag
 ; Preserves $X and $Y
TAG(VAL) ;-
 N APX,APY
 S APX=$X,APY=$Y
 W VAL
 S $X=APX,$Y=APY
 Q ""
 ;
DASH ;-
 N DASH
 F DASH=1:1:80 W "-"
 Q
 ;
TST ;
 D UTLOUT()
 S APSPBD=3160718.99
 S APSPBDF="07/19/2016"
 S APSPDIV="*"
 S APSPDRG=""
 S APSPDSUB=0
 S APSPED=3190415.99
 S APSPEDF="04/15/2019"
 S APSPFIL="A"
 S APSPGRP=0
 S APSPOUT=2
 S APSPQ=0
 S APSPSRT=1
 S APSPSRT2=2
 D OUT^APSPESR2
 Q
