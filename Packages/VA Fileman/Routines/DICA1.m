DICA1 ;SEA/TOAD-VA FileMan: Updater, Pre-Processor ;2/17/98  13:08 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**17,41**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;12347;5338649;4118;
 
CHECK(DIFLAGS,DIFDA,DINUMS,DIRULE,DIOK) 
 ; ENTRY POINT--check out the FDA
 ; subroutine, DIFLAGS passed by value
 N DIC,DIEN,DIFILE,DIFLD,DIN,DINODE,DINT,DINUM,DIOP
 N DIOUT1,DIOUT2,DIOUT3,DIRID,DIRIGHT,DISEQ,DITYPE,DIVAL
FILES 
 S DIFILE=0,DIOUT1=0 F  D  Q:DIOUT1!$G(DIERR)
 . S DIFILE=$O(@DIFDA@(DIFILE))
 . I 'DIFILE S DIOUT1=1 Q
 . S DINODE=$G(^DD(DIFILE,.01,0))
 . I DINODE="" D  Q
 . . D ERR^DICA3($S('$D(^DD(DIFILE)):401,1:406),DIFILE)
 . I $P(DINODE,U,2)["W" D  Q
 . . D ERR^DICA3(407,DIFILE)
 . S DIRID=$$RID^DICU(DIFILE)
IENS .
 . S DIEN="",DIOUT2=0 F  D  Q:DIOUT2!$G(DIERR)
 . . S DIEN=$O(@DIFDA@(DIFILE,DIEN))
 . . I DIEN="" S DIOUT2=1 Q
 . . N DIDA D IEN^DICA2(.DIFILE,DIEN,.DIDA,DIRULE,.DIOK) Q:$G(DIERR)
 . . I 'DIOK S DIOUT1=1,DIOUT2=1 D  Q
 . . . I $E(DIEN,$L(DIEN))'="," D ERR^DICA3(304,"",DIEN) Q
 . . . D ERR^DICA3(202,"","","","IENS")
 . . S DIOK=$$RID(DIFILE,DIEN,DIFDA,DIRID)
 . . I 'DIOK D  Q
 . . . I $P(DIEN,U)["+" D ERR^DICA3(311,"",DIEN) Q
 . . . I $E(DIEN)="?",$P(DIOK,U,2)=".01" D ERR^DICA3(351,DIFILE,DIEN) Q
 . . . D ERR712(DIFILE,$P(DIOK,U,2)) Q
 . . I $D(@DIFDA@(DIFILE,DIEN,.001))#2 D
 . . . N DIENS S DIENS=@DIFDA@(DIFILE,DIEN,.001)
 . . . I $D(@DINUMS@(@DIRULE@("NUM")))[0 D
 . . . . S @DINUMS@(@DIRULE@("NUM"))=DIENS
 . . . S ^TMP("DIADD",$J,DIFILE,DIEN,.001)=DIENS
 . . . K @DIFDA@(DIFILE,DIEN,.001)
VALUES . .
 . . I DIFLAGS'["E" Q
 . . S DIFLD="",DIOUT3=0 F  D  Q:DIOUT3!$G(DIERR)
 . . . S DIFLD=$O(@DIFDA@(DIFILE,DIEN,DIFLD))
 . . . I DIFLD="" S DIOUT3=1 Q
 . . . I DIFLD=.01,$E(DIEN)="?",$E(DIEN,2)'="+" Q
 . . . S DIVAL=$G(@DIFDA@(DIFILE,DIEN,DIFLD))
 . . . D DTYP^DIOU(DIFILE,DIFLD,.DITYPE)
 . . . I DITYPE=5 S DINT=DIVAL
CONVERT . . .
 . . . I DITYPE'=5 D  Q:$G(DIERR)
 . . . . I DIEN["?"!(DIEN["+") D  Q:$G(DIERR)
 . . . . . I "@"[DIVAL D  Q
 . . . . . . I $P($G(^DD(DIFILE,DIFLD,0)),U,2)["R" D  Q
 . . . . . . . D ERR712(DIFILE,DIFLD)
 . . . . . . S DINT=DIVAL
 . . . . . N DA M DA=DIDA
 . . . . . N DIARG S DIARG="D0"
 . . . . . N DIMAX S DIMAX=$O(DA(""),-1)
 . . . . . N DIVAR F DIVAR=1:1:DIMAX S DIARG=DIARG_",D"_DIVAR
 . . . . . N @DIARG F DIVAR=0:1:DIMAX-1 S @("D"_DIVAR)=DA(DIMAX-DIVAR)
 . . . . . S @("D"_DIMAX)=DA
 . . . . . N DIDA D CHK^DIE(DIFILE,DIFLD,"",DIVAL,.DINT)
 . . . . E  D  Q:$G(DIERR)
 . . . . . N DIVALFLG S DIVALFLG="R"_$E("Y",DIFLAGS["Y")
 . . . . . D VAL^DIE(DIFILE,DIEN,DIFLD,DIVALFLG,DIVAL,.DINT)
 . . . . Q:$D(DINUM)[0
 . . . . S @DINUMS@(@DIRULE@("NUM"))=DINUM K DINUM
 . . . S @DIRULE@("FDA",DIFILE,DIEN,DIFLD)=DINT
CLEANUP 
 I $G(DIERR)!'DIOK K @DIRULE Q
 K @DIRULE@("L"),@DIRULE@("NUM"),@DIRULE@("OP"),@DIRULE@("ROOT")
 K @DIRULE@("SEQ"),@DIRULE@("TEMP"),@DIRULE@("UP")
 S DIN=$NA(@DIRULE@("ORDER")),DIC=0,@DIRULE@("THE END")=""
 F  S DIN=$Q(@DIN) Q:DIN=""!($P(DIN,",",3)'="""ORDER""")  D
 . S DIC=DIC+1,@DIRULE@("NEXT",DIC)=@DIN
 K @DIRULE@("ORDER"),@DIRULE@("THE END")
 I DIFLAGS["E" S DIFDA=$NA(@DIRULE@("FDA"))
 Q
 
RID(DIFILE,DIEN,DIFDA,DIRID) 
 ; CHECK--return whether FDA entry sets all required identifiers
 ; func, all passed by value
 N DIP S DIP=$P(DIEN,",") N DIOK S DIOK=1
 ; finding & LAYGO finding require a .01 node & not deleting the entry
 I $E(DIP)="?","@"[$G(@DIFDA@(DIFILE,DIEN,.01)) Q "0^.01"
 N DIC,DIR F DIC=1:1 S DIR=$P(DIRID,U,DIC) Q:DIR=""  D  I 'DIOK Q
 . ; filing & finding nodes needn't include all RIDs
 . ; they can't delete an RID, but filing nodes can delete the entry
 . I DIP'["+" D:DIR'=.01  Q
 . . I "@"[$G(@DIFDA@(DIFILE,DIEN,DIR),0) S DIOK="0^"_DIR
 . ; adding and LAYGO finding nodes must include all RIDs & not delete
 . S DIOK="@"'[$G(@DIFDA@(DIFILE,DIEN,DIR)) I 'DIOK S DIOK=DIOK_U_DIR
 Q DIOK
 
ERR712(DIFILE,DIFIELD) 
 N DIFILNAM S DIFILNAM=$$GET1^DID(DIFILE,"","","NAME")
 N DIFLDNAM S DIFLDNAM=$$GET1^DID(DIFILE,DIFIELD,"","LABEL")
 D ERR^DICA3(712,DIFILE,"",DIFIELD,DIFLDNAM,DIFILNAM)
 Q
