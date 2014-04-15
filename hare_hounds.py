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
    return [position for position in rules[(hare, True)] if position not in hounds]

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
    return moves
        
def who_win(hare, hounds):
    def get_col(position):
        if position == 0:
            return 0
        elif position in (1,2,3):
            return 1
        elif position in (4,5,6):
            return 2
        elif position in (7,8,9):
            return 3
        elif position == 10:
            return 4

    if get_col(hare) <= get_col(min(hounds)):
        #print '=====hare win====='
        return True
    elif hare_positions(hare, hounds) == []:
        #print '=====hounds win====='
        return False
    #elif hounds_positions(hare, hounds) == None:
    #    print '=====hare win====='
    #    return True 
    else:
        return None

import random
def simulate(hare, hounds, turn):
    #print_board(hare, hounds)
    while True:
        if turn:
            turn = False
            #print '======hare======'
            hare = random.choice(hare_positions(hare, hounds))
        else:
            turn = True
            #print '=====hounds====='
            hounds = random.choice(hounds_positions(hare, hounds))
        #print_board(hare, hounds)
        winer = who_win(hare, hounds)
        if winer != None:
            return winer

def score_simulate(hare, hounds, turn = False):
    score = [0, 0]
    for i in range(10000):
        if simulate(hare, hounds, turn):
            score[0] += 1
        else:
            score[1] += 1
    return score


def play():
    hare = 10
    hounds = [0, 1, 3]

    computer = True
    you = False
    if raw_input('choose sides: ') == 'hare':
        you = True
        computer = False

    turn = False
    if raw_input('turn: ') == 'true':
        turn = True

    print_board(hare, hounds)
    while True:
        if turn:
            if you:
                print '======hare======'
                hare = int(raw_input('choose position: '))
                print_board(hare, hounds)
            else:
                print '======hounds======'
                hound = int(raw_input('choose hound: '))
                hounds[hounds.index(hound)] = int(raw_input('choose position: '))
                print_board(hare, hounds)
            turn = False
        else:
            if computer:
                print '=====hare====='
                move_score = {}
                for move in hare_positions(hare, hounds):
                    move_score[score_simulate(move, hounds, True)[0]] = move
                print move_score
                hare = move_score[max(move_score.keys())]
                print_board(hare, hounds)
            else:
                print '=====hounds====='
                move_score = {}
                for move in hounds_positions(hare, hounds):
                    move_score[score_simulate(hare, move, False)[1]] = move
                print move_score
                hounds = move_score[max(move_score.keys())]
                print_board(hare, hounds)
            turn = True
                
        winer = who_win(hare, hounds)
        if winer != None:
            return winer


play()
