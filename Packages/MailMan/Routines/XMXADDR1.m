XMXADDR1 ;ISC-SF/GMB- XMXADDR (continued) ;03/13/99  11:57
 ;;7.1;MailMan;**50**;Jun 02, 1994
CHKPARM(XMADDR,XMSTRIKE,XMPREFIX,XMLATER) ;
 I $E(XMADDR,1)="-" D
 . S XMSTRIKE=1
 . S XMADDR=$E(XMADDR,2,999)
 E  S XMSTRIKE=0
 I $E(XMADDR,1)=" "!($E(XMADDR,$L(XMADDR))=" ") S XMADDR=$$STRIP^XMXUTIL1(XMADDR)
 I $P(XMADDR,"@",1)="" D  Q
 . S XMERROR="Null address"
 . I $G(XMIA) W !,XMERROR
 I $E(XMADDR,1)'="""",XMADDR[":" D  Q
 . D PREFIX(.XMADDR,.XMPREFIX,.XMLATER)
 . I XMSTRIKE,XMLATER="?" S XMLATER=""
 S XMPREFIX=""
 S XMLATER=""
 Q
PREFIX(XMADDR,XMPREFIX,XMLATER) ;
 N XMPRE
 S XMPRE=$P(XMADDR,":",1)
 I XMPRE="" D  Q
 . S XMERROR="Null recipient type"
 . I $G(XMIA) W !,XMERROR
 S (XMLATER,XMPREFIX)=""
 S XMPRE=$$UP^XLFSTR(XMPRE)
 I $P(XMPRE,"@",1)["L",'$D(XMRESTR("NET RECEIVE")) D
 . D LATER($P(XMPRE,"@",2,99),.XMLATER)
 . S XMPRE=$TR($P(XMPRE,"@",1),"L")
 D:XMPRE'="" RTYPE(XMPRE,.XMPREFIX)
 I $D(XMERROR),$D(XMRESTR("NET RECEIVE")),+$$FACILITY^XMR1A($P(XMADDR,"@",2))'=^XMB("NUM") K XMERROR Q
 S XMADDR=$P(XMADDR,":",2)
 Q
LATER(XMWHEN,XMLATER) ; (XMWHEN=user-supplied date/time)
 I $G(XMIA),XMWHEN="" S XMLATER="?" Q
 D DT^DILF("FTX",XMWHEN,.XMLATER,XMINLATR)
 Q:XMLATER>0
 S XMLATER=$S($G(XMIA):"?",1:"")
 Q
RTYPE(XMPRE,XMPREFIX) ;
 N XMINTRNL
 D CHK^DIE(3.91,6.5,"",XMPRE,.XMINTRNL)
 I XMINTRNL="^" D  Q
 . S XMERROR="Invalid recipient type '"_XMPRE_"'"
 . I $G(XMIA) W !,XMERROR
 S XMPREFIX=XMINTRNL
 Q
QLATER(XMFULL,XMLATER) ;
 N DIR,Y
 W !
 S DIR(0)="DO^"_XMINLATR_":"_XMAXLATR_":EXT"
 S DIR("A",1)="Later Delivery must be at least 5 minutes from now."
 S DIR("A")="When Later"
 S DIR("B")=$$MMDT^XMXUTIL1($$FMADD^XLFDT($$NOW^XLFDT,"","",5)) ; (in 5 minutes)
 S DIR("B")=$P(DIR("B")," ",1,3)_"@"_$P(DIR("B")," ",4)
 ;S DIR("??")="Response must be no earlier than "_$$MMDT^XMXUTIL1(XMINLATR)
 D ^DIR I $D(DIRUT) D  Q
 . S XMLATER=""
 . S XMERROR="Up-arrow out of later date"
 . W !,XMFULL," removed from recipient list."
 S XMLATER=Y
 W:$E(XMFULL,1,2)="G." !!,">> Remember, you won't be able to 'minus' anyone from the group. <<"
 Q
SERVER(XMADDR,XMSTRIKE,XMPREFIX,XMLATER,XMFULL) ;
 N XMG
 S XMADDR=$P(XMADDR,".",2,99)
 I $G(XMIA) D
 . N DIC,X
 . S X=XMADDR
 . S DIC="^DIC(19,"
 . S DIC(0)="FEZ"
 . D ^DIC
 . I Y<0 D  Q
 . . S XMERROR="Invalid server name"
 . . W !,XMERROR
 . S XMG=+Y
 E  D
 . S XMG=$$FIND1^DIC(19,"","OQ",XMADDR) I 'XMG S XMERROR="Server "_$S($D(DIERR):"ambiguous.",1:"not found.")
 Q:$D(XMERROR)
 S XMFULL="S."_$P(^DIC(19,XMG,0),U,1)
 D SETEXP^XMXADDR(XMFULL,XMG,XMSTRIKE,XMPREFIX,XMLATER)
 Q
DEVICE(XMADDR,XMSTRIKE,XMPREFIX,XMLATER,XMFULL) ;
 N XMG
 S XMADDR=$P(XMADDR,".",2,99)
 I $G(XMIA) D
 . N DIC,X
 . S X=XMADDR
 . S DIC="^%ZIS(1,"   ; file 3.5
 . S DIC(0)="EF"
 . D ^DIC
 . I Y<0 D  Q
 . . S XMERROR="Invalid device name"
 . . W !,XMERROR
 . S XMG=+Y
 . S XMADDR=$P(Y,U,2)
 E  D
 . S XMG=$$FIND1^DIC(3.5,"","OQ",XMADDR) I 'XMG S XMERROR="Device "_$S($D(DIERR):"ambiguous.",1:"not found.") Q
 . S XMADDR=$P(^%ZIS(1,XMG,0),U,1)
 Q:$D(XMERROR)
 I XMADDR["P-MESSAGE" D  Q
 . S XMERROR="You may not use P-MESSAGE in an address."
 . I $G(XMIA) W !,XMERROR
 S XMFULL="D."_XMADDR
 D SETEXP^XMXADDR(XMFULL,XMG,XMSTRIKE,XMPREFIX,XMLATER)
 Q
PERSON(XMDUZ,XMADDR,XMSTRIKE,XMPREFIX,XMLATER,XMG,XMFULL) ;
 N XMSCREEN,XMNOTFND,XMINDEX,I
 S XMINDEX="B" ; "B^BB^C^D" = name^alias^initial^nickname            
 F I="BB","C","D" S:$D(^VA(200,I)) XMINDEX=XMINDEX_U_I
 S XMADDR=$$UP^XLFSTR(XMADDR)
 S XMSCREEN="I $L($P(^(0),U,3)),$D(^XMB(3.7,+Y,2))"  ; User must have an access code & mailbox
 S XMG=$$FIND1^DIC(200,"","OQ",$S(+XMADDR=XMADDR:"`"_XMADDR,1:XMADDR),XMINDEX,XMSCREEN)
 I XMG D  Q
 . S XMFULL=$P(^VA(200,XMG,0),U,1)
 . Q:XMG'=.6
 . D CHKSHARE
 . S:XMLATER XMLATER="?"  ; Can't 'later' to SHARED,MAIL
 S XMNOTFND=$S($D(DIERR):"ambiguous",1:"not found")
 I +XMADDR=XMADDR D  Q
 . S XMERROR="Addressee "_XMNOTFND_"."
 ; Not found in NEW PERSON file, see if there's a MAIL NAME
 I $D(^XMB(3.7,"C")) D  Q:XMG
 . S XMSCREEN="I $L($P(^VA(200,+Y,0),U,3))"  ; User must have an access code
 . S XMG=$$FIND1^DIC(3.7,"","OQ",XMADDR,"C",XMSCREEN) Q:'XMG
 . S XMFULL=$P(^VA(200,XMG,0),U,1)
 ; Not a Mail Name, see if it's in the Remote User Directory.
 S XMINDEX="" F I="B","F" S:$D(^DIC(4.2997,I)) XMINDEX=XMINDEX_U_I
 I XMINDEX'="" D  Q:XMG
 . S XMINDEX=$E(XMINDEX,2,99)
 . S XMG=$$FIND1^DIC(4.2997,"","OQ",XMADDR,XMINDEX) Q:'XMG
 . S XMADDR=$P(^XMD(4.2997,XMG,0),U,7)
 . D REMDT(XMG)
 . D REMOTE(XMDUZ,XMADDR,XMSTRIKE,XMPREFIX,XMLATER,.XMFULL)
 S XMERROR="Addressee "_XMNOTFND_"."
 Q
CHKSHARE ;
 I $G(XMINSTR("FLAGS"))["X"!($G(XMRESTR("FLAGS"))["X") D  Q
 . S XMERROR="Closed messages may not be sent to SHARED,MAIL."
 I $G(XMINSTR("FLAGS"))["C"!($G(XMRESTR("FLAGS"))["C") D  Q
 . S XMERROR="Confidential messages may not be sent to SHARED,MAIL."
 Q
BRODCAST(XMSTRIKE,XMPREFIX,XMLATER,XMFULL) ;
 I DUZ'=.5,'$D(^XUSEC("XMSTAR",DUZ)) D  Q
 . S XMERROR="Only the postmaster or holders of the XMSTAR key may broadcast messages."
 . W:$G(XMIA) !,XMERROR
 S XMFULL="* (Broadcast to all local users)"
 W:$G(XMIA) $E(XMFULL,2,99)
 D SETEXP^XMXADDR(XMFULL,"",XMSTRIKE,XMPREFIX,XMLATER)
 Q
REMDT(XMG) ;
 N XMFDA
 S XMFDA(4.2997,XMG_",",6)=$E(DT,1,5)  ; Date (YYYMM) remote address last used
 D FILE^DIE("","XMFDA")
 Q
REMOTE(XMDUZ,XMADDR,XMSTRIKE,XMPREFIX,XMLATER,XMFULL) ;
 ; XMVIA    IEN of domain in ^DIC(4.2 via which the msg will be sent
 ; XMVIAN   Name of domain via which the msg will be sent
 ; XMDOMAIN Domain of the addressee
 ; XMNAME   Name of the addressee
 N XMVIA,XMVIAN,XMDOMAIN,XMNAME
 S:XMADDR["<"!(XMADDR[" ") XMADDR=$$REMADDR(XMADDR)
 S XMNAME=$P(XMADDR,"@",1)
 I XMNAME="" D  Q
 . S XMERROR="Null addressee"
 . I $G(XMIA) W !,XMERROR
 S XMDOMAIN=$P(XMADDR,"@",2,99)
 I XMDOMAIN="" D  Q
 . I XMNAME["!" S XMERROR="You must specify a reachable uunet host."
 . E  S XMERROR="Null domain"
 . I $G(XMIA) W !,XMERROR
 ; find out the full domain name, and
 ; whether the domain is valid, and if so, via which entry in DIC(4.2
 D DNS^XMXADDRD(XMDUZ,.XMDOMAIN,.XMVIA,.XMVIAN) Q:$D(XMERROR)
 I XMDOMAIN=^XMB("NETNAME") D  ; the full domain name = the local domain
 . N XMQUOTED
 . S:XMNAME?1""""1.E1"""" XMNAME=$E(XMNAME,2,$L(XMNAME)-1),XMQUOTED=1
 . D LOCAL^XMXADDR(XMDUZ,XMNAME,XMSTRIKE,XMPREFIX,.XMLATER,.XMFULL)
 . Q:'$D(XMERROR)
 . Q:$G(XMQUOTED)
 . Q:".G.g.D.d.S.s."[("."_$E(XMNAME,1,2))
 . N XMSAVE
 . S XMSAVE=XMNAME
 . S XMNAME=$TR(XMNAME,"._+",", .")
 . Q:XMSAVE=XMNAME
 . K XMERROR
 . W:$G(XMIA) !,"Checking: ",XMNAME
 . D LOCAL^XMXADDR(XMDUZ,XMNAME,XMSTRIKE,XMPREFIX,.XMLATER,.XMFULL)
 E  D
 . I $D(XMRESTR("NONET")) D  Q
 . . S XMERROR="Messages longer than "_XMRESTR("NONET")_" may not be sent across the network."
 . . W:$G(XMIA) !,XMERROR
 . ; I XMDOMAIN?.E1".VA.GOV" D
 . ;. ; Check the address before the @ to find any obvious errors
 . ; Now transform spaces, commas, and periods in XMNAME
 . S XMFULL=XMNAME_"@"_XMDOMAIN
 . I XMLATER="?" D QLATER(XMFULL,.XMLATER) Q:$D(XMERROR)
 . D SETEXP^XMXADDR(XMFULL,XMVIA,XMSTRIKE,XMPREFIX,XMLATER)
 Q
REMADDR(XMADDR) ;
 I XMADDR["<" Q $TR($P($P(XMADDR,">",1),"<",2,99),"<")  ; handles <addr> and <<addr>>
 Q:XMADDR'[" " XMADDR
 I $E(XMADDR,1)=" "!($E(XMADDR,$L(XMADDR))=" ") S XMADDR=$$STRIP^XMXUTIL1(XMADDR)
 I XMADDR'["""",XMADDR'["(" Q XMADDR
 I XMADDR["""@" D  Q XMADDR
 . ; "first last"@domain
 . N I,J,XMDOM
 . S I=$F(XMADDR,"""@")
 . S XMDOM=$E(XMADDR,I,999)
 . S XMDOM=$P(XMDOM," ",1)
 . S J=$F(XMADDR,"""")
 . S XMADDR=$E(XMADDR,J-1,I-J)_"@"_XMDOM
 ; last.first@domain (first last)
 N I
 F I=1:1:$L(XMADDR," ") Q:$P(XMADDR," ",I)["@"
 S XMADDR=$P(XMADDR," ",I)
 Q XMADDR
