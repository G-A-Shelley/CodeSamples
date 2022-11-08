matrix = [[112, 42, 83, 119], [56, 125, 56, 49], [15, 78, 101, 43], [62, 98, 114, 108]]


def MaxSum(matrix):
    # matrix = square 2D list of integers

    size = len(matrix)-1        # the number of list across the matrix
    half = int(len(matrix)/2)   # the mid point of the lists
    max_sum = 0                 # holds the calculated maximum sum

    # iterate through ranges for hlaf the width and depth of the matrix
    for i in range(half):   # rows
        for j in range(half):   # columns
            # find the maximum value of the corresponding index values and incerement the max_sum value
            maximum = max(matrix[i][j],matrix[i][size-j],matrix[size-i][j],matrix[size-i][size-j])
            max_sum += maximum 
    # print the calculated maximum sum value
    print(max_sum)

MaxSum(matrix)
