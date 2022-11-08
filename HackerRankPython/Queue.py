# Enter your code here. Read input from STDIN. Print output to STDOUT
if __name__ == '__main__':
  
    total = int(input().strip()) # total number of instrustions to process
    
    # 1 = enqueue element
    # 2 = dequque element
    # 3 = print first element
    
    myQueue = list()
    
    # iterate through all of the inputs
    for item in range(total):
      
      values = input().rstrip().split()     # input values in a list       
      command = int(values[0])              # command values from the first element
        
      # determine what command is being executed
      if command == 1: # enqueue elements
        element = int(values[1])    # get element value to be added to the queue
        # determine if the queue is empty or has elements and enqueue
        if len(myQueue)==0:
          myQueue.append(element)
        else:
          myQueue.append(element) 
      elif command == 2: # dequeue elements
        myQueue.pop(0)  
      else: # print head element values 
        print(myQueue[0])  
