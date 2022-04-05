       IDENTIFICATION DIVISION.
      *=================================================================
       PROGRAM-ID. gsprge.
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

       01  TRANSFER-VARIABLES.
           05  WS-TRANSFER-PRODUCT         PIC X(8).
           05  WS-TRANSFER-DESC            PIC X(17).

       01  CHECK-VARIABLES.
           05  WS-CHECK-PN-ENTRY           PIC X(03).
.
       01  ORDFILE-LENGTH                  PIC S9(4) COMP  VALUE 150.

        01  ORDFILE-RECORD.
            05  ORDFILE-KEY.
                10  ORDFILE-PREFIX         PIC XXX VALUE 'GAS'.
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

       01 PRODUCT-NUMBER.
           05  PRODUCT-A                   PIC X(4).
           05  PRODUCT-B                   PIC X(4).


       LINKAGE SECTION.
      *=================================================================
       01 DFCOMMAREA.
           05 EK-TRANSFER                  PIC X(3).


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
           EXEC CICS HANDLE
               AID PF1 (1210-FUNCTION1)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF4 (1200-FUNCTION4)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF7 (990-CLEAR-SCREEN)
           END-EXEC.
           EXEC CICS HANDLE CONDITION
               DUPREC(1100-DUPLICATE)
           END-EXEC.

           *> REVIEVE MAP AND MAPSET
           EXEC CICS RECEIVE MAP('MAP2') MAPSET('GSMAP2') END-EXEC.

           *> PERFORM MAIN LOGIC
           GO TO 200-MAIN-LOGIC.


       100-FIRST-TIME.
      * FIRST TIME RUN / MAP FAIL PARAGRAPH
      *=================================================================

           *> CLEAR THE MAP AND SEND TO THE SCREEN
           *>=============================================
           MOVE 'XXX' TO WS-CHECK-PN-ENTRY.
           MOVE LOW-VALUES TO MAP2O.
           PERFORM 920-UNPROTECT-MAP.
           PERFORM 930-LOAD-TITLE.
           PERFORM 940-LOAD-FIELDS.
           EXEC CICS
               SEND MAP('MAP2') MAPSET('GSMAP2') ERASE
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS03') END-EXEC.

       100-EXIT.


       200-MAIN-LOGIC.
      * MAIN PROGRAM LOGIC PARAGRAPH
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
               PERFORM 990-CLEAR-SCREEN
           ELSE

           *> CHECK INVOICE NUMBER
           *>===============================================

           *> CHECK TO SEE IF THE INVOICE NUMBER IS LESS THAN 7 LONG
           IF INVNUML IS LESS THAN 7
               MOVE "*  INVOICE NUMBER MUST BE 7 LONG   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO INVNUML
               MOVE DFHUNIMD TO INVNUMA
               PERFORM 900-SEND-MAP
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
                   PERFORM 900-SEND-MAP
           END-IF.

           *> CHECK TO SEE IF THE VALUES ARE NUMERIC
           IF INVNUMI IS NOT NUMERIC
               MOVE "*  INVOICE NUMBER MUST BE NUMERIC  *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO INVNUML
               MOVE DFHUNIMD TO INVNUMA
               PERFORM 900-SEND-MAP
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
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO1AL
               MOVE DFHUNIMD TO PRO1AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO1AI(1:1) EQUAL SPACES OR
               PRO1AI(2:1) EQUAL SPACES OR
               PRO1AI(3:1) EQUAL SPACES OR
               PRO1AI(4:1) EQUAL SPACES
               MOVE "*P1-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO1AL
               MOVE DFHUNIMD TO PRO1AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO1BL IS LESS THAN 4
               MOVE "*P1-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO1BL
               MOVE DFHUNIMD TO PRO1BA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO1BI IS NOT NUMERIC
                MOVE "*  P1-B SECTION MUST BE NUMERIC   *" TO MSGO
                PERFORM 920-UNPROTECT-MAP
                MOVE DFHPROTI TO MSGA
                MOVE -1 TO PRO1BL
                MOVE DFHUNIMD TO PRO1BA
                PERFORM 900-SEND-MAP
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO1AL NOT EQUAL ZERO
               AND PRO1BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO1AI TO PRODUCT-A
                   MOVE PRO1BI TO PRODUCT-B

                   PERFORM 1000-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO1AL
                       MOVE DFHUNIMD TO PRO1AA
                       MOVE DFHUNIMD TO PRO1BA
                       PERFORM 900-SEND-MAP
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO1AL
                       MOVE DFHUNIMD TO PRO1AA
                       MOVE DFHUNIMD TO PRO1BA
                       PERFORM 900-SEND-MAP
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
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO2AL
               MOVE DFHUNIMD TO PRO2AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO2AI(1:1) EQUAL SPACES OR
               PRO2AI(2:1) EQUAL SPACES OR
               PRO2AI(3:1) EQUAL SPACES OR
               PRO2AI(4:1) EQUAL SPACES
               MOVE "*P2-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO2AL
               MOVE DFHUNIMD TO PRO2AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO2BL IS LESS THAN 4
               MOVE "*P2-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO2BL
               MOVE DFHUNIMD TO PRO2BA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO2BI IS NOT NUMERIC
               MOVE "*  P2-B SECTION MUST BE NUMERIC   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO2BL
               MOVE DFHUNIMD TO PRO2BA
               PERFORM 900-SEND-MAP
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO2AL NOT EQUAL ZERO
               AND PRO2BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO2AI TO PRODUCT-A
                   MOVE PRO2BI TO PRODUCT-B

                   PERFORM 1000-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO2AL
                       MOVE DFHUNIMD TO PRO2AA
                       MOVE DFHUNIMD TO PRO2BA
                       PERFORM 900-SEND-MAP
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO2AL
                       MOVE DFHUNIMD TO PRO2AA
                       MOVE DFHUNIMD TO PRO2BA
                       PERFORM 900-SEND-MAP
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
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO3AL
               MOVE DFHUNIMD TO PRO3AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO3AI(1:1) EQUAL SPACES OR
               PRO3AI(2:1) EQUAL SPACES OR
               PRO3AI(3:1) EQUAL SPACES OR
               PRO3AI(4:1) EQUAL SPACES
               MOVE "*P3-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO3AL
               MOVE DFHUNIMD TO PRO3AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO3BL IS LESS THAN 4
               MOVE "*P3-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO3BL
               MOVE DFHUNIMD TO PRO3BA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO3BI IS NOT NUMERIC
               MOVE "*  P3-B SECTION MUST BE NUMERIC   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO3BL
               MOVE DFHUNIMD TO PRO3BA
               PERFORM 900-SEND-MAP
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO3AL NOT EQUAL ZERO
               AND PRO3BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO3AI TO PRODUCT-A
                   MOVE PRO3BI TO PRODUCT-B

                   PERFORM 1000-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO3AL
                       MOVE DFHUNIMD TO PRO3AA
                       MOVE DFHUNIMD TO PRO3BA
                       PERFORM 900-SEND-MAP
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO3AL
                       MOVE DFHUNIMD TO PRO3AA
                       MOVE DFHUNIMD TO PRO3BA
                       PERFORM 900-SEND-MAP
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
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO4AL
               MOVE DFHUNIMD TO PRO4AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO4AI(1:1) EQUAL SPACES OR
               PRO4AI(2:1) EQUAL SPACES OR
               PRO4AI(3:1) EQUAL SPACES OR
               PRO4AI(4:1) EQUAL SPACES
               MOVE "*P4-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO4AL
               MOVE DFHUNIMD TO PRO4AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO4BL IS LESS THAN 4
               MOVE "*P4-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO4BL
               MOVE DFHUNIMD TO PRO4BA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO4BI IS NOT NUMERIC
               MOVE "*  P4-B SECTION MUST BE NUMERIC   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO4BL
               MOVE DFHUNIMD TO PRO4BA
               PERFORM 900-SEND-MAP
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO4AL NOT EQUAL ZERO
               AND PRO4BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO4AI TO PRODUCT-A
                   MOVE PRO4BI TO PRODUCT-B

                   PERFORM 1000-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO4AL
                       MOVE DFHUNIMD TO PRO4AA
                       MOVE DFHUNIMD TO PRO4BA
                       PERFORM 900-SEND-MAP
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO4AL
                       MOVE DFHUNIMD TO PRO4AA
                       MOVE DFHUNIMD TO PRO4BA
                       PERFORM 900-SEND-MAP
                   END-IF
               MOVE "YES" TO WS-CHECK-PN-ENTRY
           END-IF.


           *> CHECK TO SEE IF THE PRODUCT NUMBER 5 IS VALID
           *> =============================================
           IF WS-CHECK-PN-ENTRY EQUAL "YES"
               AND PRO5AL EQUAL ZERO
               AND PRO5BL EQUAL ZERO
                   MOVE SPACES TO MSGO
           ELSE
           IF PRO5AL EQUAL ZERO
               AND PRO5BL EQUAL ZERO
               MOVE "* P5-A MUST HAVE A PRODUCT NUMBER  *" TO MSGO
                   PERFORM 920-UNPROTECT-MAP
                   MOVE DFHPROTI TO MSGA
                   MOVE -1 TO PRO5AL
                   MOVE DFHUNIMD TO PRO5AA
                   PERFORM 900-SEND-MAP
           ELSE
           IF PRO5AI IS NOT ALPHABETIC
               MOVE "* P5-A SECTION MUST BE ALPHABETIC  *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO5AL
               MOVE DFHUNIMD TO PRO5AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO5AI(1:1) EQUAL SPACES OR
               PRO5AI(2:1) EQUAL SPACES OR
               PRO5AI(3:1) EQUAL SPACES OR
               PRO5AI(4:1) EQUAL SPACES
               MOVE "*P5-A SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO5AL
               MOVE DFHUNIMD TO PRO5AA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO5BL IS LESS THAN 4
               MOVE "*P5-B SECTION CANNOT CONTAIN SPACES*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO5BL
               MOVE DFHUNIMD TO PRO5BA
               PERFORM 900-SEND-MAP
           ELSE
           IF PRO5BI IS NOT NUMERIC
               MOVE "*  P5-B SECTION MUST BE NUMERIC   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PRO5BL
               MOVE DFHUNIMD TO PRO5BA
               PERFORM 900-SEND-MAP
           END-IF.
           *> CHECK PRODUCT CODE DATABASE
           IF PRO5AL NOT EQUAL ZERO
               AND PRO5BL NOT EQUAL ZERO
                   *> MOVE PRODUCT NUMBERS TO WS-PRODUCT BEFORE
                   MOVE PRO5AI TO PRODUCT-A
                   MOVE PRO5BI TO PRODUCT-B

                   PERFORM 1000-CHECK-PARTS

                   *> CHECK THE DESCRIPTION TO SEE WHAT WAS RETURNED
                   IF WS-TRANSFER-DESC IS NUMERIC
                       MOVE "*         DATABASE ERROR          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO5AL
                       MOVE DFHUNIMD TO PRO5AA
                       MOVE DFHUNIMD TO PRO5BA
                       PERFORM 900-SEND-MAP
                   ELSE
                   IF WS-TRANSFER-DESC EQUAL 'PART NOT FOUND'
                       MOVE "*         PART NOT FOUND          *"
                           TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO PRO5AL
                       MOVE DFHUNIMD TO PRO5AA
                       MOVE DFHUNIMD TO PRO5BA
                       PERFORM 900-SEND-MAP
                   END-IF
               MOVE "YES" TO WS-CHECK-PN-ENTRY
           END-IF.


           *> CHECK CONTACT NAME
           *>=============================================

           *> CONFIRM THE USER HAS ENTERED A NAME AND NAME LENGTH
           IF NAMEL EQUAL ZERO
               MOVE "*   PLEASE ENTER A CUSTOMER NAME   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO NAMEL
               MOVE DFHUNIMD TO NAMEA
               PERFORM 900-SEND-MAP
           ELSE
           IF NAMEL IS LESS THAN 4
               MOVE "*NAME MUST BE MIN 4 CHARACTERS LONG*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO NAMEL
               MOVE DFHUNIMD TO NAMEA
               MOVE LOW-VALUES TO NAMEI
               PERFORM 900-SEND-MAP
           ELSE
           IF NAMEI IS NOT ALPHABETIC
               MOVE "*   NAMES CANNOT CONTAIN NUMBERS   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO NAMEL
               MOVE DFHUNIMD TO NAMEA
               MOVE LOW-VALUES TO NAMEI
               PERFORM 900-SEND-MAP
           END-IF.

           *> CHECK ADDRESS LINE INFORMATION
           *>=============================================

           *> CHECK THE FIRST ADDRESS LINE
           IF ADD1L IS LESS THAN 3
               MOVE "* ADDRESS IS MIN 3 CHARACTERS LONG *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO ADD1L
               MOVE DFHUNIMD TO ADD1A
               MOVE LOW-VALUES TO ADD1I
               PERFORM 900-SEND-MAP
           END-IF.

            *> CHECK THE SECOND ADDRESS LINE
           IF ADD2L IS LESS THAN 3
               MOVE "* ADDRESS IS MIN 3 CHARACTERS LONG *"  TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO ADD2L
               MOVE DFHUNIMD TO ADD2A
               MOVE LOW-VALUES TO ADD2I
               PERFORM 900-SEND-MAP
           END-IF.

           *> CHECK THE THIRD ADDRESS LINE
           IF ADD3L IS GREATER THAN ZERO
               IF ADD3L IS LESS THAN 3
                   MOVE "* ADDRESS IS MIN 3 CHARACTERS LONG *"
                       TO MSGO
                       PERFORM 920-UNPROTECT-MAP
                       MOVE DFHPROTI TO MSGA
                       MOVE -1 TO ADD3L
                       MOVE DFHUNIMD TO ADD3A
                       MOVE LOW-VALUES TO ADD3I
                       PERFORM 900-SEND-MAP
               END-IF
           END-IF.

           *> CHECK POSTAL CODE ENTRY AND FORMAT
           *>=============================================

           *> CHECK THE FIRST PART OF THE POSTAL CODE
           IF POS1L IS LESS THAN 3
               MOVE "* PLEASE ENTER THE FULL POSTAL CODE*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS1L
               MOVE DFHUNIMD TO POS1A
               PERFORM 900-SEND-MAP
           ELSE
           IF POS1I(1:1) IS NUMERIC
               MOVE "*  PC VALUE ONE MUST BE A LETTER   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS1L
               MOVE DFHUNIMD TO POS1A
               PERFORM 900-SEND-MAP
           ELSE
           IF POS1I(2:1) IS NOT NUMERIC
               MOVE "*  PC VALUE TWO MUST BE A NUMBER   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS1L
               MOVE DFHUNIMD TO POS1A
               PERFORM 900-SEND-MAP
           ELSE
           IF POS1I(3:1) IS NUMERIC
               MOVE "* PC VALUE THREE MUST BE A LETTER  *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS1L
               MOVE DFHUNIMD TO POS1A
               PERFORM 900-SEND-MAP
           END-IF.

           *> CHECK THE SECOND PART OF THE POSTAL CODE
           IF POS2L IS LESS THAN 3
               MOVE "* PLEASE ENTER THE FULL POSTAL CODE*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS2L
               MOVE DFHUNIMD TO POS2A
               PERFORM 900-SEND-MAP
           ELSE
           IF POS2I(1:1) IS NOT NUMERIC
               MOVE "*  PC VALUE FOUR MUST BE A NUMBER  *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS2L
               MOVE DFHUNIMD TO POS2A
               PERFORM 900-SEND-MAP
           ELSE
           IF POS2I(2:1) IS NUMERIC
               MOVE "*  PC VALUE FIVE MUST BE A LETTER  *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS2L
               MOVE DFHUNIMD TO POS2A
               PERFORM 900-SEND-MAP
           ELSE
           IF POS2I(3:1) IS NOT NUMERIC
               MOVE "*  PC VALUE SIX MUST BE A NUMBER   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO POS2L
               MOVE DFHUNIMD TO POS2A
               PERFORM 900-SEND-MAP
           END-IF.

           *> CHECK THE PHONE NUMBER
           *>=============================================

           *> CHECK THE AREA CODE OF THE PHONE NUMBER
           IF PHN1L IS LESS THAN 3
               MOVE "* PLEASE ENTER THE PHONE AREA CODE *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN1L
               MOVE DFHUNIMD TO PHN1A
               PERFORM 900-SEND-MAP
           ELSE
           IF PHN1I IS EQUAL TO 905
               MOVE "AREA CODE IS VALID" TO MSGO
               PERFORM 920-UNPROTECT-MAP
           ELSE
           IF PHN1I IS EQUAL TO 416
               MOVE "AREA CODE IS VALID" TO MSGO
               PERFORM 920-UNPROTECT-MAP
           ELSE
           IF PHN1I IS EQUAL TO 705
               MOVE "AREA CODE IS VALID" TO MSGO
               PERFORM 920-UNPROTECT-MAP
           ELSE
               MOVE "*ACCEPTED AREA CODES ARE 905/416/705" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN1L
               MOVE DFHUNIMD TO PHN1A
               PERFORM 900-SEND-MAP
           END-IF.

           *> CHECK THE PHONE EXCHANGE
           IF PHN2L IS LESS THAN 3
               MOVE "PLEASE ENTER THE FULL PHONE EXCHANGE" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN2L
               MOVE DFHUNIMD TO PHN2A
               PERFORM 900-SEND-MAP
           ELSE
           IF PHN2I IS NOT NUMERIC
               MOVE "* PHONE EXCHANGES SHOULD BE NUMERIC*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN2L
               MOVE DFHUNIMD TO PHN2A
               PERFORM 900-SEND-MAP
           END-IF.

           *> CHECK THE PHONE NUMBER
           IF PHN3L IS LESS THAN 4
               MOVE "*PLEASE ENTER THE FULL PHONE NUMBER*" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN3L
               MOVE DFHUNIMD TO PHN3A
               PERFORM 900-SEND-MAP
           ELSE
           IF PHN3I IS NOT NUMERIC
               MOVE "*  PHONE NUMBERS MUST BE NUMERIC   *" TO MSGO
               PERFORM 920-UNPROTECT-MAP
               MOVE DFHPROTI TO MSGA
               MOVE -1 TO PHN3L
               MOVE DFHUNIMD TO PHN3A
               PERFORM 900-SEND-MAP
           END-IF.

           *> LOAD THE VALUES INTO THE MAP
           PERFORM 940-LOAD-FIELDS.

           *> WRTIE THE VALIDATED INFORMATION TO ORDFILE
           PERFORM 1300-WRTIE-RECORDS.

           *> CLEAR THE INFORMATION ON THE MAP
           PERFORM 950-CLEAR-MAP.

       200-EXIT.


       900-SEND-MAP.
      * SENDING THE MAP PARAGRAPH
      *=================================================================

           PERFORM 930-LOAD-TITLE.
           EXEC CICS
              SEND MAP('MAP2') MAPSET('GSMAP2')CURSOR
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS03') END-EXEC.

       900-EXIT.


       920-UNPROTECT-MAP.
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

       920-EXIT.


       930-LOAD-TITLE.
      * LOAD THE ENTRY SCREEN TITLE
      *=================================================================

           MOVE '  E N T R Y    S C R E E N    ' TO SCREENO.
           MOVE DFHBMASK TO SCREENA.

       930-EXIT.


       940-LOAD-FIELDS.
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

       940-EXIT.


       950-CLEAR-MAP.
      * CLEAR THE INFORMATION OF THE MAP
      *=================================================================

           MOVE 'XXX' TO WS-CHECK-PN-ENTRY.
           PERFORM 920-UNPROTECT-MAP.
           MOVE LOW-VALUES TO MAP2O.
               MOVE "*       NEW INVOICE CREATED        *" TO MSGO.
           MOVE DFHPROTI TO MSGA.
           PERFORM 930-LOAD-TITLE.
           EXEC CICS
              SEND MAP('MAP2') MAPSET('GSMAP2')ERASE
           END-EXEC.
           MOVE -1 TO INVNUML.
           PERFORM 920-UNPROTECT-MAP.
           PERFORM 900-SEND-MAP.

       950-EXIT.


       990-CLEAR-SCREEN.
      *=================================================================

           MOVE LOW-VALUES TO MAP2O.
           PERFORM 930-LOAD-TITLE.
           EXEC CICS
              SEND MAP('MAP2') MAPSET('GSMAP2')ERASE
           END-EXEC.
           MOVE -1 TO INVNUML.
           PERFORM 920-UNPROTECT-MAP.
           PERFORM 900-SEND-MAP.

       990-EXIT.


       1000-CHECK-PARTS.
      * CHECK PART NUMBER TO SEE IF THEY ARE VALID
      *=================================================================

      *=================================================================
      * CHECK ALL NUMBERS ONCE ALL VALUES HAVE BEEN VALIDATED
      * INSERT LINK LOGIC TO CONNECT TO GSPRGPC
      * INSERT LOGIC TO PROCESS THE DATA RETURNED FROM GSPRGPC
      *=================================================================

           MOVE PRODUCT-NUMBER TO WS-TRANSFER-PRODUCT.

           EXEC CICS LINK
               PROGRAM('GSPRGPC')
               COMMAREA(TRANSFER-VARIABLES)
               LENGTH(WS-TRANSFER-PN)
           END-EXEC.

       1000-EXIT.


       1100-DUPLICATE.
      * DUPLICATE RECORDS PARAGRAPH
      *=================================================================

           MOVE LOW-VALUES             TO MAP2O.
           MOVE DFHPROTI TO MSGA.
           MOVE "*    DUPLICATE RECORD WAS FOUND    *" TO MSGO.
           MOVE -1                     TO INVNUML.
           PERFORM 920-UNPROTECT-MAP.
           PERFORM 900-SEND-MAP.

       1100-EXIT.


       1200-FUNCTION4.
      * FUNCTION KEY 4 PARAGRAPH
      *=================================================================

           MOVE LOW-VALUES TO MAP2O.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       1200-EXIT.


       1210-FUNCTION1.
      * FUNCTION KEY 1 PARAGRAPH
      *=================================================================

           EXEC CICS XCTL
               PROGRAM('gsprgm')
               COMMAREA(WS-TRANSFER-FIELD)
               LENGTH(WS-TRANSFER-LENGTH)
           END-EXEC.

       1200-EXIT.


       1300-WRTIE-RECORDS.
      * WRTIE THE NEW INFORMATION TO THE DATABASE
      *=================================================================

           EXEC CICS WRITE
               FROM(ORDFILE-RECORD)
               LENGTH(ORDFILE-LENGTH)
               FILE('ORDFILE')
               RIDFLD(ORDFILE-KEY)
           END-EXEC.

       1300-EXIT.


       2000-EXIT-APPLICATION.
      * EXIT PROGRAM PARAGRAPH
      *=================================================================

            MOVE LOW-VALUES            TO MAP2O.
            MOVE 'GOODBYE'             TO MSGO.

           GOBACK.

       2000-EXIT.


       END PROGRAM gsprge.
