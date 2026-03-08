BIVWPAR ;IHS/CMI/MWR - EXTRACT DATA FROM ICE OUTPUT XML; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**18,26**;OCT 24,2011;Build 33
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXTRACT DATA FROM ICE OUTPUT XML
 ;;  PATCH 18: New routine to parse data from ICE Output XML.
 ;;  PATCH 26: Get Supplemental Text from XML output
 ;
 ;
 ;----------
PARSE(BIOXML,BIH,BIF,BIXMLV,BIERR) ;EP
 ;---> Update Patient Imms Due (in ^BIPDUE) using Immserve Utility.
 ;---> Parameters:
 ;     1 - BIOXML (req) Output XML from ICE.
 ;     1 - BIH    (ret) Patient Imm History Evaluation array from ICE.
 ;     2 - BIF    (ret) Patient Imm Forecast array from ICE.
 ;     3 - BIXMLV (ret) ICE Version Number.
 ;     4 - BIERR  (ret) Error Number.
 ;
 ;---> BIXML is the full ICE Output XML.
 ;---> BIXMLH is the returned ICE History
 ;---> BIXMLF is the returned ICE Forecast.
 ;---> May need to parse these nodes earlier if too large.
 ;
 ;N BIXML,BIXMLH,BIXMLF
 ;S BIXML=""
 ;N I S I=0
 ;F  S I=$O(^TMP("BIICE",$J,"RETURNXML",I)) Q:'I  D
 ;.S BIXML=BIXML_^TMP("BIICE",$J,"RETURNXML",I)
 ;
 N BISUPP
 N BIXML,BIXMLH,BIXMLF S BIXML=""
 N I S I=0
 F  S I=$O(BIOXML(I)) Q:'I  D
 .S BIXML=BIXML_BIOXML(I)
 ;
 S BIXMLH=$P(BIXML,"<substanceAdministrationProposals>",1)
 S BIXMLF=$P(BIXML,"<substanceAdministrationProposals>",2)
 K BIXML
 ;
 ;---> Get ICE Version#.
 S BIXMLV=$P(BIXMLF,"<dataSourceType code=""ICE_",2),BIXMLV=$P(BIXMLV,""" codeSystem",1)
 ;W !,BIXMLV R ZZZ
 ;
 ;---> Remember $L give #occurences of a string, plus 1!
 ;
 ; * * * HISTORY * * * -----------------------------------------
 ;
 ;---> Extract History.
 ;W !!,"HISTORY"
 ;
 N BICOUNT,V
 ;---> Delimiter to parse historical immunizations.
 S V="</substanceAdministrationEvent><substanceAdministrationEvent>"
 ;
 S BICOUNT=$L(BIXMLH,V)
 ;W !," Total Historical Imms: ",BICOUNT
 ;
 ;---> K is the subcript increment for BIH( history array.
 N K S K=0
 F I=1:1:BICOUNT D
 .N BICCVX,BICVX,BICOMPS,BIDATE,BIIMM,BINOD,BITAGS,BIVALID,BIREASON
 .;
 .;---> BIIMM encompasses first level of "substanceAdministrationEvent>" for each immunization.
 .S BIIMM=$P(BIXMLH,V,I)
 .;
 .S BICCVX=$P($P(BIIMM,"<substanceCode code=""",2),""" ")
 .;
 .S BITAGS=$L(BIIMM,"relatedClinicalStatement")-1
 .S BICOMPS=(BITAGS/4)
 .;W !!!,"COMBO CVX: ",BICCVX," ",$$HL7TX^BIUTL2(+BICCVX,2)
 .;W !,"COMPONENTS: ",BICOMPS
 .S K=K+1,BIH(K,0)=BICCVX
 .;
 .N L S L=0
 .F J=2:4:BITAGS D
 ..;---> BINOD encompasses first level of "relatedClinicalStatement" for each dose or component.
 ..S BINOD=$P(BIIMM,"relatedClinicalStatement",J,J+1)
 ..;
 ..S BICVX=$P($P(BINOD,"<substanceCode code=""",2),""" ")
 ..S L=L+1,BIH(K,L)=BICVX
 ..;W !,"CVX: ",BICVX," ",$$HL7TX^BIUTL2(+BICVX,2)
 ..;
 ..S BIDATE=$E($P($P(BINOD,"<administrationTimeInterval high=""",2),""" "),1,8)
 ..S:BIDATE="" BIDATE=$E($P($P(BINOD,"<administrationTimeInterval low=""",2),""" "),1,8)
 ..S:BIDATE="" BIDATE=19000101
 ..S BIH(K,L)=BIH(K,L)_U_BIDATE
 ..;W "  DATE: ",$$SLDT2^BIUTL5($$TCHFMDT^BIUTL5(BIDATE))
 ..;
 ..S BIVALID=$P($P(BINOD,"<concept code=""",2),""" ")
 ..S BIH(K,L)=BIH(K,L)_U_BIVALID
 ..;20230130 76219 maw added for supplemental text
 ..S BISUPP=$P($P(BINOD,"<interpretation code=""",2),""" ")
 ..I $G(BISUPP)="SUPPLEMENTAL_TEXT" D  ;20230120 p26 maw lets get the supplemental text for this
 .. N BISUPPT
 .. S BISUPPT=$P($P($P(BINOD,"originalText=""",2),""" "),"/></")
 .. S BISUPPT=$TR(BISUPPT,"""","")
 .. S BIH(K,L,"SUPP")=$G(BISUPPT)
 ..;20230130 maw end of mods
 ..;W "  VALID: ",BIVALID
 ..;
 ..I BIVALID'="VALID" D
 ...S BIREASON=$P($P(BINOD,"Evaluation Reason"" displayName=""",2),"""")
 ...;20230130 76219 maw added for supplemental text
 ...S BISUPP=$P($P(BINOD,"<interpretation code=""",2),""" ")
 ...I $G(BISUPP)="SUPPLEMENTAL_TEXT" D  ;20230120 p26 maw lets get the supplemental text for this
 ... N BISUPPT
 ... S BISUPPT=$P($P($P(BINOD,"originalText=""",2),""" "),"/></")
 ... S BISUPPT=$TR(BISUPPT,"""","")
 ... S BIH(K,L,"SUPP")=$G(BISUPPT)
 ...;20230130 maw end of mods
 ...S BIH(K,L)=BIH(K,L)_U_BIREASON
 ;
 ;
 ; * * * FORECAST * * * -----------------------------------------
 ;
 ;---> Extract Forecast.
 ;
 N BITAGS
 ;---> Delimiter to parse forecast immunizations.
 S BITAGS=$L(BIXMLF,"substanceAdministrationProposal>")-1
 S BICOUNT=(BITAGS/2)
 ;W !!!,"FORECAST",!!,BITAGS," Total Forecast Imms: ",BICOUNT
 ;
 ;---> K is the subcript increment for BIF( forecast array.
 N I,K S K=0
 ;
 F I=1:2:BITAGS D
 .N BICCVX,BICODE,BICODTX,BIDATE,BINOD,BIREASON,BISTATUS,BISUBLN,BITYPE
 .;
 .;---> BINOD encompasses first level of "substanceAdministrationProposal>" for each recommended volume group.
 .S BINOD=$P(BIXMLF,"substanceAdministrationProposal>",I,I+1)
 .;
 .S BISUBLN=$P($P(BINOD,"<substanceCode code=""",2),"/>")
 .S BICODE=$P(BISUBLN,"""",1)
 .;---> Interpret the forecast code based on the codeSystem.
 .D
 ..;W !!
 ..S BITYPE=0
 ..I BISUBLN["2.16.840.1.113883.3.795.12.100.1" D  Q
 ...S BICODTX=$$HL7TX^BIUTL2($$VMRVG^BIUTL2(+BICODE),2) ;W "VMR"
 ..I BISUBLN["2.16.840.1.113883.12.292" D  Q
 ...S BITYPE=1 S BICODTX=$$HL7TX^BIUTL2((+BICODE),2) ;W "CVX"
 ..S BICODTX="UNKNOWN"
 .;W !!," CODE: ",BICODE," ",BICODTX
 .S K=K+1,BIF(K)=BICODE_U_BITYPE
 .;
 .S BIDATE=$E($P($P(BINOD,"<validAdministrationTimeInterval low=""",2),""" "),1,8)
 .;W !,"EARLIEST DATE: ",$$SLDT2^BIUTL5($$TCHFMDT^BIUTL5(BIDATE))
 .S BIF(K)=BIF(K)_U_BIDATE
 .;
 .S BIDATES=$P($P(BINOD,"<proposedAdministrationTimeInterval",2),"/>")
 .S BIDATE=$E($P($P(BIDATES,"low=""",2),""" "),1,8)
 .;W !,"REC DATE: ",$$SLDT2^BIUTL5($$TCHFMDT^BIUTL5(BIDATE))
 .S BIF(K)=BIF(K)_U_BIDATE
 .;
 .S BIDATE=$E($P($P(BIDATES,"high=""",2),""""),1,8)
 .;W !,"PAST DUE DATE: ",$$SLDT2^BIUTL5($$TCHFMDT^BIUTL5(BIDATE))
 .S BIF(K)=BIF(K)_U_BIDATE
 .;
 .S BISTATUS=$P($P(BINOD,"<concept code=""",2),""" ")
 .;S BISTATUS=$P($P($P(BINOD,"<concept code=""",2),"""/>"),"displayName=""",2)
 .;W !,"STATUS: ",BISTATUS
 .S BIF(K)=BIF(K)_U_BISTATUS
 .;20230209 76219 maw added for HIGH RISK
 .S BIREASON=$P($P(BINOD,"<interpretation code=""",2),""" ")
 .;W !,$g(BICODE)_U_$G(BIREASON)
 .;S BIREASON=$P($P($P(BINOD,"<interpretation code=""",2),")""/>"),"(",2)
 .;W !,"REASON: ",BIREASON
 .S BIF(K)=BIF(K)_U_BIREASON
 . ;20230209 76219 maw added for supplemental text
 . ;I $G(BISTATUS)="CONDITIONAL",$G(BIREASON)="HIGH_RISK" D
 .;.;S BISUPP=$P($P(BINOD,"<interpretation code=""",2),""" ")
 .S BISUPP=$P($P(BINOD,"<interpretation code=""",2),""" ")
 .I $G(BISUPP)="SUPPLEMENTAL_TEXT" D  ;20230209 p26 maw lets get the supplemental text for this
 . N BISUPPT
 . S BISUPPT=$P($P($P(BINOD,"originalText=""",2),""" "),"/></")
 . S BISUPPT=$TR(BISUPPT,"""","")
 . S BIF(K,"SUPP")=$G(BISUPPT)
 .;20230130 maw end of mods
 ;D ^%ZTER  ;20220109 maw capture data being returned
 ;W ! r zzz
 ;
 Q
 ;
SPLICE ;---> NOT USED FOR NOW.
 ;---> Carving up 4k nodes and splicing together any tags or elements broken between nodes.
 S BINODE1=^TMP("BIICE",$J,"RETURNXML",1)
 S BINODE2=^TMP("BIICE",$J,"RETURNXML",2)
 S BINODE3=^TMP("BIICE",$J,"RETURNXML",3)
 S BIEVENTS=$P(BINODE1,"<substanceAdministrationEvents>",2)
 ;
 S BITL1=$L(BINODE1),BIL=BITL1+1
 F  S BIL=BIL-1 I $E(BINODE1,BIL)=">" Q
 W !,BIL
 S BIFTAG=BIL+1,BIFRAG1=$E(BINODE1,BIFTAG,BITL1)
 W !,BIFRAG1
 ;
 S BIL=0
 F  S BIL=BIL+1 I $E(BINODE2,BIL)=">" Q
 W !,BIL
 S BIFRAG2=$E(BINODE2,1,BIL)
 W !,BIFRAG2
 W !!,"Spliced: ",BIFRAG1_BIFRAG2,!
 ;
 Q
 ;
 ;
OLD ;
 ;*** NOT USED ***
 ;---> Old code to extract all historical imms individually without tracking
 ;---> how they were administered as combinations.
 ;---> Extract History.
 S BITAGS=$L(BIXMLH,"relatedClinicalStatement")-1
 S BICOUNT=(BITAGS/4)
 W !!,"HISTORY",!!,BITAGS," Total Historical Imms: ",BICOUNT
 S BIH(0)=BICOUNT
 ;
 ;---> Each node in BIH(X)=CVX^Admin Date^Valid Code^Eval Reason
 N I,J S J=0
 F I=2:4:BITAGS D
 .;---> BINOD encompasses first level of "relatedClinicalStatement" for each dose or component.
 .S BINOD=$P(BIXMLH,"relatedClinicalStatement",I,I+1)
 .;
 .S BICVX=$P($P(BINOD,"<substanceCode code=""",2),""" ")
 .S J=J+1,BIH(J)=BICVX
 .W !!,"CVX: ",BICVX," ",$$HL7TX^BIUTL2(+BICVX,2)
 .;
 .S BIDATE=$E($P($P(BINOD,"<administrationTimeInterval low=""",2),""" "),1,8)
 .S BIH(J)=BIH(J)_U_BIDATE
 .W !,"DATE: ",$$SLDT2^BIUTL5($$TCHFMDT^BIUTL5(BIDATE))
 .;
 .S BIVALID=$P($P(BINOD,"<concept code=""",2),""" ")
 .S BIH(J)=BIH(J)_U_BIVALID
 .W !,"VALID: ",BIVALID
 .;
 .I BIVALID'="VALID" D
 ..S BIREASON=$P($P(BINOD,"Evaluation Reason"" displayName=""",2),"""")
 ..S BIH(J)=BIH(J)_U_BIREASON
 ..W !,"REASON: ",BIREASON
