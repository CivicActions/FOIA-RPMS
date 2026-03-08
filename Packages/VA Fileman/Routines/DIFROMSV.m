DIFROMSV ;SFISC/DCL-DIFROM SERVER UTILITY,PKG REV DATA;08:40 AM  6 Sep 1994; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q
PRD(DIFRFILE,DIFRPRD) ;Package Revision Data for File
EN ;FILE,DATA
 ;Used to install Package Data from Post-Installation Routine
 Q:$G(DIFRFILE)'>1
 Q:'$D(^DD(DIFRFILE))
 S ^DD(DIFRFILE,0,"VRRV")=$G(DIFRPRD)
 Q
