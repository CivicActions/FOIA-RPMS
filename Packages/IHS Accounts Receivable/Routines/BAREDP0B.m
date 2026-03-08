BAREDP0B ; IHS/SD/LSL - AR ERA AUTO-POSTIEG ; 01/30/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**37**;OCT 26,2005;Build 210
 ;IHS/SD/SDR 1.8*37 ADO60825 Split from BAREDP00 due to routine size; Make sure cashiering session stays open
 Q
4010 ;
 S ANS="Y"
 K FILE
 I $D(^BAREDI("I",DUZ(2),"C",HSTFILE)) D  Q:ANS="N"
 .S IEN=$O(^BAREDI("I",DUZ(2),"C",HSTFILE,9999999),-1)
 .S LOADDT=""
 .S:(+IEN'=0) LOADDT=$$GET1^DIQ(90056.02,IEN,".02"),FILE=$$GET1^DIQ(90056.02,IEN,".01")
 .W !!,"This file was previously loaded on "_LOADDT_" as",!?2,"file "_FILE
 .W !!,?5," You can exit and review the import by entering"
 .W !,?5," the filename in the View Import Header option.",!
 .W !,"NOTE: reloading a file will create duplicate entries in the A/R EDI Check!"
 .W !,"Proceed with caution"
 .S BARFLG=1
 .S BARFLG=$$POSTCHK^BAREDP0A(IEN)
 .I BARFLG=1 W !,"Nothing has been posted from this ERA.  If you reload it, the original file",!,"will be replaced with this file.  Any edits done in REV will be lost."
 .I BARFLG=0 D  S ANS="N" Q
 ..W !!!,"Part of this file has been POSTED and is therefore not eligible for reload."
 .S DIR(0)="Y"
 .S DIR("A")="Do you wish to reload this file"
 .S DIR("B")="N"
 .S DIR("?")="Enter 'Y' to re-install transport file: "
 .D ^DIR
 .I $D(DIRUT)!Y=0 S ANS="N" Q
 .I BARFLG=1 D
 ..K DIR
 ..S DIR(0)="Y"
 ..S DIR("A")="Are you sure?"
 ..S DIR("B")="N"
 ..S DIR("?")="Enter 'Y' to re-install transport file: "
 ..D ^DIR
 .I BARFLG=1 Q:$D(DIRUT)!(ANS'="Y")
 .K DIR
 .S ANS=$S(+Y:"Y",1:"N")
 .Q:ANS'="Y"
 Q:ANS'="Y"
 K XBY,XBGUI
 W !!,"File",?25,"Directory",?50,"Transport"
 W !,HSTFILE,?25,XBDIR,?50,TRNAME,!!
 S DIR(0)="Y"
 S DIR("A")="Do you want to proceed"
 S DIR("B")="N"
 S DIR("?")="Enter 'Y' to install transport file: "
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 Q:'+Y
 I +$G(BARFLG)=1 D
 .S DIK=$$DIC^XBDIQ1(90056.02)
 .S DA=IEN
 .D ^DIK
 S BARCTRL=0
 D READ^BAREDPA1(XBDIR,HSTFILE)  ;Read file into ^TMP($J,"ERA")
 Q:+$G(POP)
 D EOP^BARUTL(1)
 I '$D(^TMP($J,"ERA")) D  Q
 .W !,"The file ",HSTFILE," in directory ",XBDIR
 .W !,"Appears to be an empty file."
 .W !,"Empty files are not HIPAA compliant."
 .W !,"Inform your source and request a HIPAA compliant file"
 .W !,"Please contact your supervisor for assistance."
 .D EOP^BARUTL(1)
 D CLEAR^VALM1
 S X=$O(^TMP($J,"ERA",""),-1)
 W !,"LINE COUNT LOADED: ",X,! H 3
 Q
