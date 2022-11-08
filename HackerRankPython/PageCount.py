#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'pageCount' function below.
#
# The function is expected to return an INTEGER.
# The function accepts following parameters:
#  1. INTEGER n
#  2. INTEGER p
#

def pageCount(n, p):
  # open books to a page number
  # start from the fron or back
  # turn one page at a time
  # page 1 on the right side
  # given total pages and page number
  # minimum number of page turns to reach the desired page
  # n = number of pages
  # p = page to reach
  # return the minimum number of pages to turn

  turns       = 0       # number of page turns to reach desired page p
  offest      = 0       # page offset for over mid point pages

  # determine if the page and total pages are the same and return 0
  if n == p : 
    return(0)
  
  # determine if the page numbers are odd
  if p%2==1:
    offest = 1  # set page offset to 1
    
  turns = min(p//2,(n-p+offest)//2) # calculate the minimum number of turns
  
  # return the page turn value
  return(turns)
  