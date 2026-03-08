ACGSGET ;IHS/OIRM/DSD/THL,AEF - ROUTINE TO GET CIS FILES FROM AREA MACHINES;     [ 10/27/2004   4:19 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;**13**;FEB 16, 2000
 ;;IHS/ITSC/SD/MRS:ACR*2.1*9 - MODIFIED FOR CACHE COMPLIANCY
EN D EN1
EXIT K ACG,ACGI,ACGX
 Q
EN1 ;
 ;F ACGI=235,239,245 S ACG=$P($T(@ACGI),";;",2) Q:ACG=""  S ACGX="getfrom "_$P(ACG,";")_" /usr/mumps/acg"_$P(ACG,";",2)_".asc > /dev/null",ACGX=$$JOBWAIT^%HOSTCMD(ACGX)  ;ACR*2.1*13.06 IM14144
 N ARMSDIR,ZISH1,ZISH2,ZISH3,ZISH4,ZISH5     ;ACR*2.1*13.06 IM14144
 S ARMSDIR=$$ARMSDIR^ACRFSYS(1)              ;ACR*2.1*13.06 IM14144
 Q:ARMSDIR']""                               ;ACR*2.1*13.06 IM14144
 F ACGI=235,239,245 S ACG=$P($T(@ACGI),";;",2) Q:ACG=""  D  ;ACR*2.1*13.06 IM14144
 .S ZISH1=ARMSDIR                            ;ACR*2.1*13.06 IM14144
 .S ZISH2=$P(ACG,";",2)_".asc"               ;ACR*2.1*13.06 IM14144
 .S ZISH3=$P(ACG,";")                        ;ACR*2.1*13.06 IM14144
 .S ZISH4=""                                 ;ACR*2.1*13.06 IM14144
 .S ZISH5="/dev/null"                        ;ACR*2.1*13.06 IM14144
 .S ACGX=$$FROM^%ZISH(ZISH1,ZISH2,ZISH3,ZISH4,ZISH5)  ;ACR*2.1*13.06 IM14144
 Q
DATA ;;
161 ;;dallas;16192
102 ;;seattle;10292
235 ;;cao-as;235
239 ;;bji-ao;239
241 ;;abr-ab;241
242 ;;albaao;242
243 ;;akproc;243
244 ;;bilbao;244
245 ;;nav-aa;245
246 ;;okc-ao;246
247 ;;phx-ao;247
248 ;;pordps;248
249 ;;tucdev;24992
285 ;;nsaoa;285
Q ;;
