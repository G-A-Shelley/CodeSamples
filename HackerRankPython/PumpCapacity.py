#!/bin/python3

import math
import os
import random
import re
import sys



#
# Complete the 'truckTour' function below.
#
# The function is expected to return an INTEGER.
# The function accepts 2D_INTEGER_ARRAY petrolpumps as parameter.
#

def truckTour(petrolpumps):
  
  # petrolpumps contains 2 values
  # index 0 = the fuel pump capacity
  # index 1 = the distance to the next pump
  
  # find the starting pump to begin the tour
  tracker   = 0   # tracks the current pump index number to start
  capacity  = 0   # tracks the current truck gas tank capacity
  
  # iteraete through all of the petrolpump information
  # using enumerate to get the current index value of the pump
  for i,pump in enumerate(petrolpumps):
    
    distance  = int(pump[0])    # distance to travel with the fuel from the pump
    nextpump  = int(pump[1])    # distance to the next pump
    
    # calulate the tank capacity remaining after travelling to the next pump
    capacity = capacity + (distance - nextpump)
    
    # determine if the capacity remaining after travel is negative
    if capacity < 0 :
      capacity  = 0     # reset the tank capacity to an empty tank
      tracker   = i + 1 # set the traker index to the next pumps index
      
  # return the index pump number
  return(tracker)
 