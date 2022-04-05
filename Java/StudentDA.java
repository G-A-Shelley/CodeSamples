package shelleyg;

import java.sql.Connection;
import java.util.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Vector;

/***
 * Student Data Access Class
 * @author Gavin
 * @version 1.0
 * February 27 2016
 * Provides the connection to a Data sources and the Methods used
 * to query the required information from it.
 */
public class StudentDA {
	
	// Class Variables
	//============================================
	/*** Class Student to hold student information */
	static Student aStudent;	
	/*** Class connection for the Student Database */
	static Connection aConnection;
	/*** Class statement for initial Database Queries */
	static Statement aStatement;
	/*** Class statement for secondary Database Queries */
	static Statement bStatement;
	/*** Class Vector to hold all Students information*/
	static Vector<Student> aStudents = new Vector<Student>();
	/*** Class Vector to hold all of a Students Marks */
	static Vector<Marks> aMarks = new Vector<Marks>();
	/*** Class Mark to hold a single Course Mark */
	static Marks aMark;
	/*** Class Transcript to hold a formatted Student Transcript */
	static String atranscript;
	/*** Class String to hold a Students Course Code */
	static String aCourseCode;
	/*** Class String to hold a Students Course Title */
	static String aCourseTitle;
	/*** Class Integer to hold a Students Course GPA weighting */
	static int aWeighting;
	/*** Class Integer to hold a Students Course Grade */
	static int aGrade;
	/*** Class Integer to hold a Students ID number */
	static int aStudentId;
	/*** Class Double to hold a Students cumulative GPA */
	static double aGPA;
	/*** Class Double to hold a Students Course GPA */
	static double bGPA;
	/*** Class Formatter to format the output of a Students GPA */
	static DecimalFormat gpaFormat = new DecimalFormat("0.00");
	/*** Class Date Formatter  */
	static final SimpleDateFormat SQL_DATE = new SimpleDateFormat("YYYY-MM-dd");

	// Student Object Attributes
	//============================================
	/*** Student object Student Number */
	static int studentNumber;
	/*** Student object password */
	static String password;
	/*** Student object First Name */
	static String firstName;
	/*** Student object Last Name */
	static String lastName;
	/*** Student object Birth Date */
	static Date birthDate;
	/*** Student object Email address */
	static String emailAddress;
	/*** Student object Phone Number */
	static String phoneNumber;
	/*** Student object Vector of Students grades */
	static Vector studentGrades = new Vector();
	

	/***
	 * Initialize a Connection
	 * @author Gavin
	 * February 24 2016
	 * @version 1.0
	 * Establish a connection to the Data source
	 * @return
	 */
	public static void initialize(Connection c)	{
		try {
			aConnection=c;
			aStatement=aConnection.createStatement();
			bStatement=aConnection.createStatement();
		}
		catch (SQLException e) { 
			System.out.println(e);}
	}

	/***
	 * Terminate a Connection
	 * @author Gavin
	 * February 24 2016
	 * @version 1.0
	 * Terminates the connection to the Data source
	 */
	public static void terminate()	{
		try	{ 	// close the statement
    		aStatement.close();	}
		catch (SQLException e){ 
			System.out.println(e);	}
	}
	
	/***
	 * Verify a Students Login Information
	 * @author Gavin
	 * February 24 2016
	 * @version 1.0
	 * @param myStudentNumber
	 * @param myPassword
	 * @return
	 * @throws StudentNotFoundException
	 * Determines if a Students Login information matches the information
	 * containing in the Data source by Locating the passed Student ID and
	 * Password. If the information is not found a StudentNotFoundException
	 * will be thrown.
	 */
	public static Student login(int myStudentNumber, String myPassword) throws StudentNotFoundException {				
		aStudent = null;				
		String sqlQuery = "SELECT * FROM students WHERE studentnumber = '" 
							+ myStudentNumber +"' AND password = '" + myPassword + "'";		
		try {
	    	ResultSet rs = aStatement.executeQuery(sqlQuery);			
			boolean gotIt = rs.next();
	    	if (gotIt) {	
					studentNumber = rs.getInt("studentnumber");
					password = rs.getString("password");
					firstName = rs.getString("firstname");
					lastName = rs.getString("lastname");
					birthDate = rs.getDate("birthdate");
					emailAddress = rs.getString("emailaddress");
					phoneNumber = rs.getString("phonenumber");					
					aStudent = new Student(studentNumber, password, firstName, lastName,birthDate, emailAddress, phoneNumber);					
			}
			else {
				throw (new StudentNotFoundException("User ID and/or Password are not Valid."));
			}
			rs.close();
	   	}
		catch (SQLException e)
		{ System.out.println("Login information is not correct.");}		
		return aStudent;
	}

	/***
	 * Finds a Students information
	 * @author Gavin
	 * February 24 2016
	 * @version 1.0
	 * @param myStudentNumber
	 * @return
	 * @throws StudentNotFoundException
	 * Finds a students information from the Data source by using the passed
	 * value of the Students ID number. When the information is not found
	 * in the Data source a StudentNotFoundException is thrown.
	 */
	public static Student find(int myStudentNumber) throws StudentNotFoundException{
		aStudent = null;				
		String sqlQuery = "SELECT * FROM students WHERE studentnumber = '" 
							+ myStudentNumber + "'";		
		try {
			ResultSet rs = aStatement.executeQuery(sqlQuery);			
			boolean gotIt = rs.next();
			if (gotIt) {	
				studentNumber = rs.getInt("studentnumber");
				password = rs.getString("password");
				firstName = rs.getString("firstname");
				lastName = rs.getString("lastname");
				birthDate = rs.getDate("birthdate");
				emailAddress = rs.getString("emailaddress");
				phoneNumber = rs.getString("phonenumber");					
				aStudent = new Student(studentNumber, password, firstName, lastName,birthDate, emailAddress, phoneNumber);					
			}
			else {
				throw (new StudentNotFoundException("Student ID does not Exist."));
			}
			rs.close();
		}
		catch (SQLException e) { 
			System.out.println("Student ID is not on file.");
		}		
		return aStudent;
	}
		
	/***
	 * Get All Student information
	 * @author Gavin
	 * February 24 2016
	 * @version 1.0
	 * @return
	 * Get all of the Student information from the Data source and 
	 * return it to the calling method in the form of a Student Vector.
	 */
	public static Vector<Student> getAllStudents() {
		System.out.println("check get all");
		String sqlQuery = "SELECT * FROM students";	
		try {
			ResultSet rs = aStatement.executeQuery(sqlQuery);	
			boolean moreData = rs.next();
			while (moreData) {
				studentNumber = rs.getInt("studentnumber");
				password = rs.getString("password");
				firstName = rs.getString("firstname");
				lastName = rs.getString("lastname");
				birthDate = rs.getDate("birthdate");
				emailAddress = rs.getString("emailaddress");
				phoneNumber = rs.getString("phonenumber");					
				aStudent = new Student(studentNumber, password, firstName, lastName,birthDate, emailAddress, phoneNumber);
				aStudents.add(aStudent);
				System.out.println("check loop");	
				moreData = rs.next();
			}
			rs.close();
		}
		catch (SQLException e) { 
			System.out.println("No Student are on file.");
		}		
		return aStudents;
	}
		
	/***
	 * Delete a Student
	 * @author Gavin
	 * February 24 2016
	 * @version 1.0
	 * @param aStudent
	 * Delete all of a Students Information from the Data source
	 */
	public static void delete(Student aStudent){	
		studentNumber = aStudent.getStudentNumber();
		String sqlDelete = "DELETE FROM students " +
                "WHERE studentnumber = '" + studentNumber +"'";
		try	{ 
			int result = aStatement.executeUpdate(sqlDelete);			   
		}
		catch (SQLException e)	{		
			System.out.println("Student Record cannot be Deleted.");	
		}
	}	
	
	/***
	 * Update a Student
	 * @author Gavin
	 * February 24 2016
	 * @version 1.0
	 * @param aStudent
	 * @throws StudentNotFoundException
	 * Update all of a Students Information from the Data source. If the
	 * passed Student ID number is not found in the Data source a
	 * StudentNotFoundException is thrown.
	 */
	public static void update(Student aStudent) throws StudentNotFoundException{
		studentNumber = aStudent.getStudentNumber();
		password = aStudent.getPassword();
		firstName = aStudent.getFirstName();
		lastName = aStudent.getLastName();
		birthDate = aStudent.getBirthDate();
		emailAddress = aStudent.getEmailAddress();
		phoneNumber = aStudent.getPhoneNumber();
		
		
		String sqlUpdate = "UPDATE students SET " + 
							"studentnumber = '" 		+ studentNumber 	+ "', " + 
							"password = '" 	 			+ password 			+ "', " + 
							"firstname = '" 			+ firstName 		+ "', " + 
							"lastname = '" 				+ lastName 			+ "', " + 							
							"birthDate = '" 			+ SQL_DATE.format(birthDate) 			+ "', " + 							
							"emailaddress = '" 			+ emailAddress 		+ "', " + 
							"phonenumber = '" 			+ phoneNumber 		+ "' " 	+ 
							"WHERE studentnumber = '"	+ studentNumber 	+ "'"; 
		System.out.println(sqlUpdate);
		try	{ 
			int result = aStatement.executeUpdate(sqlUpdate);			   
		}
		catch (SQLException e)	{		
			System.out.println("Cannot update this Student.");	
		}
	}
	
	/***
	 * Insert a Student
	 * @author Gavin
	 * February 24 2016
	 * @version 1.0
	 * @param aStudent
	 * @throws StudentNotFoundException
	 * Update all of a Students Information from the Data source. If the
	 * passed Student ID number is not found in the Data source a
	 * StudentNotFoundException is thrown.
	 */
	public static void insert(Student aStudent) throws DuplicateStudentException{	
		studentNumber = aStudent.getStudentNumber();
		password = aStudent.getPassword();
		firstName = aStudent.getFirstName();
		lastName = aStudent.getLastName();
		birthDate = aStudent.getBirthDate();
		emailAddress = aStudent.getEmailAddress();
		phoneNumber = aStudent.getPhoneNumber();
		
		
		String sqlInsert = "INSERT INTO students (studentnumber, password, birthDate, firstname, lastname, emailaddress, phonenumber) VALUES ('" +
							studentNumber +"', '" +  password + "', '" + birthDate + "', '" + firstName + "', '"+ lastName +"', '" +
							emailAddress  +"', '" + phoneNumber + "')";
		try	{ 
			int result = aStatement.executeUpdate(sqlInsert);			   
		}
		catch (SQLException e)	{		
			System.out.println("Student ID Already Exists.");	
		}
	}
	
	/***
	 * Is Existing Student
	 * @author Gavin
	 * February 24 2016
	 * @version 1.0
	 * @param id
	 * @return
	 * Determines if a Student exists in a Data source by checking 
	 * the passed Student ID number. A Boolean value is returned 
	 * true or false based on the existence of the Student in it.
	 */
	public static boolean isExistingLogin(int id)
	{ 
		String sqlQuery = "SELECT * FROM students WHERE studentnumber= '" + id +"'";			
		boolean exists = false;                  
		try	{
			ResultSet rs = aStatement.executeQuery(sqlQuery);
			exists = rs.next();
		}
		catch (SQLException e){ 
			System.out.println(e);
		}
		return exists;
	}
	
	
	/***
	 * getHTMLTranscript
	 * March 09 2016
	 * @version 1.0
	 * @param id
	 * @return
	 * Returns a formatted string containing anEntire Students Grades and GPAs
	 * in a format to display on an HTML web page. If the student has no marks 
	 * a message is returned notifying there are no marks
	 */
	public static String getHTMLTranscript(int id){		
		Vector<Marks> myMarks = new Vector<Marks>();
		myMarks = getTranscript(id);
		
		// Processing GPA
		try {
			aStudent = StudentDA.find(id);
		} catch (StudentNotFoundException e) {
			
			e.printStackTrace();
		}
		aGPA = aStudent.calculateGPA();
		
		atranscript = "<h2>Student Transcript</h2>\n";
		//System.out.println("getHTMLTranscript : " + id);
		if( myMarks.size() > 0){
			atranscript 	+= 	"<table class=\"transcript\" cellspacing=\"0\" cellpadding=\"0\">\n" 
							+	"<tr><th class=\"gpa\"><h3>Course Code</h3></th><th class=\"gpa\"><h3>Course Title</h3></th>"
							+	"<th class=\"gpa\"><h3>Course Grade</h3></th><th class=\"gpa\"><h3>GPA Weighting</h3></th></tr>";	
			for(int i = 0; i <= (myMarks.size()-1) ; i++){					
				aCourseCode = myMarks.get(i).getCourseCode();
				aCourseTitle = myMarks.get(i).getCourseTitle();
				aGrade = myMarks.get(i).getCourseMark();
				aWeighting = (int) myMarks.get(i).getGpaWeight();
				atranscript += 	"<tr><td>" + aCourseCode + "</td><td>" + aCourseTitle + "</td><td>" 
							+ aGrade + "</td><td>" + aWeighting + "</td></tr>\n";
			}	
			atranscript += "<tr><td class=\"gpa\"><h3>GPA</h3></td><td colspan=\"3\" class=\"gpa\"><h3>"+ gpaFormat.format(aGPA) +"</h3></td></tr></table><br/><br/>";
		} else {
			atranscript += "<p>Current Student has no Transcript Information</p>";
		}		
		return atranscript;
	}
		
	
	/***
	 * getTranscript
	 * March 09 2016
	 * @version 1.0
	 * @param id
	 * @return
	 * Returns a Vector of a Students Marks that contains a Student Course information,
	 * title, description, grades and gpa. Returns and empty vector when a Student does
	 * not have grades.
	 */
	public static Vector<Marks> getTranscript(int id){
		aMarks.clear();
		String sqlQueryMarks = "SELECT * FROM marks WHERE studentnumber= '" + id +"'"; 
		//System.out.println(sqlQueryMarks);
		try	{
			ResultSet rsMarks = aStatement.executeQuery(sqlQueryMarks);
			boolean moreData = rsMarks.next();
			while (moreData) {
				aCourseCode = rsMarks.getString("coursecode");
				aGrade = rsMarks.getInt("result");
				//System.out.println("course code	:" + aCourseCode);
				//System.out.println("course grade	:" + aGrade);	
				String sqlQueryCourses = 	"SELECT * FROM courses WHERE coursecode='" + aCourseCode +"'"; 
				//System.out.println(sqlQueryCourses +"\n==============================");
				try {
					ResultSet rsCourses = bStatement.executeQuery(sqlQueryCourses);
					boolean exists = rsCourses.next();
					if(exists){
					aCourseTitle = rsCourses.getString("coursetitle");
					aWeighting = rsCourses.getInt("gpaweighting");
					//System.out.println("course title" + aCourseTitle);
					//System.out.println("course weight" + aWeighting);	
					}
					rsCourses.close();
				}
				catch (SQLException e){ 
					System.out.println(e);
				}	
				catch (NullPointerException npe){
					System.out.println(npe + "Courses Query");
				}	
				aMark = new Marks(aCourseCode, aCourseTitle, aWeighting, aGrade);					
                aMarks.add(aMark);				
				moreData = rsMarks.next();
			}	
			rsMarks.close();			
		}
		catch (SQLException e){ 
			System.out.println(e);
		}	
		catch (NullPointerException npe){
			System.out.println(npe + "Marks Query");
		}		
		return aMarks;	
	}	
	
	/***
	 * calculateGPA
	 * March 09 2016
	 * @version 1.0
	 * @param aStudent
	 * @return
	 * Calculates a students GPA for their entire transcript and 
	 * returns the final calculated value.
	 */
	public static double calculateGPA(Student aStudent) {
		aMarks.clear();
		aMarks = getTranscript(aStudent.getStudentNumber());
		double totalWeight = 0;
		double totalMarks = 0;
		aGPA=0;		
		if( aMarks.size() > 0){
			for(int i = 0; i <= (aMarks.size()-1) ; i++){	
				aGrade = aMarks.get(i).getCourseMark();
				aWeighting = (int) aMarks.get(i).getGpaWeight();				
				totalWeight+=aWeighting;
				totalMarks+=(convertGPA(aGrade)*aWeighting);	
				System.out.println("W Grades : " + aGrade + "   Weight : " + aWeighting);
			}
			aGPA=(totalMarks/totalWeight);			
		}
		else {
			aGPA = 0;
		}
		
		return (aGPA);		
	}
	
	/***
	 * convertGPA
	 * MArch 9 2016
	 * @version 1.0
	 * @param gpavalue
	 * @return
	 * Converts a Students Course Grade to a GPA and returns
	 * the GPA value
	 */
	private static double convertGPA(double gpavalue){
		if (gpavalue >=50) {
			bGPA = 1.0 + ((int)(gpavalue-50)/5)* 0.5;
			bGPA = (bGPA>5.0)? 5 : bGPA;
		} else {
			bGPA = 0;
		}
		//System.out.println("GPA " + bGPA );
		return bGPA;	
	}
}
