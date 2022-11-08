#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'miniMaxSum' function below.
#
# The function accepts INTEGER_ARRAY arr as parameter.
#

def miniMaxSum(arr):
  # five positive integers
  # find min and max values by summing four of the five integers
  # arr = array of integer values
  
  size    = len(arr)  # total number of integers in the arry
  high    = 0         # high sum value 
  low     = 0         # low sum value
  sumArr  = sum(arr)  # sum of all the integers in the array
  
  # initate high and low for the first integer value
  high    = sumArr - arr[0]
  low     = sumArr - arr[0]    
  
  # iterate through all the integer values
  for i in range(1,size):
    # determine if the current sum is a new high or low value
    # sethigh and low if the criteria is met
    if high < (sumArr - arr[i]):
      high = sumArr - arr[i]
    if low > (sumArr - arr[i]):
      low = sumArr - arr[i]
  
  # print out space separated integers
  print(low,high)
  