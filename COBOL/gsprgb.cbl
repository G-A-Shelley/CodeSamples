       IDENTIFICATION DIVISION.
      *=================================================================
       PROGRAM-ID. gsprgb.
       AUTHOR. GAVIN SHELLEY.


       ENVIRONMENT DIVISION.
      *=================================================================
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.


       DATA DIVISION.
      *=================================================================
       WORKING-STORAGE SECTION.
           COPY 'GSMAP3'.
           COPY 'DFHBMSCA'.

       01 TRANSFER-VARIABLES.
           05 WS-TRANSFER-FIELD            PIC X(3).
           05 WS-TRANSFER-LENGTH           PIC S9(4) COMP VALUE 3.

       01  WS-ARRAY-COUNTER.
           05  LINE-SUB                    PIC 99.

       01  ORDFILE-LENGTH                  PIC S9(4) COMP VALUE 150.

       01  ORDFILE-RECORD.
           05  ORDFILE-KEY.
               10  ORDFILE-PREFIX          PIC XXX     VALUE 'GAS'.
               10  ORDFILE-INVOICE-NO      PIC X(7).
           05  ORDFILE-NAME                PIC X(20).
           05  ORDFILE-PRODUCTS.
               10  ORDFILE-PRODUCT1.
                   15  ORDFILE-P1A         PIC X(4).
                   15  ORDFILE-P1B         PIC X(4).
               10  ORDFILE-PRODUCT2.
                   15 ORDFILE-P2A          PIC X(4).
                   15 ORDFILE-P2B          PIC X(4).
               10  ORDFILE-PRODUCT3.
                   15 ORDFILE-P3A          PIC X(4).
                   15 ORDFILE-P3B          PIC X(4).
               10  ORDFILE-PRODUCT4.
                   15 ORDFILE-P4A          PIC X(4).
                   15 ORDFILE-P4B          PIC X(4).
               10  ORDFILE-PRODUCT5.
                   15 ORDFILE-P5A          PIC X(4).
                   15 ORDFILE-P5B          PIC X(4).
           05  ORDFILE-ADDR-LINE1          PIC X(20).
           05  ORDFILE-ADDR-LINE2          PIC X(20).
           05  ORDFILE-ADDR-LINE3          PIC X(20).
           05  ORDFILE-POSTAL.
               10  ORDFILE-POSTAL-1        PIC XXX.
               10  ORDFILE-POSTAL-2        PIC XXX.
           05  ORDFILE-PHONE.
               10  ORDFILE-AREA-CODE       PIC XXX.
               10  ORDFILE-EXCHANGE        PIC XXX.
               10  ORDFILE-PHONE-NUM       PIC XXXX.
           05  FILLER                      PIC X(4)    VALUE SPACES.

       01 RECORD-LINE.
           05  FILLER                      PIC X(11)   VALUE SPACES.
           05  RL-LINE                     PIC 99.
           05  FILLER                      PIC X(02)   VALUE SPACES.
           05  RL-NUM                      PIC X(7).
           05  FILLER                      PIC X(11)   VALUE SPACES.
           05  RL-NAME                     PIC X(26).
           05  FILLER                      PIC X(01)   VALUE '('.
           05  RL-AREA                     PIC XXX.
           05  FILLER                      PIC XX      VALUE ') '.
           05  RL-EXCH                     PIC XXX.
           05  FILLER                      PIC X       VALUE '-'.
           05  RL-PHONE                    PIC XXXX.
           05  FILLER                      PIC X(06)   VALUE SPACES.

       01  TRANS-FILE-TRACKING.
           05  EOF-FLAG                    PIC X(03)   VALUE "NO".
               88  END-OF-TRANS                        VALUE "YES".


       LINKAGE SECTION.
      *=================================================================
       01 DFCOMMAREA.
           05 LK-TRANSFER                  PIC X(3).


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
               AID PF1 (1000-FUNCTION1-MAIN)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF2 (1400-FUNCTION2-FORWARD)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF3 (1500-FUNCTION3-BACKWARD)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF4 (1100-FUNCTION4-EXIT)
           END-EXEC.
           EXEC CICS HANDLE
               AID PF7 (1200-FUNCTION7-CLEAR)
           END-EXEC.
           EXEC CICS HANDLE CONDITION
               ENDFILE(1600-END-OF-FILE)
           END-EXEC.

           *> REVIEVE MAP AND MAPSET
           EXEC CICS RECEIVE MAP('MAP3') MAPSET('GSMAP3') END-EXEC.

           *> PERFORM MAIN LOGIC
           PERFORM 200-MAIN-LOGIC.


       100-FIRST-TIME.
      * FIRST TIME RUN / MAP FAIL PARAGRAPH
      *=================================================================

           *> CLEAR THE MAP AND SEND TO THE SCREEN
           *>=============================================
           MOVE LOW-VALUES TO MAP3O.

           MOVE '* ENTER A CUSTOMERS NAME TO BROWSE *' TO MSGO
           EXEC CICS
               SEND MAP('MAP3') MAPSET('GSMAP3') ERASE
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS05') END-EXEC.

       100-EXIT.


       200-MAIN-LOGIC.
      * MAIN PROGRAM LOGIC PARAGRAPH
      *=================================================================

           IF CNAMEI EQUALS SPACES

               MOVE '*   PLEASE ENTER A CUSTOMER NAME   *' TO MSGO
               PERFORM 1300-SEND-MAP
           ELSE
           IF CNAMEL IS LESS THAN 3

               MOVE '*    SEARCH REQUIRES 3 LETTERS     *' TO MSGO
               PERFORM 1300-SEND-MAP
           END-IF.

           MOVE CNAMEI TO ORDFILE-NAME.

           EXEC CICS STARTBR
               FILE('ORDNAME')
               RIDFLD(ORDFILE-NAME)
           END-EXEC.

           MOVE LOW-VALUES TO MAP3O.

           PERFORM 2000-BROWSE-FORWARD
               VARYING LINE-SUB FROM 1 BY 1
                     UNTIL LINE-SUB > 10.

           EXEC CICS ENDBR FILE('ORDNAME') END-EXEC.

           MOVE '*          SEARCH RESULTS          *' TO MSGO.

           PERFORM 1300-SEND-MAP.

       200-EXIT.


       1000-FUNCTION1-MAIN.
      * FUNCTION KEY 1 PARAGRAPH
      *=================================================================

           EXEC CICS XCTL
               PROGRAM('gsprgm')
               COMMAREA(WS-TRANSFER-FIELD)
               LENGTH(WS-TRANSFER-LENGTH)
           END-EXEC.

       1000-EXIT.


       1100-FUNCTION4-EXIT.
      * FUNCTION KEY 4 PARAGRAPH
      *=================================================================

           MOVE LOW-VALUES TO MAP3O.
           EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
           EXEC CICS RETURN END-EXEC.

   `   1100-EXIT.


       1200-FUNCTION7-CLEAR.
      *=================================================================

           MOVE LOW-VALUES TO MAP3O.
           EXEC CICS
              SEND MAP('MAP3') MAPSET('GSMAP3')ERASE
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS05') END-EXEC.

       1200-EXIT.


       1300-SEND-MAP.
      *=================================================================

           MOVE -1 TO CNAMEL.
           EXEC CICS
               SEND MAP('MAP3') MAPSET('GSMAP3')CURSOR
           END-EXEC.
           EXEC CICS RETURN TRANSID('GS05') END-EXEC.

       1300-EXIT.


       1400-FUNCTION2-FORWARD.
      *=================================================================

           MOVE LINEI(10) TO RECORD-LINE.
           MOVE RL-NAME TO  ORDFILE-NAME.

           EXEC CICS STARTBR
               FILE('ORDNAME')
               RIDFLD(ORDFILE-NAME)
           END-EXEC.

           MOVE LOW-VALUES TO MAP3O.

           PERFORM 2000-BROWSE-FORWARD
               VARYING LINE-SUB FROM 1 BY 1
                     UNTIL LINE-SUB > 10.

           EXEC CICS ENDBR FILE('ORDNAME') END-EXEC.

           MOVE '*          SEARCH RESULTS          *' TO MSGO.

           PERFORM 1300-SEND-MAP.

       1400-EXIT.


       1500-FUNCTION3-BACKWARD.
      *=================================================================

           MOVE LINEI(10) TO RECORD-LINE.
           MOVE RL-NAME TO  ORDFILE-NAME.

           EXEC CICS STARTBR
               FILE('ORDNAME')
               RIDFLD(ORDFILE-NAME)
           END-EXEC.

           MOVE LOW-VALUES TO MAP3O.

           PERFORM 2100-BROWSE-BACKWARD
               VARYING LINE-SUB FROM 1 BY 1
                     UNTIL LINE-SUB > 10.

           EXEC CICS ENDBR FILE('ORDNAME') END-EXEC.

           MOVE '*          SEARCH RESULTS          *' TO MSGO.

           PERFORM 1300-SEND-MAP.

       1500-EXIT.


       1600-END-OF-FILE.

           MOVE '*      END OF RECORDS REACHED      *' TO MSGO.
           PERFORM 1300-SEND-MAP.

       1600-EXIT.


       2000-BROWSE-FORWARD.
      *=================================================================

           EXEC CICS READNEXT FILE('ORDNAME')
                      INTO(ORDFILE-RECORD)
                      RIDFLD(ORDFILE-NAME)
                      LENGTH(ORDFILE-LENGTH)
           END-EXEC.

           MOVE LINE-SUB TO RL-LINE.
           MOVE ORDFILE-INVOICE-NO TO RL-NUM.
           MOVE ORDFILE-NAME TO RL-NAME.
           MOVE ORDFILE-AREA-CODE TO RL-AREA.
           MOVE ORDFILE-EXCHANGE TO RL-EXCH.
           MOVE ORDFILE-PHONE TO RL-PHONE.

           MOVE RECORD-LINE TO LINEO(LINE-SUB).

       2000-EXIT.


       2100-BROWSE-BACKWARD.
      *=================================================================

           EXEC CICS READPREV FILE('ORDNAME')
               INTO(ORDFILE-RECORD)
               RIDFLD(ORDFILE-NAME)
               LENGTH(ORDFILE-LENGTH)
           END-EXEC.

           MOVE LINE-SUB TO RL-LINE.
           MOVE ORDFILE-INVOICE-NO TO RL-NUM.
           MOVE ORDFILE-NAME TO RL-NAME.
           MOVE ORDFILE-AREA-CODE TO RL-AREA.
           MOVE ORDFILE-EXCHANGE TO RL-EXCH.
           MOVE ORDFILE-PHONE TO RL-PHONE.

           MOVE RECORD-LINE TO LINEO(LINE-SUB).

       2100-EXIT.


       END PROGRAM gsprgb.
