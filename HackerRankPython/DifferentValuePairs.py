#!/bin/python3

import math
import os
import random
import re
import sys



#
# Complete the 'pairs' function below.
#
# The function is expected to return an INTEGER.
# The function accepts following parameters:
#  1. INTEGER k
#  2. INTEGER_ARRAY arr
#

def pairs(k, arr):
  # k = target difference of number pairs of array elements
  # arr = array of numbers
  
  arr.sort()            # sort array by numeric value
  counter   = 0         # counter for the number of pairs
  arrset    = set(arr)  # create a set for array values

  # iterate through the elements of the list
  for number in arr:
    # check to see if the pair value is in the set 
    if number+k in arrset:
      counter+=1    # increment the counter

  # retrun the counter value
  return(counter)
  