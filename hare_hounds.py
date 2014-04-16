#   d-o-o
#  /|\|/|\
# d-o-o-o-r
#  \|/|\|/
#   d-o-o
# 
#
#   1-4-7   
#  /|\|/|\
# 0-2-5-8-10
#  \|/|\|/
#   3-6-9   

#import simplegui
#
#def draw_handler(canvas):
#    width = image.get_width()
#    height = image.get_height()
#    canvas.draw_image(image, (width / 2, height / 2), (width, height), (width / 2, height / 2), (width, height))
#
#image = simplegui.load_image('http://upload.wikimedia.org/wikipedia/commons/8/85/Hare_and_Hounds_board.png')
#
#frame = simplegui.create_frame('Testing', image.get_width(), image.get_height())
#frame.set_draw_handler(draw_handler)
#frame.start()

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

def hare_positions(hare, hounds):
    return [position for position in rules[(hare, True)] if position not in hounds]

def hound_positions(hare, hounds, hound):
    return [position for position in rules[(hound, False)] if (position not in hounds) and (position != hare)]

def hounds_positions(hare, hounds):
    moves = []
    for i in range(len(hounds)):
        for hound_move in hound_positions(hare, hounds, hounds[i]):
            hounds_move = hounds[:]
            hounds_move[i] = hound_move
            moves += [hounds_move]
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
    for i in range(1000):
        if simulate(hare, hounds, turn):
            score[0] += 1
        else:
            score[1] += 1
    return score

def play():
    hare = 10
    hounds = [0, 1, 3]

    you = raw_input('choose sides hare or hounds: ')
    while True:
        if you == 'hare':
            you = True
            break
        elif you == 'hounds':
            you = False
            break
        you = raw_input('choose sides hare or hounds: ')

    #turn = raw_input('first? yes or no: ')
    #while True:
    #    if turn == 'yes':
    #        turn = True
    #        break
    #    elif turn == 'no':
    #        turn = False
    #        break
    #    turn = raw_input('first? yes or no: ')
        
    turn = True
    print_board(hare, hounds)
    while True:
        if turn:
            if you:
                print '=====hounds====='
                move_score = {}
                for move in hounds_positions(hare, hounds):
                    move_score[score_simulate(hare, move, False)[1]] = move
                print move_score
                hounds = move_score[max(move_score.keys())]
                print_board(hare, hounds)
            else:
                print '======hounds======'
                hound = int(raw_input('choose hound: ' + str(hounds) + ': '))
                positions = hound_positions(hare, hounds, hound)
                while (hound not in hounds) or positions == []:
                    hound = int(raw_input('choose hound: ' + str(hounds) + ': '))
                    positions = hound_positions(hare, hounds, hound)
                position = int(raw_input('choose position: ' + str(positions) + ': '))
                while position not in positions:
                    position = int(raw_input('choose position: ' + str(positions) + ': '))
                hounds[hounds.index(hound)] = position
                print_board(hare, hounds)
            turn = False
        else:
            if you:
                print '======hare======'
                positions = hare_positions(hare, hounds)
                position = int(raw_input('choose position: ' + str(positions) + ': '))
                while position not in positions:
                    position = int(raw_input('choose position: ' + str(positions) + ': '))
                hare = position
                print_board(hare, hounds)
            else:
                print '=====hare====='
                move_score = {}
                for move in hare_positions(hare, hounds):
                    move_score[score_simulate(move, hounds, True)[0]] = move
                print move_score
                hare = move_score[max(move_score.keys())]
                print_board(hare, hounds)
            turn = True
                
        winer = who_win(hare, hounds)
        if winer != None:
            return winer

play()
