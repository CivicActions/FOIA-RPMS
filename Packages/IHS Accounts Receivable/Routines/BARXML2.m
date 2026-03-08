BARXML2 ;IHS/SD/CPC - XML UTILITIES ;05/12/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**30**;OCT 26, 2005;Build 55
 ;
 ;Use for converting portions of Excel generated XML template to Mumps formatted code
 ;20200512 - Style tags added (PARSTYL)
 ;;D NEWXML^BARXML2
 ; PROVIDE PATH, AND FILENAME TO XML TEMPLATE FILE
 ; LOADS INTO ^TMP($J,"XML"
 ; D PARSTYL^BARXML2
 Q
NEWXML   ;
 K ^TMP($J,"XML")
 S DIR(0)="F"
 S DIR("A")="Enter the directory path for the format file"
 S BARPATH=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),U,17)
 S DIR("B")=BARPATH
 S DIR("?")="For example enter '/usr/mydir/'"
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 ; Path
 S XBDIR=X
 D FNAME^BAREDIUT
 S HSTFILE=$G(XBFN)
 Q:HSTFILE=""
 W !!,"CHECKING FILE FORMAT....."
 S BARCTRL=0
 S POP=0 D READ(XBDIR,HSTFILE) I POP QUIT
 Q
 ;
READ(BARPATH,BARFILE)   ; EP
 ; Read host file into ^TMP($J,"XML")
 Q:BARPATH=""
 Q:BARFILE=""
 K ^TMP($J,"ERA")
 N BARCNT,BARTXT,BARDONE
 S (BARCNT,BARDONE)=0
 D OPEN^%ZISH("XMLFILE"_$J,BARPATH,BARFILE,"R")
 I POP D  Q
 .W !!,"Error opening file....please verify filename and directory and try again"
 .S BARDONE=1
 .D EOP^BARUTL(1)
 D READTST
 D CLOSE^%ZISH("XMLFILE"_$J)
 H 5
 D OPEN^%ZISH("XMLFILE"_$J,BARPATH,BARFILE,"R")
 I BARFTYP="STREAM" F  D STREAM Q:+BARDONE
 I BARFTYP'="STREAM" F  D CRLF Q:+BARDONE
 D CLOSE^%ZISH("XMLFILE"_$J)
 Q
 ; ********************************************************************
 ;
READTST   ;
 ; Test file type
 U IO
 R BARTXT#200:300          ;Direct read of flat file
 I $L(BARTXT)>120 S BARFTYP="STREAM" Q
 S BARFTYP="CR/LF"
 Q
 ; ********************************************************************
 ;
STREAM   ;
 U IO
 R BARTXT#250:300           ;Direct read of flat file
 I $$STATUS^%ZISH D
 .S BARCNT=BARCNT+1
 .S ^TMP($J,"XML",BARCNT)=BARTXT
 .S BARTXT=""
 I '+$L(BARTXT) S BARDONE=1 Q
 S BARCNT=BARCNT+1
 S ^TMP($J,"XML",BARCNT)=BARTXT
 Q
 ; ********************************************************************
 ;
CRLF   ;
 U IO
 R BARTXT:300   ;Direct read of flat file
 I $$STATUS^%ZISH!'+$L(BARTXT) S BARDONE=1 Q
 S BARCNT=BARCNT+1
 S ^TMP($J,"XML",BARCNT)=BARTXT
 Q
 ;
PRINT   ;
 S %ZIS="QM"
 D ^%ZIS Q:POP
 I $D(IO("Q")) D  Q
 .S ZTRTN="PARSTYL^BARXML2",ZTDESC="STYLE BUILDER"
 .S ZTSAVE("BAR*")=""
 .D ^%ZTLOAD
 .I $D(ZTSK)[0 W !!?5,"Report Cancelled!"
 .E  W !!?5,"Report queued to run on ",ZTSK," #"
 .D HOME^%ZIS
 .K IO("Q")
 ;D PARSTYL
 ;U IO
 ;D GENXML^BARRCXL3
 Q
PARSTYL   ;
 U IO
 N T,X,Y,Z,STYLE
 K ^TMP($J,"COD")
 S X=0,Z="",STYLE=1
 F  S X=$O(^TMP($J,"XML",X)) Q:+X=0  D
 .S T=^TMP($J,"XML",X)
 .I $F(T,"<Styles>")'>0,$G(STYLE) Q
 .S STYLE=0
 .S Y=" W "_""""
 .S DQ=$C(34)_$C(34)_$C(34)_$C(34)
 .F Z=1:1:$L(T) D
 ..S V=$E(T,Z)
 ..;Possible line endings "?>","/>",">"
 ..I Z<$L(T),(V="?"),($E(T,Z+1)=">") S Y=Y_"_"_DQ_"_"_$C(34)_$E(T,Z) Q  ;"?>"
 ..I Z<$L(T),(V="/"),($E(T,Z+1)=">") S Y=Y_"_"_DQ_$E(T,Z) Q  ;"/>"
 ..I V=">",($E(T,Z-1)="?") S Y=Y_V_"""" Q
 ..I V=">",($E(T,Z-1)="/") S Y=Y_V_"""" Q
 ..I V=">",(Z=$L(T)) S Y=Y_V_$C(34) Q
 ..I V=">" S Y=Y_V_DQ Q
 ..;I V="=" S Y=Y_V_$C(34) Q
 ..;B:V=$C(34)
 ..I V=$C(34),(Z<$L(T)) S Y=Y_$C(34)_"_"_DQ_"_"_$C(34) Q
 ..I V=$C(34),(Z=$L(T)) S Y=Y_$C(34) Q
 ..S Y=Y_V
 ..;W X,"|",Z,"|",Y,!
 .;B
 .I $E(Y,$L(Y))=$C(34) S Y=Y_",!"
 .E  S Y=Y_$C(34)_",!"
 .;W ^TMP($J,"XML",X),!
 .W Y,!
 .;X Y
 .S ^TMP($J,"COD",X)=Y
 .I $F(T,"</Styles>")>0 S STYLE=1 Q
 Q
