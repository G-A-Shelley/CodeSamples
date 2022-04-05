Option Strict On

'**************************************************************************
' Name      : Gavin Shelley
' Course    : VISB 6201
' Program   : Lab 02 DisplaySummary 
' Date      : Feb 16 2015
' Updated   : Apr 13 2015
'
' Description
'
'   This form will display the shared information from the PieceWork object
' for total pieces, total pay and average pay for the employees that have
' been processed. The client can then press the Exit button on the Tool Bar
' or select the Close option from the Menus to close the current instance 
' of the form
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
'   - Added the Method to display the summary information in the form
'
'**************************************************************************

Public Class frmDisplaySummary

#Region "Declarations"

    '===========================================================
    '  VARIABLE DECLARATIONS
    '===========================================================
    Private Shared displaySummaryInstance As frmDisplaySummary ' declares an object of the Form Display Summary

#End Region

#Region "Properties"

    '===========================================================
    ' Property - Instance
    '===========================================================
    Friend Shared ReadOnly Property Instance() As frmDisplaySummary
        ' A property procedure that will allow the calling class 
        ' to display an instance of the form DisplaySummary. The 
        ' instance will only be displayed if there is not an existing
        ' instance being displayed.
        Get

            ' Determine if there is an existing instance of 
            ' the form DisplaySummary
            If displaySummaryInstance Is Nothing Then
                ' No instance exists

                ' create a new Instance of of the form DisplaySummary
                displaySummaryInstance = New frmDisplaySummary

            End If

            ' Return the value of DisplaySummary
            Return displaySummaryInstance

        End Get

    End Property

#End Region

#Region "Form Events"

    '===========================================================
    ' Form Load Event Handler
    '===========================================================
    Private Sub frmDisplaySummary_Load(sender As Object, e As EventArgs) _
        Handles MyBase.Load
        ' Loads the shared information for total pay, total pieces and average pay from the
        ' PieceWork object when the form loads and displays in the form for the lcient to view 

        ' Call the Method to Update the Information in the Form
        Me.DisplaySummaryInformation()

    End Sub

    '===========================================================
    ' Event Handler - Form Activated
    '===========================================================
    Private Sub frmDisplaySummary_Activated(sender As Object, e As EventArgs) _
        Handles MyBase.Activated
        ' Handles the events when the form DisplaySummary takes focus 

        ' Determine if any PieceWork objects have been processed
        If (PieceWork.ShowTotalPieces <= 0) Then
            ' No PieceWork objects have been processed

            ' Close the current instance of the form
            frmMainForm.tlbBtnClose.PerformClick()
            ' Update the Status Bar message on the PArent form telling the client
            ' There is no information to display and the form has been closed
            frmMainForm.staPanelMessages.Text = "No summary information available Production Summary Form Closed"

        Else
            ' At least one PieceWork object has been processed

            ' Call the Method to Update the Information in the Form
            Me.DisplaySummaryInformation()
            ' Change the colour of the Status Bar message text
            frmMainForm.staPanelMessages.ForeColor = Drawing.Color.Black
            ' Update the name of the Current form in the Status Bar
            frmMainForm.staPanelCurrentForm.Text = "Production Summary"
            ' Update the message in the Status Bar for the Display Summary form
            frmMainForm.staPanelMessages.Text = "View information based on the employee information that has been entered."

        End If

    End Sub

    '===========================================================
    ' Event Handler - Form Closing
    '===========================================================
    Private Sub frmDisplaySummary_FormClosing(sender As Object, e As Windows.Forms.FormClosingEventArgs) _
        Handles Me.FormClosing
        ' Release the Instance of the form DisplaySummary when the form is closed

        ' Release the Instance of this form by
        ' Setting DisplaySummary to Nothing
        displaySummaryInstance = Nothing

    End Sub

#End Region

#Region "Client Click Events"

    '===========================================================
    ' Close Button Event Handler
    '===========================================================
    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click

        ' Closes the Display Summary form
        Me.Close()

    End Sub

#End Region

#Region "Form Methods"

    '===========================================================
    ' Method - Display Summary Information
    '===========================================================
    Private Sub DisplaySummaryInformation()

        ' Variable Declarations and Initialization
        '=========================================

        ' holds the formatted string with the value of the shared total pieces processed for PieceWork
        Dim showPieces As String = PieceWork.ShowTotalPieces.ToString
        ' holds the currency formatted string with the value of the shared total pay processed for PieceWork
        Dim showPay As String = FormatCurrency(PieceWork.ShowTotalPay).ToString
        ' holds the currency formatted string with the value of the shared average pay processed for PieceWork
        Dim showAverage As String = FormatCurrency(PieceWork.ShowAveragePay).ToString

        ' Output of PieceWork Shared information
        '=======================================

        ' Display the total number of pieces that have been processed by employees 
        lblShowPieces.Text = showPieces
        ' Display the total pay for all employees that have been processed 
        lblShowPay.Text = showPay
        ' Display the average pay per employee based on the number of employees processed 
        lblShowAverage.Text = showAverage

    End Sub

#End Region

   
End Class