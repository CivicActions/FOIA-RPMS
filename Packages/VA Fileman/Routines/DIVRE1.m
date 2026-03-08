DIVRE1 ;SFISC/MWE-HELP LOGIC FOR REQ FLD(S) CHK ;1/17/91  3:11 PM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
H W !!?5,"YES means that every entry in the file will be checked to see"
 W !?5,"that all the required fields have data."
 W !!?5,"NO means that ALL will be used to lookup an entry in the"
 W !?5,"file which begins with the letters ALL."
 Q
