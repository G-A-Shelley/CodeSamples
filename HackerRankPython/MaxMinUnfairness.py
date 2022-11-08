#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'maxMin' function below.
#
# The function is expected to return an INTEGER.
# The function accepts following parameters:
#  1. INTEGER k
#  2. INTEGER_ARRAY arr
#

def maxMin(k, arr):
  # list of integer values and a single integer
  # create an array of length k from elements of the list
  # calculate the unfairness value
  # max(arr) - min(arr)
  # return the minimum possible unfairness

  arr.sort()            # sort list values numerically
  unfairness = arr[-1]  # set unfairness to the mas value in the list
    
  # iterate through the list and sublists to find min and max values
  for i in range(len(arr)-k+1):
    # set unfairness to the min value of the two value
    # last sub element minus the first sub element or current unfairness
    unfairness = min(arr[i+k-1]-arr[i], unfairness)
  
  # return the unfairness value
  return(unfairness)
  
