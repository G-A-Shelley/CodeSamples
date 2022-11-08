#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'isBalanced' function below.
#
# The function is expected to return a STRING.
# The function accepts STRING s as parameter.
#

def isBalanced(s):
  # s = string containing a sequence of brackets
  
  # determine if the string is balanced / anagram
  brackets  = {"(":")","{":"}","[":"]"} # dictionary of bracket pairs
  b_open    = ["(","{","["]             # list of opening brackets
  b_closed  = {")","}","]"}             # list of closing brackets
  counter   = 0                         # bracket pair counter
  
  # iterate through each character in the bracket string
  for item in s:
    # determine if there is a balaced number of opening and closing brackets
    if item in b_open:
      counter+=1
    else:
      counter-=1
      
  # if the counter is not 0 the brackets are not balanced
  if counter !=0 : return("NO")

  # iterate through all of the characters in the string using an index
  for ind in range(len(s)):
    # determine if the current character is not in open
    # determine if the previous character is open
    if s[ind]not in b_open and s[ind-1] in b_open:
      # determine if the value for the previous character is not the same as the current
      # checking for bracket pairs from the dictionary 
      if brackets[s[ind-1]] != s[ind]:
        return("NO")
  
  # return the YES value
  return("YES")
