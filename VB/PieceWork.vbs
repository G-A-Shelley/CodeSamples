Option Strict On

'**************************************************************************
' Name      : Gavin Shelley
' Course    : VISB 6201
' Program   : PieceWork.vb
' Date      : Feb 11 2015
' Updated   : Mar 3 2015 for Lab 3A 
'           : Mar 17 2015 for Lab 3B
'           : Apr 13 2015 for Lab 5
'
' Description
'
' This is the file containing the PieceWork class
'
'   The PieceWork class is designed to input an employees name and the number
' of pieces they have prodcued for a company and calculate the employees pay.
' The more pieces the employee produces the higher the pay they will receive
' per piece. The PieceWork class will also track the total number pieces 
' processed, total pay calculated for all employees, the average pay based 
' on the number of employees processed and the total number of employees 
' processed.
'
' Contents
' ============================
'   Event
'       -Productive
'   Variable Declarations
'       -instance variables
'       -shared variables
'   Constructors
'       -Default
'       -Parameratized
'   Methods
'       -calculatePay
'       -ToString
'       -clearPieceWork
'       -removeWorker
'   Procedures
'       -name
'       -pieces
'       -employeePay
'       -showTotalPieces
'       -showTotalPay
'       -showAveragePay
'       -showEmployeesProcessed
'
' Changed Mar 17 2015
' ===================
'   Changes made for Lab 3 Requirements
'   - Added the Event Productive
'   - Added the RaiseEvent to the calculatePay method that is set for when the employee
'       pay is below the minimum acceptable pay for a Regular Worker
'   - Added validation to the Name set property. The property now determines if both a 
'       full first and full last name have been entered with no periods. It also determines
'       if the each name is a minimum of two letters long. If the name does not pass 
'       validation the property throws an ArgumentOutOfRangeException.
'   - Added validation to Pieces set determine if the number of pieces that has been 
'       entered is within the business rules for the range of pieces an employee can 
'       produce. If the number is not in the range the property will throw an
'       ArgumentOutOfRangeException
'
' Changed Apr 13 2015
' ===================
'   Changes made for Lab 5
'   - Added the ToString override method to display PieceWork information
'   - Added the clearPieceWork method to reset the Class variable values
'       to zero to process a new group of workers
'   - Added the removeWorker method to remove the information of a worker
'       from the Class variable values
'
'**************************************************************************

Public Class PieceWork

#Region "Class Events"

    '===========================================================
    ' Event - Productive
    '===========================================================
    Friend Event Productive(ByVal employeeProduction As PieceWork)
    ' This event is used to notify the client when the regular worker is  
    ' earning more than the high pay level set in the business rules

#End Region

#Region "Class Variables - Instance and Shared"

    '===========================================================
    ' VARIABLE DECLARATIONS
    '===========================================================

    ' Instance Variables
    Protected Friend employeeName As String         ' name of the employee being processed
    Protected Friend numberOfPieces As Integer      ' number of work pieces completed by employeeName
    Protected Friend employeePay As Double          ' the calculated pay for an individual employee

    ' Shared Variables
    Protected Shared employeesProcessed As Integer  ' the total number of employees processed
    Protected Shared totalPieces As Integer         ' the total number of work pieces completed by all employees processed
    Protected Shared totalPay As Double             ' the total of the pay for all employees processed
    Protected Shared averagePay As Double           ' the average employee pay based on the number of employee processed

#End Region

#Region "Constructors"

    '===========================================================
    ' CONSTRUCTORS
    '===========================================================

    ' Parameratized Constructor
    Friend Sub New(ByVal nameValue As String, ByVal piecesValue As Integer)
        ' Creates a new PieceWork object with values passed for nameValue and piecesValue

        ' Sets the value for employeeName
        Me.Name = nameValue
        ' Sets the value for numberOfPieces
        Me.Pieces = piecesValue

        ' Removed for Lab 3A
        '===================
        ' Calls the function to process the pay based on numberOfPieces
        'calculatePay()

    End Sub

    ' Default Constructor
    Friend Sub New()

    End Sub

#End Region

#Region "Class Methods"

    '===========================================================
    ' METHOD - clearPieceWork   
    '===========================================================
    Protected Friend Shared Sub clearPieceWork()
        ' This method when called will reset the values of the 
        ' class variables back to zero.

        ' Sets the number of employees processed to zero 
        employeesProcessed = 0
        ' Sets the number of pieces processed to zero
        totalPieces = 0
        ' Sets the total calculated pay to zero
        totalPay = 0
        ' Sets the calculated average pay for all workers processed to zero
        averagePay = 0

    End Sub

    '===========================================================
    ' METHOD - removeWorker 
    '===========================================================
    Protected Friend Sub removeWorker()
        ' this method wehn called will remove a workers information
        ' from all of the Class varaible values

        ' Remove the individual workers pay from the total calculated
        ' pay from the the PieceWork class variable
        totalPay -= Me.Pay
        ' Remove the individual workers pieces from the total number
        ' of pieces from the the PieceWork class variable
        totalPieces -= Me.Pieces
        ' Reduce the number of employees processed from the PieceWork
        ' class variables by 1
        employeesProcessed -= 1
        ' Recalculate the average pay for the PieceWork class variable
        ' storing the average pay for all workers processed
        averagePay = CDbl(totalPay / employeesProcessed)

    End Sub

    '===========================================================
    ' METHOD - calculatePay    
    '===========================================================
    Protected Friend Overridable Sub calculatePay()
        ' Calculate the employees pay based on the number of pieces
        ' the employee has produced

        ' VARIABLE DECLARATIONS
        '======================
        Const HIGH_PAY_LIMIT As Double = 650D       ' The high pay limit for a PieceWork worker

        Dim isPayScale As Boolean = True            ' Boolean condition for the loop to determine the pay scale 
        Dim scaleIndex As Integer = 0               ' Index used for accessing elements of the array for the pay scale
        Dim payLimit As Integer = 0                 ' The index of the pay scale for the low limit of the pay range
        Dim payPerUnit As Integer = 1               ' The index of the pay scale for the pay rate for the selected pay range

        employeePay = 0                             ' sets employeePay to zero to before processing the current employee 

        ' Array to hold the pay scale lower limits and the pay value associated with that scale
        Dim arrayPayScale(,) As Double = New Double(,) _
            {{600, 0.65}, {400, 0.6}, {200, 0.55}, {1, 0.5}}

        ' PAY RANGES
        ' Number of Pieces= Rate of Pay per piece
        ' 1     to  199 pieces  =   $0.50
        ' 200   to  399 pieces  =   $0.55
        ' 400   to  599 pieces  =   $0.60
        ' 600 and above         =   $0.65

        ' PROCESSING       
        '======================================

        ' Determine employee pay range based on 
        ' number of pieces the have produced 

        ' Loop to determine the employees pay
        While (isPayScale = True)
            ' Determine if all values of the array have been checked already
            ' Process the numberOfPieces when it is still in range
            If (scaleIndex <= arrayPayScale.GetUpperBound(0)) Then
                ' Determine if numberOfPieces is in the current pay range

                If (numberOfPieces >= arrayPayScale(scaleIndex, payLimit)) Then
                    ' Calculate the employees pay using the values from the array mulitplied by the number of pieces
                    employeePay = CDbl(arrayPayScale(scaleIndex, payPerUnit) * numberOfPieces)
                    ' Change the value of isPayScale to false to end the loop
                    isPayScale = False
                End If 'End of determining the pay range

            Else ' All Elemnts of the array have been processed
                ' Change the value of isPayScale to false to end the loop 
                isPayScale = False
            End If ' End of determining if the entire array has been looped through

            ' Increment the index for arrayPayScale to check the next pay range 
            scaleIndex = scaleIndex + 1
        End While ' End of the loop to determine the pay range for the current employee

        ' Calculate cumulative employee information based on the number
        ' of employees being processed. 

        ' Calculate the total pay for all employees 
        totalPay += employeePay
        ' Calculate the total number of pieces produced by all employees
        totalPieces += numberOfPieces
        ' Calculate the total number of employees that have been processed
        employeesProcessed += 1
        ' Calculate the average pay for employees that have been processed
        averagePay = CDbl(totalPay / employeesProcessed)

        ' Determine if the employees pay is above the high pay level set
        ' in HIGH_PAY_LIMIT according to the business rules
        If employeePay >= HIGH_PAY_LIMIT Then

            ' The employee has earned more than the high pay level
            ' Raise the Event Productive
            RaiseEvent Productive(Me)

        End If

    End Sub

    '===========================================================
    ' METHOD - ToString   
    '===========================================================
    Public Overrides Function ToString() As String
        ' Overrides the ToString method to display the information
        ' in a PieceWork object in a formatted string

        ' Holds the formatted string conatining the PieceWork information
        Dim showWorker As String

        ' Build the concatenated string with PieceWork information containing the PieceWork Name,
        ' PieceWork pieces and the PieceWork pay formatted for currency.
        showWorker = Me.Name + " - " + Me.Pieces.ToString + " pieces - " + (FormatCurrency(Me.Pay))

        ' Return the string showWorker
        Return showWorker

    End Function


#End Region

#Region "Instance Property Procedures"

    '===========================================================
    ' Employee Name - get and set properties
    '===========================================================
    Public Property Name() As String

        ' Return the value of employee name to the client
        Get
            Return employeeName
        End Get

        ' Set the value of employeeName to a client input value
        Set(setEmployeeName As String)

            ' CONSTANT & VARIABLE DECLARATIONS
            '=================================
            ' Constants
            Const MINIMUM_LENGTH_OF_NAME As Integer = 5 ' The minimum required length of a name including spaces
            Const MINIMUM_INDIVIDUAL_NAME = 2           ' The minimum length of a first name or last name
            Const REQUIRED_SPACES = 1                   ' The number of spaces needed for a valid name

            ' Variables
            Dim isName As Boolean = False               ' value used to determine if the input name is properly formatted full name
            Dim containsSpace As Boolean = False        ' value used to verify if the name has a space between the first and last name
            Dim containsNumbers As Boolean = False      ' value used to verify if the name contains any numbers
            Dim containsPeriod As Boolean = False       ' value used to verify if the name contains any periods

            Dim spaceCount As Integer = 0               ' counts the number of spaces in the name
            Dim spaceIndex As Integer = 0               ' stores the index of the space in the setEmployeeName

            ' PROCESSING       
            '======================================

            ' Loop through all of the characters in setEmployeeName
            For Each letter As Char In setEmployeeName

                ' Determine if the current character is a space
                If letter = " " Then
                    ' current character is a space

                    ' change containsSpace to true to indicate there is a space in the name
                    containsSpace = True
                    ' increment the count of space characters by 1
                    spaceCount = spaceCount + 1
                    ' store the index of the character space 
                    spaceIndex = setEmployeeName.IndexOf(letter)

                    ' Determine if the current character is a period
                ElseIf letter = "." Then
                    ' current character is a period

                    ' change containsPeriod to true to indicate there is a period in the name
                    containsPeriod = True

                    ' Determine if the current character is a number
                ElseIf Integer.TryParse(letter, Nothing) Then
                    ' current character is a number

                    'change containNumber to true to indicate there is a numeric value in the name
                    containsNumbers = True

                End If

            Next

            ' Determine if a number was found in the name
            If containsNumbers = False Then
                ' Determine if a period was found in the name
                If containsPeriod = False Then
                    ' Determine if a space was found in the name
                    If containsSpace = True Then
                        ' Determine if the correct number of spaces where found in the name
                        If spaceCount = REQUIRED_SPACES Then
                            ' Determine if the name is the the minimum required length or longer
                            If setEmployeeName.Length >= MINIMUM_LENGTH_OF_NAME Then
                                ' Determine if the first name is the minimum length or longer
                                If spaceIndex >= MINIMUM_INDIVIDUAL_NAME Then
                                    ' Determine if the last name is the minimum length or longer
                                    If setEmployeeName.Length - (spaceIndex + 1) >= MINIMUM_INDIVIDUAL_NAME Then

                                        ' When all conditions are met for for a vaild employee name
                                        ' Change isName to true to indicate the name is valid
                                        isName = True

                                    End If
                                End If
                            End If
                        End If
                    End If
                End If
            End If

            ' Determine if the name has been validated
            If isName = True Then

                ' The name is valid, set the value of 
                ' employeeName to setEmployeeName
                Me.employeeName = setEmployeeName

            Else

                ' The name was not validates
                ' Throw the Argument out of range exception
                Throw New ArgumentOutOfRangeException("Improper Name", _
                    setEmployeeName + " is not a valid Name")

            End If

        End Set

    End Property

    '===========================================================
    ' Number of Pieces - get and set properties
    '===========================================================
    Public Property Pieces() As Integer

        ' Return the value to numberOfPieces to the client
        Get
            Return numberOfPieces
        End Get

        ' Set the value of numberOfPieces to a client input value
        Set(setNumberOfPieces As Integer)

            ' CONSTANT & VARIABLE DECLARATIONS
            '=================================
            ' Constants
            Const MINIMUM_PIECES As Integer = 1     ' the minimum number of pieces an employee can be paid for
            Const MAXIMUM_PIECES As Integer = 1200  ' the maximum number of pieces an employee can be paid for

            ' PROCESSING       
            '======================================

            ' Determine if setNumberOfPieces is in the correct range for the 
            ' number of pieces a worker can produce
            If setNumberOfPieces <= CDbl(MAXIMUM_PIECES) And setNumberOfPieces >= CDbl(MINIMUM_PIECES) Then

                ' The number of pieces is in the correct range
                ' set numberOfPieces to the passed value of setNumberOfPieces
                Me.numberOfPieces = setNumberOfPieces

            Else
                ' the number of pieces is out of the range of pieces
                ' Throw the Argument out of range exception
                Throw New ArgumentOutOfRangeException("Piece Range", _
                    "Number of pieces must be between " + CStr(MINIMUM_PIECES) + _
                    " and " + CStr(MAXIMUM_PIECES) + " inclusive.")

            End If

        End Set

    End Property

    '===========================================================
    ' Employee Pay - get and set properties
    '===========================================================
    Protected Friend ReadOnly Property Pay() As Double
        ' Return the value of an employees pay to the client
        Get
            Return employeePay
        End Get

    End Property

#End Region

#Region "Class Property Procedures"

    '===========================================================
    ' Display the total pay for all employees processed
    '===========================================================
    Protected Friend Shared ReadOnly Property ShowTotalPay() As Double
        ' Return the value to totalPay to the client
        ' value is set in calculatePay()
        Get
            Return totalPay
        End Get
    End Property

    '===========================================================
    ' Display the total of all work pieces completed
    '===========================================================
    Protected Friend Shared ReadOnly Property ShowTotalPieces() As Integer
        ' Return the value to totalPieces to the client
        ' value is set in calculatePay()
        Get
            Return totalPieces
        End Get
    End Property

    '===========================================================
    ' Display the average pay for all of the employees processed
    '===========================================================
    Protected Friend Shared ReadOnly Property ShowAveragePay() As Double
        ' Return the value to averagePay to the client
        ' value is set in calculatePay()
        Get
            Return averagePay
        End Get
    End Property

    '===========================================================
    ' Display the total number of all employees processed
    '===========================================================
    Protected Friend Shared ReadOnly Property ShowEmployeesProcessed() As Integer
        ' Return the value to employeesProcessed to the client
        ' value is set in calculatePay()
        Get
            Return employeesProcessed
        End Get
    End Property

#End Region

End Class
