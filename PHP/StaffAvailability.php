<?php
/**
   * ANOR Labs Software Development
   * Created :   2016
   * Author  :   Gavin Shelley    
   *
   * Check Staff Availability
   *
   * Checks the Staff Availability for the 
   * Staff ID and Selected date and returns
   * true when availability is found and
   * false when it is not
   *
   * @param       integer   staff_id            staff unique identifier 
   * @param       date      select_date         date selected for availability check
   * @param       date      start               placeholder 
   * @param       date      end                 placeholder
   * @return      boolean   is_avail            returns availability check value
   */
    function is_staff_availability ( $staff_id , $select_date , $start , $end ) {

      /*  declare function locals */
      $avail_rows           = "";     // number of staff availability rows for id and date
      $avail_results        = "";     // staff availability information for id and date
      $is_avail             = "";     // check staff availability status value
      $avail_start          = "";     // staff avilability start date
      $avail_end            = "";     // staf availability end date
      $check_end            = "";     // number of availabilty for id date 

      /*  set staff availibity rows */
      $avail_rows           = dbs_stav_staff_date(0, $staff_id, $select_date, $start, $end);
      /*  set availability check to false */
      $is_avail             = false;

      /*  determine if staff availbility rows are greater than 0 */
      if ($avail_rows > 0) {
        /* set staff availability information */
        $avail_results      = dbs_stav_staff_date(1, $staff_id, $select_date, $start, $end);

        /*  iterate through staff avilability information */
        for ($check = 0; $check < $avail_rows; $check++) {
          /*  set availability dates */
          $avail_start      = $avail_results[$check]['start_date'];
          $avail_end        = $avail_results[$check]['end_date'];

          /*  determine if the selected date is the same as the start date */ 
          if ($select_date == $avail_start) {
            /*  set availabilty check to true */
            $is_avail = true;

          /*  determine if the selected date is greate than the start date*/
          } elseif ($select_date > $avail_start) {
            /*  determine if the availability has an end date */
            if ($avail_end != "" || $avail_end != null) {
              /*  determine if the selected date is less than equal to the end date */
              if ($select_date <= $avail_end) {
                /*  check for availabity for id date */
                $check_end  =  dbs_stav_staff_date_end(0, $staff_id, $select_date);
                /*  determine if check end is greater than 0 */
                if ($check_end > 0) {
                  /*  set availabilty check to true */
                  $is_avail = true;
      } } } } } }
      /*  return availability status value */
      return $is_avail;
    }
?>
