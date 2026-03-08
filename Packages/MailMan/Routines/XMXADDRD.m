XMXADDRD ;ISC-SF/GMB-DOMAIN NAME SERVER ;05/18/99  15:04
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces PSP^XMA210,^XMA21A,^XMA21B (ISC-WASH/CAP)
DNS(XMDUZ,XMDOMAIN,XMVIA,XMVIAN) ;
 ; XMDOMAIN - (in/out) Domain name.  May be mixed case.  Must already be
 ;            in xxx.xxx.xxx format.
 ; XMVIA    - (out) IEN of (relay) domain (in ^DIC(4.2))
 ; XMVIAN   - (out) Name of (relay) domain
 N XMVIAREC,XMNETNAM
 S XMNETNAM=^XMB("NETNAME")
 S XMDOMAIN=$$UP^XLFSTR(XMDOMAIN)
 I XMDOMAIN=XMNETNAM D  Q
 . S XMVIA=^XMB("NUM")
 . S XMVIAN=XMNETNAM
 D FINDDOMN
 Q:$D(XMERROR)
 I XMVIAN="VA.GOV",$$FORUM D  Q
 . S XMERROR="Domain not found: "_XMDOMAIN
 . W:$G(XMIA) !,XMERROR
 I $G(XMIA) D
 . W:XMDOMAIN'=XMVIAN " via ",XMVIAN
 . I XMVIAN'=XMNETNAM,$P(XMVIAREC,U,2)'["S" W " (Queued)"
 Q
FORUM() ; Is this FORUM or GATEWAY?
 Q $S($G(XMNETNAM,^XMB("NETNAME"))'["FORUM.":0,1:1)
FINDDOMN ; Look up domain
 N XMSUBDOM,XMFLAGS,DIC,X,Y
 S XMSUBDOM="",X=XMDOMAIN
 S XMFLAGS="ZMF"_$S('$G(XMIA):"O",$G(XMRESTR("FLAGS"))["O":"OE",1:"E")
 S DIC="^DIC(4.2,",DIC(0)=XMFLAGS
 F  S D="B^C" D MIX^DIC1 Q:Y>0!(X'[".")!$D(DUOUT)!$D(DTOUT)  D  Q:X=XMNETNAM
 . S XMSUBDOM=XMSUBDOM_$P(X,".")_"."
 . S X=$P(X,".",2,999)
 I Y'>0,X'[".",'$G(XMIA),$L(X)<4 S DIC(0)="ZFX",D="C" D IX^DIC  ; Look for COM,MIL,NET,etc. as synonym for one of the domains.
 I Y>0 D  Q   ; Domain successfully found
 . I XMSUBDOM'="" D  Q:$D(XMERROR)
 . . D CHKDOM($E(XMSUBDOM,1,$L(XMSUBDOM)-1)) Q:$D(XMERROR)
 . . Q:Y(0,0)'=XMNETNAM
 . . S XMERROR="Sub-domain '"_$E(XMSUBDOM,1,$L(XMSUBDOM)-1)_"' not found for domain '"_X_"'"
 . . W:$G(XMIA) !,XMERROR
 . I XMSUBDOM="",X'[".",$L(X)<4,$$FIND1^DIC(4.2996,"","QX",X) D  Q
 . . S XMERROR="Valid domain, but need subdomain: "_X
 . . Q:'$G(XMIA)
 . . W !,"Domain "_X_" is a valid INTERNET domain,"
 . . W !,"but you must specify at least one sub-domain."
 . S XMDOMAIN=$S(XMSUBDOM="":Y(0,0),1:XMSUBDOM_X)  ; MailMan's klugey way
 . ;S XMDOMAIN=XMSUBDOM_X ; Proper way?  Nope.
 . S XMVIA=+Y
 . S XMVIAREC=Y(0)
 . D VIA(.XMVIA,.XMVIAREC,.XMVIAN)
 I '$G(XMIA),X'=XMNETNAM D  Q:$D(XMERROR)
 . N Y,X
 . S X=XMDOMAIN
 . F  S Y=$$FIND1^DIC(4.2,"","MOQ",X,"B^C") Q:Y>0!$D(DIERR)!(X'[".")  D
 . . S X=$P(X,".",2,999)
 . Q:Y!'$D(DIERR)  ; (Y should never be >0, because we didn't find it before.)
 . I X'[".",$$FIND1^DIC(4.2996,"","QX",X) Q
 . S XMERROR="Domain ambiguous: "_X
 I $D(DTOUT)!$D(DUOUT) D  Q
 . S XMERROR=$S($D(DUOUT):"^",1:"time")_" out."
 . W !,XMERROR
 I X'["." D  Q  ; Domain not found, look in internet suffix file
 . D LOOKSFX Q:$D(XMERROR)
 . I X=XMDOMAIN D
 . . S XMERROR="Valid domain, but need subdomain: "_X
 . . Q:'$G(XMIA)
 . . W !,"Domain "_X_" is a valid INTERNET domain,"
 . . W !,"but you must specify at least one sub-domain."
 . E  D CHKDOM($E(XMSUBDOM,1,$L(XMSUBDOM)-1))
 I X=XMNETNAM D  Q
 . S XMERROR="Sub-domain '"_$E(XMSUBDOM,1,$L(XMSUBDOM)-1)_"' not found for domain '"_X_"'"
 . W:$G(XMIA) !,XMERROR
 Q
VIA(XMVIA,XMVIAREC,XMVIAN) ;
 S XMVIAN=$P(XMVIAREC,U,1)
 D CHKPRMIT(XMDUZ,XMVIAREC) Q:$D(XMERROR)
 ; If there's a relay domain, follow it.
 I $P(XMVIAREC,U,3) S XMVIA=$P(XMVIAREC,U,3),XMVIAREC=$G(^DIC(4.2,XMVIA,0)) D VIA(.XMVIA,.XMVIAREC,.XMVIAN) Q
 Q:$P(XMVIAREC,U,2)'["S"
 Q:$O(^DIC(4.2,XMVIA,1,0))  ; Domain has script(s).
 Q:$L(XMVIAN)+1=$F(XMVIAN,XMNETNAM)  ; Subdomain of this domain.
 N Y
 I $L(XMVIAN,".")>3 D  I Y,$P(^DIC(4.2,+Y,0),U,1)=XMNETNAM Q  ; Subdomain of this domain.
 . N X
 . S X=$P(XMVIAN,".",2,999)
 . F  S Y=$$FIND1^DIC(4.2,"","QX",X,"C") Q:Y!($L(X,".")<3)  D
 . . S X=$P(X,".",2,999)
 ; No script, so send to parent domain, if there is one,
 ; and if the parent isn't the same as this domain.
 Q:'$G(^XMB("PARENT"))
 Q:'$G(^XMB("NUM"))
 Q:^XMB("PARENT")=^XMB("NUM")
 Q:'$D(^DIC(4.2,^XMB("PARENT"),0))
 S XMVIA=^XMB("PARENT")
 S XMVIAREC=^DIC(4.2,XMVIA,0)
 S XMVIAN=$P(XMVIAREC,U,1)
 Q
CHKDOM(XMDOM,XMMAXDOM,XMMAXDOT) ;
 N I,XMSUBDOM
 I $TR(XMDOM,".-","")'?.AN D  Q
 . S XMERROR="Domain may not contain punctuation other than '.' or '-'."
 . W:$G(XMIA) !,XMERROR
 I '$D(XMMAXDOM) S XMMAXDOM=255
 I $L(XMDOM)>XMMAXDOM D  Q
 . S XMERROR="Domain must be from 1 to "_XMMAXDOM_" characters."
 . W:$G(XMIA) !,XMERROR
 I '$D(XMMAXDOT) S XMMAXDOT=63
 F I=1:1:$L(XMDOM,".") D  Q:$D(XMERROR)
 . S XMSUBDOM=$P(XMDOM,".",I)
 . I XMSUBDOM?1AN.E,$L(XMSUBDOM)'>XMMAXDOT Q
 . I $L(XMSUBDOM,I)>XMMAXDOT S XMERROR="Domain dot pieces must be from 1 to "_XMMAXDOT_" characters long."
 . E  S XMERROR="Domain dot pieces must begin with a letter or number."
 . Q:'$G(XMIA)
 . W !,XMERROR
 . W !,XMSUBDOM_" is not valid."
 Q
LOOKSFX ; Look for top level domain in internet suffix file
 ; Instead of looking in the file, we could call the COTS DNS, if it exists.
 N DIC,Y
 I $G(XMIA) D
 . W !,"Looking in Internet Suffix file..."
 . S DIC(0)=$TR(XMFLAGS,"O")_"X"
 E  S DIC(0)="X"
 S DIC="^DIC(4.2996,"
 S:$G(XMIA) DIC("W")="W ""  "",$P(^(0),U,2)"  ; high-level domain purpose/country
 D ^DIC
 I Y>0 D  Q:XMVIA
 . S XMVIA=$G(^XMB("PARENT"))
 . I 'XMVIA S XMVIA=$$FIND1^DIC(4.2,"","MQX",$S($$FORUM:"GK.VA.GOV",1:"FORUM.VA.GOV"),"B^C") Q:'XMVIA
 . S XMVIAREC=^DIC(4.2,XMVIA,0)
 . S XMVIAN=$P(XMVIAREC,U)
 S XMERROR="Domain not found: "_X
 W:$G(XMIA) !,XMERROR
 Q
CHKPRMIT(XMDUZ,XMVIAREC) ;
 I $G(XMINSTR("ADDR FLAGS"))["R",'$D(XMRESTR("NET RECEIVE")) Q
 I $P(XMVIAREC,U,2)["C",$P(XMVIAREC,U,2)'["S" D  Q
 . S XMERROR="Domain closed: "_$P(XMVIAREC,U,1)
 . W:$G(XMIA) !,XMERROR
 Q:$G(XMINSTR("ADDR FLAGS"))["R"
 I $P(XMVIAREC,U,11)'="",'$D(^XUSEC($P(XMVIAREC,U,11),XMDUZ)) D  Q
 . S XMERROR="You don't hold key to domain '"_$P(XMVIAREC,U,1)_"'."
 . W:$G(XMIA) !,XMERROR
 ; Maybe the following belongs in XMFWD^XMVVITAE:
 ;I $P(XMVIAREC,U,2)["N" D  Q
 ;. S XMERROR="No forwarding to domain '"_$P(XMVIAREC,U,1)_"'."
 ;. W:$G(XMIA) !,XMERROR
 Q
 ; **************************************************************
 ;I X'[".",$E(XMSUBDOM)="#" D  Q
 ;. ; X.400 Addressing  (See I3^XMA21A)
 ;. S X="#"
 ;. D ^DIC
 ;. I Y<1 D  Q
 ;. . S XMERROR="X.400 domain not found.  It must have '#' as its synonym."
 ;. . I $D(XMIA) W !,*7,XMERROR Q
 ;. . S XMMG="X.400 domain not found.  It must have '#' as its synonym."
 ;. S XMDOMAIN=XMSUBDOM_X
 ; **************************************************************
CHKNAME ; Input transform for .01 field of DOMAIN file 4.2
 N XMIA,XMERROR,I
 S XMIA=0
 S X=$$UP^XLFSTR(X)
 D CHKDOM(X,64,20)
 I $D(XMERROR) D  Q
 . D EN^DDIOL(XMERROR,"","!,*7")
 . K X
 Q:$D(DIFROM)
 F I=1:1:$L(X,".")-1 D  Q:'$D(X)
 . Q:'$D(^DIC(4.2996,"B",$P(X,".",I),0))
 . D EN^DDIOL("Domain dot pieces must not match Internet reserved domain names.","","!,*7")
 . K X
 Q
 ;I $G(XMIA) D
 ;. N DIC
 ;. S DIC="^DIC(4.2,",XMFLAGS="ZMF"_$S($G(XMRESTR("FLAGS"))["O":"OE",1:"E"),DIC(0)=XMFLAGS
 ;. F  D ^DIC Q:Y>0!(X'[".")!$D(DUOUT)!$D(DTOUT)  D  Q:X=XMNETNAM
 ;. . S XMSUBDOM=XMSUBDOM_$P(X,".")_"."
 ;. . S X=$P(X,".",2,999)
 ;E  D  Q:$D(XMERROR)
 ;. ; The problem with $$FIND1 is that if X matches a synonym, we have
 ;. ; no idea which synonym.  With ^DIC, if X matches a synonym, X is
 ;. ; set to the synonym.
 ;. ;S XMFLAGS="MOQ"
 ;. ;F  S Y=$$FIND1^DIC(4.2,"",XMFLAGS,X) Q:Y>0!(X'[".")  D  Q:X=XMNETNAM
 ;. F  S Y=$$FIND1^DIC(4.2,"","OQ",X,"B") Q:Y>0!$D(DIERR)  S Y=$$FIND1^DIC(4.2,"","OQ",X,"C") Q:Y>0!(X'[".")!$D(DIERR)  D  Q:X=XMNETNAM
 ;. . S XMSUBDOM=XMSUBDOM_$P(X,".")_"."
 ;. . S X=$P(X,".",2,999)
 ;. ;Q:'Y
 ;. I 'Y S:$D(DIERR) XMERROR="Domain ambiguous." Q
 ;. S Y(0)=^DIC(4.2,Y,0)
 ;. S Y(0,0)=$P(Y(0),U)
 ;. I $E(Y(0,0),1,$L(X))=X S X=Y(0,0)
