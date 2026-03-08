BJMDECKF ;VNGT/HS/AM-Pre Install ENVIRONMENT CHECK for BFMC; 18 Nov 2009  12:51 PM
 ;;1.0;CDA/C32;**1,2**;May 27, 2011
 ;
 ; Run pre-install checks
 ;W !,"Build Name XPDNM = ",XPDNM
 N EXEC,ROLES,FAC,STAT,NS,OBJ,C32DEST,DEFDEST,EDEST,DIR,METMS,METCS
 N METFS,METDFS,LIST,MET,TSC,DEFEDEST,OK,FS,ES,VERSION,BGP,TSKNM,ZTSK  ; 6/08/12 GCD SCCB-P03213 Added BGP, TSKNM, ZTSK.
 ;
 ; Verify Version
 ; 6/15/12 GCD SCCB-P04852 Made 2009 and 2010 checks more specific. Added check for 2012.1.
 ; 9/20/12 GCD SCCB-P05164 Changed check to 2012.2.
 S VERSION=$TR($$VERSION^%ZOSV," ")
 I VERSION'="2009.1.6",VERSION'="2010.2.3",VERSION'?1."2012.2".E D
 . W !,"Ensemble 2009.1.6, 2010.2.3, or 2012.2 is required!"
 . S XPDQUIT=2
 ;
 ; Verify that installer has proper roles
 ;
 S EXEC="S ROLES=$roles" X EXEC
 S ROLES=","_ROLES_",",U="^"
 I ROLES'[",%All," D
 . W !,"Your Ensemble account MUST have ""%All"" role to proceed!" S XPDQUIT=2
 S EXEC="S OK=($SYSTEM.SYS.MaxLocalLength()>3600000)"
 X EXEC
 I 'OK D  S XPDQUIT=2
 . W !,"Long Strings must be enabled in the System Management Portal!"
 ;
 ; Check if the BFMC job is currently running. 6/08/12 GCD SCCB-P03213
 K ZTSK
 S EXEC="S ZTSK=$D(^$Lock(""^BJMDPOST""))" X EXEC
 I ZTSK W !,"The BFMC post-installation job is already running. It may not be rescheduled until the job finishes." S XPDQUIT=2
 E  D  ; Check if the BFMC job is scheduled. 6/08/12 GCD SCCB-P03213
 . D RTN^%ZTLOAD("BKGRND^BJMDPOST","BGP")
 . S TSKNM=""
 . F  S TSKNM=$O(BGP(TSKNM)) Q:'TSKNM  K ZTSK S ZTSK=TSKNM D STAT^%ZTLOAD I $G(ZTSK(2))?1."Active".E D  S XPDQUIT=2 Q
 . . W !,"The BFMC post-installation job in already scheduled. Only one may be scheduled at a time."
 ;
 K LIST
 S EXEC="S NS=$SYSTEM.SYS.NameSpace()" X EXEC
 S EXEC="SET OBJ=##class(%ResultSet).%New(""%SYS.Namespace:List"") d OBJ.Execute()" X EXEC
 S EXEC="while (OBJ.Next()) { s LIST(OBJ.Data(""Nsp""))=1 }" X EXEC
 ;
 S EXEC="S NS=$SYSTEM.SYS.NameSpace()" X EXEC
 S EXEC="S DIR=##class(%SYS.Namespace).GetGlobalDest(NS),DIR=$P(DIR,""^"",2,99)" X EXEC
 S EXEC="Set MET=##class(%Monitor.System.Freespace).%New()" X EXEC
 S EXEC="S TSC=MET.Initialize()" X EXEC
 I $G(TSC)'=1 W !,"Space check monitor failed to initialize" S XPDQUIT=2 G Q
 ;
 ; 6/14/12 GCD SCCB-P03312 Changed DEFEDEST logic to work with Ensemble 2012
 S METMS=0,METCS=0,METFS=0,METDFS=0,METDS=0,DEFEDEST=""
 S EXEC="F  S TSC=MET.GetSample() Q:'TSC  S:MET.DBName=""CACHESYS"" METDFS=MET.DiskFreeSpace S:MET.DBName=""ENSLIB"" DEFEDEST=MET.Directory"
 S EXEC=EXEC_" I MET.Directory=DIR S:METCS=0 METMS=MET.MaxSize,METCS=MET.CurSize,METFS=MET.FreeSpace,METDS=MET.DiskFreeSpace" X EXEC
 ;
 ; check if enough space (only for the BFMC load and only if classes are not there already)
 S EXEC="S TSC=$SYSTEM.OBJ.GetPackageList(.BFMC,""BFMC"")" X EXEC
 I $O(BFMC(""))'="" G MAP
 I METCS=0 W !,"Space check monitor failed to find Cache Namespace with directory ",DIR S XPDQUIT=2
 I METDFS<2000 W !,"Disk space for CACHESYS is too low (",METDFS,"MB available, 2GB needed)" S XPDQUIT=2 G MAP
 S OK=0
 ;
 ; if unlimited cache.dat, then limit is FreeDiskSpace + FreeSpaceInCurrent_cache.dat
 I METMS=-1 S FS=METDS+METFS I FS>5000 S OK=1
 ; if limited cache.dat, then ExpansionSpace is smaller of FreeDiskSpace and (MaxSpace-CurrentSpace)
 ; then limit is Expansion Space+FreeSpaceInCurrentFile
 I METMS'=-1 S ES=METMS-METCS S:METDS<ES ES=METDS S FS=ES+METFS I FS>5000 S OK=1
 ; if not enough space and BFMC package is not loaded, then abort lest FILEFULL error occurs
 I 'OK W !,"Available space is ",FS,"MB, less than required 5 GB" S XPDQUIT=2
 ;
MAP ; Check that Ensemble globals are mapped to the default namespace of ENSLIB
 ; 6/14/12 GCD SCCB-P03312 Moved the check to after we get DEFEDEST
 S EXEC="S EDEST=##class(%SYS.Namespace).GetGlobalDest(NS,""^EnsDICOM.Dictionary"")" X EXEC
 I $P(EDEST,"^",2,999)'=DEFEDEST W !,"Ensemble is not properly mapped in ",NS,!!,"Please contact support before proceeding." S XPDQUIT=2
 ;
Q ;
 I $G(MET)'="" S EXEC="S TSC=MET.Shutdown()" X EXEC
 K BFMC
 Q
DTCK(DT) ;
 S %DT="FT",X=DT
 D ^%DT
 I Y=-1 Q 0
 S ZTDTH=Y
 Q 1
