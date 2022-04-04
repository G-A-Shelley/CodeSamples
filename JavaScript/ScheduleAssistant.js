/**
   * ANOR Labs Software Development
   * Created  :   2016
   * Author   :   Gavin Shelley       
   * Page     :   sch-schedule-create.php 
   *
   * Update Schedule Assistant
   *
   * Iterates through all of the shifts for the
   * day of the week that the current shift is
   * scheduled for and updates the visual bars
   * in the assistant panel
   *
   * @param     string      shiftName           shift name identifier for day of the week
   * @return    none   
   */
    function ProcessScheduleAssistant ( shiftName ) {     

      /*  define function locals */
      var numberOfShifts;   // total number of shift elements in the schedule view
      var currentCover;     // current daily coverage element
      var coverage;         // id of the current daily coverage element
      var currentStyle;     // style of the current daily coverage element
      var checkStart;       // index of the time separator if it exists
      var checkEnd;         // index of the time separator if it exists
      var shiftNo;          // string value of the current shift 
      var startName;        // id of the shift start input element
      var endName;          // id of the shift end input element
      var startShift;       // start shift input element value
      var endShift;         // end shift input element value
      var sHour;            // start shift hour integer value
      var eHour;            // end shift hour integer value

      /*  get information from page elements */
      numberOfShifts        = document.getElementsByClassName("grpStaffTotal").length;

      /*  iterate through all of the current day shifts and clear background styles */
      for (shift = 0; shift < numberOfShifts; shift++) {
        /*  iterate through all of the assistants hours display */
        for (cover = 7; cover < 22; cover++) {
          /*  determine if the current shift needs a leading 0 on the cover value */
          if (cover < 10) { 
            coverage  = shiftName + "0" + cover; 
          } else {
            coverage  = shiftName + cover; 
          }
          /*  clear out the element background style colour */
          document.getElementById(coverage).style.backgroundColor = ''; 
        }
      }

      /*  iterate through all of the current day shifts and update background assistant colours */
      for (shift = 0; shift < numberOfShifts; shift++) {
        /*  determine if the current time needs a leading 0 on the shift number value */
        if (shift < 10) {
          shiftNo = "0" + shift; 
        } else {
          shiftNo = shift; 
        }

        /*  build the name for the current shift start and end inputs*/
        startName           = shiftName + "s" + shiftNo;
        endName             = shiftName + "e" + shiftNo;
        /*  get the shift values for shift start and end inputs*/
        startShift          = document.getElementById(startName).value;
        endShift            = document.getElementById(endName).value;
        /*  get the integer values for the start and end shift hours */
        sHour               = parseInt(startShift.substring(0,2));
        eHour               = parseInt(endShift.substring(0,2));
        /*  get the index values for the : in start and end shift times */
        checkStart          = startShift.indexOf(':'); 
        checkEnd            = endShift.indexOf(':'); 

        /*  determine if the : in shift times is at the correct position */
        if (checkStart == 2 && checkEnd == 2) {
          /*  determine if the start hour is less than 7 and sets min to 7
              assistant starts at 7 am */
          if (sHour < 7) { 
            coverHour = 7; 
          } else {
            coverHour = sHour; 
          }
          /*  determine if the start hour is more than 21 and sets max to 22
              assistant ends at 9 pm */
          if (eHour > 21) { 
            endCover  = 22; 
          } else {
            endCover  = eHour; 
          }   

          /*  iterate through all of the current shift hour values */
          for (cover = coverHour; cover < endCover; cover++) {
            /*  determine if the shift is less than 10 and requires a leading 0 
                set the name for the assistant coverage element */
            if (cover < 10) {
              coverage  = shiftName + "0" + cover; 
            } else {
              coverage  = shiftName + cover; 
            }
            /*  set the element for current shift coverage and its background colour */
            currentCover = document.getElementById(coverage);
            currentStyle = currentCover.style.backgroundColor;
            /*  determine the current background colour and adjust as required */
            if (currentStyle == 'rgb(215, 224, 66)') {
              currentCover.style.backgroundColor = '#EABD50'; 
            } else if (currentStyle == 'rgb(234, 189, 80)') {
              currentCover.style.backgroundColor = '#77E042'; 
            } else if (currentStyle == 'rgb(119, 224, 66)') {
              currentCover.style.backgroundColor = '#40AAD8'; 
            } else if (currentStyle == 'rgb(64, 170, 216)') {
              currentCover.style.backgroundColor = '#4057D8'; 
            } else if (currentStyle == 'rgb(64, 87, 216)') {
              currentCover.style.backgroundColor = '#C642E0'; 
            } else if (currentStyle == 'rgb(198, 66, 224)') {
              currentCover.style.backgroundColor = '#B23346'; 
            } else if (currentStyle == 'rgb(178, 51, 70)') {
              currentCover.style.backgroundColor = '#B23346'; 
            } else {
              currentCover.style.backgroundColor = '#D7E042'; 
            }
          }
        }
      }
    } // END of ProcessScheduleAssistant ( shiftName ) FUNCTION
