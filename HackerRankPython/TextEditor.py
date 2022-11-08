# Enter your code here. Read input from STDIN. Print output to STDOUT
if __name__ == '__main__':
  
  querries = int(input().strip()) # int value for number of querries to process
  document = list()               # list to hold text edits
  
  for i in range( querries):
    query   = input().strip().split() # full query list
    command = int(query[0])           # query command 
        
    # determine what command is being requested
    if command == 1:
      # appends the text to the string and add to document
      text = list(query[1])   # text to be added to the document 
      # determine if the document is empty
      if len(document) == 0:
        # add new text to the document
        document.append(text)
      else:
        # add the new text to the last entry and update the document
        document.append(list(document[-1]+text))
    elif command == 2:
      # delete the last K characters
      index = int(query[1]) # index for deleting characters
      text  = document[-1]  # last text entry
      text  = text[:-index]  # remove text rom the index to the end
      document.append(text) # update the document
    elif command == 3:
      index = int(query[1]) # index for ptining character
      print(document[-1][index-1])
      pass
    elif command == 4:
      # remove the last entry from the document
      document.pop()
    
  