DIINI002 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",14,10,9,0)
 ;;=158^^1
 ;;^UTILITY(U,$J,"OPT",14,10,9,"^")
 ;;=DIVERIFY
 ;;^UTILITY(U,$J,"OPT",14,10,10,0)
 ;;=336^^10
 ;;^UTILITY(U,$J,"OPT",14,10,10,"^")
 ;;=DIFIELD CHECK
 ;;^UTILITY(U,$J,"OPT",14,20)
 ;;=
 ;;^UTILITY(U,$J,"OPT",14,99)
 ;;=55633,47369
 ;;^UTILITY(U,$J,"OPT",14,"U")
 ;;=UTILITY FUNCTIONS
 ;;^UTILITY(U,$J,"OPT",15,0)
 ;;=DISTATISTICS^Statistics^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",15,1,0)
 ;;=^^3^3^2890316^^^
 ;;^UTILITY(U,$J,"OPT",15,1,1,0)
 ;;=After generating output from the Print File Entries or Search File Entries
 ;;^UTILITY(U,$J,"OPT",15,1,2,0)
 ;;=options, call upon the Statistics option to produce your choice of 
 ;;^UTILITY(U,$J,"OPT",15,1,3,0)
 ;;=seven types of statistical tallies.
 ;;^UTILITY(U,$J,"OPT",15,20)
 ;;=D ^DIX
 ;;^UTILITY(U,$J,"OPT",15,"U")
 ;;=STATISTICS
 ;;^UTILITY(U,$J,"OPT",16,0)
 ;;=DILIST^List File Attributes^^A^^^^^^^y^^n^1^^
 ;;^UTILITY(U,$J,"OPT",16,1,0)
 ;;=^^3^3^2890316^^^^
 ;;^UTILITY(U,$J,"OPT",16,1,1,0)
 ;;=This option is used to print data dictionary listings for a given file.
 ;;^UTILITY(U,$J,"OPT",16,1,2,0)
 ;;=This listing is useful for programmers, analysts, and others interested
 ;;^UTILITY(U,$J,"OPT",16,1,3,0)
 ;;=in data base structures.
 ;;^UTILITY(U,$J,"OPT",16,20)
 ;;=D ^DID
 ;;^UTILITY(U,$J,"OPT",16,99.1)
 ;;=54447,33461
 ;;^UTILITY(U,$J,"OPT",16,"U")
 ;;=LIST FILE ATTRIBUTES
 ;;^UTILITY(U,$J,"OPT",17,0)
 ;;=DITRANSFER^Transfer Entries^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",17,1,0)
 ;;=^^2^2^2890316^^^^
 ;;^UTILITY(U,$J,"OPT",17,1,1,0)
 ;;=This option is used to transfer entries from one file to another or to
 ;;^UTILITY(U,$J,"OPT",17,1,2,0)
 ;;=merge data from one entry to another in the same file.
 ;;^UTILITY(U,$J,"OPT",17,20)
 ;;=D ^DIT
 ;;^UTILITY(U,$J,"OPT",17,"U")
 ;;=TRANSFER ENTRIES
 ;;^UTILITY(U,$J,"OPT",18,0)
 ;;=DIUSER^VA FileMan^^M^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",18,1,0)
 ;;=^^2^2^2910205^^^^
 ;;^UTILITY(U,$J,"OPT",18,1,1,0)
 ;;=This option branches to the VA FileMan main menu, which allows you
 ;;^UTILITY(U,$J,"OPT",18,1,2,0)
 ;;=to enter, edit, report, inquire, and maintain data dictionaries.
 ;;^UTILITY(U,$J,"OPT",18,10,0)
 ;;=^19.01IP^11^9
 ;;^UTILITY(U,$J,"OPT",18,10,1,0)
 ;;=9^^1
 ;;^UTILITY(U,$J,"OPT",18,10,1,"^")
 ;;=DIEDIT
 ;;^UTILITY(U,$J,"OPT",18,10,2,0)
 ;;=13^^5
 ;;^UTILITY(U,$J,"OPT",18,10,2,"^")
 ;;=DIINQUIRE
 ;;^UTILITY(U,$J,"OPT",18,10,4,0)
 ;;=12^^4
 ;;^UTILITY(U,$J,"OPT",18,10,4,"^")
 ;;=DIMODIFY
 ;;^UTILITY(U,$J,"OPT",18,10,5,0)
 ;;=10^^2
 ;;^UTILITY(U,$J,"OPT",18,10,5,"^")
 ;;=DIPRINT
 ;;^UTILITY(U,$J,"OPT",18,10,6,0)
 ;;=11^^3
 ;;^UTILITY(U,$J,"OPT",18,10,6,"^")
 ;;=DISEARCH
 ;;^UTILITY(U,$J,"OPT",18,10,8,0)
 ;;=17^^9
 ;;^UTILITY(U,$J,"OPT",18,10,8,"^")
 ;;=DITRANSFER
 ;;^UTILITY(U,$J,"OPT",18,10,9,0)
 ;;=14^^6
 ;;^UTILITY(U,$J,"OPT",18,10,9,"^")
 ;;=DIUTILITY
 ;;^UTILITY(U,$J,"OPT",18,10,10,0)
 ;;=292^^10
 ;;^UTILITY(U,$J,"OPT",18,10,10,"^")
 ;;=DIOTHER
 ;;^UTILITY(U,$J,"OPT",18,10,11,0)
 ;;=349^^8
 ;;^UTILITY(U,$J,"OPT",18,10,11,"^")
 ;;=DI DDU
 ;;^UTILITY(U,$J,"OPT",18,20)
 ;;=W !!?10,"VA FileMan Version "_^DD("VERSION")
 ;;^UTILITY(U,$J,"OPT",18,99)
 ;;=55633,47363
 ;;^UTILITY(U,$J,"OPT",18,99.1)
 ;;=53890,48786
 ;;^UTILITY(U,$J,"OPT",18,1613)
 ;;=
 ;;^UTILITY(U,$J,"OPT",18,"U")
 ;;=VA FILEMAN
 ;;^UTILITY(U,$J,"OPT",104,0)
 ;;=DI DDMAP^Map Pointer Relations^^R^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",104,1,0)
 ;;=^^3^3^2910706^
 ;;^UTILITY(U,$J,"OPT",104,1,1,0)
 ;;=This option prints a map of the pointer relations between a group of
 ;;^UTILITY(U,$J,"OPT",104,1,2,0)
 ;;=files. The file selection is from the package file or entered
 ;;^UTILITY(U,$J,"OPT",104,1,3,0)
 ;;=individually.
 ;;^UTILITY(U,$J,"OPT",104,25)
 ;;=DDMAP
 ;;^UTILITY(U,$J,"OPT",104,136)
 ;;=
 ;;^UTILITY(U,$J,"OPT",104,"U")
 ;;=MAP POINTER RELATIONS
 ;;^UTILITY(U,$J,"OPT",158,0)
 ;;=DIVERIFY^Verify Fields^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",158,1,0)
 ;;=^^4^4^2890316^^^
 ;;^UTILITY(U,$J,"OPT",158,1,1,0)
 ;;=This option is used to double check the data that exists in a field
 ;;^UTILITY(U,$J,"OPT",158,1,2,0)
 ;;=to see that it matches the Data Dictionary specifications.  The user
 ;;^UTILITY(U,$J,"OPT",158,1,3,0)
 ;;=is allowed to store the discrepancies in a search template so that they
 ;;^UTILITY(U,$J,"OPT",158,1,4,0)
 ;;=can easily be retrieved for examination and correction.
 ;;^UTILITY(U,$J,"OPT",158,20)
 ;;=S DI=1 G EN^DIU
