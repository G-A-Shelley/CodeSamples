#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'sockMerchant' function below.
#
# The function is expected to return an INTEGER.
# The function accepts following parameters:
#  1. INTEGER n
#  2. INTEGER_ARRAY ar
#

def sockMerchant(n, ar):
  # pile of socks ordered by colour
  # array of integers where the value represents a colour
  # determine the number of pairs of socks
  # n = number of socks
  # ar = array of coloured socks
  
  pairs   = 0     # calculated number of pairs 
  ar.sort()       # sort array values
  arSet = set(ar) # build a set of array values
  
  # iterate through each sock colour value
  for sock in arSet:
    # calculate the pairs for each colour from the count value floor 2
    pairs += ar.count(sock)//2
  
  # return the pairs value
  return(pairs)
 