DINIT13 ;SFISC/-INITIALIZE VA FILEMAN ;5/23/96  11:20 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**8**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
DD F I=1:1 S X=$T(DD+I),Y=$P(X," ",3,99) G ^DINIT14:X?.P S @("^DD("_$E($P(X," ",2),3,99)_")=Y")
 ;;.401,8,0 TEMPLATE TYPE^S^1:ARCHIVING SEARCH;^0;8^Q
 ;;.401,8,3 Enter a 1 if this is an ARCHIVING SEARCH template (i.e., used to store lists of records to be archived) as opposed to a normal SEARCH or SORT template
 ;;.401,10,0 DESCRIPTION^.4012^^%D;0
 ;;.402,10,0 DESCRIPTION^.4021^^%D;0
 ;;.4012,0,"UP" .401
 ;;.4021,0,"UP" .402
 ;;.4,8,0 TEMPLATE TYPE^S^1:FILEGRAM;2:EXTRACT;3:EXPORT;7:SELECTED EXPORT FIELDS;^0;8^Q
 ;;.4,8,1,0 ^.1^^-1
 ;;.4,8,1,1,0 .4^FG^MUMPS
 ;;.4,8,1,1,1 S %=$S(X=1:"""FG""",1:"") I %]"" S A1=$P(@(DIC_"DA,0)"),U,1),@(DIC_%_",A1,DA)=""""") K %,A1
 ;;.4,8,1,1,2 S %=$S(X=1:"""FG""",1:"") I %]"" S A1=$P(@(DIC_"DA,0)"),U,1) K @(DIC_%_",A1,DA)"),%,A1
 ;;.4,8,1,1,"%D",0 ^^1^1^2921002^^^^
 ;;.4,8,1,1,"%D",0,"LE" 1
 ;;.4,8,1,1,"%D",1,0 Used to do a quick lookup of FILEGRAM type of print templates.
 ;;.4,8,1,1,"DT" 2901106
 ;;.4,8,3 Enter a 1 if this is a FILEGRAM template, 2 if this is an EXTRACT template, 3 if an EXPORT template, 7 if a SELECTED FIELDS template, as opposed to a normal PRINT template.
 ;;.4,8,"DT" 2921110
 ;;.4,20,0 DESTINATION FILE^NJ16,6^^0;9^K:+X'=X!(X>999999999)!(X<2)!(X?.E1"."7N.N) X
 ;;.4,20,3 Type a Number between 2 and 999999999, 6 Decimal Digits
 ;;.4,20,21,0 ^^2^2^2921002^
 ;;.4,20,21,1,0 This field holds the number of the file that is designed to receive
 ;;.4,20,21,2,0 data from other files by using the Extract Tool.
 ;;.4,20,"DT" 2920923
 ;;.4,50,0 FILEGRAM/EXTR FILE^.41A^^1;0
 ;;.4,50,"DT" 2920514
 ;;.4,100,0 EXPORT FIELD^.42A^^100;0
 ;;.4,100,21,0 ^^1^1^2921123^^
 ;;.4,100,21,1,0 This multiple holds information about each field being exported.
 ;;.4,105,0 EXPORT FORMAT^P.44'^DIST(.44,^105;1^Q
 ;;.4,105,21,0 ^^1^1^2921123^
 ;;.4,105,21,1,0 This field contains the foreign format used to make the export template.
 ;;.4,105,"DT" 2920904
 ;;.4,110,0 EXPORT TEMPLATE CREATED?^S^1:YES;0:NO;^105;3^Q
 ;;.4,110,21,0 ^^2^2^2921119^
 ;;.4,110,21,1,0 If YES, this Selected Fields for Export template has been used to create
 ;;.4,110,21,2,0 an Export template.
 ;;.4,110,"DT" 2920904
 ;;.4,115,0 MULTIPLE PATH^F^^105;4^K:$L(X)>30!($L(X)<1) X
 ;;.4,115,3 Answer must be 1-30 characters in length.
 ;;.4,115,21,0 ^^2^2^2921119^
 ;;.4,115,21,1,0 This field holds a list of field numbers representing the deepest multiple
 ;;.4,115,21,2,0 contained in this Export template.
 ;;.4,115,"DT" 2921119
 ;;.4,704,0 HEADER^CJ60^^ ; ^S X=$S($D(^DIPT(D0,"H")):^("H"),1:"")
 ;;.4,707,0 SUB-HEADER SUPPRESSED^S^1:YES^SUB;1^Q
 ;;.4,1620,0 PRINT FIELDS^XCmJ50^^ ; ^D ^DIPT
 ;;.401,15,0 SEARCH SPECIFICATIONS^.4011^^O;0
 ;;.4011,0 FIELD^.01^1
 ;;.4011,0,"NM","FIELD"
 ;;.4011,.01,0 SEARCH SPECIFICATIONS^WL^^0;1
 ;;.4011,0,"UP" .401
 ;;.401,1620,0 SORT FIELDS^CmJ50^^ ; ^D DIBT^DIPT
 ;;.401,491620,0 PRINT TEMPLATE^F^^DIPT;1^K:'$D(^DIPT("B",X)) X
 ;;.401,491620,4 N D1 S D1(1)="If this Sort Template should always be used with a particular",D1(2)="Print Template, enter the name of that Print Template.",D1(3)="" D EN^DDIOL(.D1)
