DIINI008 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",390,20)
 ;;=D 1^DDXP
 ;;^UTILITY(U,$J,"OPT",390,"U")
 ;;=DEFINE FOREIGN FILE FORMAT
 ;;^UTILITY(U,$J,"OPT",391,0)
 ;;=DDXP SELECT EXPORT FIELDS^Select Fields for Export^^A^^^^^^^^^^1
 ;;^UTILITY(U,$J,"OPT",391,1,0)
 ;;=^^1^1^2921207^^
 ;;^UTILITY(U,$J,"OPT",391,1,1,0)
 ;;=Use this option to choose fields to be exported.
 ;;^UTILITY(U,$J,"OPT",391,20)
 ;;=D 2^DDXP
 ;;^UTILITY(U,$J,"OPT",391,"U")
 ;;=SELECT FIELDS FOR EXPORT
 ;;^UTILITY(U,$J,"OPT",392,0)
 ;;=DDXP CREATE EXPORT TEMPLATE^Create Export Template^^A^^^^^^^^^^1
 ;;^UTILITY(U,$J,"OPT",392,1,0)
 ;;=^^2^2^2940519^^^
 ;;^UTILITY(U,$J,"OPT",392,1,1,0)
 ;;=This option creates an Export template by applying the specifications in a
 ;;^UTILITY(U,$J,"OPT",392,1,2,0)
 ;;=Foreign Format with the fields in a Selected Fields for Export template.
 ;;^UTILITY(U,$J,"OPT",392,20)
 ;;=D 3^DDXP
 ;;^UTILITY(U,$J,"OPT",392,"U")
 ;;=CREATE EXPORT TEMPLATE
 ;;^UTILITY(U,$J,"OPT",393,0)
 ;;=DDXP EXPORT DATA^Export Data^^A^^^^^^^^^^1
 ;;^UTILITY(U,$J,"OPT",393,1,0)
 ;;=^^4^4^2921207^^
 ;;^UTILITY(U,$J,"OPT",393,1,1,0)
 ;;=This option sends data to a specified device for export to a foreign
 ;;^UTILITY(U,$J,"OPT",393,1,2,0)
 ;;=application.  You have the opportunity to choose entries for export with
 ;;^UTILITY(U,$J,"OPT",393,1,3,0)
 ;;=VA FileMan's Search dialogue.  You use an Export template to control the
 ;;^UTILITY(U,$J,"OPT",393,1,4,0)
 ;;=export.
 ;;^UTILITY(U,$J,"OPT",393,20)
 ;;=D 4^DDXP
 ;;^UTILITY(U,$J,"OPT",393,"U")
 ;;=EXPORT DATA
 ;;^UTILITY(U,$J,"OPT",394,0)
 ;;=DDXP EXPORT MENU^Data Export to Foreign Format^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",394,1,0)
 ;;=^^1^1^2921207^
 ;;^UTILITY(U,$J,"OPT",394,1,1,0)
 ;;=Submenu for the Export tool.
 ;;^UTILITY(U,$J,"OPT",394,10,0)
 ;;=^19.01IP^5^5
 ;;^UTILITY(U,$J,"OPT",394,10,1,0)
 ;;=390^^1
 ;;^UTILITY(U,$J,"OPT",394,10,1,"^")
 ;;=DDXP DEFINE FORMAT
 ;;^UTILITY(U,$J,"OPT",394,10,2,0)
 ;;=391^^2
 ;;^UTILITY(U,$J,"OPT",394,10,2,"^")
 ;;=DDXP SELECT EXPORT FIELDS
 ;;^UTILITY(U,$J,"OPT",394,10,3,0)
 ;;=392^^3
 ;;^UTILITY(U,$J,"OPT",394,10,3,"^")
 ;;=DDXP CREATE EXPORT TEMPLATE
 ;;^UTILITY(U,$J,"OPT",394,10,4,0)
 ;;=393^^4
 ;;^UTILITY(U,$J,"OPT",394,10,4,"^")
 ;;=DDXP EXPORT DATA
 ;;^UTILITY(U,$J,"OPT",394,10,5,0)
 ;;=405^^5
 ;;^UTILITY(U,$J,"OPT",394,10,5,"^")
 ;;=DDXP FORMAT DOCUMENTATION
 ;;^UTILITY(U,$J,"OPT",394,99)
 ;;=55633,47255
 ;;^UTILITY(U,$J,"OPT",394,"U")
 ;;=DATA EXPORT TO FOREIGN FORMAT
 ;;^UTILITY(U,$J,"OPT",395,0)
 ;;=DIAX EXTRACT MENU^Extract Data To Fileman File^^M^^DIEXTRACT^^^^^^^^^1^^
 ;;^UTILITY(U,$J,"OPT",395,1,0)
 ;;=^^2^2^2921222^^^^
 ;;^UTILITY(U,$J,"OPT",395,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",395,1,2,0)
 ;;=This is a menu of the tool for extracting data to Fileman file.
 ;;^UTILITY(U,$J,"OPT",395,10,0)
 ;;=^19.01IP^9^9
 ;;^UTILITY(U,$J,"OPT",395,10,1,0)
 ;;=396^^1
 ;;^UTILITY(U,$J,"OPT",395,10,1,"^")
 ;;=DIAX SELECT
 ;;^UTILITY(U,$J,"OPT",395,10,2,0)
 ;;=397^^2
 ;;^UTILITY(U,$J,"OPT",395,10,2,"^")
 ;;=DIAX ADD/DELETE
 ;;^UTILITY(U,$J,"OPT",395,10,3,0)
 ;;=398^^3
 ;;^UTILITY(U,$J,"OPT",395,10,3,"^")
 ;;=DIAX PRINT
 ;;^UTILITY(U,$J,"OPT",395,10,4,0)
 ;;=399^^4
 ;;^UTILITY(U,$J,"OPT",395,10,4,"^")
 ;;=DIAX MODIFY
 ;;^UTILITY(U,$J,"OPT",395,10,5,0)
 ;;=400^^5
 ;;^UTILITY(U,$J,"OPT",395,10,5,"^")
 ;;=DIAX CREATE
 ;;^UTILITY(U,$J,"OPT",395,10,6,0)
 ;;=401^^6
 ;;^UTILITY(U,$J,"OPT",395,10,6,"^")
 ;;=DIAX UPDATE
 ;;^UTILITY(U,$J,"OPT",395,10,7,0)
 ;;=402^^7
 ;;^UTILITY(U,$J,"OPT",395,10,7,"^")
 ;;=DIAX PURGE
 ;;^UTILITY(U,$J,"OPT",395,10,8,0)
 ;;=403^^7
 ;;^UTILITY(U,$J,"OPT",395,10,8,"^")
 ;;=DIAX CANCEL
 ;;^UTILITY(U,$J,"OPT",395,10,9,0)
 ;;=404^^8
 ;;^UTILITY(U,$J,"OPT",395,10,9,"^")
 ;;=DIAX VALIDATE
 ;;^UTILITY(U,$J,"OPT",395,15)
 ;;=K DIAX
 ;;^UTILITY(U,$J,"OPT",395,99)
 ;;=55633,47310
 ;;^UTILITY(U,$J,"OPT",395,"U")
 ;;=EXTRACT DATA TO FILEMAN FILE
 ;;^UTILITY(U,$J,"OPT",396,0)
 ;;=DIAX SELECT^Select Entries to Extract^^A^^DIEXTRACT^^^^^^^^1^^^
 ;;^UTILITY(U,$J,"OPT",396,1,0)
 ;;=^^5^5^2921222^
 ;;^UTILITY(U,$J,"OPT",396,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",396,1,2,0)
 ;;=Use this option to specify the criteria that would select Fileman entries
 ;;^UTILITY(U,$J,"OPT",396,1,3,0)
 ;;=to extract.  This is the first step in developing an extract activity and
 ;;^UTILITY(U,$J,"OPT",396,1,4,0)
 ;;=is important since there cannot be any extract process without the search
 ;;^UTILITY(U,$J,"OPT",396,1,5,0)
 ;;=template created in this option.
