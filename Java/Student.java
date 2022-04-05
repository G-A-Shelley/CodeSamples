package shelleyg;

import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

/***
 * Student Object Class
 * @author Gavin
 * @version 1.0
 * February 27 2016
 * Class containing all of the attributes and Methods for Student
 */
public class Student {

	// Attribute Definitions
	// ==================================
	/*** student number value for a Student object*/
	private int studentNumber;
	/*** password value for a Student object*/
	private String password;
	/*** firstName value for a Student object*/
	private String firstName;
	/*** lastName value for a Student object*/
	private String lastName;
	/*** birthDate value for a Student object*/
	private Date birthDate;
	/*** emailAddress value for a Student object*/
	private String emailAddress;
	/*** phoneNumber value for a Student object*/
	private String phoneNumber;
	/*** Class Date Formatter for Student Birth Date  */
	static final SimpleDateFormat SQL_DATE = new SimpleDateFormat("YYYY-MM-dd");
	
	// Attribute Vectors
	// ==================================
	/*** Class Vector to hold a Students Grades */
	private Vector studentGrades = new Vector();
	/*** Class Vector to hold all Students information  */
	private static Vector<Student> aStudents = new Vector<Student>();
	/*** Class Vector to a single Students Marks*/
	private Vector<Marks> aMarks = new Vector<Marks>();
	
	// ==================================
	/*** Initialize the Database connection 	
	 * @param c
	 */
	public static void initialize(Connection c)
		{StudentDA.initialize(c);}
	/*** Terminate the Database connection  
	 */
	public static void terminate()
		{StudentDA.terminate();}
	/*** Validates a Students Student number and Password in the Database 
	 * @param myStudentNumber
	 * @param myPassword
	 * @return
	 * @throws StudentNotFoundException
	 */
	public static Student login(int myStudentNumber, String myPassword) throws StudentNotFoundException
		{return StudentDA.login(myStudentNumber, myPassword);}
	/*** Throws an Exception when a Student record is not found in the Database
	 * @param id
	 * @return
	 * @throws StudentNotFoundException
	 */
	public static Student find(int id) throws StudentNotFoundException
		{return StudentDA.find(id);}
	/***
	 * Stores all of the Student information from the Database into a Student Vector
	 * @return
	 */
	public static Vector<Student> getAllStudents() 
		{return aStudents;}	
	/*** 
	 * Checks to see if a Students Student number is in the Database
	 * @param id
	 * @return
	 */
	public static boolean isExistingLogin(int id)
    	{ return StudentDA.isExistingLogin(id);}
	
	// ==================================
	/*** 
	 * Delete a Student record from the Database
	 * @throws StudentNotFoundException
	 */
	public void delete() throws StudentNotFoundException
		{StudentDA.delete(this);}
	/*** 
	 * Update a Student record in the Database
	 * @throws StudentNotFoundException
	 */
	public void update() throws StudentNotFoundException
		{StudentDA.update(this);}
	/*** 
	 * Insert a Student record into the Database
	 * @throws DuplicateStudentException
	 */
	public void insert() throws DuplicateStudentException
		{StudentDA.insert(this);}	
	/*** 
	 * Get the full Transcript of grades and gpas for a Student
	 * in a formatted Table for HTML viewing 
	 * @return
	 */
	public String getHTMLTranscript()
		{return StudentDA.getHTMLTranscript(this.getStudentNumber());};
	/*** 
	 * Get the full Transcript of grades and gpas for a Student
	 * in Vector containing the information
	 * @return
	 */
	public Vector<Marks> getTranscript()
		{return StudentDA.getTranscript(this.getStudentNumber());};
	/*** 
	 * Calculate the gpa for a Students entire transcript
	 * @return
	 */
	public double calculateGPA()
		{return StudentDA.calculateGPA(this);}; 
	
	/***
	 * Student Constructor no Grades
	 * @author Gavin
	 * @version 1.0
	 * February 27 2016
	 * @param newNumber
	 * @param newPassword
	 * @param newFirst
	 * @param newLast
	 * @param newBirth
	 * @param newEmail
	 * @param newPhone
	 * Builds a Student object with all attributes passed except 
	 * the vector containing the Student grades. Grades vector is
	 * set to Null.
	 */
	public Student(int newNumber, String newPassword, String newFirst, 
			String newLast, Date newBirth, String newEmail, String newPhone) {
		super();		
		this.setStudentNumber(newNumber);
		this.setPassword(newPassword);
		this.setFirstName(newFirst);
		this.setLastName(newLast);
		this.setBirthDate(newBirth);
		this.setEmailAddress(newEmail);
		this.setPhoneNumber(newPhone);		
		this.studentGrades.clear();
	}

	/***
	 * Student Constructor with Grades
	 * @author Gavin
	 * @version 1.0
	 * February 27 2016
	 * @param newNumber
	 * @param newPassword
	 * @param newFirst
	 * @param newLast
	 * @param newBirth
	 * @param newEmail
	 * @param newPhone
	 * @param newGrades
	 * Calls the Constructor to build a Student object with no Grades.
	 * A Vector containing the Grades is passed to the constructor and
	 * added to the Student Object
	 */
	public Student(int newNumber, String newPassword, String newFirst, 
			String newLast, Date newBirth, String newEmail, String newPhone, Vector newGrades) {
		this(newNumber, newPassword, newFirst, newLast, newBirth, newEmail, newPhone);
		this.setStudentGrades(newGrades);
	}

	/***
	 * Student toString 
	 * @author Gavin
	 * @version 1.0
	 * February 27 2016
	 * Returns the attributes of a Student object to the calling 
	 * method in the form of a formatted String
	 */
	public String toString()
	{
		String studentInformation =	"Student ID " 			+ this.getStudentNumber() +
									"Password " 			+ this.getPassword() +
									"First Name " 			+ this.getFirstName() +
									"Last Name " 			+ this.getLastName() +
									"Birthdate " 			+ this.getBirthDate() +
									"Email Address "		+ this.getEmailAddress() +
									"Phone Number "			+ this.getPhoneNumber();
		return studentInformation;
	}
	
	// Get and Set Methods
	// ==================================
	/*** get Student number */
	public int getStudentNumber() 
		{return studentNumber;}
	/*** set Student number */
	public void setStudentNumber(int studentNumber) 
		{this.studentNumber = studentNumber;}
	
	/*** get Student password */
	public String getPassword() 
		{return password;}
	/*** set Student password */
	public void setPassword(String password) 
		{this.password = password;}
	
	/*** get First Name */
	public String getFirstName() 
		{return firstName;	}
	/*** set First Name */
	public void setFirstName(String firstName) 
		{this.firstName = firstName;}
	
	/*** get Birth Date */
	public Date getBirthDate() 
		{return birthDate;}
	/*** set Birth Date */
	public void setBirthDate(Date birthDate) 
		{this.birthDate = birthDate;}
	
	/*** get Email Address */
	public String getEmailAddress() 
		{return emailAddress;}
	/*** set Email Address */
	public void setEmailAddress(String emailAddress) 
		{this.emailAddress = emailAddress;}
	
	/*** get Phone Number */
	public String getPhoneNumber() 
		{return phoneNumber;}
	/***  set Phone Number */
	public void setPhoneNumber(String phoneNumber) 
		{this.phoneNumber = phoneNumber;}
	
	/*** get Student Grades */
	public Vector getStudentGrades() 
		{return studentGrades;}
	/*** set Student Grades */
	public void setStudentGrades(Vector studentGrades) 
		{this.studentGrades = studentGrades;}
	
	/*** get Last Name */
	public String getLastName() 
		{return lastName;}
	/*** set Last Name */
	public void setLastName(String lastName) 
		{this.lastName = lastName;	}
}
