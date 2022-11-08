#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'superDigit' function below.
#
# The function is expected to return an INTEGER.
# The function accepts following parameters:
#  1. STRING n
#  2. INTEGER k
#

def superDigit(n, k):
  # n = number string
  # k = length of the string
  
  values = list(n)  # create a list of values from the string
  
  # iterate through the list until there is 1 element left
  while len(values) > 1:
    digit = 0   # holds the calculated sume of all the values
    # iterate through all of the elements in the list
    for num in values:
      digit += int(num) # add the current element int value to digit
    values = list(str(digit)) # create a new list from the digit sum value
    
  # return the remaining value in the values list
  return(values[0])
