/******************************************************************************
 * Author   : Gavin Shelley
 * Course   : DNET 4200
 * Date     : Mar 30 2015
 * Program  : Assignment 10
 *                  
 * Description
 * 
 *      Contains the definitions for the fields, properties, event handlers, 
 *  constructors, events and method that make up the user control
 * 
 *          User Control Class - PlayingCardBox
 *          ===================================
 *          Declaration
 *              Constants
 *              Variables
 *          Properties
 *              IsFaceUp
 *              MySuit
 *              MyRank
 *              CardFlips
 *          EventHandlers
 *              CardFlipped
 *              Click
 *          Constructor
 *              Default
 *          Events
 *              PlayingCardBox_Load
 *              pboCardImage_Click
 *          Methods
 *              UpdateCardImage
 *              ToString
 *              FlipCard
 * 
 ******************************************************************************/

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PlayingCardDisplay
{
    public partial class PlayingCardBox : UserControl
    {
        #region Constant and Variable Declarations
        //============================================
        // Instance - Constant and Variable Declarations
        //============================================


        // Constants
        private const Rank DEFAULT_RANK = Rank.Seven;   // Default Rank value for a PlayingCardBox object
        private const Suit DEFAULT_SUIT = Suit.Hearts;  // Default Suit value for a PlayingCardBox object
        private const bool DEFAULT_FACE = true;         // Default IsFaceUp value for a PlayingCardBox object

        // Variables
        private int cardFlips = -1;                     // Initialize the card flips count to -1
        private Rank myRank;                            // holds the value of myRank for a PlayingCardBox object
        private Suit mySuit;                            // holds the value of mySuit for a PlayingCardBox object
        private bool faceUp;                            // holds the value of faceUp for a PlayingCardBox object

        # endregion

        # region Properties
        //============================================
        // Properties
        //============================================


        // IsFaceUp
        //============================================
        public bool IsFaceUp
        {
            set
            {
                // Sets the value of faceUp
                faceUp = value;
                // Calls the method to increment cardFlips
                this.CardFlips++;   
                // Update the image to match the change to faceUp
                this.UpdateCardImage();
                // Determine if CardFlipped is not null
                if (CardFlipped != null)
                {
                    // Raise the Event CardFlipped
                    CardFlipped(this, EventArgs.Empty);
                }
            }
            get
            {
                // Return the value of faceUp
                return faceUp;
            }
        }
                
        // MySuit
        //============================================
        public Suit MySuit
        {
            set
            {
                // Sets the value of mySuit
                mySuit = value;
                // Update the image to match the change to mySuit
                this.UpdateCardImage();
            }
            get
            {   // Return the value of mySuit
                return mySuit;

            }
        }
                
        // MyRank
        //============================================
        public Rank MyRank
        {
            set
            {
                // Sets the value of myRank
                myRank = value;
                // Update the image to match the change to myRank
                this.UpdateCardImage();
            }
            get
            {
                // Return the value of myRank
                return myRank;
            }
        }
             
        // CardFlips
        //============================================
        public int CardFlips
        {
            set
            {
                // Sets the value of cardFlips
                cardFlips = value;
            }
            get
            {
                // Returns the value of cardFlips
                return cardFlips;
            }
        }


        # endregion

        # region Event Handlers

        //============================================
        // Event Handlers
        //============================================


        // Handler for the CardFlipped event
        public event EventHandler CardFlipped; 
        // Handler for the Picture Box image Click       
        public new event EventHandler Click;

        # endregion

        # region Constructor
        //============================================
        // Constructors
        //============================================
        
        
        // Default
        //============================================
        public PlayingCardBox()
        {
            // Initializes a PlayingCardBox object
            InitializeComponent();

            // Sets the value of myRank to a default value
            this.MyRank = DEFAULT_RANK;     
            // Sets the value of mySuit to a default value
            this.MySuit = DEFAULT_SUIT;
            // Sets the value of faceUp to a default value
            this.IsFaceUp = DEFAULT_FACE;
        }

        # endregion

        # region Events

        //============================================
        // Events
        //============================================
        
        
        // PlayingCardBox Load
        //============================================
        private void PlayingCardBox_Load(object sender, EventArgs e)
        {
            // Calls the method to load the image for a PlayingCardBox object
            this.UpdateCardImage();
        }
                
        // Picture Box Image Click
        //============================================
        private void pboCardImage_Click(object sender, EventArgs e)
        {
            // Determine if Click is not null
            if (Click != null)
            {
                // Call the Click event
                Click(this, null);
            }
        }

        # endregion

        # region Methods

        //============================================
        // Methods
        //============================================
        
        
        // Update Card Image
        //============================================
        private void UpdateCardImage()
        {
            // Declare a string to hold the card information
            string imageName;

            // Determine if the Card is face up or down, If it is face up determine 
            // the rank of the card and then create the image name string
            if (faceUp == false)
            {
                // The card is face down

                // Set the image name to show the back of the card
                imageName = "CB";
            }
            else if ((int)this.MyRank < 9)
            {
                // The card is face up and the rank index is less than 9 for numeric rank cards

                // Set the image name of the card for numeric rank cards
                imageName = "_" + ((int)this.MyRank + 2) + this.MySuit.ToString().Substring(0, 1);
            }
            else
            {
                // The card is face up and the rank index is greaterthan or equal to 9 for named rank cards

                // Set the image name of the card for named rank cards
                imageName = this.MyRank.ToString().Substring(0, 1) + this.MySuit.ToString().Substring(0, 1);
            }
             
            // Set the image of the picture box using the string created in imageName        
            pboCardImage.Image = (Bitmap)Properties.Resources.ResourceManager.GetObject(imageName);
        }
                
        // ToString - OverLoaded
        //============================================
        public override string ToString()
        {
            // Declare a string to hold the information of a PlayingCardBox object
            string cardInformation;

            // Determine if the card is face up or face down
            if (faceUp == true)
            {
                // The Card is face up

                // Create a sting to display the value of myRank and mySuit in a concatenated string
                cardInformation = "The " + myRank.ToString() + " of " + mySuit.ToString();
            }
            else
            {
                // The card is face down

                // Create a string with the face down message
                cardInformation = "Card is Face Down";
            }

            // Return the string containing the card information
            return cardInformation;
        }
                     
        // Flip Card
        //============================================     
        public void FlipCard()
        {     
            // Determine if the card is face up or face down
            if (this.IsFaceUp == true)
            {
                // The card if face up, change the value of faceUp to false
                // to change the card to face down
                this.IsFaceUp = false;                
            }
            else
            {
                // The card is face down, change the value of faceUp to true 
                // to change the card to face up
                this.IsFaceUp = true;                
            }
        }

        # endregion
    }
}
