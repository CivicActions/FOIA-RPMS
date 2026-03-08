XMXLIST ;ISC-SF/GMB-List message: multiple conditions ;06/01/99  13:38
 ;;7.1;MailMan;**50**;Jun 02, 1994
LISTMSGS(XMDUZ,XMK,XMFLDS,XMFLAGS,XMAMT,XMSTART,XMF,XMTROOT) ;
 ; XMK is the basket to look in
 ;              =number - Look in this basket ONLY
 ;              =*      - Look in all baskets
 ; XMFLDS is a list, separated by ';', of fields to retrieve.
 ; e.g. XMFLDS="SUBJ;DATE" means retrieve subject and date.
 ;       "BSKT" = basket (default: <basket ien>^<basket name>)
 ;                optionally followed by ":" and
 ;                "I" for basket IEN only (no 2nd piece)
 ;                "X" adds basket name xref
 ;       "DATE" = date sent (default: <internal date>^<dd mmm yy hh:mm>)
 ;                optionally followed by ":" and
 ;                "I" for internal date only (no 2nd piece)
 ;                "F" for FileMan date as the 2nd piece
 ;                "X" adds FileMan date xref
 ;       "FROM" = message from (default: <internal from>^<external from>)
 ;                optionally followed by ":" and
 ;                "I" for internal from only (no 2nd piece)
 ;                "X" adds external from xref
 ;       "LINE" = number of lines in the message
 ;       "NEW"  = is the message new? (0=no; 1=yes; 2=yes, and priority, too)
 ;       "PRI"  = is the message priority? (0=no; 1=yes)
 ;       "READ" = how much of the message has the user read?
 ;                null   = has not read the message at all
 ;                0      = has read the message, but no responses
 ;                number = has read through this response
 ;       "RESP" = how many responses does the message have?
 ;                0      = none
 ;                number = this many
 ;       "SEQN" = sequence number in basket
 ;       "SUBJ" = message subject (always external)
 ;                optionally followed by ":" and
 ;                "X" adds subject xref
 ; XMFLAGS are used to control processing
 ;              =B Backwards order (Default is traverse forward)
 ;              =C Use basket C-xref (Default is message IEN)
 ;              =N New messages only (C flag ignored)
 ;              =P New Priority messages only (C, N flags ignored)
 ; XMAMT        How many?
 ;              =number - Get this many
 ;              =*      - Get all (default)
 ; XMSTART is used to start the lister going.  The lister will keep it
 ; updated from call to call.
 ; XMSTART("XMK")  Start with this basket IEN (valid only if XMK="*")
 ;                 Continues from there, with each successive call,
 ;                 to the end.
 ;                 (Default is to start with basket .5, the WASTE basket)
 ; XMSTART("XMZ")  Start AFTER this message IEN (valid only if no C flag)
 ;                 Continues from there, with each successive call,
 ;                 to the end.
 ;                 (Default is to start at the beginning (or end) of the
 ;                 basket)
 ; XMSTART("XMKZ") Start AFTER this message C-xref (valid only if C flag)
 ;                 Continues from there, with each successive call,
 ;                 to the end.
 ;                 (Default is to start at the beginning (or end) of the
 ;                 basket)
 ; XMF contains conditions which are 'and'ed together to select only
 ; those messages which meet the conditions.
 ; XMF("FROM")  Message is from this person
 ; XMF("FDATE") Message was sent on or after this date
 ; XMF("RFROM") Message has a response from this person
 ; XMF("SUBJ")  Subject contains this string
 ; XMF("SUBJ","C") =0 - Search is not case-sensitive (default)
 ;                 =1 - Search is case-sensitive
 ; XMF("TDATE") Message was sent on or before this date
 ; XMF("TEXT")  Message contains this string
 ; XMF("TEXT","L") =1 - Look in message only (default)
 ;                 =2 - Look in both message and responses
 ;                 =3 - Look in responses only
 ; XMF("TEXT","C") =0 - Search is not case-sensitive (default)
 ;                 =1 - Search is case-sensitive
 ; XMF("TO")    Message is to this person
 ; XMTROOT is the target root to receive the message list.
 ;              (default is ^TMP("XMLIST",$J))
 ;
 ; Variables set and used by the routine:
 ; XMF("SUBJ","S") Look for this string in the subject
 ; XMF("TEXT","S") Look for this string in the message
 N XMZ,XMCNT,XMORDER
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 D INIT(.XMFLDS,.XMFLAGS,.XMAMT,.XMORDER,.XMF,.XMTROOT)
 S (XMZ,XMCNT)=0
 I XMK="*" D
 . I XMFLAGS["P" D NEWA^XMXLIST1(XMDUZ,"N",XMORDER,.XMFLDS,XMAMT,.XMSTART,.XMF,XMTROOT) Q
 . I XMFLAGS["N" D NEWA^XMXLIST1(XMDUZ,"N0",XMORDER,.XMFLDS,XMAMT,.XMSTART,.XMF,XMTROOT) Q
 . I XMFLAGS["C" D REGAC^XMXLIST1(XMDUZ,XMORDER,.XMFLDS,XMAMT,.XMSTART,.XMF,XMTROOT) Q
 . D REGAZ^XMXLIST1(XMDUZ,XMORDER,.XMFLDS,XMAMT,.XMSTART,.XMF,XMTROOT)
 E  D
 . N XMKN
 . S XMKN=$P(^XMB(3.7,XMDUZ,2,XMK,0),U,1)
 . I XMFLAGS["P" D NEW1(XMDUZ,XMK,XMKN,"N",XMORDER,.XMFLDS,XMAMT,.XMSTART,.XMF,XMTROOT) Q
 . I XMFLAGS["N" D NEW1(XMDUZ,XMK,XMKN,"N0",XMORDER,.XMFLDS,XMAMT,.XMSTART,.XMF,XMTROOT) Q
 . I XMFLAGS["C" D REG1C(XMDUZ,XMK,XMKN,XMORDER,.XMFLDS,XMAMT,.XMSTART,.XMF,XMTROOT) Q
 . D REG1Z(XMDUZ,XMK,XMKN,XMORDER,.XMFLDS,XMAMT,.XMSTART,.XMF,XMTROOT)
 Q
INIT(XMFLDS,XMFLAGS,XMAMT,XMORDER,XMF,XMTROOT) ;
 I $D(XMFLDS),XMFLDS="" K XMFLDS
 I $D(XMTROOT),XMTROOT'="" D
 . K @$$CREF^DILF(XMTROOT)
 . S XMTROOT=$$OREF^DILF(XMTROOT)_"""XMLIST"","
 E  D
 . K ^TMP("XMLIST",$J)
 . S XMTROOT="^TMP(""XMLIST"",$J,"
 I $D(XMF) D
 . I $D(XMF)'>9 K XMF Q
 . S:$D(XMF("SUBJ")) XMF("SUBJ","S")=$S('$G(XMF("SUBJ","C")):$$UP^XLFSTR(XMF("SUBJ")),1:XMF("SUBJ"))
 . I $D(XMF("TEXT")) D
 . . S XMF("TEXT","S")=$S('$G(XMF("TEXT","C")):$$UP^XLFSTR(XMF("TEXT")),1:XMF("TEXT"))
 . . I '$D(XMF("TEXT","L")) S XMF("TEXT","L")=1
 . I $D(XMF("FROM")) S XMF("FROM")=$$UP^XLFSTR(XMF("FROM"))
 . I $D(XMF("RFROM")) S XMF("RFROM")=$$UP^XLFSTR(XMF("RFROM"))
 . I $D(XMF("TO")) S XMF("TO")=$$UP^XLFSTR(XMF("TO"))
 S XMFLAGS=$G(XMFLAGS)
 S XMORDER=$S(XMFLAGS["B":-1,1:1)
 I $G(XMAMT)="" S XMAMT="*"
 Q
NEW1(XMDUZ,XMK,XMKN,XMTYPE,XMORDER,XMFLDS,XMAMT,XMSTART,XMF,XMTROOT) ; New messages in 1 basket
 N XMCNT,XMZ
 S XMKN=$P(^XMB(3.7,XMDUZ,2,XMK,0),U,1)
 S XMCNT=0
 S XMZ=$G(XMSTART("XMZ"))
 F  S XMZ=$O(^XMB(3.7,XMDUZ,XMTYPE,XMK,XMZ),XMORDER) Q:'XMZ  D  Q:XMCNT=XMAMT
 . I '$D(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)) D ADDITN^XMUT4A(XMDUZ,XMTYPE,XMK,XMZ)
 . I '$D(^XMB(3.9,XMZ,0)) D ZAPIT^XMXMSGS2(XMDUZ,XMK,XMZ) Q
 . I $D(XMF) Q:'$$GOODMSG^XMJMFB(XMDUZ,XMK,XMZ,.XMF)
 . S XMCNT=XMCNT+1
 . S @(XMTROOT_XMCNT_")")=XMZ
 . Q:'$D(XMFLDS)
 . D FIELDS^XMXLIST1(XMDUZ,XMK,XMKN,XMZ,.XMFLDS,XMTROOT,XMCNT)
 . I XMFLDS["SEQN" D KSEQN^XMXLIST1(XMDUZ,XMK,XMZ,.XMFLDS,XMTROOT,XMCNT)
 S XMSTART("XMZ")=XMZ
 S @(XMTROOT_"0)")=XMCNT_U_XMAMT
 ; Any more?
 I 'XMZ S @(XMTROOT_"0)")=@(XMTROOT_"0)")_"^0" Q
 I '$O(^XMB(3.7,XMDUZ,XMTYPE,XMK,XMZ),XMORDER) S @(XMTROOT_"0)")=@(XMTROOT_"0)")_"^0" Q
 I '$D(XMF) S @(XMTROOT_"0)")=@(XMTROOT_"0)")_"^1" Q
 N XMORE
 S XMORE=0
 F  S XMZ=$O(^XMB(3.7,XMDUZ,XMTYPE,XMK,XMZ),XMORDER) Q:'XMZ  D  Q:XMORE
 . I '$D(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)) D ADDITN^XMUT4A(XMDUZ,XMTYPE,XMK,XMZ)
 . I '$D(^XMB(3.9,XMZ,0)) D ZAPIT^XMXMSGS2(XMDUZ,XMK,XMZ) Q
 . I $$GOODMSG^XMJMFB(XMDUZ,XMK,XMZ,.XMF) S XMORE=1
 S @(XMTROOT_"0)")=@(XMTROOT_"0)")_U_XMORE
 Q
REG1C(XMDUZ,XMK,XMKN,XMORDER,XMFLDS,XMAMT,XMSTART,XMF,XMTROOT) ; Messages (by C-xref) in one basket
 N XMCNT,XMKZ,XMZ
 S XMCNT=0
 S XMKZ=$G(XMSTART("XMKZ"))
 F  S XMKZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ),XMORDER) Q:'XMKZ  D  Q:XMCNT=XMAMT
 . S XMZ=$O(^(XMKZ,"")) ; naked reference from previous line!
 . I '$D(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)) D ADDITC^XMUT4A(XMDUZ,XMK,XMZ,XMKZ)
 . I '$D(^XMB(3.9,XMZ,0)) D ZAPIT^XMXMSGS2(XMDUZ,XMK,XMZ) Q
 . I $D(XMF) Q:'$$GOODMSG^XMJMFB(XMDUZ,XMK,XMZ,.XMF)
 . S XMCNT=XMCNT+1
 . S @(XMTROOT_XMCNT_")")=XMZ
 . Q:'$D(XMFLDS)
 . D FIELDS^XMXLIST1(XMDUZ,XMK,XMKN,XMZ,.XMFLDS,XMTROOT,XMCNT)
 . I FIELDS["SEQN" D SEQN^XMXLIST1(XMDUZ,XMKZ,.XMFLDS,XMTROOT,XMCNT)
 S XMSTART("XMKZ")=XMKZ
 S @(XMTROOT_"0)")=XMCNT_U_XMAMT
 ; Any more?
 I 'XMKZ S @(XMTROOT_"0)")=@(XMTROOT_"0)")_"^0" Q
 I '$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ),XMORDER) S @(XMTROOT_"0)")=@(XMTROOT_"0)")_"^0" Q
 I '$D(XMF) S @(XMTROOT_"0)")=@(XMTROOT_"0)")_"^1" Q
 N XMORE
 S XMORE=0
 F  S XMKZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ),XMORDER) Q:'XMKZ  D  Q:XMORE
 . I '$D(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)) D ADDITC^XMUT4A(XMDUZ,XMK,XMZ,XMKZ)
 . I '$D(^XMB(3.9,XMZ,0)) D ZAPIT^XMXMSGS2(XMDUZ,XMK,XMZ) Q
 . I $$GOODMSG^XMJMFB(XMDUZ,XMK,XMZ,.XMF) S XMORE=1
 S @(XMTROOT_"0)")=@(XMTROOT_"0)")_U_XMORE
 Q
REG1Z(XMDUZ,XMK,XMKN,XMORDER,XMFLDS,XMAMT,XMSTART,XMF,XMTROOT) ; Messages (by IEN) in one basket
 N XMCNT,XMZ
 S XMCNT=0
 S XMZ=$G(XMSTART("XMZ"))
 I +XMZ=0 S XMZ=0 I XMORDER=-1 S XMZ=":"
 F  S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,XMZ),XMORDER) Q:'XMZ  D  Q:XMCNT=XMAMT
 . I '$D(^XMB(3.9,XMZ,0)) D ZAPIT^XMXMSGS2(XMDUZ,XMK,XMZ) Q
 . I $D(XMF) Q:'$$GOODMSG^XMJMFB(XMDUZ,XMK,XMZ,.XMF)
 . S XMCNT=XMCNT+1
 . S @(XMTROOT_XMCNT_")")=XMZ
 . Q:'$D(XMFLDS)
 . D FIELDS^XMXLIST1(XMDUZ,XMK,XMKN,XMZ,.XMFLDS,XMTROOT,XMCNT)
 . I XMFLDS["SEQN" D KSEQN^XMXLIST1(XMDUZ,XMK,XMZ,.XMFLDS,XMTROOT,XMCNT)
 S XMSTART("XMZ")=XMZ
 S @(XMTROOT_"0)")=XMCNT_U_XMAMT
 ; Any more?
 I 'XMZ S @(XMTROOT_"0)")=@(XMTROOT_"0)")_"^0" Q
 I '$O(^XMB(3.7,XMDUZ,2,XMK,1,XMZ),XMORDER) S @(XMTROOT_"0)")=@(XMTROOT_"0)")_"^0" Q
 I '$D(XMF) S @(XMTROOT_"0)")=@(XMTROOT_"0)")_"^1" Q
 N XMORE
 S XMORE=0
 F  S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,XMZ),XMORDER) Q:'XMZ  D  Q:XMORE
 . I '$D(^XMB(3.9,XMZ,0)) D ZAPIT^XMXMSGS2(XMDUZ,XMK,XMZ) Q
 . I $$GOODMSG^XMJMFB(XMDUZ,XMK,XMZ,.XMF) S XMORE=1
 S @(XMTROOT_"0)")=@(XMTROOT_"0)")_U_XMORE
 Q
