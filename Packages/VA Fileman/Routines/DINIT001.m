DINIT001 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DIC(.84,0,"GL")
 ;;=^DI(.84,
 ;;^DIC("B","DIALOG",.84)
 ;;=
 ;;^DIC(.84,"%D",0)
 ;;=^^8^8^2941121^^^^
 ;;^DIC(.84,"%D",1,0)
 ;;=This file stores the dialog used to 'talk' to a user (error messages,
 ;;^DIC(.84,"%D",2,0)
 ;;=help text, and other prompts.) Entry points in the ^DIALOG routine
 ;;^DIC(.84,"%D",3,0)
 ;;=retrieve text from this file.  Variable parameters can be passed to these
 ;;^DIC(.84,"%D",4,0)
 ;;=calls.  The parameters are inserted into windows within the text as it is
 ;;^DIC(.84,"%D",5,0)
 ;;=built.  The text is returned in an array.  This file and associated calls
 ;;^DIC(.84,"%D",6,0)
 ;;=can be used by any package to pass information in arrays rather than
 ;;^DIC(.84,"%D",7,0)
 ;;=writing to the current device.  Record numbers 1 through 10000 are
 ;;^DIC(.84,"%D",8,0)
 ;;=reserved for VA FileMan.
 ;;^DD(.84,0)
 ;;=FIELD^^1.2^10
 ;;^DD(.84,0,"DT")
 ;;=2940526
 ;;^DD(.84,0,"ID","WRITE")
 ;;=N DIALID S DIALID=$O(^(2,0)) S:DIALID DIALID(1)=$E($G(^(DIALID,0)),1,42),DIALID(1,"F")="?10" D EN^DDIOL(.DIALID)
 ;;^DD(.84,0,"IX","B",.84,.01)
 ;;=
 ;;^DD(.84,0,"IX","C",.84,1.2)
 ;;=
 ;;^DD(.84,0,"NM","DIALOG")
 ;;=
 ;;^DD(.84,.01,0)
 ;;=DIALOG NUMBER^RNJ13,3X^^0;1^K:+X'=X!(X>999999999.999)!(('$G(DIFROM))&(X<10000.001))!(X?.E1"."4N.N) X S:$G(X) DINUM=X
 ;;^DD(.84,.01,1,0)
 ;;=^.1
 ;;^DD(.84,.01,1,1,0)
 ;;=.84^B
 ;;^DD(.84,.01,1,1,1)
 ;;=S ^DI(.84,"B",$E(X,1,30),DA)=""
 ;;^DD(.84,.01,1,1,2)
 ;;=K ^DI(.84,"B",$E(X,1,30),DA)
 ;;^DD(.84,.01,3)
 ;;=Type a Number between 10000.001 and 999999999.999, up to 3 Decimal Digits
 ;;^DD(.84,.01,21,0)
 ;;=^^1^1^2940523^
 ;;^DD(.84,.01,21,1,0)
 ;;=The dialogue number is used to uniquely identify a message.
 ;;^DD(.84,.01,"DT")
 ;;=2940623
 ;;^DD(.84,1,0)
 ;;=TYPE^RS^1:ERROR;2:GENERAL MESSAGE;3:HELP;^0;2^Q
 ;;^DD(.84,1,3)
 ;;=Enter code that reflects how this dialogue is used when talking to the users.
 ;;^DD(.84,1,21,0)
 ;;=^^2^2^2940523^
 ;;^DD(.84,1,21,1,0)
 ;;=This code is used to group the entries in the FileMan DIALOG file,
 ;;^DD(.84,1,21,2,0)
 ;;=according to how they are used when interacting with the user.
 ;;^DD(.84,1,23,0)
 ;;=^^3^3^2940523^
 ;;^DD(.84,1,23,1,0)
 ;;=This field is used to tell the DIALOG routines what array to use in
 ;;^DD(.84,1,23,2,0)
 ;;=returning the dialogue.  It is also used for grouping the dialogue for
 ;;^DD(.84,1,23,3,0)
 ;;=reporting purposes.
 ;;^DD(.84,1,"DT")
 ;;=2940523
 ;;^DD(.84,1.2,0)
 ;;=PACKAGE^RP9.4'^DIC(9.4,^0;4^Q
 ;;^DD(.84,1.2,1,0)
 ;;=^.1
 ;;^DD(.84,1.2,1,1,0)
 ;;=.84^C
 ;;^DD(.84,1.2,1,1,1)
 ;;=S ^DI(.84,"C",$E(X,1,30),DA)=""
 ;;^DD(.84,1.2,1,1,2)
 ;;=K ^DI(.84,"C",$E(X,1,30),DA)
 ;;^DD(.84,1.2,1,1,"%D",0)
 ;;=^^3^3^2940623^
 ;;^DD(.84,1.2,1,1,"%D",1,0)
 ;;=Cross-reference on Package file.  Used for identifying DIALOG entries by
 ;;^DD(.84,1.2,1,1,"%D",2,0)
 ;;=the package that owns the entry, and for populating the BUILD file during
 ;;^DD(.84,1.2,1,1,"%D",3,0)
 ;;=package distribution.
 ;;^DD(.84,1.2,1,1,"DT")
 ;;=2940623
 ;;^DD(.84,1.2,3)
 ;;=Enter the name of the Package that owns and distributes this entry.
 ;;^DD(.84,1.2,21,0)
 ;;=^^3^3^2940526^
 ;;^DD(.84,1.2,21,1,0)
 ;;=This is a pointer to the Package file.  Each entry in this file belongs
 ;;^DD(.84,1.2,21,2,0)
 ;;=to, and is distributed by, a certain package.  The Package field should be
 ;;^DD(.84,1.2,21,3,0)
 ;;=filled in for each entry on this file.
 ;;^DD(.84,1.2,"DT")
 ;;=2940623
 ;;^DD(.84,2,0)
 ;;=DESCRIPTION^.842^^1;0
 ;;^DD(.84,2,21,0)
 ;;=^^1^1^2930824^^
 ;;^DD(.84,2,21,1,0)
 ;;=  Used for internal documentation purposes.
 ;;^DD(.84,3,0)
 ;;=INTERNAL PARAMETERS NEEDED^S^y:YES;^0;3^Q
 ;;^DD(.84,3,3)
 ;;=
 ;;^DD(.84,3,21,0)
 ;;=^^6^6^2931105^
 ;;^DD(.84,3,21,1,0)
 ;;=  Some dialogue is built by inserting variable text (internal parameters)
 ;;^DD(.84,3,21,2,0)
 ;;=into windows in the word-processing TEXT field.  The insertable text might
 ;;^DD(.84,3,21,3,0)
 ;;=be, for example, File or Field names.  This field should be set to YES if
 ;;^DD(.84,3,21,4,0)
 ;;=any internal parameters need to be inserted into the TEXT.  If the field
 ;;^DD(.84,3,21,5,0)
 ;;=is not set to YES, the DIALOG routine will not go through the part of the
 ;;^DD(.84,3,21,6,0)
 ;;=code that stuffs the internal parameters into the text.
 ;;^DD(.84,3,"DT")
 ;;=2931105
 ;;^DD(.84,4,0)
 ;;=TEXT^.844^^2;0
 ;;^DD(.84,4,21,0)
 ;;=^^7^7^2941122^
