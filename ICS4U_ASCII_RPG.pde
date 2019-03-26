Map m;
int text_scalar;

int display_width;
int display_height;

PFont map_font;
PFont title_font;

Player player;

void setup() {
  fullScreen();
  //size(800, 600);
  text_scalar = 20;

  display_width = 48;
  display_height = 48;

  m = new Map(1000, 1000);

  player = new Player();
  player.setX(m.map_width/2);
  player.setY(m.map_height/2);

  map_font = createFont("courier", 24);
  title_font = createFont("Monotype Corsiva", 50);

  //print(player.getX(), player.getY());
}

void draw() {
  background(0);
  //background(238,238,238);
  fill(255, 255, 255);
  textFont(title_font);
  text("Ascii RPG", 25, 50);
  text("_________", 0, 50);
  int startX = player.getX() - (display_width/2);
  int startY = player.getY() - (display_height/2);

  int endX = player.getX() + (display_width/2);
  int endY = player.getY() + (display_height/2);
  //println(startX, startY, endX, endY);

  int xOff = 0;
  int yOff = 5;
  textFont(map_font);
  for (int y = startY; y < endY; y++) {
    for (int x = startX; x < endX; x++) {
      fill(0, 255, 0);
      if (player.getX() == x && player.getY() == y) {
        fill(0, 255, 255);
        text("@", xOff*text_scalar, yOff*text_scalar);
      } else {
        fill(m.getC(x, y));
        text(m.get(x, y), xOff*text_scalar, yOff*text_scalar);
      }
      xOff++;
    }
    yOff++;
    xOff = 0;
  }
}

void keyPressed() {
  int startX = player.getX() - (display_width/2);
  int startY = player.getY() - (display_height/2);

  int endX = player.getX() + (display_width/2);
  int endY = player.getY() + (display_height/2);
  if (keyCode == 87) {
    if (startY > 0) {
      player.setY(player.getY()-1);
    }
  }
  if (keyCode == 65) {
    if (startX > 0) {
      player.setX(player.getX()-1);
    }
  }
  if (keyCode == 83) {
    if (endY < m.map_height) {
      player.setY(player.getY()+1);
    }
  }
  if (keyCode == 68) {
    if (endX < m.map_width) {
      player.setX(player.getX()+1);
    }
  }
}
