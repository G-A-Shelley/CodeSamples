#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'dynamicArray' function below.
#
# The function is expected to return an INTEGER_ARRAY.
# The function accepts following parameters:
#  1. INTEGER n
#  2. 2D_INTEGER_ARRAY queries
#

def dynamicArray(n, queries):
  # declare and empty 2d array pf size n
  # declare integer variable and initialize to 0
  # n = size of the 2d array
  # queries = an array of strings to parse
  
  lastAnswer  = 0
  arr         = [[] for i in range(n)]
  answer      = list()

  for q,x,y in queries:
    idx = ((x^lastAnswer)%n)
    if q == 1:
      # append the integer y to arr at index idx
      arr[idx].append(y)
    elif q ==2:
      # assign the value of arr[idx][y%(arr[idx])] to lastAnswer
      arr[idx][y%len(arr[idx])] = lastAnswer
      answer.append(lastAnswer)
    
  # return teh value for lastAnswer
  return(answer)
