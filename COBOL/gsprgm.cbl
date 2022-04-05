       IDENTIFICATION DIVISION.
      *=================================================================
       PROGRAM-ID. gsprgm.
       AUTHOR. GAVIN SHELLEY.


       ENVIRONMENT DIVISION.
      *=================================================================
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.


       DATA DIVISION.
      *=================================================================
       WORKING-STORAGE SECTION.
           COPY 'GSMAP1'.
           COPY 'DFHBMSCA'.

       01  TRANSFER-VARIABLES.
           05 WS-TRANSFER-FIELD        PIC X(3).
           05 WS-TRANSFER-LENGTH       PIC S9(4) COMP VALUE 3.


       LINKAGE SECTION.
      *=================================================================
       01 DFHCOMMAREA.
           05 LK-TRANSFER              PIC X(3).


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
           EXEC CICS
               HANDLE CONDITION MAPFAIL(100-FIRST-TIME)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF1 (810-FUNCTION-1)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF2 (820-FUNCTION-2)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF3 (830-FUNCTION-3)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF4 (840-FUNCTION-4)
           END-EXEC.

           *> REVIEVE MAP AND MAPSET
           EXEC CICS
               RECEIVE MAP('MAP1') MAPSET('GSMAP1')
           END-EXEC.

           *> PERFORM MAIN LOGIC
           GO TO 200-MAIN-LOGIC.


       100-FIRST-TIME.
      * FIRST TIME RUN / MAP FAIL PARAGRAPH
      *=================================================================

           *> CLEAR THE MAP AND SEND TO THE SCREEN
           *>=============================================
           MOVE LOW-VALUES TO MAP1O.
           EXEC CICS
               SEND MAP('MAP1') MAPSET('GSMAP1') ERASE
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS01') END-EXEC.

       100-EXIT.

       200-MAIN-LOGIC.
      * MAIN PROGRAM LOGIC PARAGRAPH
      *=================================================================

           *> DETERMINE AND HANDLE USER INPUT
           *>=============================================
           IF CHOICEI IS EQUAL TO '1'
               GO TO 300-CHOICE-1
           ELSE
           IF CHOICEI IS EQUAL TO '2'
               GO TO 400-CHOICE-2
           ELSE
           IF CHOICEI IS EQUAL TO '3'
               GO TO 500-CHOICE-3
           ELSE
           IF CHOICEI IS EQUAL TO '4'
               GO TO 600-CHOICE-4
           ELSE
           IF CHOICEI IS EQUAL TO '9'
              GO TO 600-CHOICE-4
           ELSE
           IF CHOICEI IS NUMERIC
               GO TO 700-ENTRY-ERROR
           ELSE
           IF CHOICEI IS NOT NUMERIC
               GO TO 700-ENTRY-ERROR
           ELSE
               GO TO 999-SEND-ERROR-MSG
           END-IF.

       200-EXIT.


       300-CHOICE-1.
      * CHANGE SCREENS TO INVOICE ENTRY SCREEN
      *=================================================================

           EXEC CICS XCTL
               PROGRAM('gsprge')
               COMMAREA(WS-TRANSFER-FIELD)
               LENGTH(WS-TRANSFER-LENGTH)
           END-EXEC.

       300-EXIT.


       400-CHOICE-2.
      * CHANGE SCREENS TO INVOICE INQUIRY SCREEN
      *=================================================================

           EXEC CICS XCTL
               PROGRAM('gsprgu')
               COMMAREA(WS-TRANSFER-FIELD)
               LENGTH(WS-TRANSFER-LENGTH)
           END-EXEC.

       400-EXIT.


       500-CHOICE-3.
      * FUTURE OPTION NOT IMPLEMENTED
      *=================================================================

           EXEC CICS XCTL
               PROGRAM('gsprgb')
               COMMAREA(WS-TRANSFER-FIELD)
               LENGTH(WS-TRANSFER-LENGTH)
           END-EXEC.

       500-EXIT.


       600-CHOICE-4.
      * END AND EXIT THE APPLICATION
      *=================================================================

           MOVE LOW-VALUES TO MAP1O.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

       600-EXIT.


       700-ENTRY-ERROR.
      * DISPLAY USER ENTRY ERROR MESSAGE
      *=================================================================

           MOVE LOW-VALUES TO MAP1O.
           MOVE '* PLEASE SELECT A VALID OPTION 1 TO 4  *' TO MSGO.
           MOVE DFHPROTI TO MSGA.
           EXEC CICS SEND MAP('MAP1') MAPSET('GSMAP1') END-EXEC.
           EXEC CICS RETURN TRANSID('GS01') END-EXEC.

       700-EXIT.


       810-FUNCTION-1.
      * FUNCTION NUMBER 1
      *=================================================================

           PERFORM 300-CHOICE-1.

       810-EXIT.


       820-FUNCTION-2.
      * FUNCTION NUNBER 2
      *=================================================================

           PERFORM 400-CHOICE-2.

       820-EXIT.


       830-FUNCTION-3.
      * FUNCTION NUMBER 3
      *=================================================================

           PERFORM 500-CHOICE-3.

       830-EXIT.


       840-FUNCTION-4.
      * FUNCTION NUMBER 4
      *=================================================================

           PERFORM 600-CHOICE-4.

       840-EXIT.


       999-SEND-ERROR-MSG.
      * DISPLAY APPLICATION ERROR MESSAGE
      *=================================================================

           MOVE LOW-VALUES TO MAP1O.
           MOVE '*  ERROR ENCOUNTERED - PROGRAM ENDING  *' TO MSGO.
           EXEC CICS SEND MAP('MAP1') MAPSET('GSMAP1') END-EXEC.
           EXEC CICS RETURN END-EXEC.

       999-EXIT.


       1000-EXIT-APPLICATION.
      * EXIT PROGRAM PARAGRAPH
      *=================================================================

            MOVE LOW-VALUES TO MAP1O.
            MOVE 'GOODBYE' TO MSGO.

           GOBACK.

       1000-EXIT.


       END PROGRAM gsprgm.
