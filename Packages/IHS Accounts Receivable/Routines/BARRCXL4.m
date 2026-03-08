BARRCXL4 ;IHS/SD/CPC - XML CANCELLED BILLS REPORT;05/12/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**30**;OCT 26, 2005;Build 55
 ;BAR*1.8*30 - XML parent elements for Cancelled bills report
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
 W "  <WindowHeight>11625</WindowHeight>",!
 W "  <WindowWidth>22200</WindowWidth>",!
 W "  <WindowTopX>0</WindowTopX>",!
 W "  <WindowTopY>0</WindowTopY>",!
 W "  <ActiveSheet>2</ActiveSheet>",!
 W "  <ProtectStructure>False</ProtectStructure>",!
 W "  <ProtectWindows>False</ProtectWindows>",!
 W " </ExcelWorkbook>",!
 Q
XLDETWSB  ;DETAIL CXL Bills Report banner
 W " <Worksheet ss:Name="_""""_"DetailCXL Bills Report"_""""_">",!
 ;W "  <Table ss:ExpandedColumnCount="_""""_"13"_""""_" ss:ExpandedRowCount="_""""_"7"_""""_" x:FullColumns="_""""_"1"_""""
 ;W "   x:FullRows="_""""_"1"_""""_" ss:DefaultRowHeight="_""""_"15"_""""_">",!
 W "   <Table ss:DefaultRowHeight="_""""_"15"_""""_">",!
 W "   <Column ss:Width="_""""_"144.75"_""""_" ss:Span="_""""_"1"_""""_"/>",!
 W "   <Column ss:Index="_""""_"3"_""""_" ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"150.75"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"128.25"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"153.75"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"81.75"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"176.25"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"132.75"_""""_"/>",!
 W "   <Column ss:Width="_""""_"102.75"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"78"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"173.25"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"88.5"_""""_"/>",!
 W "   <Column ss:AutoFitWidth="_""""_"0"_""""_" ss:Width="_""""_"170.25"_""""_"/>",!
 W "   <Column ss:Width="_""""_"72.75"_""""_" ss:Span="_""""_"2"_""""_"/>",!
 W "   <Row ss:AutoFitHeight="_""""_"0"_""""_">",!
 D NOW^%DTC
 S BARXMLHD=%I(1)_"/"_%I(2)_"/"_(%I(3)+1700)
 S BARXMLHD=BARXMLHD_BAR("HD",1)
 I $G(BAR("HD",2))]" " S BARXMLHD=BARXMLHD_BAR("HD",2)
 W "    <Cell ss:MergeAcross="_""""_"12"_""""_" ss:StyleID="_""""_"m333500408"_""""_"><Data ss:Type="_""""_"String"_""""_">DETAIL Cancelled Bills Report as of "_BARXMLHD_"</Data></Cell>",!
 W "   </Row>",!
 W "   <Row>",!
 W "    <Cell ss:MergeAcross="_""""_"12"_""""_" ss:StyleID="_""""_"m333500428"_""""_"><Data ss:Type="_""""_"String"_""""_">WARNING: Confidential Patient Information, Privacy Act Applies</Data></Cell>",!
 W "   </Row>",!
 W "   <Row>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Cancelling Official</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Visit Location</Data></Cell>",!
 ;S BARXMLHD=$S($G(BARY("SORT"))="V":"Visit Type",1:"Clinic")
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Visit Type</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Clinic</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Patient</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">HRN</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Active Insurer</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Claim Number</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Visit Date</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Reason Number</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s76"_""""_"><Data ss:Type="_""""_"String"_""""_">Reason</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s77"_""""_"><Data ss:Type="_""""_"String"_""""_">Amount Billed</Data></Cell>",!
 W "    <Cell ss:StyleID="_""""_"s77"_""""_"><Data ss:Type="_""""_"String"_""""_">Balance in A/R</Data></Cell>",!
 W "   </Row>"
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
 W "    <Scale>68</Scale>",!
 W "    <HorizontalResolution>600</HorizontalResolution>",!
 W "    <VerticalResolution>600</VerticalResolution>",!
 W "   </Print>",!
 W "   <Selected/>",!
 W "   <Panes>",!
 W "    <Pane>",!
 W "     <Number>3</Number>",!
 W "     <ActiveRow>18</ActiveRow>",!
 W "     <ActiveCol>8</ActiveCol>",!
 W "    </Pane>",!
 W "   </Panes>",!
 W "   <ProtectObjects>False</ProtectObjects>",!
 W "   <ProtectScenarios>False</ProtectScenarios>",!
 W "  </WorksheetOptions>",!
 W " </Worksheet>",!
 Q
XLSUMWSB  ;SUMMARY CXL BILLS Report Worksheet Section Begin
 W "   <Worksheet ss:Name="_""""_"SummaryCXL Bills RPT"_""""_">",!
 ;W "   <Table ss:ExpandedColumnCount="_""""_"7"_""""_" ss:ExpandedRowCount="_""""_"31"_""""_" x:FullColumns="_""""_"1"_"""",!
 ;W "    x:FullRows="_""""_"1"_""""_" ss:DefaultRowHeight="_""""_"15"_""""_">",!
 W "    <Table ss:DefaultRowHeight="_""""_"15"_""""_">",!
 W "    <Column ss:Width="_""""_"98.25"_""""_" ss:Span="_""""_"2"_""""_"/>",!
 W "    <Column ss:Index="_""""_"5"_""""_" ss:Width="_""""_"55.5"_""""_"/>",!
 W "    <Row>",!
 D NOW^%DTC
 S BARXMLHD1=%I(1)_"/"_%I(2)_"/"_(%I(3)+1700)
 S BARXMLHD2=BAR("HD",1)
 I $G(BAR("HD",2))]" " S BARXMLHD2=BARXMLHD2_BAR("HD",2)
 W "     <Cell ss:MergeAcross="_""""_"6"_""""_" ss:StyleID="_""""_"s87"_""""_"><Data ss:Type="_""""_"String"_""""_">Summary Cancelled Bills Report as of "_BARXMLHD1_"</Data></Cell>",!
 W "    </Row>",!
 W "    <Row ss:Height="_""""_"15.75"_""""_">",!
 W "     <Cell ss:MergeAcross="_""""_"6"_""""_" ss:StyleID="_""""_"s87"_""""_"><Data ss:Type="_""""_"String"_""""_"> "_BARXMLHD2_"</Data></Cell>",!
 W "    </Row>",!
 W "    <Row>",!
 W "     <Cell ss:MergeAcross="_""""_"4"_""""_" ss:StyleID="_""""_"m333503776"_""""_"><Data ss:Type="_""""_"String"_""""_">Cancelling Official</Data></Cell>",!
 W "     <Cell ss:StyleID="_""""_"s95"_""""_"><Data ss:Type="_""""_"String"_""""_">Count</Data></Cell>",!
 W "     <Cell ss:StyleID="_""""_"s96"_""""_"><Data ss:Type="_""""_"String"_""""_">Total</Data></Cell>",!
 W "    </Row>",!
 W "    <Row>",!
 W "     <Cell ss:MergeAcross="_""""_"2"_""""_" ss:StyleID="_""""_"m333503796"_""""_"><Data ss:Type="_""""_"String"_""""_">Visit Location</Data></Cell>",!
 W "     <Cell ss:StyleID="_""""_"s104"_""""_"><Data ss:Type="_""""_"String"_""""_">Count</Data></Cell>",!
 W "     <Cell ss:StyleID="_""""_"s104"_""""_"><Data ss:Type="_""""_"String"_""""_">Total</Data></Cell>",!
 W "     <Cell ss:StyleID="_""""_"s105"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s106"_""""_"/>",!
 W "    </Row>",!
 W "    <Row ss:Height="_""""_"15.75"_""""_">",!
 S BARXMLHD=$S($G(BARY("SORT"))="V":"Visit Type",1:"Clinic")
 W "     <Cell ss:StyleID="_""""_"s107"_""""_"><Data ss:Type="_""""_"String"_""""_">"_BARXMLHD_"</Data></Cell>",!
 W "     <Cell ss:StyleID="_""""_"s108"_""""_"><Data ss:Type="_""""_"String"_""""_">Count</Data></Cell>",!
 W "     <Cell ss:StyleID="_""""_"s108"_""""_"><Data ss:Type="_""""_"String"_""""_">Total</Data></Cell>",!
 W "     <Cell ss:StyleID="_""""_"s109"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s109"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s109"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s110"_""""_"/>",!
 W "    </Row>",!
 W "    <Row ss:Height="_""""_"15.75"_""""_">",!
 W "     <Cell ss:StyleID="_""""_"s111"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s112"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s112"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s113"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s113"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s113"_""""_"/>",!
 W "     <Cell ss:StyleID="_""""_"s113"_""""_"/>",!
 W "    </Row>",!
 Q
XLSUMWSE  ;
 W "   </Table>",!
 W "   <WorksheetOptions xmlns="_""""_"urn:schemas-microsoft-com:office:excel"_""""_">",!
 W "    <PageSetup>",!
 W "     <Header x:Margin="_""""_"0.3"_""""_"/>",!
 W "     <Footer x:Margin="_""""_"0.3"_""""_"/>",!
 W "     <PageMargins x:Bottom="_""""_"0.75"_""""_" x:Left="_""""_"0.25"_""""_" x:Right="_""""_"0.25"_""""_" x:Top="_""""_"0.75"_""""_"/>",!
 W "    </PageSetup>",!
 W "    <FitToPage/>",!
 W "    <Print>",!
 W "     <FitHeight>0</FitHeight>",!
 W "     <ValidPrinterInfo/>",!
 W "     <HorizontalResolution>600</HorizontalResolution>",!
 W "     <VerticalResolution>600</VerticalResolution>",!
 W "    </Print>",!
 W "    <Panes>",!
 W "     <Pane>",!
 W "      <Number>3</Number>",!
 W "      <ActiveRow>19</ActiveRow>",!
 W "      <ActiveCol>1</ActiveCol>",!
 W "     </Pane>",!
 W "    </Panes>",!
 W "    <ProtectObjects>False</ProtectObjects>",!
 W "    <ProtectScenarios>False</ProtectScenarios>",!
 W "   </WorksheetOptions>",!
 W "  </Worksheet>",!
 Q
