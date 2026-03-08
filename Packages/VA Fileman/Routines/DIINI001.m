DIINI001 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"KEY",24,0)
 ;;=DIEXTRACT
 ;;^UTILITY(U,$J,"KEY",24,1,0)
 ;;=^^3^3^2930106^
 ;;^UTILITY(U,$J,"KEY",24,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"KEY",24,1,2,0)
 ;;=This key is needed to access the menu for extracting data to a VA FileMan
 ;;^UTILITY(U,$J,"KEY",24,1,3,0)
 ;;=file.
 ;;^UTILITY(U,$J,"KEY",25,0)
 ;;=DDXP-DEFINE
 ;;^UTILITY(U,$J,"KEY",25,1,0)
 ;;=^^3^3^2930108^^
 ;;^UTILITY(U,$J,"KEY",25,1,1,0)
 ;;=Holders of this key can use the Define Foreign File Format option.  That
 ;;^UTILITY(U,$J,"KEY",25,1,2,0)
 ;;=option defines foreign formats, modifies existing formats that have not
 ;;^UTILITY(U,$J,"KEY",25,1,3,0)
 ;;=been used to create an export template, and clones formats.
 ;;^UTILITY(U,$J,"OPT",9,0)
 ;;=DIEDIT^Enter or Edit File Entries^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",9,1,0)
 ;;=^^2^2^2890316^^^^
 ;;^UTILITY(U,$J,"OPT",9,1,1,0)
 ;;=This option is used to enter new entries in a file or edit existing ones.
 ;;^UTILITY(U,$J,"OPT",9,1,2,0)
 ;;=You specify the file and fields within the file to edit.
 ;;^UTILITY(U,$J,"OPT",9,20)
 ;;=D ^DIB
 ;;^UTILITY(U,$J,"OPT",9,99)
 ;;=52905,54998
 ;;^UTILITY(U,$J,"OPT",9,"U")
 ;;=ENTER OR EDIT FILE ENTRIES
 ;;^UTILITY(U,$J,"OPT",10,0)
 ;;=DIPRINT^Print File Entries^^A^^^^^^^y^^n^1^^
 ;;^UTILITY(U,$J,"OPT",10,1,0)
 ;;=^^3^3^2910625^^^^
 ;;^UTILITY(U,$J,"OPT",10,1,1,0)
 ;;=This option is used to print a report from a file, where a number of
 ;;^UTILITY(U,$J,"OPT",10,1,2,0)
 ;;=entries are to be listed in a columnar format.  Each column can be
 ;;^UTILITY(U,$J,"OPT",10,1,3,0)
 ;;=individually controlled for format, tabulation, justification, etc.
 ;;^UTILITY(U,$J,"OPT",10,20)
 ;;=D ^DIP
 ;;^UTILITY(U,$J,"OPT",10,99.1)
 ;;=55061,47656
 ;;^UTILITY(U,$J,"OPT",10,"U")
 ;;=PRINT FILE ENTRIES
 ;;^UTILITY(U,$J,"OPT",11,0)
 ;;=DISEARCH^Search File Entries^^A^^^^^^^y^^n^1^^
 ;;^UTILITY(U,$J,"OPT",11,1,0)
 ;;=^^3^3^2930728^^^^
 ;;^UTILITY(U,$J,"OPT",11,1,1,0)
 ;;=This option is used to print a report in which entries are to be selected
 ;;^UTILITY(U,$J,"OPT",11,1,2,0)
 ;;=according to a pre-determined set of criteria.  After the search criteria 
 ;;^UTILITY(U,$J,"OPT",11,1,3,0)
 ;;=is met, a standard report will be generated.
 ;;^UTILITY(U,$J,"OPT",11,20)
 ;;=D ^DIS
 ;;^UTILITY(U,$J,"OPT",11,"U")
 ;;=SEARCH FILE ENTRIES
 ;;^UTILITY(U,$J,"OPT",12,0)
 ;;=DIMODIFY^Modify File Attributes^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",12,1,0)
 ;;=^^2^2^2890316^^^
 ;;^UTILITY(U,$J,"OPT",12,1,1,0)
 ;;=This option is used to modify the structure of a file or the 
 ;;^UTILITY(U,$J,"OPT",12,1,2,0)
 ;;=characteristics of its fields.
 ;;^UTILITY(U,$J,"OPT",12,20)
 ;;=D ^DICATT
 ;;^UTILITY(U,$J,"OPT",12,"U")
 ;;=MODIFY FILE ATTRIBUTES
 ;;^UTILITY(U,$J,"OPT",13,0)
 ;;=DIINQUIRE^Inquire to File Entries^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",13,1,0)
 ;;=3^^4^4^2890316^^
 ;;^UTILITY(U,$J,"OPT",13,1,1,0)
 ;;=This option is used to display all the data for a group of specified
 ;;^UTILITY(U,$J,"OPT",13,1,2,0)
 ;;=entries in a file.  This is useful for a quick look at a small number
 ;;^UTILITY(U,$J,"OPT",13,1,3,0)
 ;;=of entries.  Use the Print File Entries option for larger numbers
 ;;^UTILITY(U,$J,"OPT",13,1,4,0)
 ;;=of entries.
 ;;^UTILITY(U,$J,"OPT",13,20)
 ;;=D INQ^DII
 ;;^UTILITY(U,$J,"OPT",13,"U")
 ;;=INQUIRE TO FILE ENTRIES
 ;;^UTILITY(U,$J,"OPT",14,0)
 ;;=DIUTILITY^Utility Functions^^M^^^^^^^^^n^^
 ;;^UTILITY(U,$J,"OPT",14,1,0)
 ;;=^^2^2^2901205^^^^
 ;;^UTILITY(U,$J,"OPT",14,1,1,0)
 ;;=This option is a menu of VA FileMan utilities used to maintain the more
 ;;^UTILITY(U,$J,"OPT",14,1,2,0)
 ;;=technical aspects of files.
 ;;^UTILITY(U,$J,"OPT",14,10,0)
 ;;=^19.01IP^10^10
 ;;^UTILITY(U,$J,"OPT",14,10,1,0)
 ;;=163^^6
 ;;^UTILITY(U,$J,"OPT",14,10,1,"^")
 ;;=DIEDFILE
 ;;^UTILITY(U,$J,"OPT",14,10,2,0)
 ;;=159^^2
 ;;^UTILITY(U,$J,"OPT",14,10,2,"^")
 ;;=DIXREF
 ;;^UTILITY(U,$J,"OPT",14,10,3,0)
 ;;=162^^5
 ;;^UTILITY(U,$J,"OPT",14,10,3,"^")
 ;;=DIITRAN
 ;;^UTILITY(U,$J,"OPT",14,10,4,0)
 ;;=160^^3
 ;;^UTILITY(U,$J,"OPT",14,10,4,"^")
 ;;=DIIDENT
 ;;^UTILITY(U,$J,"OPT",14,10,5,0)
 ;;=161^^4
 ;;^UTILITY(U,$J,"OPT",14,10,5,"^")
 ;;=DIRDEX
 ;;^UTILITY(U,$J,"OPT",14,10,6,0)
 ;;=164^^7
 ;;^UTILITY(U,$J,"OPT",14,10,6,"^")
 ;;=DIOTRAN
 ;;^UTILITY(U,$J,"OPT",14,10,7,0)
 ;;=165^^8
 ;;^UTILITY(U,$J,"OPT",14,10,7,"^")
 ;;=DITEMP
 ;;^UTILITY(U,$J,"OPT",14,10,8,0)
 ;;=166^^9
 ;;^UTILITY(U,$J,"OPT",14,10,8,"^")
 ;;=DIUNEDIT
