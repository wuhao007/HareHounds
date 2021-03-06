import java.util.Map;
import java.util.Arrays;
import java.util.Random;

/**
 * Artificial Intelligence A Modern Approach (3rd Ed.): Page 173.<br>
 * 
 * <pre>
 * <code>
 * function ALPHA-BETA-SEARCH(state) returns an action
 *   v = MAX-VALUE(state, -infinity, +infinity)
 *   return the action in ACTIONS(state) with value v
 *   
 * function MAX-VALUE(state, alpha, beta) returns a utility value
 *   if TERMINAL-TEST(state) then return UTILITY(state)
 *   v = -infinity
 *   for each a in ACTIONS(state) do
 *     v = MAX(v, MIN-VALUE(RESULT(s, a), alpha, beta))
 *     if v >= beta then return v
 *     alpha = MAX(alpha, v)
 *   return v
 *   
 * function MIN-VALUE(state, alpha, beta) returns a utility value
 *   if TERMINAL-TEST(state) then return UTILITY(state)
 *   v = infinity
 *   for each a in ACTIONS(state) do
 *     v = MIN(v, MAX-VALUE(RESULT(s,a), alpha, beta))
 *     if v <= alpha then return v
 *     beta = MIN(beta, v)
 *   return v
 * </code>
 * </pre>
 * 
 * Figure 5.7 The alpha-beta search algorithm. Notice that these routines are
 * the same as the MINIMAX functions in Figure 5.3, except for the two lines in
 * each of MIN-VALUE and MAX-VALUE that maintain alpha and beta (and the
 * bookkeeping to pass these parameters along).
 * 
 * @author Ruediger Lunde
 * 
 * @param <STATE>
 *            Type which is used for states in the game.
 * @param <ACTION>
 *            Type which is used for actions in the game.
 * @param <PLAYER>
 *            Type which is used for players in the game.
 */
 
HashMap<Integer, IntList> hare_rules;
HashMap<Integer, IntList> hound_rules;
IntList xlist, ylist;

int hare, hound;
int radius;
IntList hounds;
PImage img_grid, img_hare, img_hound;
int depth;

boolean you;
boolean you_move;
boolean stop;
int max_depth, num_nodes, max_pruning, min_pruning;

//HashMap<Integer, Integer> hare_best_move;
int hare_best_move;
//HashMap<Integer, IntList> hounds_best_move;
int hound_best_index;
int hound_best_move;
int total_hounds_countdown;
int total_depth;
//PrintWriter output;
Random random;

//initial the state of hare and hounds
void setup() {
  you = false; 
  you_move = true; //used for change state
  stop = false; //used for change state
  random = new Random(); //used for evalation function
  //output = createWriter("positions.txt"); 
  total_depth = 10; // search depth

  hounds = new IntList(Arrays.asList(0, 1, 3)); //hounds initial state
  default_setting();
  //hare_best_move = new HashMap<Integer, Integer>();
  //hounds_best_move = new HashMap<Integer, IntList>();
  //hounds_best_move = new IntList();
  total_hounds_countdown = 10; //If the hounds move vertically ten times in a row, they are considered to be "stalling" and the hare wins

  // use hash table to find the next state of hare
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

// use hash table to find the next state of hounds
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

//draw the board, hare and hounds
void draw() {
  image(img_grid, 0, 0);
  if (!stop)
  { 
    gameover();
  } 
  if (!stop && !you_move )
  {
    max_depth = 0; 
    num_nodes = 0;
    max_pruning = 0;
    min_pruning = 0;
    if (you)
    {
      println("=====hounds=====");
      //println(hare, hounds, " to draw");
      //ArrayList<IntList> hounds_moves = hounds_next_positions(hare, hounds);
      //println(hounds_moves);
      playMax(-2, 2, hare, hounds, total_hounds_countdown, 0);
      int a = hounds.get(hound_best_index);
      int b = hound_best_move;
      //println("hounds best", a);
      //println("hounds best move ", b);
      //hounds = hounds_moves.get(int(random(hounds_moves.size())));
      //hounds = hounds_best_move.get(int_key)
      if (get_col(a) == get_col(b))
      {
        total_hounds_countdown--;
      }
      hounds.set(hound_best_index, hound_best_move);
      //println(hounds_moves, hounds);
    }
    else {
      println("=====hare=====");
      //println(hare, hounds, " to draw");
      //IntList hare_moves = hare_next_positions(hare, hounds);
      playMax(-2, 2, hare, hounds, total_hounds_countdown, 0);
      //println("hare best move", hare_best_move);
      //hare = hare_moves.get(int(random(hare_moves.size())));
      //hare = hare_best_move.get(int_key);
      hare = hare_best_move;
      //println(hare_moves, hare);
    }
    you_move = true;

    println("maximum depth of game tree ", max_depth);
    println("total number of nodes generated ", num_nodes);
    println("number of times pruning occurred within the MAX-VALUE function ", max_pruning);
    println("number of times pruning occurred within the MIN-VALUE function ", min_pruning);
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

//use mouse to move hare and hounds and change sides
void mousePressed() 
{
  if (!stop)
  {
    if (you)
    {

      if (overCircle(xlist.get(hare), ylist.get(hare))) {
        println("=====choose hare=====");
        you_move = true;
        return;
      }

      if (you_move)
      {
        println("=====move hare=====");
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
          println("=====choose hound=====", one);
          you_move = true;
          hound = one;
          return;
        }
      }

      if (you_move)
      {
        println("=====move hound=====");
        for (int move : hound_next_positions(hare, hounds, hound))
        {
          if (overCircle(xlist.get(move), ylist.get(move))) 
          {

            if (get_col(hound) == get_col(move))
            {
              total_hounds_countdown--;
            }
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
    stop = false;
    default_setting();
    println("=====choose hare side=====");
    return;
  }
  if (overCircle(radius, img_grid.height - radius)) {
    you = false;
    you_move = true;
    stop = false;
    default_setting();
    println("=====choose hounds side=====");
    return;
  }
}

//the next state that hare can choose
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

//the next state that a hound can choose
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

//the next state that hounds can choose
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

//initial setting
void default_setting()
{
  hare = 10;
  hounds.set(0, 0);
  hounds.set(1, 1);
  hounds.set(2, 3);
  total_hounds_countdown = 10;
}

//move hare and hounds and change sides
boolean overCircle(int x, int y)
{
  return sqrt(sq(x - mouseX) + sq(y - mouseY)) < radius;
}

//max beta
//min alpha
//[beta, alpha]
/*
boolean cutoff_test(int winner, int depth)
 {
 if (winner != 0 || depth > total_depth)
 {
 println("depth is ", depth);
 return true;
 }
 else
 {
 return false;
 }
 }
 */

//monte carlo simulation
int simulate(int hare_position, IntList hounds_position, int hounds_countdown, boolean side)
{
  int winner = who_win(hare_position, hounds_position, hounds_countdown);
  if (winner != 0) 
  {
    return winner;
  }
  else
  {
    if (side)
    {
      ArrayList<IntList> hounds_choose_positions = hounds_next_positions(hare_position, hounds_position);
      IntList hounds_choose_position = hounds_choose_positions.get(random.nextInt(hounds_choose_positions.size()));
      if (same_col(hounds_position, hounds_choose_position))
      {
        return simulate(hare_position, hounds_choose_position, hounds_countdown - 1, !side);
      }
      else
      {
        return simulate(hare_position, hounds_choose_position, hounds_countdown, !side);
      }
    }
    else
    {
      IntList hare_choose_positions = hare_next_positions(hare_position, hounds_position);
      return simulate(hare_choose_positions.get(random.nextInt(hare_choose_positions.size())), hounds_position, hounds_countdown, !side);
    }
  }
}

//evalation function it use monte carlo
double eval_fn(int hare_position, IntList hounds_position, int hounds_countdown, boolean side)
{
  int computer_side = 0;
  for (int i = 0; i < 10; i++)
  {
    if (simulate(hare_position, hounds_position, hounds_countdown, side) == 1)
    {
      computer_side++;
    }
  }
  //println(computer_side/10.0);
  return computer_side/10.0;
}

//alpha and beta search algorithm max step
double playMax(double alpha, double beta, int hare_position, IntList hounds_position, int hounds_countdown, int depth)
{
  if (max_depth < depth)
  {
    max_depth = depth;
  }
  num_nodes++;
    
  int winner = who_win(hare_position, hounds_position, hounds_countdown);
  //output.println("max depth " + depth + " position: " + hare_position + " " + hounds_position + " winner:" + winner);
  if (winner != 0)
  {
    return winner;
  }
  else if (depth > total_depth)
  {
    //return 0;
    return eval_fn(hare_position, hounds_position, hounds_countdown, you);
  }

  //println("max ", hare_position, hounds_position, alpha, beta);
  int int_key = convert_key(hare_position, hounds_position);
  double value = -2;
  if (you)
  {
    for (IntList move : hounds_next_positions(hare_position, hounds_position))
    {
      int countdown = hounds_countdown;
      if (same_col(hounds_position, move))
      {
        countdown--;
      }
      double one_step_value = playMin(alpha, beta, hare_position, move, countdown, depth + 1);
      //println("move:", hare_position, hounds_position, " value:", one_step_value);
      if (value < one_step_value)
      {
        value = one_step_value;
        //hounds_best_move = move;
        if (depth == 0)
        {
          hound_best_index = get_hound_index(hounds_position, move);
          hound_best_move = move.get(hound_best_index);
        }
        //hounds_best_move.put(int_key, move);
      }
      if (value >= beta) 
      {
        max_pruning++;
        return value;
      }
      if (value > alpha) 
      {
        alpha = value;
      }
      /*
      if (value == 1)
       {
       return value;
       }
       */
    }
    return value;
  }
  else
  {
    for (int move : hare_next_positions(hare_position, hounds_position))
    {
      double one_step_value = playMin(alpha, beta, move, hounds_position, hounds_countdown, depth + 1);
      //println("move:", hare_position, hounds_position, " value:", one_step_value);
      if (value < one_step_value)
      {
        value = one_step_value;
        if (depth == 0)
        {
          hare_best_move = move;
        }
        //hare_best_move.put(int_key, move);
      }
      if (value >= beta) 
      {
        max_pruning++;
        return value;
      }
      if (value > alpha) 
      {
        alpha = value;
      }
      /*
      if (value == 1)
       {
       return value;
       }
       */
    }
    return value;
  }
}

//used this as the key of the map, same like hash table
int convert_key(int hare_position, IntList hounds_position)
{
  int int_key = hare_position;
  for (int hound_position : hounds_position)
  {
    int_key = int_key * 11 + hound_position;
  }
  return int_key;
}


//alpha and beta search algorithm min step
double playMin(double alpha, double beta, int hare_position, IntList hounds_position, int hounds_countdown, int depth)
{
  if (max_depth < depth)
  {
    max_depth = depth;
  }
  num_nodes++;
  
  int winner = who_win(hare_position, hounds_position, hounds_countdown);
  //output.println("min depth " + depth + " position: " + hare_position + " " + hounds_position + " winner:" + winner);
  if (winner != 0)
  {
    return winner;
  }
  else if (depth > total_depth)
  {
    //return 0;
    return eval_fn(hare_position, hounds_position, hounds_countdown, !you);
  }

  int int_key = convert_key(hare_position, hounds_position);
  double value = 2;
  //println("min ", hare_position, hounds_position, alpha, beta);
  if (you)
  {   
    for (int move : hare_next_positions(hare_position, hounds_position))
    {
      double one_step_value = playMax(alpha, beta, move, hounds_position, hounds_countdown, depth + 1);
      //println("move:", hare_position, hounds_position, " value:", one_step_value);
      if (value > one_step_value)
      {
        value = one_step_value;
        //hare_best_move = move;
        //hare_best_move.put(int_key, move);
      }
      if (value <= alpha) 
      {
        min_pruning++;
        return value;
      }
      if (value < beta) 
      {
        beta = value;
      }
      /*
      if (value == -1)
       {
       return value;
       }
       */
    }
    return value;
  }
  else
  {
    for (IntList move : hounds_next_positions(hare_position, hounds_position))
    {
      int countdown = hounds_countdown;
      if (same_col(hounds_position, move))
      {
        countdown--;
      }
      double one_step_value = playMax(alpha, beta, hare_position, move, countdown, depth + 1);
      //println("move:", hare_position, hounds_position, " value:", one_step_value);
      if (value > one_step_value)
      {
        value = one_step_value;
        //hounds_best_move = move;
        //hounds_best_move.put(int_key, move);
      }
      if (value <= alpha) 
      {
        min_pruning++;
        return value;
      }
      if (value < beta) 
      {
        beta = value;
      }
      /*
      if (value == -1)
       {
       return value;
       }
       */
    }
    return value;
  }
}

//get the collume, used for whether hounds move vertically
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

//if hounds move vertically, they in the same col
boolean same_col(IntList a, IntList b)
{
  int i = get_hound_index(a, b);
  if (i == -1)
  {
    return true;
  }
  else
  {    
    return get_col(a.get(i)) == get_col(b.get(i));
  }
}

//used for whether hounds move vertically 
int get_hound_index(IntList a, IntList b)
{
  for (int i = 0; i < a.size(); i++)
  {
    if (a.get(i) != b.get(i))
    {
      return i;
    }
  }
  return -1;
}

//check the winner of this game
int who_win(int hare_position, IntList hounds_position, int hounds_countdown)
{
  if (get_col(hare_position) <= get_col(hounds_position.min()))
  {    
    if (you)
    {   
      return -1;
    } 
    else 
    { 
      return 1;
    }
  }
  else if (hare_next_positions(hare_position, hounds_position).size() <= 0)
  {
    if (you)
    {   
      return 1;
    }
    else
    { 
      return -1;
    }
  }
  else if (hounds_countdown <= 0)
  {
    if (you)
    {   
      return -1;
    } 
    else 
    { 
      return 1;
    }
  }
  else
  {    
    return 0;
  }
}

// check whether the game is over
void gameover()
{
  int result = who_win(hare, hounds, total_hounds_countdown);
  if (result == -1)
  {
    println("=====you win=====");
    stop = true;
  }
  else if (result == 1)
  {
    println("=====computer win=====");
    stop = true;
  }
  else
  {    
    stop = false;
  }
}

// use up to change different levels of difficulty
void keyPressed() 
{
  if (key == CODED) 
  {
    if (keyCode == UP) 
    {
      total_depth++;
      println("levels of difficulty ", total_depth);
    } 
    else if (keyCode == DOWN) 
    {
      total_depth--;
      println("levels of difficulty ", total_depth);
    }
  } 
  else 
  {
    println("not code");
  }
}

