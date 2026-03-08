DINIT00F ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,3072,1,1,0)
 ;;=The specified field was not found on the block.
 ;;^UTILITY(U,$J,.84,3072,2,0)
 ;;=^^1^1^2931129^
 ;;^UTILITY(U,$J,.84,3072,2,1,0)
 ;;=Field |1| was not found on block |2|.
 ;;^UTILITY(U,$J,.84,3072,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,3072,3,1,0)
 ;;=1^Field order, number, caption, or unique name
 ;;^UTILITY(U,$J,.84,3072,3,2,0)
 ;;=2^Block name
 ;;^UTILITY(U,$J,.84,3081,0)
 ;;=3081^1^^11
 ;;^UTILITY(U,$J,.84,3081,1,0)
 ;;=^^2^2^2931201^^
 ;;^UTILITY(U,$J,.84,3081,1,1,0)
 ;;=The field specified by FO(field) in the pointer link or computed expression
 ;;^UTILITY(U,$J,.84,3081,1,2,0)
 ;;=is not a form only field.
 ;;^UTILITY(U,$J,.84,3081,2,0)
 ;;=^^1^1^2931201^^
 ;;^UTILITY(U,$J,.84,3081,2,1,0)
 ;;=The specified field is not a form-only field.
 ;;^UTILITY(U,$J,.84,3082,0)
 ;;=3082^1^^11
 ;;^UTILITY(U,$J,.84,3082,1,0)
 ;;=^^3^3^2931203^
 ;;^UTILITY(U,$J,.84,3082,1,1,0)
 ;;=The field, block, and/or page is missing or invalid in the expression
 ;;^UTILITY(U,$J,.84,3082,1,2,0)
 ;;=FO(field,block,page), used in the pointer link, parent field, or computed
 ;;^UTILITY(U,$J,.84,3082,1,3,0)
 ;;=expression.
 ;;^UTILITY(U,$J,.84,3082,2,0)
 ;;=^^1^1^2931203^
 ;;^UTILITY(U,$J,.84,3082,2,1,0)
 ;;=Parameters are missing or invalid in an FO() expression.
 ;;^UTILITY(U,$J,.84,3083,0)
 ;;=3083^1^^11
 ;;^UTILITY(U,$J,.84,3083,1,0)
 ;;=^^1^1^2931203^^
 ;;^UTILITY(U,$J,.84,3083,1,1,0)
 ;;=The relational expression is incomplete.
 ;;^UTILITY(U,$J,.84,3083,2,0)
 ;;=^^1^1^2931203^^
 ;;^UTILITY(U,$J,.84,3083,2,1,0)
 ;;=The relational expression is incomplete.
 ;;^UTILITY(U,$J,.84,3084,0)
 ;;=3084^1^^11
 ;;^UTILITY(U,$J,.84,3084,1,0)
 ;;=^^3^3^2931203^^
 ;;^UTILITY(U,$J,.84,3084,1,1,0)
 ;;=In a computed expression, a form-only field should be referenced as
 ;;^UTILITY(U,$J,.84,3084,1,2,0)
 ;;={FO(field,block)} or {FO(field)}.  The page parameter should not be
 ;;^UTILITY(U,$J,.84,3084,1,3,0)
 ;;=included.
 ;;^UTILITY(U,$J,.84,3084,2,0)
 ;;=^^1^1^2931203^^
 ;;^UTILITY(U,$J,.84,3084,2,1,0)
 ;;=The FO() expression should not contain a page parameter.
 ;;^UTILITY(U,$J,.84,3085,0)
 ;;=3085^1^^11
 ;;^UTILITY(U,$J,.84,3085,1,0)
 ;;=^^3^3^2931203^
 ;;^UTILITY(U,$J,.84,3085,1,1,0)
 ;;=In a computed expression, a form-only field should be referenced as
 ;;^UTILITY(U,$J,.84,3085,1,2,0)
 ;;={FO(field,block)} or {FO(field)}.  The block parameter should be
 ;;^UTILITY(U,$J,.84,3085,1,3,0)
 ;;=either the block name or `block number.  It should not be a block order.
 ;;^UTILITY(U,$J,.84,3085,2,0)
 ;;=^^1^1^2931203^^
 ;;^UTILITY(U,$J,.84,3085,2,1,0)
 ;;=The FO() expression should not use block order to specify a block.
 ;;^UTILITY(U,$J,.84,3086,0)
 ;;=3086^1^^11
 ;;^UTILITY(U,$J,.84,3086,1,0)
 ;;=^^2^2^2940708^^
 ;;^UTILITY(U,$J,.84,3086,1,1,0)
 ;;=Reject calls to PUT^DDSVAL which attempt to set the .01 field of a file to
 ;;^UTILITY(U,$J,.84,3086,1,2,0)
 ;;="" or "@".
 ;;^UTILITY(U,$J,.84,3086,2,0)
 ;;=^^1^1^2940708^^^
 ;;^UTILITY(U,$J,.84,3086,2,1,0)
 ;;=PUT^DDSVAL cannot be used to delete an entry.
 ;;^UTILITY(U,$J,.84,3091,0)
 ;;=3091^1^^11
 ;;^UTILITY(U,$J,.84,3091,1,0)
 ;;=^^1^1^2930722^
 ;;^UTILITY(U,$J,.84,3091,1,1,0)
 ;;=The data could not be filed.
 ;;^UTILITY(U,$J,.84,3091,2,0)
 ;;=^^1^1^2931202^^
 ;;^UTILITY(U,$J,.84,3091,2,1,0)
 ;;=THE DATA COULD NOT BE FILED.
 ;;^UTILITY(U,$J,.84,3092,0)
 ;;=3092^1^y^11^
 ;;^UTILITY(U,$J,.84,3092,1,0)
 ;;=^^1^1^2940713^^^^
 ;;^UTILITY(U,$J,.84,3092,1,1,0)
 ;;=The given field is required and its current value is null.
 ;;^UTILITY(U,$J,.84,3092,2,0)
 ;;=^^1^1^2940713^^^
 ;;^UTILITY(U,$J,.84,3092,2,1,0)
 ;;=|1|, |2| is a required field |3|
 ;;^UTILITY(U,$J,.84,3092,3,0)
 ;;=^.845^3^3
 ;;^UTILITY(U,$J,.84,3092,3,1,0)
 ;;=1^Page name
 ;;^UTILITY(U,$J,.84,3092,3,2,0)
 ;;=2^Caption
 ;;^UTILITY(U,$J,.84,3092,3,3,0)
 ;;=3^Subrecord name in parentheses
 ;;^UTILITY(U,$J,.84,7001,0)
 ;;=7001^2^^11
 ;;^UTILITY(U,$J,.84,7001,1,0)
 ;;=^^1^1^2940314^^^
 ;;^UTILITY(U,$J,.84,7001,1,1,0)
 ;;=This is the general Yes/No Prompt
 ;;^UTILITY(U,$J,.84,7001,2,0)
 ;;=^^1^1^2940314^^^
 ;;^UTILITY(U,$J,.84,7001,2,1,0)
 ;;=Yes^No
 ;;^UTILITY(U,$J,.84,7001,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,7002,0)
 ;;=7002^2^^11
 ;;^UTILITY(U,$J,.84,7002,1,0)
 ;;=^^1^1^2940314^^^
 ;;^UTILITY(U,$J,.84,7002,1,1,0)
 ;;=Insert/Replace Switch
 ;;^UTILITY(U,$J,.84,7002,2,0)
 ;;=^^1^1^2940314^^
 ;;^UTILITY(U,$J,.84,7002,2,1,0)
 ;;=Insert ^Replace
