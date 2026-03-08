DINIT00E ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,3021,0)
 ;;=3021^1^y^11^
 ;;^UTILITY(U,$J,.84,3021,1,0)
 ;;=^^1^1^2940811^^^
 ;;^UTILITY(U,$J,.84,3021,1,1,0)
 ;;=A lookup in to the Form file for the given form failed.
 ;;^UTILITY(U,$J,.84,3021,2,0)
 ;;=^^2^2^2940811^
 ;;^UTILITY(U,$J,.84,3021,2,1,0)
 ;;=Form |1| does not exist in the Form file, or DDSFILE is not the Primary
 ;;^UTILITY(U,$J,.84,3021,2,2,0)
 ;;=File of the form.
 ;;^UTILITY(U,$J,.84,3021,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,3021,3,1,0)
 ;;=1^Form name
 ;;^UTILITY(U,$J,.84,3022,0)
 ;;=3022^1^y^11^
 ;;^UTILITY(U,$J,.84,3022,1,0)
 ;;=^^1^1^2931130^^
 ;;^UTILITY(U,$J,.84,3022,1,1,0)
 ;;=There are no pages defined in the Page multiple of the given form.
 ;;^UTILITY(U,$J,.84,3022,2,0)
 ;;=^^1^1^2931130^^
 ;;^UTILITY(U,$J,.84,3022,2,1,0)
 ;;=Form |1| contains no pages.
 ;;^UTILITY(U,$J,.84,3022,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,3022,3,1,0)
 ;;=1^Form name
 ;;^UTILITY(U,$J,.84,3023,0)
 ;;=3023^1^y^11^
 ;;^UTILITY(U,$J,.84,3023,1,0)
 ;;=^^1^1^2931129^^
 ;;^UTILITY(U,$J,.84,3023,1,1,0)
 ;;=The given page was not found on the form.
 ;;^UTILITY(U,$J,.84,3023,2,0)
 ;;=^^1^1^2931129^^^
 ;;^UTILITY(U,$J,.84,3023,2,1,0)
 ;;=The form does not contain a page |1|.
 ;;^UTILITY(U,$J,.84,3023,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,3023,3,1,0)
 ;;=1^Page name or number
 ;;^UTILITY(U,$J,.84,3031,0)
 ;;=3031^1^y^11^
 ;;^UTILITY(U,$J,.84,3031,1,0)
 ;;=^^1^1^2931124^
 ;;^UTILITY(U,$J,.84,3031,1,1,0)
 ;;=The call to the specified ScreenMan utility failed.
 ;;^UTILITY(U,$J,.84,3031,2,0)
 ;;=^^1^1^2931124^
 ;;^UTILITY(U,$J,.84,3031,2,1,0)
 ;;=NOTE: The programmer call to the |1| ScreenMan utility failed.
 ;;^UTILITY(U,$J,.84,3031,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,3031,3,1,0)
 ;;=1^ScreenMan utility entry point.
 ;;^UTILITY(U,$J,.84,3041,0)
 ;;=3041^1^y^11^
 ;;^UTILITY(U,$J,.84,3041,1,0)
 ;;=^^1^1^2931130^^
 ;;^UTILITY(U,$J,.84,3041,1,1,0)
 ;;=Errors were encountered while attempting to load the page.
 ;;^UTILITY(U,$J,.84,3041,2,0)
 ;;=^^1^1^2931130^
 ;;^UTILITY(U,$J,.84,3041,2,1,0)
 ;;=Page |1| (|2|) could not be loaded.
 ;;^UTILITY(U,$J,.84,3041,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,3041,3,1,0)
 ;;=1^Page number
 ;;^UTILITY(U,$J,.84,3041,3,2,0)
 ;;=2^Page name
 ;;^UTILITY(U,$J,.84,3051,0)
 ;;=3051^1^y^11^
 ;;^UTILITY(U,$J,.84,3051,1,0)
 ;;=^^2^2^2931129^^^^
 ;;^UTILITY(U,$J,.84,3051,1,1,0)
 ;;=The block has no 0 node in the Block file or was not found in the "B"
 ;;^UTILITY(U,$J,.84,3051,1,2,0)
 ;;=index.
 ;;^UTILITY(U,$J,.84,3051,2,0)
 ;;=^^1^1^2931129^^^
 ;;^UTILITY(U,$J,.84,3051,2,1,0)
 ;;=Block |1| does not exist in the Block file.
 ;;^UTILITY(U,$J,.84,3051,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,3051,3,1,0)
 ;;=1^Block number or name
 ;;^UTILITY(U,$J,.84,3053,0)
 ;;=3053^1^y^11^
 ;;^UTILITY(U,$J,.84,3053,1,0)
 ;;=^^4^4^2931129^
 ;;^UTILITY(U,$J,.84,3053,1,1,0)
 ;;=The specified block was not found on the page.  For example, it was not
 ;;^UTILITY(U,$J,.84,3053,1,2,0)
 ;;=found in the "AC" or "B" index in the block multiple of the page multiple
 ;;^UTILITY(U,$J,.84,3053,1,3,0)
 ;;=of the Form file, or the 0 node of the block in the block multiple is
 ;;^UTILITY(U,$J,.84,3053,1,4,0)
 ;;=missing.
 ;;^UTILITY(U,$J,.84,3053,2,0)
 ;;=^^1^1^2931129^^
 ;;^UTILITY(U,$J,.84,3053,2,1,0)
 ;;=Block |1| was not found on page |2|.
 ;;^UTILITY(U,$J,.84,3053,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,3053,3,1,0)
 ;;=1^Block order, name, or number
 ;;^UTILITY(U,$J,.84,3053,3,2,0)
 ;;=2^Page number and/or name
 ;;^UTILITY(U,$J,.84,3055,0)
 ;;=3055^1^y^11^
 ;;^UTILITY(U,$J,.84,3055,1,0)
 ;;=^^1^1^2931129^^^
 ;;^UTILITY(U,$J,.84,3055,1,1,0)
 ;;=There are no blocks defined on the page.
 ;;^UTILITY(U,$J,.84,3055,2,0)
 ;;=^^1^1^2931129^^^
 ;;^UTILITY(U,$J,.84,3055,2,1,0)
 ;;=There are no blocks defined on page |1|.
 ;;^UTILITY(U,$J,.84,3055,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,3055,3,1,0)
 ;;=1^Page name and/or number
 ;;^UTILITY(U,$J,.84,3071,0)
 ;;=3071^1^y^11^
 ;;^UTILITY(U,$J,.84,3071,1,0)
 ;;=^^1^1^2931129^^^
 ;;^UTILITY(U,$J,.84,3071,1,1,0)
 ;;=The specified block has no fields on it.
 ;;^UTILITY(U,$J,.84,3071,2,0)
 ;;=^^1^1^2931129^^
 ;;^UTILITY(U,$J,.84,3071,2,1,0)
 ;;=There are no fields defined on block |1|.
 ;;^UTILITY(U,$J,.84,3071,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,3071,3,1,0)
 ;;=1^Block name
 ;;^UTILITY(U,$J,.84,3072,0)
 ;;=3072^1^y^11^
 ;;^UTILITY(U,$J,.84,3072,1,0)
 ;;=^^1^1^2931129^
