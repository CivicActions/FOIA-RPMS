HLPAT84 ;OIFO-O/RJH - HL7 PATCH 84 POST-INIT ;07/10/03  11:38
 ;;1.6;HEALTH LEVEL SEVEN;**84**;Oct 13, 1995
 Q
POST ; reindex field #3, DEVICE TYPE of file #870 (logical link file)
 N DIK
 S DIK="^HLCS(870,"
 S DIK(1)="400.03"
 D ENALL^DIK
 ;
CACHE ; for Cache/VMS multi-listeners, clear the following fields:
 ; #4 (State).
 ; #10 (Time Stopped)
 ; #14 (Shutdown LLP)
 ; #4.5 (Autostart)
 ; #400.01 (TCP/IP Address)
 ; #400.06 (Startup Node)
 ;
 I ^%ZOSF("OS")["OpenM",$$OS^%ZOSV["VMS" D
 . N HLIEN870,DIE,DA,DR
 . S HLIEN870=0
 . F  S HLIEN870=$O(^HLCS(870,"E","MS",HLIEN870)) Q:'HLIEN870  D
 .. S DIE="^HLCS(870,"
 .. S DA=HLIEN870
 .. S DR="4////@;10////@;14////@;4.5////@;400.01////@;400.06////@"
 .. D ^DIE
 Q
