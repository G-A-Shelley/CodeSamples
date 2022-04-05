/**
   * ANOR Labs Software Development
   * Created  :   2016
   * Author   :   Gavin Shelley       
   * Page     :   sch-budget-weekly.php 
   *
   * Process Budget Table Information
   *
   * calculates budgets information for changes and 
   * efficiences for both a departments schedule 
   * and timeclock totals
   *
   * @param     none 
   * @return    none
   */
    function ProcessWeeklyBudget () {       

      /*  define function locals */
      var outTotalBudget;   // id total budget element
      var outTotalSchedule; // id total schedule element
      var outTotalClock;    // id total clock element
      var outTotalPay;      // id total pay element
      var outChangeSchedule;// id schedule change element
      var outChangeClock;   // id clock change element
      var outChangePay;     // id pay change element
      var grpDeptBudget;    // class for department budget values
      var grpDeptPercent;   // class for department budget percentages
      var grpSchedTotal;    // class for department schedule values
      var grpSchedChange;   // class for department schedule change values
      var grpClockTotal;    // class for department timeclock values
      var grpClockChange;   // class for department timeclock change values
      var grpPayTotal;      // sum of dept weekly payroll
      var grpPayChange;     // payroll vs budget totals
      var totalDepartments; // number of departments being processed
      var sumBudget;        // sum of all department budget values
      var sumSched;         // sum of all department schedule values
      var sumClock;         // sum of all department clock values
      var sumPay;           // sum of all department pay values

      /*  get information from page elements */
      outTotalBudget        = document.getElementById('outTotalBudget');
      outTotalSchedule      = document.getElementById('outTotalSchedule');
      outTotalClock         = document.getElementById('outTotalClock');
      outTotalPay           = document.getElementById("outTotalPay");
      outChangeSchedule     = document.getElementById('outChangeSchedule');
      outChangeClock        = document.getElementById("outChangeClock");
      outChangePay          = document.getElementById("outChangePay");
      grpDeptBudget         = document.getElementsByClassName('grpDeptBudget');
      grpDeptPercent        = document.getElementsByClassName('grpDeptPercent');
      grpSchedTotal         = document.getElementsByClassName('grpSchedTotal');
      grpSchedChange        = document.getElementsByClassName('grpSchedChange');
      grpClockTotal         = document.getElementsByClassName('grpClockTotal');
      grpClockChange        = document.getElementsByClassName("grpClockChange");
      grpPayTotal           = document.getElementsByClassName("grpPayTotal");
      grpPayChange          = document.getElementsByClassName("grpPayChange");

      /*  process page information values */
      totalDepartments      = 0;
      sumBudget             = 0;
      sumSched              = 0;
      sumClock              = 0;
      sumPay                = 0;      
      totalDepartments      = grpDeptBudget.length;

      /*  iterate through all of the current department information */
      for (dept=0; dept < totalDepartments; dept++) {      

        /*  define iteration locals */
        var change;         // department difference of schedule and budget
        var budget;         // department budget value
        var schedule;       // department schedule value
        var efficiency;     // department schedule efficiency value
        var clock;          // department clock value
        var chgClock;       // department difference of timeclock and budget
        var effClock;       // department budget efficiency value
        var chgSchedule;    // departmentschedule change value
        var pay;            // department pay
        var chgPay;         // department pay change value

        /*  process iteration information values */
        change              = 0;
        budget              = 0;
        schedule            = 0;
        efficiency          = 0;
        clock               = 0;
        chgClock            = 0;
        effClock            = 0;
        chgSchedule         = 0;
        chgPay              = 0;

        /*  get the information for the current departments 
            budget, schedule and timeclock  */
        budget              = grpDeptBudget[dept].value;
        schedule            = grpSchedTotal[dept].innerHTML;
        clock               = grpClockTotal[dept].innerHTML;
        pay                 = grpPayTotal[dept].innerHTML;      

        /* determine if the budget value is an integer value */
        if (parseInt(budget)) {

          /*  calculate the values for schedule change and efficiency 
              and for timeclock change and efficiency */
          change            = ((budget - schedule)*(-1)).toFixed(2);
          efficeincy        = ((schedule/budget)*100).toFixed(0);
          chgClock          = ((clock - budget)*(1)).toFixed(2);
          effClock          = ((clock/budget)*100).toFixed(0);
          chgPay            = ((pay - budget)*(1)).toFixed(2);

          /*  update the pge with the calculated information */
          grpSchedChange[dept].innerHTML      = change;
          grpClockChange[dept].innerHTML      = chgClock;
          grpPayChange[dept].innerHTML        = chgPay;

          /*  update the color of the calculated information to 
              highlight the information for the end user */

          /*  budget vs schedule */
          if (change > 0) {
            grpSchedChange[dept].style.color  = "red"; 
          } else if (change < 0) {
            grpSchedChange[dept].style.color  = "green"; 
          } else {
            grpSchedChange[dept].style.color  = "black"; 
          }

          /*  budget vs clock */
          if (chgClock > 0) {
            grpClockChange[dept].style.color  = "red"; 
          } else if (chgClock < 0) {
            grpClockChange[dept].style.color  = "green"; 
          } else {
            grpClockChange[dept].style.color  = "black"; 
          }

          /*  budget vs payroll */
          if (chgPay > 0) {
            grpPayChange[dept].style.color    = "red"; 
          } else if (chgPay < 0) {
            grpPayChange[dept].style.color    = "green"; 
          } else {
            grpPayChange[dept].style.color    = "black"; 
          }

          /* claculate the sum of all departments budgets 
          and scheduled values */
          sumBudget         += parseInt(budget);
        } 
          sumSched          += parseFloat(schedule);
          sumPay            += parseFloat(pay);
          sumClock          += parseFloat(clock);
      }

      /*  iterate through all of the current department information 
          calculate the departments budget percentage of the full budget */
      for (dept=0; dept < totalDepartments; dept++) {    

        /*  define iteration locals */
        var budget;         // id department budget values
        var percentage;     // id department efficiency values

        /*  process iteration information values */
        budget              = 0;
        percentage          = 0;

        /* get the budget value for the current department */
        budget              = (grpDeptBudget[dept].value);      

        /* determine if the budget value is an integer value */
        if (parseInt(budget)) {
          /*  calculate the departments budget percentage and output to the table */
          percentage        = ((budget/sumBudget)*100).toFixed(2);
          grpDeptPercent[dept].innerHTML = percentage;
        } 
      }

      /* calculate the schedule total for all departments */
      chgSchedule           = (sumSched - sumBudget);
      chgPay                = (sumPay - sumBudget);
      chgClock              = (sumClock - sumBudget);

      /* update the color of the calculated information to 
      highlight the information for the end user */

      /*  budget vs schedule */
      if (chgSchedule < 0) {
        outChangeSchedule.style.color   = "green";
      } else if (chgSchedule > 0) {
        outChangeSchedule.style.color   = "red";
      } else {
        outChangeSchedule.style.color   = "black";
      }

      /*  budget vs payroll */
      if (chgPay < 0) {
        outChangePay.style.color        = "green";
      } else if (chgPay > 0) {
        outChangePay.style.color        = "red";
      } else {
        outChangePay.style.color        = "black";
      }

      /*  budget vs clock */
      if (chgClock < 0) {
        outChangeClock.style.color      = "green";
      } else if (chgClock > 0) {
        outChangeClock.style.color      = "red";
      } else {
        outChangeClock.style.color      = "black";
      }

      /* update the pge with the calculated information */
      outTotalBudget.innerHTML          = (sumBudget).toFixed(2);
      outTotalSchedule.innerHTML        = (sumSched).toFixed(2);
      outChangeSchedule.innerHTML       = (chgSchedule).toFixed(2);
      outTotalClock.innerHTML           = (sumClock).toFixed(2);
      outChangeClock.innerHTML          = (chgClock).toFixed(2);
      outTotalPay.innerHTML             = (sumPay).toFixed(2);
      outChangePay.innerHTML            = (chgPay).toFixed(2);
    } // END OF ProcessWeeklyBudget () FUNCTION
