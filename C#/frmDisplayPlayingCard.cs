/******************************************************************************
 * Author   : Gavin Shelley
 * Course   : DNET 4200
 * Date     : Mar 30 2015
 * Program  : Assignment 10
 *                  
 * Description
 * 
 *          This is a Windows Form application that will demonstrate the user
 *  control class PlayingCardBox and its features. The application will display
 *  a card image based on the suit and rank of the card as well as if the card
 *  is face up or down. The application will also display a message that will
 *  reflect the state of the image in the form. The client can select a specific 
 *  rank or suit from a combo box and the application will update the image and
 *  the message in the form. The client can also flip the image to show the back
 *  of the card, when flipped over the message will also indicate the card is 
 *  face down. The application will track the number of times a card has been
 *  flipped and display the total in the form for the client to see. When the 
 *  client is finished they can click the exit button to end the application
 *          
 ******************************************************************************/

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PlayingCardDisplay
{
    public partial class frmDisplayPlayingCard : Form
    {
        //==================================================================================
        public frmDisplayPlayingCard()
        {
            // Initialize the application form
            InitializeComponent();
        }
        //==================================================================================
        private void frmDisplayPlayingCard_Load(object sender, EventArgs e)
        {
            // Load the individual combo boxes for Rank and Suit from the Enumerations
            // containing the Rank and Suit values for a Deck of cards
            cboRank.DataSource = Enum.GetValues(typeof(Rank));
            cboSuit.DataSource = Enum.GetValues(typeof(Suit));

            // Set the index of the combo boxes to the index of the first item in the box
            cboRank.SelectedIndex = 0;
            cboSuit.SelectedIndex = 0;

            // Set the Rank of the usrCardBox based on the selected index of the Rank combo box
            usrCardBox.MyRank = (Rank)cboRank.SelectedItem;
            // Set the Suit of the usrCardBox based on the selected index of the Suit combo box
            usrCardBox.MySuit = (Suit)cboSuit.SelectedItem;

            // Set the CardFlips counter to 0
            usrCardBox.CardFlips = 0;
          
            // Display the card information in the label on the form
            lblCardInformation.Text = usrCardBox.ToString();
            // Display a welcome message to the client in the message label on the form
            lblMessage.Text = "Welcome to the Card Tester.";   
        }
        //==================================================================================
        private void btnFlip_Click(object sender, EventArgs e)
        {
            // Call the FlipCard method for usrCardBox to filp the curren card displayed in the application
            usrCardBox.FlipCard();

            // Update the card information string on the form 
            lblCardInformation.Text = usrCardBox.ToString();
            // Update the flipped card information string on the form
            lblMessage.Text = "The Card has been flipped " + usrCardBox.CardFlips.ToString() + " times.";           
        }          
        //==================================================================================
        private void cboSuit_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Update the Suit of the card based on the clients selection in the Suit combo box
            usrCardBox.MySuit = (Suit)cboSuit.SelectedItem;
            // Update the card information string on the form 
            lblCardInformation.Text = usrCardBox.ToString();
        }
        //==================================================================================
        private void cboRank_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Update the Rank of the card based on the clients selection in the Rank combo box
            usrCardBox.MyRank = (Rank)cboRank.SelectedItem;
            // Update the card information string on the form 
            lblCardInformation.Text = usrCardBox.ToString();
        }
        //==================================================================================
        private void btnExit_Click(object sender, EventArgs e)
        {
            // Close the Form and the Application
            this.Close();
        }
        //==================================================================================
       
    }
}
