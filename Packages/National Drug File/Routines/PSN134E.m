PSN134E ;BIR/DMA-environment check ; 23 Feb 2007  7:58 AM
 ;;4.0; NATIONAL DRUG FILE;**134**; 30 Oct 98;Build 19
 I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
 E  W !!,"You must be a valid user." S XPDQUIT=2
 Q
