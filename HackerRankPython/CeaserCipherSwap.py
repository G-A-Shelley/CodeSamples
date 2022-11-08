#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'caesarCipher' function below.
#
# The function is expected to return a STRING.
# The function accepts following parameters:
#  1. STRING s
#  2. INTEGER k
#

def caesarCipher(s, k):
  
  # s = string to be changed
  # k = number of letter rotations

  upperbet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  lowerbet = "abcdefghijklmnopqrstuvwxyz"
  newString = ""    # cipher string to be returned
  
  # determine if character is an alpha character
  # determine if the character is upper or lower case
  
  # function to swap characters for cipher
  def swapChar(char, alphabet, offset):
    ind = alphabet.index(char) + offset   # set the offset index value
    
    # determine if the offset is larger than the alphabet and adjust the offset value
    if offset > 26: offset = offset%26    
    # determine if the ind value is out of range
    if (ind) > 25 :
      ind = (ind)%26  # adjust the index value to the list range
  
    #return(char)
    return(alphabet[ind])
  
  # iterate through all of the characters in the string
  for char in s:
    # determine if the character is from the alphabet
    if char.isalpha():
      # determine the character case and call the swapChar function with related values
      if char.isupper(): newString += swapChar(char, upperbet, k)
      else: newString += swapChar(char, lowerbet, k)
    else:
      newString += char # add not alpha character directly to the new string
  
  # return the new string
  return(newString)
