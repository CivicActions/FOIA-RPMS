ZIBSETUP ; IHS/HQW/JDH - NO DESCRIPTION PROVIDED ; [ 09/08/1998  8:30 AM ]
ZIBSETUP ;IHS UTILITY/JDH;instll routine
 ; usage S X=$$MGR^ZIBSETUP(DEV_ROUTINE)
 ;
 N ZIBNS
 S ZIBNS=$P(XPDNM,"*"),U="^"
 B  I $L($T(@ZIBNS)) D
 .S X=$$MGRSET(ZIBNS) S:ZIBNS="XU" X=$$VA
 E  W !!,"TAG "_ZIBNS_" DOES NOT EXIST IN THIS ROUTINE."
 Q
 ;
SEED(XBNS) ; set seed for $O to start                                           
 ; input:  namespace                                                    
 S T=$L(XBNS)                                                           
 Q ($E(XBNS,1,T-1)_$C($A($E(XBNS,T))-1)_"~")
 ;
VA() ; execute the VA's ZTMGRSET routine in the MGR uci
 S POP=0
 S ZIBCURR=$V(2,$J,2) ; get the number of the current UCI 
 ; V 2:$J:1:2 sets the current uci to the Volume Group MGR uci
 ; V 2:$J:ZIBCURR:2 resets the current uci
 V 2:$J:1:2 W $ZU(0) D ^ZTMGRSET V 2:$J:ZIBCURR:2 Q POP
 Q 1
 ; 
MGRSET(ZIBNS) ; copy a routine from the list into the volume groups uci
 ;
 ; Usage:  S X=$$MGRSET^ZIBSETUP
 ;
 ;N ZIBPOP,%
 S ZIBPOP=0
 W !!,"MANAGER SETUP",!
 F ZIBCNT=1:1 S %=$P($T(@ZIBNS+ZIBCNT),";;",2) Q:%="END"  D
 .S ZIBRPROD=$P(%,";"),ZIBRMGR=$P(%,";",2)
 .S %=$F(ZIBRPROD,"*") ; loop through the namespace?
 .S:% ZIBPOP=$$MGRSET1($E(ZIBRPROD,1,%-2)) Q:ZIBPOP
 .I $L(ZIBRPROD),$D(^$ROUTINE(ZIBRPROD)) D  ; does the routine exist
 ..S %=$$MGRCHG(ZIBRPROD,ZIBRMGR)
 ..D OUTPUT(ZIBRPROD,ZIBRMGR,$P(%,U),$P(%,U,2))
 .E  D ERROR(ZIBRPROD,$ZU(0))
 Q ZIBPOP
 ;
MGRSET1(ZIBNS) ; loop through namespace
 N ZIBRPROD,%
 S ZIBRPROD=$$SEED(ZIBNS)
 F  S ZIBRPROD=$O(^$ROUTINE(ZIBRPROD)) Q:$E(ZIBRPROD,1,$L(ZIBNS))'=ZIBNS  D
 .S %=$$MGRCHG(ZIBRPROD,ZIBRPROD) ; always same routine names
 .D OUTPUT(ZIBRPROD,ZIBRPROD,$P(%,U),$P(%,U,2))
 Q 1
 ;
MGRCHG(ZIBRPROD,ZIBRMGR) ; zsave a routine from the production uci to the MGR uci of
 ; the volume group
 ; 
 ; input:   routine name
 ; output:  uci routine copied from^uci copied to
 ; usage:   S X=$$MGRCHG^ZIBSETUP("routine_name")
 ;
 ;N ZIBCURR
 S ZIBRPROD=$TR(ZIBRPROD,"^"),ZIBRMGR=$TR(ZIBRMGR,"^") ; remove any "^" characters
 S ZIBCURR=$V(2,$J,2) ; get the number of the current UCI 
 ; V 2:$J:1:2 sets the current uci to the Volume Group MGR uci
 ; V 2:$J:ZIBCURR:2 resets the current uci
 S %="ZL @ZIBRPROD V 2:$J:1:2 ZS @ZIBRMGR V 2:$J:ZIBCURR:2"
 X % Q $ZU(0)_"^"_$ZU(1,0)
 ;
DI ; list of routines to copy into the MGR UCI of the Volume group for fileman installs.  END marks the end of the list
 ;;DIDT;%DT
 ;;DIDTC;%DTC
 ;;DIRCR;%RCR
 ;;END
 ;
XU ; list of routines to copy into the MGR UCI of the Volume group for kernel installs.  END marks the end of the list
 ;;ZIS*;
 ;;ZOS*;
 ;;ZTER*;
 ;;ZTL*;
 ;;ZTM*;
 ;;ZTEDIT*
 ;;END
 ;
MGR ; list of routines to copy into the MGR UCI of the Volume group.  END marks the end of the list
 ;;zzz;zz
 ;;DIDT;%DT
 ;;DIDTC;%DTC
 ;;DIRCR;%RCR
 ;;ZIS*;
 ;;ZOS*;
 ;;ZTER*;
 ;;ZTL*;
 ;;ZTM*;
 ;;ZTEDIT*
 ;;END
 ;
ERROR(ZIBRTN,ZIBUCI) ; output error message
 W !,"******* ERROR Routine "_ZIBRTN_" does not exist in "_ZIBUCI
 Q
 ;
OUTPUT(ZIBROU1,ZIBROU2,ZIBUCI1,ZIBUCI2) ;
 W !,"Routine "_ZIBROU1_" copied from "_ZIBUCI1_" to "_ZIBUCI2_" and saved as "_ZIBROU2_"."
 Q
