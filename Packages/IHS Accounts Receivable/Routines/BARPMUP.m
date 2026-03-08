BARPMUP ; IHS/SD/LSL - MANUAL UPLOAD PROCESS JAN 15,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**34**;OCT 26, 2005;Build 139
 ;
 ;IHS/SD/LSL 06/09/03 1.7*1 Modified to set BAR("OPT") to menu option to disquinish single bill upload during AR Bill creation
 ;
 ;IHS/SD/SDR 1.8*34 ADO76207 Added help text at beginning of menu option to clarify what it does
 ;
 ; ********************************************************************
 ;** Manual upload process
 ;
EN ;
 D ^BARVKL0
 S BARESIG=""
 ;
ENTRY ;
 ;start new bar*1.8*34 IHS/SD/SDR ADO76207
 W !!,"This option allows you to upload an individual bill from Third Party Billing."
 W !,"You may upload a bill that has not previously been uploaded."
 W !,"If you upload a bill that exists, it will only update existing bill entries."
 ;end new bar*1.8*34 IHS/SD/SDR ADO76207
 ;
 I '$G(BARESIG) D SIG^XUSESIG Q:X1=""  ;elec signature test
 S BARESIG=1
 I '$D(BARUSR) D INIT^BARUTL
 S BAROPT="Upload 1 bill"
 ;
LOOP ;
 F  D  Q:Y<0
 .W !!
 .D ONE^BARPMUP1
 ;
EXIT ;
 D EOP^BARUTL(1)
 D ^BARVKL0
 Q
