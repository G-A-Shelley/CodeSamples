#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'plusMinus' function below.
#
# The function accepts INTEGER_ARRAY arr as parameter.
#

def plusMinus(arr):
  # array of integers
  # positive and negative numbers
  # ratio of positive negative zero numbers in the array
  # 6 decimal places
  
  # arr = array of integers
  
  results = [0,0,0]   # counter for values found for positive negative and zero
  size    = len(arr)  # total number of integers in the array
  
  # iterate through teh integers in teh array
  for item in arr:
    # determine if the value is positive negative or zero
    # increment counters
    if item > 0:
      results[0] += 1
    elif item < 0:
      results[1] += 1
    else:
      results[2] += 1
  
  # iterate through the counters
  # calculate and print results
  for item in results:
    print("{:6f}".format(item/size))
 