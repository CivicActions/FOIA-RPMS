DINIT007 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,330,3,1,0)
 ;;=1^Passed Value.
 ;;^UTILITY(U,$J,.84,330,3,2,0)
 ;;=2^Data Type.
 ;;^UTILITY(U,$J,.84,348,0)
 ;;=348^1^y^11^
 ;;^UTILITY(U,$J,.84,348,1,0)
 ;;=^^2^2^2940214^
 ;;^UTILITY(U,$J,.84,348,1,1,0)
 ;;=The calling application passed us a variable pointer value. That value
 ;;^UTILITY(U,$J,.84,348,1,2,0)
 ;;=points to a file that does not exist, or that lacks a Header Node.
 ;;^UTILITY(U,$J,.84,348,2,0)
 ;;=^^2^2^2940214^
 ;;^UTILITY(U,$J,.84,348,2,1,0)
 ;;=The passed value '|1|' points to a file that does not exist or lacks a
 ;;^UTILITY(U,$J,.84,348,2,2,0)
 ;;=Header Node.
 ;;^UTILITY(U,$J,.84,348,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,348,3,1,0)
 ;;=1^Passed Value.
 ;;^UTILITY(U,$J,.84,349,0)
 ;;=349^2^y^11^
 ;;^UTILITY(U,$J,.84,349,1,0)
 ;;=^^2^2^2940310^^^
 ;;^UTILITY(U,$J,.84,349,1,1,0)
 ;;=Text used by the Replace...With editor
 ;;^UTILITY(U,$J,.84,349,1,2,0)
 ;;=Note: Dialog will be used with $$EZBLD^DIALOG call, only one text line!!
 ;;^UTILITY(U,$J,.84,349,2,0)
 ;;=^^1^1^2940310^^
 ;;^UTILITY(U,$J,.84,349,2,1,0)
 ;;= String too long by |1| character(s)!
 ;;^UTILITY(U,$J,.84,349,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,349,3,1,0)
 ;;=1^Number of characters over the limit.
 ;;^UTILITY(U,$J,.84,349,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,350,0)
 ;;=350^2^^11
 ;;^UTILITY(U,$J,.84,350,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,350,1,1,0)
 ;;=Message from the Replace...With editor.
 ;;^UTILITY(U,$J,.84,350,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,350,2,1,0)
 ;;= String too long! '^' to quit.
 ;;^UTILITY(U,$J,.84,350,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,351,0)
 ;;=351^1^y^11
 ;;^UTILITY(U,$J,.84,351,1,0)
 ;;=^^4^4^2941021^
 ;;^UTILITY(U,$J,.84,351,1,1,0)
 ;;=When passing an FDA to the Updater, any entries intended as Finding or
 ;;^UTILITY(U,$J,.84,351,1,2,0)
 ;;=LAYGO Finding nodes must include a .01 node that has the lookup value.
 ;;^UTILITY(U,$J,.84,351,1,3,0)
 ;;=This value need not be a legitimate .01 field value, but it must be a
 ;;^UTILITY(U,$J,.84,351,1,4,0)
 ;;=valid and unambiguous lookup value for the file.
 ;;^UTILITY(U,$J,.84,351,2,0)
 ;;=^^1^1^2941021^
 ;;^UTILITY(U,$J,.84,351,2,1,0)
 ;;=FDA nodes for lookup '|IENS|' omit a .01 node with a lookup value.
 ;;^UTILITY(U,$J,.84,351,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,351,3,1,0)
 ;;=FILE^File #.
 ;;^UTILITY(U,$J,.84,351,3,2,0)
 ;;=IENS^IENS Subscript for Finding or LAYGO Finding node.
 ;;^UTILITY(U,$J,.84,401,0)
 ;;=401^1^y^11^
 ;;^UTILITY(U,$J,.84,401,1,0)
 ;;=^^2^2^2931123^^^
 ;;^UTILITY(U,$J,.84,401,1,1,0)
 ;;=The specified file or subfile does not exist; it is not present in the 
 ;;^UTILITY(U,$J,.84,401,1,2,0)
 ;;=data dictionary.
 ;;^UTILITY(U,$J,.84,401,2,0)
 ;;=^^1^1^2931123^^^
 ;;^UTILITY(U,$J,.84,401,2,1,0)
 ;;=File #|FILE| does not exist.
 ;;^UTILITY(U,$J,.84,401,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,401,3,1,0)
 ;;=FILE^File number.
 ;;^UTILITY(U,$J,.84,402,0)
 ;;=402^1^y^11^
 ;;^UTILITY(U,$J,.84,402,1,0)
 ;;=^^2^2^2940316^^^^
 ;;^UTILITY(U,$J,.84,402,1,1,0)
 ;;=The specified file or subfile lacks a valid global root; the global root
 ;;^UTILITY(U,$J,.84,402,1,2,0)
 ;;=is missing or is syntactically not valid.
 ;;^UTILITY(U,$J,.84,402,2,0)
 ;;=^^1^1^2940316^^^^
 ;;^UTILITY(U,$J,.84,402,2,1,0)
 ;;=The global root of file #|FILE| is missing or not valid.
 ;;^UTILITY(U,$J,.84,402,3,0)
 ;;=^.845^3^3
 ;;^UTILITY(U,$J,.84,402,3,1,0)
 ;;=FILE^File number.
 ;;^UTILITY(U,$J,.84,402,3,2,0)
 ;;=ROOT^File root.
 ;;^UTILITY(U,$J,.84,402,3,3,0)
 ;;=IENS^IEN String.
 ;;^UTILITY(U,$J,.84,403,0)
 ;;=403^1^y^11^
 ;;^UTILITY(U,$J,.84,403,1,0)
 ;;=^^3^3^2940213^
 ;;^UTILITY(U,$J,.84,403,1,1,0)
 ;;=The File Header Node, the top level of the data file as described in the
 ;;^UTILITY(U,$J,.84,403,1,2,0)
 ;;=Programmer Manual, must be present for FileMan to determine certain kinds
 ;;^UTILITY(U,$J,.84,403,1,3,0)
 ;;=of information about a file.
 ;;^UTILITY(U,$J,.84,403,2,0)
 ;;=^^1^1^2940213^
 ;;^UTILITY(U,$J,.84,403,2,1,0)
 ;;=File #|FILE| lacks a Header Node.
 ;;^UTILITY(U,$J,.84,403,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,403,3,1,0)
 ;;=FILE^File #.
 ;;^UTILITY(U,$J,.84,404,0)
 ;;=404^1^y^11^
 ;;^UTILITY(U,$J,.84,404,1,0)
 ;;=^^4^4^2940214^
 ;;^UTILITY(U,$J,.84,404,1,1,0)
 ;;=We have identified a file by the global node of its data file, and found
 ;;^UTILITY(U,$J,.84,404,1,2,0)
 ;;=its Header Node. We needed to use the Header Node to identify the number
