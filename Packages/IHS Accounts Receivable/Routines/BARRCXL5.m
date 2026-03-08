BARRCXL5 ;IHS/SD/CPC - DETAIL XML REPORT;05/12/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**30**;OCT 26, 2005;Build 55
 ;
 ;
 ;BAR*1.8*30 - XML parent elements for Cancelled bills report
 Q
XLDETDAT    ;
 N ROWDATA,X,Y
 S Y=4  ;Y=First row number after header
 S BARBCANC=""
 F  S BARBCANC=$O(^TMP($J,"BAR-CXL XML DET",BARBCANC)) Q:BARBCANC']""  D
 .S BARLOC=""
 .F  S BARLOC=$O(^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC)) Q:BARLOC']""  D
 ..S BARSORT=""
 ..F  S BARSORT=$O(^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT)) Q:BARSORT']""  D
 ...S BARPAT=""
 ...F  S BARPAT=$O(^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT)) Q:BARPAT']""  D
 ....S BARBILL=""
 ....F  S BARBILL=$O(^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL)) Q:BARBILL']""  D
 .....D XMLROW
 Q
XMLROW    ;
 F X=1:1:11 S ROWDATA(X)=""
 I '$D(^TMP($J,"BAR-CXL")) D  Q           ; No data - quit
 . S ROWDATA(1)="*** NO DATA TO PRINT ***"
 S X=0
 ;F  S X=$O(^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,X)) Q:+X=0  D
 D
 .S ROWDATA(1)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,1)
 .S ROWDATA(1)=$S(ROWDATA(1)'=0:$P(^VA(200,ROWDATA(1),0),"^"),1:"Unknown Cancelling Official")
 .S ROWDATA(2)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,2)    ;BARLOC
 .S ROWDATA(3)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,3)    ;VISIT TYPE
 .S ROWDATA(4)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,12)   ;CLINIC NAME
 .S ROWDATA(5)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,4)    ;BARPAT
 .S ROWDATA(6)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,5)    ;HRN
 .S ROWDATA(7)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,6)    ;BARACCT
 .S ROWDATA(8)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,7)    ;BARBILL
 .S ROWDATA(9)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,8)    ;BAR("D")
 .S ROWDATA(10)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,9)    ;BARBREAS INTERNAL
 .I +ROWDATA(10) S ROWDATA(11)=$P($G(^ABMCBILR(ROWDATA(10),0)),U,1)                      ;Human Readable Reason
 .E  S ROWDATA(11)="Reason Not Recorded"
 .S ROWDATA(12)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,10)  ;BARBAMT
 .S ROWDATA(13)=^TMP($J,"BAR-CXL XML DET",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,11)  ;BARBAL
 .I (Y#2) D ODDROW(.ROWDATA)
 .E  D EVENROW(.ROWDATA)
 .S Y=Y+1
 Q
 ;
XLSUMDAT   ;
 I '$D(^TMP($J,"BAR-CXL")) D  Q           ; No data - quit
 .W "   <Row>",!
 .W "    <Cell ss:MergeAcross="_""""_"4"_""""_" ss:StyleID="_""""_"m333503816"_""""_"><Data ss:Type="_""""_"String"_""""_">"_""""_"*** NO DATA TO PRINT ***"_""""_"</Data></Cell>",!
 .W "   </Row>",!
 ;
 S BARCANC=""
 F  S BARBCANC=$O(^TMP($J,"BAR-CXL",BARBCANC)) Q:BARBCANC']""  D
 .S BARBCXLR=$S(BARBCANC'=0:$P(^VA(200,BARBCANC,0),"^"),1:"Unknown Cancelling Official")
 .W "   <Row>",!
 .W "    <Cell ss:MergeAcross="_""""_"4"_""""_" ss:StyleID="_""""_"m333503816"_""""_"><Data ss:Type="_""""_"String"_""""_">"_BARBCXLR_"</Data></Cell>",!  ;CX OFFICIAL NAME
 .W "    <Cell ss:StyleID="_""""_"s114"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_$P(^TMP($J,"BAR-CXL",BARBCANC),U,1)_"</Data></Cell>",!  ;OFFICIAL COUNT
 .W "    <Cell ss:StyleID="_""""_"s116"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_$P(^TMP($J,"BAR-CXL",BARBCANC),U,2)_"</Data></Cell>",!  ;OFFICIAL TOTAL
 .W "   </Row>",!
 .D LOCSUM
 Q
 ;
LOCSUM    ;
 S BARLOC=""
 F  S BARLOC=$O(^TMP($J,"BAR-CXL",BARBCANC,BARLOC)) Q:BARLOC']""  D
 .W "   <Row>",!
 .W "    <Cell ss:MergeAcross="_""""_"2"_""""_" ss:StyleID="_""""_"m333503836"_""""_"><Data ss:Type="_""""_"String"_""""_">"_BARLOC_"</Data></Cell>",!
 .W "    <Cell ss:StyleID="_""""_"s118"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_$P(^TMP($J,"BAR-CXL",BARBCANC,BARLOC),U,1)_"</Data></Cell>",!
 .W "    <Cell ss:StyleID="_""""_"s119"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_$P(^TMP($J,"BAR-CXL",BARBCANC,BARLOC),U,2)_"</Data></Cell>",!
 .W "    <Cell ss:StyleID="_""""_"s78"_""""_"/>",!
 .W "    <Cell ss:StyleID="_""""_"s120"_""""_"/>",!
 .W "   </Row>",!
 .D SORT3SUM
 Q
 ;
SORT3SUM    ;
 S SORT3=""
 F  S SORT3=$O(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,SORT3)) Q:SORT3']""  D
 .S SORT3NAM=$S(BARY("SORT")="V":$$GET1^DIQ(9002274.8,SORT3,.01,"E"),1:$$GET1^DIQ(40.7,SORT3,.01,"E"))
 .W "   <Row>",!
 .W "    <Cell ss:StyleID="_""""_"s121"_""""_"><Data ss:Type="_""""_"String"_""""_">"_SORT3NAM_"</Data></Cell>",!
 .W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_$P(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,SORT3),U,1)_"</Data></Cell>",!
 .W "    <Cell ss:StyleID="_""""_"s119"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_$P(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,SORT3),U,2)_"</Data></Cell>",!
 .W "    <Cell ss:StyleID="_""""_"s122"_""""_"/>",!
 .W "    <Cell ss:StyleID="_""""_"s119"_""""_"/>",!
 .W "    <Cell ss:StyleID="_""""_"s78"_""""_"/>",!
 .W "    <Cell ss:StyleID="_""""_"s120"_""""_"/>",!
 .W "   </Row>",!
 Q
 ;
EVENROW(ROWDATA)  ;Pass by reference
 W "   <Row>",!
 W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(1)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(2)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(3)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(4)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(5)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(6)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(7)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(8)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s79"_""""_"><Data ss:Type="_""""_"DateTime"_""""_">"_$$XDT^BARDUTL(ROWDATA(9))_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s80"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(10)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s78"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(11)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s81"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_ROWDATA(12)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s81"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_ROWDATA(13)_"</Data></Cell>",!
 W "   </Row>",!
 Q
 ;
ODDROW(ROWDATA)   ;Pass by reference
 W "   <Row>",!
 W "    <Cell ss:StyleID="_""""_"s82"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(1)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s82"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(2)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s82"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(3)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s82"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(4)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s82"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(5)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s82"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(6)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s82"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(7)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s82"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(8)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s83"_""""_"><Data ss:Type="_""""_"DateTime"_""""_">"_$$XDT^BARDUTL(ROWDATA(9))_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s84"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(10)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s82"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ROWDATA(11)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s85"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_ROWDATA(12)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s85"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_ROWDATA(13)_"</Data></Cell>",!
 W "   </Row>",!
 Q
