BUSAUTL1 ;GDIT/HS/BEE-IHS USER SECURITY AUDIT Utility Program 1 ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;**3,4**;Nov 05, 2013;Build 71
 ;
 Q
 ;
LOG(DUZ,AMCAT,AMACT,AMCALL,AMDESC,AMERVDFN) ;EP - File entry into BUSA
 ;
 NEW X
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Define DUZ variable
 I $G(DUZ)="" Q
 D DUZ^XUP(DUZ)
 ;
 ;Log the entry
 D LOG^AMERBUSA($G(AMCAT),$G(AMACT),$G(AMCALL),$G(AMDESC),.AMERVDFN)
 ;
 Q
 ;
 ;This is the SET logic called by the 'S' mumps cross reference on the
 ;BUSA SWITCH SETTINGS file LOGGING STATUS (#.02) field.  This index is different
 ;from other indexes in that there will only be one index per switch type. This
 ;allows the API call to look for this index for a switch and if defined easily
 ;determine that the switch is on. The variable DA should be set.
 NEW DA
 ;
SSET ;EP - Switch Status Set
 ;
 NEW SWITCH,STATUS
 ;
 I $G(DA)="" Q
 ;
 ;Retrieve entry information
 S SWITCH=$$GET1^DIQ(9002319.04,DA_",",".01","I") Q:SWITCH=""
 S STATUS=$$GET1^DIQ(9002319.04,DA_",",".02","I")
 ;
 ;Clear any existing entry for the switch type
 K ^BUSA(9002319.04,"S",SWITCH)
 ;
 ;Create new entry if enabled
 I STATUS S ^BUSA(9002319.04,"S",SWITCH,STATUS,DA)=""
 ;
 Q
 ;
 ;This is the KILL logic called by the 'S' mumps cross reference on the
 ;BUSA SWITCH SETTINGS file LOGGING STATUS (#.02) field.  This index is different
 ;from other indexes in that there will only be one index per switch type. Only 
 ;switches that are enabled will have an entry. The variable DA should be set
 ;
SKILL ;EP - Switch Status Kill
 ;
 NEW SWITCH
 ;
 I $G(DA)="" Q
 ;
 ;Retrieve switch
 S SWITCH=$$GET1^DIQ(9002319.04,DA_",",".01","I") Q:SWITCH=""
 ;
 ;Clear all entries for the selected switch
 K ^BUSA(9002319.04,"S",SWITCH)
 ;
 Q
 ;
 ;This is the SET logic called by the 'F' mumps cross reference on the
 ;BUSA FILEMAN AUDIT INCLUSIONS file AUDIT FILE (#.02) field. This cross
 ;reference allows the BUSA API call which returns whether to audit a 
 ;file or not by utilizing just one global hit.
 ;
FSET ;EP - File Audit Set
 ;
 NEW FFILE,AUDIT
 ;
 I $G(DA)="" Q
 ;
 ;Retrieve entry information
 S FFILE=$$GET1^DIQ(9002319.08,DA_",",".01","I") Q:FFILE=""
 S AUDIT=$$GET1^DIQ(9002319.08,DA_",",".02","I")
 ;
 ;Clear any existing entry for the file
 K ^BUSAFMAN("F",FFILE)
 ;
 ;Create new entry if enabled
 I AUDIT S ^BUSAFMAN("F",FFILE,AUDIT,DA)=""
 ;
 Q
 ;
 ;This is the KILL logic called by the 'F' mumps cross reference on the
 ;BUSA FILEMAN AUDIT INCLUSIONS file AUDIT FILE (#.02) field. This cross
 ;reference allows the BUSA API call which returns whether to audit a 
 ;file or not by utilizing just one global hit.
 ;
FKILL ;EP - File Audit Kill
 ;
 NEW FFILE
 ;
 I $G(DA)="" Q
 ;
 ;Retrieve switch
 S FFILE=$$GET1^DIQ(9002319.08,DA_",",".01","I") Q:FFILE=""
 ;
 ;Clear all entries for the selected switch
 K ^BUSAFMAN("F",FFILE)
 ;
 Q
 ;
 ;This is the SET logic called by the 'F' mumps cross reference on the
 ;BUSA FILEMAN LOCAL AUDIT DEF file FIELD NUMBER (#.01) field. This field
 ;is a subfield in the FIELD NUMBER (#1) multiple in the FILE NUMBER (#1)
 ;multiple. The cross reference is used in the switch logic to cycle back to
 ;the original FileMan values
 ;
ASET ;EP - BUSA FILEMAN LOCAL AUDIT DEF F XREF SET
 ;
 NEW BFIL,BFLD,BENT
 S BENT=+$G(DA(2)) Q:'BENT
 S BFIL=$P($G(^BUSAFDEF(+$G(DA(2)),1,+$G(DA(1)),0)),U) Q:BFIL=""
 S BFLD=$P($G(^BUSAFDEF(+$G(DA(2)),1,+$G(DA(1)),1,+$G(DA),0)),U) Q:BFLD=""
 S ^BUSAFDEF(BENT,"F",BFIL,BFLD,+$G(DA(1)),+$G(DA))=""
 ;
 Q
 ;
 ;This is the KILL logic called by the 'F' mumps cross reference on the
 ;BUSA FILEMAN LOCAL AUDIT DEF file FIELD NUMBER (#.01) field. This field
 ;is a subfield in the FIELD NUMBER (#1) multiple in the FILE NUMBER (#1)
 ;multiple. The cross reference is used in the switch logic to cycle back to
 ;the original FileMan values
AKILL ;EP - BUSA FILEMAN LOCAL AUDIT DEF F XREF KILL
 ;
 NEW BFIL,BFLD,BENT
 S BENT=+$G(DA(2)) Q:'BENT
 S BFIL=$P($G(^BUSAFDEF(+$G(DA(2)),1,+$G(DA(1)),0)),U) Q:BFIL=""
 S BFLD=$P($G(^BUSAFDEF(+$G(DA(2)),1,+$G(DA(1)),1,+$G(DA),0)),U) Q:BFLD=""
 K ^BUSAFDEF(BENT,"F",BFIL,BFLD,+$G(DA(1)),+$G(DA))
 ;
 Q
