import java.util.Map;
import java.util.Arrays;

HashMap<Integer, IntList> hare_rules;
HashMap<Integer, IntList> hound_rules;
IntList xlist, ylist;

int hare;
int hound;
IntList hounds;
boolean you;
boolean you_move;
PImage img_grid, img_hare, img_hound;
int radius;
boolean move_hare, move_hound, gameover;

HashMap<Integer, HashMap<IntList, Integer>> hare_record;
HashMap<Integer, HashMap<IntList, Integer>> hounds_record;

void setup() {
  you = false;
  you_move = true;

  default_setting();

  hare_record = new HashMap<Integer, HashMap<IntList, Integer>>();
  hounds_record = new HashMap<Integer, HashMap<IntList, Integer>>();

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

  img_grid = loadImage("grid.png");
  img_hare = loadImage("hare.png");
  img_hound = loadImage("hound.png");

  radius = (img_hare.height + img_hare.width + img_hound.height + img_hound.width)/8;
  xlist = new IntList(Arrays.asList(57, 192, 192, 192, 327, 327, 327, 462, 462, 462, 597));
  ylist = new IntList(Arrays.asList(172, 52, 172, 292, 52, 172, 292, 52, 172, 292, 172));

  size(img_grid.width, img_grid.height);
}

void draw() {
  image(img_grid, 0, 0);
  if (!gameover && who_win(hare, hounds) == 0 && !you_move )
  {
    if (you)
    {
      println("=====hounds=====");
      /*
       move_score = {}
       for move in hounds_positions(hare, hounds):
       move_score[score_simulate(hare, move, False)[1]] = move
       print move_score
       hounds = move_score[max(move_score.keys())]
       */
      ArrayList<IntList> hounds_moves = hounds_next_positions(hare, hounds);
      println(hounds_moves);
      hounds = hounds_moves.get(int(random(hounds_moves.size())));
      println(hounds_moves, hounds);
    }
    else {
      println("=====hare=====");
      /*
       move_score = {}
       for move in hare_next_positions():
       move_score[score_simulate(move, hounds, True)[0]] = move
       print move_score
       hare = move_score[max(move_score.keys())]
       */
      IntList hare_moves = hare_next_positions(hare, hounds);
      hare = hare_moves.get(int(random(hare_moves.size())));
      println(hare_moves, hare);
    }
    you_move = true;
  }
  image(img_hare, xlist.get(hare) - radius, ylist.get(hare) - radius);
  for (int i : hounds)
  {
    image(img_hound, xlist.get(i) - radius, ylist.get(i) - radius);
  }
  //image(img_hare, mouseX-img_hare.width/2, mouseY-img_hare.height/2);
  image(img_hound, 0, img_grid.height-img_hound.height);
  image(img_hare, img_grid.width-img_hare.width, img_grid.height-img_hare.height);
}

void mousePressed() 
{
  if (!gameover)
  {
    if (you)
    {

      if (overCircle(xlist.get(hare), ylist.get(hare))) {
        println("move hare");
        you_move = true;
        return;
      }

      if (you_move)
      {
        println("=====hare=====");
        for (int move : hare_next_positions(hare, hounds))
        {
          if (overCircle(xlist.get(move), ylist.get(move))) {
            hare = move;
            you_move = false;
            return;
          }
        }
      }
    }
    else
    {
      for (int one : hounds)
      {
        if (overCircle(xlist.get(one), ylist.get(one))) {
          println("move hound", one);
          you_move = true;
          hound = one;
          return;
        }
      }

      if (you_move)
      {
        println("=====hounds=====");
        for (int move : hound_next_positions(hare, hounds, hound))
        {
          if (overCircle(xlist.get(move), ylist.get(move))) 
          {
            hounds.set(hounds.index(hound), move);
            you_move = false;
            return;
          }
        }
      }
    }
  }
  if (overCircle(img_grid.width - radius, img_grid.height - radius)) 
  {
    you = true;
    you_move = false;
    default_setting();
    println("choose hare");
    return;
  }
  if (overCircle(radius, img_grid.height - radius)) {
    you = false;
    you_move = true;
    default_setting();
    println("choose hounds");
    return;
  }
}

IntList hare_next_positions(int hare_position, IntList hounds_position)
{
  IntList moves = new IntList();
  for (int move : hare_rules.get(hare_position))
  {
    if (!hounds_position.hasValue(move))
    {
      moves.append(move);
    }
  }
  return moves;
}

IntList hound_next_positions(int hare_position, IntList hounds_position, int one)
{
  IntList moves = new IntList();
  for (int move : hound_rules.get(one))
  {
    if (move != hare_position && !hounds_position.hasValue(move))
    {
      moves.append(move);
    }
  }
  return moves;
}

ArrayList<IntList> hounds_next_positions(int hare_position, IntList hounds_position)
{
  ArrayList<IntList> moves = new ArrayList<IntList>();
  for (int i = 0; i < hounds_position.size(); i++)
  {   
    for (int move : hound_next_positions(hare_position, hounds_position, hounds_position.get(i)))
    {
      IntList hounds_move = new IntList(hounds_position);
      hounds_move.set(i, move);
      moves.add(hounds_move);
    }
  }
  println(moves);
  return moves;
}

void default_setting()
{
  hare = 10;
  hounds = new IntList(Arrays.asList(0, 1, 3));
  gameover = false;
}

boolean overCircle(int x, int y)
{
  return sqrt(sq(x - mouseX) + sq(y - mouseY)) < radius;
}

void play()
{
  if (you_move)
  {
    playMax(-2, 2, hare, hounds);
  }
  else
  {
    playMin(-2, 2, hare, hounds);
  }
}

//max beta
//min alpha
//[beta, alpha]
int playMax(int alpha, int beta, int hare_position, IntList hounds_position)
{
  if (hare_record_key(hare_position, hounds_position))
  {
    return hare_record_value(hare_position, hounds_position);
  }
  else
  {
    value = -2;
    if (you)
    {
      for (int move : hare_next_positions(hare_position, hounds_position))
      {
        value = max(value, playMin(alpha, beta, move, hounds_position));
        if (value > beta) 
        {
          return hare_record_value(hare_position, hounds_position);
        }
        if (value > alpha) 
        {
          alpha = value;
        }
      }
      return hare_record_value(hare_position, hounds_position);
    }
    else
    {
    }
  }
}

boolean record_key(HashMap<Integer, HashMap<IntList, Integer>> record, int hare_position, IntList hounds_position)
{
  return record.containsKey(hare_position) && record.get(hare_position).containsKey(hounds_position)
}

boolean record_value(HashMap<Integer, HashMap<IntList, Integer>> record, int hare_position, IntList hounds_position)
{
  value = new HashMap<IntList, Integer>()
  record.put(hare_position, )
  IntList node = new IntList(hounds_position);
  node.append(hare_position);
}

int playMin(int alpha, int beta, int hare, int hounds)
{
  int score = who_win();
  if (score == 0)
  { 
    int value = 2;
    var children = successors(node);
    for (var i = 0; i <children.length; i++) {
      var child = children[i];
      value = min(value, playMax(alpha, beta, child));
      if (value <alpha) return record(node, value);
      if (value < beta) beta = value;
    }
    return record(node, value);
  }
  else
  {   
    return score;
  }
}

int get_col(int position)
{
  if (position == 0)
  {
    return 0;
  }
  else if (position == 1 || position == 2 || position == 3)
  {
    return 1;
  }
  else if (position == 4 || position == 5 || position == 6)
  {
    return 2;
  }
  else if (position == 7 || position == 8 || position == 9)
  {
    return 3;
  }
  else if (position == 10)
  {
    return 4;
  }
  else
  {
    return -1;
  }
}

int who_win(int hare_position, IntList hounds_position)
{
  if (get_col(hare_position) <= get_col(hounds_position.min()))
  {
    println("=====hare win=====");
    gameover = true;
    return 1;
  }
  else if (hare_next_positions(hare_position, hounds_position).size() <= 0)
  {
    println("=====hounds win=====");
    gameover = true;
    return -1;
  }
  else
  {    
    return 0;
  }
}

