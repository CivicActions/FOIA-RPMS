BPDMSPKY ;ihs/cmi/maw - Prescription Monitoring Program - SSH Key Management;
 ;;2.0;CONTROLLED DRUG EXPORT SYSTEM;**4,6**;NOV 15, 2011;Build 16
 ;
 Q
 ;
EN ; Entry-point
 N STATEIEN,DIC,X,Y,DUOUT,DTOUT,PSOOS,LOCALDIR,X1,DIR,DIRUT,LOCALDIR
 W ! K DIC S DIC("A")="Select PDM SITE PARAMETERS SITE/LOCATION: ",DIC="^BPDMSITE(",DIC(0)="QOEAM"
 D ^DIC I X=""!(X="^")!$D(DUOUT)!$D(DTOUT) G END
 K DIC("A") G:Y<0 EN S (BPDMSITE,STATEIEN)=+Y
 ;
ACTION ; SSH Key Action
 K DIR S DIR("A")="Action"
 S DIR(0)="S^V:View Public SSH Key;N:Create New SSH Key Pair;"
 S DIR(0)=DIR(0)_"D:Delete SSH Key Pair"  ;H:Help with SSH Keys"
 S DIR("B")="V" D ^DIR I $D(DUOUT)!($D(DIRUT)) G END
 I Y="N"!(Y="D"),'$D(^XUSEC("BPDMZMENU",DUZ)) D  G ACTION
 . W !!,"The BPDMZMENU security key is required for this action.",$C(7)
 K ^TMP("BPDMPUBKY",$J) D RETRIEVE(STATEIEN,"PUB")
 ; 
 ; View Public SSH Key
 I Y="V" D  G ACTION
 . W ! D VIEW(STATEIEN),PAUSE
 ;
 ; Create New SSH Key Pair
 I Y="N" D  G ACTION
 . S PSOOS=$$BKENDOS()
 . I '$$OPENSSH^BPDMRDRN() W !,"OpenSSH is not installed/configured on the server, cannot continue..." Q
 . S LOCALDIR=$$GET1^DIQ(9002315.01,STATEIEN,1101)
 . I LOCALDIR="" D  Q
 . . W !!,"The SECURE DIRECTORY FOR FILE parameter is missing for ",$$GET1^DIQ(9002315.01,STATEIEN,.01),". Please,"
 . . W !,"update it in the View/Edit SPMP State Parameters option and try again.",$C(7) D PAUSE
 . K DIR S DIR("A")="SSH Key Encryption Type",DIR("?")="^D ETHELP^BPDMSPKY"
 . ;S DIR(0)="S^DSA:Digital Signature Algorithm (DSA);RSA:Rivest, Shamir & Adleman (RSA)"
 . S DIR(0)="S^RSA:Rivest, Shamir & Adleman (RSA)"
 . S DIR("B")="RSA" D ^DIR I $D(DUOUT)!($D(DIRUT)) Q
 . S ENCRTYPE=Y
 . I $D(^TMP("BPDMPUBKY",$J)) D
 . . W !!,$G(IOBON),"WARNING:",$G(IOBOFF)," You may be overwriting SSH Keys that are currently in use.",$C(7)
 . K DIR S DIR("A")="Confirm Creation of SSH Keys for "_$$GET1^DIQ(9002315.01,STATEIEN,.01),DIR(0)="Y",DIR("B")="NO"
 . W ! D ^DIR I $D(DIRUT)!$D(DUOUT)!'Y Q
 . ; Deleting Existing SSH Key
 . I $D(^TMP("BPDMPUBKY",$J)) D DELETE(STATEIEN)
 . W !!,"Creating New SSH Keys, please wait..."
 . ;N ZTRTN,ZTIO,ZTDESC,ZTDTH,ZTSK
 . ;S ZTRTN="NEWKEY^BPDMSPKY("_STATEIEN_","""_ENCRTYPE_""")",ZTIO=""
 . ;S ZTDESC="Prescription Drug Monitoring Program (PDMP) SSH Key Generation"
 . ;S ZTDTH=$$NOW^XLFDT() D ^%ZTLOAD K ZTSK
 . ;K ^TMP("BPDMPUBKY",$J)
 . ;F I=1:1:30 D RETRIEVE(STATEIEN,"PUB") Q:$D(^TMP("BPDMPUBKY",$J))  H 1
 . ; If unable to create the key via Taskman after 30 seconds, creates them in the foreground
 . I '$D(^TMP("BPDMPUBKY",$J)) D
 . . D NEWKEY(STATEIEN,ENCRTYPE),RETRIEVE(STATEIEN,"PUB")
 . I '$$KEYFILE(STATEIEN) D
 . . W !!,"There was a problem with the generation of the new SSH Key Pair."
 . . W !,"Please try again and if the problem persists contact IT Support.",$C(7) D PAUSE
 . E  W "Done",$C(7)
 ;
 ; Delete SSH Key Pair
 I Y="D" D  G ACTION
 . ;D RETRIEVE(STATEIEN,"PUB")
 . ;I '$D(^TMP("BPDMPUBKY",$J)) D  Q
 . ;. W !!,"[No SSH Key Pair found for ",$$GET1^DIQ(9002315.01,STATEIEN,.01),"]",$C(7)
 . ;W !!,$G(IOBON),"WARNING:",$G(IOBOFF)," You may be deleting SSH Keys that are currently in use.",$C(7)
 . K DIR S DIR("A")="Confirm Deletion of "_$$GET1^DIQ(9002315.01,STATEIEN,.01)_"'s SSH Keys",DIR(0)="Y",DIR("B")="NO"
 . W ! D ^DIR I $D(DIRUT)!$D(DUOUT)!'Y Q
 . W !!,"Deleting SSH Keys..." D DELETE(STATEIEN) H 1 W "Done",$C(7)
 ;
 ; SSH Key Help
 I Y="H" D HELP G ACTION
 ;
 G ACTION
 ;
END Q
 ;
KEYFILE(ST) ;did the key file get created
 S LOCDIR=$$GET1^DIQ(9002315.01,ST,1101)
 S KEYFILE=$S($$GET1^DIQ(9002315.01,ST,1408)]"":$$GET1^DIQ(9002315.01,ST,1408),1:"authorized_keys")
 S Y=$$LIST^%ZISH(LOCDIR,KEYFILE_"*",.KEY)
 I $O(KEY("")) Q 1
 Q 0
 ;
NEWKEY(STATEIEN,ENCRTYPE) ; Generate and store a pair of SSH keys for a specific state
 ; Input: (r) STATEIEN - State that will be using the new key pair. Pointer to the STATE file (#5)
 ;        (o) ENCRTYPE - SSH Encryption Type (DSA / RSA) (Default: DSA)
 N LOCALDIR,DATETIME,PSOOS,KEYFILE,PV,FILE2DEL,LINE,OVFLINE,NMSPC,KEYTXT,SAVEKEY,DIE,DR,DA,SSHFOLD
 ;
 I '$G(STATEIEN) Q  ;Error: State missing
 S PSOOS=$$OS^%ZOSV()
 S LOCALDIR=$$GET1^DIQ(9002315.01,STATEIEN,1101) I LOCALDIR="" Q  ;Error: Missing directory
 I $G(ENCRTYPE)'="DSA",$G(ENCRTYPE)'="RSA" S ENCRTYPE="RSA"
 ;
 S KEYFILE=$S($$GET1^DIQ(9002315.01,STATEIEN,1408)]"":$$GET1^DIQ(9002315.01,STATEIEN,1408),1:"authorized_keys")
 S SSHFOLD=$$GET1^DIQ(9002315.01,STATEIEN,1410)
 ;
 ; Deleting existing SSH Keys first
 D DELETE(STATEIEN)
 ;
 ; OpenVMS SSH Key Generation
 I PSOOS["NT" D
 . ;S BPDMKCAL=SSHFOLD_"ssh-keygen -q -N """" -C """" -t "_$$LOW^XLFSTR($G(ENCRTYPE))_" -f "_LOCALDIR_KEYFILE_""
 . S BPDMKCAL=SSHFOLD_"ssh-keygen -q -N """" -C """" -m pem -t "_$$LOW^XLFSTR($G(ENCRTYPE))_" -f "_LOCALDIR_KEYFILE_""  ;20220421 patch 6
 . ;S XXX=XXX
 . S XSSH="S PV=$ZF(-1,BPDMKCAL)"
 . X XSSH
 . ;X "S PV=$ZF(-1,BPDMKCAL)"
 . ;X "S PV=$ZF(-1,""ssh-keygen -q -N """" -C """" -t "_$$LOW^XLFSTR($G(ENCRTYPE))_" -f "_LOCALDIR_KEYFILE_""")"
 . ;S PV=$ZF(-1,"ssh-keygen -q -N """" -C """" -t "_$$LOW^XLFSTR($G(ENCRTYPE))_" -f "_LOCALDIR_KEYFILE_"")
 . S FILE2DEL(KEYFILE)="",FILE2DEL(KEYFILE_".PUB")=""
 ;
 ; Linux/Unix SSH Key Generation
 I PSOOS["UNIX" D
 . I '$$DIREXIST(LOCALDIR) D MAKEDIR(LOCALDIR)
 . ;X "S PV=$ZF(-1,""ssh-keygen -q -N '' -C '' -t "_$$LOW^XLFSTR($G(ENCRTYPE))_" -f "_LOCALDIR_KEYFILE_""")"  ;20220421 patch 6
 . X "S PV=$ZF(-1,""ssh-keygen -q -N '' -C '' -m pem -t "_$$LOW^XLFSTR($G(ENCRTYPE))_" -f "_LOCALDIR_KEYFILE_""")"
 . S FILE2DEL(KEYFILE)="",FILE2DEL(KEYFILE_".pub")=""
 ;
 K ^TMP("BPDMPRVKY",$J),^TMP("BPDMPUBKY",$J)
 ; Retrieving SSH Private Key Content
 S X=$$FTG^%ZISH(LOCALDIR,KEYFILE_$S(PSOOS["NT":"",1:""),$NAME(^TMP("BPDMPRVKY",$J,1)),3)
 I '$D(^TMP("BPDMPRVKY",$J,1)) Q
 ; Retrieving SSH Public Key Content
 S X=$$FTG^%ZISH(LOCALDIR,KEYFILE_$S(PSOOS["NT":".pub",1:".pub"),$NAME(^TMP("BPDMPUBKY",$J,1)),3)
 I '$D(^TMP("BPDMPUBKY",$J,1)) Q
 ;
 ; Saving new SSH Keys content in the PDMP SITE PARAMETERS file (#9002315.01)
 F NMSPC="BPDMPRVKY","BPDMPUBKY" D
 . K KEYTXT,SAVEKEY
 . F LINE=1:1 Q:'$D(^TMP(NMSPC,$J,LINE))  D
 . . ; Unix/Linux Public SSH Key has no line-feed (one long line)
 . . I NMSPC="BPDMPUBKY" D  Q
 . . . S KEYTXT(1)=^TMP(NMSPC,$J,LINE)
 . . . F OVFLINE=1:1 Q:'$D(^TMP(NMSPC,$J,LINE,"OVF",OVFLINE))  D
 . . . . S KEYTXT(1)=$G(KEYTXT(1))_^TMP(NMSPC,$J,LINE,"OVF",OVFLINE)
 . . S KEYTXT(LINE)=$$ENCRYP^XUSRB1(^TMP(NMSPC,$J,LINE))
 . I NMSPC="BPDMPUBKY" S KEYTXT(1)=$$ENCRYP^XUSRB1(KEYTXT(1))
 . S SAVEKEY(9002315.01,STATEIEN_",",$S(NMSPC="BPDMPRVKY":1500,1:1600))="KEYTXT"
 . D UPDATE^DIE("","SAVEKEY")
 . K ^TMP(NMSPC,$J)
 ;
 ; Saving SSH Key Format (SSH2/OpenSSH) and Encryption Type (DSA/RSA) fields
 K DIE S DIE="^BPDMSITE(",DA=STATEIEN
 S DR="1401///"_$S(PSOOS="UNIX":"SSH2",1:"OSSH")_";1402///"_ENCRTYPE D ^DIE
 ;
 ;L -@KEYFILE
 Q
 ;
RETRIEVE(STATEIEN,KEYTYPE) ; Retrieve the SSH Key into the ^TMP global
 ; Input: (r) STATEIEN - State to retrieve the SSH Key from
 ;        (o) KEYTYPE  - SSH Key Type (PUB - Public / PRV - PRivate) (Default: Public)
 ;Output: ^TMP("PSO[PUB/PRV]KY",$J,0)="SSH Key Format (SSH2 / OpenSSH)^Encryption Type (DSA / RSA)"
 ;        ^TMP("PSO[PUB/PRV]KY",$J,1-N)=[SSH Key Content]
 N X,LINE,KEYTXT,NMSPC
 I $G(KEYTYPE)'="PUB",$G(KEYTYPE)'="PRV" S KEYTYPE="PUB"
 S X=$$GET1^DIQ(9002315.01,STATEIEN_",",$S(KEYTYPE="PRV":1500,1:1600),,"KEYTXT")  ;TODO add fields to BPDMSITE and change to correct field names
 S NMSPC=$S(KEYTYPE="PRV":"BPDMPRVKY",1:"BPDMPUBKY")
 K ^TMP(NMSPC,$J)
 F LINE=1:1 Q:'$D(KEYTXT(LINE))  D
 . S ^TMP(NMSPC,$J,LINE)=$$DECRYP^XUSRB1(KEYTXT(LINE))
 I $D(^TMP(NMSPC,$J)) D
 . S ^TMP(NMSPC,$J,0)=$$GET1^DIQ(9002315.01,STATEIEN,1401,"I")_"^"_$$GET1^DIQ(9002315.01,STATEIEN,1402,"I")  ;
 Q
 ;
VIEW(STATEIEN) ; Displays the SSH Public Key
 ;Input: (r) STATEIEN - State to display the Public SSH Key for
 ;       ^TMP("BPDMPUBKY",$J,0)="SSH Key Format (SSH2 / OpenSSH)^Encryption Type (DSA / RSA)"
 ;       ^TMP("BPDMPUBKY",$J,1-N)=[SSH Key Content]
 N SSHKEY,DASHLN
 N LOCDIR,FILEC,SSHDA,KEYF
 K SSHFILES
 I '$G(STATEIEN) Q
 S KEYF=$S($$GET1^DIQ(9002315.01,STATEIEN,1409):$$GET1^DIQ(9002315.01,STATEIEN,1409),1:"authorized_keys")
 S LOCDIR=$$GET1^DIQ(9002315.01,STATEIEN,1101)
 S FILEC=$$LIST^%ZISH(LOCDIR,KEYF_"*",.SSHFILES)
 S SSHDA=0 F  S SSHDA=$O(SSHFILES(SSHDA)) Q:'SSHDA  D
 . W !,$G(SSHFILES(SSHDA))
 Q
 ;
DELETE(STATEIEN) ; Delete Both SSH Keys associated with the State
 ;Input: (r) STATEIEN - State from what the key should be deleted from in the SPMP STATE PARAMETERS file (#58.41)
 N DIE,DA,DR,LOCDIR,KEYF
 S KEYF=$S($$GET1^DIQ(9002315.01,STATEIEN,1409):$$GET1^DIQ(9002315.01,STATEIEN,1409),1:"authorized_keys")
 S LOCDIR=$$GET1^DIQ(9002315.01,STATEIEN,1101)
 S DIE="^BPDMSITE(",DA=+$G(STATEIEN),DR="1500///@;1600///@" D ^DIE
 S KEY(KEYF)=""
 S KEY(KEYF_".pub")=""
 D DEL^%ZISH(LOCDIR,"KEY")
 Q
 ;
OPENSSH() ; Returns the SSH Public Key in OpenSSH Format (Converts if necessary)
 ;Input: ^TMP("BPDMPUBKY",$J,0)="SSH Key Format (SSH2 / OpenSSH)^Encryption Type (DSA / RSA)"
 ;       ^TMP("BPDMPUBKY",$J,1-N)=[SSH Key Content]
 N OPENSSH,ENCRTYPE,LINE
 S OPENSSH=""
 I $P($G(^TMP("BPDMPUBKY",$J,0)),"^",1)="SSH2" D
 . S ENCRTYPE=$P($G(^TMP("BPDMPUBKY",$J,0)),"^",2),OPENSSH=""
 . F LINE=5:1 Q:'$D(^TMP("BPDMPUBKY",$J,LINE))  D
 . . I $G(^TMP("BPDMPUBKY",$J,LINE))["---- END" Q
 . . S OPENSSH=OPENSSH_$G(^TMP("BPDMPUBKY",$J,LINE))
 . S OPENSSH=$S(ENCRTYPE="RSA":"ssh-rsa",1:"ssh-dss")_" "_OPENSSH
 E  D
 . F LINE=1:1 Q:'$D(^TMP("BPDMPUBKY",$J,LINE))  D
 . . S OPENSSH=OPENSSH_$G(^TMP("BPDMPUBKY",$J,LINE))
 Q OPENSSH
 ;
BKENDOS() ; Returns the Backend Server Operating System (OS)
 ;Output: Backend Operating System (e.,g., "VMS", "UNIX")
 N BKENDOS,ZTRTN,ZTIO,ZTDESC,ZTDTH,ZTSK,I
 K ^XTMP("BPDMSPMKY",$J,"OS")
 S BKENDOS="",ZTRTN="SETOS^BPDMSPKY("_$J_")",ZTIO=""
 S ZTDESC="Prescription Drug Monitoring Program (BPDM) Backend Server OS Check"
 S ZTDTH=$$NOW^XLFDT() D ^%ZTLOAD
 F I=1:1:5 S BKENDOS=$G(^XTMP("BPDMSPMKY",$J,"OS")) Q:BKENDOS'=""  H 1
 K ^XTMP("BPDMSPMKY",$J,"OS")
 Q $S(BKENDOS'="":BKENDOS,1:$$OS^%ZOSV())
 ;
SETOS(JOB) ; Sets the Operating Systems in ^XTMP("BPDMSPMKY",$J,"OS") (Called via Taskman)
 ;Input: JOB - $Job value from calling process
 S ^XTMP("BPDMSPMKY",JOB,"OS")=$$OS^%ZOSV()
 Q
 ;
HELP ; SSH Key Help Text
 W !!,"Secure SHell (SSH) Encryption Keys are used to automate the data transmission"
 W !,"to the State Prescription Monitoring Programs (SPMPs). Follow the steps below"
 W !,"to successfully setup SPMP transmissions from VistA to the state/vendor server:"
 W !,""
 W !,"Step 1: Select the 'N' (Create New SSH Key Pair) Action and follow the prompts"
 W !,"        to create a new pair of SSH keys. If you already have an existing SSH"
 W !,"        Key Pair you can skip this step."
 W !,"        You can check whether you already have an existing SSH Key Pair"
 W !,"        through the 'V' (View Public SSH Key) Action."
 W !,""
 W !,"        Encryption Type: DSA or RSA?"
 W !,"        ----------------------------"
 D ETHELP,PAUSE
 W !!,"Step 2: Share the Public SSH Key content with the state/vendor. In order to"
 W !,"        successfully establish SPMP transmissions the state/vendor will have"
 W !,"        to install/configure the new SSH Key created in step 1 for the"
 W !,"        user id they assigned to your site. Use the 'V' (View Public SSH Key)"
 W !,"        Action to retrieve the content of the Public SSH key. The Public SSH"
 W !,"        Key should not contain line-feed characters, therefore after you copy"
 W !,"        & paste it from the terminal emulator into an email or text editor"
 W !,"        make sure it contains only one line of text (no wrapping)."
 Q
ETHELP ; Encryption Type Help
 W !,"        Digital Signature Algorithm (DSA) and Rivest, Shamir & Adleman (RSA)"
 W !,"        are two of the most common encryption algorithms used by the IT"
 W !,"        industry for securely sharing data. The majority of SPMP servers can"
 W !,"        handle either type; however there are vendors that accept only one"
 W !,"        specific type. You will need to contact the SPMP vendor support to"
 W !,"        determine which type to select."
 Q
 ;
PAUSE ; Pauses screen until user hits Return
 W ! K DIR S DIR("A")="Press Return to continue",DIR(0)="E" D ^DIR
 Q
 ;
DIREXIST(DIR) ; Returns whether the Linux Directory for SPMP sFTP already exists
 ;Input: DIR - Linux Directory name to be checked
 N DIREXIST
 I DIR="" Q 0
 I $$OS^%ZOSV()'="UNIX" Q 0
 I $$UP^XLFSTR($$VERSION^%ZOSV(1))'["CACHE" Q 0
 I $E(DIR,$L(DIR))="/" S $E(DIR,$L(DIR))=""
 X "S DIREXIST=$ZSEARCH(DIR)"
 Q $S(DIREXIST="":0,1:1)
 ;
MAKEDIR(DIR) ; Create a new directory
 ;Input: DIR - Linux Directory name to be created
 N MKDIR
 I $$OS^%ZOSV()'="UNIX" Q
 I $$UP^XLFSTR($$VERSION^%ZOSV(1))'["CACHE" Q
 I $$DIREXIST(DIR) Q
 X "S MKDIR=$ZF(-1,""mkdir ""_DIR)"
 I 'MKDIR X "S MKDIR=$ZF(-1,""chmod 777 ""_DIR)"
 Q
 ;
