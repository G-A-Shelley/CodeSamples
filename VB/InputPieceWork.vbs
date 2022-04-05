Option Strict On

'**************************************************************************
' Name      : Gavin Shelley
' Course    : VISB 6201
' Program   : Lab 02 InputPieceWork 
' Date      : Feb 16 2015
' Updated   : Mar 1 2015
'           : Mar 17 2015 for Lab 3B
'
' Description
'
'   This is a windows form application that will calculate the pay for
' employees using PieceWork objects. 
'
'   The client can input the Employee name and the number of pieces that
' employee has produced and the application will calculate the pay that
' the employee will receive. The client input will be validate to ensure 
' that a name has been entered and that the number of pieces is a positive 
' whole number. 
'
'   The client can select the type of employee they are going to process
' the pay for by selecting the radio button for either Regular Worker or
' Senior Worker
'
'   The client can then press the clear button to remove the information 
' currently displayed on the form and then continue to enter more 
' employees information. 
'   
'   The client can press the Display Summary button to see the total number
' of pieces, the total pay and the average pay for the employees that have 
' been processed when the button was pressed. 
'
'   The client can then press the Exit button on the Tool Bar
' or select the Close option from the Menus to close the current instance 
' of the form
'   
' Changed Mar 01 2015
' ===================
'   Adjusted to use the SeniorWorkers class in place of PieceWork
'
' Changed Mar 17 2015
' ===================
'   Changes made for Lab 3 Requirements
'   - Added the ability for the client to select the type of employee they want to process
'       the pay for by selecting radio buttons on the form
'   - removed the validation for the minimum number of pieces entered as 0 
'   - Decalre PieceWork and SeniorWorkers objects WithEvents for access to the Event Handlers
'   - Added Try Catch block to catch Exceptions thrown from the PieceWork and SeniorWorkers Classes
'   - If staterments in the Try Catch block to determine what type of worker to process
'   - Catch block looks for thrown ArgumentOutOfRangeException for the range of Pieces and valid Employee Name
'   - Display Exception error message on the Form
'   - Summary form will not open until one employee pay has been processed
'   - Added the Event handlers for Productive and UnderProductive
'
' Changed Apr 13 2015
' ===================
'   - Messages removed from the form and will now be displayed in the Status bar on the Parent form
'   - Added Instance Property that will only open up an instance of the 
'       form when there isnt another instance of the form open
'   - Added the Form Activated Event that will update the message on the 
'       parent form when the current instance of the form has focus
'   - Added the Form Closing Event that will release the current instance 
'       of the form so a new instance can be created when the client goes
'       to open one.
'   - Removed the Display Summary and Exit buttons and the respective Event
'       Handlers. This functionality has been moved to the Main Form of 
'       this application
'
'**************************************************************************

Public Class frmInputPieceWork

#Region "Declarations"

    '===========================================================
    ' CONSTANT AND VARIABLE DECLARATIONS
    '===========================================================
    Dim employeeName As String              ' holds the validated value of an employees name 
    Dim employeePay As String               ' holds the returned value of an individual employees pay formatted for output.
    Dim employeePieces As Integer           ' holds the validated value of the number of pieces an employee produced

    Dim WithEvents employeePayments As PieceWork    ' declares a new PieceWork object 
    Dim WithEvents seniorPayments As SeniorWorkers  ' declares a new SeniorWorkers object
    Dim isMessagePosted As Boolean = False          ' Boolean value to determine if an error message has been set in the Status Bar
    Dim extendMessage As String                     ' String used to concatenate a Status label message with an Error message

    Private Shared pieceWorkInstance As frmInputPieceWork   ' declares an object of the Form Input Piece Work

#End Region

#Region "Properties"

    '===========================================================
    ' Property - Instance
    '===========================================================
    Friend Shared ReadOnly Property Instance() As frmInputPieceWork
        ' A property procedure that will allow the calling class 
        ' to display an instance of the form InputPieceWork. The 
        ' instance will only be displayed if there is not an existing
        ' instance being displayed.

        Get

            ' Determine if there is an existing instance of 
            ' the form InputPieceWork
            If pieceWorkInstance Is Nothing Then
                ' No instance exists

                ' create a new Instance of of the form InputPieceWork
                pieceWorkInstance = New frmInputPieceWork

            End If

            ' Return the value of pieceWorkInstance
            Return pieceWorkInstance

        End Get

    End Property

#End Region

#Region "Form Events"

    '===========================================================
    ' Event Handler - Form Activated
    '===========================================================
    Private Sub frmInputPieceWork_Activated(sender As Object, e As EventArgs) _
        Handles MyBase.Activated
        ' Handles the events when the form InputPieceWork takes focus 

        ' Change the colour of the Status Bar messages
        frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
        ' Update the name of the current form in the Status Bar
        frmMainForm.staPanelCurrentForm.Text = "Enter Production"
        ' Update the Status Bar message for the Input Piece Work form
        frmMainForm.staPanelMessages.Text = "Enter an Workers Information."

    End Sub

    '===========================================================
    ' Event Handler - Text Box Changed 
    '   + Employee Name Text Box 
    '   + Number of Pieces Text box 
    '   + Radio Button Senior Workers
    '===========================================================
    Private Sub txtEmployeeName_TextChanged(sender As Object, e As EventArgs) Handles _
        txtEmployeeName.TextChanged, _
        txtNumberOfPieces.TextChanged, _
        optSeniorWorkers.CheckedChanged
        ' Clears the client message and the employee pay value when the client changes the information in 
        ' the employee name text box, the number of peices text box or the radio buttons 
        ' for the type of employee

        ' Change the colour of the Status Bar messages
        frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
        ' Update the Status Bar message for the Input Piece Work form
        frmMainForm.staPanelMessages.Text = "Enter an Workers Information."
        ' Clear the label containing the calculated value of an employees pay
        lblDisplayEmployeePay.Text = String.Empty

    End Sub

    '===========================================================
    ' emploeePayment Productive Event Handler
    '===========================================================
    Private Sub ProductiveHandler(ByVal pieceWork As PieceWork) _
        Handles employeePayments.Productive
        ' The Productive event is triggered when the individual regular employee pay is 
        ' greater than the maximum pay limit set in the business rules. 

        ' Change the colour of the Status Bar messages
        frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
        ' When the event is triggered Display the message in the Form
        frmMainForm.staPanelMessages.Text = employeePayments.Name + _
            " is producing at a high level, consider recognition for achievement"

        ' Set to True to indicate a message was set by an Event
        isMessagePosted = True

    End Sub

    '===========================================================
    ' seniorPayment UnderProductive Event Handler
    '===========================================================
    Private Sub UnderProductiveHandler(ByVal seniorWorkers As SeniorWorkers) _
        Handles seniorPayments.UnderProductive

        ' Change the colour of the Status Bar messages
        frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
        ' The UnderProductive event is triggered when the individual senior employee
        ' pay is less than the minimum pay limit set in the business rules
        frmMainForm.staPanelMessages.Text = seniorPayments.Name + _
            " is falling behind in production, consider punitive action"

        ' Set to True to indicate a message was set by an Event
        isMessagePosted = True

    End Sub

    '===========================================================
    ' Event Handler - Form Closing
    '===========================================================
    Private Sub frmInputPieceWork_FormClosing(sender As Object, e As Windows.Forms.FormClosingEventArgs) _
        Handles Me.FormClosing
        ' Release the Instance of the form InputPieceWork when the form is closed

        ' Release the Instance of this form by
        ' Setting pieceWorkInstance to Nothing
        pieceWorkInstance = Nothing

    End Sub

#End Region

#Region "Client Click Events"

    '===========================================================
    ' Event Handler - Calculate Pay Button 
    '===========================================================
    Private Sub btnCalculatePay_Click(sender As Object, e As EventArgs) _
        Handles btnCalculatePay.Click
        ' Validates the client input information to ensure an employee name has been entered and 
        ' that the number of pieces entered is a positive whole number starting at the minimum value
        ' set by the constant MINIMUM_PIECES. When the information entered is not valid an error message
        ' is displayed on the form telling the client how to correct the error. Once the two pieces 
        ' of information are validated the application creates a new PieceWork object using them and
        ' display the pay for the current employee on the form

        ' Input Validation of Employee Name and Number of Pieces
        '=======================================================

        ' Determine if the text box for employee name is empty
        If txtEmployeeName.Text = "" Then
            ' Change the colour of the Status Bar messages
            frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Red
            ' display the message in lblMessage telling the client to enter a name
            frmMainForm.staPanelMessages.Text = "Please enter the Workers Name."
            ' put the focus back to the text box for employee name
            txtEmployeeName.Focus()

            ' Determine if the text box for number of pieces is empty 
        ElseIf txtNumberOfPieces.Text = "" Then
            ' Change the colour of the Status Bar messages
            frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Red
            ' display the message in lblMessage telling the client to enter the number of pieces 
            frmMainForm.staPanelMessages.Text = "Please enter the number of pieces."
            ' put the focus back to the text box for the number of pieces 
            txtNumberOfPieces.Focus()

            ' Determine if the client entered value is not numeric
        ElseIf Not IsNumeric(txtNumberOfPieces.Text) Then
            ' Change the colour of the Status Bar messages
            frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Red
            ' display the message in lblMessage telling the client the value entered needs to be numeric
            frmMainForm.staPanelMessages.Text = "Number of pieces needs to be numeric."
            ' select the information entered by the client in the text box for number of pieces
            txtNumberOfPieces.SelectAll()
            ' put the focus back to the text box for the number of pieces 
            txtNumberOfPieces.Focus()

            ' Determine if the client entred value is a whole number
            ' When the number is a whole number it will be stored in the variable employeePieces
        ElseIf Not Int32.TryParse(txtNumberOfPieces.Text, employeePieces) Then
            ' Change the colour of the Status Bar messages
            frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Red
            ' display the message in lblMessage telling the client the number of pieces needs to be a 
            ' whole number
            frmMainForm.staPanelMessages.Text = "Number of pieces must be whole numbers."
            ' select the information entered by the client in the text box for number of pieces
            txtNumberOfPieces.SelectAll()
            ' put the focus back to the text box for the number of pieces 
            txtNumberOfPieces.Focus()

            ' Employee name has been entered and the number of pieces is a valid number
        Else

            ' Processing the client input 
            '============================

            ' store the employee name from the text box in the variable employeeName
            employeeName = txtEmployeeName.Text

            ' Attemmpt to process the PieceWork or SeniorWorkers objects
            Try

                ' Determine if the Regular worker has been selected
                If optPieceWork.Checked = True Then

                    ' create a new PieceWork object by sending employeeName and 
                    ' employeePiece to the Constructor for the PieceWork Class 
                    employeePayments = New PieceWork(employeeName, employeePieces)
                    listPieceWorker.Insert(0, employeePayments)

                    ' calculate the individual employee pay by calling the method calculatePay
                    employeePayments.calculatePay()
                    ' set the value of the current employees pay to the returned value employee pay from 
                    ' Pay property of the PeiceWork class and formats it into a string before output
                    employeePay = (FormatCurrency(employeePayments.Pay)).ToString

                    ' Determine if a Message has been set in the Event Productive
                    If isMessagePosted = True Then
                        ' A message was set in the Event

                        ' Change the colour of the Status Bar messages
                        frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
                        ' Concatenate the Message from the Event to the message showing 
                        ' that a Regular worker has been processed
                        extendMessage = frmMainForm.staPanelMessages.Text + " - Regular Worker Processed"
                        ' Display the new messaage in the Status Bar on the Parent form
                        frmMainForm.staPanelMessages.Text = extendMessage

                    Else
                        ' No message was set in the Event

                        ' Change the colour of the Status Bar messages
                        frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
                        ' Display the message in the Status Bar on the Parent Form that
                        ' a regular Worker has been processed
                        frmMainForm.staPanelMessages.Text = "Regular Worker Processed"

                    End If

                    ' Determine if a Seniors worker has been selected
                ElseIf optSeniorWorkers.Checked = True Then

                    ' create a new SeniorWorkers object by sending employeeName 
                    ' and employeePiece to the Constructor for the PieceWork Class 
                    seniorPayments = New SeniorWorkers(employeeName, employeePieces)
                    listPieceWorker.Insert(0, seniorPayments)

                    ' calculate the individual employee pay by calling the method calculatePay
                    seniorPayments.calculatePay()
                    ' set the value of the current employees pay to the returned value employee pay from from
                    ' Pay property of the PeiceWork class and formats it into a string before output
                    employeePay = (FormatCurrency(seniorPayments.Pay)).ToString

                    ' Determine if a Message has been set in the Event UnderProductive
                    If isMessagePosted = True Then
                        ' A message was set in the Event

                        ' Change the colour of the Status Bar messages
                        frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
                        ' Concatenate the Message from the Event to the message showing 
                        ' that a Senior worker has been processed
                        extendMessage = frmMainForm.staPanelMessages.Text + " - Senior Worker Processed"
                        ' Display the new messaage in the Status Bar on the Parent form
                        frmMainForm.staPanelMessages.Text = extendMessage

                    Else
                        ' No message was set in the Event

                        ' Change the colour of the Status Bar messages
                        frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
                        ' Display the message in the Status Bar on the Parent Form that
                        ' a Senior Worker has been processed
                        frmMainForm.staPanelMessages.Text = "Senior Worker Processed"

                    End If

                    ' If the form loaded without the default button selected and the client does not select
                    ' one of the options
                Else

                    ' Change the colour of the Status Bar messages
                    frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
                    ' display this message on the form for the client informing to select the
                    ' type of employee pay they want to process
                    frmMainForm.staPanelMessages.Text = "Please select the type of Worker to process."

                End If

                ' Output of an employees pay
                '===========================

                ' display the calculated pay for the current employee in the text box for employee pay
                ' format the value for employeePay as currency and convert it to a string to display 
                ' in the text box
                lblDisplayEmployeePay.Text = employeePay

                ' Exception Handling Catch Block
                '===============================

                ' Catch any exceptions that are thrown while trying to process the Piecework object 
                ' employeePayments or the SeniorWorkers object seniorPayments.
            Catch validPieceWorkEntry As ArgumentOutOfRangeException

                ' If the exception was related to the number of pieces being out of range 
                ' of the business rules.
                If validPieceWorkEntry.ParamName = "Piece Range" Then

                    ' Change the colour of the Status Bar messages
                    frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Red
                    ' Dislay the Exception message in the form
                    frmMainForm.staPanelMessages.Text = validPieceWorkEntry.Message
                    ' Set the focus back to the input text box for the  number of pieces
                    txtNumberOfPieces.Focus()
                    ' Select everything that is currently in the text box
                    txtNumberOfPieces.SelectAll()

                End If

                ' If the exception was realted to the name not being the correct format
                ' according to the business rules.
                If validPieceWorkEntry.ParamName = "Improper Name" Then

                    ' Change the colour of the Status Bar messages
                    frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Red
                    ' Display the Exception message in the form
                    frmMainForm.staPanelMessages.Text = validPieceWorkEntry.Message
                    ' Set the focus back to the input text box for the  number of pieces
                    txtEmployeeName.Focus()
                    ' Select everything that is currently in the text box
                    txtEmployeeName.SelectAll()

                End If

            End Try

        End If

        ' Set isMessagePosted to false before processing the next Worker
        isMessagePosted = False

    End Sub

    '===========================================================
    ' Event Handler - Clear Button
    '===========================================================
    Private Sub btnClear_Click(sender As Object, e As EventArgs) _
        Handles btnClear.Click
        ' Clears the information on the current form 

        'Set the worker type check box to Regular Worker
        optPieceWork.Checked = True
        ' Clear the values entered in the text box for employee name
        txtEmployeeName.Text = String.Empty
        ' Clear the values entered in the text box for number of pieces
        txtNumberOfPieces.Text = String.Empty
        ' Change the colour of the Status Bar messages
        frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
        ' Update the Status Bar message for the Input Piece Work form
        frmMainForm.staPanelMessages.Text = "Enter an Workers Information."
        ' Clear the label containing the calculated value of an employees pay
        lblDisplayEmployeePay.Text = String.Empty
        ' Place the focus of the form back to the text box for employee name
        txtEmployeeName.Focus()

    End Sub

#End Region

End Class