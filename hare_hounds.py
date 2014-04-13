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
( 0,True):(1,2,3),
( 1,True):(0,2,4,5),
( 2,True):(0,1,3,5),
( 3,True):(0,2,5,6),
( 4,True):(1,5,7),
( 5,True):(1,2,3,4,6,7,8,9),
( 6,True):(3,5,9),
( 7,True):(4,5,8,10),
( 8,True):(5,7,9,10),
(9,True):(5,6,8,10),
(10,True):(7,8,9),
( 0,False):(1,2,3),
( 1,False):(2,4,5),
( 2,False):(1,3,5),
( 3,False):(2,5,6),
( 4,False):(5,7),
( 5,False):(4,6,7,8,9),
( 6,False):(5,9),
( 7,False):(8,10),
( 8,False):(7,9,10),
( 9,False):(8,10),
(10,False):(),
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

def choose_move(moves):
    if moves != []:
        return random.choice(moves)
    else:
        return None

def hare_positions(hare, hounds):
   return choose_move([position for position in rules[(hare, True)] if position not in hounds])

def hounds_positions(hare, hounds):
    #hounds_moves = [[position for position in rules[(hound, False)] if position != hare] for hound in hounds]
    moves = []
    for i in range(len(hounds)):
        for hound_move in rules[(hounds[i], False)]:
            if (hound_move != hare) and (hound_move not in hounds):
                hounds_move = hounds[:]
                hounds_move[i] = hound_move
                moves += [hounds_move]
    #print 'S================================================='
    #for move in moves:
    #    print_board(hare, move)
    #print 'E================================================='
    return choose_move(moves)
        
def who_win(hare, hounds):
    if hare < min(hounds):
        print '=====hare win====='
        return True
    elif hare_positions(hare, hounds) == None:
        print '=====hounds win====='
        return True
    elif hounds_positions(hare, hounds) == None:
        print '=====hare win====='
        return True 
    else:
        return False

import random
def simulate():
    hare = 10
    hounds = [0,1,3]
    print_board(hare, hounds)
    while (who_win(hare, hounds) == False):
        print '=====hounds====='
        hounds = hounds_positions(hare, hounds)
        print_board(hare, hounds)
        if (who_win(hare, hounds)):
            break;

        print '======hare======'
        hare = hare_positions(hare, hounds)
        print_board(hare, hounds)
        if (who_win(hare, hounds)):
            break;

for i in range(10000):
    simulate()
#simulate()

