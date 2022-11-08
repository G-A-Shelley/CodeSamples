#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'flippingBits' function below.
#
# The function is expected to return a LONG_INTEGER.
# The function accepts LONG_INTEGER n as parameter.
#

def flippingBits(n):
  # given a 32 bit unsigned integer
  # flip the bits and return the result
  # n = unsigned integer
  
  bits  = format((n),"032b")  # convert interger to binary with 32 places
  flip  = ""                  # binary conversion string
  
  # iterate through the individual values 
  for bit in bits:
    # determine if the value is 1 and add new value to the conversion string
    if int(bit) == 1:
      flip += "0"
    else:
      flip+= "1"
      
  # return the integer value of the binary conversion string
  return(int(flip,base=2))

  