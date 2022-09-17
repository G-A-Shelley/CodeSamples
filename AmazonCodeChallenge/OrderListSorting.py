def sortOrders(orderList):
  # orderList = list of strings containing order information

  primeList   = list()  # list of prime orders
  nonList     = list()  # list of non prime orders
  returnList  = list()  # sorted order list to be returned  
  
  # iterate through the orders
  for order in orderList:
    order = order.split(" ",1)  # split individual orders into the identifier and the metadata
    # determine if the current order is a prime or non-prime order
    # prime metadata is alpha and non prime is numeric
    if order[1][1:2].isalpha():
      primeList.append(order) # add prime orders to the list
    else:
      nonList.append(order)   # add non prime orders to the list

  # function defintion to sort an order list 
  # independent of order type
  def sortItems(myList):
    # First iteration is though inital orders 
    # Second iteration is used to order from the current position to the start
    for i in range(len(myList)):
      for j in range(i,0,-1):
        check     = myList[j][1]    # current order to be check
        compare   = myList[j-1][1]  # order to compare against the check
        # determine if the check order is less than the comparison
        # swap orders when it is true
        if check < compare:
          myList[j],myList[j-1] = myList[j-1],myList[j]
        # determine if the check order is the same as the comparison
        # check to see if the identifier for check is less than the comparison
        # swap orders when it is true
        elif check == compare:
          if myList[j][0] < myList[j-1][0]:
            myList[j],myList[j-1] = myList[j-1],myList[j]
        else:
          break
    return(myList)

  # send the individual order lists to the function to be sorted 
  primeList = sortItems(primeList)
  nonList   = sortItems(nonList)

  # combine the identifiers and the metadata for the orders into a single string
  # add the orders to the return order list
  for item in primeList:
    returnList.append(item[0]+ " "+item[1])
  for item in nonList:
    returnList.append(item[0]+ " "+item[1])

  # return the updated list
  return(returnList)


# sample data 
orders = ["g5 94 27 234 91", "t2 13 121 98","r1 box ape bit","b4 xi me nu","br8 eat nim did","w1 has uni gry", "1 367 72 23", "2 586 234 12", "10 582 86 23"]
#orders = ["br8 eat nim did", "r1 box ape bit"]
#orders = ["r8 eat nim did","br8 eat nim did", "br7 eat nim did", "a7 eat nim did"]

results = sortOrders(orders)

for result in results:
  print(result)
