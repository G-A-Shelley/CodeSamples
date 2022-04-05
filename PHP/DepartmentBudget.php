<?php
 /**
   * ANOR Labs Software Development
   * Created :   2016
   * Author  :   Gavin Shelley    
   *
   * Maintain Multiple Department Budgets
   *
   * Maintains Multiple Department Budget 
   * and Date information for Schedule 
   * Budgets. Checks to ensure information 
   * is being update by a valid staff user 
   * type and will then create a 
   * new budget or update an existing.
   *
   * @param     array       post_info           page post information  
   * @return    none
   */
    function maintain_multi_dept_budget ( $post_info ) {

      /*  declare function locals */
      $staff_type           = "";     // session staff type check value
      $staff_current        = "";     // session current user unique identifier
      $log_title            = "";     // title of log message 
      $log_message          = "";     // content of log message
      $dept_total           = "";     // number of department budgets
      $dept_list            = "";     // array of department unique identifiers
      $dept_id              = "";     // current department unique identifier
      $dept_budget          = "";     // current department budget value
      $dept_name            = "";     // current department full name
      $check_budget         = "";     // check for existing budget information
      $date_total           = "";     // number of dates to process
      $date_list            = "";     // array of budget date information 
      $date_current         = "";     // current date being processed
      $date_budget          = "";     // budget value for current date and department 

      /*  set function locals */
      $staff_type           = $_SESSION['check'];
      $staff_current        = $_SESSION['current_user'];
      $log_title            = "BUDGET";
      $dept_total           = count($post_info['dept']);
      $dept_list            = $post_info['dept'];
      $date_total           = count($post_info['date']);
      $date_list            = $post_info['date'];

      /*  determine if the current staff type is E F*/
      if ($staff_type == 'E' || $staff_type == 'F') {
        /*  set log message */
        $log_message        = "BUDGET ADJUST | DATE " . $date . " UNAUTH ACCESS INFO TO FOLLOW ";
        build_log_files($staff_current, $log_title, $log_message);
        /*  iterate through dates and set log messages */
        for ($i = 0; $i < $date_total; $i++) {
          $date_current     = $date_list[$i];
          $log_message      = "UNAUTH :". $date_current . "| Dept Listings";
          build_log_files($staff_current, $log_title, $log_message); 
        }
      } else {

        /*  iterate throught department list */
        for ($i = 0; $i < $dept_total; $i++) {
          /*  set department information */
          $dept_id          = $dept_list[$i];
          $dept_budget      = $post_info[$dept_id];

          /*  iterate through date list */
          for ($date = 0; $date < $date_total; $date++) {
            /*  set date information */
            $date_current   = $date_list[$date];
            $date_budget    = $dept_budget[$date];

            /*  determine if the department budget is numeric */
            if (ctype_digit($date_budget)) {
              /*  set check budget to rows for dept and date */
              $check_budget = dbs_budget_rows($dept_id, $date_current);

              /*  determine if there is an existing budget */
              if ($check_budget > 0) {
                /*  set log and system message */
                $dept_name   = find_dept_name($dept_id); 
                $log_message = "Update :" . $date_current . "|" . $dept_name . "|" . $date_budget;
                build_log_files($staff_current, $log_title, $log_message); 
                $_SESSION['system_error_messages'] = "Budget Exists/" . $date_budget;
                /*  update department budget information */
                dbu_budget_dept($dept_id, $date_current, $date_budget);
              } else {
                /*  set log and system message */
                $dept_name   = find_dept_name($dept_id); 
                $log_message = "Create :" . $date_current . "|" . $dept_id . "|" . $date_budget;
                build_log_files($staff_current, $log_title, $log_message); 
                $_SESSION['system_error_messages'] = "Create Budget ".$date_budget;
                /*  insert new department budget information */
                dbi_budget_insert($dept_id, $date_current, $date_budget);
              }
            } else {
              $_SESSION['system_error_messages'] = "Not Valid ".$date_budget;
            }
          }
        }
      }
    } // END of maintain_multi_dept_budget ( $post_info ) FUNCTION
?>
