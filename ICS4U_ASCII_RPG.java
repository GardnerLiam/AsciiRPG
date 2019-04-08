import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 
import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ICS4U_ASCII_RPG extends PApplet {

/*
@Author: Liam Gardner
@Date: March 26, 2019
@Purpose: This is the 'run' class. I've every time I've had to actually go through everything here. 
*/



Map m;

float encounterPercentage = 0.0075f;
float bossEncounterPercentage = 0.001f;

int minLevelBossEncounter = 1;

ArrayList<FadingText> text = new ArrayList<FadingText>();

float move = 0.015f;

int seed = 0;

int text_scalar;

int display_width;
int display_height;

PFont map_font;
PFont title_font;

Player player;

boolean random_movement = false;
int decision = 0;
int counter = 0;

GameState gameState = new GameState();

Enemy enemy;
boolean enemyExists = false;

Button play;
Button load;
Button exit;

Button attack;
Button skill1;
Button skill2;
Button skill3;

Button Item_SNEAK;
Button Item_KILL;
Button Item_HEAL;
Button Item_WEAKEN;
Button Item_WATER;
Button Item_PANDORA;

FadingText saveText;

int deathResetCounter = 0;

boolean mute = false;

String[] characters = {"ha", "he", "hi", "ho", "fu", "ba", "be", "bi", "bo", "bu", "sa", "se", "shi", "so", "su", "ta", "te", "chi", "to", "tsu", "pa", "pe", "pi", "po", "pu", 
  "ka", "ke", "ki", "ko", "ku", "ra", "re", "ri", "ro", "ru", "ma", "me", "mi", "mo", "mu", "na", "ne", "ni", "no", "nu"};

int levelUpCounter = 0;
boolean dispSave = false;

Music menuMusic;
Music[] gameMusic;
int musicIndex = 0;

float timeStart = millis();

/*
@Name: createName
@Purpose: It'd suck if enemies were named 'slime #467' right? So I have hiragana style generated name!
@Type: takes a size and returns a name of said size
*/
public String createName(int size) {
  String name = "";
  for (int i = 0; i < size; i++) {
    name += characters[floor(random(0, characters.length))];
  }
  return name;
}

/*
@Name: setup
@Purpose: bare minimum initialization;
@type: No params -- return None
*/
public void setup() {
  
  if (seed == 0) {
    seed = millis();
    println(seed);
  }
  noiseSeed(seed);

  map_font = createFont("courier", 24);
  title_font = createFont("Monotype Corsiva", 50);
}
/*
@Name: Init
@Purpose: Initialize everything that could be initialized apart from the setup function
@Type: No params -- return None
*/
public void init() {
  menuMusic = new Music("menuMusic.mp3", this);
  gameMusic = new Music[6];
  gameMusic[0] = new Music("roamingMusic.mp3", this, false);
  gameMusic[1] = new Music("WindsOfStories.wav", this, false);
  gameMusic[2] = new Music("pathToLakeLand.mp3", this, false);
  gameMusic[3] = new Music("oldCityTheme.mp3", this, false);
  gameMusic[4] = new Music("September.wav", this, false);
  gameMusic[5] = new Music("Orchestra.wav", this, false);

  saveText = new FadingText("Saved.", width/2-100, height/2);
  saveText.setTextSize(100);

  play = new Button(width/2-100, height/2-200, 250, 100, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Play", 50, null);
  load = new Button(width/2-100, height/2, 250, 100, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Load", 50, null);
  exit = new Button(width/2-100, height/2+200, 250, 100, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Exit", 50, null);

  Item_SNEAK = new Button(100, 600, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Sneak", 50, null);
  Item_KILL = new Button(100, 700, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Kill", 50, null);
  Item_HEAL = new Button(100, 800, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Heal", 50, null);
  Item_WEAKEN = new Button(450, 600, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Weaken", 50, null);
  Item_WATER = new Button(450, 700, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Water", 50, null);
  Item_PANDORA = new Button(450, 800, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Pandora", 50, null);

  Item_SNEAK.itemButton = true;
  Item_KILL.itemButton = true;
  Item_HEAL.itemButton = true;
  Item_WEAKEN.itemButton = true;
  Item_WATER.itemButton = true;
  Item_PANDORA.itemButton = true;


  play.setTextPos(width/2-25, height/2-135);
  load.setTextPos(width/2-25, height/2+65);
  exit.setTextPos(width/2-25, height/2+265);

  Item_SNEAK.setTextPos(150, 635);
  Item_KILL.setTextPos(150, 735);
  Item_HEAL.setTextPos(150, 835);
  Item_WEAKEN.setTextPos(500, 635);
  Item_WATER.setTextPos(500, 735);
  Item_PANDORA.setTextPos(500, 835);

  play.allowChange = true;
  load.allowChange = true;
  exit.allowChange = true;

  play.menuButton = true;
  load.menuButton = true;
  exit.menuButton = true;

  m = new Map();

  player = new Player();
  player.setHealth(100);
  player.setX(0);
  player.setY(0);

  while (player.passive.type != Passive.MOUNTAIN_WALKING && m.getVal(player.getX(), player.getY()) > 0.625f) {
    player.setX(random(-1000, 1000));
    player.setY(random(-1000, 1000));
  }

  while (player.passive.type != Passive.WATER_WALKING && m.getVal(player.getX(), player.getY()) < 0.25f) {
    player.setX(random(-1000, 1000));
    player.setY(random(-1000, 1000));
  }

  attack = new Button(300, 300, 130, 30, 3, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Attack", 33, null);
  skill1 = new Button(300, 330, 130, 30, 3, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Heal", 33, player.skill1);
  skill2 = new Button(300, 360, 130, 30, 3, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "ATK+", 33, player.skill2);
  skill3 = new Button(300, 390, 130, 30, 3, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "ATK-", 33, player.skill3);

  attack.addPressedEffect(color(50, 50, 50), color(255, 255, 255), color(150, 150, 150));
  skill1.addPressedEffect(color(50, 50, 50), color(255, 255, 255), color(150, 150, 150));
  skill2.addPressedEffect(color(50, 50, 50), color(255, 255, 255), color(150, 150, 150));
  skill3.addPressedEffect(color(50, 50, 50), color(255, 255, 255), color(150, 150, 150));

  text_scalar = 20;

  display_width = 48;
  display_height = 48;

  gameState.setGameState(GameState.MENU);
}
/*
@Name: Draw loop
@Purpose: Draws the loading screen
@Type: Params none -- return none
*/
public void drawLoop() {
  int colorHue = floor(map(noise(mouseX/1000f, mouseY/1000f, (millis()-timeStart)/1000f), 0, 1, 0, 256));
  colorMode(HSB);
  textFont(title_font);
  textSize(100);
  fill(colorHue, 255, 255);
  text("Loading", width/2-150, height/2+25);
  rectMode(CORNERS);
  noFill();
  strokeWeight(map(noise((millis()-timeStart)/1000f), 0, 1, 1, 10));
  stroke(colorHue, 255, 255);
  rect(width/2-200, height/2-200, width/2+200, height/2+200, map(noise((millis()-timeStart)/1000f), 0, 1, 1, 100));
  rectMode(CORNER);
  colorMode(RGB);
}
/*
@Name: drawMap
@purpose: draw's the 48x48 character abomination that's meant to show where in the infinite plane of suffering you are.
@type: params none -- return none
*/
public void drawMap() {
  //println(startX, startY, endX, endY);

  int startX = -(display_width/2);
  int startY = -(display_height/2);

  int endX = (display_width/2);
  int endY = (display_height/2);

  int xOff = 0;
  int yOff = 5;
  textFont(map_font);
  for (int y = startY; y < endY; y++) {
    for (int x = startX; x < endX; x++) {
      fill(0, 255, 0);
      if (x == 0 && y == 0) {
        fill(0, 255, 255);
        text("@", xOff*text_scalar, yOff*text_scalar);
      } else {
        fill(m.getC(player.getX()+(x*move), player.getY()+(y*move)));
        text(m.get(player.getX()+(x*move), player.getY()+(y*move)), xOff*text_scalar, yOff*text_scalar);
      }
      xOff++;
    }
    yOff++;
    xOff = 0;
  }
}
/*
@Name: drawHealthBar
@Purpose: To continuously remind me to organize my functions, as this should go into the player class. Also to draw a healthbar during a fight
@Type: Params int (coordinates) -- return None
*/
public void drawHealthBar(int x, int y) {
  fill(255);
  textFont(map_font);
  text("Health: ", x, y-25);
  if (player.getHealth() > 50) {
    int from = color(0, 155, 0);
    int to = color(0, 255, 0);
    int newCol = lerpColor(from, to, (player.getHealth()/100f));
    fill(newCol);
  } else {
    int from = color(100, 0, 0);
    int to = color(255, 0, 0);
    int newCol = lerpColor(from, to, (player.getHealth()/100f));
    fill(newCol);
  }
  noStroke();

  rect(x, y, player.getHealth()*2, 30);
}
/*
@Name: createSave
@Purpose: This allows for the game to be saved and reloaded "oh shite I forgot to have inventory saves! DAMMIT!"
@Type: params None -- return None
*/
public void createSave() {
  String xmlData = "<root><world><seed>"+seed+"</seed></world><player><coordinates><x>"+player.x+"</x><y>"+player.y+"</y></coordinates><level>"+player.level+"</level><xp>"+player.xp+"</xp>" +
    "<health>";
  if (player.health < 50) {
    xmlData += Integer.toString(player.health);
  } else {
    xmlData += "100";
  }
  
  xmlData += "</health><passive>" + player.passive.type + "</passive>";
  xmlData += "<inventory>";
  xmlData += "<sneak>" + player.items.get(0) + "</sneak>";
  xmlData += "<kill>" + player.items.get(1) + "</kill>";
  xmlData += "<heal>" + player.items.get(2) + "</heal>";
  xmlData += "<weaken>" + player.items.get(3) + "</weaken>";
  xmlData += "<water>" + player.items.get(4) + "</water>";
  xmlData += "<pandora>" + player.items.get(5) + "</pandora>";
  xmlData += "</inventory>";
  xmlData += "</player></root>";

  XML xmlSave = parseXML(xmlData);
  saveXML(xmlSave, "save.xml");
}
/*
@Name: drawMoves
@Purpose: to uncluster my insanely clustured draw() function.
@Type: params None -- return None
*/
public void drawMoves() {
  attack.show();
  skill1.show();
  skill2.show();
  skill3.show();

  if (skill1.counter < 100) {
    skill1.counter++;
  }

  if (skill2.counter < 100) {
    skill2.counter++;
  }

  if (skill3.counter < 100) {
    skill3.counter++;
  }

  if (attack.counter < 100) {
    attack.counter++;
  }
}

/*
@Name: createEnemy
@Purpose: I honestly have no idea why I use this. this could've just been one repeated section in an if statement. or I could've included the 'boss' thing into this. I probably thought it would be easier this way...
@Type: params None -- return None
*/
public void createEnemy() {
  if (!enemyExists) {
    enemy = new Enemy(player);
    enemyExists = true;
  }
}
/*
@Name: DrawXPBar
@Purpose: there's this little grey rectangle that looks like it slowly fills up every time you win a fight. It's meant to show how much time and effort you've put in to the game.
@Type: params int(coordinates) -- return None
*/
public void drawXPBar(int x, int y) {
  fill(255);
  text("XP: ", x, y-25);
  float dxp = map(player.getXP(), 0, 100, 0, 200);
  fill(150);
  rect(x, y, 200, 30);
  fill(0, 255, 0);
  rect(x, y, dxp, 30);
}
/*
@Name: drawInventory
@purpose: To make use for the items that I've created poorly. Items were made like 4 hours ago and I wanted to take my friend out for lunch before his family came over so it's implemented terribly.
@type; params none -- return none
*/
public void drawInventory() {
  textFont(map_font);
  if (player.items.get(0) > 0) {
    Item_SNEAK.show();
  }
  if (player.items.get(1) > 0) {
    Item_KILL.show();
  }
  if (player.items.get(2) > 0) {
    Item_HEAL.show();
  }
  if (player.items.get(3) > 0) {
    Item_WEAKEN.show();
  }
  if (player.items.get(4) > 0) {
    Item_WATER.show();
  }
  if (player.items.get(5) > 0) {
    Item_PANDORA.show();
  }
}
/*
@Name: "The bane of my existence" --> also called draw
@purpose: this controlls what's on the screen, which means, it's like 201 lines of code and half of it's if statements
@type: params none -- return none
*/
public void draw() {
  background(0);
  fill(255, 255, 255);
  textFont(title_font);
  text("AsciiGAR", 25, 50);
  text("_________", 0, 50);
  if (gameState.getGameState() == GameState.LOADING) {
    drawLoop();
    if ((millis()-timeStart)/1000f > 10) {
      thread("drawLoop");
      init();
    }
  } else if (gameState.getGameState() == GameState.MENU) {

    if (!menuMusic.isPlaying()) {
      menuMusic.play();
    }

    play.show();
    load.show();
    exit.show();
  } else if (gameState.getGameState() == GameState.ROAMING) {
    if (menuMusic.isPlaying()) {
      menuMusic.stop();
    }
    if (!gameMusic[musicIndex].isPlaying()) {
      if (musicIndex == gameMusic.length-1) {
        musicIndex = 0;
      } else {
        musicIndex++;
      }
      gameMusic[musicIndex].play();
    }


    drawMap();
    drawHealthBar((display_width*display_width)/2, 200);
    drawXPBar((display_width*display_width)/2, 350);

    textFont(map_font);
    textSize(35);
    text("Level: " + player.getLevel(), (display_width*display_width)/2, 150);

    fill(255, 255, 255);
    if (player.passive.type == Passive.RETAIN_DAMAGE) {
      text("Passive Skill: Damage Retain", (display_width*display_width)/2, 450);
    } else if (player.passive.type == Passive.WATER_WALKING) {
      text("Passive Skill: Water Walking", (display_width*display_width)/2, 450);
    } else if (player.passive.type == Passive.MOUNTAIN_WALKING) {
      text("Passive Skill: Mountain Walking", (display_width*display_width)/2, 450);
    }
    if (random_movement) {
      if (counter == 100) {
        counter = 0;
      }
      if (counter == 0) {
        decision = floor(random(0, 4));
        counter++;
      } else {
        if (decision == 0) {
          player.setY(player.getY()-move);
        } 
        if (decision == 1) {
          player.setX(player.getX()+move);
        }  
        if (decision == 2) {
          player.setY(player.getY()+move);
        }  
        if (decision == 3) {
          player.setX(player.getX()-move);
        }
        counter++;
      }
    }
    if (m.getVal(player.x, player.y) < 0.25f && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
      gameState.setGameState(GameState.DEAD);
    }
    if (dispSave) {
      saveText.update();
      if (saveText.c <= 0) {
        saveText.x = width/2-100;
        saveText.y = height/2;
        saveText.c = 255;
        dispSave = false;
      }
    }
  } else if (gameState.getGameState() == GameState.FIGHTING) {
    if (menuMusic.isPlaying()) {
      menuMusic.stop();
    }
    //if (roamingMusic.isPlaying()) {
    //  roamingMusic.pause();
    //}

    drawInventory();
    drawHealthBar(300, 150);
    createEnemy();
    enemy.drawStats(width-300, 150);
    drawMoves();

    fill(255);
    text("Player Damage: " + player.getDamage(), 100, 500);


    for (FadingText ft : text) {
      if (ft.c > 0) {
        ft.update();
      }
    }

    if (player.health <= 0) {
      gameState.setGameState(GameState.DEAD);
    }

    if (enemy.health <= 0) {
      if (enemy.level < 3) {
        player.xp += 10*enemy.level;
      } else if (enemy.level < 5) {
        player.xp += 7.5f*enemy.level;
      } else if (enemy.level < 10) {
        player.xp += 5*enemy.level;
      } else {
        player.xp += enemy.level;
      }

      player.health = max(50, player.health);

      if (player.passive.type == Passive.RETAIN_DAMAGE) {
        if (player.level < 3) {
          player.setDamage(max(1, player.getDamage()/10));
        } else if (player.level < 5) {
          player.setDamage(max(1, player.getDamage()/5));
        } else if (player.level < 7) {
          player.setDamage(max(1, player.getDamage()/2));
        } else {
          player.setDamage(max(1, player.getDamage()));
        }
      } else {
        if (player.getLevel() < 1) {
          player.setDamage(1);
        } else {
          player.setDamage(player.getLevel());
        }
      }

      if (floor(random(0, Item.ITEMS)) > 0) {
        int id =  floor(random(0, Item.MAXITEMID));
        player.items.put(id, player.items.get(id)+1);
      }
      if (player.xp >= 100) {
        gameState.setGameState(GameState.LEVELUP);
      } else {
        gameState.setGameState(GameState.ROAMING);
      }
    }
  } else if (gameState.getGameState() == GameState.DEAD) {
    if (menuMusic.isPlaying()) {
      menuMusic.stop();
    }
    gameMusic[musicIndex].stop();
    musicIndex = 0;

    textFont(title_font);
    textSize(100);
    fill(255, 0, 0);
    text("YOU DIED", width/2-300, height/2);
    deathResetCounter ++;
    if (deathResetCounter >= 1000 || (deathResetCounter > 100 && mousePressed) ||(deathResetCounter > 100 && keyPressed)) {
      gameState.setGameState(GameState.MENU);
    }
  } else if (gameState.getGameState() == GameState.LEVELUP) {
    if (menuMusic.isPlaying()) {
      menuMusic.stop();
    }
    //if (roamingMusic.isPlaying()){
    //  roamingMusic.pause();
    //}

    textFont(title_font);
    textSize(100);
    fill(0, 255, 0);
    if (player.xp >= 100) {
      player.level++;
      player.xp = 0;
      player.health = 100;
    }
    text("You leveled up!", width/2-300, height/2-50);
    text("You're now level " + player.getLevel(), width/2-300, height/2+50);


    levelUpCounter+=1;
    if (levelUpCounter >= 1000) {
      gameState.setGameState(GameState.ROAMING);
      levelUpCounter = 0;
    }

    if ((levelUpCounter >= 100 && keyPressed) || (levelUpCounter >= 100 && mousePressed)) {
      gameState.setGameState(GameState.ROAMING);
      levelUpCounter = 0;
    }
  }
}

/*
@Name: keyPressed
@Purpose: so that you can move. otherwise you'd be paralyzed. Imagine if you were paralyzed and spawned in water. That'd suck.
@Type: params none -- return none
*/
public void keyPressed() {
  if (!random_movement) {
    if (gameState.getGameState() == GameState.ROAMING) {
      if (keyCode == 87) {
        float value = m.getVal(player.getX(), player.getY()-move);

        boolean shouldMove = true;

        if (value < 0.25f && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
          shouldMove = false;
          if (m.getVal(player.getX(), player.getY()) == 0) {
            gameState.setGameState(GameState.DEAD);
          }
        }
        if (value < 0.25f && player.waterWalkingSteps > 0) {
          player.waterWalkingSteps-= 1;
        }

        if (value > 0.625f && player.passive.type != Passive.MOUNTAIN_WALKING) {
          shouldMove = false;
        }


        if (shouldMove) {
          player.setY(player.getY()-move);
          if (player.sneakSteps > 0) {
            player.sneakSteps --;
          } else {
            if (random(0, 1) < encounterPercentage) {
              if (player.level >= minLevelBossEncounter && random(0, 1) < bossEncounterPercentage) {
                enemyExists = true;
                enemy = new Boss(player);
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
                println("BOSS");
              } else {
                enemyExists = false;
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
              }
            }
          }
        }
      }
      if (keyCode == 65) {
        float value = m.getVal(player.getX()-move, player.getY());

        boolean shouldMove = true;

        if (value < 0.25f && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
          shouldMove = false;
          if (m.getVal(player.getX(), player.getY()) == 0) {
            gameState.setGameState(GameState.DEAD);
          }
        }
        if (value < 0.25f && player.waterWalkingSteps > 0) {
          player.waterWalkingSteps-= 1;
        }

        if (value > 0.625f && player.passive.type != Passive.MOUNTAIN_WALKING) {
          shouldMove = false;
        }

        if (shouldMove) {
          player.setX(player.getX()-move);
          if (player.sneakSteps > 0) {
            player.sneakSteps--;
          } else {
            if (random(0, 1) < encounterPercentage) {
              if (player.level >= minLevelBossEncounter && random(0, 1) < bossEncounterPercentage) {
                enemyExists = true;
                enemy = new Boss(player);
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
                println("BOSS");
              } else {
                enemyExists = false;
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
              }
            }
          }
        }
      }
      if (keyCode == 83) {
        float value = m.getVal(player.getX(), player.getY()+move);

        boolean shouldMove = true;

        if (value < 0.25f && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
          shouldMove = false;
          if (m.getVal(player.getX(), player.getY()) == 0) {
            gameState.setGameState(GameState.DEAD);
          }
        }
        if (value < 0.25f && player.waterWalkingSteps > 0) {
          player.waterWalkingSteps-= 1;
        }

        if (value > 0.625f && player.passive.type != Passive.MOUNTAIN_WALKING) {
          shouldMove = false;
        }

        if (shouldMove) {
          player.setY(player.getY()+move);
          if (player.sneakSteps > 0) {
            player.sneakSteps--;
          } else {
            if (random(0, 1) < encounterPercentage) {
              if (player.level >= minLevelBossEncounter && random(0, 1) < bossEncounterPercentage) {
                enemyExists = true;
                enemy = new Boss(player);
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
                println("BOSS");
              } else {
                enemyExists = false;
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
              }
            }
          }
        }
      }
      if (keyCode == 68) {
        float value = m.getVal(player.getX()+move, player.getY());

        boolean shouldMove = true;

        if (value < 0.25f && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
          shouldMove = false;
          if (m.getVal(player.getX(), player.getY()) == 0) {
            gameState.setGameState(GameState.DEAD);
          }
        }
        if (value < 0.25f && player.waterWalkingSteps > 0) {
          player.waterWalkingSteps-= 1;
        }

        if (value > 0.625f && player.passive.type != Passive.MOUNTAIN_WALKING) {
          shouldMove = false;
        }

        if (shouldMove) {
          player.setX(player.getX()+move);
          if (player.sneakSteps > 0) {
            player.sneakSteps --;
          } else {
            if (random(0, 1) < encounterPercentage) {
              if (player.level >= minLevelBossEncounter && random(0, 1) < bossEncounterPercentage) {
                enemyExists = true;
                enemy = new Boss(player);
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
                println("BOSS");
              } else {
                enemyExists = false;
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
              }
            }
          }
        }
      }

      if (keyCode == 115) {
        createSave();
        dispSave = true;
      }
    }
  }
}

//FINALLY! IVE REACHED THE BOTTOM!
//THAT'S 1/13...
//please save me. I don't have time for this...
/*
@Author: Liam Gardner
@Date: 4/7/2019 or somewhere within a 2-3 day radius of that
@Purpose: "Imagine having an enemy that's so powerful it has two healthbars" -- every RPG gamedev ever.
Thankfully, every single method here has (or in my case will be) commented in the enemy class in which this inherents 
*/
class Boss extends Enemy {

  public Boss(Player player) {
    super(player);
    this.name = createName(10);
    this.name = name.substring(0, 1).toUpperCase() + name.substring(1);

    this.level = player.level + 5;
    this.health = 200;
    this.maxHealth = 200;

    this.isBoss = true;
  }

  @Override
    public void turn() {
    int val = floor(random(1, 5));
    if (val == 1) {
      health = skill1.heal(health, level, PApplet.parseInt(maxHealth));
      if (health == maxHealth) {
        text.add(new FadingText("Boss Taunted", width/2-300, height/2+200));
      } else {
        text.add(new FadingText("Boss Healed", width/2-300, height/2+200));
      }
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else if (val == 2) {
      damage = skill2.damageIncr(damage, level);
      text.add(new FadingText("Boss Increased Damage", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else if (val == 3) {
      player.setDamage(skill3.damageDecr(player.getDamage(), level));
      text.add(new FadingText("Your Damage Decreased", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else {
      if (this.health > this.maxHealth/2) {
        player.setHealth(player.getHealth()-damage);
        text.add(new FadingText("Boss Attacked", width/2-300, height/2+200));
        text.get(text.size()-1).setYOffset(5);
        text.get(text.size()-1).setTextSize(50);
      } else {
        if (random(5) < 2) {
          player.setHealth(player.getHealth()-(damage*2));
          text.add(new FadingText("Boss Raged", width/2-300, height/2+200));
          text.get(text.size()-1).setYOffset(5);
          text.get(text.size()-1).setTextSize(50);
        } else {
          player.setHealth(player.getHealth()-damage);
          text.add(new FadingText("Boss Attacked", width/2-300, height/2+200));
          text.get(text.size()-1).setYOffset(5);
          text.get(text.size()-1).setTextSize(50);
        }
      }
    }
  }

  public @Override
    void drawStats(int x, int y) {
    fill(255);
    text("Boss: " + name, width/2-100, y-25);
    textFont(map_font);
    text("Enemy Boss: ", x, y-25);
    int from0 = color(0, 100, 0);
    int to0 = color(0, 255, 0);
    int from1 = color(100, 0, 0);
    int to1 = color(255, 0, 0);

    int from2 = color(100, 0, 100);
    int to2 = color(255, 0, 255);

    if (health > 100) {
      noStroke();
      fill(to2);
      rect(x, y, 200, 30);
      if (health > 150) {
        int newColor = lerpColor(from0, to0, ((health-100)/100f));
        fill(newColor);
        noStroke();
        rect(x, y, (health-100)*2, 30);
      } else if (health < 150) {
        int newColor = lerpColor(from1, to1, ((health-100)/100f));
        fill(newColor);
        noStroke();
        rect(x, y, (health-100)*2, 30);
      }
    }else{
      noStroke();
      int newColor = lerpColor(from2,to2, health/100f);
      fill(newColor);
      rect(x,y,health*2,30);
    }

    fill(0, 255, 0);
    text("Boss Level: " + level, width/2-100, y);
    fill(255, 255, 255);
    textFont(map_font);
    textSize(35);
    text("Boss Damage: " + damage, width-500, 500);
  }
}
/*
@Author: Liam Gardner
@Date: Let's say around a week ago... so 3/31/2019
@Purpose: Let's turn this into a dialogue
  "Hey, I'm making a game, wanna draw some buttons for me?" - me
  "I'm kind of busy right now" - Lyndsay
  "Same" - The only other person I trust to draw (His name is Maurice and I've known him since gr. 1)
  "Looks like I'll program them myself then... :(" - me
  
Seriously though, The constructor's so big and I couldn't even fit everything I needed into it
*/
class Button {
  int x;
  int y;
  int w;
  int h;
  int s;
  CVector fillColor;
  CVector strokeColor;
  CVector textColor;
  CVector fillColorSelected;
  CVector strokeColorSelected;
  CVector textColorSelected;
  String str;
  int strSize;

  CVector fillColorPressed;
  CVector strokeColorPressed;
  CVector textColorPressed;

  Skill skill;

  int counter;

  int textX;
  int textY;

  CVector changeFillColor;
  CVector changeStrokeColor;
  CVector changeTextColor;
  float change;

  boolean allowChange;

  float xoff;

  boolean menuButton;

  boolean disabled;
  boolean itemButton;

  public Button(int x, int y, int w, int h, int s, int fillColor, int strokeColor, int fillColorSelected, int strokeColorSelected, int textColor, int textColorSelected, String text, int textSize, Skill skill) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.s = s;
    this.fillColor = new CVector(fillColor);
    this.strokeColor = new CVector(strokeColor);
    this.fillColorSelected = new CVector(fillColorSelected);
    this.strokeColorSelected = new CVector(strokeColorSelected);
    this.textColor = new CVector(textColor);
    this.textColorSelected = new CVector(textColorSelected);
    this.str = text;
    this.strSize = textSize;

    this.fillColorPressed = new CVector(fillColorSelected);
    this.strokeColorPressed = new CVector(strokeColorSelected);
    this.textColorPressed = new CVector(textColorSelected);

    this.skill = skill;
    counter = 50;

    this.textX = x + 5;
    this.textY = y + 25;

    this.changeFillColor = new CVector(fillColor);
    this.changeStrokeColor = new CVector(strokeColor);
    this.changeTextColor = new CVector(textColor);

    this.allowChange = false;
    this.xoff = 0;
    this.menuButton = false;
    this.itemButton = false;
  }

  /*
  add Pressed effect
  just in case you want to have your buttons look different when you press them
  technically, these all take integers because... processing?
  */
  public void addPressedEffect(int fillColorPressed, int strokeColorPressed, int textColorPressed) {
    this.fillColorPressed = new CVector(fillColorPressed);
    this.strokeColorPressed = new CVector(strokeColorPressed);
    this.textColorPressed = new CVector(textColorPressed);
  }

  /*
  This just sets the text position of the button. hence the "setTextPos"
  takes in integer coordinates
  those coordinates are sent into the depths of hell and nothing is returned. Just like the "integers" in the function/method above
  */
  public void setTextPos(int x, int y) {
    this.textX = x;
    this.textY = y;
  }

  /*
  this should've been split into a multitude of different methods.
  I cry everytime I travel to this section of my code. Seriously, it's 222 lines!
  this is like the buttons's personal draw() function and my second personal hell. 
  */
  public void show() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && !mousePressed) {
      if (allowChange) {
        if (fillColorSelected.equals(changeFillColor) && strokeColorSelected.equals(changeStrokeColor) && textColorSelected.equals(changeTextColor)) { 
          fill(fillColorSelected.asColor());
          stroke(strokeColorSelected.asColor());
          if (!str.contains(">>")) {
            str += ">";
          }
        } else {
          if (xoff > -24) {
            xoff-=0.5f;
          }

          if (xoff == -12) {
            str += ">";
          }

          changeFillColor.adjust(fillColorSelected, 10);

          changeStrokeColor.adjust(strokeColorSelected, 10);

          changeTextColor.adjust(textColorSelected, 10);

          fill(changeFillColor.asColor());
          stroke(changeStrokeColor.asColor());
        }
      } else {
        fill(fillColorSelected.asColor());
        stroke(strokeColorSelected.asColor());
      }
    } else if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed) {
      fill(fillColorPressed.asColor());
      stroke(strokeColorPressed.asColor());
    } else {
      fill(fillColor.asColor());
      stroke(strokeColor.asColor());
      this.changeFillColor = new CVector(this.fillColor.asColor());
      this.changeStrokeColor = new CVector(this.strokeColor.asColor());
      this.changeTextColor = new CVector(this.textColor.asColor());

      if (str.contains(">>")) {
        str = str.substring(0, str.length()-2);
        xoff = 0;
      }
    }
    strokeWeight(s);
    rect(x, y, w, h);

    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && !mousePressed) {
      if (allowChange) {
        if (textColorSelected.equals(changeTextColor)) {
          fill(textColorSelected.asColor());
        } else {
          fill(changeTextColor.asColor());
        }
      } else {

        fill(textColorSelected.asColor());
      }
      textSize(strSize);
      text(str, textX+xoff, textY);
    } else if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && counter >= 50 && menuButton == false) {
      fill(textColorPressed.asColor());
      textSize(strSize);
      text(str, textX+xoff, textY);
    } else {
      fill(textColor.asColor());
      textSize(strSize);
      text(str, textX+xoff, textY);
    }

    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && menuButton) {
      fill(textColorPressed.asColor());
      textSize(strSize);
      text(str, textX+xoff, textY);
    } else {
      fill(textColor.asColor());
      textSize(strSize);
      text(str, textX+xoff, textY);
    }

    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && counter >= 50 && menuButton == false && itemButton == false) {
      if (gameState.getGameState() == GameState.FIGHTING) {
        if (!str.equals("Attack")) {
          if (skill.getName().equals("Heal")) {
            player.setHealth(skill.heal(player.getHealth(), player.getLevel()));
            text.add(new FadingText("You Healed", width/2-300, height/2+100));
            text.get(text.size()-1).setYOffset(5);
            text.get(text.size()-1).setTextSize(50);
          } else if (skill.getName().equals("Atk+")) {
            player.setDamage(skill.damageIncr(player.getDamage(), player.getLevel()));
            text.add(new FadingText("You Increased Damage", width/2-300, height/2+100));
            text.get(text.size()-1).setYOffset(5);
            text.get(text.size()-1).setTextSize(50);
          } else if (skill.getName().equals("Atk-")) {
            enemy.setDamage(skill.damageDecr(enemy.getDamage(), player.getLevel()));
            text.add(new FadingText("Enemy Damage Decreased", width/2-300, height/2+100));
            text.get(text.size()-1).setYOffset(5);
            text.get(text.size()-1).setTextSize(50);
          }
        } else {
          enemy.setHealth(enemy.getHealth()-player.getDamage());
          text.add(new FadingText("You Attacked", width/2-300, height/2+100));
          text.get(text.size()-1).setYOffset(5);
          text.get(text.size()-1).setTextSize(50);
        }
        counter = 0;
        enemy.turn();
      }
    }
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && menuButton == true) {
      if (menuButton && gameState.getGameState() == GameState.MENU || gameState.getGameState() == GameState.LOADING) {
        if (str.contains("Play")) {
          gameState.setGameState(GameState.ROAMING);
          menuMusic.pause();
          menuMusic.stop();
          gameMusic[musicIndex].play();
        } else if (str.contains("Exit")) {
          System.exit(0);
        } else if (str.contains("Load")) {
          try {
            XML saveFile = loadXML("save.xml");

            for (XML x : saveFile.getChildren("world")) {
              for (XML c : x.getChildren("seed")) {
                seed = c.getIntContent();
                break;
              }
            }

            for (XML x : saveFile.getChildren("player")) {
              for (XML c : x.getChildren("coordinates")) {
                for (XML c1 : c.getChildren("x")) {
                  player.x = c1.getFloatContent();
                }
                for (XML c2 : c.getChildren("y")) {
                  player.y = c2.getFloatContent();
                }
              }
              for (XML c : x.getChildren("level")) {
                player.level = c.getIntContent();
              }
              for (XML c : x.getChildren("xp")) {
                player.xp = c.getFloatContent();
              }
              for (XML c : x.getChildren("health")) {
                player.health = c.getIntContent();
              }
              for (XML c : x.getChildren("passive")) {
                player.passive.type = c.getIntContent();
              }
              for (XML i : x.getChildren("inventory")){
                for (XML c : x.getChildren("sneak")){
                  player.items.put(0, c.getIntContent());
                }
                for (XML c : x.getChildren("kill")){
                  player.items.put(1, c.getIntContent());
                }
                for (XML c : x.getChildren("heal")){
                  player.items.put(2, c.getIntContent());
                }
                for (XML c : x.getChildren("weaken")){
                  player.items.put(3, c.getIntContent());
                }
                for (XML c : x.getChildren("water")){
                  player.items.put(4, c.getIntContent());
                }
                for (XML c : x.getChildren("pandora")){
                  player.items.put(5, c.getIntContent());
                }
              }
            }

            noiseSeed(seed);

            gameState.setGameState(GameState.ROAMING);
            menuMusic.stop();
            gameMusic[musicIndex].play();
          }
          catch (Exception e) {
            println("Could not load properly");
            gameState.setGameState(GameState.ROAMING);
            menuMusic.stop();
            gameMusic[musicIndex].play();
          }
        }
      }
    }
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && itemButton == true) {
      if (str.equals("Sneak")) {
        player.sneak.use();
        if (player.items.get(0) > 0) {
          player.items.put(0, player.items.get(0)-1);
        }
      } else if (str.equals("Kill")) {
        player.kill.use();
        if (player.items.get(1) > 0) {
          player.items.put(1, player.items.get(1)-1);
        }
      } else if (str.equals("Heal")) {
        player.heal.use();
        if (player.items.get(2) > 0) {
          player.items.put(2, player.items.get(2)-1);
        }
      } else if ( str.equals("Weaken")) {
        player.weaken.use();
        if (player.items.get(3) > 0) {
          player.items.put(3, player.items.get(3)-1);
        }
      } else if (str.equals("Water")) {
        player.water.use();
        if (player.items.get(4) > 0) {
          player.items.put(4, player.items.get(4)-1);
        }
      } else if (str.equals("Pandora")) {
        player.pandora.use();
        if (player.items.get(5) > 0) {
          player.items.put(5, player.items.get(5)-1);
        }
      }
    }
  }
}
/*
@Author: Liam Gardner
 @Date: Let's say around a week ago... 31/3/2019
 @Purpose: So Processing has this thing called PVector. PVector can hold 1D coordinates, 2D coordinates and 3D coordinates.
 These coordinates are x,y, and z.
 I don't like that.
 Here's a CVector class for a 3D vector for R,G,B because variable names.
 */

class CVector {

  int r;
  int g;
  int b;

  public CVector(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  public CVector(int x) {
    this.r = (x>>16)&0xFF;
    this.g = (x>>8)&0xFF;
    this.b = (x>>0)&0xFF;
  }

  /*
  .equals() practicality
   could've probably just converted it to an int and done it that way, but to late now (and by too late I mean I'm not gonna put the effort in)
   it takes in another one of its kind and returns a PASS/FAIL test score on similarity.
   */
  public boolean equals(CVector b) {
    return this.r == b.r && this.g == b.g && this.b == b.b;
  }
  /*
  I wanted to print it. Also printing is just println() in processing! So much easier! and you can comma separate in print statements!
   anyways, this toString() converts it to a string.
   */
  public String toString() {
    return "[" + r + " " + g + " " + b + "]";
  }
  /*
  returns an int called color.
   it's meant to represent the vector "as color" -- heh, see what I did there? It's like 23:00 and I'm tired! It's not my fault I  make bad jokes!
   */
  public int asColor() {
    return color(this.r, this.g, this.b);
  }
  /*
  So you know how when you're a kid, how there's always that one person that you really want to be like?
   This function basically shows a kid learning to become closer and closer to that one person he really wants to be like.
   except as kids don't exist in programming (human at least). It's been done with vectors.
   It just takes small steps. It 'adjusts' itself -- I did it again!
   */
  public void adjust(CVector toEmulate) {
    if (this.r > toEmulate.r) {
      this.r --;
    } else if (this.r < toEmulate.r) {
      this.r++;
    }

    if (this.g > toEmulate.g) {
      this.g --;
    } else if (this.g < toEmulate.g) {
      this.g++;
    }

    if (this.b > toEmulate.b) {
      this.b --;
    } else if (this.b < toEmulate.b) {
      this.b++;
    }
  }
  /*
  I needed it done in a for loop
   */
  public void adjust(CVector toEmulate, int loop) {
    for (int i = 0; i < loop; i++) {
      if (this.r > toEmulate.r) {
        this.r --;
      } else if (this.r < toEmulate.r) {
        this.r++;
      }

      if (this.g > toEmulate.g) {
        this.g --;
      } else if (this.g < toEmulate.g) {
        this.g++;
      }

      if (this.b > toEmulate.b) {
        this.b --;
      } else if (this.b < toEmulate.b) {
        this.b++;
      }
    }
  }
}
//I'M SO CLOSE TO BEING ABLE TO SLEEP!
//SOMEONE SAVE ME FROM THIS ACURSED HELL!
/* Author: Samuel Bates
 * Date: 2-27-2019
 * Purpose: To have a class used entirely for skills of the enemy and player
 
 Okay so I am REALLY tired right now. I've had like 3 cups of coffee and it has done nothing.
 Sorry Sam. I edited your enemy class. Like A Lot. We didn't really need accessors and mutators, did we? Good Job though!
 */

public class Enemy {


  String name;
  int health;
  float xp;
  int damage;
  int level;
  float maxHealth;

  Skill skill1 = new Skill();
  Skill skill2 = new Skill();
  Skill skill3 = new Skill();
  
  boolean isBoss;

  public Enemy(Player player) {
    name = createName(round(random(3, 5)));
    name = name.substring(0, 1).toUpperCase() + name.substring(1);
    if (random(0,1) < 0.25f){
      name += "n";
    }
    isBoss = false;

    if (player.level < 3) {
      level = 1;
    } else if (player.level < 5) {
      level = floor(random(1, 3));
    } else if (player.level < 10) {
      level = floor(random(1, 10));
    } else {
      level = abs(round(random(player.getLevel()-3, player.getLevel()+3)));
    }
    if (level < 2) {
      health = 25;
      maxHealth = 25;
    } else if (level < 3) {
      health = 50;
      maxHealth = 50;
    } else if (level < 5) {
      health = 75;
      maxHealth = 75;
    } else {
      health = 100;
      maxHealth = 100;
    }

    xp = 10 * level;

    skill1.setName("Heal");
    skill2.setName("Atk+");
    skill3.setName("Atk-");

    damage = 1;
  }

  //Okay so since we didn't really need accessors and mutators I'm leaving them uncommented.
  //Also this isn't -- or shouldn't be -- my code to comment, so... whatever?

  public int getLevel() {
    return level;
  }

  public void setLevel(int newLevel) {
    level = newLevel;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getHealth() {
    return health;
  }

  public void setHealth(int health) {
    this.health = health;
  }

  public int getDamage() {
    return damage;
  }

  public void setDamage(int damage) {
    this.damage = damage;
  }

  public Skill getSkill1() {
    return skill1;
  }

  public void setSkill1(Skill skill1) {
    this.skill1 = skill1;
  }

  public Skill getSkill2() {
    return skill2;
  }

  public void setSkill2(Skill skill2) {
    this.skill2 = skill2;
  }

  public Skill getSkill3() {
    return skill3;
  }

  public void setSkill3(Skill skill3) {
    this.skill3 = skill3;
  }


  /*
  Now This. This is *my* code.
  When you fight someone in real life. you know how all the sudden, this green bar appears over their head and slowly turns red and shrinks when they get hit? no? just me? well it's here now too!
  Along with that, you can see the enemy level and name!
  all for the price of two integer coordinates for drawing reference.
  Your coordinates are consumed by the 'voids' of hell and are never returned! mwahahahahhah!  
  */
  public void drawStats(int x, int y) {
    fill(255);
    text("Enemy: " + name, width/2-100, y-25);
    textFont(map_font);
    text("Enemy Health: ", x, y-25);
    if (enemy.getHealth() > enemy.maxHealth/2) {
      int from = color(0, 100, 0);
      int to = color(0, 255, 0);
      int newCol = lerpColor(from, to, (enemy.getHealth()/enemy.maxHealth));
      fill(newCol);
    } else {
      int from = color(100, 0, 0);
      int to = color(255, 0, 0);
      int newCol = lerpColor(from, to, (enemy.getHealth()/enemy.maxHealth));
      fill(newCol);
    }
    noStroke();
    rect(x, y, enemy.getHealth()*2, 30);
    fill(0, 255, 0);
    text("Enemy Level: " + level, width/2-100, y);
    fill(255, 255, 255);
    textFont(map_font);
    textSize(35);
    text("Enemy Damage: " + damage, width-500, 500);
  }

  /*
  so as per standard combat, you can only hit someone once before they hit you back. Wait... I'm being told that's just me again. I should get into fights more often!
  This method allows the enemy to take it's turn deciding what to do and acting upon it's decision. ITS AN AI!!!
  takes nothing and returns nothing.
  */
  public void turn() {
    int val = floor(random(1, 5));
    if (val == 1) {
      health = skill1.heal(health, level, PApplet.parseInt(maxHealth));
      if (health == maxHealth) {
        text.add(new FadingText("Enemy Taunted", width/2-300, height/2+200));
      } else {
        text.add(new FadingText("Enemy Healed", width/2-300, height/2+200));
      }
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else if (val == 2) {
      damage = skill2.damageIncr(damage, level);
      text.add(new FadingText("Enemy Increased Damage", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else if (val == 3) {
      player.setDamage(skill3.damageDecr(player.getDamage(), level));
      text.add(new FadingText("Your Damage Decreased", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else {
      player.setHealth(player.getHealth()-damage);
      text.add(new FadingText("Enemy Attacked", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    }
  }
}
/*
@Author: Liam Gardner
@Date: 31/3/2019 probably.
@Purpose: CSS doesn't work with java? Guess I'll have to do everything myself :(
*/
class FadingText {
  int x;
  int y;
  String text;
  int c;
  
  int textSize;
  int yOff;
  public FadingText(String text, int x, int y) {
    this.x = x;
    this.y = y;
    this.text = text;
    this.c = 255;
    this.textSize = 30;
    this.yOff = 2;
  }
  
  /*
  Changes how fast it goes up
  Takes an integer for some reason. I should make that a float. I'll do it later
  returns nothing
  */
  public void setYOffset(int yoff){
    yOff = yoff;
  }
  
  /*
  sets the text size.
  I'm still not sure why I used integers for these. meh, can't be that bad can it?
  returns nothing
  */
  public void setTextSize(int size){
    textSize = size;
  }

  /*
  Updating is like going through life. Actually, this class is like going through life. You're born into this world bright and slowly fade into nothingness while your innocents and purity blackens into disgust.
  That might also be me again... I'm fairly certain it's at least relatable to a few people.
  + there's also the ascension part of it if you're religious. You know, going up to heaven to meet god or whatever.
  
  It takes nothing and it gives nothing... just like life? no? that one doesn't work? alright then... I'm gonna go cry in gameState now.
  */
  public void update() {
    c -= 3;
    fill(c);
    textSize(textSize);
    text(text, x, y);
    y -= yOff;
  }
}
/* Author: Samuel Bates
 * Date: 3-31-2019
 * Purpose: To have a class used entirely for skills of the enemy and player
 
 
 Hmmm. Something seems familiar about this. I can't seem to put my finger on it though.
 OH! Maybe I should've actually put draw in here. or at least segments of it! That would've been smart!
 Good job on this btw. It looks great!
 */
public class GameState {
  public static final int MENU = 0;
  public static final int ROAMING = 1;
  public static final int FIGHTING = 2;
  public static final int DEAD = 3;
  public static final int LEVELUP = 4;
  public static final int LOADING = 5;

  int state;

  public GameState() {
    state = GameState.LOADING;
  }
  public int getGameState() {
    return state;
  }
  public void setGameState(int newGameState) {
    state = newGameState;
  }
  public void changeState() {
    state++;
  }
}
/*
@Author: Liam Gardner
@Date: today, so that would be... 9/7/2019!
@Purpose: So Maurice told me to add items, well, here's a terribly implemented item class!
*/

class Item {
  public static final int SNEAK = 0;
  public static final int KILL = 1;
  public static final int HEAL = 2;
  public static final int WEAKEN = 3;
  public static final int WATER = 4;
  public static final int PANDORA = 5;

  public static final int ITEMS = 6;
  public static final int MAXITEMID = 5;

  String name;
  int id;

  public Item (String name, int id) {
    this.name = name;
    this.id = id;
  }
  /*
  So you know how whenever you touch an object in the real world it disappears? like a sandwich, or a soul, or someone's innocence? No? why am I so alone...
  Okay, so apparently things don't disappear when you use them, so they don't disappear in this method either! this method just 'helps' the player when they use an item
  */
  public void use() {
    if (id == SNEAK) {
      player.sneakSteps = 500;
    }
    if (id == KILL) {
      if (!enemy.isBoss) {
        enemy.health = 1;
      }
    }
    if (id == HEAL) {
      player.health += 25;
      if (player.health > 100) {
        player.health = 100;
      }
    }
    if (id == WEAKEN) {
      if (!enemy.isBoss) {
        enemy.health/=2;
        enemy.level -= 1;
      }
    }
    if (id == WATER) {
      player.waterWalkingSteps = 250;
    }
    if (id == PANDORA) {
      if (random(0, 1) < 0.5f) {
        player.damage += 20;
      } else {
        enemy.health = 200;
        enemy.maxHealth = 200;
        enemy.isBoss = true;
      }
    }
  }
}
/*
@Author: Liam Gardner
@Date: Hmmm.....March 26, 2019! Maybe!
@Purpose: Did you know there's this really cool thing called perlin noise? that's been updated like 60 times by the author?
          Well guess which version processing uses? It's the original!
          I spent countless years turning that original noise algorithm into a class and here's my final result!
*/

class Map {

  public Map() {
    
  }
  /*
  returns a character based on FLOATING POINT COORDINATES!!! --> noise works by a very small step value
  */
  public char get(float x, float y) {
    float val = noise(x, y);
    if (val < 0.25f) {
      return ',';
    } else if (val < 0.3f) {
      return'$';
    } else if (val < 0.4f) {
      return '~';
    } else  if (val < 0.5f){
      return '#';
    }else if (val < 0.675f){
      return '.';
    }else {
      return '"';
    }
  }
  
  /*
  this is literally just the noise function... I'm not even sure why I did this...
  Okay, so it takes two floats and returns a float... like perlin noise.....
  */
  public float getVal(float x, float y){
    return noise(x,y);
  }
  /*
  this takes in two floats and returns an 'integer' based off it's noise value
  */
  public int getC(float x, float y) {
    float val = noise(x, y);
    if (val < 0.15f) {
      return color(0, 0, 150);
    } else if (val < 0.2f) {
      return color(0, 0, 200);
    } else if (val < 0.25f) {
      return color(0, 100, 255);
    } else if (val < 0.3f) {
      return color(255, 243, 0);
    } else if (val < 0.4f) {
      return color(0, 200, 0);
    } else if (val < 0.5f){
      return color(0, 255, 0);
    }else if (val < 0.6f){
      return color(100,100,100);
    }else if (val < 0.625f){
      return color(150,150,150);
    }else if (val < 0.65f){
      return color(175,175,175);
    }else if (val < 0.675f){
      return color(200,200,200);
    }else{
      return color(255,255,255);
    }
  }
}


/*
@Author: Liam Gardner
@Date: 31/3/2019
@Purpose: What makes or breaks a game? MUSIC!

Okay so peter just told me that I didn't have to comment anything.... it's like 23:30 or something and I'm so tired and unmotivated to finish this yet I can't sleep bc of coffee and need to finish this
Someone save me from my 3rd self condemned hell.

Oh also every function in here is just calling the music file function... that can be found here: https://processing.org/reference/libraries/sound/SoundFile.html
*/

class Music {
  SoundFile file;
  String filename;
  PApplet container;
  public Music(String filename, PApplet container) {
    this.container = container;
    this.filename = filename;
    this.file = new SoundFile(container, filename);

    this.file.loop();
    this.file.stop();
  }

  public Music(String filename, PApplet container, boolean loop) {
    this.container = container;
    this.filename = filename;
    this.file = new SoundFile(container, filename);
    if (loop) {
      this.file.loop();
    }
    this.file.stop();
  }

  public void play() {
    if (!mute) {
      this.file.play();
    }
  }

  public void stop() {
    this.file.stop();
  }

  public void pause() {
    this.file.pause();
  }

  public boolean isPlaying() {
    return this.file.isPlaying();
  }
}
/*
@Author: Liam Gardner
@Date: 31/3/2019
@Purpose: well it's called passive, I guess it's telling me to be a pacifist? probably not, it's probably saying 'just be passively violent' right?
I basically used this to name integers.
*/
class Passive {
  public static final int RETAIN_DAMAGE = 0;
  public static final int WATER_WALKING = 1;
  public static final int MOUNTAIN_WALKING = 2;

  int type;
  public Passive(int type) {
    this.type = type;
  }
}
/* Author: Samuel Bates
* Date: 2-27-2019
* Purpose: To have a class used entirely for skills of the enemy and player

Boy was this a handful to work with. Is handful the right expression to use here? I'm not sure...
All I did here was make things floats and add a hashmap for items... It's not my place to do the work of others (Unless I can get paid for it. but what are the chances of that...)
Looks good though, good job!
*/

public class Player {

  String name;
  int health;
  float xp;
  int damage;
  int level;
  float x;
  float y;
  Skill skill1;
  Skill skill2;
  Skill skill3;

  Item sneak = new Item("Sneak", 0);
  Item kill = new Item("Kill", 1);
  Item heal = new Item("Heal", 2);
  Item weaken = new Item("Weaken", 3);
  Item water = new Item("Water", 4);
  Item pandora = new Item("Pandora", 5);
  
  Passive passive;
  int waterWalkingSteps = 0;
  
  int sneakSteps;
  
  HashMap<Integer, Integer> items;
  
  public Player() {
    skill1 = new Skill();
    skill2 = new Skill();
    skill3 = new Skill();
    skill1.setName("Heal");
    skill2.setName("Atk+");
    skill3.setName("Atk-");
    damage = 1;
    passive = new Passive(floor(random(0,3)));
    
    sneakSteps = 0;
    waterWalkingSteps = 0;
    
    items = new HashMap<Integer, Integer>();
    for (int i = 0; i < Item.ITEMS; i++){
      items.put(i,0);
    }
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getHealth() {
    return health;
  }

  public void setHealth(int health) {
    this.health = health;
  }

  public int getDamage() {
    return damage;
  }

  public void setDamage(int damage) {
    this.damage = damage;
  }

  public float getX() {
    return x;
  }

  public void setX(float x) {
    this.x = x;
  }

  public float getY() {
    return y;
  }

  public void setY(float y) {
    this.y = y;
  }

  public Skill getSkill1() {
    return skill1;
  }

  public void setSkill1(Skill skill1) {
    this.skill1 = skill1;
  }

  public Skill getSkill2() {
    return skill2;
  }

  public void setSkill2(Skill skill2) {
    this.skill2 = skill2;
  }

  public Skill getSkill3() {
    return skill3;
  }

  public void setSkill3(Skill skill3) {
    this.skill3 = skill3;
  }
  
  public float getXP(){
    return this.xp;
  }
  
  public int getLevel(){
    return this.level;
  }
}
/* Author: Samuel Bates
 * Date: 2-27-2019
 * Purpose: To have a class used entirely for skills of the enemy and player
 
 This is a different kind of "leave me out of this"
 */

public class Skill {
  String name;
  public Skill() {
    this.name = "";
  }
  
  public void setName(String name){
    this.name = name;
  }
  
  public String getName(){
    return this.name;
  }
  
  public int heal(int curhealth, int level) {
    int newhealth = 0;
    if(curhealth == 100) {
      newhealth = curhealth;
    }
    if(level == 0) {
      newhealth = curhealth + 1;
    }
    else if(level == 100) {
      newhealth = 100;
    }
    else if(level >= 1 && level <= 10) {
      newhealth = curhealth + 1 * level;
    }
    else if(level >= 11 && level <= 50) {
      newhealth = curhealth + 1 * level;
    }
    else if(level >= 51 && level <= 100) {
      newhealth = curhealth + 1 * level;
    }
    if(newhealth >= 100) {
      newhealth = 100;
    }
    return newhealth;
  }
  
  public int heal(int curhealth, int level, int maxHealth) {
    int newhealth = 0;
    if(curhealth == 100) {
      newhealth = curhealth;
    }
    if(level == 0) {
      newhealth = curhealth + 1;
    }
    else if(level == 100) {
      newhealth = 100;
    }
    else if(level >= 1 && level <= 10) {
      newhealth = curhealth + 1 * level;
    }
    else if(level >= 11 && level <= 50) {
      newhealth = curhealth + 1 * level;
    }
    else if(level >= 51 && level <= 100) {
      newhealth = curhealth + 1 * level;
    }
    if(newhealth >= maxHealth) {
      newhealth = maxHealth;
    }
    return newhealth;
  }
  public int damageDecr(int curattack, int level) {
    int newattack = 0;
    if(level == 0) {
      newattack = curattack - 1;
    }
    else if(level >= 1 && level <= 10) {
      newattack = curattack - 1 * level;
    }
    else if(level >= 11 && level <= 50) {
      newattack = curattack - 1 * level;
    }
    else if(level >= 51 && level <= 100) {
      newattack = curattack - 1 * level;
    }
    else if(level > 100) {
      newattack = curattack - 1 * level;
    }
    if(newattack < 1) {
      newattack = 1;
    }
    return newattack;
  }
  public int damageIncr(int curattack, int level) {
    int newattack = 0;
    if(level == 0) {
      newattack = curattack + 1; 
    }
    else if(level == 100) {
      newattack = 100;
    }
    else if(level >= 1 && level <= 10) {
      newattack = curattack + 1 * level;
    }
    else if(level >= 11 && level <= 50) {
      newattack = curattack + 1 * level;
    }
    else if(level >= 51 && level <= 100) {
      newattack = curattack + 1 * level;
    }
    else if(level > 100) {
      newattack = curattack + 1 * level;
    }
    return newattack;
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "ICS4U_ASCII_RPG" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
