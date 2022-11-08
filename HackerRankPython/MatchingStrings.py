#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'matchingStrings' function below.
#
# The function is expected to return an INTEGER_ARRAY.
# The function accepts following parameters:
#  1. STRING_ARRAY strings
#  2. STRING_ARRAY queries
#

def matchingStrings(strings, queries):
  # collection of input string and a collection of query strings 
  # for each query string, how many times it occurs in the list of input strings
  # how many times does a query string appear in an input string
  
  # strings   = input string values
  # queries   = query strings to check against the input stings
  
  # sort lists
  strings.sort()
             
  check = [0 for i in range(len(queries))]  # build list to contain string counts
  
  # iterate through the query values to be checked
  for i, query in enumerate(queries):
    # iterate through the input strings
    for item in strings:
      # determine if the query matches the string, increment the counter
      if queries[i] == item:
        check[i] += 1
      # determine if the query is greater than the string being checked
      # break strings loop when it is greater
      if queries[i] < item:
        break  
  
  # return the check counts for queries
  return(check)
