BYIMAPI ;IHS/CIM/THL - IMMUNIZATION DATA EXCHANGE;
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**4,7**;AUG 20, 2020;Build 747
 ;
 ;REAL-TIME HL7 MESSAGE PROCESSING - API ENTRY POINTS
 ;
 ;=====
 Q
 ;
QUERY(PLIST,RETURN,BYIMRTD) ;PEP;Send Queries for patients listed in PLIST
 ;
 ;Input:
 ;PLIST    = ARRAY OF PATIENT DFN'S
 ;           PLIST(DFN1)=""
 ;           PLIST(DFN2)=""
 ;BYIMRTD   = 0 or "" if background call or no display wanted
 ;          = 1 if calling app wants list of VXU's sent to be displayed
 ;
 ;Returns:
 ;RETURN   = ARRAY OF QUERY MESSAGES CREATED
 ;
 N QDFN
 S:'$G(BYIMRTD) BYIMRTD=""
 S:'$D(BYIMEXST) BYIMEXST=""
 S:'$O(PLIST(0)) RETURN(1)="No patients listed"
 S QDFN=0
 F  S QDFN=$O(PLIST(QDFN)) Q:'QDFN  D
 .S X0=$G(^DPT(QDFN,0))
 .I X0="" S RETURN(QDFN)="No patient found for DFN: "_QDFN Q
 .S NAM=$E($P(X0,U),1,30)
 .S DOB=$P(X0,U,3)
 .S DOB=$E(DOB,4,5)_"/"_$E(DOB,6,7)_"/"_$E(DOB,2,3)
 .S MID=$$QBPX^BYIMRT(QDFN)
 .S RETURN(QDFN,"QS")="Query sent for.........: "_NAM_" (DFN-"_QDFN_") DOB: "_DOB_" MID: "_MID
 Q $O(RETURN(""))]""
 ;=====
 ;
SENDIMM(PLIST,RETURN,BYIMRTD) ;PEP;Send all immunizations for patients listed in PLIST
 ;
 ;Input:
 ;PLIST     = ARRAY OF PATIENT DFN'S
 ;            PLIST(DFN1)=""
 ;            PLIST(DFN2)=""
 ;BYIMRTD   = 0 or "" if background call or no display wanted
 ;          = 1 if calling app wants list of VXU's sent displayed
 ;
 ;Returns:
 ;RETURN    = ARRAY OF IMMUNIZATION MESSAGES CREATED
 ;
 N SDFN
 S:'$G(BYIMRTD) BYIMRTD=""
 S:'$O(PLIST(0)) RETURN(1)="No patients listed"
 S SDFN=0
 F  S SDFN=$O(PLIST(SDFN)) Q:'SDFN  D
 .S X0=$G(^DPT(SDFN,0))
 .I X0="" S RETURN(SDFN)="No patient found for DFN: "_SDFN Q
 .S MID=$$VXU^BYIMRT(SDFN)
 .S X0=$G(^DPT(SDFN,0))
 .S NAM=$E($P(X0,U),1,30)
 .S DOB=$P(X0,U,3)
 .S DOB=$E(DOB,4,5)_"/"_$E(DOB,6,7)_"/"_$E(DOB,2,3)
 .S RETURN(SDFN,"IS")="Immunizations sent for : "_NAM_" (DFN-"_SDFN_") DOB: "_DOB_" MID: "_MID
 Q $O(RETURN(""))]""
 ;=====
 ;
RESPONSE(PIEN,RESPONSE,ST,IND) ;PEP;RETURNS SIIS IMMUNIZATIONS FORECAST
 ;OR ERROR MESSAGE
 ;V3.0 PATCH 7 FID-104091 PARAMETER TO DISPLAY COMPONENTS OR COMBO
 ;
 ;IN:
 ;
 ;PIEN     = PATIENT DFN
 ;ST       = State for Query response
 ;           NULL = all states that have responded to query included
 ;           ST   = IEN from the STATE file, only responses from
 ;                  specified state included in response
 ;IND      = WHETHER TO INCLUDE INDIVIDUAL COMPONENTS OF COMPOUND VACC
 ;           0    = Compound vaccine only         
 ;           1    = Include individual components
 ;
 ;OUT:
 ;RESPONSE = MOST RECENT RESPONSE
 ;           Most recent response returned.
 ;           Multiple responses if site exchanges with multiple states
 ;
 ;           Response subscripts:
 ;
 ;           RESPONSE(PIEN,STATE,RESPONSE SEQ #,RESPONSE TYPE,LINE #)
 ;
 ;             PIEN   = PATIENT IEN/DFN
 ;             STATE  = NAME OF STATE
 ;             RIEN   = RESPONSE IEN
 ;             RESPONSE TYPE
 ;               IMMS     = IMMUNIZATION - immunizations from the SIIS
 ;               FORECAST = FORECAST     - forecasts from state SIIS
 ;               ERRORS   = HL7 message errors
 ;             LINE # = HL7 message line number
 ;
 ;RESPONSE LINE CONTAINS:
 ;
 ;    IMMUNIZATION
 ;        PIECE:
 ;        1   IMMUNIZATION
 ;        2   DATE ADMINISTERED
 ;        3   AGE
 ;        4   LOCATION OF ENCOUNTER
 ;        5   REACTION
 ;        6   VOLUME
 ;        7   INJECTION SITE
 ;        8   LOT NUMBER
 ;        9   MANUFACTURER
 ;        10  VACC INFO STATEMENT DATE
 ;        11  V IMMUNIZATION IEN
 ;        12  DUPLICATE IMMUNIZATION
 ;
 ;    FORECAST
 ;        PIECE:
 ;        1   VACCINE TYPE
 ;        2   STATUS IN SERIES
 ;        3   EARLIEST DATE
 ;        4   RECOMMENDED DATE
 ;        5   LATEST DATE
 ;
 ;    NO PATIENT RETURNED
 ;        NF  No Patient Match Found
 ;        TM  More than one Patient Match Found No patient info returned
 ;
R1 ;COMPILE RESPONSE
 ;V3.0 PATCH 7 FID-104091 PARAMETER TO DISPLAY COMPONENTS OR COMBO
 N STATE,DA,STNAM,X,Y,Z,RSX
 S:$G(IND)="" IND=0
 K RESPONSE
 S RESPONSE=1
 S PIEN=+$G(PIEN)
 S ST=+$G(ST)
 S STEND=$S(ST:ST+.9,1:999)
 S STNAM=$S($P($G(^DIC(5,ST,0)),U)]"":$P(^(0),U),1:"SIIS")
 S PNAM=$S(PIEN:$P($G(^DPT(PIEN,0)),U),1:"Patient parameter missing.")
 S:PNAM="" STNAM="SIIS",PNAM="NO PATIENT found for Patient ID: "_PIEN
 S VDAT=+$O(^BYIMRT("RSP",PIEN,9999999.999),-1)
 S STATE=$S(ST:ST-.01,1:.9)
 S STATE=+$O(^BYIMRT("RSP",PIEN,VDAT,STATE))
 S DA=+$O(^BYIMRT("RSP",PIEN,VDAT,STATE,0))
 S RSX=$G(^BYIMRT(DA,0))
 I RSX'["qbp",$P(RSX,U,2)="RSP" S VDAT=+$O(^BYIMRT("RSP",PIEN,VDAT),-1)
 S STATE=$S(ST:ST-.01,1:.9)
 F  S STATE=$O(^BYIMRT("RSP",PIEN,VDAT,STATE)) Q:'STATE!(STATE>STEND)  D
 .S DA=0
 .F  S DA=$O(^BYIMRT("RSP",PIEN,VDAT,STATE,DA)) Q:'DA  D
 ..S RSX=$G(^BYIMRT(DA,0))
 ..Q:RSX'["qbp"&($P(RSX,U,2)'="RSP")
 ..S STNAM=$S($P($G(^DIC(5,STATE,0)),U)]"":$P(^(0),U),1:"SIIS")
 ..S Z=0
 ..F  S Z=$O(^BYIMRT(DA,2,Z)) Q:'Z  S X=$G(^(Z,0)) D:X]""
 ...;V3.0 PATCH 7 FID-104091 PARAMETER TO DISPLAY COMPONENTS OR COMBO
 ...I 'IND,Z["." Q
 ...I IND,Z'["." Q:$G(^BYIMRT(DA,2,Z+.1,0))
 ...S CVX=+$P(X,U)
 ...S DG=+$$DG(CVX)
 ...S RESPONSE(PIEN,STNAM,VDAT,"IMMS",DG,Z)=X
 ..S Z=0
 ..F  S Z=$O(^BYIMRT(DA,3,Z)) Q:'Z  S X=$G(^(Z,0)) D:X]""
 ...S CVX=+$P(X,U)
 ...S DG=+$$DG(CVX)
 ...S $P(X,U,3)=$$CODE($P(X,U,3))
 ...S RESPONSE(PIEN,STNAM,VDAT,"FORECAST",DG,Z)=X
 ..Q:$G(^BYIMRT(DA,0))'["qbp"&($G(^BYIMRT(DA,0))'["vxu")
 ..S Z=0
 ..F  S Z=$O(^BYIMRT(DA,4,Z)) Q:'Z  S X=$G(^(Z,0)) D:$P(X,U)]""
 ...I "TMNF"[$P(X,U) D  Q
 ....S RESPONSE(PIEN,STNAM,VDAT,"ERROR",Z)=$P(X,U,2)
 ...I "TMNF"'[$P(X,U) D
 ....S RESPONSE(PIEN,STNAM,VDAT,"ERROR",Z)=X
 ....F J=1:1:5 S X=$G(^BYIMRT(DA,4,Z,J)) D:X["NOTE"
 .....S RESPONSE(PIEN,STNAM,VDAT,"ERROR",Z)=X
 ;PATCH 4 - FID-76220
 ;Remove extraneous statements
 I $O(RESPONSE(""))="" D
 .I PNAM'["NO PAT",PNAM'["missing" S (RESPONSE,RESPONSE(PIEN,STNAM,0,"ERROR","NO",1))="No Query Response: "_PNAM
 .E  S (RESPONSE,RESPONSE(PIEN,STNAM,0,"ERROR","NO",1))=PNAM
 .S:$L($G(RESPONSE))>1 RESPONSE="-1^"_RESPONSE
 ;PATCH 4 - FID-76220 END
 Q RESPONSE
 ;V3.0 PATCH 7 FID-104091 END
 ;=====
 ;
DG(CVX) ;RETURN VACCINE DISPLAY GROUP
 S CVXDA=+$O(^AUTTIMM("C",CVX,0))
 S DG=+$P($G(^AUTTIMM(CVXDA,0)),U,9)
 S DG=+$P($G(^BISERT(DG,0)),U,2)
 Q DG
 ;=====
 ;
CODE(CODE) ;DUE CODE
 N X,Y,Z
 S:$G(CODE)="" CODE=""
 S X=CODE_":"
 S Y=$P(^DD(90480.23,.03,0),U,3)
 S:$L(X)>1 CODE=$P($P(Y,X,2),";")
 Q CODE
 ;=====
 ;
RD(PIEN,RESPONSE,ST) ;PEP;RETURN DATE OF LAST RESPONSE - BY STATE
 N STATE,DA,STNAM,X,Y,Z
 K RESPONSE
 S RESPONSE=1
 S PIEN=+$G(PIEN)
 S ST=+$G(ST)
 S STEND=$S(ST:ST+.9,1:999)
 S STNAM=$S($P($G(^DIC(5,ST,0)),U)]"":$P(^(0),U),1:"SIIS")
 S PNAM=$S(PIEN:$P($G(^DPT(PIEN,0)),U),1:"Patient parameter missing.")
 S:PNAM="" STNAM="SIIS",PNAM="NO PATIENT found for Patient ID: "_PIEN
 S VDAT=+$O(^BYIMRT("RSP",PIEN,9999999.999),-1)
 S STATE=$S(ST:ST-.01,1:.9)
 F  S STATE=$O(^BYIMRT("RSP",PIEN,VDAT,STATE)) Q:'STATE!(STATE>STEND)  D
 .S DA=0
 .F  S DA=$O(^BYIMRT("RSP",PIEN,VDAT,STATE,DA)) Q:'DA  D
 ..S STNAM=$S($P($G(^DIC(5,STATE,0)),U)]"":$P(^(0),U),1:"SIIS")
 ..S RESPONSE(PIEN,STNAM,VDAT,"RD")=$P(VDAT,".")+17000000
 ;PATCH 4 - FID-76220
 ;Remove extraneous statements
 I $O(RESPONSE(""))="" D
 .S (RESPONSE,RESPONSE(PIEN,STNAM,0,"RD"))="No Query Response on file."
 ;PATCH 4 - FID-76220 END
 S:$L($G(RESPONSE))>1 RESPONSE="-1^"_RESPONSE
 Q RESPONSE
 ;=====
 ;
