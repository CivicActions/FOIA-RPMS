PSBOSF1 ;BIRMINGHAM/EFC-UNABLE TO SCAN DETAIL REPORT - CONTINUATION;23-Mar-2023 14:49;DU
 ;;3.0;BAR CODE MED ADMIN;**1033**;Mar 2004;Build 34
 ;
 ; New Routine split from PSBOSF   IHS/MSC/MIR - 03/23/23
 ;
BLDRPT ; Compile the report.
 K PSBOUTP S PSBPGNUM="",PSBX3="" D CREATHDR^PSBOSF
 S PSBPGNUM=1,PSBTOT1=0
 I '$D(^XUSEC("PSB UNABLE TO SCAN",DUZ)) D  Q
 .S PSBOUTP(0,14)="W !!,""<<<< BCMA UNABLE TO SCAN REPORTS HAVE RESTRICTED ACCESS >>>>"",!!"
 I '$D(PSBSFHD1) D  Q
 .S PSBOUTP(0,14)="W !!,""<<<< Print format NOT SUPPORTED.  80&132 col formats ARE supported. >>>>"",!!"
 I '$D(PSBLIST) D  Q
 .S PSBOUTP(0,14)="W !!,""<<<< NO DOCUMENTED BCMA UNABLE TO SCAN EVENTS FOR THIS DATE RANGE >>>>"",!!"
 ;
 ; Extract the data for the list of records.
 F  S PSBX3=$O(PSBLIST(PSBX3))  Q:+PSBX3=0  K PSBDATA D
 .;
 .; Patient's Name (VAID)
 .I $P(^PSB(53.77,PSBX3,0),U,2)]"" D
 ..N DFN,VA,VADM S DFN=$P(^PSB(53.77,PSBX3,0),U,2)
 ..D DEM^VADPT,PID^VADPT
 ..;IHS/MSC/PLS - DISPLAY FULL HRN KCF VAOIT-CPS 2-2013
 ..;S PSBDATA(1)=VADM(1),PSBDATA(1,0)="("_$E(VA("PID"),$L(VA("PID"))-3,999)_")"
 ..S PSBDATA(1)=VADM(1),PSBDATA(1,0)="("_$S(DUZ("AG")="I":(VA("PID")),1:$E(VA("PID"),$L(VA("PID"))-3,999))_")"
 .;
 .; Scan Failure Date/Time
 .S PSBINDAT=$$GET1^DIQ(53.77,PSBX3_",",.04,"I"),Y=PSBINDAT D DD^%DT
 .S PSBDATA(2)=$TR($P(Y,"@")," "),PSBDATA(2,0)="@"_$P(Y,"@",2)
 .;
 .; UTS Location
 .S PSBDATA(3)=$P($$GET1^DIQ(53.77,PSBX3_",",.03),"$"),PSBDATA(3,0)="/"_($P($$GET1^DIQ(53.77,PSBX3_",",.03),"$",2))
 .;
 .; UTS Type - Get the parameter from File #53.69, compare it to the value below,and quit if not compatible.
 .S PSBDATA(4)=$S($E($P($$GET1^DIQ(53.77,PSBX3_",",.05)," "),1)="M":"MED",$E($P($$GET1^DIQ(53.77,PSBX3_",",.05)," "),1)="W":"WRIST")
 .I $P($G(PSBRPT(3)),",",1)=1&(PSBDATA(4)="WRIST") Q
 .I $P($G(PSBRPT(3)),",",1)=2&(PSBDATA(4)="MED") Q
 .;
 .; Drug (IEN)
 .S (PSBDATA(5),PSBDATA(5,0))=""
 .F PSBI=2,3,4 I $D(^PSB(53.77,PSBX3,PSBI,1,0)) S PSBDATA(5,0)="("_$P(^PSB(53.77,PSBX3,PSBI,1,0),U)_")",PSBDATA(5)=$P(^PSB(53.77,PSBX3,PSBI,1,0),U,2) Q
 .I $$GET1^DIQ(53.77,PSBX3_",",13)["WS" S PSBDATA(4,0)="(WS)",PSBDATA(5,0)="("_$$GET1^DIQ(53.77,PSBX3_",",13)_")",PSBDATA(5)=$P(^PSB(53.77,PSBX3,5),U,2)
 .I $$GET1^DIQ(53.77,PSBX3_",",13)]"",$$GET1^DIQ(53.77,PSBX3_",",13)'["WS" D
 ..S PSBDATA(4,0)="(UID)",PSBDATA(5,0)="("_$$GET1^DIQ(53.77,PSBX3_",",13)_")",PSBDATA(5)=$$GET1^DIQ(53.77,PSBX3_",",15)
 .S:PSBDATA(5)="" PSBDATA(5)=" " S:PSBDATA(5,0)="" PSBDATA(5.0)=" "
 .;
 .; User Name
 .S PSBDATA(6)=$$GET1^DIQ(53.77,PSBX3_",",.01)
 .;
 .; UTS Reason - Get the parameter from File #53.69. Quit if defined and '= reason.
 .S PSBDATA(7)=$$GET1^DIQ(53.77,PSBX3_",",.06)
 .I $P($G(PSBRPT(3)),",",2)=1&(PSBDATA(7)'="Damaged Medication Label") Q
 .I $P($G(PSBRPT(3)),",",2)=2&(PSBDATA(7)'="Damaged Wristband") Q
 .I $P($G(PSBRPT(3)),",",2)=3&(PSBDATA(7)'="No Bar Code") Q
 .I $P($G(PSBRPT(3)),",",2)=4&(PSBDATA(7)'="Scanning Equipment Failure") Q
 .I $P($G(PSBRPT(3)),",",2)=5&(PSBDATA(7)'="Unable to Determine") Q
 .I $P($G(PSBRPT(3)),",",2)=6&(PSBDATA(7)'="Dose Discrepancy") Q
 .;
 .; Create sort subscripts.
 .S (PSBDATA(0),PSBIEN)=PSBX3
 .;
SORT .; Sort the line.
 .; Sort Option internal values:
 .;    1=PATIENT'S NAME
 .;    2=DATE/TIME OF SCAN FAILURE (ascending)
 .;    3=LOCATION WARD/RmBd
 .;    4=TYPE
 .;    5=DRUG
 .;    6=USER'S NAME
 .;    7=UNABLE TO SCAN REASON
 .;   -2=DATE/TIME OF SCAN FAILURE (descending)
 .;
 .; Count how many sort options were selected.
 .F X=0:1:2 Q:$P(PSBSRTBY,",",X+1)=""  S PSBSRTNM=X+1
 .;
 .; Add current line to sort file using the sort option data as the
 .; record's file subscripts. Convert commas in the data to a $ in
 .; case the data (PSBX2) is one of the sort keys.
 .S (PSBX1,PSBX2)="",PSBMRG="^XTMP(""PSBO"",$J,""PSBLIST"""
 .F X=1:1:PSBSRTNM S PSBX1=$P(PSBSRTBY,",",X) Q:PSBX1=""  S PSBDSCN="" D
 ..I PSBX1=2!(PSBX1=-2) S:PSBX1=-2 PSBDSCN="-" S PSBX2=PSBINDAT D
 ...I PSBSRTNM>1,X=1!(X=2) S PSBX2=$P(PSBINDAT,".")
 ...S PSBX2=PSBDSCN_PSBX2
 ..I PSBX1'=2&(PSBX1'=-2) S PSBX2=PSBDATA(PSBX1),PSBX2=$TR(PSBX2,",","$")
 ..S PSBMRG=PSBMRG_","_""""_PSBX2_""""
 .S PSBMRG=PSBMRG_","_PSBIEN_")" M @PSBMRG=PSBDATA
 .S PSBTOT=PSBTOT+1 I +PSBTOT=0 K PSBLIST,^XTMP("PSBO",$J,"PSBLIST")
 ; Retrieve the sorted records.
 ; Set sort file root.
 S PSBMRG="^XTMP(""PSBO"",$J,""PSBLIST"")"
 ; Work through the sort file zero node for each scan event and load the data into
 ; the local array PSBDATA.
 F  S PSBMRG=$Q(@PSBMRG) Q:PSBMRG=""!($P(PSBMRG,",")'["PSBO")!($P(PSBMRG,",",2)'=$J)  D
 .K PSBRPLN,PSBCMNT1,PSBCMNT2,PSBCMNT3 S PSBX1=$P(PSBMRG,",",PSBSRTNM+4)
 .;
 .; Get comment. Skip the comment parsing if no comment.
 .S PSBSFCMT=$G(^PSB(53.77,PSBX1,1)),PSBCMNTX="COMMENT: "_PSBSFCMT,PSBNDENT=" "
 .S $E(PSBCMNT0,PSBTAB7)="|"
 .I PSBCMNTX="COMMENT: " S PSBCMNT1=PSBCMNTX G CONSTR
 .;
 .; Replace any quotes in comment.
 .I $F(PSBCMNTX,"""")>0 S PSBCMNTX=$TR(PSBCMNTX,"""","'")
 .;
 .; # of lines needed to parse comment.
 .S PSBCMTLN=$L(PSBCMNTX)\PSBTAB7+($L(PSBCMNTX)#PSBTAB7>0)
 .;
 .; Parse and wrap the comment by space character. Treat consecutive spaces
 .; as one space. Treat a "!~" sequence as a forced CRLF token from GUI.
 .; PSBTAB7 is the report width based on the user's device.
 .; If "!~" CRLF token sent by GUI, separate the system comment from the user comment.
 .S PSBX=$F(PSBCMNTX,"!~"),PSBCRLF=0 I PSBX>0 S PSBCRLF=1 D
 ..S PSBCMNT1=$E(PSBCMNTX,1,PSBX-3),PSBCMNTX=$E(PSBCMNTX,PSBX,999)
 .;
 .; Wrap the system comment if needed.
 .I PSBCRLF=1,$L(PSBCMNT1)>PSBTAB7 D
 ..S PSBCMNT2=PSBNDENT
 ..F PSBI=1:1:$L(PSBCMNT1," ") I $L($P(PSBCMNT1," ",1,PSBI))>PSBTAB7 D  Q
 ...S PSBCMNT2=PSBCMNT2_$P(PSBCMNT1," ",PSBI,999)
 ...S PSBCMNT1=$P(PSBCMNT1," ",1,PSBI-1)
 ..S PSBCRLF=2
 .;
 .; If no space character in user comment, insert a space in the comment
 .; based on line length in PSBTAB7.
 .I $E(PSBCMNTX,10,999)'[" " S PSBCMNTX=$E(PSBCMNTX,1,PSBTAB7-15)_" "_$E(PSBCMNTX,PSBTAB7-14,999)
 .;
 .; Wrap the comment into multiple lines if needed.
 .S PSBLNO=1+PSBCRLF F PSBI=1:1:$L(PSBCMNTX," ") D
 ..I PSBCRLF,PSBLNO>1,$G(@("PSBCMNT"_PSBLNO))="" S @("PSBCMNT"_PSBLNO)=PSBNDENT
 ..S PSBX=$P(PSBCMNTX," ",PSBI) Q:PSBX=""  ; Don't wrap for contiguous spaces.
 ..D
 ...I $L($G(@("PSBCMNT"_PSBLNO)))+$L(PSBX)'>PSBTAB7 S @("PSBCMNT"_PSBLNO)=$G(@("PSBCMNT"_PSBLNO))_PSBX_" " Q
 ...S PSBLNO=PSBLNO+1,@("PSBCMNT"_PSBLNO)=PSBNDENT_PSBX_" "
 .;
CONSTR .; Construct output from UTS event record.
 .S PSBTOT1=PSBTOT1+1,PSBTOTX=PSBBLANK,$E(PSBTOTX,0,$L(PSBTOT1_".")-1)=PSBTOT1_"."
 .S PSBXORX=$$GET1^DIQ(53.77,PSBX1_",",.08)
 .I PSBXORX]"" S PSBXORX="ORD#: "_PSBXORX,$E(PSBTOTX,PSBTAB4+2,PSBTAB4+2+($L(PSBXORX)-1))=PSBXORX
 .K PSBDATA M PSBDATA=@($P(PSBMRG,",",1,PSBSRTNM+4)_")")
 .D BUILDLN
 .S PSBOUTP($$PGTOT,PSBLNTOT)="W """_PSBTOTX_""""
 .F I=1:1:10 Q:'$D(PSBRPLN(I))  D
 ..F J=1:1:7 S $E(PSBRPLN(I),@("PSBTAB"_J))="|"
 ..S PSBOUTP($$PGTOT,PSBLNTOT)="W !,"""_PSBRPLN(I)_""""
 .S $E(PSBCMNT1,PSBTAB7)="|"
 .I $D(PSBCMNT2) S $E(PSBCMNT2,PSBTAB7)="|"
 .I $D(PSBCMNT3) S $E(PSBCMNT3,PSBTAB7)="|"
 .S PSBOUTP($$PGTOT,PSBLNTOT)="W !,"""_PSBCMNT0_""""
 .S PSBOUTP($$PGTOT,PSBLNTOT)="W !,"""_PSBCMNT1_""""
 .I $D(PSBCMNT2) S PSBOUTP($$PGTOT,PSBLNTOT)="W !,"""_PSBCMNT2_""""
 .I $D(PSBCMNT3) S PSBOUTP($$PGTOT,PSBLNTOT)="W !,"""_PSBCMNT3_""""
 .S PSBOUTP($$PGTOT(2),PSBLNTOT)="W !,$TR($J("""",PSBTAB7),"" "",""-""),!"
 .;
 .; Force a skip to the next record's zero node.
 .S $P(PSBMRG,",",PSBSRTNM+5)="999999)"
 ;
 K PSBRPLN,PSBCMNT1,PSBCMNT2,PSBCMNT3
 Q
 ;
BUILDLN ; Construct records
 K LN,J F PSBFLD=1:1:7 D FORMDAT(PSBFLD) S LN(J)="" K J
 Q
 ;
FORMDAT(FLD) ; Format the data.
 S J=3,PSBVAL=PSBDATA(FLD),PSBVAL(0)="" I $D(PSBDATA(FLD,0)) S PSBVAL(0)=PSBDATA(FLD,0)
 I IOM'>90 S XX=@("PSBTAB"_(FLD-1))+1,YY=(@("PSBTAB"_FLD)-1)-XX,ZZ=PSBVAL_" "_PSBVAL(0) D  Q
 .S O=$$WRAPPER(XX,YY,ZZ)
 I ($L(PSBVAL)+(@("PSBTAB"_(FLD-1))))<(@("PSBTAB"_FLD)-1) D  Q
 .F PSBI=$L(PSBVAL)+(@("PSBTAB"_(FLD-1))):1:(@("PSBTAB"_FLD)-3) S PSBVAL=PSBVAL_" "
 .S $E(PSBRPLN(1),@("PSBTAB"_(FLD-1))+2,(@("PSBTAB"_FLD)-1))=PSBVAL
 .F PSBI=$L(PSBVAL(0))+(@("PSBTAB"_(FLD-1))):1:(@("PSBTAB"_FLD)-3) S PSBVAL(0)=PSBVAL(0)_" "
 .S $E(PSBRPLN(2),@("PSBTAB"_(FLD-1))+2,(@("PSBTAB"_FLD)-1))=PSBVAL(0)
 I ($L(PSBVAL)+(@("PSBTAB"_(FLD-1))))'<(@("PSBTAB"_FLD)-1) D  Q
 .I $F(PSBVAL,",")>1 S PSBVAL1=$E(PSBVAL,1,$F(PSBVAL,",")-1),PSBVAL2=$E(PSBVAL,$F(PSBVAL,","),999)
 .E  S PSBVAL1=$E(PSBVAL,1,$F(PSBVAL," ")-1),PSBVAL2=$E(PSBVAL,$F(PSBVAL," "),999)
 .F PSBI=$L(PSBVAL1)+(@("PSBTAB"_(FLD-1))):1:(@("PSBTAB"_FLD)-3) S PSBVAL1=PSBVAL1_" "
 .I $D(PSBVAL2) I ($L(PSBVAL2)+(@("PSBTAB"_(FLD-1))))'<(@("PSBTAB"_FLD)-1) D
 ..S PSBVAL3=$E(PSBVAL2,$F(PSBVAL2," "),999),PSBVAL2=$E(PSBVAL2,1,$F(PSBVAL2," ")-1)
 ..F PSBI=$L(PSBVAL3)+(@("PSBTAB"_(FLD-1))):1:(@("PSBTAB"_FLD)-3) S PSBVAL3=PSBVAL3_" "
 ..S $E(PSBRPLN(3),@("PSBTAB"_(FLD-1))+2,(@("PSBTAB"_FLD)-1))=PSBVAL3
 .I ($L(PSBVAL1)+(@("PSBTAB"_(FLD-1))))>(@("PSBTAB"_FLD)-2) D
 ..S PSBVAL2=($E(PSBVAL1,(@("PSBTAB"_FLD)-1)-(@("PSBTAB"_(FLD-1))),999))_PSBVAL2
 ..S PSBVAL1=$E(PSBVAL1,1,(((@("PSBTAB"_FLD)-1))-(@("PSBTAB"_(FLD-1))+1)))
 .S $E(PSBRPLN(1),@("PSBTAB"_(FLD-1))+2,(@("PSBTAB"_FLD)-1))=PSBVAL1
 .F PSBI=$L(PSBVAL2)+(@("PSBTAB"_(FLD-1))):1:(@("PSBTAB"_FLD)-3) S PSBVAL2=PSBVAL2_" "
 .S $E(PSBRPLN(2),@("PSBTAB"_(FLD-1))+2,(@("PSBTAB"_FLD)-1))=$E(PSBVAL2,1,((@("PSBTAB"_FLD)-1))-(@("PSBTAB"_(FLD-1))+1))
 .I $E(PSBVAL(0),1)'="" D
 ..F PSBI=$L(PSBVAL(0))+(@("PSBTAB"_(FLD-1))):1:(@("PSBTAB"_FLD)-3) S PSBVAL(0)=PSBVAL(0)_" "
 ..S $E(PSBRPLN(3),@("PSBTAB"_(FLD-1))+2,(@("PSBTAB"_FLD)-1))=PSBVAL(0)
 Q
 ;
PGTOT(X) ; Track PAGE Number.
 S:'$D(X) PSBLNTOT=PSBLNTOT+1 S:$D(X) PSBLNTOT=PSBLNTOT+X
 I PSBPGNUM=1,(PSBLNTOT=1) S PSBLNTOT=15 S PSBMORE=PSBLNTOT+7 Q PSBPGNUM
 I PSBLNTOT'<PSBMORE D
 .S PSBMORE=PSBLNTOT+7
 .I PSBMORE>(IOSL-9) S PSBPGNUM=PSBPGNUM+1,PSBLNTOT=15 S PSBMORE=PSBLNTOT+7
 Q PSBPGNUM
 ;
WRAPPER(X,Y,Z) ; Wrap text line.
 N PSB S J=1
 F  Q:'$L(Z)  D
 .I $L(Z)<Y S $E(PSBRPLN(J),X)=Z S Z="" Q
 .F PSB=Y:-1:0 Q:$E(Z,PSB)=" "
 .S:PSB<1 PSB=Y S $E(PSBRPLN(J),X)=$E(Z,1,PSB)
 .S Z=$E(Z,PSB+1,250),J=J+1
 Q ""
