#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'lonelyinteger' function below.
#
# The function is expected to return an INTEGER.
# The function accepts INTEGER_ARRAY a as parameter.
#

def lonelyinteger(a):
  # an array of pairs of integers where there is one without a pair
  # locate the unique element
  
  # a = array of integer values

  a.sort()  # sort arr values
    
  # function to be called recursively
  def pairs(arr):
    # if the array has a single value return the value
    if len(arr) == 1:
      return(arr[0])
    # if the first two values are a pair
    elif arr[0] == arr[1]:
      #pop the pair of values from the array and call the function with the new array
      arr.pop(0)
      arr.pop(0)
      pairs(arr)
    # return the first value of the array 
    return(a[0])
  
  # return the value from the pairs function for the array a    
  return(pairs(a))
    
  