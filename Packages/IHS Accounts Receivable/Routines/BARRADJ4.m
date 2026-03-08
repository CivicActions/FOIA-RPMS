BARRADJ4 ;IHS/OIT/FCJ - TRANSACTION/ADJUSTMENT REPORT - XLM FORMAT ;01/28/2021
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**31**;OCT 26,2005;Build 90
 ;IHS/OIT/FCJ - BAR*1.8*31 CR#6369 - New routine to print Spreadsheet XML detail report
 ;
 Q
 ;
 ;
 ;
DETAIL ;EP;creates appropriate number of column headers from TS report
 ;LOCATION^VISITTYPE^CLINIC^BILLNUMBER^DOS^TRANSACTION^INSURER^BILLAMOUNT^TRXNAMOUNT^PRIMARYPROVIDER"
ROWTOCOL ;
 ;Piece 1 = column name
 ;Piece 2 = cell data
 ;SORT BY VISIT OR CLINC
 S BAR("XMLSORT")=$S(BARY("SORT")="C":BARDLMTD("CLINIC"),1:BARDLMTD("VISITTYP"))
 S BARROW=BARROW+1
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,1)="LOCATION"_U_BARDLMTD("VISIT")
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,2)="VISIT TYPE"_U_BARDLMTD("VISITTYP")
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,3)="CLINIC"_U_BARDLMTD("CLINIC")
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,4)="BILL NUMBER"_U_BARDLMTD("BILLNUM")
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,5)="DOS"_U_BARDLMTD("DOS")
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,6)="TRANSACTION"_U_BARDLMTD("TRANSDATE")
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,7)="INSURER"_U_BARDLMTD("INSURER")
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,8)="BILL AMOUNT"_U_BARDLMTD("BILLAMT")
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,9)="TRXN AMOUNT"_U_BARDLMTD("TRXNAMT")
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,10)="PRIMARY PROVIDER"_U_BARDLMTD("PV")
 Q
 ;
NODATA ;ROW DATA FOR NO DATA
 ;Piece 1 = column name
 ;Piece 2 = cell data
 ;SORT BY VISIT OR CLINC
 S BAR("XMLSORT")="Z"
 S BARROW=BARROW+1
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,1)="LOCATION"_U_$P($G(^DIC(4,DUZ(2),0)),U)_"-NO DATA TO PRINT"
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,2)="VISIT TYPE"_U_""
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,3)="CLINIC"_U_""
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,4)="BILL NUMBER"_U_""
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,5)="DOS"_U_""
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,6)="TRANSACTION"_U_""
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,7)="INSURER"_U_""
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,8)="BILL AMOUNT"_U_""
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,9)="TRXN AMOUNT"_U_""
 S ^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,10)="PRIMARY PROVIDER"_U_""
 Q
 ;
PRTXML ;Walks through data and outputs data elements
 D XCELHDR
 S BAR("XMLSORT")=""
 F  S BAR("XMLSORT")=$O(^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"))) Q:BAR("XMLSORT")=""  D
 .S BARROW=0 F  S BARROW=$O(^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW)) Q:BARROW'?1N.N  D
 ..F CELL=1:1:10 S CELL(CELL)=""
 ..F CELL=1:1:10 S CELL(CELL)=$P(^XTMP("BARRADJ",$J,"TRANS STAT","COL",BAR("XMLSORT"),BARROW,CELL),U,2)
 ..D XLDETDAT
 D XMLEND
 Q
 ;
XCELHDR ;Excel XML Header
 W "<?xml version="_""""_"1.0"_""""_"encoding="_""""_"utf-8"_""""_" ?>",!
 W "<?mso-application progid="_""""_"Excel.Sheet"_""""_" ?>",!
 W "<Workbook xmlns="_""""_"urn:schemas-microsoft-com:office:spreadsheet"_"""",!
 W "          xmlns:o="_""""_"urn:schemas-microsoft-com:office:office"_"""",!
 W "          xmlns:x="_""""_"urn:schemas-microsoft-com:office:excel"_"""",!
 W "          xmlns:html="_""""_"http://www.w3.org/TR/REC-html40"_""""_">",!
 W " <DocumentProperties xmlns="_""""_"urn:schemas-microsoft-com:office:office"_""""_">",!
 W "  <Author>"_$P(^VA(200,DUZ,0),U,1)_"</Author>",!
 W "  <LastAuthor>"_$P(^VA(200,DUZ,0),U,1)_"</LastAuthor>",!
 D NOW^%DTC
 W "  <Created>"_$$XDT^BARDUTL(%)_"</Created>",!
 W "  <LastSaved>"_$$XDT^BARDUTL(%)_"</LastSaved>",!
 W "  <Version>16.00</Version>",!
 W " </DocumentProperties>",!
 W " <OfficeDocumentSettings xmlns="_""""_"urn:schemas-microsoft-com:office:office"_""""_">",!
 W "  <AllowPNG/>",!
 W " </OfficeDocumentSettings>",!
 ;
XMLWRKBK    ;
 W " <ExcelWorkbook xmlns="_""""_"urn:schemas-microsoft-com:office:excel"_""""_">",!
 W "  <WindowHeight>13020</WindowHeight>",!
 W "  <WindowWidth>28800</WindowWidth>",!
 W "  <WindowTopX>0</WindowTopX>",!
 W "  <WindowTopY>0</WindowTopY>",!
 W "  <ProtectStructure>False</ProtectStructure>",!
 W "  <ProtectWindows>False</ProtectWindows>",!
 W " </ExcelWorkbook>",!
 ;
 ;
STYLES ;
 D STYLEBEG^BARXML4
S16 ;
 W "  <Style ss:ID="_""""_"s16"_""""_" ss:Name="_""""_"Currency"_""""_">",!
 W "   <NumberFormat ss:Format="_""""_"_(&quot;$&quot;* #,##0.00_);_(&quot;$&quot;* \(#,##0.00\);_(&quot;$&quot;* &quot;-&quot;??_);_(@_)"_""""_"/>",!
 W "  </Style>",!
 ;
 ;
S17 ;
 W "  <Style ss:ID="_""""_"s17"_""""_">",!
 W "   <Alignment ss:Vertical="_""""_"Center"_""""_"/>",!
 W "   <Font ss:FontName="_""""_"Consolas"_""""_" x:Family="_""""_"Modern"_""""_" ss:Color="_""""_"#000000"_""""_"/>",!
 W "  </Style>",!
 ;
 ;
S18 ;
 W "  <Style ss:ID="_""""_"s18"_""""_">",!
 W "   <NumberFormat ss:Format="_""""_"Short Date"_""""_"/>",!
 W "  </Style>",!
 ;
 ;
S19 ;
 W "  <Style ss:ID="_""""_"s19"_""""_" ss:Parent="_""""_"s16"_""""_">",!
 W "   <Font ss:FontName="_""""_"Calibri"_""""_" x:Family="_""""_"Swiss"_""""_" ss:Size="_""""_"11"_""""_" ss:Color="_""""_"#000000"_""""_"/>",!
 W "  </Style>",!
 ;
 ;
S20 ;
 W "  <Style ss:ID="_""""_"s20"_""""_">",!
 W "   <Alignment ss:Vertical="_""""_"Center"_""""_"/>",!
 W "   <Font ss:FontName="_""""_"Consolas"_""""_" x:Family="_""""_"Modern"_""""_" ss:Color="_""""_"#000000"_""""_" ss:Bold="_""""_"1"_""""_"/>",!
 W "  </Style>",!
 ;
 ;
S21 ;
 W "  <Style ss:ID="_""""_"s21"_""""_">",!
 W "   <Font ss:FontName="_""""_"Calibri"_""""_" x:Family="_""""_"Swiss"_""""_" ss:Size="_""""_"11"_""""_" ss:Color="_""""_"#000000"_""""_" ss:Bold="_""""_"1"_""""_"/>",!
 W "  </Style>",!
 ;
 ;
 W "</Styles>",!
 ;
 ;
XLDETWSB ;COLUMN HEADER
 W "<Worksheet ss:Name="_""""_"Transaction Statistical Report"_""""_">",!
 W " <Table x:FullColumns="_""""_"1"_""""_"  x:FullRows="_""""_"1"_""""_" ss:DefaultRowHeight="_""""_"15"_""""_">",!
 W " <Column ss:Width="_""""_"122.25"_""""_"/>",!
 W " <Column ss:Width="_""""_"66.75"_""""_"/>",!
 W " <Column ss:Width="_""""_"75"_""""_"/>",!
 W " <Column ss:Width="_""""_"50.25"_""""_"/>",!
 W " <Column ss:Width="_""""_"54"_""""_"/>",!
 W " <Column ss:Width="_""""_"121.5"_""""_"/>",!
 W " <Column ss:Width="_""""_"66.75"_""""_"/>",!
 W " <Column ss:Width="_""""_"72"_""""_"/>",!
 W " <Column ss:Width="_""""_"87"_""""_"/>",!
 W " <Row ss:AutoFitHeight="_""""_"0"_""""_">",!
 W "  <Cell ss:StyleID="_""""_"s20"_""""_"><Data ss:Type="_""""_"String"_""""_">LOCATION</Data></Cell>",!
 W "  <Cell ss:StyleID="_""""_"s21"_""""_"><Data ss:Type="_""""_"String"_""""_">VISIT TYPE</Data></Cell>",!
 W "  <Cell ss:StyleID="_""""_"s21"_""""_"><Data ss:Type="_""""_"String"_""""_">CLINIC</Data></Cell>",!
 W "  <Cell ss:StyleID="_""""_"s21"_""""_"><Data ss:Type="_""""_"String"_""""_">BILL NUMBER</Data></Cell>",!
 W "  <Cell ss:StyleID="_""""_"s21"_""""_"><Data ss:Type="_""""_"String"_""""_">DOS</Data></Cell>",!
 W "  <Cell ss:StyleID="_""""_"s21"_""""_"><Data ss:Type="_""""_"String"_""""_">TRANSACTION DATE</Data></Cell>",!
 W "  <Cell ss:StyleID="_""""_"s21"_""""_"><Data ss:Type="_""""_"String"_""""_">INSURER</Data></Cell>",!
 W "  <Cell ss:StyleID="_""""_"s21"_""""_"><Data ss:Type="_""""_"String"_""""_">BILL AMOUNT</Data></Cell>",!
 W "  <Cell ss:StyleID="_""""_"s21"_""""_"><Data ss:Type="_""""_"String"_""""_">TXRN AMOUNT</Data></Cell>",!
 W "  <Cell ss:StyleID="_""""_"s21"_""""_"><Data ss:Type="_""""_"String"_""""_">PRIMARY ROVIDER</Data></Cell>",!
 W " </Row>"
 Q
 ;
 ;
XLDETDAT  ;Write cell data to row
 ;
 W " <Row ss:AutoFitHeight="_""""_"0"_""""_">",!
 W "  <Cell ss:StyleID="_""""_"s17"_""""_"><Data ss:Type="_""""_"String"_""""_">"_CELL(1)_"</Data></Cell>",!  ;LOCATION
 W "  <Cell><Data ss:Type="_""""_"String"_""""_">"_CELL(2)_"</Data></Cell>",!                                 ;VISIT TYPE
 W "  <Cell><Data ss:Type="_""""_"String"_""""_">"_CELL(3)_"</Data></Cell>",!                                 ;CLINIC
 W "  <Cell><Data ss:Type="_""""_"String"_""""_">"_CELL(4)_"</Data></Cell>",!                                 ;BILL NUMBER
 W "  <Cell ss:StyleID="_""""_"s17"_""""_"><Data ss:Type="_""""_"String"_""""_">"_CELL(5)_"</Data></Cell>",!  ;DOS
 W "  <Cell ss:StyleID="_""""_"s17"_""""_"><Data ss:Type="_""""_"String"_""""_">"_CELL(6)_"</Data></Cell>",!  ;TRANSACTION DATE
 W "  <Cell><Data ss:Type="_""""_"String"_""""_">"_CELL(7)_"</Data></Cell>",!                                 ;INSURER
 W "  <Cell ss:StyleID="_""""_"s19"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_CELL(8)_"</Data></Cell>",!  ;BILL AMOUNT
 W "  <Cell ss:StyleID="_""""_"s19"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_CELL(9)_"</Data></Cell>",!  ;TRXN AMOUNT
 W "  <Cell><Data ss:Type="_""""_"String"_""""_">"_CELL(10)_"</Data></Cell>",!                                ;PRIMARY ROVIDER
 W " </Row>"
 Q
 ;
 ;
XMLEND ;Close out report
 W "</Table>",!
 W "<WorksheetOptions xmlns="_""""_"urn:schemas-microsoft-com:office:excel"_""""_">",!
 W "   <PageSetup>",!
 W "    <Header x:Margin="_""""_"0.3"_""""_"/>",!
 W "    <Footer x:Margin="_""""_"0.3"_""""_"/>",!
 W "    <PageMargins x:Bottom="_""""_"0.75"_""""_" x:Left="_""""_"0.25"_""""_" x:Right="_""""_"0.25"_""""_" x:Top="_""""_"0.75"_""""_"/>",!
 W "   </PageSetup>",!
 W "   <FitToPage/>",!
 W "   <Print>",!
 W "   <FitHeight>0</FitHeight>",!
 W "    <ValidPrinterInfo/>",!
 W "    <HorizontalResolution>600</HorizontalResolution>",!
 W "    <VerticalResolution>600</VerticalResolution>",!
 W "   </Print>",!
 W "   <Selected/>",!
 W "   <Panes>",!
 W "    <Pane>",!
 W "     <Number>3</Number>",!
 W "     <ActiveRow>1</ActiveRow>",!
 W "     <ActiveCol>1</ActiveCol>",!
 W "    </Pane>",!
 W "   </Panes>",!
 W "   <ProtectObjects>False</ProtectObjects>",!
 W "   <ProtectScenarios>False</ProtectScenarios>",!
 W "  </WorksheetOptions>",!
 W " </Worksheet>",!
 W "</Workbook>",!
 Q
 ;
