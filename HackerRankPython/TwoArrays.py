#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'twoArrays' function below.
#
# The function is expected to return a STRING.
# The function accepts following parameters:
#  1. INTEGER k
#  2. INTEGER_ARRAY A
#  3. INTEGER_ARRAY B
#

def twoArrays(k, A, B):
  # two array of integers of length n
  # k = value to check against
  # A = array of integers
  # B = array of integers
  
  # sort two arrays in opposite orders
  A.sort()
  B.sort(reverse=True)
  
  check = "YES" # set default return message
  
  # iterate through both arrays
  for i,item in enumerate(A):
    # compare the combined values at indexi to the value k
    if (A[i] + B[i]) < k:
      # if the criteria is not met, alter return message and break loop
      check = "NO"
      break
      
  # return message
  return(check)
