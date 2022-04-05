       $SET DB2 (DB=INFOSYS,UDB-VERSION=V8)
       IDENTIFICATION DIVISION.
      *=================================================================
       PROGRAM-ID. GSPRGPC.
       AUTHOR. GAVIN SHELLEY.


       ENVIRONMENT DIVISION.
      *=================================================================
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.


       SPECIAL-NAMES.
          call-convention 8 is litlink.

       DATA DIVISION.
      *=================================================================
       WORKING-STORAGE SECTION.
       01  CICS-API-WS-START        PIC X.

                               

       
       01 WS-SQL-CODE PIC -9(8).

       
           EXEC SQL INCLUDE SQLCA END-EXEC.

           
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
           
       
           01  SQL-PRODUCT-CODE                        PIC X(8).
           01  SQL-PRODUCT-DESC                        PIC X(17).

       
           EXEC SQL END DECLARE SECTION END-EXEC.


       COPY 'CICS-API'.
       01  CICS-API-TEMP-STORAGE.
           02  CICS-API-TEMP        PIC S9(4) COMP-5 OCCURS 2.
           02  CICS-API-TEMPPTR     USAGE POINTER OCCURS 8.
           02  CICS-API-TEMP-SHORT  PIC S9(4) COMP-5 OCCURS 4.
           02  CICS-API-TEMP-LONG   PIC S9(8) COMP-5 OCCURS 4.
       01  CICS-API-WS-END          PIC X.

       
              
       LINKAGE SECTION.
       COPY 'CICS-EIB'.

                       
      *=================================================================
       01 DFHCOMMAREA.
           05  LK-PRODUCT                          PIC X(8).
           05  LK-DESC                             PIC X(17).



           
       
       PROCEDURE DIVISION
           USING
           DFHEIBLK
           DFHCOMMAREA

                         .
       CICS-API SECTION.
       CICS-API-TRIGGER.
           SET CICS-EIB-PTR TO ADDRESS OF DFHEIBLK.
           CALL litlink 'CICSAPIWSADDRE' USING CICS-ARGS
                CICS-API-WS-START CICS-API-WS-END.
           IF EIBLABEL NOT = 0
               GO TO CICS-API-ERROR.
           PERFORM CICS-API-EDF-INIT.

                          
      *=================================================================
      *=================================================================


       
       
       000-MAIN-LOGIC.
      * START OF PROGRAM CODE
      *================================================================= 

           EXEC SQL WHENEVER NOT FOUND GO TO 200-ERROR-CODE END-EXEC.
           EXEC SQL WHENEVER SQLERROR  GO TO 400-ERROR-SQL  END-EXEC.
           EXEC SQL WHENEVER SQLWARNING CONTINUE END-EXEC.

           
           PERFORM 200-CHECK-PN THRU 200-EXIT.

      *     EXEC CICS RETURN END-EXEC
           MOVE 0 TO CICS-ARG-MASK
           MOVE 72 TO CICS-FN-CODE
           MOVE 53 TO CICS-DEBUG-LINE
           CALL litlink 'CICSAPIE' USING CICS-ARGS
           IF EIBLABEL NOT = 0
               GO TO CICS-API-ERROR
           END-IF

                                    .

       
       000-EXIT.


       
       
       200-CHECK-PN.
      * CHECK PART NUMBER LOGIC
      *=================================================================

      *     EXEC CICS ASKTIME END-EXEC
           MOVE 0 TO CICS-ARG-MASK
           MOVE 4 TO CICS-FN-CODE
           MOVE 62 TO CICS-DEBUG-LINE
           CALL litlink 'CICSAPIE' USING CICS-ARGS
           IF EIBLABEL NOT = 0
               GO TO CICS-API-ERROR
           END-IF

                                     .

           
           MOVE LK-PRODUCT TO SQL-PRODUCT-CODE.

      *     EXEC CICS ASKTIME END-EXEC
           MOVE 0 TO CICS-ARG-MASK
           MOVE 4 TO CICS-FN-CODE
           MOVE 66 TO CICS-DEBUG-LINE
           CALL litlink 'CICSAPIE' USING CICS-ARGS
           IF EIBLABEL NOT = 0
               GO TO CICS-API-ERROR
           END-IF

                                     .

           EXEC SQL SELECT PART_DESC INTO :SQL-PRODUCT-DESC
               FROM BILLM.PART_CODES
               WHERE PART_CODE = :SQL-PRODUCT-CODE
           END-EXEC.

      *     EXEC CICS ASKTIME END-EXEC
           MOVE 0 TO CICS-ARG-MASK
           MOVE 4 TO CICS-FN-CODE
           MOVE 73 TO CICS-DEBUG-LINE
           CALL litlink 'CICSAPIE' USING CICS-ARGS
           IF EIBLABEL NOT = 0
               GO TO CICS-API-ERROR
           END-IF

                                     .

           
           MOVE SQL-PRODUCT-DESC TO LK-DESC.

      *     EXEC CICS ASKTIME END-EXEC
           MOVE 0 TO CICS-ARG-MASK
           MOVE 4 TO CICS-FN-CODE
           MOVE 77 TO CICS-DEBUG-LINE
           CALL litlink 'CICSAPIE' USING CICS-ARGS
           IF EIBLABEL NOT = 0
               GO TO CICS-API-ERROR
           END-IF

                                     .
  
           
           GO TO 200-EXIT.

       
       200-ERROR-CODE.
      * ERROR CODE LOGIC
      *=================================================================

       
           MOVE 'PART NOT FOUND' TO LK-DESC.
          
       
       200-EXIT.

       
           EXIT.

              
       400-ERROR-SQL.
      * SQL ERROR LOGIC
      *=================================================================

       
           MOVE SQLCODE TO WS-SQL-CODE.
           MOVE WS-SQL-CODE TO LK-DESC.
      *     EXEC CICS RETURN END-EXEC
           MOVE 0 TO CICS-ARG-MASK
           MOVE 72 TO CICS-FN-CODE
           MOVE 97 TO CICS-DEBUG-LINE
           CALL litlink 'CICSAPIE' USING CICS-ARGS
           IF EIBLABEL NOT = 0
               GO TO CICS-API-ERROR
           END-IF

                                    .

       
       400-EXIT.


       
       
           GOBACK.


       CICS-API-EDF-INIT SECTION.
           CALL litlink 'CICSAPIEDFINIT' USING DFHEIBLK BY VALUE 1.
       CICS-API-ERROR SECTION.
           IF EIBLABEL = -1
               GO TO CICS-API-RETURN-OR-ABEND.
           GO TO
               CICS-API-RETURN-OR-ABEND
           DEPENDING ON EIBLABEL.
       CICS-API-RETURN-OR-ABEND.
           GOBACK.

           
       END PROGRAM gsprgpc.
