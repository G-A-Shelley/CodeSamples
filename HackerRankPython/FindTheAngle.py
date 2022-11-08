# Enter your code here. Read input from STDIN. Print output to STDOUT
if __name__ == '__main__':
  
  import math
  
  a = int(input().rstrip())
  b = int(input().rstrip())

  # returns the point in radians of point a b 
  tangent = math.atan2(a,b)
  # convert the radians to the degree value
  angle = round(math.degrees(tangent))
  # output formatted degree value
  print("{}{}".format(angle,chr(176)))
