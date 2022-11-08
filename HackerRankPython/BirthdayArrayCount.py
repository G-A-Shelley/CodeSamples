#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'birthday' function below.
#
# The function is expected to return an INTEGER.
# The function accepts following parameters:
#  1. INTEGER_ARRAY s
#  2. INTEGER d
#  3. INTEGER m
#

def birthday(s, d, m):
  # chocolate bar squares on a bar
  # contiguous segment of the bar
  # length equals birth month
  # sum of integers equals birth day
  # how many squares can it be divided into
  
  # s = chocolate bar squares
  # d = birth day / sum of the squares of chocolate
  # m = birth month / number of pieces of chocolate
  
  # Debug output 
  print("Days/Sum {} | Month/Length {}".format(d,m))
  
  pieces  = 0 # calculated number of pieces to be returned
  
  # determine if the length of a piece and the array equal
  # and if the sum of the array equals d the return 1
  if m == len(s) and sum(s) == d:
    return(1)
  
  # iterate through the squares
  for i,item in enumerate(s):
    # determine if the sum of the current piece to the plus m piece 
    # equal the day sum value
    if (sum(s[i:i+m])) == d:
      pieces  += 1  # increment the piece counter
      i       = i+m # increment the index to exclude counter pieces
    
  # return the number of ways the cholcate can be divided into
  return(pieces)
  