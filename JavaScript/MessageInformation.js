 /**
   * ANOR Labs Software Development
   * Created  :   2016
   * Author   :   Gavin Shelley      
   * Page     :   com-message-new.php         
   *          :   com-message-view.php  
   *
   * Request Dutylist Task Information
   *
   * Request Dutylist Task information by the 
   * Task ID number and display in elements 
   * matching the keys in the returned results
   *
   * @param     integer   taskID          dutylist task unique identifier
   * @param     string    taskStamp       task time stamp
   * @param     string    outSessionInfo  current session information
   * @param     string    outCheckId      current client id 
   * @return    none   
   */     
    function getMessageInfo ( taskID , taskStamp , outSessionInfo , outCheckId) {     

      /*  define function locals */
      var httpReq;          // http request 
      var readyState;       // state of the http request
      var status;           // status of the http request
      var sendID;           // post formatted task ID
      var sendStamp;        // message sent stamp value
      var taskInfo;         // JS object containing task information
      var htmlOut;          // html option elements
      var outSentList;      // html select element

      /*  set the id information for the request */
      sendRequest           = "fnc=message" +  
                              "&terminal=" + outSessionInfo +  
                              "&checkid=" + outCheckId + 
                              "&sendid=" + taskID +
                              "&sendstamp=" + taskStamp;

      /*  initialize a new request */
      httpReq = new XMLHttpRequest();

      /*  check the state of the request */
      httpReq.onreadystatechange = function() {
        /*  determine if the request is completed and OK */
        if (this.readyState == 4 && this.status == 200) {
          /*  parse the JSON content from the response */
          taskInfo = JSON.parse(this.responseText);   
          /*  display the information on the page */ 
          document.getElementById("outSentTitle").textContent = taskInfo.message_title;
          document.getElementById("outSentMessage").textContent = taskInfo.message_body; 

          staffList   = taskInfo.staff_list;
          listTotal   = staffList.length;

          htmlOut   = "";
          htmlOut   += "<option class=\"cn_ddlist_panel\" ";
          htmlOut   += "value=\'X\' >Select Staff</option>";
          outSentList = document.getElementById('outSentList');

          for (staff = 0; staff < listTotal; staff++) {
            htmlOut += "<option class=\"cn_ddlist_panel\" ";
            htmlOut += "value=\'" + staffList[staff]['id'] + "\' >"+staffList[staff]['name']+"</option>";
          }
          outSentList.innerHTML = htmlOut;
        } 
      }
      /*  open the current request and send the information to the API for processing */
      httpReq.open("POST", "./api/api.php", true);
      httpReq.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      httpReq.send(sendRequest);
    } // END of getMessageInfo ( taskID ) FUNCTION
