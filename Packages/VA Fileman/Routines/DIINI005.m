DIINI005 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",287,10,4,0)
 ;;=291^^4
 ;;^UTILITY(U,$J,"OPT",287,10,4,"^")
 ;;=DIAUDIT PURGE DD
 ;;^UTILITY(U,$J,"OPT",287,10,5,0)
 ;;=337^^5
 ;;^UTILITY(U,$J,"OPT",287,10,5,"^")
 ;;=DIAUDIT TURN ON/OFF
 ;;^UTILITY(U,$J,"OPT",287,99)
 ;;=55633,47284
 ;;^UTILITY(U,$J,"OPT",287,"U")
 ;;=AUDIT MENU
 ;;^UTILITY(U,$J,"OPT",288,0)
 ;;=DIAUDITED FIELDS^Fields Being Audited^^R^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",288,1,0)
 ;;=^^2^2^2930125^^^
 ;;^UTILITY(U,$J,"OPT",288,1,1,0)
 ;;=This options lists all the fields that are being audited.  One can
 ;;^UTILITY(U,$J,"OPT",288,1,2,0)
 ;;=see all the fields or just those in a particular file range.
 ;;^UTILITY(U,$J,"OPT",288,25)
 ;;=1^DIAU
 ;;^UTILITY(U,$J,"OPT",288,"U")
 ;;=FIELDS BEING AUDITED
 ;;^UTILITY(U,$J,"OPT",289,0)
 ;;=DIAUDIT DD^Data Dictionaries Being Audited^^R^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",289,1,0)
 ;;=^^2^2^2890803^
 ;;^UTILITY(U,$J,"OPT",289,1,1,0)
 ;;=This option lists the data dictionaries being audited within a selected
 ;;^UTILITY(U,$J,"OPT",289,1,2,0)
 ;;=range.
 ;;^UTILITY(U,$J,"OPT",289,25)
 ;;=2^DIAU
 ;;^UTILITY(U,$J,"OPT",289,"U")
 ;;=DATA DICTIONARIES BEING AUDITE
 ;;^UTILITY(U,$J,"OPT",290,0)
 ;;=DIAUDIT PURGE DATA^Purge Data Audits^^R^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",290,1,0)
 ;;=^^3^3^2890804^^
 ;;^UTILITY(U,$J,"OPT",290,1,1,0)
 ;;=This option purges the audited data from a particular file.  Either all
 ;;^UTILITY(U,$J,"OPT",290,1,2,0)
 ;;=of the audits may be purged or the audits may be deleted based on a
 ;;^UTILITY(U,$J,"OPT",290,1,3,0)
 ;;=field in the audit file, e.g., date, user, field.
 ;;^UTILITY(U,$J,"OPT",290,25)
 ;;=3^DIAU
 ;;^UTILITY(U,$J,"OPT",290,99.1)
 ;;=56123,39787
 ;;^UTILITY(U,$J,"OPT",290,"U")
 ;;=PURGE DATA AUDITS
 ;;^UTILITY(U,$J,"OPT",291,0)
 ;;=DIAUDIT PURGE DD^Purge DD Audits^^R^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",291,25)
 ;;=4^DIAU
 ;;^UTILITY(U,$J,"OPT",291,"U")
 ;;=PURGE DD AUDITS
 ;;^UTILITY(U,$J,"OPT",292,0)
 ;;=DIOTHER^Other Options^^M^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",292,1,0)
 ;;=^^3^3^2921207^^^^
 ;;^UTILITY(U,$J,"OPT",292,1,1,0)
 ;;=This menu contains a series of menus which lead to enhancements in current
 ;;^UTILITY(U,$J,"OPT",292,1,2,0)
 ;;=and coming versions.  These include auditing, filegrams, and FileMan 
 ;;^UTILITY(U,$J,"OPT",292,1,3,0)
 ;;=management.
 ;;^UTILITY(U,$J,"OPT",292,10,0)
 ;;=^19.01IP^8^8
 ;;^UTILITY(U,$J,"OPT",292,10,1,0)
 ;;=231^^5
 ;;^UTILITY(U,$J,"OPT",292,10,1,"^")
 ;;=DI MGMT MENU
 ;;^UTILITY(U,$J,"OPT",292,10,2,0)
 ;;=287^^2
 ;;^UTILITY(U,$J,"OPT",292,10,2,"^")
 ;;=DIAUDIT
 ;;^UTILITY(U,$J,"OPT",292,10,3,0)
 ;;=15^^4
 ;;^UTILITY(U,$J,"OPT",292,10,3,"^")
 ;;=DISTATISTICS
 ;;^UTILITY(U,$J,"OPT",292,10,4,0)
 ;;=327^^1
 ;;^UTILITY(U,$J,"OPT",292,10,4,"^")
 ;;=DIFG
 ;;^UTILITY(U,$J,"OPT",292,10,5,0)
 ;;=294^^3
 ;;^UTILITY(U,$J,"OPT",292,10,5,"^")
 ;;=DDS SCREEN MENU
 ;;^UTILITY(U,$J,"OPT",292,10,6,0)
 ;;=394^^6
 ;;^UTILITY(U,$J,"OPT",292,10,6,"^")
 ;;=DDXP EXPORT MENU
 ;;^UTILITY(U,$J,"OPT",292,10,7,0)
 ;;=395^^7
 ;;^UTILITY(U,$J,"OPT",292,10,7,"^")
 ;;=DIAX EXTRACT MENU
 ;;^UTILITY(U,$J,"OPT",292,10,8,0)
 ;;=503^
 ;;^UTILITY(U,$J,"OPT",292,10,8,"^")
 ;;=DDBROWSER
 ;;^UTILITY(U,$J,"OPT",292,99)
 ;;=56021,58310
 ;;^UTILITY(U,$J,"OPT",292,"U")
 ;;=OTHER OPTIONS
 ;;^UTILITY(U,$J,"OPT",293,0)
 ;;=DDS EDIT/CREATE A FORM^Edit/Create a Form^^R^^^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",293,1,0)
 ;;=^^2^2^2940630^
 ;;^UTILITY(U,$J,"OPT",293,1,1,0)
 ;;=An option for editing and creating ScreenMan Forms.  This option calls the
 ;;^UTILITY(U,$J,"OPT",293,1,2,0)
 ;;=Form Editor.
 ;;^UTILITY(U,$J,"OPT",293,20)
 ;;=
 ;;^UTILITY(U,$J,"OPT",293,25)
 ;;=1^DDSOPT
 ;;^UTILITY(U,$J,"OPT",293,99)
 ;;=54872,31063
 ;;^UTILITY(U,$J,"OPT",293,"U")
 ;;=EDIT/CREATE A FORM
 ;;^UTILITY(U,$J,"OPT",294,0)
 ;;=DDS SCREEN MENU^ScreenMan^^M^^XUSCREENMAN^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",294,10,0)
 ;;=^19.01IP^4^4
 ;;^UTILITY(U,$J,"OPT",294,10,1,0)
 ;;=293^^1^Enter/Edit Screen Definition
 ;;^UTILITY(U,$J,"OPT",294,10,1,"^")
 ;;=DDS EDIT/CREATE A FORM
 ;;^UTILITY(U,$J,"OPT",294,10,2,0)
 ;;=360^^2
 ;;^UTILITY(U,$J,"OPT",294,10,2,"^")
 ;;=DDS RUN A FORM
 ;;^UTILITY(U,$J,"OPT",294,10,3,0)
 ;;=509^^3
 ;;^UTILITY(U,$J,"OPT",294,10,3,"^")
 ;;=DDS DELETE A FORM
 ;;^UTILITY(U,$J,"OPT",294,10,4,0)
 ;;=510^^4
 ;;^UTILITY(U,$J,"OPT",294,10,4,"^")
 ;;=DDS PURGE UNUSED BLOCKS
 ;;^UTILITY(U,$J,"OPT",294,99)
 ;;=56078,27325
 ;;^UTILITY(U,$J,"OPT",294,"U")
 ;;=SCREENMAN
