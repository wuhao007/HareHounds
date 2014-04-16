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
float radius;
boolean move_hare;

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

  img_grid = loadImage("grid.png");
  img_hare = loadImage("hare.png");
  img_hound = loadImage("hound.png");
  
  radius = (img_hare.height + img_hare.width + img_hound.height + img_hound.width)/8;
  xlist = new IntList(Arrays.asList(57, 192, 192, 192, 327, 327, 327, 462, 462, 462, 597));
  ylist = new IntList(Arrays.asList(172, 52, 172, 292, 52, 172, 292, 52, 172, 292, 172));

  size(img_grid.width, img_grid.height);
 
  move_hare = false;
}

void draw() {
  image(img_grid, 0, 0);
  image(img_hare, xlist.get(hare) - radius, ylist.get(hare) - radius);
  for (Integer i : hounds)
  {
    image(img_hound, xlist.get(i) - radius, ylist.get(i) - radius);
  }
  //image(img_hare, mouseX-img_hare.width/2, mouseY-img_hare.height/2);
  image(img_hound, 0, img_grid.height-img_hound.height);
  image(img_hare, img_grid.width-img_hare.width, img_grid.height-img_hare.height);
}

void mousePressed() {
  float disX;
  float disY;

  if (move_hare)
  {
    for (int i = 0; i < xlist.size(); i++)
    {
      disX = xlist.get(i) - mouseX;
      disY = ylist.get(i) - mouseY;
      if (hare_rules.get(hare).hasValue(i) && !hounds.hasValue(i) && (sqrt(sq(disX) + sq(disY)) < radius)) {
        hare = i;
        move_hare = false;
        return;
      }
    }
  }
  else
  {
    disX = radius - mouseX;
    disY = img_grid.height - radius - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < radius) {
      you = false;
      println("choose hounds");
      return;
    }

    disX = img_grid.width - radius - mouseX;
    disY = img_grid.height - radius - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < radius) {
      you = true;
      println("choose hare");
      return;
    } 

    disX = xlist.get(hare) - mouseX;
    disY = ylist.get(hare) - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < radius) {
      println("move hare");
      move_hare = true;
      return;
    }
  }
}

