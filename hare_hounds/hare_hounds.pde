import java.util.Map;
import java.util.Arrays;

HashMap<Integer, IntList> hare_rules;
HashMap<Integer, IntList> hound_rules;
IntList xlist, ylist;

int hare, hound;
int radius;
IntList hounds;
PImage img_grid, img_hare, img_hound;


boolean you;
boolean you_move;
boolean gameover;

HashMap<Integer, Integer> hare_value;
HashMap<Integer, Integer> hare_best_move;
HashMap<Integer, Integer> hounds_value;
HashMap<Integer, IntList> hounds_best_move;

void setup() {
  you = false;
  you_move = true;

  default_setting();

  hare_value = new HashMap<Integer, Integer>();
  hounds_value = new HashMap<Integer, Integer>();
  hare_best_move = new HashMap<Integer, Integer>();
  hounds_best_move = new HashMap<Integer, IntList>();

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
      println(hare, hounds, " to draw");
      ArrayList<IntList> hounds_moves = hounds_next_positions(hare, hounds);
      println(hounds_moves);
      IntList max_stack = new IntList();
      int int_key = convert_key(hare, hounds);
      max_stack.append(int_key);
      playMax(-2, 2, hare, hounds, max_stack, new IntList());
      //hounds = hounds_moves.get(int(random(hounds_moves.size())));
      hounds = hounds_best_move.get(int_key);
      //println(hounds_moves, hounds);
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
      println(hare, hounds, " to draw");
      IntList hare_moves = hare_next_positions(hare, hounds);
      IntList max_stack = new IntList();
      int int_key = convert_key(hare, hounds);
      max_stack.append(int_key);
      playMax(-2, 2, hare, hounds, max_stack, new IntList());
      //hare = hare_moves.get(int(random(hare_moves.size())));
      hare = hare_best_move.get(int_key);
      //println(hare_moves, hare);
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
  //println(moves);
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
    playMax(-2, 2, hare, hounds, new IntList(), new IntList());
  }
  else
  {
    playMin(-2, 2, hare, hounds, new IntList(), new IntList());
  }
}

//max beta
//min alpha
//[beta, alpha]
int playMax(int alpha, int beta, int hare_position, IntList hounds_position, IntList max_stack, IntList min_stack)
{
  int int_key = convert_key(hare_position, hounds_position);
  int winner = who_win(hare_position, hounds_position);

  println("max ", hare_position, hounds_position, alpha, beta);
  if (you)
  {
    if (hounds_value.containsKey(int_key))
    {
      return hounds_value.get(int_key);
    }
    else if (winner != 0)
    {
      hounds_value.put(int_key, winner);
      return winner;
    }
    else 
    {
      int value = -2;
      for (IntList move : hounds_next_positions(hare_position, hounds_position))
      {
        int child = convert_key(hare_position, move);
        if (max_stack.hasValue(child))
        {
          continue;
        }
        max_stack.append(child);
        int one_step_value = playMin(alpha, beta, hare_position, move, max_stack, min_stack);
        if (value < one_step_value)
        {
          value = one_step_value;
          hounds_best_move.put(int_key, move);
        }
        if (value >= beta) 
        {
          hounds_value.put(int_key, value);
          return value;
        }
        if (value > alpha) 
        {
          alpha = value;
        }
        if (value == 1)
        {
          return value;
        }
      }
      hounds_value.put(int_key, value);
      return value;
    }
  }
  else
  {
    if (hare_value.containsKey(int_key))
    {
      return hare_value.get(int_key);
    }
    else if (winner != 0)
    {
      hare_value.put(int_key, winner);
      return winner;
    }
    else 
    {
      int value = -2;
      for (int move : hare_next_positions(hare_position, hounds_position))
      {
        int child = convert_key(move, hounds_position);
        if (max_stack.hasValue(child))
        {
          continue;
        }
        max_stack.append(child);
        int one_step_value = playMin(alpha, beta, move, hounds_position, max_stack, min_stack);

        if (value < one_step_value)
        {
          value = one_step_value;
          hare_best_move.put(int_key, move);
        }
        if (value >= beta) 
        {
          hare_value.put(int_key, value);
          return value;
        }
        if (value > alpha) 
        {
          alpha = value;
        }
        if (value == 1)
        {
          return value;
        }
      }
      hare_value.put(int_key, value);
      return value;
    }
  }
}

int convert_key(int hare_position, IntList hounds_position)
{
  int int_key = hare_position;
  for (int hound_position : hounds_position)
  {
    int_key = int_key * 11 + hound_position;
  }
  return int_key;
}

int playMin(int alpha, int beta, int hare_position, IntList hounds_position, IntList max_stack, IntList min_stack)
{
  int int_key = convert_key(hare_position, hounds_position);
  int winner = who_win(hare_position, hounds_position);

  println("min ", hare_position, hounds_position, alpha, beta);
  if (you)
  {
    if (hare_value.containsKey(int_key))
    {
      return hare_value.get(int_key);
    }
    else if (winner != 0)
    {
      hare_value.put(int_key, winner);
      return winner;
    }
    else 
    {
      int value = 2;
      for (int move : hare_next_positions(hare_position, hounds_position))
      {
        int child = convert_key(move, hounds_position);
        if (min_stack.hasValue(child))
        {
          continue;
        }
        min_stack.append(child);
        int one_step_value = playMax(alpha, beta, move, hounds_position, max_stack, min_stack);
        if (value > one_step_value)
        {
          value = one_step_value;
          hare_best_move.put(int_key, move);
        }
        if (value <= alpha) 
        {
          hare_value.put(int_key, value);
          return value;
        }
        if (value < beta) 
        {
          beta = value;
        }
        if (value == -1)
        {
          return value;
        }
      }
      hare_value.put(int_key, value);
      return value;
    }
  }
  else
  {
    if (hounds_value.containsKey(int_key))
    {
      return hounds_value.get(int_key);
    }
    else if (winner != 0)
    {
      hounds_value.put(int_key, winner);
      return winner;
    }
    else 
    {
      int value = 2;
      for (IntList move : hounds_next_positions(hare_position, hounds_position))
      {
        int child = convert_key(hare_position, move);
        if (min_stack.hasValue(child))
        {
          continue;
        }
        min_stack.append(child);
        int one_step_value = playMax(alpha, beta, hare_position, move, max_stack, min_stack);
        if (value > one_step_value)
        {
          value = one_step_value;
          hounds_best_move.put(int_key, move);
        }
        if (value >= alpha) 
        {
          hounds_value.put(int_key, value);
          return value;
        }
        if (value < beta) 
        {
          beta = value;
        }
        if (value == -1)
        {
          return value;
        }
      }
      hounds_value.put(int_key, value);
      return value;
    }
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
    if (you)
    {
      println("=====you win=====");
      return 1;
    } 
    else 
    {
      println("=====computer win=====");
      return -1;
    }
  }
  else if (hare_next_positions(hare_position, hounds_position).size() <= 0)
  {
    println("=====hounds win=====");
    gameover = true;
    if (you)
    {
      println("=====computer win=====");
      return -1;
    }
    else
    {
      println("=====you win=====");
      return 1;
    }
  }
  else
  {    
    return 0;
  }
}

