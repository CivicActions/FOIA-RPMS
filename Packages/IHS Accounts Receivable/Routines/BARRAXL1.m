BARRAXL1 ;IHS/SD/CPC - XML UTILITIES ;07/28/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**30**;OCT 26, 2005;Build 55
 ;
 ;UFMS AGE REPORT XML FORMAT
 ;
 ;
 Q
XMLHDR    ;
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
 Q
XMLWRKBK    ;
 W " <ExcelWorkbook xmlns="_""""_"urn:schemas-microsoft-com:office:excel"_""""_">",!
 W "  <WindowHeight>10500</WindowHeight>",!
 W "  <WindowWidth>24150</WindowWidth>",!
 W "  <WindowTopX>0</WindowTopX>",!
 W "  <WindowTopY>0</WindowTopY>",!
 W "  <ProtectStructure>False</ProtectStructure>",!
 W "  <ProtectWindows>False</ProtectWindows>",!
 W " </ExcelWorkbook>",!
 Q
XLDETWSB  ;DETAIL CXL Bills Report banner
 W " <Worksheet ss:Name="_""""_"UFMS Aged"_""""_">",!
 ;W "  <Table ss:ExpandedColumnCount="_""""_"11"_""""_" ss:ExpandedRowCount="_""""_"5"_""""_" x:FullColumns="_""""_"1"_""""
 ;W "   x:FullRows="_""""_"1"_""""_" ss:DefaultRowHeight="_""""_"15"_""""_">",!
 W "   <Table ss:DefaultRowHeight="_""""_"15"_""""_">",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"141"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"135"_""""_"/>",!
 W "   <Column ss:Width="_""""_"120"_""""_"/>",!
 W "   <Column ss:Hidden="_""""_"1"_""""_" ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"135"_""""_"/>",!
 W "   <Column ss:Hidden="_""""_"1"_""""_" ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"138"_""""_"/>",!
 W "   <Column ss:Hidden="_""""_"1"_""""_" ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"116.25"_""""_"/>",!
 W "   <Column ss:Hidden="_""""_"1"_""""_" ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"180"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"135"_""""_" ss:Span="_""""_"1"_""""_"/>",!
 W "   <Column ss:Index="_""""_"10"_""""_" ss:Width="_""""_"75"_""""_"/>",!
 W "   <Column ss:Width="_""""_"69.75"_""""_" ss:Span="_""""_"4"_""""_"/>",!
 W "   <Row ss:AutoFitHeight="_""""_"0"_""""_" ss:Height="_""""_"19.5"_""""_">",!
 W "    <Cell ss:StyleID="_""""_"s102"_""""_"><Data ss:Type="_""""_"String"_""""_">FISCAL YEAR</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s102"_""""_"><Data ss:Type="_""""_"String"_""""_">ALLOWANCE CATEGORY</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s103"_""""_"><Data ss:Type="_""""_"String"_""""_">VISIT LOCATION</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s103"_""""_"><Data ss:Type="_""""_"String"_""""_">VISIT LOCATION ASUFAC</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s103"_""""_"><Data ss:Type="_""""_"String"_""""_">BILLING LOCATION</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s103"_""""_"><Data ss:Type="_""""_"String"_""""_">BILLING LOCATION ASUFAC</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s103"_""""_"><Data ss:Type="_""""_"String"_""""_">3P IEN</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s103"_""""_"><Data ss:Type="_""""_"String"_""""_">UFMS INVOICE NUMBER</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s103"_""""_"><Data ss:Type="_""""_"String"_""""_">A/R ACCOUNT</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s103"_""""_"><Data ss:Type="_""""_"String"_""""_">BILL NUMBER</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s104"_""""_"><Data ss:Type="_""""_"String"_""""_">CURRENT</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s104"_""""_"><Data ss:Type="_""""_"String"_""""_">30-60</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s104"_""""_"><Data ss:Type="_""""_"String"_""""_">61-90</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s104"_""""_"><Data ss:Type="_""""_"String"_""""_">91-120</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s104"_""""_"><Data ss:Type="_""""_"String"_""""_">120+</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s105"_""""_"><Data ss:Type="_""""_"String"_""""_">BALANCE</Data></Cell>",!
 W "   </Row>",!
 Q
XLDETDAT  ;
 W "   <Row>",!
 W "    <Cell ss:StyleID="_""""_"s113"_""""_"><Data ss:Type="_""""_"String"_""""_">"_FY_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s113"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ALLCAT_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s113"_""""_"><Data ss:Type="_""""_"String"_""""_">"_VSTLOC_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s114"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_VSUFAC_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s113"_""""_"><Data ss:Type="_""""_"String"_""""_">"_PFAC_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s114"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_PSUFAC_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s114"_""""_"><Data ss:Type="_""""_"String"_""""_">"_TPIEN_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s113"_""""_"><Data ss:Type="_""""_"String"_""""_">"
 W $P(UFMSINV,"'",2)_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s113"_""""_"><Data ss:Type="_""""_"String"_""""_">"_ARACCT_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s113"_""""_"><Data ss:Type="_""""_"String"_""""_">"_BILLNUM_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s115"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_CURR_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s115"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_THIRTY_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s115"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_SIXTY_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s115"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_NINETY_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s115"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_OVER_"</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s115"_""""_"><Data ss:Type="_""""_"Number"_""""_">"_BAL_"</Data></Cell>",!
 W "   </Row>",!
 Q
XLDETWSE  ;DETAIL CXL Bills Report Worksheet Section End
 W "</Table>",!
 W "<WorksheetOptions xmlns="_""""_"urn:schemas-microsoft-com:office:excel"_""""_">",!
 W "   <PageSetup>",!
 W "    <Layout x:Orientation="_""""_"Landscape"_""""_"/>",!
 W "    <Header x:Margin="_""""_"0.3"_""""_"/>",!
 W "    <Footer x:Margin="_""""_"0.3"_""""_"/>",!
 W "    <PageMargins x:Bottom="_""""_"0.75"_""""_" x:Left="_""""_"0.25"_""""_" x:Right="_""""_"0.25"_""""_" x:Top="_""""_"0.75"_""""_"/>",!
 W "   </PageSetup>",!
 W "   <FitToPage/>",!
 W "   <Print>",!
 W "   <FitHeight>0</FitHeight>",!
 W "    <ValidPrinterInfo/>",!
 ;W "    <Scale>68</Scale>",!
 W "    <HorizontalResolution>1200</HorizontalResolution>",!
 W "    <VerticalResolution>1200</VerticalResolution>",!
 W "   </Print>",!
 W "   <Selected/>",!
 W "   <Panes>",!
 W "    <Pane>",!
 W "     <Number>3</Number>",!
 W "     <ActiveRow>16</ActiveRow>",!
 W "     <ActiveCol>1</ActiveCol>",!
 W "    </Pane>",!
 W "   </Panes>",!
 W "   <ProtectObjects>False</ProtectObjects>",!
 W "   <ProtectScenarios>False</ProtectScenarios>",!
 W "  </WorksheetOptions>",!
 W " </Worksheet>",!
 Q
