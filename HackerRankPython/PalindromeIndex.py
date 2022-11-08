#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'palindromeIndex' function below.
#
# The function is expected to return an INTEGER.
# The function accepts STRING s as parameter.
#

def palindromeIndex(s):
  # s = palindrome string with extra character
  # find the index of the extra character
  
  palin = list(s)       # convert the string to a list
  j     = len(palin)-1  # find the index of the last element 
  
  # iterate through the elements first and last inwards
  for i,char in enumerate(palin):
    # determine if the indexes are not overlapping
    if i < j:
      #determine if the current values do not match  
      if palin[i] != palin[j]:
        # determine the matching pattern of the characters
        if palin[i] != palin[j-1]:
          return(i) # left against right side minus 1
        elif palin[i+1] != palin[j]:
          return(j) # right against left side plus 1
        elif palin[i] == palin[i+2]:
          return(i) # left against right side minus two checking for similar letters
        elif palin[j] == palin[j-2]:
          return(j) # right against left plus 2 checking for similar letters
      j-=1 # decrement the right side counter
    else:
      # indexes have overlapped break the loop
      break
  # return -1 the string is a plaindrome
  return(-1)
  