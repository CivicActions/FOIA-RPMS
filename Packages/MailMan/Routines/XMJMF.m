XMJMF ;ISC-SF/GMB-Find messages based on criteria ;06/03/99  14:12
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces ^XMA03,^XMAL0,^XMAL0A (ISC-WASH/CAP/THM)
 ; Entry points used by MailMan options (not covered by DBIA):
 ; FIND     XMSEARCH
FINDBSKT(XMDUZ,XMK,XMKN) ; Find messages in a particular basket
 ; XMKCHOOS  1=user may choose which basket; 0=user is locked into current basket
 N XMKCHOOS
 S XMKCHOOS=0
 D M
 Q
FIND ; Find messages in any basket or find any message
 N XMK,XMKN,XMKCHOOS,DIR,Y,DIRUT
 D CHECK^XMVVITAE
 S XMKCHOOS=1  ; ,XMK=1,XMKN="IN"
 S DIR(0)="SO^A:Search all messages;M:Search my Mailbox only"
 S DIR("A")="Select message search method"
 S DIR("?",1)="Enter 'A' to search all messages on the system which you have ever sent"
 S DIR("?",2)="or which have ever been sent to you."
 S DIR("?",3)="The search is based only on the criterion, 'Subject starts with'."
 S DIR("?",4)=""
 S DIR("?",5)="Enter 'M' to search all messages which currently exist in your mailbox."
 S DIR("?",6)="The search is based on any combination of criteria:"
 S DIR("?",7)="'Subject contains', 'sender is', 'addressee is', 'date sent',"
 S DIR("?")="'response sender is', and 'message contains'."
 S DIR("??")="XM-U-Q-SEARCH"
 D ^DIR Q:$D(DIRUT)
 D @Y
 Q
A ; Search all existing messages
 N DIR,Y,DIRUT
 S DIR(0)="FO^3:30"
 S DIR("A")="Enter the string that the subject starts with"
 S DIR("?",1)="The string may be from 3 to 30 characters."
 S DIR("?",2)="We will find all messages whose subject starts with the string you enter."
 S DIR("?",3)="We will search all existing messages which you have ever had access to,"
 S DIR("?",4)="whether they are in your mailbox or not."
 S DIR("?")="The search is case-sensitive."
 S DIR("??")="XM-U-Q-SEARCH SYSTEM"
 D ^DIR Q:$D(DIRUT)
 W !,"Searching..."
 D FIND^XMJMFA(XMDUZ,Y)
 Q
M ; Search my mailbox only
 N DIR,Y,DIRUT,XMF,XMABORT,XMFFRN,XMFBSKTN,XMFTDTX,XMFFDTX,XMFRFRN,XMSRCHED
 S (XMABORT,XMSRCHED)=0
 I $D(XMK) S XMF("BSKT")=XMK,XMFBSKTN=XMKN
 E  S XMF("BSKT")="*"
 S DIR(0)=""
 F  D  Q:XMABORT
 . S DIR(0)=""
 . W @IOF,"Current search criteria:"
 . I +XMF("BSKT")=XMF("BSKT") D
 . . W !,"Search basket:",?30,XMFBSKTN
 . . Q:'XMKCHOOS
 . . S DIR(0)=DIR(0)_";B:Change Search basket"
 . . S DIR(0)=DIR(0)_";BA:Search all baskets"
 . E  D
 . . W !,"Search basket:",?30,"All baskets"
 . . S DIR(0)=DIR(0)_";B:Search one basket"
 . I $D(XMF("SUBJ")) D
 . . W !,"Subject contains:",?30,XMF("SUBJ")
 . . S DIR(0)=DIR(0)_";S:Change 'Subject contains' string"
 . E  S DIR(0)=DIR(0)_";S:Enter 'Subject contains' string"
 . I $D(XMF("FROM")) D
 . . W !,"Message from:",?30,$S(XMF("FROM")=+XMF("FROM"):XMFFRN,1:XMF("FROM"))
 . . S DIR(0)=DIR(0)_";F:Change 'Message from' person"
 . E  S DIR(0)=DIR(0)_";F:Enter 'Message from' person"
 . I $D(XMF("TO")) D
 . . W !,"Message to:",?30,XMF("TO")
 . . S DIR(0)=DIR(0)_";T:Change 'Message to' addressee"
 . E  S DIR(0)=DIR(0)_";T:Enter 'Message to' addressee"
 . I $D(XMF("FDATE")) D
 . . W !,"Message sent on or after:",?30,XMFFDTX
 . . S DIR(0)=DIR(0)_";DA:Change 'Message sent on or after' date"
 . E  S DIR(0)=DIR(0)_";DA:Enter 'Message sent on or after' date"
 . I $D(XMF("TDATE")) D
 . . W !,"Message sent on or before:",?30,XMFTDTX
 . . S DIR(0)=DIR(0)_";DB:Change 'Message sent on or before' date"
 . E  S DIR(0)=DIR(0)_";DB:Enter 'Message sent on or before' date"
 . I $D(XMF("RFROM")) D
 . . W !,"Response from:",?30,$S(XMF("RFROM")=+XMF("RFROM"):XMFRFRN,1:XMF("RFROM"))
 . . S DIR(0)=DIR(0)_";R:Change 'Response from' person"
 . E  S DIR(0)=DIR(0)_";R:Enter 'Response from' person"
 . I $D(XMF("TEXT")) D
 . . W !,$S(XMF("TEXT","L")=1:"Message",XMF("TEXT","L")=2:"Message or Response",1:"Response")," contains:",?30,XMF("TEXT")
 . . S DIR(0)=DIR(0)_";X:Change 'Message contains' string"
 . E  S DIR(0)=DIR(0)_";X:Enter 'Message contains' string"
 . S DIR(0)=DIR(0)_";Q:Quit"
 . I $D(XMF("SUBJ"))!$D(XMF("FROM"))!$D(XMF("FDATE"))!$D(XMF("TDATE"))!$D(XMF("TO"))!$D(XMF("RFROM"))!$D(XMF("TEXT")) D
 . . S DIR(0)=DIR(0)_";G:Go search"
 . . S DIR("A")="Select search action"
 . . S DIR("B")=$S(XMSRCHED:"Q",1:"G")
 . E  D
 . . S DIR("A")="Select search action"
 . . S DIR("B")="S"
 . S DIR(0)="S^"_$E(DIR(0),2,999)
 . S DIR("??")="XM-U-Q-SEARCH CRITERIA"
 . D ^DIR I $D(DUOUT)!$D(DTOUT)!(Y="Q") S XMABORT=1 Q
 . S XMSRCHED=$S(Y="G":1,1:0)
 . D @Y
 Q
B ; Search one basket
 N XMDIC,XMFBSKT
 S XMDIC("B")=$G(XMFBSKTN,"IN")
 D SELBSKT^XMJBU(XMDUZ,"Select basket to search: ","",.XMDIC,.XMFBSKT,.XMFBSKTN) I XMFBSKT=U S XMABORT=1 Q
 S XMF("BSKT")=XMFBSKT
 Q
BA ; Search all baskets
 S XMF("BSKT")="*"
 Q
S ; Subject contains
 N DIR,Y,X
 S DIR(0)="FO^3:30"
 S DIR("A")="Subject contains"
 S:$D(XMF("SUBJ")) DIR("B")=XMF("SUBJ")
 S DIR("?",1)="Enter the string that the subject contains."
 S DIR("?",2)="It may be from 3 to 30 characters."
 S DIR("?")="The search is NOT case-sensitive."
 D ^DIR I $D(DUOUT)!$D(DTOUT) S XMABORT=1 Q
 I X="@" K XMF("SUBJ") Q
 Q:Y=""
 S XMF("SUBJ")=Y
 Q
F ; Message from
 D GETPERS(XMDUZ,.XMF,"FROM",.XMFFRN,.XMABORT)
 Q
G ; Go search
 W !,"Searching..."
 I XMF("BSKT")="*" D FINDALL^XMJMFB(XMDUZ,.XMF) Q
 D FIND1^XMJMFB(XMDUZ,.XMF,1)
 Q
R ; Response from
 D GETPERS(XMDUZ,.XMF,"RFROM",.XMFRFRN,.XMABORT)
 Q
T ; Message to
 N XMFTON
 D GETPERS(XMDUZ,.XMF,"TO",.XMFTON,.XMABORT)
 S:$D(XMFTON) XMF("TO")=XMFTON
 Q
DA ; Message sent on or after date
 N DIR,Y,X
 S DIR(0)="DO^:"_$G(XMF("TDATE"),DT)_":EX"
 S DIR("A")="Message sent on or after"
 S DIR("?")="Enter a date.  It must include day, month, and year"
 S:$D(XMF("FDATE")) DIR("B")=XMFFDTX
 D ^DIR I $D(DUOUT)!$D(DTOUT) S XMABORT=1 Q
 I X="@" K XMF("FDATE") Q
 Q:Y=""
 S XMF("FDATE")=Y
 S XMFFDTX=$$MMDT^XMXUTIL1(XMF("FDATE"))
 Q
DB ; Message sent on or before date
 N DIR,Y,X
 S DIR(0)="DO^"_$G(XMF("FDATE"))_":DT:EX"
 S DIR("A")="Message sent on or before"
 S DIR("?")="Enter a date.  It must include day, month, and year"
 S:$D(XMF("TDATE")) DIR("B")=XMFTDTX
 D ^DIR I $D(DUOUT)!$D(DTOUT) S XMABORT=1 Q
 I X="@" K XMF("TDATE") Q
 Q:Y=""
 S XMF("TDATE")=Y
 S XMFTDTX=$$MMDT^XMXUTIL1(XMF("TDATE"))
 Q
X ; Message contains
 N DIR,Y,X
 S DIR(0)="FO^3:30"
 S DIR("A")="Message contains"
 S:$D(XMF("TEXT")) DIR("B")=XMF("TEXT")
 S DIR("?",1)="Enter the string to search for.  It may be from 3 to 30 characters."
 S DIR("?",2)="Note that if the string you are searching for is not all on one line"
 S DIR("?")="in the message, the search will not be able to find it."
 D ^DIR I $D(DUOUT)!$D(DTOUT) S XMABORT=1 Q
 I X="@" K XMF("TEXT") Q
 Q:Y=""
 S XMF("TEXT")=Y
 K DIR,X,Y
 S DIR(0)="Y"
 S DIR("A")="Should the search be case-sensitive"
 S DIR("B")=$S($G(XMF("TEXT","C"),1):"YES",1:"NO")
 S DIR("?",1)="Your answer determines whether case (upper/lower) matters in the search."
 S DIR("?",2)="It also affects the speed of the search."
 S DIR("?",3)="A case-sensitive search (one in which case matters) is faster."
 S DIR("?",4)="A case-insensitive search (one in which case does not matter) may find"
 S DIR("?",5)="more matches, but will be slower."
 S DIR("?",6)="Answer YES for a faster search, when case matters."
 S DIR("?")="Answer NO for a slower search, when case does not matter."
 D ^DIR I $D(DUOUT)!$D(DTOUT) S XMABORT=1 Q
 S XMF("TEXT","C")=Y
 K DIR,X,Y
 S DIR(0)="S^1:Message only;2:Message and Responses;3:Responses only"
 S DIR("A")="Where should we search"
 S DIR("B")=$S($G(XMF("TEXT","L"),1)=1:"Message only",$G(XMF("TEXT","L"))=2:"Message and Responses",1:"Responses only")
 D ^DIR I $D(DUOUT)!$D(DTOUT) S XMABORT=1 Q
 S XMF("TEXT","L")=Y
 Q
GETPERS(XMDUZ,XMF,XMWHICH,XMNAME,XMABORT) ;
 N DIR,Y,X,XMOK,XMWHO
 S DIR(0)="FO^1:30"
 S DIR("A")=$S(XMWHICH="RFROM":"Response",1:"Message")_" is "_$S(XMWHICH="TO":"to",1:"from")
 I XMWHICH="TO" S DIR("?",1)="Enter the message addressee.  It may be a person, group, device, or server."
 E  S DIR("?",1)="Enter the name of the person who sent the "_$S(XMWHICH="FROM":"message",1:"response")_"."
 S XMWHO=$S(XMWHICH="TO":"addressee",1:"user")
 S DIR("?",2)=""
 S DIR("?",3)="For remote "_XMWHO_"s, enter name@, name@domain, or @domain."
 S DIR("?",4)="'Name' must be found somewhere in the "_XMWHO_"'s name."
 S DIR("?",5)="'Domain' must be found somewhere in the "_XMWHO_"'s domain."
 S DIR("?")="The more characters you provide, the narrower the search will be."
 S:$D(XMF(XMWHICH)) DIR("B")=$S(+XMF(XMWHICH)=XMF(XMWHICH):XMNAME,1:XMF(XMWHICH))
 F  D  Q:XMABORT!XMOK
 . S XMOK=1
 . D ^DIR I $D(DUOUT)!$D(DTOUT) S XMABORT=1 Q
 . I X="@" K XMF(XMWHICH),XMNAME Q
 . I Y="" Q
 . I X["@" D  Q
 . . S XMF(XMWHICH)=$$UP^XLFSTR(Y)
 . I XMWHICH="TO" D
 . . N XMINSTR
 . . S XMINSTR("ADDR FLAGS")="X"  ; don't create ^TMP("XMY" globals
 . . D ADDR^XMXADDR(XMDUZ,X,.XMINSTR,"",.XMNAME)
 . . I '$D(XMNAME) S XMOK=0
 . E  D
 . . N DIC,X
 . . S X=Y
 . . S DIC="^VA(200,",DIC(0)="MNEQ"
 . . D ^DIC I $D(DUOUT)!$D(DTOUT) S XMABORT=1 Q
 . . I Y=-1 S XMOK=0 Q
 . . S XMF(XMWHICH)=+Y
 . . S XMNAME=$P(Y,U,2)
 Q
