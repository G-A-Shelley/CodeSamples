// Connect to CustomerDatabase
package demo;

import java.sql.*;

/***
 * Customer Connection Class
 * @author Gavin
 * Feb 16 2016
 * Contains the Methods and Information required to connect to the Database 
 * containing Customer Information
 */
public class CustomerConnect
{
	static String url = "jdbc:postgresql://127.0.0.1:5432/demo_db";
	static Connection aConnection;
	static String user = "db_user";
	static String password = "db_password";
	
	// establish the database connection
	public static Connection initialize()
	{
		try
 		{ 	// load the jdbc - odbc Driver for PostGreSQL
			Class.forName("org.postgresql.Driver");
			
			// create connection instance
	    	aConnection = DriverManager.getConnection(url, user, password);
	    	
	 	}
		catch (ClassNotFoundException e)
		{
			System.out.println(e);
		}
		catch (SQLException e)
			{ System.out.println(e); }
		return aConnection;
	}

	// close the database connection
	public static void terminate()
	{
		try
 		{
    		aConnection.close();
		}
		catch (SQLException e)
			{ System.out.println(e);	}
	}
}