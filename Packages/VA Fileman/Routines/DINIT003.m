DINIT003 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.844,0)
 ;;=TEXT SUB-FIELD^^.01^1
 ;;^DD(.844,0,"DT")
 ;;=2930811
 ;;^DD(.844,0,"NM","TEXT")
 ;;=
 ;;^DD(.844,0,"UP")
 ;;=.84
 ;;^DD(.844,.01,0)
 ;;=TEXT^WL^^0;1^Q
 ;;^DD(.844,.01,3)
 ;;=Enter the actual text of the dialogue, with optional parameter windows.
 ;;^DD(.844,.01,"DT")
 ;;=2930811
 ;;^DD(.845,0)
 ;;=PARAMETER SUB-FIELD^^1^2
 ;;^DD(.845,0,"DT")
 ;;=2931105
 ;;^DD(.845,0,"IX","B",.845,.01)
 ;;=
 ;;^DD(.845,0,"NM","PARAMETER")
 ;;=
 ;;^DD(.845,0,"UP")
 ;;=.84
 ;;^DD(.845,.01,0)
 ;;=PARAMETER SUBSCRIPT^MF^^0;1^K:$L(X)>20!($L(X)<1) X
 ;;^DD(.845,.01,1,0)
 ;;=^.1
 ;;^DD(.845,.01,1,1,0)
 ;;=.845^B
 ;;^DD(.845,.01,1,1,1)
 ;;=S ^DI(.84,DA(1),3,"B",$E(X,1,30),DA)=""
 ;;^DD(.845,.01,1,1,2)
 ;;=K ^DI(.84,DA(1),3,"B",$E(X,1,30),DA)
 ;;^DD(.845,.01,3)
 ;;=This entry corresponds to the subscript of an entry in either the text or output parameter list to the BLD^DIALOG and $$EZBLD^DIALOG routine.  Answer must be 1-20 characters in length.
 ;;^DD(.845,.01,21,0)
 ;;=^^7^7^2941122^
 ;;^DD(.845,.01,21,1,0)
 ;;=This multiple is used for documentation purposes only.  The entry in the
 ;;^DD(.845,.01,21,2,0)
 ;;=.01 field of this multiple will correspond to a subscript in either the
 ;;^DD(.845,.01,21,3,0)
 ;;=text or output parameter list, that are passed to the routines that build
 ;;^DD(.845,.01,21,4,0)
 ;;=dialogue messages, BLD^DIALOG and $$EZBLD^DIALOG. This routine will insert
 ;;^DD(.845,.01,21,5,0)
 ;;=into each 'window' from the TEXT field, the corresponding entry out of the
 ;;^DD(.845,.01,21,6,0)
 ;;=text parameter list.  For errors only, it passes any entries from the
 ;;^DD(.845,.01,21,7,0)
 ;;=output parameter list back to the user as entries in its output array.
 ;;^DD(.845,.01,"DT")
 ;;=2931105
 ;;^DD(.845,1,0)
 ;;=PARAMETER DESCRIPTION^F^^0;2^K:$L(X)>230!($L(X)<1) X
 ;;^DD(.845,1,3)
 ;;=Describe the Parameter for documentation purposes.  Answer must be 1-230 characters in length.
 ;;^DD(.845,1,21,0)
 ;;=^^5^5^2941122^
 ;;^DD(.845,1,21,1,0)
 ;;=This field is used for documentation purposes only.  It describes the text
 ;;^DD(.845,1,21,2,0)
 ;;=and/or output parameter(s) that are passed to BLD^DIALOG and
 ;;^DD(.845,1,21,3,0)
 ;;=$$EZBLD^DIALOG. The same parameter can be used both as a text parameter
 ;;^DD(.845,1,21,4,0)
 ;;=(i.e., inserted into the text when it is built), and as an output
 ;;^DD(.845,1,21,5,0)
 ;;=parameter (i.e., a parameter passed back in a list to the user)
 ;;^DD(.845,1,"DT")
 ;;=2930614
 ;;^DD(.847,0)
 ;;=TRANSLATION SUB-FIELD^^1^2
 ;;^DD(.847,0,"DT")
 ;;=2940524
 ;;^DD(.847,0,"IX","B",.847,.01)
 ;;=
 ;;^DD(.847,0,"NM","TRANSLATION")
 ;;=
 ;;^DD(.847,0,"UP")
 ;;=.84
 ;;^DD(.847,.01,0)
 ;;=LANGUAGE^M*P.85'X^DI(.85,^0;1^S DIC("S")="I Y>1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X S:$G(X) DINUM=X
 ;;^DD(.847,.01,1,0)
 ;;=^.1
 ;;^DD(.847,.01,1,1,0)
 ;;=.847^B
 ;;^DD(.847,.01,1,1,1)
 ;;=S ^DI(.84,DA(1),4,"B",$E(X,1,30),DA)=""
 ;;^DD(.847,.01,1,1,2)
 ;;=K ^DI(.84,DA(1),4,"B",$E(X,1,30),DA)
 ;;^DD(.847,.01,3)
 ;;=Enter the number or name for a non-English language.
 ;;^DD(.847,.01,12)
 ;;=English language cannot be selected.
 ;;^DD(.847,.01,12.1)
 ;;=S DIC("S")="I Y>1"
 ;;^DD(.847,.01,21,0)
 ;;=^^3^3^2941118^^
 ;;^DD(.847,.01,21,1,0)
 ;;=Pointer to the LANGUAGE file. If FileMan system variable DUZ("LANG") is
 ;;^DD(.847,.01,21,2,0)
 ;;=set to an integer greater than 1, we use that number to extract dialogue
 ;;^DD(.847,.01,21,3,0)
 ;;=text for the specified language from this multiple.
 ;;^DD(.847,.01,"DT")
 ;;=2940524
 ;;^DD(.847,1,0)
 ;;=FOREIGN TEXT^.8471^^1;0
 ;;^DD(.847,1,21,0)
 ;;=^^3^3^2941118^
 ;;^DD(.847,1,21,1,0)
 ;;=Insert here the non-English equivalent for this language to the text in
 ;;^DD(.847,1,21,2,0)
 ;;=the TEXT field for this entry.  This field may contain windows for
 ;;^DD(.847,1,21,3,0)
 ;;=variable parameters the same as the TEXT field.
 ;;^DD(.8471,0)
 ;;=FOREIGN TEXT SUB-FIELD^^.01^1
 ;;^DD(.8471,0,"DT")
 ;;=2930811
 ;;^DD(.8471,0,"NM","FOREIGN TEXT")
 ;;=
 ;;^DD(.8471,0,"UP")
 ;;=.847
 ;;^DD(.8471,.01,0)
 ;;=FOREIGN TEXT^WL^^0;1^Q
 ;;^DD(.8471,.01,3)
 ;;=Enter the non-English dialog text
 ;;^DD(.8471,.01,"DT")
 ;;=2930811
