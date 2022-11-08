#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'getTotalX' function below.
#
# The function is expected to return an INTEGER.
# The function accepts following parameters:
#  1. INTEGER_ARRAY a
#  2. INTEGER_ARRAY b
#

def getTotalX(a, b):

  # a = factors
  # b = numbers

  maxA    = max(a)    # maximum value from a    
  maxB    = max(b)    # maximum value for b
  factors =[]         # empty list for factors found

  # iterate through the max value of a to the maximum value of b
  for test in range(maxA,maxB+1):
    countA = 0 # a index counter
    countB = 0 # b index counter
    # iterate through the factors
    for fact in a:
      # determine if the test is a factor of fact
      if test % fact == 0:
        print("Test%Fact {}:{} = ".format(test,fact,(test%fact)))
        countA += 1  # increment counter for a
        # determine if the end of a has been reached
        if countA==len(a):
          # iterate through the numbers
          for number in b:
            # determine if the number is a factor of the test
            if number % test == 0:
              print(" Number%Test {}:{} = ".format(number,number,(number%test)))
              countB += 1 # increment the counter
          # determine if the end of b has been reached
          if countB == len(b):
            print("##### Append Value {} #####".format(test))
            factors.append(test) # append the test to the factors list  
  
  # return the number of factors 
  return len((factors))
