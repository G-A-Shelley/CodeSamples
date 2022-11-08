# Enter your code here. Read input from STDIN. Print output to STDOUT
if __name__ == '__main__':

  import cmath  # cmath for complex numbers - polar values
  
  values  = complex(input().rstrip()) # input complex number 
  x,y     = cmath.polar(values)       # convert complex to polar coordinates
  
  # print the values
  print(x)
  print(y)
  
