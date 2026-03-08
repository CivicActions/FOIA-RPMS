DIINI007 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",336,20)
 ;;=S DI=10 G EN^DIU
 ;;^UTILITY(U,$J,"OPT",336,"U")
 ;;=MANDATORY/REQUIRED FIELD CHECK
 ;;^UTILITY(U,$J,"OPT",337,0)
 ;;=DIAUDIT TURN ON/OFF^Turn Data Audit On/Off^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",337,1,0)
 ;;=^^4^4^2901206^
 ;;^UTILITY(U,$J,"OPT",337,1,1,0)
 ;;=This option allows the user to start or stop an audit on a particular
 ;;^UTILITY(U,$J,"OPT",337,1,2,0)
 ;;=data field.  The user must have audit access to the file in order to turn
 ;;^UTILITY(U,$J,"OPT",337,1,3,0)
 ;;=an audit on or off.  No other attributes in the field definition can 
 ;;^UTILITY(U,$J,"OPT",337,1,4,0)
 ;;=be affected by this option.
 ;;^UTILITY(U,$J,"OPT",337,25)
 ;;=5^DIAU
 ;;^UTILITY(U,$J,"OPT",337,"U")
 ;;=TURN DATA AUDIT ON/OFF
 ;;^UTILITY(U,$J,"OPT",338,0)
 ;;=DIWF^Forms Print^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",338,1,0)
 ;;=^^7^7^2901206^
 ;;^UTILITY(U,$J,"OPT",338,1,1,0)
 ;;=This VA FileMan routine asks first for a 'document' file, which must be
 ;;^UTILITY(U,$J,"OPT",338,1,2,0)
 ;;=a file that contains a word processing field at the first level.  It then
 ;;^UTILITY(U,$J,"OPT",338,1,3,0)
 ;;=asks the user to choose an entry in that file for which the word
 ;;^UTILITY(U,$J,"OPT",338,1,4,0)
 ;;=processing field has some text on file.  It then uses that text as a 
 ;;^UTILITY(U,$J,"OPT",338,1,5,0)
 ;;='print template' for a file.  If the chosen document entry has a pointer
 ;;^UTILITY(U,$J,"OPT",338,1,6,0)
 ;;=to a file, that file is automatically the one from which the printing
 ;;^UTILITY(U,$J,"OPT",338,1,7,0)
 ;;=is done.
 ;;^UTILITY(U,$J,"OPT",338,25)
 ;;=DIWF
 ;;^UTILITY(U,$J,"OPT",338,"U")
 ;;=FORMS PRINT
 ;;^UTILITY(U,$J,"OPT",348,0)
 ;;=DI DDUCHK^Check/Fix DD Structure^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",348,1,0)
 ;;=^^4^4^2930125^
 ;;^UTILITY(U,$J,"OPT",348,1,1,0)
 ;;=This option looks at the internal structure of files and subfiles
 ;;^UTILITY(U,$J,"OPT",348,1,2,0)
 ;;=and determines if there are inconsistencies or conflicts between the
 ;;^UTILITY(U,$J,"OPT",348,1,3,0)
 ;;=information in the data dictionary and the structure of the file's global
 ;;^UTILITY(U,$J,"OPT",348,1,4,0)
 ;;=nodes.  This option will note them and fix or delete the incorrect nodes.
 ;;^UTILITY(U,$J,"OPT",348,25)
 ;;=DDUCHK
 ;;^UTILITY(U,$J,"OPT",348,"U")
 ;;=CHECK/FIX DD STRUCTURE
 ;;^UTILITY(U,$J,"OPT",349,0)
 ;;=DI DDU^Data Dictionary Utilities^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",349,10,0)
 ;;=^19.01IP^3^3
 ;;^UTILITY(U,$J,"OPT",349,10,1,0)
 ;;=16^^1
 ;;^UTILITY(U,$J,"OPT",349,10,1,"^")
 ;;=DILIST
 ;;^UTILITY(U,$J,"OPT",349,10,2,0)
 ;;=104^^2
 ;;^UTILITY(U,$J,"OPT",349,10,2,"^")
 ;;=DI DDMAP
 ;;^UTILITY(U,$J,"OPT",349,10,3,0)
 ;;=348^^3
 ;;^UTILITY(U,$J,"OPT",349,10,3,"^")
 ;;=DI DDUCHK
 ;;^UTILITY(U,$J,"OPT",349,99)
 ;;=55633,47339
 ;;^UTILITY(U,$J,"OPT",349,"U")
 ;;=DATA DICTIONARY UTILITIES
 ;;^UTILITY(U,$J,"OPT",360,0)
 ;;=DDS RUN A FORM^Run a Form^^A^^^^^^^^^^1
 ;;^UTILITY(U,$J,"OPT",360,1,0)
 ;;=^^1^1^2940701^^
 ;;^UTILITY(U,$J,"OPT",360,1,1,0)
 ;;=Option to run a form.
 ;;^UTILITY(U,$J,"OPT",360,20)
 ;;=D 2^DDSOPT
 ;;^UTILITY(U,$J,"OPT",360,99.1)
 ;;=56123,39787
 ;;^UTILITY(U,$J,"OPT",360,"U")
 ;;=RUN A FORM
 ;;^UTILITY(U,$J,"OPT",384,0)
 ;;=DIFG-SRV-HISTORY^Server to Load a Message into the FG History File^^S^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",384,1,0)
 ;;=^^2^2^2920420^
 ;;^UTILITY(U,$J,"OPT",384,1,1,0)
 ;;=This option is a SERVER that will take a message and add it to the 
 ;;^UTILITY(U,$J,"OPT",384,1,2,0)
 ;;=Filegram History file so that it can be installed.
 ;;^UTILITY(U,$J,"OPT",384,3.91,0)
 ;;=^19.391^^0
 ;;^UTILITY(U,$J,"OPT",384,25)
 ;;=HIST^DIFGSRV
 ;;^UTILITY(U,$J,"OPT",384,220)
 ;;=^R^^N^N^N
 ;;^UTILITY(U,$J,"OPT",384,"U")
 ;;=SERVER TO LOAD A MESSAGE INTO 
 ;;^UTILITY(U,$J,"OPT",390,0)
 ;;=DDXP DEFINE FORMAT^Define Foreign File Format^^A^^DDXP-DEFINE^^^^^^^^1
 ;;^UTILITY(U,$J,"OPT",390,1,0)
 ;;=^^5^5^2930108^
 ;;^UTILITY(U,$J,"OPT",390,1,1,0)
 ;;=Use this option to define formats.  Formats are entries in the Foreign
 ;;^UTILITY(U,$J,"OPT",390,1,2,0)
 ;;=Format file.  They are used to control the exporting of data to a
 ;;^UTILITY(U,$J,"OPT",390,1,3,0)
 ;;=non-MUMPS application.  You can alter an existing format only before it has
 ;;^UTILITY(U,$J,"OPT",390,1,4,0)
 ;;=been used to create an Export template.  After it has been used, you can
 ;;^UTILITY(U,$J,"OPT",390,1,5,0)
 ;;=clone a format.  This option is locked with the DDXP-DEFINE key.
