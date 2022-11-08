#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'timeConversion' function below.
#
# The function is expected to return a STRING.
# The function accepts STRING s as parameter.
#

def timeConversion(s):
  # Given a 12hour AM PM time format, convert it to 24 hours
  # 12:00:00 AM is 00:00:00 24 hour format
  # s = string time information
  
  # split the time string into a list 
  parts = s.split(":")
  parts.append((parts[2])[2:4])
  parts[2] = ((parts[2])[0:2])

  # determine if the time is for AM or PM
  if parts[3] == "AM":
    # determine if the time is hour 12 and set new hour values
    if int(parts[0]) == 12:
      parts[0]  = "00"
  else:
    # determine if the hour is 12 and set new hour values
    if int(parts[0]) == 12:
      parts[0]  = "12"
    else:
      parts[0]  = str(int(parts[0]) + 12) 

  # return the new time stirng
  return(":".join(parts[0:3]))
