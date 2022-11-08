#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'minimumBribes' function below.
#
# The function accepts INTEGER_ARRAY q as parameter.
#

def minimumBribes(q):
    line_size   = len(q)    # total number of people in the line
    bribes      = 0         # bribe coutner initaited at 0
    max_bribe   = 2         # set the max number of bribes per person in line

    # iterate through q of people
    for i,person in enumerate(q):
      # determine if the persons displacement is greater than 2
      if (person-1)-i > 2:
        bribes = "Too chaotic"  # set bribes to message
        break                   # break loop 

      # iterate through the current person value - 2 to the current index number
      for check in range(max(person-2,0), i):
        # determine if the person at the check index is greater than person
        if q[check] > person:
          bribes+=1 # increment bribes by 1
    
    # Return bribes information
    print(bribes)
  