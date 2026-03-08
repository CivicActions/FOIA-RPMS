BGP3PARP ; IHS/CMI/LAB - IHS gpra print ; [ 07/14/03  5:27 PM ]
 ;;2.0;IHS GPRA REPORTING;**2**;MAY 22, 2003
 ;
 ;
PRINT ;EP
 S BGPGPG=0
 S BGPQUIT=""
 I BGPROT="D" G DEL
 D AREACP^BGP3DH
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D PRINT1^BGP3DP
 Q:BGPQUIT
 Q:BGPROT="P"
DEL ;create delimited output file
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP3PDL ;create ^tmp of delimited report
 Q
 ;
