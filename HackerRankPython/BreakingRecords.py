#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'breakingRecords' function below.
#
# The function is expected to return an INTEGER_ARRAY.
# The function accepts INTEGER_ARRAY scores as parameter.
#

def breakingRecords(scores):
  # scores = points scored per game
  count = [0,0]   # counter of high low score breaks
  track = [0,0]   # tracking of high low scores
  
  track[0] = scores[0]  # set the inital score for the high score
  track[1] = scores[0]  # set the inital score for the low score 
  
  # iterate through the score list
  for score in scores:
    # determine if the high score has been beat
    if score > track[0]:
      track[0] = score  # set new high score
      count[0]+=1       # increment high score counter
    # determine if the low score has been beat
    if score < track[1]:
      track[1] = score  # set new low score 
      count[1]+=1       # increment low score counter
  
  # return the score counter list
  return(count)
