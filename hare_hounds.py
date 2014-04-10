#   d-o-o
#  /|\|/|\
# d-o-o-o-r
#  \|/|\|/
#   d-o-o
# 
#
#     1-4-7   
#    /|\|/|\
#   0-2-5-8-10
#    \|/|\|/
#     3-6-9   
# 
rules = { 
( 0,True):[1,2,3],
( 1,True):[0,2,4,5],
( 2,True):[0,1,3,5],
( 3,True):[0,2,5,6],
( 4,True):[1,5,7],
( 5,True):[1,2,3,4,6,7,8,9],
( 6,True):[3,5,9],
( 7,True):[4,5,8,10],
( 8,True):[5,7,9,10],
(9,True):[5,6,8,10],
(10,True):[7,8,9],
( 0,False):[1,2,3],
( 1,False):[2,4,5],
( 2,False):[1,3,5],
( 3,False):[2,5,6],
( 4,False):[5,7],
( 5,False):[4,6,7,8,9],
( 6,False):[5,9],
( 7,False):[8,10],
( 8,False):[7,9,10],
(9,False):[8,10],
(10,False):[],
}
def print_board(hare, hounds):
    positions = ['o']*11 
    positions[hare] = 'r'
    for hound in hounds:
        positions[hound] = 'd'
    print '  ' + positions[1] + '-' + positions[4] + '-' + positions[7]
    print ' /|\\|/|\\'
    print positions[0] + '-' + positions[2] + '-' + positions[5] + '-' + positions[8] + '-' + positions[10]
    print ' \\|/|\\|/'
    print '  ' + positions[3] + '-' + positions[6] + '-' + positions[9]
    print 

def trap(hare, hounds):
    moves = []
    for position in rules[(hare, True)]:
        if position not in hounds:
            moves += [position]
    return moves
import random
def simulate():
    hare = 10
    hounds = [0,1,3]
    moves = trap(hare, hounds)
    while (hare != 2 and moves != []):
        hare = random.choice(moves)
        print_board(hare, hounds)
        moves = trap(hare, hounds)
simulate()
