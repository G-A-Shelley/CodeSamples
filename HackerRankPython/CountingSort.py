#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'countingSort' function below.
#
# The function is expected to return an INTEGER_ARRAY.
# The function accepts INTEGER_ARRAY arr as parameter.
#

def countingSort(arr):
  # quicksorr runtime n times log(n)
  # counting sort does not require comparisons
  # arr = array of integer values
  
  maxValue  = max(arr)+1  # find the maximum value in the array
  arrCount  = [0 for i in range(maxValue)]  # build a counting array 

  # iterate through the array
  for item in arr:
    # increment the value of the counting array at the index of the current item
    arrCount[item] += 1
  
  # return the counting array
  return(arrCount)
  