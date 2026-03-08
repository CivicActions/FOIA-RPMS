ACHSTXFD ;IHS/OIT/FCJ - RECORD 2(UFMS) FORMAT ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**13,29**;JUN 11, 2001;Build 86
 ;IHS/OIT/FCJ ACHS*3.1*13 - New routine
 ;;ACHS*3.1*29 IHS.OIT.FCJ ADDED MOD FOR NEW UEI;5 DIGIT CAN;EFT
 ;NOTE: The "U" is stripped when processed at the Area.
 ;
 ;Routine: ACHSTXF
 ;;Record type 2 - FACILITY GENERATED UFMS RECORD.
 ;;   POS     LEN       VAR      NAME            JUSTIFY
 ;;   -----  ------  -------------------------------------
 ;;    1       2  constant RECORD TYPE (U2)
 ;;    3- 8    6  ACHSEFDT EFF DATE (MMDDYY)
 ;;    9-11    3           DESTINATION CODE
 ;;                           values: 050
 ;;    12      1           Reverse code
 ;;                           values: 2 = (-)
 ;;                           values: 1 = +
 ;;    13      1           Modifier code
 ;;                           values: 3 new
 ;;                           values: 5 Mod
 ;;                           values: 4 cancel
 ;;    14-16   3  ACHSTOS  323, 324, OR 325
 ;;    17-21   4           DEPT-AGENCY "HHSI"
 ;;    22-24   3  ACHSARCO Area contracting number
 ;;    25-36  12  ACHSDOCN DOCUMENT NUMBER
 ;;                   ACHSDFY  4 digit fy
 ;;                            3 Area Finance location code
 ;;                            5 numeric document number
 ;;                            1 Contract purchase type
 ;;    37-39  3            blanks                           ;ACHS*3.1*29 EXPANDED TO 6 DIG
 ;;    40      1            Geographic code constant=1      ;ACHS*3.1*29 NO LONGER USED
 ;;    41      1  X1        FISCAL YEAR                     ;ACHS*3.1*29 NO LONGER USED
 ;;    42-48   7  ACHSCAN   COMMON ACCOUNTING NUMBER        ;ACHS*3.1*29 42-48 TO 41-47 L-JST
 ;;    49-52   5  ACHSOBJC  OBJECT CLASS CODE               ;ACHS*3.1*29 49-52 TO 48-52 L-JST LENGTH 5 INST OF 4
 ;;    53-64  12  ACHSIPA   IHS PAYMENT AMOUNT       R zero fill
 ;;    65      1  ACHSFED   FED NON FED CODE         VENDOR
 ;;    66-77  12  ACHSEIN   EIN Vendor               R
 ;;    78-92  15            EIN secondary vendor
 ;;   93-131  39            Blanks
 ;;  132-133   2  ACHSY     FISCAL YEAR (YY)
 ;;  134       1            PAYMENT DESTINATION "F" OR "I"
 ;;  136-139   4  ACHSFC    USER ID (FINANCIAL CODE USED)
 ;;  139-151  13  ACHSDUNS  DUNS+4                    L
 ;;  162-173  12  ACHSUEI   VENDOR UEI                      ;ACHS*3.1*29 ADDED UEI
 ;;  174-177   4  ACHSEFT   VENDOR UEI                      ;ACHS*3.1*29 ADDED EFT
