DINIT008 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,404,1,3,0)
 ;;=of the file, but that piece of information is missing from the Header
 ;;^UTILITY(U,$J,.84,404,1,4,0)
 ;;=Node.
 ;;^UTILITY(U,$J,.84,404,2,0)
 ;;=^^1^1^2940214^
 ;;^UTILITY(U,$J,.84,404,2,1,0)
 ;;=The File Header node of the file stored at |1| lacks a file number.
 ;;^UTILITY(U,$J,.84,404,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,404,3,1,0)
 ;;=1^File Root.
 ;;^UTILITY(U,$J,.84,405,0)
 ;;=405^1^y^11^
 ;;^UTILITY(U,$J,.84,405,1,0)
 ;;=^^2^2^2931110^^
 ;;^UTILITY(U,$J,.84,405,1,1,0)
 ;;=The NO EDIT flag is set for the file.  No instruction to override
 ;;^UTILITY(U,$J,.84,405,1,2,0)
 ;;=that flag is present.
 ;;^UTILITY(U,$J,.84,405,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,405,2,1,0)
 ;;=Entries in file |1| cannot be edited.
 ;;^UTILITY(U,$J,.84,405,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,405,3,1,0)
 ;;=1^File Name.
 ;;^UTILITY(U,$J,.84,405,3,2,0)
 ;;=FILE^File number.
 ;;^UTILITY(U,$J,.84,406,0)
 ;;=406^1^y^11^
 ;;^UTILITY(U,$J,.84,406,1,0)
 ;;=^^2^2^2940317^
 ;;^UTILITY(U,$J,.84,406,1,1,0)
 ;;=The data definition for a .01 field for the specified file is missing.
 ;;^UTILITY(U,$J,.84,406,1,2,0)
 ;;=This file is therefore not valid for most database operations.
 ;;^UTILITY(U,$J,.84,406,2,0)
 ;;=^^1^1^2940317^
 ;;^UTILITY(U,$J,.84,406,2,1,0)
 ;;=File #|FILE| has no .01 field definition.
 ;;^UTILITY(U,$J,.84,406,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,406,3,1,0)
 ;;=FILE^File #.
 ;;^UTILITY(U,$J,.84,407,0)
 ;;=407^1^^11
 ;;^UTILITY(U,$J,.84,407,1,0)
 ;;=^^4^4^2940317^
 ;;^UTILITY(U,$J,.84,407,1,1,0)
 ;;=The subfile number of a word processing field has been passed in the place
 ;;^UTILITY(U,$J,.84,407,1,2,0)
 ;;=of a file parameter. This is not acceptable. Although we implement word
 ;;^UTILITY(U,$J,.84,407,1,3,0)
 ;;=processing fields as independent files, we do not allow them to be treated
 ;;^UTILITY(U,$J,.84,407,1,4,0)
 ;;=as files for purposes of most database activities.
 ;;^UTILITY(U,$J,.84,407,2,0)
 ;;=^^1^1^2940317^
 ;;^UTILITY(U,$J,.84,407,2,1,0)
 ;;=A word-processing field is not a file.
 ;;^UTILITY(U,$J,.84,407,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,407,3,1,0)
 ;;=FILE^Subfile # of word-processing field.
 ;;^UTILITY(U,$J,.84,408,0)
 ;;=408^1^y^11
 ;;^UTILITY(U,$J,.84,408,1,0)
 ;;=^^2^2^2940715^
 ;;^UTILITY(U,$J,.84,408,1,1,0)
 ;;=The file lacks a name. For subfiles, $P(^DD(file#,0),U) is null. For root
 ;;^UTILITY(U,$J,.84,408,1,2,0)
 ;;=files, $O(^DD(file#,0,"NM",""))="". 
 ;;^UTILITY(U,$J,.84,408,2,0)
 ;;=^^1^1^2940715^
 ;;^UTILITY(U,$J,.84,408,2,1,0)
 ;;=File# |FILE| lacks a name.
 ;;^UTILITY(U,$J,.84,408,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,408,3,1,0)
 ;;=FILE^File #.
 ;;^UTILITY(U,$J,.84,420,0)
 ;;=420^1^y^11^
 ;;^UTILITY(U,$J,.84,420,1,0)
 ;;=^^4^4^2940628^
 ;;^UTILITY(U,$J,.84,420,1,1,0)
 ;;=A cross reference was specified for look-up, but that cross reference 
 ;;^UTILITY(U,$J,.84,420,1,2,0)
 ;;=does not exist on the file. The file has entries, but the index does not.
 ;;^UTILITY(U,$J,.84,420,1,3,0)
 ;;=This error implies nothing about whether the index is defined in the
 ;;^UTILITY(U,$J,.84,420,1,4,0)
 ;;=file's DD.
 ;;^UTILITY(U,$J,.84,420,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,420,2,1,0)
 ;;=There is no |1| index for File #|FILE|.
 ;;^UTILITY(U,$J,.84,420,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,420,3,1,0)
 ;;=1^Cross reference name.
 ;;^UTILITY(U,$J,.84,420,3,2,0)
 ;;=FILE^File number.
 ;;^UTILITY(U,$J,.84,501,0)
 ;;=501^1^y^11^
 ;;^UTILITY(U,$J,.84,501,1,0)
 ;;=^^2^2^2940214^^^
 ;;^UTILITY(U,$J,.84,501,1,1,0)
 ;;=A search of the data dictionary reveals that the field name or number
 ;;^UTILITY(U,$J,.84,501,1,2,0)
 ;;=passed does not exist in the specified file.
 ;;^UTILITY(U,$J,.84,501,2,0)
 ;;=^^1^1^2940214^^
 ;;^UTILITY(U,$J,.84,501,2,1,0)
 ;;=File #|FILE| does not contain a field |1|.
 ;;^UTILITY(U,$J,.84,501,3,0)
 ;;=^.845^3^3
 ;;^UTILITY(U,$J,.84,501,3,1,0)
 ;;=1^Field name or number.
 ;;^UTILITY(U,$J,.84,501,3,2,0)
 ;;=FILE^File number.
 ;;^UTILITY(U,$J,.84,501,3,3,0)
 ;;=FIELD^Field number.
 ;;^UTILITY(U,$J,.84,502,0)
 ;;=502^1^y^11
 ;;^UTILITY(U,$J,.84,502,1,0)
 ;;=^^3^3^2940715^
 ;;^UTILITY(U,$J,.84,502,1,1,0)
 ;;=The field has been identified, but some key part of its definition is
 ;;^UTILITY(U,$J,.84,502,1,2,0)
 ;;=missing or corrupted. ^DD(file#,field#,0) may not be defined. Some key
 ;;^UTILITY(U,$J,.84,502,1,3,0)
 ;;=piece of that node may be missing.
