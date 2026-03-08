XMJMLR1 ;ISC-SF/GMB-List/Read messages in basket (continued) ;04/27/99  08:10
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces 1^XMAL0 (ISC-WASH/THM/CAP)
XMDIR(XMDUZ,XMHI,XMPAGE,XMMORE,XMHELP,XMINSTR,XMOPTION,Y,XMABORT) ;
 N DIR,I,XMCMD,X
 D ZOOMOPT(.XMOPTION)
 S DIR(0)="FOA^1:100^K:'$$XMDIROK^XMJMLR1() X"
 S DIR("A")="Enter message number or command: "
 S DIR("??")=XMHELP
 S I=1,DIR("?",I)="Enter a message number to read a message."
 I $D(XMOPTION("Q")),'$D(XMOPTION("Q","?")) D
 . S I=I+1,DIR("?",I)="      ?string             Search for messages in this basket whose subject"
 . S I=I+1,DIR("?",I)="                          contains the specified string"
 . S I=I+1,DIR("?",I)="      ??string            Search for messages you once sent or received"
 . S I=I+1,DIR("?",I)="                          whose subject begins with the specified string"
 S I=I+1,DIR("?",I)="      .(-)n or n-m,a,c-d  (de)select message n or a list of messages"
 S I=I+1,DIR("?",I)="      .(-)*               (de)select all messages"
 S XMCMD=""
 F  S XMCMD=$O(XMOPTION(XMCMD)) Q:XMCMD=""  D
 . Q:$D(XMOPTION(XMCMD,"?"))
 . S I=I+1,DIR("?",I)="      "_XMCMD_"                  "_$S($L(XMCMD)=1:" ",1:"")_XMOPTION(XMCMD)
 I XMPAGE>0 D
 . S I=I+1,DIR("?",I)="Enter -  to go to the previous page; 0 to go to the first page."
 . S:$G(XMINSTR("GOTO")) I=I+1,DIR("?",I)="Enter -n to page back n pages."
 I XMMORE D
 . I $G(XMINSTR("GOTO")) D
 . . I XMPAGE>0 S DIR("?",I)=DIR("?",I)_"  "
 . . E  S I=I+1
 . . S DIR("?",I)=$G(DIR("?",I))_"Enter +n to page forward n pages."
 . S DIR("?")="Press ENTER or + to go to the next page.  Press ^ to exit this list."
 E  D
 . S DIR("?")="Press ENTER or ^ to exit this list."
 D ^DIR I $D(DTOUT)!$D(DUOUT) S XMABORT=1 Q
 Q:Y'?.A!(Y="")
 I $D(XMOPTION(Y)),'$D(XMOPTION(Y,"?")) Q
 D SHOWERR^XMJDIR(.XMOPTION,Y)
 D WAIT^XMXUTIL
 K Y
 Q
XMDIROK() ;
 N XMLO
 S XMLO=0
 I X?1N.N Q:$L(X)>25 0  S X=+X,Y=+Y Q $S(X'<XMLO&(X'>XMHI):1,$D(^XMB(3.9,X,0)):1,1:0)
 I $E(X)="." Q $$DOT()
 I X?1"-".N Q:$L(X)>25 0  Q 1
 I X?1"+".N Q:$L(X)>25 0  Q 1
 S Y=$$COMMAND^XMJDIR(.XMOPTION,X)
 Q:Y'=-1 1
 I X'?1"?".E!'$D(XMOPTION("Q")) Q 0
 I $D(XMOPTION("Q","?")) S Y="Q" Q 1
 I X?1"??".E D  Q 1
 . I $E(X,3,99)?1N.N,$D(^XMB(3.9,$E(X,3,99),0)) S Y=$E(X,3,99) Q
 . S Y="Q2",Y(0)=$E(X,3,99)
 S Y="Q1",Y(0)=$E(X,2,99)
 Q 1
DOT() ;
 N XMXR,I,XMOK,XMX,XMSTRIKE
 S XMOK=1
 S XMX=$TR(X," ")
 I $E(XMX,2)="-" S XMSTRIKE=1,XMX=$E(XMX,3,999)
 E  S XMSTRIKE=0,XMX=$E(XMX,2,999)
 I XMX="*" S Y="."_$S(XMSTRIKE:"-",1:"")_XMX Q 1
 F I=1:1:$L(XMX,",") D  Q:'XMOK
 . S XMXR=$P(XMX,",",I)
 . I XMXR?1.25N1"-"1.25N D  Q
 . . I $P(XMXR,"-",1)<XMLO S XMOK=0 Q
 . . I $P(XMXR,"-",2)>XMHI S XMOK=0 Q
 . . I $P(XMXR,"-",1)>$P(XMXR,"-",2) S XMOK=0
 . I XMXR?1.25N D  Q
 . . I XMXR<XMLO S XMOK=0 Q
 . . I XMXR>XMHI S XMOK=0
 . I XMXR?1.25N1"-" D  Q
 . . I $P(XMXR,"-",1)<XMLO S XMOK=0 Q
 . . I $P(XMXR,"-",1)>XMHI S XMOK=0
 . S XMOK=0
 I XMOK S Y="."_$S(XMSTRIKE:"-",1:"")_XMX Q 1
 Q 0
SETOPT(XMDUZ,XMK,XMOPTION) ;
 D OPTGRP^XMXSEC1(XMDUZ,XMK,.XMOPTION)
 S XMOPTION("CD")="Change Detail"
 S XMOPTION("O")="Opposite selection toggle"
 S XMOPTION("Z")="Zoom selection toggle"
 Q
ZOOMOPT(XMOPTION) ;
 I $D(^TMP("XM",$J,".")) D  Q
 . I $D(XMOPTION("Z","?")) K XMOPTION("O","?"),XMOPTION("Z","?")
 . Q:'$D(XMOPTION("Q"))
 . S XMOPTION("Q","?")="You can't do this with messages selected."
 . S XMOPTION("N","?")=XMOPTION("Q","?")
 . S XMOPTION("R","?")=XMOPTION("Q","?")
 S XMOPTION("O","?")="You can't do this unless messages are selected."
 S XMOPTION("Z","?")=XMOPTION("O","?")
 Q:'$D(XMOPTION("Q"))
 K XMOPTION("Q","?"),XMOPTION("N","?"),XMOPTION("R","?")
 Q
