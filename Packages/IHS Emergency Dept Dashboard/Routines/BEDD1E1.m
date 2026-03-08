BEDD1E1 ;GDIT/HS/BEE-BEDD VERSION 1 PATCH 1 ENV CHECK ROUTINE ; 08 Nov 2011  12:00 PM
 ;;1.0;IHS EMERGENCY DEPT DASHBOARD;**1**;Dec 17, 2012;Build 7
 ;
 NEW VERSION,X
 ;
 ;Add code to check for Ensemble version greater or equal to 2012
 ;Currently skipping this check
 ;S VERSION=$$VERSION^%ZOSV
 ;I VERSION<2012 D BMES^XPDUTL("Ensemble 2012 or later is required!") S XPDQUIT=2 Q
 ;
 S X="BEDD1P1" X ^%ZOSF("TEST") I '$T D BMES^XPDUTL("The BEDD XML build bedd0100p1.xml must first be installed!") S XPDQUIT=2 Q
 ;
 ;Make sure original KIDS version has been installed
 I $$VERSION^XPDUTL("BEDD")<1 D BMES^XPDUTL("The original BEDD Version 1.0 KIDS build release (file 'bedd0100.k') must first be installed!") S XPDQUIT=2 Q
 Q
