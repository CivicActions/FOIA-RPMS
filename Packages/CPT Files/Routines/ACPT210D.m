ACPT210D ;IHS/SD/SDR - ACPT*2.10*1 install ; 12/21/2008 00:29
 ;;2.10;CPT FILES;**1**;JAN 8, 2009
 ;
IMPORT ; Import CPTs from AMA files
 ;
 S ACPTYR=3100101
 D BMES^XPDUTL("CPT 2010 Patch 1 Install (CPT v2.10 p1)")
 D MES^XPDUTL("CPT v2.10 p1 contains 2010 HCPCS codes and modifiers")
 D MES^XPDUTL("The install will attempt to read the HCPCS file")
 D MES^XPDUTL("acpt2010.01h from the directory you specified")
 ;
 ;Get the directory containing the two files
 N ACPTPTH S ACPTPTH=$G(XPDQUES("POST1")) ; path to files
 I ACPTPTH="" D  ; for testing at programmer mode
 .S ACPTPTH=$G(^XTV(8989.3,1,"DEV")) ; default directory
 .D POST1(.ACPTPTH) ; input transform
 ;
 ; Installing 2010 CPTs from file acpt2010.01h
 D BMES^XPDUTL("Loading 2010 HCPCSs from file acpt2010.01h")
 I $$VERSION^XPDUTL("BCSV")<1 D IMPORT^ACPT2101  ;(non-CSV) all codes (adds/edits/deletes)
 I $$VERSION^XPDUTL("BCSV")>0 D IMPHCPCS^ACPT2102  ;(CSV) all codes (adds/edits/deletes)
 ;
 ; Reindexing CPT file (81); this will take awhile.
 D BMES^XPDUTL("Reindexing CPT file (81); this will take awhile.")
 N DA,DIK S DIK="^ICPT(" ; CPT file's global root
 D IXALL^DIK ; set all cross-references for all records
 D ^ACPTCXR ; rebuild C index for all records
 ;
 ; Reindexing CPT Modifier file (9999999.88).
 D BMES^XPDUTL("Reindexing CPT Modifier file (9999999.88)")
 S DIK="^AUTTCMOD(" ; MODIFIER file's global root
 D IXALL^DIK ; set all cross-references for all records
 ;
 Q
POST1(ACPTDIR) ; input transform for KIDS question POST1
 ;
 ; .ACPTDIR, passed by reference, is X from the Fileman Reader, the
 ; input to this input transform.
 ;
 I $ZV["UNIX" D  ; if unix, ensure proper syntax for unix
 .S ACPTDIR=$TR(ACPTDIR,"\","/") ; forward slash should delimit
 .S:$E(ACPTDIR)'="/" ACPTDIR="/"_ACPTDIR ; start with root (/)
 .S:$E(ACPTDIR,$L(ACPTDIR))'="/" ACPTDIR=ACPTDIR_"/" ; ensure trailing /
 ;
 E  D  ; otherwise, ensure proper syntax for other operating systems
 .S ACPTDIR=$TR(ACPTDIR,"/","\") ; back slash should delimit
 .I $E(ACPTDIR)'="\",ACPTDIR'[":" D
 ..S ACPTDIR="\"_ACPTDIR ; start with \ if not using : (?)
 .S:$E(ACPTDIR,$L(ACPTDIR))'="\" ACPTDIR=ACPTDIR_"\" ; ensure trailing \
 ;
 W !!,"Checking directory ",ACPTDIR," ..."
 ;
 N ACPTFIND S ACPTFIND=0 ; do we find our files in that directory?
 ; find out whether that directory contains those files
 K ACPTFILE
 S ACPTFILE("acpt2010.01h")=""  ;HCPCS file
 N Y S Y=$$LIST^%ZISH(ACPTDIR,"ACPTFILE","ACPTFIND")
 D  Q:ACPTFIND  ;format for most platforms:
 .Q:'$D(ACPTFIND("acpt2010.01h"))
 .S ACPTFIND=1
 ; format for Cache on UNIX
 Q:'$D(ACPTFIND(ACPTDIR_"acpt2010.01h"))
 S ACPTFIND=1
 ;
 I $D(ACPTFIND("acpt2010.01h"))!$D(ACPTFIND(ACPTDIR_"acpt2010.01h")) D
 .W !,"HCPCS file acpt2010.01h found."
 ;
 I ACPTFIND D  Q  ; if they picked a valid directory
 .W !,"Proceeding with the install of ACPT 2.10 patch 1."
 ;
 W !!,"I'm sorry, but that cannot be correct."
 W !,"Directory ",ACPTDIR," does not contain that file."
 ;
 N ACPTFILE S ACPTFILE("*")=""
 N ACPTLIST
 N Y S Y=$$LIST^%ZISH(ACPTDIR,"ACPTFILE","ACPTLIST")
 W !!,"Directory ",ACPTDIR," contains the following files:"
 S ACPTF=""
 F  S ACPTF=$O(ACPTLIST(ACPTF)) Q:ACPTF=""  D
 .W !?5,ACPTF
 ;
 W !!,"Please select a directory that contains the HCPCS file."
 K ACPTDIR
 ;
 Q
