import zipfile
import pytesseract
from PIL import Image
from IPython.display import display
import cv2 as cv
import numpy as np
import math
face_cascade = cv.CascadeClassifier('readonly/haarcascade_frontalface_default.xml')

# G A Shelley 2022

# build list of file names and images from a zip file of images
def build_image_list(file_name, check_value):

    # checks image file for a specific text string
    def text_check(file, check):
        text = pytesseract.image_to_string(file)
        if check in text: return(True)
        else: return(False)

    return_list = list()    # collection of lists of image information to be returned

    # build information from the zipped image files
    zip_data = zipfile.ZipFile(file_name)   # read the zipped object
    zip_list = zip_data.infolist()          # list of zipinfo objects
    zip_name = zip_data.namelist()          # return a list of object file names

    # iterate though the zip objects and build image information
    for i, item in enumerate(zip_list):
        image_list = list()                 # create a list for the current imahe information
        this = zip_data.open(item)          # open zipfile for current item
        image_list.append(Image.open(this)) # add the image to the image list
        image_list.append(zip_name[i])      # add the image file name to the list

        # check the current image for the current text value
        is_check = text_check(Image.open(this), check_value)
        image_list.append(is_check)         # add the check boolean to the list

        #  add the current image list go the return list and return the list
        return_list.append(image_list)
    return return_list

# builds contact sheet of facial images for files containig specified text
def find_faces_for_text(image_list, cont_width, image_size):
    # iterate though the images information list
    for item in image_list:
        # determine if the text value was found in the images
        if item[2] == True:
            print("Results found in file {}".format(item[1])) # display message
            #pil_img = (item[0])

            # set the image to grayscale and detect faces in the image
            cv_img = cv.cvtColor(np.array(item[0]), cv.COLOR_BGR2GRAY)
            faces = face_cascade.detectMultiScale(cv_img,1.3,5)

            # determine if any faces were located in the image
            if len(faces) > 0 :

                pil_img = (item[0])             # save the current pil image

                total = len(faces)              # find the total number of images
                row = math.ceil(total/cont_width) # calculate the  total number of rows
                rows,columns = 0,0              # set the counters for contact sheet building

                # build the contact sheet for the rows and columns for current number of facial images
                contact_sheet = PIL.Image.new(pil_img.mode, (image_size*cont_width,image_size*row))

                # iterate through the facial image data
                for x,y,w,h in faces:
                    # build contact sheet image
                    img = pil_img.crop((x,y,x+w,y+h)) # crop image with current coordinates
                    img = img.resize((image_size,image_size)) # resize image to fit contact sheet
                    contact_sheet.paste(img,(columns, rows)) # add image to the contact sheet

                    # increment columns and counter for images
                    columns += image_size

                    # deterimne if the current image is at the end of the row
                    if columns == (cont_width * image_size):
                        columns = 0             # reset columns to the first column
                        rows += image_size      # increment row by image height

                display(contact_sheet)          # display completed contact sheet
            else :
                # display the message when no faces are found in the image
                print("But there were no faces in that file!")
