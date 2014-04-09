#   d-o-o
#  /|\|/|\
# d-o-o-o-True
#  \|/|\|/
#   d-o-o
# 
#
#     2-5-8   
#    /|\|/|\
#   1-3-6-9-11
#    \|/|\|/
#     4-7-10   
# 
rules = { 
( 1,True):[2,3,4],
( 2,True):[1,3,5,6],
( 3,True):[1,2,4,6],
( 4,True):[1,3,6,7],
( 5,True):[2,6,8],
( 6,True):[2,3,4,5,7,8,9,10],
( 7,True):[4,6,10],
( 8,True):[5,6,9,11],
( 9,True):[6,8,10,11],
(10,True):[6,7,9,11],
(11,True):[8,9,10],

( 1,False):[2,3,4],
( 2,False):[3,5,6],
( 3,False):[2,4,6],
( 4,False):[3,6,7],
( 5,False):[6,8],
( 6,False):[5,7,8,9,10],
( 7,False):[6,10],
( 8,False):[9,11],
( 9,False):[8,10,11],
(10,False):[9,11],
(11,False):[],
}
hare = 11
hounds = [1,2,4]

def trap(hare):
    moves = []
    for position in rules[(hare, True)]:
        if position not in hounds:
            moves += [position]
    return moves
moves = trap(hare)
while (hare != 1 or moves != []):
    hare = moves[0]
