import java.util.Map;
import java.util.Arrays;

HashMap<Integer, IntList> hare_rules;
HashMap<Integer, IntList> hound_rules;
IntList xlist, ylist;


int hare;
IntList hounds;
boolean you;
boolean turn;
PImage img_grid, img_hare, img_hound;
/*
  while (true)
 {
 if (keyPressed) 
 {
 if (key == 'r') 
 {
 you = true;
 break;
 }
 else if (key == 'd')
 {
 you = false;
 break;
 }
 println("choose sides hare(r) or hounds(d): ");
 }
 } 
 */

void setup() {

  you = false;

  turn = true;

  hare = 10;
  hounds = new IntList(Arrays.asList(0, 1, 3));

  hare_rules = new HashMap<Integer, IntList>();

  hare_rules.put(0, new IntList(Arrays.asList(1, 2, 3)));
  hare_rules.put(1, new IntList(Arrays.asList(0, 2, 4, 5)));
  hare_rules.put(2, new IntList(Arrays.asList(0, 1, 3, 5)));
  hare_rules.put(3, new IntList(Arrays.asList(0, 2, 5, 6)));
  hare_rules.put(4, new IntList(Arrays.asList(1, 5, 7)));
  hare_rules.put(5, new IntList(Arrays.asList(1, 2, 3, 4, 6, 7, 8, 9)));
  hare_rules.put(6, new IntList(Arrays.asList(3, 5, 9)));
  hare_rules.put(7, new IntList(Arrays.asList(4, 5, 8, 10)));
  hare_rules.put(8, new IntList(Arrays.asList(5, 7, 9, 10)));
  hare_rules.put(9, new IntList(Arrays.asList(5, 6, 8, 10)));
  hare_rules.put(10, new IntList(Arrays.asList(7, 8, 9)));
  hound_rules = new HashMap<Integer, IntList>();
  hound_rules.put(0, new IntList(Arrays.asList(1, 2, 3)));
  hound_rules.put(1, new IntList(Arrays.asList(2, 4, 5)));
  hound_rules.put(2, new IntList(Arrays.asList(1, 3, 5)));
  hound_rules.put(3, new IntList(Arrays.asList(2, 5, 6)));
  hound_rules.put(4, new IntList(Arrays.asList(5, 7)));
  hound_rules.put(5, new IntList(Arrays.asList(4, 6, 7, 8, 9)));
  hound_rules.put(6, new IntList(Arrays.asList(5, 9)));
  hound_rules.put(7, new IntList(Arrays.asList(8, 10)));
  hound_rules.put(8, new IntList(Arrays.asList(7, 9, 10)));
  hound_rules.put(9, new IntList(Arrays.asList(8, 10)));
  hound_rules.put(10, new IntList());
 
  xlist = new IntList(Arrays.asList(20, 155, 155, 155, 290, 290, 290, 425, 425, 425, 560));
  ylist = new IntList(Arrays.asList(135, 15, 135, 255,  15, 135, 255,  15, 135, 255, 135));
  
  
  img_grid = loadImage("grid.png");
  img_hare = loadImage("hare.png");
  img_hound = loadImage("hound.png");
  println(img_grid.width, img_grid.height);
  println(img_hare.width, img_hare.height);
  println(img_hound.width, img_hound.height);
  size(img_grid.width, img_grid.height);
}

void draw() {
  image(img_grid, 0, 0);
  image(img_hare, xlist.get(hare), ylist.get(hare));
  for (int i = 0; i < 3; i++)
  {
    image(img_hound, xlist.get(hounds.get(i)), ylist.get(hounds.get(i)));
  }
}
/*
  print_board(hare, hounds);
 
 while (true)
 {
 if (turn)
 {
 if (you)
 {
 println("=====hounds=====");
 HashMap<Integer, IntList> move_score = new HashMap<Integer, IntList>();
 //for move in hounds_positions(hare, hounds)
 //{
 //  move_score[score_simulate(hare, move, False)[1]] = move
 //}
 //println(move_score);
 //hounds = move_score[max(move_score.keys())];
 //print_board(hare, hounds)
 }
 else
 {
 println("======hounds======");
 //hound = int(raw_input('choose hound: ' + str(hounds) + ': '))
 //positions = hound_positions(hare, hounds, hound)
 //while (hound not in hounds) or positions == []
 //{
 //  hound = int(raw_input('choose hound: ' + str(hounds) + ': '))
 //  positions = hound_positions(hare, hounds, hound)
 //  position = int(raw_input('choose position: ' + str(positions) + ': '))
 //}
 //while position not in positions
 //{
 //  position = int(raw_input('choose position: ' + str(positions) + ': '))
 //}
 //hounds[hounds.index(hound)] = position
 //print_board(hare, hounds)
 }
 turn = false;
 }
 else
 {
 if (you)
 {
 println("======hare======");
 //positions = hare_positions(hare, hounds)
 //position = int(raw_input('choose position: ' + str(positions) + ': '))
 //while position not in positions
 //{
 //  position = int(raw_input('choose position: ' + str(positions) + ': '))
 //}
 //hare = position
 //print_board(hare, hounds)
 }
 else
 {
 println("=====hare=====");
 //move_score = {}
 //for move in hare_positions(hare, hounds)
 //{
 //          move_score[score_simulate(move, hounds, True)[0]] = move
 //}
 //hare = move_score[max(move_score.keys())]
 //print_board(hare, hounds)
 }
 turn = true;
 }             
 //winer = who_win(hare, hounds)
 //if (winer != None)
 //{
 //  return winer
 //}
 }
 */
// We can also access values by their key
//int[] val = hare_rules.get(1);
//println("1 is " + val[0]);

