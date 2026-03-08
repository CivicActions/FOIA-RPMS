ZTMDCL ;SFISC/RWF - Run Taskman with a DCL context. ;05/17/96  07:47 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**24**;JUL 03, 1995
 ;This assumes that TM was started with a DCL context.
 N QUEUE S QUEUE=$S(ZTNODE]"":ZTNODE,1:%ZTNODE)
 ;Use the next line if you want/need log files
 ;S %SPAWN="SUBMIT/NOPRINT/NOKEEP/QUEUE=TM$"_QUEUE_" ZTMSWDCL.COM/PARAM=("_%ZTPFLG("DCL")_","_ZTUCI_","_ZTDVOL_")"
 ;Use the next line if you don't need log files.
 S %SPAWN="SUBMIT/NOPRINT/NOLOG/QUEUE=TM$"_QUEUE_" ZTMSWDCL.COM/PARAM=("_%ZTPFLG("DCL")_","_ZTUCI_","_ZTDVOL_")"
 S %=$ZC(%SPAWN,%SPAWN) I 1
 Q
