
  /*  
  ANOR Labs Software Development
  Created :   2016
  Author  :   Gavin Shelley
  */
   
//==================================================================================
// SCHEDULING DEMONSTRATION FUNCTIONS
//==================================================================================


    /* DISPLAY INDEX PAGE INFORMATION SECTIONS
  ===============================================
  ev            = the element that triggered the event  
  Display and hide the About and Contact information sections located
  on the index page of the site*/
  function indexDisplay(ev) {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var delay;            // holds the delay value for the main setTimeout function
    var maxDelay;         // holds the delay value for the inner setTimeout function
    var main;             // Main information division on the page
    var section1;         // section to be displayed
    var section2;         // section to be hidden
    var eventId           // the id of the element that triggered the event
    var direction         // the float value for the main section of the index

    /* initialize the local variables */
    delay                 = 0;
    maxDelay              = 1500;
    main                  = document.getElementById("subMainInformation");
    eventId               = ev.target.id;


    function adjustSizing() {
      /* check to see if section is already open on the index page */
      if (!(section2.style.width == "" || section2.style.width == "0px")){

        /* return the index page back to the original state with the main section set
        to 100%, section2 width set to 0, clear section2 style display property and 
        set the value of delay to the value of maxDelay */
        main.style.width          = "100%";   
        section2.style.width      = "0";
        section2.style.display    = "";  
        delay                     = maxDelay;  
      }
    
      /* set the delay for executing the following code and check to see if section1 is 
      currently closed or open and then process based on the open closed state */
      setTimeout(function () {  
        if (section1.style.width == "" || section1.style.width == "0px"){

          /* set the widths of the main and section one to split the screen into two 
          equals parts, change the float property of the main section to match the side
          of the screen it will animate to, and display section1 once the delay is completed */          
          main.style.width        = "59.99%";  
          main.style.float        = direction;
          setTimeout(function (){                            
              section1.style.display = "inline-block";
              section1.style.width = "39.99%";
          },maxDelay);                        
        } else {

          /* set the width of the main section to 100% and section1 to 0 to return the main 
          section to the full screen, section1 to 0, and clear the style display property */
          main.style.width        = "100%"; 
          section1.style.width    = "0";
          section1.style.display  = "";
        }
      }, delay)

      /* prevent the default action of the navigation link from loading the link */
      ev.preventDefault();
    }

  } //END OF THE indexDisplay(ev, main, section1, section2, direction) FUNCTION

  /* CHECK SHIFT TIME INPUTS
  ===============================================   
  Check the formatting of the user input shift times, calculate the 
  duration of individual shifts and set error messages based on the
  shift rules and valid clock times */
  function checkTimeInput(ev) {


    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var checkInput;       // holds the element that triggered the event
    var inputName;        // holds the ID of the checkInput element
    var dayName;          // holds the day name taken from the inputName
    var staffId;          // holds the Staff Id taken from the inputName
    var start;            // holds the start time of the current shift
    var end;              // hold the end time of the current shift

    /* initialize the local variables */
    checkInput            = ev.target;
    inputName             = checkInput.id;
    dayName               = inputName.substring(0,3);
    staffId               = inputName.substring(4,6);  

    //console.log(inputName + "|" + dayName);

    /* LOCAL FUNCTION getInformation() 
    Send the shift start and end time to the schedule API for processing,
    display the returned shift times in the schedule for the current 
    shift. Display shift colours and errors as required */
    function getInformation(start, end) {

      /* SET LOCAL VARIABLES AND FUNCTIONS 
      ==================================*/
      var httpReq;        // holds the HTTP request object
      var sendInfo;       // holds the information for the request
      var results;        // holds the response from the request    
      var startName;      // holds the id of the shift start element
      var endName;        // holds the id of the shift end element
      var totalName;      // holds the id of the shift total element
      var isTotal;        // holds the element of the shift total      

      /* initialize the local variables */
      httpReq             = new XMLHttpRequest();
      sendInfo            = "start=" + start + "&end=" + end;

      /* ANONYMOUS FUNCTION TO PROCESS THE HTTP REQUEST */ 
      httpReq.onreadystatechange = function() {
        /* check to see if the request was succesfull */ 
        if (this.readyState == 4 && this.status == 200) {

          /* create a JSON object results to contain the response information*/
          results         = JSON.parse(this.responseText);

          //console.log("S:" + results.start_err + "|E:" + results.end_err + "|T:" + results.total);

          /* set the id names for the shift start ,end and total elements */             
          startName       = dayName + "s" + staffId;
          endName         = dayName + "e" + staffId;
          totalName       = dayName + "t" + staffId;

          /* send the returned start and end shift values to the page */ 
          document.getElementById(startName).value  = results.start;
          document.getElementById(endName).value    = results.end;

          /* get the element for the shifts total and send the calculated 
          duration value to the page */
          isTotal           = document.getElementById(totalName);                 
          isTotal.innerHTML = results.total;

          /* check to see if the shift start or shift end triggered and error, 
          when an error is found update the style color for that element to 
          highligh and error or clear to remove existing errors when the value
          is a good time value */
          if (results.start_err != true){
            document.getElementById(startName).style.color  = "red"; } 
          else {
            document.getElementById(startName).style.color  = ""; }
          if (results.end_err != true){
            document.getElementById(endName).style.color    = "red"; } 
          else {
            document.getElementById(endName).style.color    = ""; }

          /* check the value of the shift duration and set the style color of
          the shift total element to the specified color */
          if (results.total == 0) {
            isTotal.style.color   = ""; }
          else if (results.total <= 6) {
            isTotal.style.color   = "blue"; }
          else if (results.total <= 9){
            isTotal.style.color   = "green"; }
          else {
            isTotal.style.color   = "red"; }


          /* determine if both of the processed times are 00:00 set to clear the 
          current shift from the schedule totals */
          if (results.start == "00:00" && results.end == "00:00") { 
            /* send the returned start and end shift values to the page */ 
            document.getElementById(startName).value  = "";
            document.getElementById(endName).value    = "";
            isTotal.style.color                       = "";
          }


          /* call the function to calculate the staff members total scheduled hours, 
          the current day of the week scheduled hours and the full department 
          scheduled hours */
          calculateStaffTotal(staffId);
          calculateDayTotal(dayName);
          calculateDeptTotal();
        } 
      } // END OF onreadystatechange ANONYMOUS FUNCTION

      // open the current request and send the information to the API for processing
      httpReq.open("POST", "./api/api.php/shifts?" + sendInfo, true);
      httpReq.send();  

    } // END OF THE getInformation() FUNCTION    


    /* Set the shift start and end values based on the current target 
    being a start shift element or an end shift element */
    if (inputName.charAt(3) == "s"){
      start    = checkInput.value;
      end      = checkInput.nextElementSibling.value;
    } else {
      end      = checkInput.value;
      start    = checkInput.previousElementSibling.value;
    }   

    startName       = dayName + "s" + staffId;
    endName         = dayName + "e" + staffId;   

    start       = document.getElementById(startName).value;
    end         = document.getElementById(endName).value;          
        
    /* check to see if both of the shift elements are not empty */        
    if (start != "" && end != "") {

      /* hide the add new staff and toggle shift totals elements */
      //document.getElementById("inpAddNew").style.display = "none";
      //document.getElementById("inpToggleHours").style.display = "none";
      //document.getElementById("subAddNew").style.borderRight = "0";
      //document.getElementById("subToggleHours").style.borderLeft = "0";

      /* send the start and end shift values to the function for processing */
      var shiftTimes      = getInformation(start, end);                  
    } else {

      /*==================================================================================*/
      var clearDay        = dayName + "t" + staffId;
      document.getElementById(clearDay).innerHTML   = 0;
      document.getElementById(clearDay).style.color = "";
      calculateStaffTotal(staffId);
      calculateDayTotal(dayName);
      calculateDeptTotal();
      /*==================================================================================*/
    }

  } // END OF THE checkTimeInput() FUNCTION
       


  /* CALCULATE STAFF TOTAL SCHDEULED HOURS 
  ===============================================
  staffId     = the staff id for the current shift 
  Calculate the an individual staffs total scheduled hours */
  function calculateStaffTotal(staffId){ 

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var dayNames;         // an array to hold weekday names
    var totalHours;       // holds the total hour calculaton for the staff
    var currentDay;       // holds the id name for the current day total element
    var dailyTotal;       // holds the value of the current day total
    var totalName;        // holds the if of the staffs total element

    /* initialize the local variables */
    dayNames              = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
    totalHours            = 0;
    totalName             = "total" + staffId;

    /* iterate through the days of the week */
    for (days = 0; days < 7; days++) {

      /* set the ID for the current staff day total get the staffs shift 
      total for the current day and add the staff day total to the staff 
      overall total */
      currentDay          = dayNames[days] + "t" + staffId;                        
      dailyTotal          = document.getElementById(currentDay).innerHTML;                        
      totalHours          = parseFloat(totalHours) + parseFloat(dailyTotal);                        
    }

     /* send the staff total to the staff total element */
    document.getElementById(totalName).innerHTML = totalHours.toFixed(2);                       

  } // END OF THE calculateStaffTotal() FUNCTION



  /* CALCULATES THE DAY OF THE WEEK TOTALS
  ===============================================
  dayName       = the 3 char name for the day of the week 
  Calculate the total scheduled hours for the passed value of the day of 
  the week*/
  function calculateDayTotal(dayName) {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var staffTotal;       // holds an array containing staff daily totals
    var numberOfStaff;    // holds the number of staff on the current schedule
    var dayTotal;         // holds the total hours for the current day
    var currentId;        // holds the id for the staff being processed
    var currentShift;     // holds the id for staff total being processed
    var currentDay;       // holds the id of the current day total element

    /* initialize the local variables */
    staffTotal            = document.getElementsByClassName("grpStaffTotal");
    numberOfStaff         = staffTotal.length;
    dayTotal              = 0; 
    currentDay            = dayName + "t";

    /* iterate through all of the current staff scheduled */
    for (staff = 0; staff < numberOfStaff; staff++) {

      getId               = staffTotal[staff].id;
      staffId             = getId.substring(5,7); 

      /* set the current ID number to the current counter */
      currentId           = staff;

      /* determine if the current staff id is less than 10 and when it is 
      Format with number with a leading 0 when it is less than 10, then set 
      the id name for the current shift to process */
      /*if (staffId < 10) {
        staffId = "0" + staffId;
      }*/
      currentShift        = dayName + "t" + staffId;

      /* add the value of the current shift duration to the daily total */
      dayTotal += parseFloat(document.getElementById(currentShift).innerHTML);
    }

    /* send the current day total to the day total element */
    document.getElementById(currentDay).innerHTML = dayTotal.toFixed(2);

  } // END OF THE calculateDayTotal() FUNCTION



  /* CALCULATE THE FULL SCHEDULE/DEPT TOTAL
  ===============================================
  Calculate the Department/Schedule total of all staff currently on the schedule */
  function calculateDeptTotal() {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var staffTotals;      // holds an array of all of the staff totals
    var numberOfStaff;    // holds the number of staff on the current schedule
    var deptTotal;        // holds the total hours for the current schedule
    var currentTotal;     // holds the total for the current staff being processed

    /* initialize the local variables */
    staffTotals           = document.getElementsByClassName("grpStaffTotal");
    numberOfStaff         = staffTotals.length;
    deptTotal             = 0;
    currentTotal          = 0;

    /* iterate through all of the current staff scheduled */
    for (total = 0; total < numberOfStaff; total++) {

      /* get the total hours for the current staff member and increment the 
      dept/schedule total by the current total */
      currentTotal        = parseFloat(staffTotals[total].innerHTML);
      deptTotal           += currentTotal;
    }

    /* send the dept/schedule total to the schedule total element */
    document.getElementById("outScheduleTotal").innerHTML = deptTotal.toFixed(2);                        

  } // END OF THE calculateDeptTotal() FUNCTION 
      
  

  /* ADD NEW STAFF TO THE SCHEDULE 
  ===============================================  
  This function will determine if a current staff member already exists in the
  schedule, when the first staff is being added the main body of the schdule will
  be set to visible to display the header and staff rows. Each row will be built 
  to contain all the inputs for each day of the week and then add the appropriate 
  event listenrs for each of the new inputs */
  function addNewStaff(ev) {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var checkTotal;       // holds the value of the schedules total hours
    var confirmToggle;    // holds the response from the confirm prompt for new users
    var schedule;         // holds the entire schedule element 
    var rows;             // holds the number of rows currently in the schedule
    var dayNames;         // holds an array of 3 char day names
    var maxStaff;         // holds the maximum number of staff in a schedule
    var content;          // holds the display content element (center of the panel)
    var newRow;           // holds a new row elements for a table
    var enterName;        // holds the name of the staff for the row
    var newName;          // holds the new cell for staff name
    var newTotal;         // holds the new cell for staff total hours
    var staffId;          // holds the numeric value of the staff id
    var newDay;           // holds the cells for the days of the week
    var shiftInput;       // holds all of the input elements in the schdule
    var totalInput;       // holds the number of inputs in the schedule
    var nextId; 

    /* get the current total hours scheduled and determine if any shifts have been entered. 
    0 value indicates no shifts have been entered. Display a prompt to the user that adding 
    a new staff member with current shifts will cuase the schedule to restart and confirm 
    the user wants to continue */
    checkTotal            = parseFloat(document.getElementById("outScheduleTotal").innerHTML);    
    if (checkTotal != 0) {
      //confirmToggle       = confirm("Adding a Staff memeber will clear the current Schedule.\nDo you want to continue?");
      confirmToggle       = 1; 
    } 
    else {
      confirmToggle       = 1; }
    
    /* add the new staff row to the table when the user has confirmed the changes */
    if (confirmToggle == true) {

      /* initialize local variables for the schedule */
      maxStaff            = 10;
      schedule            = document.getElementById("subScheduleTable");
      rows                = (schedule.rows.length) -1;
      dayNames            = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];

      currentStaff        = schedule.lastChild.id;
      nextId              = (currentStaff.substr(5, currentStaff.length));
      intId               = parseInt(nextId);
      
      /* check to see if this will be the first staff to be added to the schedule and 
      change the style visibility of the display content div to visible which will show
      the contents and headers for the schedule */
      if (rows == 0) {
        content           = document.getElementById("subMiddlePanel");
        content.style.visibility = "visible";
        intId             = 0;
      }
      
      /* check to see if the maximum number of staff has been entered before building 
      the new row for staff scheduling */
      if (rows < (maxStaff)){
        
        /* initialize the staff id */
        staffId         = intId + 1;

        /* check the value of the staff id, if it is less than 10 add a leading
        0 for proper formatting of the staff id */
        if (staffId < 10) {staffId = "0" + staffId;}

        /* initialize local variables for the table row */
        newRow            = document.createElement("tr"); 
        newRow.id         = ("staff" + staffId);
        newRow.className  = "sch_shifts";
       
        /* initialize local variables for the table name cell */
        newName           = newRow.insertCell(0);
        newName.id        = ("staffId" + staffId );
        newName.className = "sch_staff_name";
        newName.innerHTML = "<span id=\"del"+staffId+"\" class=\"grpDelStaff cn_del\" >&#9851;</span>"; 
        newName.innerHTML += "<input id=\"inp"+staffId+"\" type=\"text\" class=\"cn_demo_name\" value=\"Click to enter name\" />";
       
        /* check the value of row for values less than 10. when the value is less
        than 10 add a leading 0 for proper id formatting of the totalRow value */
        if (rows < 10) {
          totalRow        = "0" + rows; }
        else { 
          totalRow        = rows; }

        /* initialize local variables for the table total cell */
        newTotal          = newRow.insertCell(1);
        newTotal.id       = ("total" + staffId);
        newTotal.className = "grpStaffTotal sch_staff_total";
        newTotal.innerHTML = "0.00";
        
        /* iterate through the days of the week */
        for (day = 0; day < 7; day++) {

          /* initialize local variables for the table day input cells */
          newDay          = newRow.insertCell(day + 2);
          newDay.className = "sch_shift_inputs";
          newDay.innerHTML = 
            "<input id=\"" + dayNames[day] + "s" + staffId +"\" class=\"grpShiftInput sch_shift_start\" name=\"mons[]\" type=\"text\" value=\"\" />" + 
            "<span class=\"shift_div\" >-</span>" +
            "<input id=\"" + dayNames[day] + "e" + staffId +"\" class=\"grpShiftInput sch_shift_end\" name=\"mone[]\" type=\"text\" value=\"\" />" +
            "<span id=\"" + dayNames[day] + "h" + staffId +"\"class=\"grpShiftView sch_shift_total\">" +
            "<span id=\"" + dayNames[day] + "t" + staffId +"\" class=\"grpShiftTotal\">0</span> hours</span>";
        }
        
        /* add the new row after the last row in the currentschedule table*/
        schedule.appendChild(newRow);

        var inputId       = "inp" + staffId;
        var deleteId      = "del" + staffId;
        var delStaff      = document.getElementById(deleteId);
        var inputStaff    = document.getElementById(inputId);
        inputStaff.addEventListener("click", function(ev) {
          this.select();
        }, false);
        delStaff.addEventListener("click", function(ev){
          var targetId    = ev.target.id;
          var idNum       = targetId.substr(3, targetId.length);
          var rowId       = "staff" + idNum;
          var delRow      = document.getElementById(rowId);
          schedule.removeChild(delRow);
          adjustScrollBar();
        }, false);
        
        /* get all of the input elements in the schdule and the quantity of those 
        elements */
        shiftInput        = document.getElementsByClassName('grpShiftInput');
        totalInput        = shiftInput.length;

        /* iterate through the new input elements and add the required event listeners */
        for (input = (rows * 14); input < totalInput; input ++){
          shiftInput[input].addEventListener("blur", checkTimeInput, false);
          shiftInput[input].addEventListener("contextmenu", loadShifts, false);
          shiftInput[input].addEventListener("click", function(){this.select()}, false);
        }

        /* reset the current shift values in the current schedule */
        //resetPageInformation();
      } else {

        /* display the message when the maximun number of scheduled staff is reached */
        alert("Max Reached");
      }

      adjustScrollBar();

    }

  } // END OF THE addNewStaff(ev, name = "empty") FUNCTION 
        


  /* CLEAR ALL INPUT SHIFT TIMES AND TOTAL VALUES
  ===============================================    
  The function will clear of the user input shift time and set to 0, clear the
  daily totals time and set to 0 and clear the shchedule total time and set to 0 */    
  function resetPageInformation() {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var staffTotals;      // holds an array containing shift total elements
    var dayTotals;        // holds an array containing day total elements
    var dayNames;         // holds an array containing 3 character day names
    var numberOfStaff;    // holds the number of staff on the current schedule
    var numberOfTotals;   // holds the number of day totals on the current schedule
    var currentDay;       // holds the id of the current day being processed
    var staffShifts       // holds the collection of staff shift elements
    var numberOfShifts    // holds the number of shifts to be cleared

    /* initialize the local variables */
    dayNames              = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];   
    staffTotals           = document.getElementsByClassName("grpStaffTotal");
    dayTotals             = document.getElementsByClassName("grpShiftTotal"); 
    staffShifts           = document.getElementsByClassName("grpShiftInput");    
    numberOfStaff         = staffTotals.length;   
    numberOfTotals        = dayTotals.length;
    numberOfShifts        = staffShifts.length;

    /* set the add new staff and toggle hours buttons to display on the screen */
    document.getElementById("inpAddNew").style.display = "";
    document.getElementById("inpToggleHours").style.display = "";
    document.getElementById("subAddNew").style.borderRight = "";
    document.getElementById("subToggleHours").style.borderLeft = "";

    /* iterate through all of the shift input fields and clear the values */
    for (shifts = 0; shifts < numberOfShifts; shifts++) {
      staffShifts[shifts].value    = "";
    }

    /* iterate through all total hours for all staff and set to 0 value */
    for (total = 0; total < numberOfStaff; total++) {
      staffTotals[total].innerHTML = "0.00";                    
    }  
    
    /* iterate through all of the shift totals, set to 0 value and update the
    element style color back to black */
    for (days = 0; days < numberOfTotals; days++) {
      dayTotals[days].innerHTML   = 0; 
      dayTotals[days].style.color = "black";                 
    }  
    
    /* iterate through all of the day totals and set to 0 value */
    for (day = 0; day < 7; day++) {
      currentDay          = dayNames[day] + "t";
      document.getElementById(currentDay).innerHTML = "0.00";
    }   

    /* set the schedules total value to 0 */
    document.getElementById("outScheduleTotal").innerHTML = "0.00";

  } // END OF THE resetPageInformation() FUNCTION 
       


  /* TOGGLE INDIVIDUAL SHIFT TOTALS
  ===============================================    
  This function will toggle the individual shift total from being visible 
  to being hidden */
   function toggleViewShiftHours() {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var confirmToggle;    // holds the check value for performing the view change
    var checkTotal;       // holds the value of the schdule total hours 
    var viewShifts;       // holds the array of elements containing shift totals
    var shiftNumbers;     // holds the number of shifts in the array
    var shiftId;          // holds the id number of the shift to be  processed
    var shift;            // holds the shift elements for the id being processed
    var shiftDisplay;     // holds the current style display value of the total element
    var newDisplay;       // holds the toggle for the elements style display

    /* save the current shift start and end times in the current schedule */
    saveShifts();

    /* initialize local variables */
    confirmToggle         = false;
    checkTotal            = parseFloat(document.getElementById("outScheduleTotal").innerHTML);

    viewShifts          = document.getElementsByClassName("grpShiftView");
    shiftNumbers        = viewShifts.length;

    /* determine if a staff member exists on the current schedule and set the
    confirmToggle to true to allow the total shift hours to be toggled */
    if (viewShifts.length > 0){
      confirmToggle       = true; }

    /* check to see if the schedule total is not equal to 0, when it is not 0
    prompt the user to to confirm the toggle before erasing the information on
    the schedule with the toggle function */
    if (checkTotal != 0) {
      //confirmToggle       = confirm("Toggle will clear your current Schedule.\nDo you want to continue?"); 
      confirmToggle       = true;
    }  

    /* check the value of checkToggle before performing the chnaging the view of
    shift total hours */
    if (confirmToggle == true){

      /* initialize local variables */           
      shiftId             = viewShifts[0].id;
      shift               = document.getElementById(shiftId);
      shiftDisplay        = shift.style.display;
  
      /* check to see if style display property for the total shift hours is
      set to none for the first shift on the schedule. When it is set, change 
      the value to "", and not set to "none" to toggle the view */
      if (shiftDisplay == "") {
        newDisplay        = "none"; } 
      else {
        newDisplay        = ""; }

      /* iterate through all of the shift total elements of the schedule */ 
      for (shifts = 0; shifts < shiftNumbers; shifts++) {

        /* update the style display property for the current shift total element */
        shiftId           = viewShifts[shifts].id;
        shift             = document.getElementById(shiftId);
        shift.style.display = newDisplay;
      }
    } else {
      /* hold for error message to the end user */
    }

  } // END OF THE toggleViewShiftHours() FUNCTION 

        

  /* SAVE THE VALUES OF SHIFT INPUT TIMES
  ===============================================    
  This function will save the values of the user input start and end of shift times
  into an array that can be used to call back information if the page is cleared.
  The array required to use this function is declared at the top of the header file 
  so that it is accessible to all function for the demo-schedule page */     
  function saveShifts(){

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var saveInputs;       // holds an array of all of the shift input elements 
    var inputNumbers;     // holds the number of elements in the array
    var inputList;        // save value array

    /* initialize the local variables */
    saveInputs            = document.getElementsByClassName("grpShiftInput");
    inputNumbers          = saveInputs.length;  
    inputList             = new Array(); 

    /* iterate through all of the shift elements and add to the array */
    for (saveInput = 0; saveInput < inputNumbers; saveInput++) {
      inputList[saveInput] = saveInputs[saveInput].value; } 
   
  } // END OF THE saveShifts() FUNCTION 
            


  /* LOADS THE SHIFT VALUES BACK TO THE SCHEDULE
  ===============================================    
  This function will load the shift time values from the array back to the shift 
  input elements on the schedule. This function is used in conjunction with the
  saveShift function which need to be run before this function will work properly */
  function loadShifts() {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var saveInputs;       // holds an array of all of the shift input elements 
    var inputNumbers;     // holds the number of elements in the array
    var inputId;          // holds the id of the element being processed
    var currentInput;     // holds the element being processed 

    /* initialize local variables */
    saveInputs            = document.getElementsByClassName("grpShiftInput");
    inputNumbers          = saveInputs.length;  

    /* iterate through all of the shift elements*/
    for (saveInput = 0; saveInput < inputNumbers; saveInput++) {   

      /* get the value from the array at the current index and copy the value 
      from the array into the shift input with the same index value */
      inputId             = saveInputs[saveInput].id;
      currentInput        = document.getElementById(inputId)
      currentInput.value  = "";
    }   

  } // END OF THE loadShifts() FUNCTION 



  /* DISPLAYS SCHEDULE DEMO SETUP PANEL
  ===============================================    
  This function will display an introduction panel to explain what the demo is
  and allows the end user to enter the schedule build options fos the Schedule
  Name, Creater Name, Date and the number of staff with information. */
  function staffNameEntry(ev) {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var staffInfo;        // holds the element containing the number of staff entered
    var staffNumber;      // holds the value of the staffInfo element
    var checkName;        // holds the element for staff name entry
    var currentName;      // holds the value of the checkName element
    var enterStaff;       // holds the element for number of staff entry
    var maxStaff;         // holds the value of the enterStaff element
    var enterAllNames;    // holds the element for the enter staff name panel
    var submitInfo;       // holds the element for the submit schedule panel 

    /* initialize local variables */
    staffInfo             = document.getElementById("outStaffNumber");
    staffNumber           = parseInt(staffInfo.innerHTML);
    checkName             = document.getElementById("inpStaffName");
    currentName           = checkName.value;
    enterStaff            = document.getElementById("inpStaffNumber");
    maxStaff              = parseInt(enterStaff.value);
    enterAllNames         = document.getElementById("subStaffNames");
    submitInfo            = document.getElementById("subViewSchedule");
    
    /* add a new staff to the schedule with the user input name */
    addNewStaff(ev, currentName);

    /* increment the staff input number by 1, clear the current name in the input 
    and put the focus back to the input to input the next staff for the schedule */
    staffInfo.innerHTML = (parseInt(staffNumber) + 1);
    checkName.value = "";
    checkName.focus();

    /* check to see if the current staff number is at the maximun staff number */
    if (staffNumber >= maxStaff) { 

      /* update the style display properties for the enter name panel to hide and 
      stop staff name input, and show the submit schedule information panel to allow
      the user to close the introduction panel and view the schedule prototype */
      enterAllNames.style.display = "none";
      submitInfo.style.display = "";
    }

  } // END OF THE staffNameEntry() FUNCTION 



  /* EVENT CLICK MODAL PANEL
  ===============================================    
  This function handles the events for the Click even on the Schedule options
  modal panel when the page loads */
  function eventClickModal(ev) {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var myClick;          // element id of the element trigggering the event   
    var enterStaff;       // the number of staff to add to the schedule   
    var schOptions;       // division containing schedule input panel     
    var modalPanel;       // division containing the schedule information panel
    var staffInfo;        // holds the element containing the number of staff entered
    var staffNumber;      // holds the value of the staffInfo element

    /* initialize local variables */
    myClick               = ev.target.id;
    modalPanel            = document.getElementById("secScheduleSetup"); 
    enterStaff            = document.getElementById("inpStaffNumber"); 
    schOptions            = document.getElementById("subSheduleOptions"); 
    staffInfo             = document.getElementById("outStaffNumber");
    staffNumber           = parseInt(enterStaff.value);

    /* process the id of the event trigger */
    switch(myClick) {
      case "inpClosePanel": 
        /* close the schedule information panel. set the style display 
        property to none to hide the panel */
        modalPanel.style.display = "none"; 
        break;
      case "inpViewSchedule": 
        /* add the number of staff based on the number input by the user */
        for (newStaff = 0; newStaff < staffNumber; newStaff++ ) {
          addNewStaff();
        }
        /* close the schedule information panel. clear the style display
        property */
        modalPanel.style.display = ""; 
        break;
      case "inpEnterStaff": 
        /* enter new staff to the schedule. called the staffEntry function 
        to enter the new staff and load the current shifts into the storage 
        array */
        staffNameEntry(); 
        loadShifts(); 
        break;
      case "inpEnterInformation": 
        /* closes the staff name entry panel. clear the division style 
        dsiplay property  */
        schOptions.style.display = ""; 
        break;
      default: 
        /**/
    }

  } // END OF THE eventClickModal(id) FUNCTION



  /* EVENT CLICK BUTTON ROW
  ===============================================    
  This function handles the events for the Click even on the Schedule options
  buttons at the bottom of the schedule  */
  function eventClickButtons(ev) {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var myClick;         // element id of the element trigggering the event   

    /* initialize local variables */
    myClick               = ev.target.id;

    /* process the id of the event trigger */
    switch(myClick) {
      case "inpCreateNew" :
        /* perform the add new staff function */ 
        location.reload();
        break;
      case "inpAddNew" :
        /* perform the add new staff function */ 
        addNewStaff(); 
        break;
      case "inpResetButton": 
        /* perform the reset schedule options */
        resetPageInformation(); 
        break;
      case "inpToggleHours": 
        /* perform toggle shift hours function */
        toggleViewShiftHours(); 
        //loadShifts(); 
        break;
      case "inpPrint": 
        /* perform the print schedule option */
        //saveShifts();
        window.print(); 
        break;
      default: 
        /**/
    }

  } // END OF THE eventClickButtons(id) FUNCTION



  /* EVENT KEY UP SCHEDULE OPTION INPUTS
  ===============================================    
  This function handles the events for the Key Up event of the input 
  elements of the schedule creating panel on page load  */
  function eventKeyUpInputs(ev) {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var myClick;          // element id of the element trigggering the event
    var schDate;          // schedule title date
    var enterDate;        // schedule create input date
    var schName;          // schedule title name
    var enterName;        // schedule create input name
    var manName;          // schedule title user name
    var enterUser;        // schedule create input use name 

    /* initialize local variables */
    myClick               = ev.target.id;
    schDate               = document.getElementById("outScheduleDate");
    enterDate             = document.getElementById("datepicker");
    schName               = document.getElementById("outScheduleName");
    enterName             = document.getElementById("inpScheduleName");
    manName               = document.getElementById("outManagerName"); 
    enterUser             = document.getElementById("inpManagerName");  

    /* process the id of the event trigger */
    switch(myClick) {
      case "datepicker":
        /* update the schedule date with the date entered in the create panel */
        schDate.innerHTML = enterDate.innerHTML;
        break;
      case "inpScheduleName":
        /* update the schedule name with the name entered in the create panel */
        schName.value = enterName.value;
        break;
      case "inpManagerName":
        /* update the schedule user with the name entered in the create panel */
        manName.value = enterUser.value;
        break;
      default: 
        /**/
        break;
    }

  } // END OF THE eventClickButtons(id) FUNCTION



   /* EVENT TO ADJUST WIDTH FOR SCROLL BAR
  =============================================== 
  */
  function adjustScrollBar() {

    /* SET LOCAL VARIABLES AND FUNCTIONS 
    ==================================*/
    var scheduleHeight; 
    var scheduleWidth;
    var panelHeight;  
    var scrollWidth;

    /* initialize local variables */
    scheduleHeight        = document.getElementById("subScheduleTable").offsetHeight;
    scheduleWidth         = document.getElementById("subScheduleTable").offsetWidth;
    panelHeight           = document.getElementById("subMiddlePanel").offsetHeight;
    scrollWidth           = scheduleWidth + 1;

    if (scheduleHeight > panelHeight) {
      document.getElementById("subBottomPanel").style.width = scrollWidth + "px";
    } else {
      document.getElementById("subBottomPanel").style.width = "";
    }   

  } // END OF THE adjustScrollBar() FUNCTION