import math
import PIL
from PIL import Image, ImageFont, ImageDraw
# G A Shelley 2022

# In this assignment you are going to change the colors of the image, creating variations based on a single photo.
# In this assignment, you'll be just changing the image one color channel at a time
# Your assignment is to learn how to take the stub code provided in the lecture (cleaned up below), and generate the following output image:

# read and save image information
img = Image.open("readonly/msi_recruitment.gif")
img = image.convert('RGB')  # original image
img_copy = img.copy()       # copy image for base hue values

# setup font for images
font_size = 37
img_font = ImageFont.truetype('readonly/fanwood-webfont.ttf', font_size)

# original image dimension including text spacing
img_width = img.width       # image width
img_height = img.height+50  # image height plus text space

# build the base for the contact sheet and set dimensions
contact_sheet=PIL.Image.new(img.mode, (img_width*3,img_height*3))
con_width = contact_sheet.width     # contact sheet width
con_height = contact_sheet.height   # contact sheet height

# set incremental values for x and y image positions
x = con_width       # initialize x dimension for the full contact sheet width
y = -img_height     # initialize y dimension for - image height

# set values for colour change intensity
set_intense = 0.9   # inital value for colour intensity change
set_change  = 0.4   # the change in intensity for each colour change

# function definition for changing image colors
def ColourImage(this,colors):
    pixels = this.load() # map the image to pixels
    # iterate through all the pixels by rows and by columns
    for row in range(this.size[0]):
        for col in range(this.size[1]):
            r,g,b = img_copy.getpixel((row,col)) # set RGB values based on original image
            # set the current pixel values based on the color changes for each RGB value
            pixels[row,col] = (int(r*colors[0]),int(g*colors[1]),int(b*colors[2]))
    return this

# iterate though the spaces required for the contact sheet (3 by 3 images)
for i in range(3):
    x = con_width       # initalize x position to the width of the contact sheet
    y = y + img_height  # incerment y position by the height of an image
    rgb = [1,1,1]       # set the default RGB values for the ColourImage Function
    intense = set_intense
    for j in range(3):
        rgb[i] = intense # set the value for the current RGB value being adjusted

        # build current image with border across the bottom for text information
        img_current = ColourImage(img,rgb)
        temp_img = PIL.Image.new(img.mode, (img_width,img_height))
        temp_img.paste(img_current, (0,0))

        # build image with text information that matches colour changes
        img_text = "channel {} intensity {}".format(i,intense)
        img_all = ImageDraw.Draw(temp_img)
        img_all.text((15,img_height-font_size), img_text, (int(255*rgb[0]),int(255*rgb[1]),int(255*rgb[2])), font=img_font)

        contact_sheet.paste(temp_img,(x-img_width, y)) # add the updated image to the contact sheet
        x = x - img_width # decrement the x position by the image width
        intense = round(intense - set_change,1) # decrement the intense value for the next image

# resize the contact sheet and display to the client
contact_sheet = contact_sheet.resize((int(con_width/2),int(con_height/2) ))
display(contact_sheet)
