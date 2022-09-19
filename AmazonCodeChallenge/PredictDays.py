def predictDays(day, k):
  # day = integer array of predicted rainfall values
  # k   = integer target number of days from the considered day

  # return and array of ideal days where index 0 is day 1
  # non increaasing rainfall for k days
  # non decresing for k days after 

  size      = len(day)  # number of days to evaluate
  idealDays = list()    # list of days to be returned
  check     = 0         # number of valied days checked per day
  
  # iterate through the days from k to size minus k
  for i in (range(k,size-k)):
    check = 0   # reset the chak value to zero for each new day
    # determine if for the current day 
    # day before and after are greater than equal
    if day[i-1] >= day[i] and day[i] <= day[i+1]:
      # iterate though the days before and after the current day by 1
      for j in range(k):
        # determine is the preceding days are decreasing or equal
        # determine if the days after are increasing or equal
        if day[i-j-1] >= day[i-j] and day[i+j] <= day[i+j+1]:
          check+=1  # increment the check days counter
        else:
          break # if the check of days does not meet criteria break the loop
        
    #determine if the check days is equal to the ideal day
    if check == k:
      idealDays.append(i+1) # add the curretn day to the ideal days list

  # return the list of ideal days
  return(idealDays)

# testing days to meet criteria
calendar  = [[1,0,0,0,1],2],[[1,0,1,0,1],1],[[1,1,1,1,1,1,1,1,1,1],3],[[3,2,2,2,3,4],2]

# expected results for the above
# [3]
# [2,4]
# [4,5,6,7]
# [3,4]

# testing for expected results 
for item in calendar:
  results = predictDays(item[0], item[1])
  for result in results:
    print(result, end=" ")
  print()


'''
Testcase1
day = [1,0,1,0,1]
k = 1
Output:
[2,4]

Testcase2
day = [1,0,0,0,1]
k = 2
Output:
[3]

Testcase3
day = [1,1,1,1,1,1,1,1,1,1]
k = 3
Output:
[4,5,6,7]

'''
