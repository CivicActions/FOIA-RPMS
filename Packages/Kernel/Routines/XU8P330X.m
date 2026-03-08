XU8P330X ;OIFO-O/SO-CREATE NEW-STYLE XREF ;12:29 PM  16 Jan 2004
 ;;8.0;KERNEL;**330**;Jul 10, 1995
 ;
 N XU8PXR,XU8PRES,XU8POUT
 S XU8PXR("FILE")=200
 S XU8PXR("NAME")="AUSER"
 S XU8PXR("TYPE")="MU"
 S XU8PXR("USE")="S"
 S XU8PXR("EXECUTION")="R"
 S XU8PXR("ACTIVITY")="IR"
 S XU8PXR("SHORT DESCR")="Build cross reference of active users"
 S XU8PXR("DESCR",1)="This is a cross reference of CPRS Active USERs (AUSER) and is set if:"
 S XU8PXR("DESCR",2)=" a. the IEN is not less than 1"
 S XU8PXR("DESCR",3)=" and"
 S XU8PXR("DESCR",4)=" b. the Kernel API $$PROVIDER^XUSER(ien) is True; IA#: 2343"
 S XU8PXR("DESCR",5)=" "
 S XU8PXR("DESCR",6)=" The cross reference is in the format:"
 S XU8PXR("DESCR",7)=" ^VA(200,""AUSER"",<NAME(#.01) value>,IEN)="""""
 S XU8PXR("SET")="I DA'<1,$$PROVIDER^XUSER(DA),X(1)]"""" S ^VA(200,""AUSER"",X(1),DA)="""""
 S XU8PXR("KILL")="I ((DA'<1&X1(1)'=X2(1))!(DA'<1&X2(2)="""")) K ^VA(200,""AUSER"",X1(1),DA)"
 S XU8PXR("WHOLE KILL")="K ^VA(200,""AUSER"")"
 S XU8PXR("SET CONDITION")="Q"
 S XU8PXR("KILL CONDITION")="Q"
 S XU8PXR("VAL",1)=.01
 S XU8PXR("VAL",1,"COLLATION")="F"
 S XU8PXR("VAL",2)=2
 S XU8PXR("VAL",2,"COLLATION")="F"
 D CREIXN^DDMOD(.XU8PXR,"SW",.XU8PRES,"XU8POUT")
 Q
