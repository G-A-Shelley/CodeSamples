def kangaroo(x1, v1, x2, v2):
  # two kangaroos jumping in a line to a specific point
  
  # x1 = kangaroo 1 starting point
  # x2 = kangaroo 2 starting point
  # v1 = kangaroo 1 jumping distance
  # v2 = kangaroo 2 jumping distance
  
  # determine if the 1st jump is greater than the 2nd  
  if v1 > v2:
    offset = x2-x1          # starting position offset distance
    gains = v1-v2           # distance gained on each jump 
    partial = offset%gains  # number of partial jumps required to land in the same place
    # determine if there are no partial jumpsand return YES
    if partial == 0:
      return("YES")
    
  # default return value of NO
  return("NO")