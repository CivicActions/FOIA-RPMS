AGMPSTAT ;GDIT/HS/GCD - AGMPI Application Status; 18 Mar 2024  1:43 PM
 ;;1.0;AGMP;**3**;Apr 30, 2021;Build 45
 ;
 ; Ask the user whether to use page breaks, then display the MPI application status report.
APPSTAT ;
 N %,DIR,Y
 S %=1  ; Default = yes
 W !,"Display the report with page breaks" D YN^DICN
 I %=-1 Q
 D APPRPT(2-%,1)  ; First parameter = 1 if Y, 0 if N.
 Q
 ;
 ; Display MPI application status report. Parameters = page breaks (default = 0), called from menu (default = 0).
APPRPT(PGBRK,MENU) ;
 S EXEC="do ##class(AGMPI.Manage.ApplicationStatus).DisplaySummary("_$G(PGBRK,0)_","_$G(MENU,0)_")"
 X EXEC
 Q
