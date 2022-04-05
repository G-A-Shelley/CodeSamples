       IDENTIFICATION DIVISION.
      *=================================================================
       PROGRAM-ID. gsprgi.
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

       01 TRANSFER-VARIABLES.
           05 WS-TRANSFER-FIELD              PIC X(3).
           05 WS-TRANSFER-LENGTH             PIC S9(4) COMP VALUE 3.

       01  ORDFILE-LENGTH                  PIC S9(4) COMP  VALUE 150.

        01  ORDFILE-RECORD.
            05  ORDFILE-KEY.
                10  ORDFILE-PREFIX           PIC XXX VALUE 'GAS'.
                10  ORDFILE-INVOICE-NO       PIC X(7).
            05  ORDFILE-NAME                 PIC X(20).
            05  ORDFILE-PRODUCTS.
                10  ORDFILE-PRODUCT1.
                    15  ORDFILE-P1A          PIC X(4).
                    15  ORDFILE-P1B          PIC X(4).
                10  ORDFILE-PRODUCT2.
                    15 ORDFILE-P2A           PIC X(4).
                    15 ORDFILE-P2B           PIC X(4).
                10  ORDFILE-PRODUCT3.
                    15 ORDFILE-P3A           PIC X(4).
                    15 ORDFILE-P3B           PIC X(4).
                10  ORDFILE-PRODUCT4.
                    15 ORDFILE-P4A           PIC X(4).
                    15 ORDFILE-P4B           PIC X(4).
                10  ORDFILE-PRODUCT5.
                    15 ORDFILE-P5A           PIC X(4).
                    15 ORDFILE-P5B           PIC X(4).

            05  ORDFILE-ADDR-LINE1           PIC X(20).
            05  ORDFILE-ADDR-LINE2           PIC X(20).
            05  ORDFILE-ADDR-LINE3           PIC X(20).
            05  ORDFILE-POSTAL.
                10  ORDFILE-POSTAL-1         PIC XXX.
                10  ORDFILE-POSTAL-2         PIC XXX.
            05  ORDFILE-PHONE.
                10  ORDFILE-AREA-CODE        PIC XXX.
                10  ORDFILE-EXCHANGE         PIC XXX.
                10  ORDFILE-PHONE-NUM        PIC XXXX.
            05  FILLER                       PIC X(4) VALUE SPACES.

       01 INVOICE-HOLD.
           05  KEEP-INV                      PIC X(7).

       LINKAGE SECTION.
      *=================================================================
       01 DFCOMMAREA.
           05 EK-TRANSFER                    PIC X(3).


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
               NOTFND(150-NOT-FOUND)
           END-EXEC.
           EXEC CICS
               HANDLE AID PF1 (970-FUNCTION-1)
           END-EXEC.
           EXEC CICS
               HANDLE AID PF4 (980-FUNCTION-4)
           END-EXEC.
           EXEC CICS
               HANDLE AID PF7 (990-CLEAR-SCREEN)
           END-EXEC.

           *> REVIEVE MAP AND MAPSET
           EXEC CICS
               RECEIVE MAP('MAP2') MAPSET('GSMAP2')
           END-EXEC.

           *> PERFORM MAIN LOGIC
           GO TO 200-MAIN-LOGIC.

       000-EXIT.

       100-FIRST-TIME.
      * FIRST TIME RUN / MAP FAIL PARAGRAPH
      *=================================================================

           *> CLEAR THE MAP AND SEND TO THE SCREEN
           *>=============================================
           MOVE LOW-VALUES TO MAP2O.
           PERFORM 930-PROTECT-TITLE.
           EXEC CICS
               SEND MAP('MAP2') MAPSET('GSMAP2') ERASE
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS02') END-EXEC.

       100-EXIT.


       150-NOT-FOUND.
      * INVOICE RECORD INFORMATION IS NOT FOUND
      *=================================================================

           MOVE INVNUMI TO KEEP-INV.
           MOVE LOW-VALUES TO MAP2O.
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
           PERFORM 900-SEND-MAP.

       150-EXIT.


       200-MAIN-LOGIC.
      * MAIN PROGRAM LOGIC PARAGRAPH
      *=================================================================

           *> CHECK TO SEE IF THE USER IS EXITING THE SCREEN
           *>===============================================

           *> EXIT THE SCREEN
           IF INVNUMI IS EQUAL TO 'XXXXXXX'
               OR INVNUMI (1:5) IS EQUAL TO 'ABORT'
               PERFORM 970-FUNCTION-1
           ELSE
           *> CHECK TO SEE IF THE USERS IS CLEARING THE SCREEN
           *>===============================================
           IF INVNUMI (1:5) IS EQUAL TO 'CLEAR'
               PERFORM 990-CLEAR-SCREEN
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
               PERFORM 900-SEND-MAP
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
                   PERFORM 900-SEND-MAP
           END-IF.

           *> CHECK TO SEE IF THE VALUES ARE NUMERIC
           IF INVNUMI IS NOT NUMERIC
               MOVE LOW-VALUES TO MAP2O
               MOVE "*  INVOICE NUMBER MUST BE NUMERIC  *" TO MSGO
               MOVE DFHUNIMD TO INVNUMA
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO INVNUML
               PERFORM 900-SEND-MAP
           END-IF.

           *> MOVE INVNUM TO ORDFILE TO RETRIEVE INVOICE INFORMATION
           MOVE INVNUMI TO ORDFILE-INVOICE-NO.

           *> READ INFORMATION FROM ORDFILE
           EXEC CICS READ FILE('ORDFILE')
               INTO(ORDFILE-RECORD)
               LENGTH(ORDFILE-LENGTH)
               RIDFLD(ORDFILE-KEY)
           END-EXEC.

           *> CHANGE THE SCREEN MESSAGE FOR RECORD FOUND
           MOVE SPACES TO MSGO.
           *> MOVE THE INFORMATION FROM ORDFILE TO THE MAP
           PERFORM 910-MOVE-VALUES.
           *> SEND THE MAP WITH THE NEW VALUES
           PERFORM 900-SEND-MAP.

       200-EXIT.


       900-SEND-MAP.
      * SENDING THE MAP PARAGRAPH
      *=================================================================

           PERFORM 930-PROTECT-TITLE.
           EXEC CICS SEND MAP('MAP2') MAPSET('GSMAP2') END-EXEC.
           EXEC CICS RETURN TRANSID('GS02') END-EXEC.

       900-EXIT.


       910-MOVE-VALUES.
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

       910-EXIT.


       930-PROTECT-TITLE.
      * PROTECT THE SCREEN TITLE FIELD
      *=================================================================

           MOVE DFHBMASK TO SCREENA.

       930-EXIT.


       970-FUNCTION-1.
      * FUNCTION 1 COMMANDS - MAIN MENU
      *=================================================================

           EXEC CICS XCTL
               PROGRAM('gsprgm')
               COMMAREA(WS-TRANSFER-FIELD)
               LENGTH(WS-TRANSFER-LENGTH)
           END-EXEC.

       970-EXIT.

       980-FUNCTION-4.
      * FUNCTION 4 COMMANDS - EXIT SYSTEM
      *=================================================================

           MOVE LOW-VALUES TO MAP2O.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       980-EXIT.


       990-CLEAR-SCREEN.
      * CLEAR THE SCREEN INFORMATION
      *=================================================================

           MOVE LOW-VALUES TO MAP2O.
           PERFORM 930-PROTECT-TITLE.
           EXEC CICS
              SEND MAP('MAP2') MAPSET('GSMAP2')ERASE
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS02') END-EXEC.

       990-EXIT.


       999-EXIT-APPLICATION.
      * EXIT PROGRAM PARAGRAPH
      *=================================================================

            MOVE LOW-VALUES TO MAP2O.
            MOVE 'GOODBYE' TO MSGO.

           GOBACK.

       999-EXIT.


       END PROGRAM gsprgi.
