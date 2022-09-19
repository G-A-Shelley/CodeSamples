#!/bin/python3

import math
import os
import random
import re
import sys


#
# Complete the 'minTime' function below.
#
# The function is expected to return a LONG_INTEGER.
# The function accepts following parameters:
#  1. INTEGER_ARRAY files
#  2. INTEGER numCores
#  3. INTEGER limit
#

def minTime(files, numCores, limit):
    # files     = array of integer values
    # numCores  = number of cores in the computer
    # limit     = max number of files that can be executed in parallel
    
    splitCore   = []   # files using the core to the limit 
    fullCore    = []   # files over the core limit

    # iterate through the files to process
    for file in files:
        # if the file can be processed in parallel
        if file % numCores == 0:
            splitCore.append(file)   # files that can be processed in parallel
        else:
            fullCore.append(file)   # files that cannot be processed in parallel

    # sort the files that are under/meet the core limit
    splitCore.sort(reverse=True)

    # calculate the pre-limit files, post-limit files and single files to processes in paralell
    preLimit    = sum(splitCore[:limit]) // numCores 
    postLimit   = sum(splitCore[limit:])
    singleFile  = sum(fullCore)

    # calculate the number of files that can be executed in parallel
    result = preLimit + postLimit + singleFile  
    
    # return the max number of files
    return(result)
