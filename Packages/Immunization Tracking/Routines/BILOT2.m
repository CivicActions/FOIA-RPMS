BILOT2 ;IHS/CMI/MWR - EDIT LOT NUMBERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**21,29,30**;OCT 24,2011;Build 125
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT VACCINE FIELDS: CURRENT LOT, ACTIVE, VIS DATE DEFAULT.
 ;   PATCH 2: Make Display Inactives a separate Action.  CHGORDR+11
 ;   PATCH 3: Correct leftover prompt from Inactive question. DISPLYI+7
 ;;  PATCH 21: Multiple changes for DTS Lot Number verification.
 ;
 ;
 ;----------
DTSCHK(BILOT,BIVAC,BIMAN,BINEW,BISLOT,BISMAN) ;EP
 ;V8.5 PATCH 29 - FID-105110 Remove COVID lot check
 Q 0
 ;---> Check DTS Server for Valid IHS COVID Lot Number.
 ;---> Returns a value of 1 if this Lot should NOT be added; 0=yes,add.
 ;---> Parameters:
 ;     1 - BILOT  (req) Text of the Lot Number.
 ;     2 - BIVAC  (req) Vaccine IEN.
 ;     3 - BIMAN  (req) Manufacturer IEN.
 ;     4 - BINEW  (opt) BINEW=1 means this was an Add (first time).
 ;     5 - BISLOT (opt) Original Lot Number text saved before edit screen.
 ;     6 - BISMAN (opt) Original Manufacturer pointer saved before edit screen.
 ;
 ;
 ;---> Quit if this is NOT a COVID Vaccine.
 Q:($$IMMVG^BIUTL2(BIVAC,2)'=21) 0
 ;--->Quit if required BYIM version not loaded:
 Q:($T(CVDDA^BYIMCOVD)="") 0
 ;---> Quit if COVID state is zero (not set up to transmit).
 Q:'$$CVDDA^BYIMCOVD 0
 ;---> Comment out above to test NO COVID State.
 ;
 ;
 N BIQUIT,BIPRMPT S BIQUIT=0,BIPRMPT="     Press <enter> to continue."
 N BIRES,BIRET,Y,Z
 ;---> Get MVX and Manufacturer name.
 N BIMVX S BIMVX=$$MNAME^BIUTL2(BIMAN,1)
 N BIMVXN S BIMVXN=$$MNAME^BIUTL2(BIMAN,2)
 ;
 ;---> Call DTS.
 S BIRES=$$CHKLOT^BIAPIDTS(.BIRET,$$CODE^BIUTL2(BIVAC),BILOT)
 ;
 ;---> Reset curson to top left of Help/Command Area.
 W $C(27,91)_((18))_$C(59)_((1))_$C(72)
 ;
 ;
 ;---> Uncomment to test failed DTS call.
 ;S BIRES=0
 ;
 ;---> DTS connection down and Lot Number not found in local database.
 I BIRES=0 D  Q BIQUIT
 .S Z="   Unable to verify this Lot Number against the IHS lot distribution list."
 .D WR(Z),WR(" ")
 .;---> If this is an edit and no change in Lot Number or Manufacturer,
 .;---> quit & save other changes, if any.
 .I 'BINEW,BILOT=BISLOT,BIMAN=BISMAN D DIRZ^BIUTL3(,BIPRMPT) Q
 .;---> Either new or changes to Lot Number and/or Manufacturer.
 .D SAVEYN(BILOT,BIVAC,BIMVX,BINEW,BIPRMPT,.BIQUIT)
 ;
 ;
 ;---> Lot Number found and Manufacturer matches.
 I $P(BIRET,U),($P(BIRET,U,2)=BIMVX) D  Q 0
 .S Z="   Lot Number "_BILOT_" for "_BIMVXN_" is a valid COVID lot number"
 .D WR(Z)
 .S Z="   on the IHS lot distribution list."
 .D WR(Z),WR(" ")
 .D DIRZ^BIUTL3(,BIPRMPT,,,,1)
 ;
 ;
 ;---> Lot Number found but Manufacturer does not match.
 I $P(BIRET,U),BIMVX'=$P(BIRET,U,2) D  Q BIQUIT
 .S Z="   The Manufacturer "_BIMVXN_" you have entered for lot number "_BILOT
 .D WR(Z)
 .S Z="   does *NOT* match the one ("_$P(BIRET,U,2)
 .S Z=Z_") on the IHS lot distribution list."
 .D WR(Z),WR(" ")
 .I 'BINEW,BILOT=BISLOT,BIMAN=BISMAN D DIRZ^BIUTL3(,BIPRMPT) Q
 .D SAVEYN(BILOT,BIVAC,BIMVX,BINEW,BIPRMPT,.BIQUIT)
 ;
 ;
 ;---> Lot Number not found.
 S Z="   Lot "_BILOT_" for "_BIMVXN_" is *NOT* a valid IHS COVID lot number"
 D WR(Z)
 S Z="   on the IHS lot distribution list."
 D WR(Z)
 I 'BINEW,BILOT=BISLOT,BIMAN=BISMAN D DIRZ^BIUTL3(,BIPRMPT) Q 0
 S Z="   Please verify the lot number you entered is correct."
 D WR(Z),WR(" ",1)
 D SAVEYN(BILOT,BIVAC,BIMVX,BINEW,BIPRMPT,.BIQUIT)
 Q BIQUIT
 ;
 ;---> Delete a bunch of bogus lot numbers.
 ;S DIK="^AUTTIML(" F DA=107:1:115 D ^DIK
 ;
SAVEYN(BILOT,BIVAC,BIMVX,BINEW,BIPRMPT,BIQUIT) ;EP
 ;---> Save Yes or No?
 ;
 N Z S Z="   Do you still wish to "_$S($G(BINEW):"add ",1:"save changes for ")
 S Z=Z_BILOT_" for "_$$VNAME^BIUTL2(BIVAC)_" (CVX "_$$CODE^BIUTL2(BIVAC)_")?"
 D WR(Z)
 N DIR
 S DIR("?")="       Enter NO to return to the Lot Number table with NO changes."
 S DIR("?",1)="       Enter YES to add add "_BILOT_" for "_$$VNAME^BIUTL2(BIVAC)_"."
 S DIR(0)="YA",DIR("A")="     Enter Yes or No: "
 D ^DIR D  D DIRZ^BIUTL3(,BIPRMPT)
 .N DIR
 .I '$G(Y) W !!?3,"No changes made, returning to Lot Number Table." S BIQUIT=1 Q
 .W "   Changes saved."
 .W !!?3,"Do you believe IHS was the source of this Lot of COVID vaccine?"
 .S DIR("?",1)="       Enter YES if IHS supplied this Lot of vaccine,"
 .S DIR("?")="       Enter NO if it came from another source."
 .S DIR(0)="YA",DIR("A")="     Enter Yes or No: "
 .D ^DIR
 .W "   Source is ",$S(Y:"",1:"not "),"IHS."
 .N BIMSG,X,Z
 .S BIMSG="We believe that IHS is "_$S(Y:"",1:"NOT ")
 .S BIMSG=BIMSG_"the source of this Lot of COVID vaccine."
 .;---> Send alert message via DTS. If DUZ undefined, send ADAM.
 .S X=$$LOG^BIAPIDTS($$CODE^BIUTL2(BIVAC),BILOT,BIMVX,BIMSG,$S($G(DUZ):DUZ,1:1))
 .;
 .;---> Remove negation to test failed Alert Message.
 .;---> Instruction below not used at this time.
 .;I '$P(X,U) D DIRZ^BIUTL3(,BIPRMPT) D
 .;.S Z="   Message alert error: "_X D WR(Z)
 .;.S Z="   Please submit a support ticket to enable lot verification." D WR(Z)
 ;
 Q
 ;
 ;
 ;----------
LOTDVAL(BIX) ;EP
 ;---> Sub-Lot data validation for Field 1.5, BI FORM-LOT NUMBER EDIT
 ;---> Parameters:
 ;     1 - BIX (req) The value of the Lot Number.
 ;
 Q:($G(X)="")  Q:($G(X)=0)
 ;
 I $D(^AUTTIML("B",BIX)) D  Q
 .S DDSSTACK="BI PAGE-LOT DUPLICATE WARNING"
 .;N Y S Y="This Lot Number already exists.  Please exit and select it from"
 .;S Y=Y_" the list.  (NOTE: It It may be Inactive. Try displaying Inactive as"
 .;S Y=Y_"well as Active.)"
 .;D HLP^DDSUTL(Y) S DDSERROR=1
 ;
 I BIX["*" D
 .S Y="The Lot Number may not contain an asterisk, ""*"". (This symbol is used to"
 .S Y=Y_" separate the Lot Number from the Sub-lot, if one is appended.)"
 .D HLP^DDSUTL(Y) S DDSERROR=1
 Q
 ;
 ;
 ;----------
SUBLOTD(BIA,BIX) ;EP
 ;---> Sub-Lot data validation for Field 1.5, BI FORM-LOT NUMBER EDIT
 ;---> Parameters:
 ;     1 - BIA (req) The value of the Lot Number.
 ;     2 - BIX   (req) The sub-lot entered.
 ;
 N Y,X
 Q:($G(BIX)="")
 S X=+(19-$L($G(BIA)))
 I $L($G(BIX))>(19-$L($G(BIA))) D  Q
 .S Y="The Sub-lot you entered, "_$G(BIX)_", is too long for this Lot Number."
 .S Y=Y_"  This Sub-lot must be "_X_" characters or less."
 .D HLP^DDSUTL(Y) S DDSERROR=1
 ;
 I BIX["*" D
 .S Y="The Sub-lot may not contain an asterisk, ""*"".  This symbol is used to"
 .S Y=Y_" separate the Lot Number from the Sub-lot."
 .D HLP^DDSUTL(Y) S DDSERROR=1
 Q
 ;
 ;
 ;----------
SUBLOTH(BIA) ;EP
 ;---> Sub-Lot Help for Field 1.5, BI FORM-LOT NUMBER EDIT
 ;---> Parameters:
 ;     1 - BIA (req) The value of the Lot Number.
 ;
 N X,Y
 S X=+(19-$L($G(BIA)))
 S Y="Enter/edit the Sub-lot suffix, if desired.  "
 D
 .I X S Y=Y_"The suffix for this Lot Number may be up to "_X_" characters long." Q
 .S Y=Y_"This Lot Number is too long for a sub-lot suffix."
 D HLP^DDSUTL(Y)
 Q
 ;
 ;
 ;----------
CHGORDR ;EP
 ;---> Menu for selecting Lot listing order.
 ;
 D FULL^VALM1,TITLE^BIUTL5("SELECT LOT LISTING ORDER"),TEXT2^BILOT1
 N DIR,Y
 S DIR(0)="SOA^"_$G(BISUBT)
 S DIR("A")="     Please select 1, 2, 3, 4, 5, or 6: "
 S DIR("B")=$G(BICOLL)
 D ^DIR
 S:(Y>0) BICOLL=Y
 ;
 D RESET^BILOT1
 Q
 ;
 ;
 ;----------
DISPLYI ;EP
 ;---> Display Inactive Lot Numbers.
 ;---> Called by Protocol:
 ;
 D FULL^VALM1,TITLE^BIUTL5("DISPLAY INACTIVE LOT NUMBERS YES/NO")
 W !!,"   Do you wish to include INACTIVE Lots in this display?"
 N DIR
 S DIR("?")="     Enter YES to include INACTIVE Lots."
 S DIR(0)="Y",DIR("A")="   Enter Yes or No",DIR("B")="NO"
 D ^DIR
 S BIINACT=$S(Y>0:1,1:0)
 D RESET^BILOT1
 Q
 ;
 ;
 ;----------
WR(Z,X) ;EP
 ;---> Write linefeed, Z, padded to a total of 80 characters.
 ;---> Parameters:
 ;     1 - Z  (req) Data to be padded.
 ;     2 - X  (opt) If X=1, no linefeed.
 S:Z="" Z=" "
 W:('$G(X)=1) !
 W $$PAD^BIUTL5(Z,80)
 Q
 ;=====
 ;
LOTERR ;EP;
 ;V8.5 PATCH 29 - FID-105110 Remove COVID lot check
 D CLEAR^VALM1,FULL^VALM1,TITLE^BIUTL5("EDIT LOT NUMBER FIELDS")
 W !!?23,"This Lot Number already exists!"
 W !!?18,"Please exit and select it from the list."
 W !!!!?5,"NOTE: It may be Inactive. Try displaying Inactive Lot Numbers"
 W !?11,"as well as Active ones.",!
 D DIRZ^BIUTL3()
 Q
 ;=====
 ;
