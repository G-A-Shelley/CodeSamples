       IDENTIFICATION DIVISION.
      *=================================================================
       PROGRAM-ID. GSPRGU.
       AUTHOR. GAVIN SHELLEY.


       ENVIRONMENT DIVISION.
      *=================================================================
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.


       DATA DIVISION.
      *=================================================================
       WORKING-STORAGE SECTION.
           COPY 'GSMAP2'.
           COPY 'DFHBMSCA'.


       01  WS-TRANSFER-FIELD               PIC X(3).
       01  WS-TRANSFER-LENGTH              PIC S9(4) COMP VALUE 3.
       01  WS-TRANSFER-PN                  PIC S9(4) COMP VALUE 25.
       01  WS-SAVE-LENGTH                  PIC S9(4) COMP VALUE 146.
       01  ORDFILE-LENGTH                  PIC S9(4) COMP VALUE 150.

       01 WS-SAVEAREA.
           05 WS-UPD-SW                    PIC X(03).
           05 SAVE-INV                     PIC X(07).
           05 SAVE-PRO1AI                  PIC X(04).
           05 SAVE-PRO1BI                  PIC X(04).
           05 SAVE-PRO2AI                  PIC X(04).
           05 SAVE-PRO2BI                  PIC X(04).
           05 SAVE-PRO3AI                  PIC X(04).
           05 SAVE-PRO3BI                  PIC X(04).
           05 SAVE-PRO4AI                  PIC X(04).
           05 SAVE-PRO4BI                  PIC X(04).
           05 SAVE-PRO5AI                  PIC X(04).
           05 SAVE-PRO5BI                  PIC X(04).
           05 SAVE-NAMEI                   PIC X(20).
           05 SAVE-ADD1I                   PIC X(20).
           05 SAVE-ADD2I                   PIC X(20).
           05 SAVE-ADD3I                   PIC X(20).
           05 SAVE-POS1I                   PIC X(03).
           05 SAVE-POS2I                   PIC X(03).
           05 SAVE-PHN1I                   PIC X(03).
           05 SAVE-PHN2I                   PIC X(03).
           05 SAVE-PHN3I                   PIC X(04).

       01 TRANSFER-VARIABLES.
           05 WS-TRANSFER-PRODUCT          PIC X(8).
           05 WS-TRANSFER-DESC             PIC X(17).

       01  CHECK-VARIABLES.
           05  WS-CHECK-PN-ENTRY           PIC X(03).

       01  ORDFILE-RECORD.
            05  ORDFILE-KEY.
                10  ORDFILE-PREFIX         PIC XXX VALUE 'XYZ'.
                10  ORDFILE-INVOICE-NO     PIC X(7).
            05  ORDFILE-NAME               PIC X(20).
            05  ORDFILE-PRODUCTS.
                10  ORDFILE-PRODUCT1.
                    15  ORDFILE-P1A        PIC X(4).
                    15  ORDFILE-P1B        PIC X(4).
                10  ORDFILE-PRODUCT2.
                    15 ORDFILE-P2A         PIC X(4).
                    15 ORDFILE-P2B         PIC X(4).
                10  ORDFILE-PRODUCT3.
                    15 ORDFILE-P3A         PIC X(4).
                    15 ORDFILE-P3B         PIC X(4).
                10  ORDFILE-PRODUCT4.
                    15 ORDFILE-P4A         PIC X(4).
                    15 ORDFILE-P4B         PIC X(4).
                10  ORDFILE-PRODUCT5.
                    15 ORDFILE-P5A         PIC X(4).
                    15 ORDFILE-P5B         PIC X(4).
            05  ORDFILE-ADDR-LINE1         PIC X(20).
            05  ORDFILE-ADDR-LINE2         PIC X(20).
            05  ORDFILE-ADDR-LINE3         PIC X(20).
            05  ORDFILE-POSTAL.
                10  ORDFILE-POSTAL-1       PIC XXX.
                10  ORDFILE-POSTAL-2       PIC XXX.
            05  ORDFILE-PHONE.
                10  ORDFILE-AREA-CODE      PIC XXX.
                10  ORDFILE-EXCHANGE       PIC XXX.
                10  ORDFILE-PHONE-NUM      PIC XXXX.
            05  FILLER                     PIC X(4) VALUE SPACES.

       01 INVOICE-HOLD.
           05  KEEP-INV                    PIC X(7).

       01 PRODUCT-NUMBER.

           05  PRODUCT-A                   PIC X(4).
           05  PRODUCT-B                   PIC X(4).

       01 TRIM-ORDFILE-DATA.
           05  WS-TRIM-DATA                PIC X(20).
           05  WS-TRIM-SPACES              PIC 9(4) VALUE 0.
           05  WS-TRIM-LEN                 PIC 9(4) VALUE 0.

       LINKAGE SECTION.
      *=================================================================
       01 DFHCOMMAREA.
           05  LK-SAVE                     PIC X(146) .



       PROCEDURE DIVISION.
      *=================================================================
      *=================================================================


       000-START-LOGIC.
      * START OF PROGRAM CODE
      *=================================================================

           *> TRANSFER CONTROL FROM OTHER SCREENS
           *>=============================================
           IF EIBCALEN EQUAL 3
               GO TO 100-FIRST-TIME
           END-IF.

           *> CONDITION HANDLERS / RECIEVE MAP
           *>=============================================
           EXEC CICS HANDLE CONDITION
               MAPFAIL(100-FIRST-TIME)
           END-EXEC.
           EXEC CICS HANDLE CONDITION
               NOTFND(200-NOT-FOUND)
           END-EXEC.
           EXEC CICS
               HANDLE AID PF1 (300-FNC1-MENU)
           END-EXEC.
           EXEC CICS
               HANDLE AID PF4 (400-FNC4-EXIT)
           END-EXEC.
           EXEC CICS
               HANDLE AID PF7 (500-FNC7-CLEAR)
           END-EXEC.
           EXEC CICS HANDLE CONDITION
               DUPREC(600-DUPLICATE)
           END-EXEC.

           *> REVIEVE MAP AND MAPSET
           EXEC CICS
               RECEIVE MAP('MAP2') MAPSET('GSMAP2')
           END-EXEC.

           *> MOVE THE INFORMATION FROM THE COMMAREA TO SAVEAREA
           *>=============================================
           MOVE LK-SAVE TO WS-SAVEAREA.

           *> CHECK FOR UPDATE OR INQUIRY PROCESSING
           *>=============================================
           IF WS-UPD-SW EQUALS 'UPD'
               GO TO 2000-INVOICE-CHANGE
           ELSE
               GO TO 1000-INQUIRY-LOGIC
           END-IF.

       000-EXIT.


       100-FIRST-TIME.
      * FIRST TIME RUN / MAP FAIL PARAGRAPH
      *=================================================================

           *> CLEAR THE MAP AND SEND TO THE SCREEN
           *>=============================================
           MOVE 'XXX' TO WS-CHECK-PN-ENTRY.
           MOVE LOW-VALUES TO MAP2O.
           PERFORM 3100-MAP-TITLE-INQUIRY.
           PERFORM 3200-MAP-PROT-TITLE.
           MOVE 'INQ' TO WS-UPD-SW.
           EXEC CICS
               SEND MAP('MAP2') MAPSET('GSMAP2') ERASE
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS04')
               COMMAREA(WS-SAVEAREA)
               LENGTH(WS-SAVE-LENGTH)
           END-EXEC.

       100-EXIT.


       200-NOT-FOUND.
      * INVOICE RECORD INFORMATION IS NOT FOUND
      *=================================================================

           *> RECORD MATCHING THE INVOICE NUMBER WAS NOUT
           *>=============================================
           MOVE INVNUMI TO KEEP-INV.
           MOVE LOW-VALUES TO MAP2O.
           PERFORM 3100-MAP-TITLE-INQUIRY.
           PERFORM 3200-MAP-PROT-TITLE.
           EXEC CICS
               SEND MAP('MAP2') MAPSET('GSMAP2')
           END-EXEC.
           MOVE '*          RECORD NOT FOUND            *' TO MSGO.
           MOVE DFHPROTI TO MSGA.
           EXEC CICS
              SEND MAP('MAP2') MAPSET('GSMAP2')ERASE
           END-EXEC.
           MOVE -1 TO INVNUML.
           MOVE KEEP-INV TO INVNUMI.
           PERFORM 3000-MAP-SEND-INQ.

       200-EXIT.


       300-FNC1-MENU.
      * FUNCTION 1 COMMANDS - MAIN MENU
      *=================================================================

           *> SEND CONTROL BACK TO THE MAIN MENU
           *>=============================================
           EXEC CICS XCTL
               PROGRAM('gsprgm')
               COMMAREA(WS-TRANSFER-FIELD)
               LENGTH(WS-TRANSFER-LENGTH)
           END-EXEC.

       300-EXIT.


       400-FNC4-EXIT.
      * FUNCTION 4 COMMANDS - EXIT SYSTEM
      *=================================================================

           *> EXIT THE APPLICATION FROM THE CURRENT SCREEN
           *>=============================================
           MOVE LOW-VALUES TO MAP2O.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       400-EXIT.


       500-FNC7-CLEAR.
      * CLEAR THE SCREEN INFORMATION
      *=================================================================

           *> CLEAR THE INFORMATION ON THE SCREEN
           *>=============================================
           MOVE 'XXX' TO WS-CHECK-PN-ENTRY.
           MOVE LOW-VALUES TO MAP2O.
           MOVE 'INQ' TO WS-UPD-SW.
           PERFORM 3100-MAP-TITLE-INQUIRY.
           PERFORM 3200-MAP-PROT-TITLE.
           EXEC CICS
              SEND MAP('MAP2') MAPSET('GSMAP2')ERASE
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS04')
               COMMAREA(WS-SAVEAREA)
               LENGTH(WS-SAVE-LENGTH)
           END-EXEC.

       500-EXIT.


       600-DUPLICATE.
      * DUPLICATE RECORDS PARAGRAPH
      *=================================================================

           *> THE RECORD FOR SAVING ALREADY EXISTS IN THE DB
           *>=============================================
           MOVE LOW-VALUES             TO MAP2O.
           MOVE DFHPROTI TO MSGA.
           MOVE "*    DUPLICATE RECORD WAS FOUND    *" TO MSGO.
           MOVE -1                     TO INVNUML.
           PERFORM 3300-MAP-UNPROTECT.
           PERFORM 3000-MAP-SEND-INQ.

       600-EXIT.


      *=================================================================
      * INQUIRY PARAGRAPHS
      *=================================================================


       1000-INQUIRY-LOGIC.
      * MAIN PROGRAM LOGIC PARAGRAPH
      *=================================================================

           *> CHECK TO SEE IF THE USER IS EXITING THE SCREEN
           *>===============================================

           *> EXIT THE SCREEN
           IF INVNUMI IS EQUAL TO 'XXXXXXX'
               OR INVNUMI (1:5) IS EQUAL TO 'ABORT'
               PERFORM 300-FNC1-MENU
           ELSE
           *> CHECK TO SEE IF THE USERS IS CLEARING THE SCREEN
           *>===============================================
           IF INVNUMI (1:5) IS EQUAL TO 'CLEAR'
               PERFORM 500-FNC7-CLEAR
           ELSE

           *> CHECK INVOICE NUMBER
           *>===============================================

           *> CHECK TO SEE IF THE INVOICE NUMBER IS LESS THAN 7 LONG
           IF INVNUML IS LESS THAN 7
               MOVE LOW-VALUES TO MAP2O
               MOVE "*  INVOICE NUMBER MUST BE 7 LONG   *" TO MSGO
               MOVE DFHUNIMD TO INVNUMA
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO INVNUML
               PERFORM 3100-MAP-TITLE-INQUIRY
               PERFORM 3000-MAP-SEND-INQ
           END-IF.

           *> CHECK TO SEE IF THERE ARE SPACES IN THE INVOICE NUMBER
           IF INVNUMI(1:1) EQUAL SPACES OR
               INVNUMI(2:1) EQUAL SPACES OR
               INVNUMI(3:1) EQUAL SPACES OR
               INVNUMI(4:1) EQUAL SPACES OR
               INVNUMI(5:1) EQUAL SPACES OR
               INVNUMI(6:1) EQUAL SPACES OR
               INVNUMI(7:1) EQUAL SPACES
                   MOVE INVNUMI TO KEEP-INV
                   MOVE LOW-VALUES TO MAP2O
                   MOVE "*  INVOICE NUMBER MUST BE 7 LONG   *" TO MSGO
                   MOVE DFHUNIMD TO INVNUMA
                   MOVE DFHPROTI TO MSGA
                   MOVE -1 TO INVNUML
                   MOVE KEEP-INV TO INVNUMI
                   PERFORM 3100-MAP-TITLE-INQUIRY
                   PERFORM 3000-MAP-SEND-INQ
           END-IF.

           *> CHECK TO SEE IF THE VALUES ARE NUMERIC
           IF INVNUMI IS NOT NUMERIC
               MOVE LOW-VALUES TO MAP2O
               MOVE "*  INVOICE NUMBER MUST BE NUMERIC  *" TO MSGO
               MOVE DFHUNIMD TO INVNUMA
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO INVNUML
               PERFORM 3100-MAP-TITLE-INQUIRY
               PERFORM 3000-MAP-SEND-INQ
           END-IF.

           *> MOVE INVNUM TO ORDFILE TO RETRIEVE INVOICE INFORMATION
           MOVE INVNUMI TO ORDFILE-INVOICE-NO.

           *> READ INFORMATION FROM ORDFILE
           EXEC CICS READ FILE('ORDFILE')
               INTO(ORDFILE-RECORD)
               LENGTH(ORDFILE-LENGTH)
               RIDFLD(ORDFILE-KEY)
           END-EXEC.

           *> MOVE THE FOCUS TO THE FIRST PRODUCT ON THE UPDATE SCREEN
           MOVE -1 TO PRO1AL
           *> TRIM THE TRAILING SPACES FROM ORDFILE DATA
           PERFORM 4025-TRIM-ORDFILE-DATA.
           *> MOVE THE DATA TO THE SAVEAREA
           PERFORM 4300-MOVE-ORD-SAVEAREA.
           *> UNRPOTECT THE MAP TO ALLOW CHANGES OF INVOICE DATA
           PERFORM 3300-MAP-UNPROTECT.
           *> CHANGE THE TITLE ON THE SCREEN
           PERFORM 3150-MAP-TITLE-UPDATE.
           *> CHANGE THE SCREEN MESSAGE FOR RECORD FOUND
           MOVE SPACES TO MSGO.
           *> MOVE THE INFORMATION FROM ORDFILE TO THE MAP
           PERFORM 4000-MOVE-ORD-TO-INPUT.
           *> SEND THE MAP WITH THE NEW VALUES
           PERFORM 3050-MAP-SEND-UPD.

       1000-EXIT.


      *=================================================================
      * UPDATE PARAGRAPHS
      *=================================================================


       2000-INVOICE-CHANGE.
      * DETERMINE IF THE INVOICE INFORMATION HAS BEEN CHANGED
      *=================================================================

           *> DETERMINE IF ANY OF THE VALUES HAVE BEEN CHANGED
           *>=============================================

           *> PERFORM UPDATE LOGIC IF FIELDS HAVE BEEN CHANGES
           IF SAVE-PRO1AI NOT EQUALS PRO1AI
               OR SAVE-PRO1BI NOT EQUALS PRO1BI
               OR SAVE-PRO2AI NOT EQUALS PRO2AI
               OR SAVE-PRO2BI NOT EQUALS PRO2BI
               OR SAVE-PRO3AI NOT EQUALS PRO3AI
               OR SAVE-PRO3BI NOT EQUALS PRO3BI
               OR SAVE-PRO4AI NOT EQUALS PRO4AI
               OR SAVE-PRO4BI NOT EQUALS PRO4BI
               OR SAVE-PRO5AI NOT EQUALS PRO5AI
               OR SAVE-PRO5BI NOT EQUALS PRO5BI
               OR SAVE-NAMEI NOT EQUALS NAMEI
               OR SAVE-ADD1I NOT EQUALS ADD1I
               OR SAVE-ADD2I NOT EQUALS ADD2I
      *         OR SAVE-ADD3I NOT EQUALS ADD3I
               OR SAVE-POS1I NOT EQUALS POS1I
               OR SAVE-POS2I NOT EQUALS POS2I
               OR SAVE-PHN1I NOT EQUALS PHN1I
               OR SAVE-PHN2I NOT EQUALS PHN2I
               OR SAVE-PHN3I NOT EQUALS PHN3I
               PERFORM 2050-UPDATE-LOGIC
           ELSE
               *> CLEAR THE MAP AND RETURN TO INQUIRY WHEN NO
               *> CHNAGES HAVE BEEN MADE
               MOVE LOW-VALUES TO MAP2O
               EXEC CICS
                   SEND MAP('MAP2') MAPSET('GSMAP2')ERASE
               END-EXEC
               MOVE DFHPROTI TO MSGA
               MOVE '*           NO CHANGES MADE            *' TO MSGO
               PERFORM 3000-MAP-SEND-INQ
           END-IF.


       2000-EXIT.


       2050-UPDATE-LOGIC.
      * LOGIC FOR UPDATING INVOICE DATA
      *=================================================================

        *> CHECK TO SEE IF THE USER IS EXITING THE SCREEN
           *>===============================================

           IF INVNUMI IS EQUAL TO 'XXXXXXX'
               OR INVNUMI (1:5) IS EQUAL TO 'ABORT'
                   EXEC CICS XCTL
                       PROGRAM('gsprgm')
                       COMMAREA(WS-TRANSFER-FIELD)
                       LENGTH(WS-TRANSFER-LENGTH)
                   END-EXEC
           ELSE

           *> CHECK TO SEE IF THE USER WANTS TO CLEAR
           *>===============================================
           IF INVNUMI (1:5) IS EQUAL TO 'CLEAR'
               PERFORM 500-FNC7-CLEAR
           ELSE

           *> CHECK INVOICE NUMBER
           *>===============================================

           *> CHECK TO SEE IF THE INVOICE NUMBER IS LESS THAN 7 LONG
           IF INVNUML IS LESS THAN 7
               MOVE "*  INVOICE NUMBER MUST BE 7 LONG   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO INVNUML
               MOVE DFHUNIMD TO INVNUMA
               PERFORM 3050-MAP-SEND-UPD
           ELSE

            *> CHECK TO SEE IF THERE ARE SPACES IN THE INVOICE NUMBER
           IF INVNUMI(1:1) EQUAL SPACES OR
               INVNUMI(2:1) EQUAL SPACES OR
               INVNUMI(3:1) EQUAL SPACES OR
               INVNUMI(4:1) EQUAL SPACES OR
               INVNUMI(5:1) EQUAL SPACES OR
               INVNUMI(6:1) EQUAL SPACES OR
               INVNUMI(7:1) EQUAL SPACES
                   MOVE LOW-VALUES TO MAP2O
               MOVE "*  INVOICE NUMBER MUST BE 7 LONG   *" TO MSGO
                   MOVE DFHUNIMD TO INVNUMA
                   MOVE DFHPROTI TO MSGA
                   MOVE -1 TO INVNUML
                   PERFORM 3050-MAP-SEND-UPD
           END-IF.

           *> CHECK TO SEE IF THE VALUES ARE NUMERIC
           IF INVNUMI IS NOT NUMERIC
               MOVE "*  INVOICE NUMBER MUST BE NUMERIC  *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO INVNUML
               MOVE DFHUNIMD TO INVNUMA
               PERFORM 3050-MAP-SEND-UPD
           END-IF.

           *> CHECK PRODUCT NUMBERS
           *>=============================================


           *> CHECK TO SEE IF THE PRODUCT NUMBER 1 IS VALID
           *> =============================================
           IF PRO1AL EQUAL ZERO
               AND PRO1BL EQUAL ZERO
                   MOVE SPACES TO MSGO
           ELSE
           IF PRO1AI IS NOT ALPHABETIC
               MOVE "* P1-A SECTION MUST BE ALPHABETIC  *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO1AL
               MOVE DFHUNIMD TO PRO1AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO1AI(1:1) EQUAL SPACES OR
               PRO1AI(2:1) EQUAL SPACES OR
               PRO1AI(3:1) EQUAL SPACES OR
               PRO1AI(4:1) EQUAL SPACES
               MOVE "*P1-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO1AL
               MOVE DFHUNIMD TO PRO1AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO1BL IS LESS THAN 4
               MOVE "*P1-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO1BL
               MOVE DFHUNIMD TO PRO1BA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO1BI IS NOT NUMERIC
                MOVE "*  P1-B SECTION MUST BE NUMERIC   *" TO MSGO
                PERFORM 3300-MAP-UNPROTECT
                MOVE DFHPROTI TO MSGA
                MOVE -1 TO PRO1BL
                MOVE DFHUNIMD TO PRO1BA
                PERFORM 3050-MAP-SEND-UPD
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO1AL NOT EQUAL ZERO
               AND PRO1BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO1AI TO PRODUCT-A
                   MOVE PRO1BI TO PRODUCT-B

                   PERFORM 2200-UPDATE-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO1AL
                       MOVE DFHUNIMD TO PRO1AA
                       MOVE DFHUNIMD TO PRO1BA
                       PERFORM 3050-MAP-SEND-UPD
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO1AL
                       MOVE DFHUNIMD TO PRO1AA
                       MOVE DFHUNIMD TO PRO1BA
                       PERFORM 3050-MAP-SEND-UPD
                   END-IF
               MOVE "YES" TO WS-CHECK-PN-ENTRY
           END-IF.


           *> CHECK TO SEE IF THE PRODUCT NUMBER 2 IS VALID
           *> =============================================
            IF PRO2AL EQUAL ZERO
               AND PRO2BL EQUAL ZERO
                   MOVE SPACES TO MSGO
           ELSE
           IF PRO2AI IS NOT ALPHABETIC
               MOVE "* P2-A SECTION MUST BE ALPHABETIC  *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO2AL
               MOVE DFHUNIMD TO PRO2AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO2AI(1:1) EQUAL SPACES OR
               PRO2AI(2:1) EQUAL SPACES OR
               PRO2AI(3:1) EQUAL SPACES OR
               PRO2AI(4:1) EQUAL SPACES
               MOVE "*P2-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO2AL
               MOVE DFHUNIMD TO PRO2AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO2BL IS LESS THAN 4
               MOVE "*P2-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO2BL
               MOVE DFHUNIMD TO PRO2BA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO2BI IS NOT NUMERIC
               MOVE "*  P2-B SECTION MUST BE NUMERIC   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO2BL
               MOVE DFHUNIMD TO PRO2BA
               PERFORM 3050-MAP-SEND-UPD
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO2AL NOT EQUAL ZERO
               AND PRO2BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO2AI TO PRODUCT-A
                   MOVE PRO2BI TO PRODUCT-B

                   PERFORM 2200-UPDATE-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO2AL
                       MOVE DFHUNIMD TO PRO2AA
                       MOVE DFHUNIMD TO PRO2BA
                       PERFORM 3050-MAP-SEND-UPD
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO2AL
                       MOVE DFHUNIMD TO PRO2AA
                       MOVE DFHUNIMD TO PRO2BA
                       PERFORM 3050-MAP-SEND-UPD
                   END-IF
               MOVE "YES" TO WS-CHECK-PN-ENTRY
           END-IF.


           *> CHECK TO SEE IF THE PRODUCT NUMBER 3 IS VALID
           *> =============================================
            IF PRO3AL EQUAL ZERO
               AND PRO3BL EQUAL ZERO
                   MOVE SPACES TO MSGO
           ELSE
           IF PRO3AI IS NOT ALPHABETIC
               MOVE "* P3-A SECTION MUST BE ALPHABETIC  *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO3AL
               MOVE DFHUNIMD TO PRO3AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO3AI(1:1) EQUAL SPACES OR
               PRO3AI(2:1) EQUAL SPACES OR
               PRO3AI(3:1) EQUAL SPACES OR
               PRO3AI(4:1) EQUAL SPACES
               MOVE "*P3-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO3AL
               MOVE DFHUNIMD TO PRO3AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO3BL IS LESS THAN 4
               MOVE "*P3-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO3BL
               MOVE DFHUNIMD TO PRO3BA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO3BI IS NOT NUMERIC
               MOVE "*  P3-B SECTION MUST BE NUMERIC   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO3BL
               MOVE DFHUNIMD TO PRO3BA
               PERFORM 3050-MAP-SEND-UPD
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO3AL NOT EQUAL ZERO
               AND PRO3BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO3AI TO PRODUCT-A
                   MOVE PRO3BI TO PRODUCT-B

                   PERFORM 2200-UPDATE-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO3AL
                       MOVE DFHUNIMD TO PRO3AA
                       MOVE DFHUNIMD TO PRO3BA
                       PERFORM 3050-MAP-SEND-UPD
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO3AL
                       MOVE DFHUNIMD TO PRO3AA
                       MOVE DFHUNIMD TO PRO3BA
                       PERFORM 3050-MAP-SEND-UPD
                   END-IF
               MOVE "YES" TO WS-CHECK-PN-ENTRY
           END-IF.


           *> CHECK TO SEE IF THE PRODUCT NUMBER 4 IS VALID
           *> =============================================
           IF PRO4AL EQUAL ZERO
               AND PRO4BL EQUAL ZERO
                   MOVE SPACES TO MSGO
           ELSE
           IF PRO4AI IS NOT ALPHABETIC
               MOVE "* P4-A SECTION MUST BE ALPHABETIC  *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO4AL
               MOVE DFHUNIMD TO PRO4AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO4AI(1:1) EQUAL SPACES OR
               PRO4AI(2:1) EQUAL SPACES OR
               PRO4AI(3:1) EQUAL SPACES OR
               PRO4AI(4:1) EQUAL SPACES
               MOVE "*P4-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO4AL
               MOVE DFHUNIMD TO PRO4AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO4BL IS LESS THAN 4
               MOVE "*P4-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO4BL
               MOVE DFHUNIMD TO PRO4BA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO4BI IS NOT NUMERIC
               MOVE "*  P4-B SECTION MUST BE NUMERIC   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO4BL
               MOVE DFHUNIMD TO PRO4BA
               PERFORM 3050-MAP-SEND-UPD
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO4AL NOT EQUAL ZERO
               AND PRO4BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO4AI TO PRODUCT-A
                   MOVE PRO4BI TO PRODUCT-B

                   PERFORM 2200-UPDATE-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO4AL
                       MOVE DFHUNIMD TO PRO4AA
                       MOVE DFHUNIMD TO PRO4BA
                       PERFORM 3050-MAP-SEND-UPD
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO4AL
                       MOVE DFHUNIMD TO PRO4AA
                       MOVE DFHUNIMD TO PRO4BA
                       PERFORM 3050-MAP-SEND-UPD
                   END-IF
               MOVE "YES" TO WS-CHECK-PN-ENTRY
           END-IF.


           *> CHECK TO SEE IF THE PRODUCT NUMBER 5 IS VALID
           *> =============================================
           IF WS-CHECK-PN-ENTRY EQUAL "YES"
               MOVE SPACES TO MSGO
           ELSE
           IF PRO5AL EQUAL ZERO
               AND PRO5BL EQUAL ZERO
                   MOVE "* P5-A MUST HAVE A PRODUCT NUMBER  *" TO MSGO
                   PERFORM 3300-MAP-UNPROTECT
                   MOVE DFHPROTI TO MSGA
                   MOVE -1 TO PRO5AL
                   MOVE DFHUNIMD TO PRO5AA
                   PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO5AI IS NOT ALPHABETIC
               MOVE "* P5-A SECTION MUST BE ALPHABETIC  *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO5AL
               MOVE DFHUNIMD TO PRO5AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO5AI(1:1) EQUAL SPACES OR
               PRO5AI(2:1) EQUAL SPACES OR
               PRO5AI(3:1) EQUAL SPACES OR
               PRO5AI(4:1) EQUAL SPACES
               MOVE "*P5-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO5AL
               MOVE DFHUNIMD TO PRO5AA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO5BL IS LESS THAN 4
               MOVE "*P5-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO5BL
               MOVE DFHUNIMD TO PRO5BA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PRO5BI IS NOT NUMERIC
               MOVE "*  P5-B SECTION MUST BE NUMERIC   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO5BL
               MOVE DFHUNIMD TO PRO5BA
               PERFORM 3050-MAP-SEND-UPD
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO5AL NOT EQUAL ZERO
               AND PRO5BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO5AI TO PRODUCT-A
                   MOVE PRO5BI TO PRODUCT-B

                   PERFORM 2200-UPDATE-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO5AL
                       MOVE DFHUNIMD TO PRO5AA
                       MOVE DFHUNIMD TO PRO5BA
                       PERFORM 3050-MAP-SEND-UPD
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO5AL
                       MOVE DFHUNIMD TO PRO5AA
                       MOVE DFHUNIMD TO PRO5BA
                       PERFORM 3050-MAP-SEND-UPD
                   END-IF
               MOVE "YES" TO WS-CHECK-PN-ENTRY
           END-IF.


           *> CHECK CONTACT NAME
           *>=============================================

           *> CONFIRM THE USER HAS ENTERED A NAME AND NAME LENGTH
           IF NAMEL EQUAL ZERO
               MOVE "*   PLEASE ENTER A CUSTOMER NAME   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO NAMEL
               MOVE DFHUNIMD TO NAMEA
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF NAMEL IS LESS THAN 4
               MOVE "*NAME MUST BE MIN 4 CHARACTERS LONG*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO NAMEL
               MOVE DFHUNIMD TO NAMEA
               MOVE LOW-VALUES TO NAMEI
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF NAMEI IS NOT ALPHABETIC
               MOVE "*   NAMES CANNOT CONTAIN NUMBERS   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO NAMEL
               MOVE DFHUNIMD TO NAMEA
               MOVE LOW-VALUES TO NAMEI
               PERFORM 3050-MAP-SEND-UPD
           END-IF.

           *> CHECK ADDRESS LINE INFORMATION
           *>=============================================

           *> CHECK THE FIRST ADDRESS LINE
           IF ADD1L IS LESS THAN 3
               MOVE "* ADDRESS IS MIN 3 CHARACTERS LONG *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO ADD1L
               MOVE DFHUNIMD TO ADD1A
               MOVE LOW-VALUES TO ADD1I
               PERFORM 3050-MAP-SEND-UPD
           END-IF.

            *> CHECK THE SECOND ADDRESS LINE
           IF ADD2L IS LESS THAN 3
               MOVE "* ADDRESS IS MIN 3 CHARACTERS LONG *"  TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO ADD2L
               MOVE DFHUNIMD TO ADD2A
               MOVE LOW-VALUES TO ADD2I
               PERFORM 3050-MAP-SEND-UPD
           END-IF.

           *> CHECK THE THIRD ADDRESS LINE
           IF ADD3L IS GREATER THAN ZERO
               IF ADD3L IS LESS THAN 3
                   MOVE "* ADDRESS IS MIN 3 CHARACTERS LONG *"
                       TO MSGO
                       PERFORM 3300-MAP-UNPROTECT
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO ADD3L
                       MOVE DFHUNIMD TO ADD3A
                       MOVE LOW-VALUES TO ADD3I
                       PERFORM 3050-MAP-SEND-UPD
               END-IF
           END-IF.

           *> CHECK POSTAL CODE ENTRY AND FORMAT
           *>=============================================

           *> CHECK THE FIRST PART OF THE POSTAL CODE
           IF POS1L IS LESS THAN 3
               MOVE "* PLEASE ENTER THE FULL POSTAL CODE*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS1L
               MOVE DFHUNIMD TO POS1A
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF POS1I(1:1) IS NUMERIC
               MOVE "*  PC VALUE ONE MUST BE A LETTER   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS1L
               MOVE DFHUNIMD TO POS1A
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF POS1I(2:1) IS NOT NUMERIC
               MOVE "*  PC VALUE TWO MUST BE A NUMBER   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS1L
               MOVE DFHUNIMD TO POS1A
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF POS1I(3:1) IS NUMERIC
               MOVE "* PC VALUE THREE MUST BE A LETTER  *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS1L
               MOVE DFHUNIMD TO POS1A
               PERFORM 3050-MAP-SEND-UPD
           END-IF.

           *> CHECK THE SECOND PART OF THE POSTAL CODE
           IF POS2L IS LESS THAN 3
               MOVE "* PLEASE ENTER THE FULL POSTAL CODE*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS2L
               MOVE DFHUNIMD TO POS2A
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF POS2I(1:1) IS NOT NUMERIC
               MOVE "*  PC VALUE FOUR MUST BE A NUMBER  *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS2L
               MOVE DFHUNIMD TO POS2A
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF POS2I(2:1) IS NUMERIC
               MOVE "*  PC VALUE FIVE MUST BE A LETTER  *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS2L
               MOVE DFHUNIMD TO POS2A
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF POS2I(3:1) IS NOT NUMERIC
               MOVE "*  PC VALUE SIX MUST BE A NUMBER   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS2L
               MOVE DFHUNIMD TO POS2A
               PERFORM 3050-MAP-SEND-UPD
           END-IF.

           *> CHECK THE PHONE NUMBER
           *>=============================================

           *> CHECK THE AREA CODE OF THE PHONE NUMBER
           IF PHN1L IS LESS THAN 3
               MOVE "* PLEASE ENTER THE PHONE AREA CODE *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN1L
               MOVE DFHUNIMD TO PHN1A
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PHN1I IS EQUAL TO 905
               MOVE "AREA CODE IS VALID" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
           ELSE
           IF PHN1I IS EQUAL TO 416
               MOVE "AREA CODE IS VALID" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
           ELSE
           IF PHN1I IS EQUAL TO 705
               MOVE "AREA CODE IS VALID" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
           ELSE
               MOVE "*ACCEPTED AREA CODES ARE 905/416/705" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN1L
               MOVE DFHUNIMD TO PHN1A
               PERFORM 3050-MAP-SEND-UPD
           END-IF.

           *> CHECK THE PHONE EXCHANGE
           IF PHN2L IS LESS THAN 3
               MOVE "PLEASE ENTER THE FULL PHONE EXCHANGE" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN2L
               MOVE DFHUNIMD TO PHN2A
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PHN2I IS NOT NUMERIC
               MOVE "* PHONE EXCHANGES SHOULD BE NUMERIC*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN2L
               MOVE DFHUNIMD TO PHN2A
               PERFORM 3050-MAP-SEND-UPD
           END-IF.

           *> CHECK THE PHONE NUMBER
           IF PHN3L IS LESS THAN 4
               MOVE "*PLEASE ENTER THE FULL PHONE NUMBER*" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN3L
               MOVE DFHUNIMD TO PHN3A
               PERFORM 3050-MAP-SEND-UPD
           ELSE
           IF PHN3I IS NOT NUMERIC
               MOVE "*  PHONE NUMBERS MUST BE NUMERIC   *" TO MSGO
               PERFORM 3300-MAP-UNPROTECT
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN3L
               MOVE DFHUNIMD TO PHN3A
               PERFORM 3050-MAP-SEND-UPD
           END-IF.

           *> READ ORDFILE FOR CURRENT INVOICE
           PERFORM 2300-UPDATE-READ-ORDFILE.
           *> LOAD THE VALUES INTO THE MAP
           PERFORM 4100-MOVE-INPUT-TO-ORD.
           *> WRTIE THE VALIDATED INFORMATION TO ORDFILE
           PERFORM 4200-WRITE-INPUT-TO-ORD.
           *> CLEAR THE INFORMATION ON THE MAP
           PERFORM 2100-UPDATE-COMPLETE.

       2050-EXIT.


       2100-UPDATE-COMPLETE.
      * CLEAR THE INFORMATION OF THE MAP
      *=================================================================

           *> CLEAR THE MAP AND SEND THE UPDATE MESSAGE TO THE SCREEN
           *>=============================================
           MOVE LOW-VALUES TO MAP2O.
               MOVE "*        INVOICE UPDATED          *" TO MSGO.
           MOVE DFHPROTI TO MSGA.
           PERFORM 3100-MAP-TITLE-INQUIRY.
           EXEC CICS
              SEND MAP('MAP2') MAPSET('GSMAP2')ERASE
           END-EXEC.
           PERFORM 3000-MAP-SEND-INQ.

       2100-EXIT.


       2200-UPDATE-CHECK-PARTS.
      * CHECK PART NUMBER TO SEE IF THEY ARE VALID
      *=================================================================

           *> CHECK THE PART NUMBER TO SEE IF IT IS A VALID NUMBER
           *>=============================================
           MOVE PRODUCT-NUMBER TO WS-TRANSFER-PRODUCT.
           EXEC CICS LINK
               PROGRAM('GSPRGPC')
               COMMAREA(TRANSFER-VARIABLES)
               LENGTH(WS-TRANSFER-PN)
           END-EXEC.

       2200-EXIT.


       2300-UPDATE-READ-ORDFILE.
      * READ THE ORDFILE FOR THE CURRENT INVOICE NUMBER
      *=================================================================

           *> READ THE INFORMATION FROM THE ORDFILE FOR
           *> THE CURRENT INVOICE NUMBER
           *>=============================================
           MOVE INVNUMI TO ORDFILE-INVOICE-NO.
           EXEC CICS READ FILE('ORDFILE')
               RIDFLD(ORDFILE-KEY)
               LENGTH(ORDFILE-LENGTH)
               INTO(ORDFILE-RECORD)
               UPDATE
           END-EXEC.

       2300-EXIT.


      *=================================================================
      * MAP PARAGRAPHS
      *=================================================================


       3000-MAP-SEND-INQ.
      * SENDING THE MAP PARAGRAPH
      *=================================================================

           *> SENDS THE MAP AND CHANGES THE PROCESSING MODE TO INQUIRY
           *>=============================================
           MOVE 'INQ' TO WS-UPD-SW.
           PERFORM 3100-MAP-TITLE-INQUIRY.
           PERFORM 3200-MAP-PROT-TITLE.
           EXEC CICS SEND MAP('MAP2') MAPSET('GSMAP2') END-EXEC.
           EXEC CICS RETURN TRANSID('GS04')
               COMMAREA(WS-SAVEAREA)
               LENGTH(WS-SAVE-LENGTH)
           END-EXEC.

       3000-EXIT.


       3050-MAP-SEND-UPD.
      * SENDING THE MAP PARAGRAPH
      *=================================================================

           *> SEND THE MAP AND CHAGES THE PROCESSING MODE TO UPDATE
           *>=============================================
           MOVE 'UPD' TO WS-UPD-SW.
           PERFORM 3150-MAP-TITLE-UPDATE.
           PERFORM 3200-MAP-PROT-TITLE.
           EXEC CICS
               SEND MAP('MAP2') MAPSET('GSMAP2')CURSOR
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS04')
               COMMAREA(WS-SAVEAREA)
               LENGTH(WS-SAVE-LENGTH)
           END-EXEC.

       3050-EXIT.


       3100-MAP-TITLE-INQUIRY.
      * LOAD THE ENTRY SCREEN TITLE
      *=================================================================

           MOVE ' I N Q U I R Y   S C R E E N  ' TO SCREENO.
           MOVE DFHBMASK TO SCREENA.

       3100-EXIT.


       3150-MAP-TITLE-UPDATE.
      * LOAD THE ENTRY SCREEN TITLE
      *=================================================================

           MOVE ' U P D A T E    S C R E E N  ' TO SCREENO.
           MOVE DFHBMASK TO SCREENA.
           MOVE DFHBMPRF TO INVNUMA.

       3150-EXIT.


       3200-MAP-PROT-TITLE.
      * PROTECT THE SCREEN TITLE FIELD
      *=================================================================

           MOVE DFHBMASK TO SCREENA.

       3200-EXIT.


       3300-MAP-UNPROTECT.
      * UNPROTECT THE FEILDS IN THE MAP PARAGRAPH
      *=================================================================

           MOVE DFHBMFSE TO INVNUMA.
           MOVE DFHBMFSE TO PRO1AA.
           MOVE DFHBMFSE TO PRO1BA.
           MOVE DFHBMFSE TO PRO2AA.
           MOVE DFHBMFSE TO PRO2BA.
           MOVE DFHBMFSE TO PRO3AA.
           MOVE DFHBMFSE TO PRO3BA.
           MOVE DFHBMFSE TO PRO4AA.
           MOVE DFHBMFSE TO PRO4BA.
           MOVE DFHBMFSE TO PRO5AA.
           MOVE DFHBMFSE TO PRO5BA.
           MOVE DFHBMFSE TO NAMEA.
           MOVE DFHBMFSE TO ADD1A.
           MOVE DFHBMFSE TO ADD2A.
           MOVE DFHBMFSE TO ADD3A.
           MOVE DFHBMFSE TO POS1A.
           MOVE DFHBMFSE TO POS2A.
           MOVE DFHBMFSE TO PHN1A.
           MOVE DFHBMFSE TO PHN2A.
           MOVE DFHBMFSE TO PHN3A.

       3300-EXIT.


      *=================================================================
      * DATA MOVE PARAGRAPHS
      *=================================================================


       4000-MOVE-ORD-TO-INPUT.
      * MOVE THE INVOICE INFORMATION TO OUTPUT
      *=================================================================

           MOVE ORDFILE-INVOICE-NO TO INVNUMI.
           MOVE ORDFILE-P1A TO PRO1AI.
           MOVE ORDFILE-P1B TO PRO1BI.
           MOVE ORDFILE-P2A TO PRO2AI.
           MOVE ORDFILE-P2B TO PRO2BI.
           MOVE ORDFILE-P3A TO PRO3AI.
           MOVE ORDFILE-P3B TO PRO3BI.
           MOVE ORDFILE-P4A TO PRO4AI.
           MOVE ORDFILE-P4B TO PRO4BI.
           MOVE ORDFILE-P5A TO PRO5AI.
           MOVE ORDFILE-P5B TO PRO5BI.
           MOVE ORDFILE-NAME TO NAMEI.
           MOVE ORDFILE-ADDR-LINE1 TO ADD1I.
           MOVE ORDFILE-ADDR-LINE2 TO ADD2I.
           MOVE ORDFILE-ADDR-LINE3 TO ADD3I.
           MOVE ORDFILE-POSTAL-1 TO POS1I.
           MOVE ORDFILE-POSTAL-2 TO POS2I.
           MOVE ORDFILE-AREA-CODE TO PHN1I.
           MOVE ORDFILE-EXCHANGE TO PHN2I.
           MOVE ORDFILE-PHONE-NUM TO PHN3I.

       4000-EXIT.


       4025-TRIM-ORDFILE-DATA.
      * PROCESS ALL DATA FROM THE ORDFILE USING THE TRIM FUNCTION
      *=================================================================

           *> SEND THE VALUES TO THE TRIM FUNCTION
           *>=============================================
           MOVE ORDFILE-ADDR-LINE1 TO WS-TRIM-DATA.
           PERFORM 4050-TRIM-ORDFILE-FUNCTION.
           MOVE WS-TRIM-DATA TO ORDFILE-ADDR-LINE1.

           MOVE ORDFILE-ADDR-LINE2 TO WS-TRIM-DATA.
           PERFORM 4050-TRIM-ORDFILE-FUNCTION.
           MOVE WS-TRIM-DATA TO ORDFILE-ADDR-LINE2.

           MOVE ORDFILE-ADDR-LINE3 TO WS-TRIM-DATA.
           PERFORM 4050-TRIM-ORDFILE-FUNCTION.
           MOVE WS-TRIM-DATA TO ORDFILE-ADDR-LINE3.

           MOVE ORDFILE-NAME TO WS-TRIM-DATA.
           PERFORM 4050-TRIM-ORDFILE-FUNCTION.
           MOVE WS-TRIM-DATA TO ORDFILE-NAME.

       4025-EXIT.


       4050-TRIM-ORDFILE-FUNCTION.
      * TRIM TRAILING SPACES FROM THE ORDFILE DATA
      *=================================================================

           *> TRIM FUNCTION REMOVES EXTRA TRAILING CHARACTERS FROM
           *> THE DATA FROM THE ORDFILE
           *>=============================================
           INSPECT FUNCTION REVERSE(WS-TRIM-DATA)
               TALLYING WS-TRIM-SPACES FOR LEADING SPACES.
           COMPUTE WS-TRIM-LEN =
               LENGTH OF WS-TRIM-DATA - WS-TRIM-SPACES.
           IF WS-TRIM-LEN = 0
               MOVE LOW-VALUES TO WS-TRIM-DATA
           ELSE
               MOVE WS-TRIM-DATA(1:WS-TRIM-LEN) TO WS-TRIM-DATA
           END-IF.

       4050-EXIT.


       4100-MOVE-INPUT-TO-ORD.
      * LOAD THE FIELDS FOR THE ENTRY SCREEN TITLE
      *=================================================================

           MOVE INVNUMI TO ORDFILE-INVOICE-NO.
           MOVE PRO1AI TO ORDFILE-P1A.
           MOVE PRO1BI TO ORDFILE-P1B.
           MOVE PRO2AI TO ORDFILE-P2A.
           MOVE PRO2BI TO ORDFILE-P2B.
           MOVE PRO3AI TO ORDFILE-P3A.
           MOVE PRO3BI TO ORDFILE-P3B.
           MOVE PRO4AI TO ORDFILE-P4A.
           MOVE PRO4BI TO ORDFILE-P4B.
           MOVE PRO5AI TO ORDFILE-P5A.
           MOVE PRO5BI TO ORDFILE-P5B.
           MOVE NAMEI TO ORDFILE-NAME.
           MOVE ADD1I TO ORDFILE-ADDR-LINE1.
           MOVE ADD2I TO ORDFILE-ADDR-LINE2.
           MOVE ADD3I TO ORDFILE-ADDR-LINE3.
           MOVE POS1I TO ORDFILE-POSTAL-1.
           MOVE POS2I TO ORDFILE-POSTAL-2.
           MOVE PHN1I TO ORDFILE-AREA-CODE.
           MOVE PHN2I TO ORDFILE-EXCHANGE.
           MOVE PHN3I TO ORDFILE-PHONE-NUM.

       4100-EXIT.


       4200-WRITE-INPUT-TO-ORD.
      * WRTIE THE NEW INFORMATION TO THE DATABASE
      *=================================================================

           *> REWRITE THE INFORMATION FOR THE UPDATED RECORD
           *>=============================================
           EXEC CICS REWRITE FILE('ORDFILE')
               LENGTH(ORDFILE-LENGTH)
               FROM(ORDFILE-RECORD)
           END-EXEC.

       4200-EXIT.


       4300-MOVE-ORD-SAVEAREA.
      *MOVE THE INFORMATION FROM INQUIRY FIELDS TO THE SAVEAREA
      *=================================================================

           MOVE ORDFILE-INVOICE-NO TO SAVE-INV.
           MOVE ORDFILE-P1A TO SAVE-PRO1AI.
           MOVE ORDFILE-P1B TO SAVE-PRO1BI.
           MOVE ORDFILE-P2A TO SAVE-PRO2AI.
           MOVE ORDFILE-P2B TO SAVE-PRO2BI.
           MOVE ORDFILE-P3A TO SAVE-PRO3AI.
           MOVE ORDFILE-P3B TO SAVE-PRO3BI.
           MOVE ORDFILE-P4A TO SAVE-PRO4AI.
           MOVE ORDFILE-P4B TO SAVE-PRO4BI.
           MOVE ORDFILE-P5A TO SAVE-PRO5AI.
           MOVE ORDFILE-P5B TO SAVE-PRO5BI.
           MOVE ORDFILE-NAME TO SAVE-NAMEI.
           MOVE ORDFILE-ADDR-LINE1 TO SAVE-ADD1I.
           MOVE ORDFILE-ADDR-LINE2 TO SAVE-ADD2I.
           MOVE ORDFILE-ADDR-LINE3 TO SAVE-ADD3I.
           MOVE ORDFILE-POSTAL-1 TO SAVE-POS1I.
           MOVE ORDFILE-POSTAL-2 TO SAVE-POS2I.
           MOVE ORDFILE-AREA-CODE TO SAVE-PHN1I.
           MOVE ORDFILE-EXCHANGE TO SAVE-PHN2I.
           MOVE ORDFILE-PHONE-NUM TO SAVE-PHN3I.

       4300-EXIT.


      *=================================================================
      * EXIT PARAGRAPHS
      *=================================================================


       9999-EXIT-APPLICATION.
      * EXIT PROGRAM PARAGRAPH
      *=================================================================

            MOVE LOW-VALUES TO MAP2O.
            MOVE 'GOODBYE' TO MSGO.

            GOBACK.

       9999-EXIT.


       END PROGRAM GSPRGU.
