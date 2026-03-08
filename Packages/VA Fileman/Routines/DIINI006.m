DIINI006 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",321,0)
 ;;=DIFG CREATE^Create/Edit Filegram Template^^A^^XUFILEGRAM^^^^^^^^1^^
 ;;^UTILITY(U,$J,"OPT",321,1,0)
 ;;=^^4^4^2900124^
 ;;^UTILITY(U,$J,"OPT",321,1,1,0)
 ;;=Use this option to create a filegram template or edit an existing
 ;;^UTILITY(U,$J,"OPT",321,1,2,0)
 ;;=filegram template.  This option is the first step in developing a
 ;;^UTILITY(U,$J,"OPT",321,1,3,0)
 ;;=filegram and is very important since there won't be filegrams without
 ;;^UTILITY(U,$J,"OPT",321,1,4,0)
 ;;=this template.
 ;;^UTILITY(U,$J,"OPT",321,20)
 ;;=S DI=1 D EN^DIFGO
 ;;^UTILITY(U,$J,"OPT",321,"U")
 ;;=CREATE/EDIT FILEGRAM TEMPLATE
 ;;^UTILITY(U,$J,"OPT",322,0)
 ;;=DIFG DISPLAY^Display Filegram Template^^A^^XUFILEGRAM^^^^^^^^1^^
 ;;^UTILITY(U,$J,"OPT",322,1,0)
 ;;=^^2^2^2900124^
 ;;^UTILITY(U,$J,"OPT",322,1,1,0)
 ;;=Use this option to display the filegram template in a two-column
 ;;^UTILITY(U,$J,"OPT",322,1,2,0)
 ;;=format (similar to FileMan's Inquire to File Entries option).
 ;;^UTILITY(U,$J,"OPT",322,20)
 ;;=S DI=2 D EN^DIFGO
 ;;^UTILITY(U,$J,"OPT",322,"U")
 ;;=DISPLAY FILEGRAM TEMPLATE
 ;;^UTILITY(U,$J,"OPT",323,0)
 ;;=DIFG GENERATE^Generate Filegram^^A^^XUFILEGRAM^^^^^^^^1^^
 ;;^UTILITY(U,$J,"OPT",323,1,0)
 ;;=^^3^3^2900124^
 ;;^UTILITY(U,$J,"OPT",323,1,1,0)
 ;;=Use this option to generate a filegram into a MailMan message after
 ;;^UTILITY(U,$J,"OPT",323,1,2,0)
 ;;=selecting the file, filegram template and an entry.  It's a good idea
 ;;^UTILITY(U,$J,"OPT",323,1,3,0)
 ;;=to know that information before using this option.
 ;;^UTILITY(U,$J,"OPT",323,20)
 ;;=S DI=3 D EN^DIFGO
 ;;^UTILITY(U,$J,"OPT",323,"U")
 ;;=GENERATE FILEGRAM
 ;;^UTILITY(U,$J,"OPT",324,0)
 ;;=DIFG VIEW^View Filegram^^A^^^^^^^^^^1^^
 ;;^UTILITY(U,$J,"OPT",324,1,0)
 ;;=^^1^1^2900124^
 ;;^UTILITY(U,$J,"OPT",324,1,1,0)
 ;;=Use this option to view the filegram in filegram format.
 ;;^UTILITY(U,$J,"OPT",324,20)
 ;;=S DI=4 D EN^DIFGO
 ;;^UTILITY(U,$J,"OPT",324,"U")
 ;;=VIEW FILEGRAM
 ;;^UTILITY(U,$J,"OPT",325,0)
 ;;=DIFG SPECIFIERS^Specifiers^^A^^XUFILEGRAM^^^^^^^^1^^
 ;;^UTILITY(U,$J,"OPT",325,1,0)
 ;;=^^6^6^2900124^
 ;;^UTILITY(U,$J,"OPT",325,1,1,0)
 ;;=Use this option to identify a particular field in the file as a
 ;;^UTILITY(U,$J,"OPT",325,1,2,0)
 ;;=reference point for FileMan to use when installing the filegram.
 ;;^UTILITY(U,$J,"OPT",325,1,3,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",325,1,4,0)
 ;;=Specifiers can be compared to FileMan's identifier, unlike identifiers
 ;;^UTILITY(U,$J,"OPT",325,1,5,0)
 ;;=which are used for interaction purposes...specifiers are used for
 ;;^UTILITY(U,$J,"OPT",325,1,6,0)
 ;;=transaction purposes.
 ;;^UTILITY(U,$J,"OPT",325,20)
 ;;=S DI=5 D EN^DIFGO
 ;;^UTILITY(U,$J,"OPT",325,"U")
 ;;=SPECIFIERS
 ;;^UTILITY(U,$J,"OPT",326,0)
 ;;=DIFG INSTALL^Install/Verify Filegram^^A^^XUFILEGRAM^^^^^^^^1^^
 ;;^UTILITY(U,$J,"OPT",326,1,0)
 ;;=^^2^2^2900124^^
 ;;^UTILITY(U,$J,"OPT",326,1,1,0)
 ;;=Use this option to install the filegram in a FileMan file
 ;;^UTILITY(U,$J,"OPT",326,1,2,0)
 ;;=from a MailMan message format.  A message of verification should return.
 ;;^UTILITY(U,$J,"OPT",326,20)
 ;;=S DI=6 D EN^DIFGO
 ;;^UTILITY(U,$J,"OPT",326,"U")
 ;;=INSTALL/VERIFY FILEGRAM
 ;;^UTILITY(U,$J,"OPT",327,0)
 ;;=DIFG^Filegrams^^M^^XUFILEGRAM^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",327,1,0)
 ;;=^^1^1^2900124^^^
 ;;^UTILITY(U,$J,"OPT",327,1,1,0)
 ;;=This is a menu of the Filegram options.
 ;;^UTILITY(U,$J,"OPT",327,10,0)
 ;;=^19.01IP^6^6
 ;;^UTILITY(U,$J,"OPT",327,10,1,0)
 ;;=321^^1
 ;;^UTILITY(U,$J,"OPT",327,10,1,"^")
 ;;=DIFG CREATE
 ;;^UTILITY(U,$J,"OPT",327,10,2,0)
 ;;=322^^2
 ;;^UTILITY(U,$J,"OPT",327,10,2,"^")
 ;;=DIFG DISPLAY
 ;;^UTILITY(U,$J,"OPT",327,10,3,0)
 ;;=323^^3
 ;;^UTILITY(U,$J,"OPT",327,10,3,"^")
 ;;=DIFG GENERATE
 ;;^UTILITY(U,$J,"OPT",327,10,4,0)
 ;;=324^^4
 ;;^UTILITY(U,$J,"OPT",327,10,4,"^")
 ;;=DIFG VIEW
 ;;^UTILITY(U,$J,"OPT",327,10,5,0)
 ;;=325^^5
 ;;^UTILITY(U,$J,"OPT",327,10,5,"^")
 ;;=DIFG SPECIFIERS
 ;;^UTILITY(U,$J,"OPT",327,10,6,0)
 ;;=326^^6
 ;;^UTILITY(U,$J,"OPT",327,10,6,"^")
 ;;=DIFG INSTALL
 ;;^UTILITY(U,$J,"OPT",327,99)
 ;;=55633,47328
 ;;^UTILITY(U,$J,"OPT",327,99.1)
 ;;=54674,36753
 ;;^UTILITY(U,$J,"OPT",327,"U")
 ;;=FILEGRAMS
 ;;^UTILITY(U,$J,"OPT",336,0)
 ;;=DIFIELD CHECK^Mandatory/Required Field Check^^A^^^^^^^^^^1
 ;;^UTILITY(U,$J,"OPT",336,1,0)
 ;;=^^1^1^2901205^
 ;;^UTILITY(U,$J,"OPT",336,1,1,0)
 ;;=Kernel option to emulate the VA FileMan option to check fields for required data.
