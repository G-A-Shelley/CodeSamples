#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'towerBreakers' function below.
#
# The function is expected to return an INTEGER.
# The function accepts following parameters:
#  1. INTEGER n
#  2. INTEGER m
#

def towerBreakers(n, m):
  # n = number of towers at the start
  # m = height of each of the towers
  
  # players alternate moves
  # players turn :
  # tower height x can be reduced to y
  # y greater than 1
  # x greater than Y
  # x divided by y is an integer value

  # determine if the tower height is 1, no moves can be made
  if m==1:
    return(2) # player 1 cannot move so 2 wins
    
  # determine if there is an odd number of towers
  if n%2==1:
    return(1) # player 1 wins on odd number of towers
  else:
    return(2) # player 2 wins on even number of towers
