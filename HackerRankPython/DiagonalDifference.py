#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'diagonalDifference' function below.
#
# The function is expected to return an INTEGER.
# The function accepts 2D_INTEGER_ARRAY arr as parameter.
#

def diagonalDifference(arr):
  # given a square matrix, calculate the absolute difference of its diagonals
  # arr = square matrix / 2d array
  
  size  = len(arr)  # number of elements in the list
  dSum  = [0,0]     # list to hol sum values
  index = 0         # element in list index counter
  
  # iterate through the diagonals in the matrix
  for i in range(size):
    # increment the diagonal sums and index counters
    dSum[0] += arr[i][index]
    dSum[1] += arr[i][size-index-1]
    index+=1
  # return the absolute difference of the two diagonals
  return(abs(dSum[0]-dSum[1])) 
