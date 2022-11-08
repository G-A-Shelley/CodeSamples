def countApplesAndOranges(s, t, a, b, apples, oranges):
    # Write your code here
    
    # Definitions
    # s = left side of the house
    # t = right side of the house
    # a = location of the apple tree
    # b = location of the orange tree
    # apples = distances of apple drops
    # oranges = distances of orange drops 
    
    # 1 < all values < 10^5
    # a < s < t < b
    
    # output values
    '''
    print("House {} {}".format(s,t))
    print("Apples {}".format(a))
    print("Oranges {}".format(b))
    print("Apple drops {}".format(apples))
    print("Orange drops {}".format(oranges))
    '''
    
    # counting function 
    def CheckDrops(left,right,start,drops):
      
      # left = left side of the house
      # right = right side of the house
      # start = srat position of the tree dropping fruit
      # drops = list of fruit drop values from their starting poing
      
      counter = 0 # counter for fruits that land of the house
      
      # iterate through the fruit drops list
      for drop in drops:
        # set teh hposition of the fruit drops
        position = start + drop
        # determine if the drop position is on the house and incerment counter
        if position >= left and position <= right:
          counter += 1
      return counter
    
    # output apple and orange drop values
    print(CheckDrops(s,t,a,apples))
    print(CheckDrops(s,t,b,oranges))