XMJDIR ;ISC-SF/GMB- MailMan's DIR ;06/23/99  07:05
 ;;7.1;MailMan;**50**;Jun 02, 1994
XMDIR(XMDIR,XMOPT,XMY,XMABORT) ;
 N XMX
 K XMY
 F  D  Q:$D(XMY)!XMABORT
 . W !!,XMDIR("A"),XMDIR("B"),"// "
 . R XMX:DTIME I '$T S XMABORT=1 Q
 . I XMX[U S XMABORT=1 Q
 . I XMX="" S XMY=$E(XMDIR("B")) Q
 . I XMX="?" D HELPSCR(.XMOPT) Q
 . I $E(XMX)="?" D  Q
 . . N XQH
 . . S XQH="XM-U-MO-READ"
 . . D EN^XQH
 . I $D(XMDIR("PRE")) X XMDIR("PRE")
 . S XMY=$$COMMAND(.XMOPT,XMX)
 . I $D(XMOPT(XMY)),'$D(XMOPT(XMY,"?")) Q
 . I XMY=-1 D
 . . W *7 D HELPSCR(.XMOPT)
 . E  D SHOWERR(.XMOPT,XMY)
 . K XMY
 Q
SHOWERR(XMOPT,XMY) ; Show error message
 W *7,!
 I $D(XMOPT(XMY,"?",1)) D
 . N I
 . S I=0
 . F  S I=$O(XMOPT(XMY,"?",I)) Q:'I  W !,XMOPT(XMY,"?",I)
 W !,XMOPT(XMY,"?")
 Q
COMMAND(XMOPT,XMY) ;
 S XMY=$$UP^XLFSTR(XMY)
 I XMY?.E1C.E Q -1
 I $L(XMY)>64 Q -1
 I $D(XMOPT(XMY)) Q XMY
 I '$D(XMOPT($E(XMY))) Q -1
 N XMCMD,XMLEN
 S XMLEN=$L(XMY)
 S XMCMD=$CHAR($A($E(XMY))-1)_"~"
 F  S XMCMD=$O(XMOPT(XMCMD)) Q:XMCMD=""  Q:$$UP^XLFSTR($E(XMOPT(XMCMD),1,XMLEN))=XMY!($E(XMCMD)'=$E(XMY))
 I $E(XMCMD)=$E(XMY) Q $P(XMCMD," ")  ; for Q xxx
 Q -1
HELPSCR(XMOPT) ;
 N XMCNT,XMCMD,XMROWS,I,XMHELP
 W !!,"Enter a code from the list.",!
 S XMCNT=0,XMCMD=""
 F  S XMCMD=$O(XMOPT(XMCMD)) Q:XMCMD=""  S:'$D(XMOPT(XMCMD,"?")) XMCNT=XMCNT+1
 S XMROWS=XMCNT+1\2
 S I=0
 F  D  Q:I=XMROWS
 . S XMCMD=$O(XMOPT(XMCMD))
 . Q:$D(XMOPT(XMCMD,"?"))
 . S I=I+1
 . S XMHELP(I)=$E(XMCMD_"      ",1,7)_XMOPT(XMCMD)
 S I=0
 F  S XMCMD=$O(XMOPT(XMCMD)) Q:XMCMD=""  D
 . Q:$D(XMOPT(XMCMD,"?"))
 . S I=I+1
 . W !,$E(XMHELP(I)_"                                   ",1,35)_"   "_$E(XMCMD_"      ",1,7)_XMOPT(XMCMD)
 S I=I+1
 W:$D(XMHELP(I)) !,XMHELP(I)
 Q
