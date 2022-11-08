#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'pangrams' function below.
#
# The function is expected to return a STRING.
# The function accepts STRING s as parameter.
#

def pangrams(s):
  # pangram is a string that contains every letter of the alphabet
  # return if the string is or is not a pangram
  # s = string contaning a phrase
  
  # build a dictionary counter of the lower case alphabet
  letters   = "abcdefghijklmnopqrstuvwxyz"
  alphaBet  = dict()
  for char in letters:
    alphaBet[char] = 0

  result = "pangram"  # set default return message
  
  # iterate through all of the characters in the string
  for char in s:
    # determine if the current character is in the alphabet
    if char.isalpha():
      # increment the value for the current letter key
      alphaBet[char.lower()] = alphaBet[char.lower()] + 1
    
  # determine if the lowest count is zero and change return message
  if (min(alphaBet.values())) == 0:
    result = "not pangram"   
  
  # return the result
  return(result)
 