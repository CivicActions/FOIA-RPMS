XMYMNEM ;(WASH ISC)/CAP - CONVERT MAILMAN HOST #'S TO MNEMONICS ;03/11/98  13:06
 ;;7.1;MailMan;**50**;Jun 02, 1994
 W !!,"This process will change ALL your MAILMAN HOST fields in the domain file"
 W !,"to MNEMONICS.  This change will mean that from now on you will never"
 W !,"need to patch another MAILMAN HOST number.  The MNEMONICS will always"
 W !,"be adjusted for any changes in configurations on the IDCU.",!!
 W "You may have domains in your domain file that are not included in this"
 W !,"list.  You are responsible for maintaining the MAILMAN HOST numbers for"
 W !,"these yourself.  They are not part of the standard domain file.  Don't"
 W !,"worry the old numbers will still work.",!!
 S U="^" D NOW^%DTC S XMDT=$E(%,4,5)_"/"_$E(%,6,7)_"/"_$E(%,2,3),%=$P(%,".",2) I $L(%) S %=$E(%_"000",1,4),XMDT=XMDT_" @ "_$E(%,1,2)_":"_$E(%,3,4)
R R !,"OPTION: CHECK//",X:299 E  W !!,"<< Time out ! " G END
 I X["^" G OUT
 G HELP:X="?" I X="" S XMF0="CHECK" G GO
 X ^%ZOSF("UPPERCASE") S X=Y S %="CHECK^REAL-CONVERSION" F I=1:1:$L(%,U) I $E($P(%,U,I),1,$L(X))=X S XMF0=$P(%,U,I) W $E(XMF0,$L(X)+1,99) G GO
HELP W !!,"Choose either CHECK or REAL CONVERSION",! G R
GO ;
 K %ZIS S %ZIS="Q"
 S ZTSAVE("XMF0")="",ZTSAVE("XMU")="",ZTSAVE("XMP")="",ZTSAVE("XMDT")=""
 D EN^XUTMDEVQ("ZTSK^XMYMNEM",XMF0_" MailMan Host Conversion",.ZTSAVE,.%ZIS)
 G KILL
ZTSK U IO K ^TMP($J) D DT^DICRW S XMA=0,XMPG=0 D ^XMYMNEM1,^XMYMNEM2 W !!,"WORKING",!! S XMD(1)=XMA,XMA=0
 G ^XMYMNEM0
OUT I X["^" W !!,"<< User requested Abort "
END W "Process aborted >>",!!,*7 G KILL
KILL K %,%0,I,X,Y,XMA,XMB,XMC,XMD,XMDT,XME,XMF,XMF0,XMP,XMPG,XMS,XMU
 K ZTUCI,ZTDTH,ZTSAVE,ZTRTN,ZTDESC,ZTIO,ZTSK
 Q
