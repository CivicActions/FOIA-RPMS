DIINI00A ; ;6/20/96  13:54 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**12**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",405,20)
 ;;=D 5^DDXP
 ;;^UTILITY(U,$J,"OPT",405,"U")
 ;;=PRINT FORMAT DOCUMENTATION
 ;;^UTILITY(U,$J,"OPT",407,0)
 ;;=DI SORT COMPILE^Sort Template Compile/Uncompile^^R^^^^^^^^VA FILEMAN
 ;;^UTILITY(U,$J,"OPT",407,1,0)
 ;;=^^3^3^2930715^^
 ;;^UTILITY(U,$J,"OPT",407,1,1,0)
 ;;=This option allows the user to mark a Sort Template compiled or uncompiled.
 ;;^UTILITY(U,$J,"OPT",407,1,2,0)
 ;;=The actual routine compilation occurs when the template is used during
 ;;^UTILITY(U,$J,"OPT",407,1,3,0)
 ;;=FileMan Sort/Print.
 ;;^UTILITY(U,$J,"OPT",407,25)
 ;;=EN1^DIOZ
 ;;^UTILITY(U,$J,"OPT",407,"U")
 ;;=SORT TEMPLATE COMPILE/UNCOMPIL
 ;;^UTILITY(U,$J,"OPT",503,0)
 ;;=DDBROWSER^Browser^^R^^^^^^^^VA FILEMAN
 ;;^UTILITY(U,$J,"OPT",503,1,0)
 ;;=^^3^3^2940519^
 ;;^UTILITY(U,$J,"OPT",503,1,1,0)
 ;;=Prompts user to select file, word processing field and entry.
 ;;^UTILITY(U,$J,"OPT",503,1,2,0)
 ;;=The text is then displayed to the screen, allowing the user to
 ;;^UTILITY(U,$J,"OPT",503,1,3,0)
 ;;=navigate through the document.
 ;;^UTILITY(U,$J,"OPT",503,25)
 ;;=DDBR
 ;;^UTILITY(U,$J,"OPT",503,99.1)
 ;;=56123,39787
 ;;^UTILITY(U,$J,"OPT",503,"U")
 ;;=BROWSER
 ;;^UTILITY(U,$J,"OPT",509,0)
 ;;=DDS DELETE A FORM^Delete a Form^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",509,1,0)
 ;;=^^1^1^2940630^^
 ;;^UTILITY(U,$J,"OPT",509,1,1,0)
 ;;=An option to delete a form.
 ;;^UTILITY(U,$J,"OPT",509,25)
 ;;=3^DDSOPT
 ;;^UTILITY(U,$J,"OPT",509,99.1)
 ;;=56123,39787
 ;;^UTILITY(U,$J,"OPT",509,"U")
 ;;=DELETE A FORM
 ;;^UTILITY(U,$J,"OPT",510,0)
 ;;=DDS PURGE UNUSED BLOCKS^Purge Unused Blocks^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",510,1,0)
 ;;=^^3^3^2940630^
 ;;^UTILITY(U,$J,"OPT",510,1,1,0)
 ;;=An option to delete blocks that aren't used on any forms.  This option
 ;;^UTILITY(U,$J,"OPT",510,1,2,0)
 ;;=prompts for file, and searches the Block File for all blocks that are
 ;;^UTILITY(U,$J,"OPT",510,1,3,0)
 ;;=associated with that file and that aren't used on any forms.
 ;;^UTILITY(U,$J,"OPT",510,25)
 ;;=4^DDSOPT
 ;;^UTILITY(U,$J,"OPT",510,99.1)
 ;;=56123,39787
 ;;^UTILITY(U,$J,"OPT",510,"U")
 ;;=PURGE UNUSED BLOCKS
 ;;^UTILITY(U,$J,"PKG",11,0)
 ;;=VA FILEMAN^DI^FM INIT
