DI ;SFISC/GFT-DIRECT ENTRY TO VA FILEMAN ;7/25/94  3:07 PM [ 09/10/1998  10:55 AM ]
V ;;21.0;VA Fileman;**1007**;SEP 8, 1998
V ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 G QQ:$G(^DI(.84,0))']""
C G QQ:$G(^DI(.84,0))']"" K (DTIME,DUZ) G ^DII
D G QQ:$G(^DI(.84,0))']"" G ^DII
P G QQ:$G(^DI(.84,0))']"" K (DTIME,DUZ)
Q G QQ:$G(^DI(.84,0))']"" S DUZ(0)="@" G ^DII
VERSION ;
 S VERSION=$P($T(V),";",3),X="VA FileMan V."_VERSION Q
 ;
QQ ;
 W $C(7),!!,"You must run ^DINIT first."
 Q
