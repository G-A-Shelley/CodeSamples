#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'gridChallenge' function below.
#
# The function is expected to return a STRING.
# The function accepts STRING_ARRAY grid as parameter.
#

def gridChallenge(grid):
  # grid = list of strings
  rows    = len(grid)     # number of list in the grid
  columns = len(grid[0])  # length of the lists in the grid

  # iterate through the grid rows
  for i in range(rows):
    grid[i] = sorted(grid[i]) # sort each list row 

  # iterate through the grid rows minus the last row
  for i in range(rows-1):
    # iterate through the grid columns
    for j in range(columns):
      # determine if the values with the same index are incresing from row to row
      if grid[i][j] > grid[i+1][j]:
        return("NO")  # return NO when they are not increasing
  
  # return YES when all values are increasing
  return("YES")
