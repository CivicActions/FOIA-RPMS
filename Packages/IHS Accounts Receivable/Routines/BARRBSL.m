BARRBSL ; IHS/SD/LSL - BATCH STATISTICAL LISTING RPT JAN 16,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**31**;OCT 26, 2005;Build 90
 ;BAR*1.8*31;1/5/2020;IHS/OIT/FCJ-CR#6369 CALLED BY BARRTSK TASKED REPORT OPTION
 ;
START ; EP
 ; Collections report using FM print
 D DATE
 G:$D(BAREFLG) END
 D DIPVAR
 D PRINT
 D EOP^BARUTL(1)
 ;
END ;
 Q
 ; *********************************************************************
 ;
DATE ;
 ; Select Date Range
 D DATE^BARRADAL
 Q
 ; *********************************************************************
 ;
PRINT ;EP ;**Print ;BAR*1.8*31;1/5/2020;IHS/OIT/FCJ-CR#6369 EP
 ;
 S BAR("SITE")=$P(^DIC(4,DUZ(2),0),U)
 S DIC="90051.01"
 S L=0
 S FR=BAR("BDOS")_","
 S TO=BAR("EDOS")_","
 S:$D(BARFILN) %ZIS("HFSNAME")=BARPTH_BARFILN,%ZIS("HFSMODE")="W",(IO(0),IOP)="HFS",%ZIS=0 ;BAR*1.8*31;1/5/2020;IHS/OIT/FCJ-CR#6369
 D EN1^DIP
 Q:$D(BARFILN)  ;BAR*1.8*31;1/5/2020;IHS/OIT/FCJ-CR#6369
 ;
DSP ; EP for VALM
 D ^%ZISC,HOME^%ZIS
 Q
 ; *********************************************************************
 ;
DIPVAR ;EP ;BAR*1.8*31;1/5/2020;IHS/OIT/FCJ-CR#6369 EP
 ; Set up DIP variables and Header routine
 Q:$D(BAREFLG)
 S BY="'4,+2;S2;L16"
 ; Changes required by new Collection Batch DD (Triggers)
 S FLDS="[BAR BSL DET]"
 S DHD="[BAR BSL HDR]"
 Q
